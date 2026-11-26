package dev.tpp;

import static org.assertj.core.api.Assertions.assertThat;

import dev.tpp.application.DatabaseErrors;
import java.sql.SQLException;
import java.sql.SQLTransientConnectionException;
import org.junit.jupiter.api.Test;
import org.springframework.jdbc.CannotGetJdbcConnectionException;
import org.springframework.transaction.TransactionTimedOutException;

class DatabaseErrorsTest {
  @Test
  void onlyKnownTransactionFailuresAreRetriedThroughNestedCauses() {
    for (String state : new String[] {"40001", "40P01", "55P03"}) {
      var failure =
          new IllegalStateException(new RuntimeException(new SQLException("test", state)));
      assertThat(DatabaseErrors.sqlState(failure)).isEqualTo(state);
      assertThat(DatabaseErrors.retryable(failure)).isTrue();
      assertThat(DatabaseErrors.dependencyUnavailable(failure)).isTrue();
    }
    for (String state :
        new String[] {
          "57014", "57P01", "57P02", "57P03", "23505", "23514", "23503", "08006", "XX000"
        }) {
      assertThat(DatabaseErrors.retryable(new SQLException("test", state)))
          .as("SQLSTATE %s", state)
          .isFalse();
    }
    assertThat(DatabaseErrors.retryable(new IllegalArgumentException())).isFalse();
  }

  @Test
  void timeoutsAndConnectionExhaustionRemainInfrastructureFailures() {
    assertThat(DatabaseErrors.dependencyUnavailable(new SQLException("canceled", "57014")))
        .isTrue();
    assertThat(DatabaseErrors.dependencyUnavailable(new SQLException("lost connection", "08006")))
        .isTrue();
    assertThat(
            DatabaseErrors.dependencyUnavailable(
                new RuntimeException(new SQLTransientConnectionException("pool exhausted"))))
        .isTrue();
    assertThat(
            DatabaseErrors.dependencyUnavailable(
                new CannotGetJdbcConnectionException("pool exhausted")))
        .isTrue();
    var deadline =
        new IllegalStateException(new TransactionTimedOutException("transaction deadline expired"));
    assertThat(DatabaseErrors.dependencyUnavailable(deadline)).isTrue();
    assertThat(DatabaseErrors.retryable(deadline)).isFalse();
    for (String state : new String[] {"57P01", "57P02", "57P03"}) {
      var shutdown = new IllegalStateException(new SQLException("database restarting", state));
      assertThat(DatabaseErrors.dependencyUnavailable(shutdown)).isTrue();
      assertThat(DatabaseErrors.retryable(shutdown)).isFalse();
    }
    assertThat(DatabaseErrors.dependencyUnavailable(new SQLException("bad constraint", "23514")))
        .isFalse();
    assertThat(
            DatabaseErrors.dependencyUnavailable(new IllegalStateException("programming failure")))
        .isFalse();
  }

  @Test
  void metricsUseBoundedLabelsWithoutLeakingArbitrarySqlStates() {
    assertThat(DatabaseErrors.metricState(new SQLException("test", "40001"))).isEqualTo("40001");
    assertThat(DatabaseErrors.metricState(new SQLException("test", "08006")))
        .isEqualTo("connection");
    assertThat(DatabaseErrors.metricState(new SQLException("test", "XX123"))).isEqualTo("other");
    assertThat(DatabaseErrors.metricState(new IllegalArgumentException())).isEqualTo("other");
    assertThat(DatabaseErrors.sqlState(new IllegalArgumentException())).isEqualTo("unknown");
  }
}
