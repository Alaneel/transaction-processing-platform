package dev.tpp.events.consumer;

import dev.tpp.domain.ApiException;
import dev.tpp.events.EventSettings;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.support.TransactionTemplate;

/**
 * Independently queryable eventually consistent activity and consistent-snapshot reconciliation.
 */
@Service
public class ProjectionService {
  private final JdbcTemplate jdbc;
  private final TransactionTemplate snapshot;

  public ProjectionService(
      JdbcTemplate jdbc, PlatformTransactionManager manager, EventSettings settings) {
    this.jdbc = jdbc;
    snapshot = new TransactionTemplate(manager);
    snapshot.setReadOnly(true);
    snapshot.setIsolationLevel(TransactionDefinition.ISOLATION_REPEATABLE_READ);
    snapshot.setTimeout(settings.dbTimeoutSeconds());
  }

  public record Activity(
      long id,
      UUID eventId,
      UUID transferId,
      UUID accountId,
      long deltaMinor,
      String unit,
      Instant occurredAt,
      Instant projectedAt) {}

  public record ActivityPage(
      UUID accountId, List<Activity> entries, Long nextAfter, boolean eventuallyConsistent) {
    public ActivityPage {
      entries = List.copyOf(entries);
    }
  }

  public record Report(
      long completedTransfers,
      long processedEvents,
      long projectedTransfers,
      long quarantinedRecords,
      long missingProjection,
      long publishedAwaitingProjection,
      long inboxWithoutProjection,
      long projectionWithoutInbox,
      long activityShapeDiscrepancies,
      long originDiscrepancies,
      long discrepancies,
      Double oldestUnprocessedAgeSeconds,
      Instant lastProcessedAt,
      Instant lastProcessedEventOccurredAt,
      Instant checkedAt) {}

  public ActivityPage activity(UUID accountId, long after, int limit) {
    QuarantineService.validatePage(after, limit);
    return snapshot.execute(
        status -> {
          if (java.util.Objects.requireNonNull(
                  jdbc.queryForObject(
                      "SELECT count(*) FROM accounts WHERE id=? AND kind='USER'",
                      Long.class,
                      accountId))
              != 1) throw new ApiException(404, "ACCOUNT_NOT_FOUND", "Account does not exist");
          var rows =
              jdbc.query(
                  """
                  SELECT * FROM account_activity WHERE account_id=? AND id>? ORDER BY id LIMIT ?
                  """,
                  (row, index) ->
                      new Activity(
                          row.getLong("id"),
                          row.getObject("event_id", UUID.class),
                          row.getObject("transfer_id", UUID.class),
                          accountId,
                          row.getLong("delta_minor"),
                          row.getString("unit"),
                          row.getTimestamp("occurred_at").toInstant(),
                          row.getTimestamp("projected_at").toInstant()),
                  accountId,
                  after,
                  limit + 1);
          boolean more = rows.size() > limit;
          List<Activity> entries = more ? List.copyOf(rows.subList(0, limit)) : List.copyOf(rows);
          return new ActivityPage(accountId, entries, more ? entries.getLast().id() : null, true);
        });
  }

  public Report reconcile() {
    return snapshot.execute(
        status -> {
          long completed = count("SELECT count(*) FROM transfers WHERE status='COMPLETED'");
          long processed = count("SELECT count(*) FROM event_inbox");
          long projected = count("SELECT count(*) FROM transfer_activity_projection");
          long quarantined = count("SELECT count(*) FROM event_quarantine");
          long missing =
              count(
                  """
                  SELECT count(*) FROM transfers t LEFT JOIN transfer_activity_projection p ON p.transfer_id=t.id
                  WHERE t.status='COMPLETED' AND p.transfer_id IS NULL
                  """);
          long publishedAwaiting =
              count(
                  """
                  SELECT count(*) FROM outbox_events o LEFT JOIN event_inbox i ON i.event_id=o.event_id
                  WHERE o.status='PUBLISHED' AND i.event_id IS NULL
                  """);
          long orphanInbox =
              count(
                  """
                  SELECT count(*) FROM event_inbox i LEFT JOIN transfer_activity_projection p ON p.event_id=i.event_id
                  WHERE p.event_id IS NULL
                  """);
          long orphanProjection =
              count(
                  """
                  SELECT count(*) FROM transfer_activity_projection p LEFT JOIN event_inbox i ON i.event_id=p.event_id
                  WHERE i.event_id IS NULL
                  """);
          long activity =
              count(
                  """
                  SELECT count(*) FROM transfer_activity_projection p WHERE
                  (SELECT count(*) FROM account_activity a WHERE a.event_id=p.event_id)<>2 OR
                  NOT EXISTS (SELECT 1 FROM account_activity a WHERE a.event_id=p.event_id AND a.transfer_id=p.transfer_id
                    AND a.account_id=p.source_account_id AND a.delta_minor=-p.amount_minor AND a.unit=p.unit AND a.occurred_at=p.occurred_at) OR
                  NOT EXISTS (SELECT 1 FROM account_activity a WHERE a.event_id=p.event_id AND a.transfer_id=p.transfer_id
                    AND a.account_id=p.destination_account_id AND a.delta_minor=p.amount_minor AND a.unit=p.unit AND a.occurred_at=p.occurred_at)
                  """);
          long origins =
              count(
                  """
                  SELECT count(*) FROM transfer_activity_projection p
                  JOIN transfers t ON t.id=p.transfer_id LEFT JOIN outbox_events o ON o.transfer_id=t.id
                  WHERE t.status<>'COMPLETED' OR o.event_id IS DISTINCT FROM p.event_id OR
                  ROW(p.source_account_id,p.destination_account_id,p.amount_minor,p.unit,p.occurred_at)
                    IS DISTINCT FROM ROW(t.source_account_id,t.destination_account_id,t.amount,t.unit,t.completed_at)
                  """);
          Double oldest =
              jdbc.queryForObject(
                  """
                  SELECT EXTRACT(EPOCH FROM (clock_timestamp()-min(o.created_at)))::double precision
                  FROM outbox_events o LEFT JOIN event_inbox i ON i.event_id=o.event_id WHERE i.event_id IS NULL
                  """,
                  Double.class);
          Instant last =
              jdbc.queryForObject(
                  "SELECT max(processed_at) FROM event_inbox", (row, index) -> instant(row, 1));
          Instant lastOccurred =
              jdbc.queryForObject(
                  "SELECT max(occurred_at) FROM transfer_activity_projection",
                  (row, index) -> instant(row, 1));
          return new Report(
              completed,
              processed,
              projected,
              quarantined,
              missing,
              publishedAwaiting,
              orphanInbox,
              orphanProjection,
              activity,
              origins,
              orphanInbox + orphanProjection + activity + origins,
              oldest,
              last,
              lastOccurred,
              Instant.now());
        });
  }

  private long count(String sql) {
    return java.util.Objects.requireNonNull(jdbc.queryForObject(sql, Long.class));
  }

  private static Instant instant(java.sql.ResultSet row, int column) throws java.sql.SQLException {
    var time = row.getTimestamp(column);
    return time == null ? null : time.toInstant();
  }
}
