package dev.tpp.events;

import dev.tpp.domain.TransferStatus;
import dev.tpp.events.TransferDeliveryController.DeliveryState;
import dev.tpp.events.TransferDeliveryController.EventProgress;
import dev.tpp.events.TransferDeliveryController.PublicationStatus;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Instant;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.UUID;
import org.springframework.http.CacheControl;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/** Attention within a recent fixed demo sample, not a total backlog or history search. */
@RestController
public class DemoDeliveryAttentionController {
  private static final int SAMPLE_LIMIT = 50;
  private static final UUID ALICE = UUID.fromString("00000000-0000-0000-0000-000000000002");
  private static final UUID BOB = UUID.fromString("00000000-0000-0000-0000-000000000003");
  private static final String FIND_SAMPLE =
      """
      WITH recent AS MATERIALIZED (
        SELECT * FROM (
          (SELECT id, completed_at AS decided_at, amount, unit,
                  source_account_id, destination_account_id
           FROM transfers
           WHERE source_account_id = ? AND destination_account_id = ?
             AND status = 'COMPLETED'
           ORDER BY completed_at DESC, id DESC LIMIT 50)
          UNION ALL
          (SELECT id, completed_at AS decided_at, amount, unit,
                  source_account_id, destination_account_id
           FROM transfers
           WHERE source_account_id = ? AND destination_account_id = ?
             AND status = 'COMPLETED'
           ORDER BY completed_at DESC, id DESC LIMIT 50)
        ) directions
        ORDER BY decided_at DESC, id DESC LIMIT 50
      )
      SELECT t.id, t.decided_at, t.amount, t.unit,
             t.source_account_id, t.destination_account_id,
             o.event_id, o.status AS publication_status, o.attempt_count,
             o.last_error_code, o.next_attempt_at, o.published_at,
             i.event_id AS inbox_event_id, i.processed_at,
             p.event_id AS projection_event_id, p.projected_at
      FROM recent t
      LEFT JOIN outbox_events o ON o.transfer_id = t.id
      LEFT JOIN event_inbox i ON i.transfer_id = t.id
      LEFT JOIN transfer_activity_projection p ON p.transfer_id = t.id
      """;

  private final JdbcTemplate jdbc;
  private final TransactionTemplate read;

  public DemoDeliveryAttentionController(
      JdbcTemplate jdbc, PlatformTransactionManager manager, EventSettings settings) {
    this.jdbc = jdbc;
    read = new TransactionTemplate(manager);
    read.setReadOnly(true);
    read.setTimeout(settings.dbTimeoutSeconds());
  }

  // Declaration order is the queue's severity order.
  public enum AttentionState {
    INCONSISTENT,
    BLOCKED,
    PUBLICATION_UNCONFIRMED,
    AWAITING_PUBLICATION,
    AWAITING_PROJECTION
  }

  public record AttentionItem(
      UUID transferId,
      Instant decidedAt,
      long amount,
      String unit,
      UUID sourceAccountId,
      UUID destinationAccountId,
      AttentionState attentionState,
      PublicationStatus publicationStatus,
      Integer attemptCount,
      String lastErrorCode,
      Instant nextAttemptAt) {}

  public record Attention(int sampleLimit, int sampledCount, List<AttentionItem> items) {
    public Attention {
      items = List.copyOf(items);
    }
  }

  private record Candidate(AttentionItem attention) {}

  @GetMapping(
      value = "/internal/demo/delivery-attention",
      produces = MediaType.APPLICATION_JSON_VALUE)
  public ResponseEntity<Attention> inspect() {
    var attention =
        Objects.requireNonNull(
            read.execute(
                transaction -> {
                  // Sample before joining. Each joined transfer key is unique, so one
                  // statement observes at most 50 candidates in one PostgreSQL snapshot.
                  var candidates =
                      jdbc.query(
                          FIND_SAMPLE, (row, index) -> mapCandidate(row), ALICE, BOB, BOB, ALICE);
                  var items =
                      candidates.stream()
                          .map(Candidate::attention)
                          .filter(Objects::nonNull)
                          .sorted(
                              Comparator.comparing(AttentionItem::attentionState)
                                  .thenComparing(AttentionItem::decidedAt)
                                  .thenComparing(AttentionItem::transferId))
                          .toList();
                  return new Attention(SAMPLE_LIMIT, candidates.size(), items);
                }));
    return ResponseEntity.ok().cacheControl(CacheControl.noStore()).body(attention);
  }

  private static Candidate mapCandidate(ResultSet row) throws SQLException {
    UUID eventId = row.getObject("event_id", UUID.class);
    UUID inboxId = row.getObject("inbox_event_id", UUID.class);
    UUID projectionId = row.getObject("projection_event_id", UUID.class);
    PublicationStatus publication =
        eventId == null ? null : PublicationStatus.valueOf(row.getString("publication_status"));
    Integer attempts = row.getObject("attempt_count", Integer.class);
    String error = row.getString("last_error_code");
    Instant next = publication == PublicationStatus.PENDING ? instant(row, "next_attempt_at") : null;
    var event =
        eventId == null
            ? null
            : new EventProgress(
                eventId,
                publication,
                Objects.requireNonNull(attempts),
                next,
                error,
                instant(row, "published_at"),
                eventId.equals(inboxId) ? instant(row, "processed_at") : null,
                eventId.equals(projectionId) ? instant(row, "projected_at") : null);
    var point =
        TransferDeliveryController.deliveryState(
            TransferStatus.COMPLETED, event, inboxId, projectionId);
    var state = attentionState(point, publication);
    if (state == null) return new Candidate(null);
    return new Candidate(
        new AttentionItem(
            row.getObject("id", UUID.class),
            Objects.requireNonNull(instant(row, "decided_at")),
            row.getLong("amount"),
            row.getString("unit"),
            row.getObject("source_account_id", UUID.class),
            row.getObject("destination_account_id", UUID.class),
            state,
            publication,
            attempts,
            error,
            next));
  }

  private static AttentionState attentionState(
      DeliveryState point, PublicationStatus publication) {
    if (point == DeliveryState.INCONSISTENT) return AttentionState.INCONSISTENT;
    if (publication == PublicationStatus.BLOCKED) return AttentionState.BLOCKED;
    return switch (point) {
      case PROJECTED ->
          publication == PublicationStatus.PUBLISHED
              ? null
              : AttentionState.PUBLICATION_UNCONFIRMED;
      case AWAITING_PUBLICATION -> AttentionState.AWAITING_PUBLICATION;
      case AWAITING_PROJECTION -> AttentionState.AWAITING_PROJECTION;
      default -> throw new IllegalStateException("Unexpected completed-transfer delivery state");
    };
  }

  private static Instant instant(ResultSet row, String column) throws SQLException {
    var value = row.getTimestamp(column);
    return value == null ? null : value.toInstant();
  }
}
