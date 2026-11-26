package dev.tpp.application;

import static dev.tpp.application.TransferFaults.Boundary.*;

import dev.tpp.domain.ApiException;
import dev.tpp.domain.Models.*;
import dev.tpp.domain.TransferCommand;
import dev.tpp.domain.TransferStatus;
import dev.tpp.persistence.LedgerStore;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Timer;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.support.TransactionTemplate;

@Service
public class TransferService {
  private static final Logger LOG = LoggerFactory.getLogger(TransferService.class);
  private final LedgerStore store;
  private final JdbcTemplate jdbc;
  private final TransactionTemplate transaction;
  private final TransferSettings settings;
  private final TransferFaults faults;
  private final MeterRegistry metrics;
  private final BacklogAdmission admission;

  public TransferService(
      LedgerStore store,
      JdbcTemplate jdbc,
      PlatformTransactionManager manager,
      TransferSettings settings,
      TransferFaults faults,
      MeterRegistry metrics,
      BacklogAdmission admission) {
    this.store = store;
    this.jdbc = jdbc;
    this.settings = settings;
    this.faults = faults;
    this.metrics = metrics;
    this.admission = admission;
    transaction = new TransactionTemplate(manager);
    transaction.setIsolationLevel(TransactionDefinition.ISOLATION_READ_COMMITTED);
    transaction.setTimeout(settings.transactionTimeoutSeconds());
  }

  public Transfer get(UUID id) {
    return store.transfer(id);
  }

  public Submission submit(String key, TransferCommand command) {
    TransferCommand.validateKey(key);
    Timer.Sample request = Timer.start(metrics);
    try {
      faults.at(BEFORE_TRANSACTION);
      for (int attempt = 1; attempt <= settings.maxAttempts(); attempt++) {
        Submission result;
        Timer.Sample duration = Timer.start(metrics);
        try {
          // execute returns only after PostgreSQL commit and deferred constraint checks succeed.
          result = transaction.execute(status -> execute(key, command));
          duration.stop(metrics.timer("transfer.transaction", "outcome", "commit"));
        } catch (RuntimeException error) {
          duration.stop(metrics.timer("transfer.transaction", "outcome", "rollback"));
          if (!DatabaseErrors.sqlState(error).equals("unknown"))
            metrics
                .counter("database.errors", "sqlstate", DatabaseErrors.metricState(error))
                .increment();
          if (DatabaseErrors.retryable(error) && attempt < settings.maxAttempts()) {
            metrics
                .counter("transfer.retries", "sqlstate", DatabaseErrors.metricState(error))
                .increment();
            LOG.warn(
                "Transfer transaction retry attempt={} sqlstate={}",
                attempt,
                DatabaseErrors.metricState(error));
            backoff(attempt);
            continue;
          }
          if (DatabaseErrors.dependencyUnavailable(error))
            throw new ApiException(
                503,
                "DEPENDENCY_UNAVAILABLE",
                "Database operation unavailable; retry with the same Idempotency-Key",
                error);
          throw error;
        }
        faults.at(
            AFTER_COMMIT); // Deliberately outside the retry loop's catch: commit may already have
        // applied.
        String outcome =
            result.replay()
                ? "replayed"
                : result.transfer().status() == TransferStatus.COMPLETED ? "completed" : "rejected";
        metrics.counter("transfer.outcomes", "outcome", outcome).increment();
        LOG.info(
            "Transfer result id={} status={} replay={}",
            result.transfer().id(),
            result.transfer().status(),
            result.replay());
        return result;
      }
      throw new IllegalStateException("Retry loop exhausted");
    } finally {
      request.stop(metrics.timer("transfer.requests"));
    }
  }

  private Submission execute(String key, TransferCommand command) {
    // Timeouts are per attempt; transaction-local settings cannot leak across pooled connections.
    jdbc.queryForObject(
        "SELECT set_config('lock_timeout',?,true)", String.class, settings.lockTimeoutMs() + "ms");
    jdbc.queryForObject(
        "SELECT set_config('statement_timeout',?,true)",
        String.class,
        settings.statementTimeoutMs() + "ms");
    jdbc.queryForObject(
        "SELECT set_config('tpp.correlation_id',?,true)",
        String.class,
        MDC.get("correlationId") == null ? "application-transfer" : MDC.get("correlationId"));
    UUID id = UUID.randomUUID();
    if (store.reserve(id, key, command) == 0) {
      // ON CONFLICT waits for the reserving transaction. READ COMMITTED's next statement sees its
      // result.
      Transfer prior =
          store
              .byKey(key)
              .orElseThrow(() -> new IllegalStateException("Committed idempotency result missing"));
      if (!prior.matches(command))
        throw new ApiException(
            409,
            "IDEMPOTENCY_CONFLICT",
            "Idempotency-Key was already used with a different payload");
      faults.at(BEFORE_REPLAY);
      return new Submission(prior, true);
    }
    // A denied new reservation rolls back; existing-key replay/conflict bypasses admission.
    admission.requireCapacity();
    List<LockedAccount> accounts = store.lockAccounts(command);
    String rejection = reject(command, accounts);
    if (rejection != null) {
      store.finish(id, TransferStatus.REJECTED, rejection);
    } else {
      store.changeBalance(command.sourceAccountId(), -command.amount());
      store.changeBalance(command.destinationAccountId(), command.amount());
      store.post(id, command.sourceAccountId(), -command.amount());
      faults.at(AFTER_FIRST_POSTING);
      store.post(id, command.destinationAccountId(), command.amount());
      store.finish(id, TransferStatus.COMPLETED, null);
    }
    faults.at(BEFORE_COMMIT);
    return new Submission(store.transfer(id), false);
  }

  private String reject(TransferCommand command, List<LockedAccount> accounts) {
    if (accounts.size() != 2) return "ACCOUNT_NOT_FOUND";
    if (accounts.stream().anyMatch(a -> !a.kind().equals("USER")))
      return "ACCOUNT_NOT_TRANSFERABLE";
    if (accounts.stream().anyMatch(a -> !a.status().equals("ACTIVE"))) return "ACCOUNT_INACTIVE";
    if (accounts.stream().anyMatch(a -> !a.unit().equals(command.unit()))) return "UNIT_MISMATCH";
    LockedAccount source =
        accounts.stream()
            .filter(a -> a.id().equals(command.sourceAccountId()))
            .findFirst()
            .orElseThrow();
    LockedAccount destination =
        accounts.stream()
            .filter(a -> a.id().equals(command.destinationAccountId()))
            .findFirst()
            .orElseThrow();
    if (source.amount() < command.amount()) return "INSUFFICIENT_FUNDS";
    if (destination.amount() > TransferCommand.MAX_AMOUNT - command.amount())
      return "BALANCE_LIMIT_EXCEEDED";
    return null;
  }

  private void backoff(int attempt) {
    long ms = (long) settings.backoffMs() * (1L << (attempt - 1));
    try {
      Thread.sleep(ms + ThreadLocalRandom.current().nextLong(settings.backoffMs() + 1));
    } catch (InterruptedException error) {
      Thread.currentThread().interrupt();
      throw new ApiException(
          503,
          "DEPENDENCY_UNAVAILABLE",
          "Request interrupted; retry with the same Idempotency-Key",
          error);
    }
  }
}
