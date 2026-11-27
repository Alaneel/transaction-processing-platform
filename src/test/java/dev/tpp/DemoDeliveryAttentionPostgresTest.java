package dev.tpp;

import static org.assertj.core.api.Assertions.assertThat;

import dev.tpp.events.consumer.EventProcessor;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.junit.jupiter.api.Timeout;
import org.testcontainers.postgresql.PostgreSQLContainer;

/** Real PostgreSQL/HTTP attention reads. Publication-row fixtures are not Kafka transport evidence. */
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class DemoDeliveryAttentionPostgresTest {
  private static final UUID ISSUANCE = id("00000000", 1);
  private static final UUID ALICE = id("00000000", 2);
  private static final UUID BOB = id("00000000", 3);
  private static final UUID CAROL = id("00000000", 4);
  private static final Instant BASE = Instant.parse("2026-01-02T03:04:05.123456Z");
  private PostgreSQLContainer postgres;
  private String adminUrl;
  private String username;
  private String password;
  private PgTestSupport db;
  private PgTestSupport.Application app;
  private long offset;

  @BeforeAll
  @Timeout(value = 5, unit = TimeUnit.MINUTES)
  void startOwnedRealPostgres() {
    adminUrl = System.getenv("TPP_TEST_DB_URL");
    if (adminUrl == null || adminUrl.isBlank()) {
      postgres =
          new PostgreSQLContainer(TestImages.postgres()).withImagePullPolicy(image -> false)
              .withDatabaseName("attention_tests")
              .withUsername("tpp")
              .withPassword("tpp");
      postgres.start();
      adminUrl = postgres.getJdbcUrl();
      username = postgres.getUsername();
      password = postgres.getPassword();
    } else {
      username = System.getenv().getOrDefault("TPP_TEST_DB_USER", "tpp");
      password = System.getenv().getOrDefault("TPP_TEST_DB_PASSWORD", "tpp");
    }
  }

  @BeforeEach
  void freshScenarioDatabaseAndFundedDemoAccounts() throws Exception {
    db = new PgTestSupport(adminUrl, username, password);
    app = db.start(TppApplication.class,
        Map.of("tpp.events.relay-enabled", false, "tpp.events.consumer-enabled", false));
    offset = 0;
    try (Connection connection = db.connect()) {
      connection.setAutoCommit(false);
      for (UUID account : List.of(ISSUANCE, ALICE, BOB, CAROL)) {
        execute(connection, "INSERT INTO accounts(id,kind,created_at) VALUES (?,?,?)",
            account, account.equals(ISSUANCE) ? "ISSUANCE" : "USER",
            Timestamp.from(BASE.minusSeconds(300)));
        execute(connection, "INSERT INTO balances(account_id,amount) VALUES (?,0)", account);
      }
      int index = 0;
      for (UUID account : List.of(ALICE, BOB, CAROL))
        terminal(connection, id("10000000", ++index), ISSUANCE, account, 1000,
            "COMPLETED", BASE.minusSeconds(100));
      connection.commit();
    }
  }

  @AfterEach
  void closeApplicationsAndDropOnlyScenarioDatabase() throws Exception {
    if (db != null) db.close();
  }

  @AfterAll
  void stopOnlySuiteOwnedContainer() {
    if (postgres != null) postgres.stop();
  }

  @Test
  @Timeout(45)
  void severityOrderPreservesPublicationUncertaintyAndFlagsStructuralInconsistency()
      throws Exception {
    var pending = completed(1, 40);
    retry(pending);
    var claimed = completed(2, 20);
    claim(claimed);
    var blocked = completed(3, 70);
    blocked(blocked);
    var projectedBlocked = completed(4, 10);
    blocked(projectedBlocked);
    project(projectedBlocked);
    var projectedPending = completed(5, 60);
    project(projectedPending);
    var projectedClaimed = completed(6, 15);
    claim(projectedClaimed);
    project(projectedClaimed);
    var published = completed(7, 5);
    published(published);
    var settled = completed(8, 90);
    published(settled);
    project(settled);
    create(id("20000000", 9), ALICE, BOB, 2000, "REJECTED", BASE.plusSeconds(95));
    create(id("30000000", 1), ALICE, CAROL, 7, "COMPLETED", BASE.plusSeconds(100));
    var pendingTie = completed(11, 40);
    var missingEvent = completed(12, 80);
    removeUnprojectedEventAsOwner(missingEvent);
    var brokenBlocked = completed(13, 30);
    blocked(brokenBlocked);
    project(brokenBlocked);
    removeProjectionAsOwner(brokenBlocked);

    String unchanged = durableSnapshot();
    var response = attention();
    assertThat(response.<Number>json("$.sampleLimit").intValue()).isEqualTo(50);
    // The settled transfer is sampled but does not require attention; rejected/outside rows are not sampled.
    assertThat(response.<Number>json("$.sampledCount").intValue()).isEqualTo(11);
    List<Map<String, Object>> items = response.json("$.items");
    assertThat(items.stream().map(item -> item.get("transferId")).toList())
        .containsExactly(
            brokenBlocked.transferId().toString(), missingEvent.transferId().toString(),
            projectedBlocked.transferId().toString(), blocked.transferId().toString(),
            projectedClaimed.transferId().toString(), projectedPending.transferId().toString(),
            claimed.transferId().toString(), pending.transferId().toString(),
            pendingTie.transferId().toString(), published.transferId().toString());
    assertItem(items.get(0), brokenBlocked, "INCONSISTENT", "BLOCKED", 1, "TOPIC_REJECTED");
    assertItem(items.get(1), missingEvent, "INCONSISTENT", null, null, null);
    assertItem(items.get(2), projectedBlocked, "BLOCKED", "BLOCKED", 1, "TOPIC_REJECTED");
    assertItem(items.get(3), blocked, "BLOCKED", "BLOCKED", 1, "TOPIC_REJECTED");
    assertItem(items.get(4), projectedClaimed, "PUBLICATION_UNCONFIRMED", "CLAIMED", 1, null);
    assertItem(items.get(5), projectedPending, "PUBLICATION_UNCONFIRMED", "PENDING", 0, null);
    assertItem(items.get(6), claimed, "AWAITING_PUBLICATION", "CLAIMED", 1, null);
    assertItem(items.get(7), pending, "AWAITING_PUBLICATION", "PENDING", 1, "KAFKA_UNAVAILABLE");
    assertItem(items.get(8), pendingTie, "AWAITING_PUBLICATION", "PENDING", 0, null);
    assertItem(items.get(9), published, "AWAITING_PROJECTION", "PUBLISHED", 1, null);
    assertThat(attention().body()).isEqualTo(response.body());
    assertThat(durableSnapshot()).isEqualTo(unchanged);
    assertFinancialReconciliation();
  }

  @Test
  @Timeout(45)
  void latestFiftyCompletedSampleCountsSettledRowsAndDoesNotSearchOlderSevereBacklog()
      throws Exception {
    var oldBlocked = completed(1, -50);
    blocked(oldBlocked);
    Fixture newest = null;
    for (int index = 1; index <= 55; index++) {
      var candidate = completed(100 + index, index);
      if (index >= 6 && index < 55) {
        published(candidate);
        project(candidate);
      }
      if (index == 55) newest = candidate;
    }
    create(id("30000000", 1), ALICE, CAROL, 7, "COMPLETED", BASE.plusSeconds(500));
    create(id("30000000", 2), CAROL, BOB, 7, "COMPLETED", BASE.plusSeconds(501));
    create(id("30000000", 3), BOB, ALICE, 2000, "REJECTED", BASE.plusSeconds(502));
    String unchanged = durableSnapshot();
    var response = attention();
    assertThat(response.<Number>json("$.sampledCount").intValue()).isEqualTo(50);
    List<Map<String, Object>> items = response.json("$.items");
    assertThat(items).hasSize(1);
    assertItem(items.getFirst(), newest, "AWAITING_PUBLICATION", "PENDING", 0, null);
    assertThat(response.body()).doesNotContain(oldBlocked.transferId().toString());
    assertThat(durableSnapshot()).isEqualTo(unchanged);
    assertFinancialReconciliation();
  }

  @Test
  @Timeout(30)
  void fundingUnrelatedTransfersAndRejectionsLeaveTheScopedSampleEmpty() throws Exception {
    create(id("30000000", 1), ALICE, CAROL, 7, "COMPLETED", BASE);
    create(id("30000000", 2), CAROL, BOB, 7, "COMPLETED", BASE.plusSeconds(1));
    create(id("30000000", 3), ALICE, BOB, 2000, "REJECTED", BASE.plusSeconds(2));
    String unchanged = durableSnapshot();
    var response = attention();
    assertThat(response.<Number>json("$.sampleLimit").intValue()).isEqualTo(50);
    assertThat(response.<Number>json("$.sampledCount").intValue()).isZero();
    assertThat(response.<List<?>>json("$.items")).isEmpty();
    assertThat(attention().body()).isEqualTo(response.body());
    assertThat(durableSnapshot()).isEqualTo(unchanged);
    assertFinancialReconciliation();
  }

  private PgTestSupport.Response attention() throws Exception {
    var response = db.get(app, "/internal/demo/delivery-attention");
    assertThat(response.status()).isEqualTo(200);
    assertThat(response.headers().firstValue("Cache-Control")).contains("no-store");
    assertThat(response.<Map<String, Object>>json("$").keySet())
        .containsExactlyInAnyOrder("sampleLimit", "sampledCount", "items");
    assertThat(response.body()).doesNotContain("attention-secret-", "private-error-detail", "idempotencyKey",
        "claimToken", "claimedBy", "payload", "lastErrorDetail");
    return response;
  }

  private void assertItem(Map<String, Object> item, Fixture fixture, String state,
      String publication, Integer attempts, String error) throws Exception {
    assertThat(item.keySet()).containsExactlyInAnyOrder(
        "transferId", "decidedAt", "amount", "unit", "sourceAccountId", "destinationAccountId",
        "attentionState", "publicationStatus", "attemptCount", "lastErrorCode", "nextAttemptAt");
    assertThat(item.get("transferId")).isEqualTo(fixture.transferId().toString());
    assertThat(Instant.parse((String) item.get("decidedAt"))).isEqualTo(fixture.decidedAt());
    assertThat(((Number) item.get("amount")).longValue()).isEqualTo(7);
    assertThat(item.get("unit")).isEqualTo("FIC");
    assertThat(item.get("sourceAccountId")).isEqualTo(fixture.source().toString());
    assertThat(item.get("destinationAccountId")).isEqualTo(fixture.destination().toString());
    assertThat(item.get("attentionState")).isEqualTo(state);
    assertThat(item.get("publicationStatus")).isEqualTo(publication);
    if (attempts == null) assertThat(item.get("attemptCount")).isNull();
    else assertThat(((Number) item.get("attemptCount")).intValue()).isEqualTo(attempts);
    assertThat(item.get("lastErrorCode")).isEqualTo(error);
    if ("PENDING".equals(publication)) {
      try (Connection connection = db.connect();
          var statement = connection.prepareStatement("SELECT next_attempt_at FROM outbox_events WHERE transfer_id=?")) {
        statement.setObject(1, fixture.transferId());
        try (var rows = statement.executeQuery()) {
          assertThat(rows.next()).isTrue();
          assertThat(Instant.parse((String) item.get("nextAttemptAt")))
              .isEqualTo(rows.getTimestamp(1).toInstant());
        }
      }
    } else assertThat(item.get("nextAttemptAt")).isNull();
  }

  private Fixture completed(int index, int seconds) throws Exception {
    UUID source = index % 2 == 0 ? ALICE : BOB;
    UUID destination = source.equals(ALICE) ? BOB : ALICE;
    UUID transfer = id("20000000", index);
    Instant decided = BASE.plusSeconds(seconds);
    create(transfer, source, destination, 7, "COMPLETED", decided);
    return new Fixture(transfer, source, destination, decided);
  }

  private void create(UUID transfer, UUID source, UUID destination, long amount,
      String status, Instant decided) throws Exception {
    try (Connection connection = db.connect()) {
      connection.setAutoCommit(false);
      terminal(connection, transfer, source, destination, amount, status, decided);
      connection.commit();
    }
  }

  private static void terminal(Connection connection, UUID transfer, UUID source, UUID destination,
      long amount, String status, Instant decided) throws Exception {
    execute(connection,
        "INSERT INTO transfers(id,idempotency_key,source_account_id,destination_account_id,amount,unit,status,created_at)"
            + " VALUES (?,?,?,?,?,'FIC','PROCESSING',?)",
        transfer, "attention-secret-" + transfer, source, destination, amount,
        Timestamp.from(BASE.minusSeconds(200)));
    if (status.equals("COMPLETED")) {
      execute(connection, "UPDATE balances SET amount=amount-? WHERE account_id=?", amount, source);
      execute(connection, "UPDATE balances SET amount=amount+? WHERE account_id=?", amount, destination);
      execute(connection, "INSERT INTO ledger_entries(transfer_id,account_id,delta) VALUES (?,?,?),(?,?,?)",
          transfer, source, -amount, transfer, destination, amount);
    }
    execute(connection, "UPDATE transfers SET status=?,rejection_code=?,completed_at=? WHERE id=?",
        status, status.equals("REJECTED") ? "INSUFFICIENT_FUNDS" : null,
        Timestamp.from(decided), transfer);
  }

  private void claim(Fixture fixture) throws Exception {
    db.execute("UPDATE outbox_events SET status='CLAIMED',claimed_by=?,claim_token=?,"
            + "claimed_at=clock_timestamp(),lease_until=clock_timestamp()+interval '1 hour',attempt_count=1"
            + " WHERE transfer_id=?", UUID.randomUUID(), UUID.randomUUID(), fixture.transferId());
  }

  private void published(Fixture fixture) throws Exception {
    claim(fixture);
    db.execute("UPDATE outbox_events SET status='PUBLISHED',published_at=clock_timestamp(),"
            + "kafka_topic='attention-fixture',kafka_partition=0,kafka_offset=1,"
            + "claimed_by=NULL,claim_token=NULL,claimed_at=NULL,lease_until=NULL WHERE transfer_id=?",
        fixture.transferId());
  }

  private void blocked(Fixture fixture) throws Exception {
    claim(fixture);
    db.execute("UPDATE outbox_events SET status='BLOCKED',last_error_code='TOPIC_REJECTED',"
            + "last_error_classification='PERMANENT',last_error_detail='private-error-detail',"
            + "last_error_at=clock_timestamp(),claimed_by=NULL,claim_token=NULL,claimed_at=NULL,lease_until=NULL"
            + " WHERE transfer_id=?", fixture.transferId());
  }

  private void retry(Fixture fixture) throws Exception {
    claim(fixture);
    db.execute("UPDATE outbox_events SET status='PENDING',last_error_code='KAFKA_UNAVAILABLE',"
            + "last_error_classification='TRANSIENT',last_error_detail='private-error-detail',"
            + "last_error_at=clock_timestamp(),next_attempt_at=clock_timestamp()+interval '1 hour',"
            + "claimed_by=NULL,claim_token=NULL,claimed_at=NULL,lease_until=NULL WHERE transfer_id=?",
        fixture.transferId());
  }

  private void project(Fixture fixture) throws Exception {
    String payload;
    try (Connection connection = db.connect();
        var query = connection.prepareStatement("SELECT payload::text FROM outbox_events WHERE transfer_id=?")) {
      query.setObject(1, fixture.transferId());
      try (var rows = query.executeQuery()) {
        assertThat(rows.next()).isTrue();
        payload = rows.getString(1);
      }
    }
    var outcome = app.context().getBean(EventProcessor.class).process(
        new EventProcessor.Delivery("attention-fixture", 0, offset++, fixture.transferId().toString(),
            payload.getBytes(StandardCharsets.UTF_8), 1));
    assertThat(outcome.outcome()).isEqualTo(EventProcessor.Outcome.PROCESSED);
  }

  private void removeUnprojectedEventAsOwner(Fixture fixture) throws Exception {
    // Controlled schema-owner corruption in this scenario only; restore guards before commit.
    try (Connection connection = db.connect()) {
      connection.setAutoCommit(false);
      execute(connection, "ALTER TABLE outbox_events DISABLE TRIGGER outbox_no_delete");
      execute(connection, "DELETE FROM outbox_events WHERE transfer_id=?", fixture.transferId());
      execute(connection, "ALTER TABLE outbox_events ENABLE TRIGGER outbox_no_delete");
      connection.commit();
    }
  }

  private void removeProjectionAsOwner(Fixture fixture) throws Exception {
    // Leave a committed inbox without its projection. This cannot arise from normal worker writes.
    try (Connection connection = db.connect()) {
      connection.setAutoCommit(false);
      execute(connection, "ALTER TABLE account_activity DISABLE TRIGGER account_activity_immutable");
      execute(connection, "DELETE FROM account_activity WHERE transfer_id=?", fixture.transferId());
      execute(connection, "ALTER TABLE account_activity ENABLE TRIGGER account_activity_immutable");
      execute(connection, "ALTER TABLE transfer_activity_projection DISABLE TRIGGER transfer_projection_immutable");
      execute(connection, "DELETE FROM transfer_activity_projection WHERE transfer_id=?", fixture.transferId());
      execute(connection, "ALTER TABLE transfer_activity_projection ENABLE TRIGGER transfer_projection_immutable");
      connection.commit();
    }
  }

  private String durableSnapshot() throws Exception {
    var tables = List.of("accounts", "balances", "transfers", "ledger_entries", "outbox_events",
        "event_inbox", "transfer_activity_projection", "account_activity");
    var rows = new ArrayList<String>();
    try (Connection connection = db.connect()) {
      for (String table : tables)
        try (var query = connection.prepareStatement(
                "SELECT coalesce(jsonb_agg(to_jsonb(r) ORDER BY to_jsonb(r)::text),'[]'::jsonb)::text FROM "
                    + table + " r");
            var result = query.executeQuery()) {
          assertThat(result.next()).isTrue();
          rows.add(result.getString(1));
        }
    }
    return String.join("\n", rows);
  }

  private void assertFinancialReconciliation() throws Exception {
    assertThat(db.get(app, "/internal/reconciliation").<Boolean>json("$.consistent")).isTrue();
  }

  private static UUID id(String prefix, int suffix) {
    return UUID.fromString(prefix + "-0000-0000-0000-" + "%012d".formatted(suffix));
  }

  private static void execute(Connection connection, String sql, Object... parameters) throws Exception {
    try (var statement = connection.prepareStatement(sql)) {
      PgTestSupport.bind(statement, parameters);
      statement.execute();
    }
  }

  private record Fixture(UUID transferId, UUID source, UUID destination, Instant decidedAt) {}
}
