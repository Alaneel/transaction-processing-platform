package dev.tpp.application;

import java.sql.SQLException;
import java.sql.SQLTransientConnectionException;
import java.util.Set;
import org.springframework.jdbc.CannotGetJdbcConnectionException;
import org.springframework.transaction.TransactionTimedOutException;

public final class DatabaseErrors {
  private static final Set<String> RETRYABLE = Set.of("40001", "40P01", "55P03");
  private static final Set<String> CLASSIFIED =
      Set.of(
          "40001", "40P01", "55P03", "57014", "57P01", "57P02", "57P03", "23514", "23505", "23503");

  private DatabaseErrors() {}

  public static String sqlState(Throwable error) {
    for (Throwable cursor = error; cursor != null; cursor = cursor.getCause())
      if (cursor instanceof SQLException sql && sql.getSQLState() != null) return sql.getSQLState();
    return "unknown";
  }

  public static boolean retryable(Throwable error) {
    return RETRYABLE.contains(sqlState(error));
  }

  public static boolean dependencyUnavailable(Throwable error) {
    String state = sqlState(error);
    if (RETRYABLE.contains(state)
        || Set.of("57014", "57P01", "57P02", "57P03").contains(state)
        || state.startsWith("08")) return true;
    for (Throwable cursor = error; cursor != null; cursor = cursor.getCause())
      if (cursor instanceof CannotGetJdbcConnectionException
          || cursor instanceof SQLTransientConnectionException
          || cursor instanceof TransactionTimedOutException) return true;
    return false;
  }

  public static String metricState(Throwable error) {
    String state = sqlState(error);
    return CLASSIFIED.contains(state) ? state : state.startsWith("08") ? "connection" : "other";
  }
}
