package dev.tpp;

import static org.assertj.core.api.Assertions.assertThat;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.junit.jupiter.api.Timeout;

/** Real PostgreSQL and HTTP evidence; Kafka delivery is not part of the financial proof. */
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class LedgerProofPostgresTest {
  private PgTestSupport db;
  private PgTestSupport.Application app;
  private PgTestSupport.Application peer;

  @BeforeAll
  @Timeout(value = 5, unit = TimeUnit.MINUTES)
  void startDedicatedDatabaseAndIndependentHttpServers() throws Exception {
    db = new PgTestSupport();
    var settings =
        Map.<String, Object>of(
            "tpp.events.relay-enabled", false, "tpp.events.consumer-enabled", false);
    app = db.start(TppApplication.class, settings);
    peer = db.start(TppApplication.class, settings);
  }

  @AfterAll
  void closeApplicationsAndRemoveOnlyThisTestsDatabase() throws Exception {
    if (db != null) db.close();
  }

  @Test
  @Timeout(30)
  void completedProofPreservesPhysicalBigintIdsAndSignedPairAcrossReadsAndIdempotentReplay()
      throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 1000);
    // A JavaScript Number would round the first ID. The HTTP contract must retain decimal text.
    db.execute("SELECT setval(pg_get_serial_sequence('ledger_entries','id'),9007199254740993,false)");
    String key = key();
    var completed = submit(app, source, destination, 275, key);
    assertThat(completed.status()).isEqualTo(201);
    UUID transfer = completed.id();
    List<Posting> physical = postings(transfer);
    assertThat(physical).hasSize(2);
    assertThat(physical)
        .allSatisfy(
            posting ->
                assertThat(Long.parseLong(posting.entryId())).isGreaterThan(9007199254740992L));
    assertThat(physical)
        .anySatisfy(
            posting -> {
              assertThat(posting.accountId()).isEqualTo(source.toString());
              assertThat(posting.delta()).isEqualTo(-275);
            })
        .anySatisfy(
            posting -> {
              assertThat(posting.accountId()).isEqualTo(destination.toString());
              assertThat(posting.delta()).isEqualTo(275);
            });
    String unchanged = durableSnapshot();
    var proof = proof(app, transfer, source, destination, 275, "COMPLETED", "BALANCED_PAIR");
    assertThat(proofPostings(proof)).containsExactlyInAnyOrderElementsOf(physical);
    assertThat(db.get(peer, path(transfer)).body()).isEqualTo(proof.body());
    assertThat(durableSnapshot()).isEqualTo(unchanged);

    var replay = submit(peer, source, destination, 275, key);
    assertThat(replay.status()).isEqualTo(200);
    assertThat(replay.body()).isEqualTo(completed.body());
    assertThat(db.get(peer, path(transfer)).body()).isEqualTo(proof.body());
    assertThat(postings(transfer)).containsExactlyElementsOf(physical);
    assertThat(durableSnapshot()).isEqualTo(unchanged);
    assertThat(db.scalar("SELECT amount FROM balances WHERE account_id=?", source)).isEqualTo(725);
    assertThat(db.scalar("SELECT amount FROM balances WHERE account_id=?", destination)).isEqualTo(275);
    assertReconciled();
  }

  @Test
  @Timeout(30)
  void rejectedProofHasNoPostingsAndReplayCannotChangeBalancesOrHistory() throws Exception {
    UUID source = account();
    UUID destination = account();
    String key = key();
    var rejected = submit(app, source, destination, 7, key);
    assertThat(rejected.status()).isEqualTo(422);
    assertThat(rejected.<String>json("$.rejectionCode")).isEqualTo("INSUFFICIENT_FUNDS");
    UUID transfer = rejected.id();
    assertThat(postings(transfer)).isEmpty();
    assertThat(db.scalar("SELECT count(*) FROM outbox_events WHERE transfer_id=?", transfer)).isZero();
    String unchanged = durableSnapshot();
    var proof = proof(app, transfer, source, destination, 7, "REJECTED", "NO_POSTINGS");
    assertThat(proofPostings(proof)).isEmpty();
    var replay = submit(peer, source, destination, 7, key);
    assertThat(replay.status()).isEqualTo(422);
    assertThat(replay.body()).isEqualTo(rejected.body());
    assertThat(db.get(peer, path(transfer)).body()).isEqualTo(proof.body());
    assertThat(postings(transfer)).isEmpty();
    assertThat(durableSnapshot()).isEqualTo(unchanged);
    assertThat(db.scalar("SELECT amount FROM balances WHERE account_id=?", source)).isZero();
    assertThat(db.scalar("SELECT amount FROM balances WHERE account_id=?", destination)).isZero();
    assertReconciled();
  }

  @Test
  @Timeout(30)
  void unknownAndMalformedIdsReturnExplicitHttpErrorsWithoutMutatingDurableState()
      throws Exception {
    String unchanged = durableSnapshot();
    var unknown = db.get(app, path(UUID.randomUUID()));
    assertThat(unknown.status()).isEqualTo(404);
    assertThat(unknown.<String>json("$.code")).isEqualTo("TRANSFER_NOT_FOUND");
    var malformed = db.get(app, "/internal/transfers/not-a-uuid/ledger-proof");
    assertThat(malformed.status()).isEqualTo(400);
    assertThat(malformed.<String>json("$.code")).isEqualTo("INVALID_REQUEST");
    assertThat(durableSnapshot()).isEqualTo(unchanged);
  }

  @Test
  @Timeout(30)
  void zeroSumPostingsWithWrongSignedAmountsAreInconsistentAfterControlledOwnerCorruption()
      throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 1000);
    var completed = submit(app, source, destination, 10, key());
    assertThat(completed.status()).isEqualTo(201);
    UUID transfer = completed.id();
    List<Posting> original = postings(transfer);
    String unchanged = durableSnapshot();
    // Only this suite's schema owner can bypass immutability. This is corrupted-history evidence,
    // not a state that legitimate transfer writes can create. Restore rows and trigger in finally.
    rewriteSignedAmounts(transfer, source, 11);
    try {
      assertThat(db.scalar("SELECT sum(delta) FROM ledger_entries WHERE transfer_id=?", transfer))
          .isZero();
      String corrupt = durableSnapshot();
      var proof = proof(app, transfer, source, destination, 10, "COMPLETED", "INCONSISTENT");
      assertThat(proofPostings(proof)).containsExactlyInAnyOrderElementsOf(postings(transfer));
      assertThat(durableSnapshot()).isEqualTo(corrupt);
    } finally {
      rewriteSignedAmounts(transfer, source, 10);
    }
    assertThat(postings(transfer)).containsExactlyElementsOf(original);
    assertThat(durableSnapshot()).isEqualTo(unchanged);
    proof(app, transfer, source, destination, 10, "COMPLETED", "BALANCED_PAIR");
    assertReconciled();
  }

  private PgTestSupport.Response proof(
      PgTestSupport.Application server,
      UUID transfer,
      UUID source,
      UUID destination,
      long amount,
      String transferStatus,
      String proofState)
      throws Exception {
    var response = db.get(server, path(transfer));
    assertThat(response.status()).isEqualTo(200);
    assertThat(response.headers().firstValue("Cache-Control")).contains("no-store");
    assertThat(response.<Map<String, Object>>json("$").keySet())
        .containsExactlyInAnyOrder(
            "transferId", "transferStatus", "sourceAccountId", "destinationAccountId",
            "amount", "unit", "proofState", "postings");
    assertThat(response.<String>json("$.transferId")).isEqualTo(transfer.toString());
    assertThat(response.<String>json("$.transferStatus")).isEqualTo(transferStatus);
    assertThat(response.<String>json("$.sourceAccountId")).isEqualTo(source.toString());
    assertThat(response.<String>json("$.destinationAccountId")).isEqualTo(destination.toString());
    assertThat(response.<Number>json("$.amount").longValue()).isEqualTo(amount);
    assertThat(response.<String>json("$.unit")).isEqualTo("FIC");
    assertThat(response.<String>json("$.proofState")).isEqualTo(proofState);
    return response;
  }

  private static List<Posting> proofPostings(PgTestSupport.Response response) {
    List<Map<String, Object>> rows = response.json("$.postings");
    var result = new ArrayList<Posting>();
    for (var row : rows) {
      assertThat(row.keySet()).containsExactlyInAnyOrder("entryId", "accountId", "delta");
      assertThat(row.get("entryId")).isInstanceOf(String.class);
      String entryId = (String) row.get("entryId");
      assertThat(entryId).matches("[1-9][0-9]*");
      result.add(new Posting(entryId, (String) row.get("accountId"), ((Number) row.get("delta")).longValue()));
    }
    return List.copyOf(result);
  }

  private List<Posting> postings(UUID transfer) throws Exception {
    var result = new ArrayList<Posting>();
    try (Connection connection = db.connect();
        var query = connection.prepareStatement(
            "SELECT id,account_id,delta FROM ledger_entries WHERE transfer_id=? ORDER BY id")) {
      query.setObject(1, transfer);
      try (var rows = query.executeQuery()) {
        while (rows.next())
          result.add(new Posting(rows.getString(1), rows.getObject(2, UUID.class).toString(), rows.getLong(3)));
      }
    }
    return List.copyOf(result);
  }

  private String durableSnapshot() throws Exception {
    try (Connection connection = db.connect();
        var query = connection.prepareStatement(
            "SELECT jsonb_build_object("
                + " 'accounts',(SELECT jsonb_agg(to_jsonb(a) ORDER BY a.id) FROM accounts a),"
                + " 'balances',(SELECT jsonb_agg(to_jsonb(b) ORDER BY b.account_id) FROM balances b),"
                + " 'transfers',(SELECT jsonb_agg(to_jsonb(t) ORDER BY t.id) FROM transfers t),"
                + " 'postings',(SELECT jsonb_agg(to_jsonb(l) ORDER BY l.id) FROM ledger_entries l),"
                + " 'outbox',(SELECT jsonb_agg(to_jsonb(o) ORDER BY o.event_id) FROM outbox_events o)"
                + ")::text");
        var rows = query.executeQuery()) {
      assertThat(rows.next()).isTrue();
      return rows.getString(1);
    }
  }

  private void rewriteSignedAmounts(UUID transfer, UUID source, long amount) throws Exception {
    try (Connection connection = db.connect()) {
      connection.setAutoCommit(false);
      try {
        execute(connection, "ALTER TABLE ledger_entries DISABLE TRIGGER ledger_entries_immutable");
        execute(connection,
            "UPDATE ledger_entries SET delta=CASE WHEN account_id=? THEN ? ELSE ? END WHERE transfer_id=?",
            source, -amount, amount, transfer);
        execute(connection, "ALTER TABLE ledger_entries ENABLE TRIGGER ledger_entries_immutable");
        connection.commit();
      } catch (Exception failure) {
        connection.rollback();
        throw failure;
      }
    }
  }

  private UUID account() throws Exception {
    var result = db.post(app, "/api/accounts", "{\"unit\":\"FIC\"}", null);
    assertThat(result.status()).isEqualTo(201);
    return result.id();
  }

  private void fund(UUID user, long amount) throws Exception {
    UUID issuance = UUID.randomUUID();
    UUID transfer = UUID.randomUUID();
    try (Connection connection = db.connect()) {
      connection.setAutoCommit(false);
      execute(connection, "INSERT INTO accounts(id,kind) VALUES (?,'ISSUANCE')", issuance);
      execute(connection, "INSERT INTO balances(account_id,amount) VALUES (?,0)", issuance);
      execute(connection,
          "INSERT INTO transfers(id,idempotency_key,source_account_id,destination_account_id,amount,unit,status)"
              + " VALUES (?,?,?,?,?,'FIC','PROCESSING')",
          transfer, "ledger-proof-fund-" + transfer, issuance, user, amount);
      execute(connection, "UPDATE balances SET amount=amount-? WHERE account_id=?", amount, issuance);
      execute(connection, "UPDATE balances SET amount=amount+? WHERE account_id=?", amount, user);
      execute(connection,
          "INSERT INTO ledger_entries(transfer_id,account_id,delta) VALUES (?,?,?),(?,?,?)",
          transfer, issuance, -amount, transfer, user, amount);
      execute(connection, "UPDATE transfers SET status='COMPLETED',completed_at=now() WHERE id=?", transfer);
      connection.commit();
    }
  }

  private PgTestSupport.Response submit(
      PgTestSupport.Application server, UUID source, UUID destination, long amount, String key)
      throws Exception {
    return db.post(server, "/api/transfers", PgTestSupport.transfer(source, destination, amount), key);
  }

  private void assertReconciled() throws Exception {
    var response = db.get(app, "/internal/reconciliation");
    assertThat(response.status()).isEqualTo(200);
    assertThat(response.<Boolean>json("$.consistent")).isTrue();
  }

  private static void execute(Connection connection, String sql, Object... values) throws Exception {
    try (var statement = connection.prepareStatement(sql)) {
      PgTestSupport.bind(statement, values);
      statement.execute();
    }
  }

  private static String path(UUID transfer) {
    return "/internal/transfers/" + transfer + "/ledger-proof";
  }

  private static String key() {
    return "ledger-proof-" + UUID.randomUUID();
  }

  private record Posting(String entryId, String accountId, long delta) {}
}
