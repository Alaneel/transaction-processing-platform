package dev.tpp;

import static org.assertj.core.api.Assertions.assertThat;

import java.net.URLEncoder;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.junit.jupiter.api.Timeout;

/** Real PostgreSQL/HTTP pagination over terminal financial history, without Kafka fixtures. */
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class DemoTransferHistoryPostgresTest {
  private static final UUID ISSUANCE = id("00000000", 1);
  private static final UUID ALICE = id("00000000", 2);
  private static final UUID BOB = id("00000000", 3);
  private static final UUID CAROL = id("00000000", 4);
  private static final UUID DAVE = id("00000000", 5);
  private static final Instant BASE = Instant.parse("2026-01-02T03:04:05.123456Z");
  private PgTestSupport db;
  private PgTestSupport.Application app;
  private final List<Expected> expected = new ArrayList<>();

  @BeforeAll
  @Timeout(value = 5, unit = TimeUnit.MINUTES)
  void startOwnedRealDatabaseAndCreateScopedTerminalHistory() throws Exception {
    db = new PgTestSupport();
    app =
        db.start(
            TppApplication.class,
            Map.of("tpp.events.relay-enabled", false, "tpp.events.consumer-enabled", false));
    try (Connection connection = db.connect()) {
      connection.setAutoCommit(false);
      for (UUID account : List.of(ISSUANCE, ALICE, BOB, CAROL, DAVE)) {
        execute(
            connection,
            "INSERT INTO accounts(id,kind,created_at) VALUES (?,?,?)",
            account,
            account.equals(ISSUANCE) ? "ISSUANCE" : "USER",
            Timestamp.from(BASE.minusSeconds(300)));
        execute(connection, "INSERT INTO balances(account_id,amount) VALUES (?,0)", account);
      }
      int funding = 1;
      for (UUID account : List.of(ALICE, BOB, CAROL, DAVE))
        terminal(
            connection,
            id("10000000", funding++),
            ISSUANCE,
            account,
            1000,
            "COMPLETED",
            BASE.minusSeconds(100));
      for (int index = 1; index <= 25; index++) {
        UUID source = index % 2 == 0 ? ALICE : BOB;
        UUID destination = source.equals(ALICE) ? BOB : ALICE;
        String status = index % 4 == 0 ? "REJECTED" : "COMPLETED";
        long amount = status.equals("REJECTED") ? 2000 : 7;
        Instant decidedAt = BASE.plusSeconds(index % 5);
        UUID transfer = id("20000000", index);
        terminal(connection, transfer, source, destination, amount, status, decidedAt);
        expected.add(
            new Expected(
                transfer,
                source,
                destination,
                amount,
                status,
                decidedAt,
                status.equals("REJECTED") ? "INSUFFICIENT_FUNDS" : null));
      }
      // These newer rows must not enter any page, even if only one demo account is involved.
      terminal(connection, id("30000000", 1), ALICE, CAROL, 7, "COMPLETED", BASE.plusSeconds(20));
      terminal(connection, id("30000000", 2), CAROL, BOB, 7, "COMPLETED", BASE.plusSeconds(21));
      terminal(connection, id("30000000", 3), BOB, DAVE, 2000, "REJECTED", BASE.plusSeconds(22));
      terminal(connection, id("30000000", 4), CAROL, DAVE, 7, "COMPLETED", BASE.plusSeconds(23));
      connection.commit();
    }
    expected.sort(
        Comparator.comparing(Expected::decidedAt)
            .thenComparing(value -> value.transferId().toString())
            .reversed());
  }

  @AfterAll
  void closeApplicationAndDropOnlyThisTestsDatabase() throws Exception {
    if (db != null) db.close();
  }

  @Test
  @Timeout(30)
  void defaultAndMaximumPagesExposeOnlyPrivateTerminalAliceBobHistoryAndDoNotWrite()
      throws Exception {
    String before = durableSnapshot();
    var defaultPage = page("");
    assertRows(defaultPage.items(), expected.subList(0, 6));
    assertThat(defaultPage.nextBefore()).isNotNull();
    assertThat(page("")).isEqualTo(defaultPage);
    var maximum = page("?limit=20");
    assertRows(maximum.items(), expected.subList(0, 20));
    assertThat(maximum.nextBefore()).isNotNull();
    var remainder = page("?limit=20&before=" + encoded(maximum.nextBefore()));
    assertRows(remainder.items(), expected.subList(20, 25));
    assertThat(remainder.nextBefore()).isNull();
    assertThat(durableSnapshot()).isEqualTo(before);
    assertReconciled();
  }

  @Test
  @Timeout(30)
  void opaqueCursorTraversesMixedTimestampAndUuidTiesWithoutDuplicatesOrGaps()
      throws Exception {
    String before = durableSnapshot();
    String cursor = null;
    var cursors = new HashSet<String>();
    var visited = new ArrayList<UUID>();
    for (int request = 0; request < 10; request++) {
      var response = page("?limit=4" + (cursor == null ? "" : "&before=" + encoded(cursor)));
      int offset = visited.size();
      assertRows(response.items(), expected.subList(offset, Math.min(offset + 4, expected.size())));
      for (var item : response.items())
        visited.add(UUID.fromString((String) item.get("transferId")));
      cursor = response.nextBefore();
      if (cursor == null) break;
      assertThat(cursors.add(cursor)).as("cursor must advance after each full page").isTrue();
    }
    assertThat(visited)
        .containsExactlyElementsOf(expected.stream().map(Expected::transferId).toList())
        .doesNotHaveDuplicates();
    assertThat(cursor).isNull();
    assertThat(durableSnapshot()).isEqualTo(before);
  }

  @Test
  @Timeout(30)
  void invalidLimitsAndNoncanonicalCursorsReturn400WithoutChangingDurableHistory()
      throws Exception {
    String before = durableSnapshot();
    String valid = page("?limit=4").nextBefore();
    assertThat(valid).isNotNull();
    byte[] bytes = Base64.getUrlDecoder().decode(valid);
    byte[] badVersion = bytes.clone();
    badVersion[0] = 2;
    byte[] impossibleTime = bytes.clone();
    ByteBuffer.wrap(impossibleTime).putLong(1, Long.MAX_VALUE);
    byte[] subMicrosecond = bytes.clone();
    ByteBuffer.wrap(subMicrosecond).putInt(9, 123456789);
    String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";
    int finalIndex = alphabet.indexOf(valid.charAt(valid.length() - 1));
    assertThat(finalIndex & 3).isZero();
    String noncanonical = valid.substring(0, valid.length() - 1) + alphabet.charAt(finalIndex | 1);
    for (String query : List.of("?limit=0", "?limit=-1", "?limit=21", "?limit=1.5", "?limit=many"))
      assertInvalid(query);
    for (String cursor :
        List.of(
            "not-a-cursor",
            "!".repeat(39),
            valid + "=",
            noncanonical,
            Base64.getUrlEncoder().withoutPadding().encodeToString(badVersion),
            Base64.getUrlEncoder().withoutPadding().encodeToString(impossibleTime),
            Base64.getUrlEncoder().withoutPadding().encodeToString(subMicrosecond)))
      assertInvalid("?before=" + encoded(cursor));
    assertThat(durableSnapshot()).isEqualTo(before);
  }

  private Page page(String query) throws Exception {
    var response = db.get(app, "/internal/demo/transfers" + query);
    assertThat(response.status()).isEqualTo(200);
    assertThat(response.headers().firstValue("Cache-Control")).contains("no-store");
    assertThat(response.<Map<String, Object>>json("$").keySet())
        .containsExactlyInAnyOrder("items", "nextBefore");
    assertThat(response.body()).doesNotContain("idempotency", "history-secret-");
    List<Map<String, Object>> items = response.json("$.items");
    String next = response.json("$.nextBefore");
    if (next != null) assertThat(next).matches("[A-Za-z0-9_-]{39}");
    return new Page(List.copyOf(items), next);
  }

  private static void assertRows(List<Map<String, Object>> actual, List<Expected> wanted) {
    assertThat(actual).hasSize(wanted.size());
    for (int index = 0; index < actual.size(); index++) {
      var row = actual.get(index);
      var expected = wanted.get(index);
      assertThat(row.keySet())
          .containsExactlyInAnyOrder(
              "transferId", "sourceAccountId", "destinationAccountId", "amount", "unit",
              "transferStatus", "decidedAt", "rejectionCode");
      assertThat(row.get("transferId")).isEqualTo(expected.transferId().toString());
      assertThat(row.get("sourceAccountId")).isEqualTo(expected.source().toString());
      assertThat(row.get("destinationAccountId")).isEqualTo(expected.destination().toString());
      assertThat(((Number) row.get("amount")).longValue()).isEqualTo(expected.amount());
      assertThat(row.get("unit")).isEqualTo("FIC");
      assertThat(row.get("transferStatus")).isEqualTo(expected.status());
      assertThat(Instant.parse((String) row.get("decidedAt"))).isEqualTo(expected.decidedAt());
      assertThat(row.get("rejectionCode")).isEqualTo(expected.rejectionCode());
    }
  }

  private void assertInvalid(String query) throws Exception {
    var response = db.get(app, "/internal/demo/transfers" + query);
    assertThat(response.status()).isEqualTo(400);
    assertThat(response.<String>json("$.code")).isEqualTo("INVALID_REQUEST");
  }

  private void terminal(
      Connection connection, UUID transfer, UUID source, UUID destination, long amount,
      String status, Instant decidedAt) throws Exception {
    execute(connection,
        "INSERT INTO transfers(id,idempotency_key,source_account_id,destination_account_id,amount,unit,status,created_at)"
            + " VALUES (?,?,?,?,?,'FIC','PROCESSING',?)",
        transfer, "history-secret-" + transfer, source, destination, amount,
        Timestamp.from(BASE.minusSeconds(200)));
    if (status.equals("COMPLETED")) {
      execute(connection, "UPDATE balances SET amount=amount-? WHERE account_id=?", amount, source);
      execute(connection, "UPDATE balances SET amount=amount+? WHERE account_id=?", amount, destination);
      execute(connection,
          "INSERT INTO ledger_entries(transfer_id,account_id,delta) VALUES (?,?,?),(?,?,?)",
          transfer, source, -amount, transfer, destination, amount);
    }
    execute(connection,
        "UPDATE transfers SET status=?,rejection_code=?,completed_at=? WHERE id=?",
        status, status.equals("REJECTED") ? "INSUFFICIENT_FUNDS" : null,
        Timestamp.from(decidedAt), transfer);
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

  private void assertReconciled() throws Exception {
    assertThat(db.get(app, "/internal/reconciliation").<Boolean>json("$.consistent")).isTrue();
  }

  private static String encoded(String value) {
    return URLEncoder.encode(value, StandardCharsets.UTF_8);
  }

  private static UUID id(String prefix, int suffix) {
    return UUID.fromString(prefix + "-0000-0000-0000-" + "%012d".formatted(suffix));
  }

  private static void execute(Connection connection, String sql, Object... values) throws Exception {
    try (var statement = connection.prepareStatement(sql)) {
      PgTestSupport.bind(statement, values);
      statement.execute();
    }
  }

  private record Page(List<Map<String, Object>> items, String nextBefore) {}

  private record Expected(
      UUID transferId, UUID source, UUID destination, long amount, String status,
      Instant decidedAt, String rejectionCode) {}
}
