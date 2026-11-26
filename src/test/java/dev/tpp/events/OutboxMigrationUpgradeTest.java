package dev.tpp;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import dev.tpp.events.EventCodec;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import org.flywaydb.core.Flyway;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Timeout;
import org.testcontainers.postgresql.PostgreSQLContainer;

/** Tests an actual populated Phase 1 upgrade rather than only a fresh database. */
class OutboxMigrationUpgradeTest {
  @BeforeAll
  @Timeout(value = 5, unit = TimeUnit.MINUTES)
  static void preparePostgresImage() {
    // Pulling pinned bases and compiling the server image is a fixture setup cost.
    TestImages.postgres();
  }

  @Test
  @Timeout(60)
  void phase1HistoryIsBackfilledOnceWithoutChangingLedgerBalancesOrDurableIdempotency()
      throws Exception {
    try (var postgres = new PostgreSQLContainer(TestImages.postgres()).withImagePullPolicy(image -> false)
        .withDatabaseName("upgrade_tests").withUsername("tpp").withPassword("tpp")) {
      postgres.start();
      try (var db = new PgTestSupport(postgres.getJdbcUrl(), postgres.getUsername(), postgres.getPassword())) {
        Flyway phase1 = Flyway.configure().dataSource(db.url, "tpp", "tpp").target("1").load();
        assertThat(phase1.migrate().migrationsExecuted).isEqualTo(1);
        assertThat(db.scalar("SELECT count(*) FROM information_schema.tables WHERE table_name='outbox_events'"))
            .isZero();
        UUID issuance = UUID.randomUUID();
        UUID source = UUID.randomUUID();
        UUID destination = UUID.randomUUID();
        UUID funding = UUID.randomUUID();
        UUID historicalTransfer = UUID.randomUUID();
        UUID rejected = UUID.randomUUID();
        String historicalKey = "historical-" + historicalTransfer;
        try (Connection connection = db.connect()) {
          connection.setAutoCommit(false);
          for (UUID id : List.of(issuance, source, destination)) {
            execute(connection, "INSERT INTO accounts(id,kind,status,unit) VALUES (?,?,'ACTIVE','FIC')",
                id, id.equals(issuance) ? "ISSUANCE" : "USER");
            execute(connection, "INSERT INTO balances(account_id,amount) VALUES (?,0)", id);
          }
          completeHistorical(connection, funding, "funding-" + funding, issuance, source, 1000);
          completeHistorical(connection, historicalTransfer, historicalKey, source, destination, 125);
          execute(connection, "INSERT INTO transfers(id,idempotency_key,source_account_id,destination_account_id,amount,unit,status) VALUES (?,?,?,?,9000,'FIC','PROCESSING')",
              rejected, "rejected-" + rejected, source, destination);
          execute(connection, "UPDATE transfers SET status='REJECTED',rejection_code='INSUFFICIENT_FUNDS',completed_at=clock_timestamp() WHERE id=?", rejected);
          connection.commit();
        }
        String ledgerBefore = snapshot(db, "ledger_entries");
        String balancesBefore = snapshot(db, "balances");
        String transfersBefore = snapshot(db, "transfers");
        String accountsBefore = snapshot(db, "accounts");

        Flyway upgraded = Flyway.configure().dataSource(db.url, "tpp", "tpp").load();
        assertThat(upgraded.migrate().migrationsExecuted).isEqualTo(3);
        upgraded.validate();
        assertThat(db.scalar("SELECT count(*) FROM pg_indexes WHERE schemaname='public' AND tablename='transfers' AND indexname='transfers_terminal_pair_decided_idx'"))
            .isEqualTo(1);
        assertThat(db.scalar("SELECT count(*) FROM outbox_events")).isEqualTo(2);
        assertThat(db.scalar("SELECT count(*) FROM outbox_events WHERE transfer_id=?", rejected)).isZero();
        assertThat(db.scalar("SELECT count(*) FROM transfers t JOIN outbox_events o ON o.transfer_id=t.id WHERE t.status='COMPLETED' AND o.created_at=t.completed_at AND o.status='PENDING' AND o.attempt_count=0 AND o.payload->>'correlationId'='migration-backfill'"))
            .isEqualTo(2);
        EventCodec codec = new EventCodec();
        for (UUID transfer : List.of(funding, historicalTransfer)) {
          String payload = text(db, "SELECT payload::text FROM outbox_events WHERE transfer_id=?", transfer);
          var event = codec.decode(payload);
          assertThat(event.transferId()).isEqualTo(transfer);
          assertThat(event.eventId().toString()).isEqualTo(text(db, "SELECT event_id::text FROM outbox_events WHERE transfer_id=?", transfer));
          assertThat(event.amountMinor()).isEqualTo(transfer.equals(funding) ? 1000 : 125);
          assertThat(event.sourceAccountId()).isEqualTo(transfer.equals(funding) ? issuance : source);
          assertThat(event.destinationAccountId()).isEqualTo(transfer.equals(funding) ? source : destination);
          assertThat(event.schemaVersion()).isEqualTo(1);
        }
        String outboxAfterUpgrade = snapshot(db, "outbox_events");
        assertThat(upgraded.migrate().migrationsExecuted).isZero();
        assertThat(snapshot(db, "outbox_events")).isEqualTo(outboxAfterUpgrade);
        assertThat(snapshot(db, "ledger_entries")).isEqualTo(ledgerBefore);
        assertThat(snapshot(db, "balances")).isEqualTo(balancesBefore);
        assertThat(snapshot(db, "transfers")).isEqualTo(transfersBefore);
        assertThat(snapshot(db, "accounts")).isEqualTo(accountsBefore);
        assertThatThrownBy(() -> db.execute("UPDATE outbox_events SET payload=jsonb_set(payload,'{amountMinor}','126') WHERE transfer_id=?", historicalTransfer))
            .isInstanceOf(SQLException.class);
        assertThatThrownBy(() -> db.execute("UPDATE outbox_events SET event_id=? WHERE transfer_id=?", UUID.randomUUID(), historicalTransfer))
            .isInstanceOf(SQLException.class);
        var app = db.start(TppApplication.class, Map.of("tpp.events.relay-enabled", false, "tpp.events.consumer-enabled", false));
        var replay = db.post(app, "/api/transfers", PgTestSupport.transfer(source, destination, 125), historicalKey);
        assertThat(replay.status()).isEqualTo(200);
        assertThat(replay.id()).isEqualTo(historicalTransfer);
        assertThat(db.scalar("SELECT count(*) FROM outbox_events")).isEqualTo(2);
        assertThat(snapshot(db, "outbox_events")).isEqualTo(outboxAfterUpgrade);
        assertThat(snapshot(db, "ledger_entries")).isEqualTo(ledgerBefore);
        assertThat(snapshot(db, "balances")).isEqualTo(balancesBefore);
        assertThat(db.get(app, "/internal/reconciliation").<Boolean>json("$.consistent")).isTrue();
        assertThat(db.scalar("SELECT count(*) FROM event_inbox")).isZero();
        assertThat(db.scalar("SELECT count(*) FROM transfer_activity_projection")).isZero();
      }
    }
  }

