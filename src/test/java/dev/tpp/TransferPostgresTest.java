package dev.tpp;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import dev.tpp.application.TransferFaults;
import dev.tpp.application.TransferFaults.Boundary;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;
import java.util.concurrent.Callable;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;

/**
 * End-to-end correctness against PostgreSQL, including simultaneous requests to independent
 * servers.
 */
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class TransferPostgresTest {
  private PgTestSupport db;
  private PgTestSupport.Application app;
  private PgTestSupport.Application peer;
  private PgTestSupport.Application faultApp;
  private MutableFaults faults;

  @BeforeAll
  void startRealDatabaseAndIndependentApplications() throws Exception {
    db = new PgTestSupport();
    app = db.start(TppApplication.class, Map.of());
    peer = db.start(TppApplication.class, Map.of());
    faultApp = db.start(TppApplication.class, Map.of(), FaultConfiguration.class);
    faults = faultApp.context().getBean(MutableFaults.class);
  }

  @AfterAll
  void cleanDedicatedDatabase() throws Exception {
    if (db != null) db.close();
  }

  @Test
  void realHttpAccountAndTransferHaveBalancedImmutablePostings() throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 1_000);
    var result = submit(app, source, destination, 275, key());
    assertThat(result.status()).isEqualTo(201);
    assertThat(result.<String>json("$.status")).isEqualTo("COMPLETED");
    assertThat(result.headers().firstValue("X-Correlation-ID")).isPresent();
    assertThat(db.get(app, "/api/transfers/" + result.id()).body()).isEqualTo(result.body());
    assertThat(db.get(app, "/api/accounts/" + source).<String>json("$.id"))
        .isEqualTo(source.toString());
    assertThat(balance(source)).isEqualTo(725);
    assertThat(balance(destination)).isEqualTo(275);
    assertThat(db.scalar("SELECT count(*) FROM ledger_entries WHERE transfer_id = ?", result.id()))
        .isEqualTo(2);
    assertThat(
            db.scalar("SELECT sum(delta) FROM ledger_entries WHERE transfer_id = ?", result.id()))
        .isZero();
    assertReconciled();
  }

  @Test
  void insufficientFundsIsDurableAndReplayedEvenAfterLaterFunding() throws Exception {
    UUID source = account();
    UUID destination = account();
    String key = key();
    var rejected = submit(app, source, destination, 50, key);
    assertThat(rejected.status()).isEqualTo(422);
    assertThat(rejected.<String>json("$.status")).isEqualTo("REJECTED");
    assertThat(rejected.<String>json("$.rejectionCode")).isEqualTo("INSUFFICIENT_FUNDS");
    fund(source, 100);
    var replay = submit(peer, source, destination, 50, key);
    assertThat(replay.status()).isEqualTo(422);
    assertThat(replay.body()).isEqualTo(rejected.body());
    assertThat(balance(source)).isEqualTo(100);
    assertThat(balance(destination)).isZero();
    assertThat(
            db.scalar("SELECT count(*) FROM ledger_entries WHERE transfer_id = ?", rejected.id()))
        .isZero();
    assertReconciled();
  }

  @Test
  void completedKeyReplaysAndEveryPayloadFieldParticipatesInConflictDetection() throws Exception {
    UUID source = account();
    UUID destination = account();
    UUID other = account();
    fund(source, 100);
    String key = key();
    var original = submit(app, source, destination, 10, key);
    assertThat(submit(peer, source, destination, 10, key).status()).isEqualTo(200);
    assertThat(submit(peer, source, destination, 10, key).body()).isEqualTo(original.body());
    assertThat(submit(app, source, destination, 11, key).status()).isEqualTo(409);
    assertThat(submit(app, source, other, 10, key).status()).isEqualTo(409);
    assertThat(submit(app, other, destination, 10, key).status()).isEqualTo(409);
    assertThat(db.scalar("SELECT count(*) FROM transfers WHERE idempotency_key = ?", key))
        .isEqualTo(1);
    assertThat(balance(source)).isEqualTo(90);
    assertThat(balance(destination)).isEqualTo(10);
    assertReconciled();
  }

  @Test
  void concurrentIdenticalKeysAcrossInstancesHaveExactlyOneFinancialEffect() throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 1_000);
    String key = key();
    List<Callable<PgTestSupport.Response>> work = new ArrayList<>();
    for (int index = 0; index < 20; index++) {
      var server = index % 2 == 0 ? app : peer;
      work.add(() -> submit(server, source, destination, 100, key));
    }
    var results = PgTestSupport.concurrently(work);
    assertThat(results.stream().filter(r -> r.status() == 201).count()).isEqualTo(1);
    assertThat(results).allSatisfy(r -> assertThat(r.status()).isIn(200, 201));
    assertThat(results.stream().map(PgTestSupport.Response::id).distinct().count()).isEqualTo(1);
    assertThat(balance(source)).isEqualTo(900);
    assertThat(balance(destination)).isEqualTo(100);
    assertThat(
            db.scalar(
                "SELECT count(*) FROM ledger_entries WHERE transfer_id = ?",
                results.getFirst().id()))
        .isEqualTo(2);
    assertReconciled();
  }

  @Test
  void concurrentSameKeyDifferentPayloadHasOneWinnerAndExplicitConflict() throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 100);
    String key = key();
    var results =
        PgTestSupport.<PgTestSupport.Response>concurrently(
            List.of(
                () -> submit(app, source, destination, 10, key),
                () -> submit(peer, source, destination, 20, key)));
    assertThat(results.stream().map(PgTestSupport.Response::status))
        .containsExactlyInAnyOrder(201, 409);
    long moved =
        results.stream()
            .filter(r -> r.status() == 201)
            .findFirst()
            .orElseThrow()
            .<Number>json("$.amount")
            .longValue();
    assertThat(balance(destination)).isEqualTo(moved);
    assertThat(balance(source)).isEqualTo(100 - moved);
    assertThat(db.scalar("SELECT count(*) FROM transfers WHERE idempotency_key = ?", key))
        .isEqualTo(1);
    assertReconciled();
  }

  @Test
  void concurrentIndependentKeysCannotOverspendTheSameAccount() throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 1_000);
    List<Callable<PgTestSupport.Response>> work = new ArrayList<>();
    for (int index = 0; index < 24; index++) {
      var server = index % 2 == 0 ? app : peer;
      work.add(() -> submit(server, source, destination, 100, key()));
    }
    var results = PgTestSupport.concurrently(work);
    assertThat(results.stream().filter(r -> r.status() == 201).count()).isEqualTo(10);
    assertThat(results.stream().filter(r -> r.status() == 422).count()).isEqualTo(14);
    assertThat(results).allSatisfy(r -> assertThat(r.status()).isIn(201, 422));
    assertThat(balance(source)).isZero();
    assertThat(balance(destination)).isEqualTo(1_000);
    assertThat(
            db.scalar(
                "SELECT count(*) FROM balances b JOIN accounts a ON a.id=b.account_id WHERE"
                    + " a.kind='USER' AND b.amount < 0"))
        .isZero();
    assertReconciled();
  }

  @Test
  void oppositeDirectionTransfersUseIndependentConnectionsAndPreserveTotals() throws Exception {
    UUID left = account();
    UUID right = account();
    fund(left, 1_000);
    fund(right, 1_000);
    List<Callable<PgTestSupport.Response>> work = new ArrayList<>();
    for (int index = 0; index < 20; index++) {
      boolean forwards = index % 2 == 0;
      var server = forwards ? app : peer;
      work.add(() -> submit(server, forwards ? left : right, forwards ? right : left, 10, key()));
    }
    var results = PgTestSupport.concurrently(work);
    assertThat(results).allSatisfy(r -> assertThat(r.status()).isEqualTo(201));
    assertThat(balance(left)).isEqualTo(1_000);
    assertThat(balance(right)).isEqualTo(1_000);
    assertReconciled();
  }

  @Test
  void persistedIdempotencySurvivesApplicationShutdownAndFreshApplicationStart() throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 100);
    String key = key();
    var transientApp = db.start(TppApplication.class, Map.of());
    var committed = submit(transientApp, source, destination, 25, key);
    transientApp.close();
    try (var restarted = db.start(TppApplication.class, Map.of())) {
      var replay = submit(restarted, source, destination, 25, key);
      assertThat(replay.status()).isEqualTo(200);
      assertThat(replay.body()).isEqualTo(committed.body());
    }
    assertThat(balance(source)).isEqualTo(75);
    assertThat(balance(destination)).isEqualTo(25);
    assertReconciled();
  }

  @Test
  void validationAndUnknownResourcesHaveExplicitClientErrors() throws Exception {
    UUID source = account();
    UUID destination = account();
    for (long amount : new long[] {0, -1, 9_000_000_000_000_001L}) {
      assertThat(submit(app, source, destination, amount, key()).status()).isEqualTo(400);
    }
    assertThat(submit(app, source, source, 1, key()).status()).isEqualTo(400);
    assertThat(
            db.post(app, "/api/transfers", PgTestSupport.transfer(source, destination, 1), null)
                .status())
        .isEqualTo(400);
    assertThat(
            db.post(app, "/api/transfers", PgTestSupport.transfer(source, destination, 1), " ")
                .status())
        .isEqualTo(400);
    assertThat(
            db.post(
                    app,
                    "/api/transfers",
                    PgTestSupport.transfer(source, destination, 1).replace("FIC", "USD"),
                    key())
                .status())
        .isEqualTo(400);
    assertThat(db.post(app, "/api/accounts", "{\"unit\":\"USD\"}", null).status()).isEqualTo(400);
    assertThat(db.post(app, "/api/transfers", "{", key()).status()).isEqualTo(400);
    var plainRequest =
        java.net.http.HttpRequest.newBuilder(java.net.URI.create(app.baseUrl() + "/api/transfers"))
            .timeout(java.time.Duration.ofSeconds(10))
            .header("Content-Type", "text/plain")
            .header("Idempotency-Key", key())
            .POST(
                java.net.http.HttpRequest.BodyPublishers.ofString(
                    PgTestSupport.transfer(source, destination, 1)))
            .build();
    var plainResponse =
        java.net.http.HttpClient.newHttpClient()
            .send(plainRequest, java.net.http.HttpResponse.BodyHandlers.ofString());
    assertThat(plainResponse.statusCode()).isEqualTo(415);
    assertThat(com.jayway.jsonpath.JsonPath.<String>read(plainResponse.body(), "$.code"))
        .isEqualTo("UNSUPPORTED_MEDIA_TYPE");
    var imageRequest =
        java.net.http.HttpRequest.newBuilder(
                java.net.URI.create(app.baseUrl() + "/api/accounts/" + source))
            .timeout(java.time.Duration.ofSeconds(10))
            .header("Accept", "image/png")
            .GET()
            .build();
    var imageResponse =
        java.net.http.HttpClient.newHttpClient()
            .send(imageRequest, java.net.http.HttpResponse.BodyHandlers.ofString());
    assertThat(imageResponse.statusCode()).isEqualTo(406);
    assertThat(com.jayway.jsonpath.JsonPath.<String>read(imageResponse.body(), "$.code"))
        .isEqualTo("NOT_ACCEPTABLE");
    String unacceptableTransferKey = key();
    var unacceptableTransferRequest =
        java.net.http.HttpRequest.newBuilder(java.net.URI.create(app.baseUrl() + "/api/transfers"))
            .timeout(java.time.Duration.ofSeconds(10))
            .header("Content-Type", "application/json")
            .header("Accept", "image/png")
            .header("Idempotency-Key", unacceptableTransferKey)
            .POST(
                java.net.http.HttpRequest.BodyPublishers.ofString(
                    PgTestSupport.transfer(source, destination, 1)))
            .build();
    var unacceptableTransferResponse =
        java.net.http.HttpClient.newHttpClient()
            .send(unacceptableTransferRequest, java.net.http.HttpResponse.BodyHandlers.ofString());
    assertThat(unacceptableTransferResponse.statusCode()).isEqualTo(406);
    assertThat(
            db.scalar(
                "SELECT count(*) FROM transfers WHERE idempotency_key=?", unacceptableTransferKey))
        .isZero();
    assertThat(
            db.post(
                    app,
                    "/api/transfers",
                    PgTestSupport.transfer(source, destination, 1)
                        .replace("\"amount\":1", "\"amount\":1.5"),
                    key())
                .status())
        .isEqualTo(400);
    assertThat(
            db.post(
                    app,
                    "/api/transfers",
                    "{\"sourceAccountId\":\""
                        + source
                        + "\",\"destinationAccountId\":\""
                        + destination
                        + "\",\"unit\":\"FIC\"}",
                    key())
                .status())
        .isEqualTo(400);
    assertThat(db.get(app, "/api/accounts/" + UUID.randomUUID()).status()).isEqualTo(404);
    assertThat(db.get(app, "/api/transfers/" + UUID.randomUUID()).status()).isEqualTo(404);
    var absentSource = submit(app, UUID.randomUUID(), destination, 1, key());
    var absentDestination = submit(app, source, UUID.randomUUID(), 1, key());
    assertThat(absentSource.status()).isEqualTo(422);
    assertThat(absentDestination.status()).isEqualTo(422);
    assertThat(absentSource.<String>json("$.rejectionCode")).isEqualTo("ACCOUNT_NOT_FOUND");
    assertThat(absentDestination.<String>json("$.rejectionCode")).isEqualTo("ACCOUNT_NOT_FOUND");
    assertReconciled();
  }

  @Test
  void ledgerPaginationUsesExclusiveCursorWithoutDuplicatesAndRejectsInvalidBounds()
      throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 100);
    for (int index = 0; index < 4; index++)
      assertThat(submit(app, source, destination, 1, key()).status()).isEqualTo(201);
    List<Long> ids = new ArrayList<>();
    long cursor = 0;
    for (int page = 0; page < 3; page++) {
      var response = db.get(app, "/api/accounts/" + source + "/ledger?limit=2&after=" + cursor);
      assertThat(response.status()).isEqualTo(200);
      List<Number> entries = response.json("$.items[*].id");
      for (Number entry : entries) {
        assertThat(entry.longValue()).isGreaterThan(cursor);
        ids.add(entry.longValue());
      }
      Number next = response.json("$.nextCursor");
      if (next == null) break;
      cursor = next.longValue();
    }
    assertThat(ids).hasSize(5).doesNotHaveDuplicates().isSorted();
    for (String query : List.of("limit=0", "limit=101", "after=-1", "after=nope")) {
      var invalid = db.get(app, "/api/accounts/" + source + "/ledger?" + query);
      assertThat(invalid.status()).isEqualTo(400);
      assertThat(invalid.<String>json("$.correlationId")).isNotBlank();
      assertThat(invalid.<String>json("$.code")).isNotBlank();
    }
  }

  @Test
  void frozenAccountsAndDestinationOverflowAreRejectedWithoutPostings() throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 100);
    db.execute("UPDATE accounts SET status='FROZEN' WHERE id=?", source);
    var frozen = submit(app, source, destination, 1, key());
    assertThat(frozen.status()).isEqualTo(422);
    assertThat(db.scalar("SELECT count(*) FROM ledger_entries WHERE transfer_id=?", frozen.id()))
        .isZero();
    db.execute("UPDATE accounts SET status='ACTIVE' WHERE id=?", source);
    db.execute("UPDATE accounts SET status='FROZEN' WHERE id=?", destination);
    assertThat(submit(app, source, destination, 1, key()).status()).isEqualTo(422);
    db.execute("UPDATE accounts SET status='ACTIVE' WHERE id=?", destination);
    fund(destination, 9_000_000_000_000_000L);
    var overflow = submit(app, source, destination, 1, key());
    assertThat(overflow.status()).isEqualTo(422);
    assertThat(balance(source)).isEqualTo(100);
    assertThat(balance(destination)).isEqualTo(9_000_000_000_000_000L);
    assertReconciled();
  }

  @Test
  void deterministicGeneratedTransferSequenceMatchesIndependentBalanceModel() throws Exception {
    List<UUID> accounts = new ArrayList<>();
    long[] expected = new long[6];
    for (int index = 0; index < expected.length; index++) {
      accounts.add(account());
      fund(accounts.get(index), 500);
      expected[index] = 500;
    }
    Random random = new Random(20261011L);
    for (int index = 0; index < 120; index++) {
      int source = random.nextInt(accounts.size());
      int destination = (source + 1 + random.nextInt(accounts.size() - 1)) % accounts.size();
      long amount = 1 + random.nextInt(600);
      String key = key();
      var result =
          submit(
              index % 2 == 0 ? app : peer,
              accounts.get(source),
              accounts.get(destination),
              amount,
              key);
      if (expected[source] >= amount) {
        assertThat(result.status()).isEqualTo(201);
        expected[source] -= amount;
        expected[destination] += amount;
      } else {
        assertThat(result.status()).isEqualTo(422);
      }
      if (index % 10 == 0) {
        var replay = submit(peer, accounts.get(source), accounts.get(destination), amount, key);
        assertThat(replay.body()).isEqualTo(result.body());
      }
    }
    for (int index = 0; index < expected.length; index++)
      assertThat(balance(accounts.get(index))).isEqualTo(expected[index]);
    assertThat(java.util.Arrays.stream(expected).sum()).isEqualTo(3_000);
    assertReconciled();
  }

  @Test
  void preCommitFaultsRollbackEveryPartialMutationAndAllowSafeRetry() throws Exception {
    for (Boundary boundary :
        List.of(
            Boundary.BEFORE_TRANSACTION, Boundary.AFTER_FIRST_POSTING, Boundary.BEFORE_COMMIT)) {
      UUID source = account();
      UUID destination = account();
      fund(source, 100);
      String key = key();
      faults.failOnce(boundary, new IllegalStateException("controlled test fault at " + boundary));
      var failed = submit(faultApp, source, destination, 10, key);
      assertThat(failed.status()).isEqualTo(500);
      assertThat(balance(source)).isEqualTo(100);
      assertThat(balance(destination)).isZero();
      assertThat(db.scalar("SELECT count(*) FROM transfers WHERE idempotency_key=?", key)).isZero();
      assertThat(submit(faultApp, source, destination, 10, key).status()).isEqualTo(201);
      assertThat(balance(source)).isEqualTo(90);
      assertThat(balance(destination)).isEqualTo(10);
      assertReconciled();
    }
  }

  @Test
  void lostHttpResponseAfterCommitIsRecoveredFromDurableIdempotency() throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 100);
    String key = key();
    faults.failOnce(
        Boundary.AFTER_COMMIT, new IllegalStateException("controlled lost response after commit"));
    assertThat(submit(faultApp, source, destination, 10, key).status()).isEqualTo(500);
    assertThat(balance(source)).isEqualTo(90);
    assertThat(balance(destination)).isEqualTo(10);
    var replay = submit(peer, source, destination, 10, key);
    assertThat(replay.status()).isEqualTo(200);
    assertThat(db.scalar("SELECT count(*) FROM ledger_entries WHERE transfer_id=?", replay.id()))
        .isEqualTo(2);
    assertReconciled();
  }

  @Test
  void actualClientHttpTimeoutAfterCommitCanRetryOnAnotherApplicationInstance() throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 100);
    String key = key();
    var pause = faults.pauseOnce(Boundary.AFTER_COMMIT);
    try (var executor = java.util.concurrent.Executors.newSingleThreadExecutor()) {
      var pending =
          executor.submit(
              () -> {
                var request =
                    java.net.http.HttpRequest.newBuilder(
                            java.net.URI.create(faultApp.baseUrl() + "/api/transfers"))
                        .timeout(java.time.Duration.ofMillis(500))
                        .header("Content-Type", "application/json")
                        .header("Idempotency-Key", key)
                        .POST(
                            java.net.http.HttpRequest.BodyPublishers.ofString(
                                PgTestSupport.transfer(source, destination, 10)))
                        .build();
                return java.net.http.HttpClient.newHttpClient()
                    .send(request, java.net.http.HttpResponse.BodyHandlers.ofString());
              });
      try {
        assertThat(pause.entered().await(5, java.util.concurrent.TimeUnit.SECONDS)).isTrue();
        assertThatThrownBy(() -> pending.get(5, java.util.concurrent.TimeUnit.SECONDS))
            .isInstanceOf(java.util.concurrent.ExecutionException.class)
            .hasCauseInstanceOf(java.net.http.HttpTimeoutException.class);
        assertThat(balance(source)).isEqualTo(90);
        assertThat(balance(destination)).isEqualTo(10);
        var replay = submit(peer, source, destination, 10, key);
        assertThat(replay.status()).isEqualTo(200);
        assertThat(
                db.scalar("SELECT count(*) FROM ledger_entries WHERE transfer_id=?", replay.id()))
            .isEqualTo(2);
      } finally {
        pause.released().countDown();
      }
    }
    assertReconciled();
  }

  @Test
  void duplicateReplayFaultDoesNotChangeCommittedResult() throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 100);
    String key = key();
    var committed = submit(faultApp, source, destination, 10, key);
    faults.failOnce(
        Boundary.BEFORE_REPLAY, new IllegalStateException("controlled duplicate response fault"));
    assertThat(submit(faultApp, source, destination, 10, key).status()).isEqualTo(500);
    assertThat(submit(peer, source, destination, 10, key).body()).isEqualTo(committed.body());
    assertThat(balance(source)).isEqualTo(90);
    assertThat(balance(destination)).isEqualTo(10);
    assertReconciled();
  }

  @Test
  void retryableDatabaseFailuresAreBoundedAndStatementTimeoutIsNotBlindlyRetried()
      throws Exception {
    for (String sqlState : List.of("40001", "40P01", "55P03")) {
      UUID source = account();
      UUID destination = account();
      fund(source, 100);
      faults.failOnce(
          Boundary.BEFORE_COMMIT,
          new RuntimeException(
              new SQLException("controlled transient database failure", sqlState)));
      assertThat(submit(faultApp, source, destination, 10, key()).status()).isEqualTo(201);
      assertThat(balance(source)).isEqualTo(90);
      assertThat(balance(destination)).isEqualTo(10);
    }
    UUID source = account();
    UUID destination = account();
    fund(source, 100);
    faults.failOnce(
        Boundary.BEFORE_COMMIT,
        new RuntimeException(new SQLException("controlled statement timeout", "57014")));
    String key = key();
    assertThat(submit(faultApp, source, destination, 10, key).status()).isEqualTo(503);
    assertThat(db.scalar("SELECT count(*) FROM transfers WHERE idempotency_key=?", key)).isZero();
    assertThat(balance(source)).isEqualTo(100);
    assertReconciled();
  }

  @Test
  void persistentRetryableFailureExhaustsThreeAttemptsWithoutPersistingFinancialState()
      throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 100);
    int before = faults.count(Boundary.BEFORE_COMMIT);
    faults.failTimes(
        Boundary.BEFORE_COMMIT,
        new RuntimeException(new SQLException("controlled serialization failure", "40001")),
        3);
    String key = key();
    var unavailable = submit(faultApp, source, destination, 10, key);
    assertThat(unavailable.status()).isEqualTo(503);
    assertThat(unavailable.<String>json("$.code")).isEqualTo("DEPENDENCY_UNAVAILABLE");
    assertThat(unavailable.headers().firstValue("Retry-After")).contains("1");
    assertThat(faults.count(Boundary.BEFORE_COMMIT) - before).isEqualTo(3);
    assertThat(db.scalar("SELECT count(*) FROM transfers WHERE idempotency_key=?", key)).isZero();
    assertThat(balance(source)).isEqualTo(100);
    assertThat(balance(destination)).isZero();
    assertThat(submit(peer, source, destination, 10, key).status()).isEqualTo(201);
    assertReconciled();
  }

  @Test
  void actualPostgresLockTimeoutRetriesFreshTransactionThenSucceedsAfterRelease() throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 100);
    var registry = faultApp.context().getBean(io.micrometer.core.instrument.MeterRegistry.class);
    double retriesBefore =
        registry.find("transfer.retries").counters().stream()
            .mapToDouble(io.micrometer.core.instrument.Counter::count)
            .sum();
    try (Connection blocker = db.connect();
        var executor = java.util.concurrent.Executors.newSingleThreadExecutor()) {
      blocker.setAutoCommit(false);
      lockBalance(blocker, source);
      var pending = executor.submit(() -> submit(faultApp, source, destination, 10, key()));
      waitForBlockedDatabaseConnection();
      Thread.sleep(
          250); // Cross the configured 200ms lock timeout, then release during the next attempt.
      blocker.rollback();
      assertThat(pending.get(10, java.util.concurrent.TimeUnit.SECONDS).status()).isEqualTo(201);
    }
    double retriesAfter =
        registry.find("transfer.retries").counters().stream()
            .mapToDouble(io.micrometer.core.instrument.Counter::count)
            .sum();
    assertThat(retriesAfter).isGreaterThan(retriesBefore);
    assertThat(balance(source)).isEqualTo(90);
    assertThat(balance(destination)).isEqualTo(10);
    assertReconciled();
  }

  @Test
  void actualPostgresLockTimeoutExhaustionReturns503AndSameKeyCanRecover() throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 100);
    String key = key();
    try (Connection blocker = db.connect();
        var executor = java.util.concurrent.Executors.newSingleThreadExecutor()) {
      blocker.setAutoCommit(false);
      lockBalance(blocker, source);
      var pending = executor.submit(() -> submit(faultApp, source, destination, 10, key));
      assertThat(pending.get(10, java.util.concurrent.TimeUnit.SECONDS).status()).isEqualTo(503);
      blocker.rollback();
    }
    assertThat(balance(source)).isEqualTo(100);
    assertThat(balance(destination)).isZero();
    assertThat(db.scalar("SELECT count(*) FROM transfers WHERE idempotency_key=?", key)).isZero();
    assertThat(submit(peer, source, destination, 10, key).status()).isEqualTo(201);
    assertReconciled();
  }

  @Test
  void actualPostgresStatementTimeoutIsClassifiedWithoutTransactionRetry() throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 100);
    try (var timeoutApp =
            db.start(
                TppApplication.class,
                Map.of(
                    "tpp.transfer.statement-timeout-ms",
                    "50",
                    "tpp.transfer.lock-timeout-ms",
                    "1000"));
        Connection blocker = db.connect();
        var executor = java.util.concurrent.Executors.newSingleThreadExecutor()) {
      blocker.setAutoCommit(false);
      lockBalance(blocker, source);
      String key = key();
      var pending = executor.submit(() -> submit(timeoutApp, source, destination, 10, key));
      var result = pending.get(10, java.util.concurrent.TimeUnit.SECONDS);
      assertThat(result.status()).isEqualTo(503);
      assertThat(
              timeoutApp
                  .context()
                  .getBean(io.micrometer.core.instrument.MeterRegistry.class)
                  .find("transfer.retries")
                  .counters())
          .isEmpty();
      blocker.rollback();
      assertThat(db.scalar("SELECT count(*) FROM transfers WHERE idempotency_key=?", key)).isZero();
    }
    assertThat(balance(source)).isEqualTo(100);
    assertReconciled();
  }

  @Test
  void actualSpringTransactionDeadlineRollsBackBothBalancesAndPartialJournal() throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 100);
    String key = key();
    try (var deadlineApp =
            db.start(
                TppApplication.class,
                Map.of("tpp.transfer.transaction-timeout-seconds", "1"),
                FaultConfiguration.class);
        var executor = java.util.concurrent.Executors.newSingleThreadExecutor()) {
      var deadlineFaults = deadlineApp.context().getBean(MutableFaults.class);
      var pause = deadlineFaults.pauseOnce(Boundary.AFTER_FIRST_POSTING);
      var pending = executor.submit(() -> submit(deadlineApp, source, destination, 10, key));
      try {
        assertThat(pause.entered().await(5, java.util.concurrent.TimeUnit.SECONDS)).isTrue();
        Thread.sleep(
            1_100); // Let Spring's one-second transaction deadline expire after a partial write.
      } finally {
        pause.released().countDown();
      }
      var result = pending.get(10, java.util.concurrent.TimeUnit.SECONDS);
      assertThat(result.status()).isEqualTo(503);
      assertThat(result.<String>json("$.code")).isEqualTo("DEPENDENCY_UNAVAILABLE");
      assertThat(
              deadlineApp
                  .context()
                  .getBean(io.micrometer.core.instrument.MeterRegistry.class)
                  .find("transfer.retries")
                  .counters())
          .isEmpty();
    }
    assertThat(db.scalar("SELECT count(*) FROM transfers WHERE idempotency_key=?", key)).isZero();
    assertThat(balance(source)).isEqualTo(100);
    assertThat(balance(destination)).isZero();
    assertThat(submit(peer, source, destination, 10, key).status()).isEqualTo(201);
    assertReconciled();
  }

  @Test
  void actualConnectionPoolExhaustionReturns503WithoutDurableRequestAndCanRecover()
      throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 100);
    String key = key();
    try (var smallPoolApp =
        db.start(
            TppApplication.class,
            Map.of(
                "spring.datasource.hikari.maximum-pool-size",
                "2",
                "spring.datasource.hikari.minimum-idle",
                "2",
                "spring.datasource.hikari.connection-timeout",
                "250"))) {
      var datasource = smallPoolApp.context().getBean(javax.sql.DataSource.class);
      try (Connection first = datasource.getConnection();
          Connection second = datasource.getConnection()) {
        var unavailable = submit(smallPoolApp, source, destination, 10, key);
        assertThat(unavailable.status()).isEqualTo(503);
        assertThat(unavailable.<String>json("$.code")).isEqualTo("DEPENDENCY_UNAVAILABLE");
        assertThat(db.scalar("SELECT count(*) FROM transfers WHERE idempotency_key=?", key))
            .isZero();
        assertThat(balance(source)).isEqualTo(100);
        assertThat(balance(destination)).isZero();
      }
      assertThat(submit(smallPoolApp, source, destination, 10, key).status()).isEqualTo(201);
    }
    assertReconciled();
  }

  @Test
  void databaseRejectsTerminalHistoryMutationAndLedgerRewrite() throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 100);
    var completed = submit(app, source, destination, 10, key());
    for (String sql :
        List.of(
            "UPDATE transfers SET amount=11 WHERE id=?",
            "UPDATE transfers SET status='REJECTED', rejection_code='TEST' WHERE id=?",
            "DELETE FROM transfers WHERE id=?",
            "UPDATE ledger_entries SET delta=delta+1 WHERE transfer_id=?",
            "DELETE FROM ledger_entries WHERE transfer_id=?")) {
      assertThatThrownBy(() -> db.execute(sql, completed.id())).isInstanceOf(SQLException.class);
    }
    assertThat(balance(source)).isEqualTo(90);
    assertThat(balance(destination)).isEqualTo(10);
    assertReconciled();
  }

  @Test
  void deferredDatabaseGuardsRejectIncompleteTransferAndUnbalancedProjectionAtCommit()
      throws Exception {
    UUID source = account();
    UUID destination = account();
    fund(source, 100);
    UUID transfer = UUID.randomUUID();
    assertCommitRejected(
        connection -> {
          insertProcessing(connection, transfer, source, destination, 10);
        });
    assertThat(db.scalar("SELECT count(*) FROM transfers WHERE id=?", transfer)).isZero();
    assertCommitRejected(
        connection -> {
          insertProcessing(connection, UUID.randomUUID(), source, destination, 10);
          try (PreparedStatement statement =
              connection.prepareStatement(
                  "UPDATE balances SET amount=amount-10 WHERE account_id=?")) {
            statement.setObject(1, source);
            statement.executeUpdate();
          }
        });
    assertCommitRejected(
        connection -> {
          UUID id = UUID.randomUUID();
          insertProcessing(connection, id, source, destination, 10);
          try (PreparedStatement statement =
              connection.prepareStatement(
                  "UPDATE transfers SET status='COMPLETED',completed_at=now() WHERE id=?")) {
            statement.setObject(1, id);
            statement.executeUpdate();
          }
        });
    assertThat(balance(source)).isEqualTo(100);
    assertThat(balance(destination)).isZero();
    assertReconciled();
  }

  @Test
  void databaseRequiresBalanceForEveryAccountAndRejectsDirectTerminalInsert() throws Exception {
    UUID orphan = UUID.randomUUID();
    assertCommitRejected(
        connection -> {
          try (PreparedStatement statement =
              connection.prepareStatement(
                  "INSERT INTO accounts(id,kind,status,unit) VALUES (?,'USER','ACTIVE','FIC')")) {
            statement.setObject(1, orphan);
            statement.executeUpdate();
          }
        });
    assertThat(db.scalar("SELECT count(*) FROM accounts WHERE id=?", orphan)).isZero();
    UUID source = account();
    UUID destination = account();
    assertThatThrownBy(
            () ->
                db.execute(
                    "INSERT INTO"
                        + " transfers(id,idempotency_key,source_account_id,destination_account_id,amount,unit,status,completed_at)"
                        + " VALUES (?,?,?,?,1,'FIC','COMPLETED',now())",
                    UUID.randomUUID(),
                    key(),
                    source,
                    destination))
        .isInstanceOf(SQLException.class);
    assertReconciled();
  }

  @Test
  void ordinaryDatabaseWritesCannotMakeUserBalanceNegativeOrInventValue() throws Exception {
    UUID account = account();
    assertThatThrownBy(
            () -> db.execute("UPDATE balances SET amount=-1 WHERE account_id=?", account))
        .isInstanceOf(SQLException.class);
    assertThatThrownBy(() -> db.execute("UPDATE balances SET amount=1 WHERE account_id=?", account))
        .isInstanceOf(SQLException.class);
    assertThat(balance(account)).isZero();
    assertReconciled();
  }

  @Test
  void reconciliationDetectsControlledPrivilegedCorruptionAndIsReadOnly() throws Exception {
    UUID account = account();
    fund(account, 100);
    db.execute("ALTER TABLE balances DISABLE TRIGGER balances_reconcile");
    try {
      db.execute("UPDATE balances SET amount=101 WHERE account_id=?", account);
    } finally {
      db.execute("ALTER TABLE balances ENABLE TRIGGER balances_reconcile");
    }
    try {
      var report = db.get(app, "/internal/reconciliation");
      assertThat(report.status()).isEqualTo(200);
      assertThat(report.<Boolean>json("$.consistent")).isFalse();
      assertThat(report.<List<?>>json("$.balanceMismatches")).isNotEmpty();
      assertThat(balance(account)).isEqualTo(101);
      assertThat(db.get(peer, "/internal/reconciliation").<Boolean>json("$.consistent")).isFalse();
    } finally {
      db.execute("ALTER TABLE balances DISABLE TRIGGER balances_reconcile");
      try {
        db.execute("UPDATE balances SET amount=100 WHERE account_id=?", account);
      } finally {
        db.execute("ALTER TABLE balances ENABLE TRIGGER balances_reconcile");
      }
    }
    assertReconciled();
  }

  private UUID account() throws Exception {
    var response = db.post(app, "/api/accounts", "{\"unit\":\"FIC\"}", null);
    assertThat(response.status()).isEqualTo(201);
    return response.id();
  }

  private void fund(UUID user, long amount) throws Exception {
    UUID issuance = UUID.randomUUID();
    UUID transfer = UUID.randomUUID();
    try (Connection connection = db.connect()) {
      connection.setAutoCommit(false);
      try (PreparedStatement account =
              connection.prepareStatement(
                  "INSERT INTO accounts(id,kind,status,unit) VALUES (?,'ISSUANCE','ACTIVE','FIC')");
          PreparedStatement balance =
              connection.prepareStatement("INSERT INTO balances(account_id,amount) VALUES (?,0)")) {
        account.setObject(1, issuance);
        account.executeUpdate();
        balance.setObject(1, issuance);
        balance.executeUpdate();
      }
      insertProcessing(connection, transfer, issuance, user, amount);
      try (PreparedStatement lock =
          connection.prepareStatement(
              "SELECT account_id FROM balances WHERE account_id IN (?,?) ORDER BY account_id FOR"
                  + " UPDATE")) {
        lock.setObject(1, issuance);
        lock.setObject(2, user);
        try (var rows = lock.executeQuery()) {
          while (rows.next()) {
            /* Acquire both ordered locks. */
          }
        }
      }
      try (PreparedStatement update =
              connection.prepareStatement(
                  "UPDATE balances SET amount=amount+? WHERE account_id=?");
          PreparedStatement posting =
              connection.prepareStatement(
                  "INSERT INTO ledger_entries(transfer_id,account_id,delta) VALUES (?,?,?)")) {
        for (var account : List.of(issuance, user)) {
          long delta = account.equals(issuance) ? -amount : amount;
          update.setLong(1, delta);
          update.setObject(2, account);
          update.executeUpdate();
          posting.setObject(1, transfer);
          posting.setObject(2, account);
          posting.setLong(3, delta);
          posting.executeUpdate();
        }
      }
      try (PreparedStatement complete =
          connection.prepareStatement(
              "UPDATE transfers SET status='COMPLETED', completed_at=now() WHERE id=?")) {
        complete.setObject(1, transfer);
        complete.executeUpdate();
      }
      connection.commit();
    }
  }

  private void insertProcessing(
      Connection connection, UUID transfer, UUID source, UUID destination, long amount)
      throws SQLException {
    try (PreparedStatement statement =
        connection.prepareStatement(
            "INSERT INTO"
                + " transfers(id,idempotency_key,source_account_id,destination_account_id,amount,unit,status)"
                + " VALUES (?,?,?,?,?,'FIC','PROCESSING')")) {
      statement.setObject(1, transfer);
      statement.setString(2, "test-issuance-" + transfer);
      statement.setObject(3, source);
      statement.setObject(4, destination);
      statement.setLong(5, amount);
      statement.executeUpdate();
    }
  }

  private void assertCommitRejected(SqlMutation mutation) throws Exception {
    try (Connection connection = db.connect()) {
      connection.setAutoCommit(false);
      mutation.run(connection);
      assertThatThrownBy(connection::commit).isInstanceOf(SQLException.class);
      connection.rollback();
    }
  }

  private void lockBalance(Connection connection, UUID account) throws SQLException {
    try (PreparedStatement statement =
        connection.prepareStatement(
            "SELECT account_id FROM balances WHERE account_id=? FOR UPDATE")) {
      statement.setObject(1, account);
      try (var rows = statement.executeQuery()) {
        assertThat(rows.next()).isTrue();
      }
    }
  }

  private void waitForBlockedDatabaseConnection() throws Exception {
    long deadline = System.nanoTime() + java.util.concurrent.TimeUnit.SECONDS.toNanos(5);
    while (System.nanoTime() < deadline) {
      if (db.scalar(
              "SELECT count(*) FROM pg_stat_activity WHERE datname=current_database() AND"
                  + " wait_event_type='Lock'")
          > 0) return;
      Thread.sleep(10);
    }
    throw new AssertionError("No real PostgreSQL connection became blocked on a row lock");
  }

  private long balance(UUID account) throws Exception {
    var result = db.get(app, "/api/accounts/" + account + "/balance");
    assertThat(result.status()).isEqualTo(200);
    return result.<Number>json("$.amount").longValue();
  }

  private PgTestSupport.Response submit(
      PgTestSupport.Application server, UUID source, UUID destination, long amount, String key)
      throws Exception {
    return db.post(
        server, "/api/transfers", PgTestSupport.transfer(source, destination, amount), key);
  }

  private void assertReconciled() throws Exception {
    var report = db.get(app, "/internal/reconciliation");
    assertThat(report.status()).isEqualTo(200);
    assertThat(report.<Boolean>json("$.consistent")).isTrue();
    assertThat(report.<List<?>>json("$.balanceMismatches")).isEmpty();
    assertThat(report.<List<?>>json("$.invalidTransfers")).isEmpty();
    assertThat(report.<Number>json("$.totalLedgerDelta").longValue()).isZero();
    assertThat(report.<Number>json("$.totalMaterializedBalance").longValue()).isZero();
    assertThat(db.scalar("SELECT count(*) FROM transfers WHERE status='PROCESSING'")).isZero();
    assertThat(
            db.scalar(
                "SELECT count(*) FROM (SELECT transfer_id FROM ledger_entries GROUP BY transfer_id"
                    + " HAVING count(*)<>2 OR sum(delta)<>0) broken"))
        .isZero();
    assertThat(
            db.scalar(
                "SELECT count(*) FROM balances b WHERE b.amount<>(SELECT COALESCE(sum(l.delta),0)"
                    + " FROM ledger_entries l WHERE l.account_id=b.account_id)"))
        .isZero();
  }

  private static String key() {
    return "test-" + UUID.randomUUID();
  }

  @FunctionalInterface
  interface SqlMutation {
    void run(Connection connection) throws SQLException;
  }

  @TestConfiguration(proxyBeanMethods = false)
  static class FaultConfiguration {
    @Bean
    @Primary
    MutableFaults mutableFaults() {
      return new MutableFaults();
    }
  }

  static class MutableFaults implements TransferFaults {
    private final ConcurrentHashMap<Boundary, FailurePlan> pending = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<Boundary, Pause> pauses = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<Boundary, AtomicInteger> invocations =
        new ConcurrentHashMap<>();

    void failOnce(Boundary boundary, RuntimeException failure) {
      failTimes(boundary, failure, 1);
    }

    void failTimes(Boundary boundary, RuntimeException failure, int times) {
      pending.put(boundary, new FailurePlan(failure, new AtomicInteger(times)));
    }

    int count(Boundary boundary) {
      return invocations.getOrDefault(boundary, new AtomicInteger()).get();
    }

    Pause pauseOnce(Boundary boundary) {
      var pause =
          new Pause(
              new java.util.concurrent.CountDownLatch(1),
              new java.util.concurrent.CountDownLatch(1));
      pauses.put(boundary, pause);
      return pause;
    }

    @Override
    public void at(Boundary boundary) {
      invocations.computeIfAbsent(boundary, ignored -> new AtomicInteger()).incrementAndGet();
      var pause = pauses.remove(boundary);
      if (pause != null) {
        pause.entered().countDown();
        try {
          if (!pause.released().await(10, java.util.concurrent.TimeUnit.SECONDS))
            throw new IllegalStateException("Test response pause expired");
        } catch (InterruptedException error) {
          Thread.currentThread().interrupt();
          throw new IllegalStateException(error);
        }
      }
      var plan = pending.get(boundary);
      if (plan != null && plan.remaining().getAndDecrement() > 0) {
        if (plan.remaining().get() == 0) pending.remove(boundary, plan);
        throw plan.failure();
      }
    }

    record FailurePlan(RuntimeException failure, AtomicInteger remaining) {}

    record Pause(
        java.util.concurrent.CountDownLatch entered,
        java.util.concurrent.CountDownLatch released) {}
  }
}
