package dev.tpp;

import static org.assertj.core.api.Assertions.assertThat;

import dev.tpp.application.BacklogAdmission;
import dev.tpp.events.consumer.EventProcessor;
import io.micrometer.core.instrument.MeterRegistry;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.Callable;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.springframework.jdbc.core.JdbcTemplate;
import org.testcontainers.postgresql.PostgreSQLContainer;

/** Real PostgreSQL/HTTP admission; publication-state fixtures are not Kafka delivery evidence. */
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class BackpressurePostgresTest {
  private PostgreSQLContainer postgres;
  private String adminUrl;
  private String username;
  private String password;
  private PgTestSupport db;
  private PgTestSupport.Application app;
  private UUID source;
  private UUID destination;

  @BeforeAll
  void startDedicatedPostgres() {
    adminUrl = System.getenv("TPP_TEST_DB_URL");
    if (adminUrl == null || adminUrl.isBlank()) {
      postgres =
          new PostgreSQLContainer(TestImages.postgres()).withImagePullPolicy(image -> false)
              .withDatabaseName("admission_tests")
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
  void isolatedFinancialDataset() throws Exception {
    db = new PgTestSupport(adminUrl, username, password);
    app = db.start(TppApplication.class, Map.of());
    source = db.post(app, "/api/accounts", "{\"unit\":\"FIC\"}", null).id();
    destination = db.post(app, "/api/accounts", "{\"unit\":\"FIC\"}", null).id();
    fund(source, 1000);
  }

  @AfterEach
  void closeApplicationsAndDropOnlyScenarioDatabase() throws Exception {
    if (db != null) db.close();
  }

  @AfterAll
  void stopSuiteOwnedContainer() {
    if (postgres != null) postgres.stop();
  }

  @Test
  void disabledAdmissionKeepsRealHttpBehaviorAndHasNoSample() throws Exception {
    var original = submit(app, "disabled-" + UUID.randomUUID(), 10);
    assertThat(original.status()).isEqualTo(201);
    var admission = policy(app);
    admission.refresh();
    var status = db.get(app, "/internal/backpressure");
    assertThat(status.<Boolean>json("$.enabled")).isFalse();
    assertThat(status.<Boolean>json("$.admitting")).isTrue();
    assertThat(status.<Object>json("$.pressure")).isNull();
    assertThat(admission.isRunning()).isFalse();
    assertFinancialInvariants();
  }

  @Test
  void priorKeysBypassAdmissionWhileOverloadRollsBackConcurrentNewKeysAndRecoversAfterDrain()
      throws Exception {
    String committedKey = "committed-" + UUID.randomUUID();
    var original = submit(app, committedKey, 10);
    assertThat(original.status()).isEqualTo(201);
    var enabled = enabled(Map.of("tpp.backpressure.max-unpublished", "2"));
    var policy = policy(enabled);
    policy.refresh();
    assertThat(policy.status().reason()).isEqualTo("unpublished_count");
    var before = financialSnapshot();
    var replay = submit(enabled, committedKey, 10);
    assertThat(replay.status()).isEqualTo(200);
    assertThat(replay.body()).isEqualTo(original.body());
    assertThat(submit(enabled, committedKey, 11).status()).isEqualTo(409);

    List<Callable<PgTestSupport.Response>> calls = new ArrayList<>();
    List<String> deniedKeys = new ArrayList<>();
    for (int index = 0; index < 12; index++) {
      String key = "denied-" + UUID.randomUUID();
      deniedKeys.add(key);
      calls.add(() -> submit(enabled, key, 1));
    }
    var responses = PgTestSupport.concurrently(calls);
    assertThat(responses)
        .allSatisfy(
            response -> {
              assertThat(response.status()).isEqualTo(503);
              assertThat(response.<String>json("$.code")).isEqualTo("EVENT_BACKLOG_OVERLOADED");
              assertThat(response.headers().firstValue("Retry-After")).contains("1");
            });
    assertThat(financialSnapshot()).isEqualTo(before);
    for (String key : deniedKeys)
      assertThat(db.scalar("SELECT count(*) FROM transfers WHERE idempotency_key=?", key)).isZero();
    assertThat(
            enabled
                .context()
                .getBean(MeterRegistry.class)
                .get("transfer.outcomes")
                .tag("outcome", "overloaded")
                .counter()
                .count())
        .isEqualTo(12);
    var inspection = db.get(enabled, "/internal/backpressure");
    assertThat(inspection.<Boolean>json("$.bestEffort")).isTrue();
    assertThat(inspection.<Number>json("$.pressure.unpublished").longValue()).isEqualTo(2);

    markPublishedFixture();
    projectCommittedOrigins();
    policy.refresh();
    assertThat(policy.status().admitting()).isTrue();
    assertThat(submit(enabled, deniedKeys.getFirst(), 1).status()).isEqualTo(201);
    assertFinancialInvariants();
  }

  @Test
  void publishedConsumerBacklogBlocksByCountAndAgeUntilProjectionCatchesUp() throws Exception {
    markPublishedFixture();
    var byCount = enabled(Map.of("tpp.backpressure.max-published-unprocessed", "1"));
    policy(byCount).refresh();
    assertThat(policy(byCount).status().reason()).isEqualTo("published_unprocessed_count");
    assertThat(policy(byCount).status().pressure().unpublished()).isZero();
    assertThat(submit(byCount, "consumer-count-" + UUID.randomUUID(), 1).status()).isEqualTo(503);

    Thread.sleep(1100); // Real persisted event age; no historical timestamps are rewritten.
    var byAge = enabled(Map.of("tpp.backpressure.max-published-unprocessed-age-seconds", "1"));
    policy(byAge).refresh();
    assertThat(policy(byAge).status().reason()).isEqualTo("published_unprocessed_age");
    var before = financialSnapshot();
    String key = "consumer-age-" + UUID.randomUUID();
    assertThat(submit(byAge, key, 1).status()).isEqualTo(503);
    assertThat(financialSnapshot()).isEqualTo(before);
    projectCommittedOrigins();
    policy(byCount).refresh();
    policy(byAge).refresh();
    assertThat(policy(byCount).status().admitting()).isTrue();
    assertThat(submit(byAge, key, 1).status()).isEqualTo(201);
    assertFinancialInvariants();
  }

  @Test
  void realSamplerStatementTimeoutLeavesStaleEvidenceAndRejectsBeforeFinancialMutations()
      throws Exception {
    var enabled =
        enabled(
            Map.of(
                "tpp.backpressure.sample-interval-ms",
                "1000",
                "tpp.backpressure.max-sample-age-ms",
                "1000",
                "tpp.backpressure.query-timeout-seconds",
                "1"));
    var policy = policy(enabled);
    policy.refresh();
    assertThat(policy.status().admitting()).isTrue();
    var before = financialSnapshot();
    String key = "sample-outage-" + UUID.randomUUID();
    try (Connection blocker = db.connect()) {
      blocker.setAutoCommit(false);
      sql(blocker, "SET LOCAL lock_timeout='5s'");
      sql(blocker, "LOCK TABLE outbox_events IN ACCESS EXCLUSIVE MODE");
      policy.refresh();
      assertThat(policy.status().reason()).isEqualTo("stale");
      assertThat(policy.status().pressure().unpublished()).isEqualTo(1);
      var blocked = submit(enabled, key, 1);
      assertThat(blocked.status()).isEqualTo(503);
      assertThat(blocked.<String>json("$.code")).isEqualTo("BACKLOG_STATUS_UNAVAILABLE");
      blocker.rollback();
    }
    assertThat(financialSnapshot()).isEqualTo(before);
    assertThat(db.scalar("SELECT count(*) FROM transfers WHERE idempotency_key=?", key)).isZero();
    assertThat(
            enabled
                .context()
                .getBean(MeterRegistry.class)
                .get("transfer.admission.sample.duration")
                .tag("outcome", "failure")
                .timer()
                .count())
        .isGreaterThanOrEqualTo(1);
    policy.refresh();
    assertThat(submit(enabled, key, 1).status()).isEqualTo(201);
    assertFinancialInvariants();
  }

  private PgTestSupport.Application enabled(Map<String, Object> overrides) {
    var settings = new HashMap<String, Object>();
    settings.put("tpp.backpressure.enabled", "true");
    settings.put("tpp.backpressure.max-unpublished", "100");
    settings.put("tpp.backpressure.max-unpublished-age-seconds", "300");
    settings.put("tpp.backpressure.max-published-unprocessed", "100");
    settings.put("tpp.backpressure.max-published-unprocessed-age-seconds", "300");
    settings.put("tpp.backpressure.sample-interval-ms", "60000");
    settings.put("tpp.backpressure.max-sample-age-ms", "300000");
    settings.putAll(overrides);
    var application = db.start(TppApplication.class, settings);
    policy(application).stop(); // Deterministic explicit refreshes; production schedules normally.
    return application;
  }

  private static BacklogAdmission policy(PgTestSupport.Application application) {
    return application.context().getBean(BacklogAdmission.class);
  }

  private PgTestSupport.Response submit(
      PgTestSupport.Application application, String key, long amount) throws Exception {
    return db.post(
        application, "/api/transfers", PgTestSupport.transfer(source, destination, amount), key);
  }

  private record FinancialSnapshot(
      long transfers, long postings, long events, long sourceBalance, long destinationBalance) {}

  private FinancialSnapshot financialSnapshot() throws SQLException {
    return new FinancialSnapshot(
        db.scalar("SELECT count(*) FROM transfers"),
        db.scalar("SELECT count(*) FROM ledger_entries"),
        db.scalar("SELECT count(*) FROM outbox_events"),
        db.scalar("SELECT amount FROM balances WHERE account_id=?", source),
        db.scalar("SELECT amount FROM balances WHERE account_id=?", destination));
  }

  private void fund(UUID user, long amount) throws SQLException {
    UUID issuer = UUID.randomUUID();
    UUID transfer = UUID.randomUUID();
    try (Connection connection = db.connect()) {
      connection.setAutoCommit(false);
      sql(
          connection,
          "INSERT INTO accounts(id,kind,status,unit) VALUES (?,'ISSUANCE','ACTIVE','FIC')",
          issuer);
      sql(connection, "INSERT INTO balances(account_id,amount) VALUES (?,0)", issuer);
      sql(
          connection,
          "INSERT INTO"
              + " transfers(id,idempotency_key,source_account_id,destination_account_id,amount,unit,status)"
              + " VALUES (?,?,?,?,?,'FIC','PROCESSING')",
          transfer,
          "issuance-" + transfer,
          issuer,
          user,
          amount);
      sql(connection, "UPDATE balances SET amount=amount-? WHERE account_id=?", amount, issuer);
      sql(connection, "UPDATE balances SET amount=amount+? WHERE account_id=?", amount, user);
      sql(
          connection,
          "INSERT INTO ledger_entries(transfer_id,account_id,delta) VALUES (?,?,?),(?,?,?)",
          transfer,
          issuer,
          -amount,
          transfer,
          user,
          amount);
      sql(
          connection,
          "UPDATE transfers SET status='COMPLETED',completed_at=clock_timestamp() WHERE id=?",
          transfer);
      connection.commit();
    }
  }

  private void markPublishedFixture() throws SQLException {
    try (Connection connection = db.connect()) {
      connection.setAutoCommit(false);
      sql(
          connection,
          "UPDATE outbox_events SET"
              + " status='CLAIMED',claimed_by=gen_random_uuid(),claim_token=gen_random_uuid(),claimed_at=clock_timestamp(),lease_until=clock_timestamp()+interval"
              + " '30 seconds',attempt_count=attempt_count+1 WHERE status='PENDING'");
      sql(
          connection,
          "UPDATE outbox_events SET"
              + " status='PUBLISHED',published_at=clock_timestamp(),kafka_topic='admission-fixture',kafka_partition=0,kafka_offset=0,claimed_by=NULL,claim_token=NULL,claimed_at=NULL,lease_until=NULL"
              + " WHERE status='CLAIMED'");
      connection.commit();
    }
  }

  private void projectCommittedOrigins() {
    var jdbc = app.context().getBean(JdbcTemplate.class);
    var processor = app.context().getBean(EventProcessor.class);
    var deliveries =
        jdbc.query(
            "SELECT o.transfer_id,o.payload::text FROM outbox_events o LEFT JOIN event_inbox i ON"
                + " i.event_id=o.event_id WHERE i.event_id IS NULL ORDER BY o.event_id",
            (row, index) ->
                new EventProcessor.Delivery(
                    "admission-fixture",
                    0,
                    index,
                    row.getObject(1, UUID.class).toString(),
                    row.getString(2).getBytes(StandardCharsets.UTF_8),
                    1));
    for (var delivery : deliveries)
      assertThat(processor.process(delivery).outcome()).isEqualTo(EventProcessor.Outcome.PROCESSED);
  }

  private static void sql(Connection connection, String command, Object... parameters)
      throws SQLException {
    try (var statement = connection.prepareStatement(command)) {
      PgTestSupport.bind(statement, parameters);
      statement.execute();
    }
  }

  private void assertFinancialInvariants() throws Exception {
    assertThat(db.get(app, "/internal/reconciliation").<Boolean>json("$.consistent")).isTrue();
    assertThat(db.scalar("SELECT count(*) FROM transfers WHERE status='PROCESSING'")).isZero();
    assertThat(
            db.scalar(
                "SELECT count(*) FROM transfers t LEFT JOIN outbox_events o ON o.transfer_id=t.id"
                    + " WHERE t.status='COMPLETED' AND o.event_id IS NULL"))
        .isZero();
    assertThat(
            db.scalar(
                "SELECT count(*) FROM (SELECT transfer_id FROM ledger_entries GROUP BY transfer_id"
                    + " HAVING count(*)<>2 OR sum(delta)<>0) broken"))
        .isZero();
  }
}