  private static void completeHistorical(Connection connection, UUID transfer, String key,
      UUID source, UUID destination, long amount) throws Exception {
    execute(connection, "INSERT INTO transfers(id,idempotency_key,source_account_id,destination_account_id,amount,unit,status) VALUES (?,?,?,?,?,'FIC','PROCESSING')",
        transfer, key, source, destination, amount);
    execute(connection, "UPDATE balances SET amount=amount-? WHERE account_id=?", amount, source);
    execute(connection, "UPDATE balances SET amount=amount+? WHERE account_id=?", amount, destination);
    execute(connection, "INSERT INTO ledger_entries(transfer_id,account_id,delta) VALUES (?,?,?),(?,?,?)",
        transfer, source, -amount, transfer, destination, amount);
    execute(connection, "UPDATE transfers SET status='COMPLETED',completed_at=clock_timestamp() WHERE id=?", transfer);
  }

  private static void execute(Connection connection, String sql, Object... values) throws Exception {
    try (PreparedStatement statement = connection.prepareStatement(sql)) {
      PgTestSupport.bind(statement, values);
      statement.executeUpdate();
    }
  }

  private static String snapshot(PgTestSupport db, String table) throws Exception {
    // Table names are fixed constants in this test; JSONB preserves every historical column.
    return text(db, "SELECT jsonb_agg(to_jsonb(row_data) ORDER BY to_jsonb(row_data)::text)::text FROM " + table + " row_data");
  }

  private static String text(PgTestSupport db, String sql, Object... values) throws Exception {
    try (Connection connection = db.connect(); PreparedStatement statement = connection.prepareStatement(sql)) {
      PgTestSupport.bind(statement, values);
      try (var rows = statement.executeQuery()) {
        if (!rows.next()) throw new AssertionError("Query returned no row");
        return rows.getString(1);
      }
    }
  }
}
