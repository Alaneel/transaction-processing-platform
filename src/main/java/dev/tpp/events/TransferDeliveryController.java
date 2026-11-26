package dev.tpp.events;

import dev.tpp.domain.ApiException;
import dev.tpp.domain.TransferStatus;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Instant;
import java.util.UUID;
import org.springframework.http.CacheControl;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

/** A point inspection of a transfer across its durable stages, without contacting Kafka. */
@RestController
public class TransferDeliveryController {
  private static final String FIND_DELIVERY =
      """
      SELECT t.id, t.status AS transfer_status, t.completed_at,
             o.event_id, o.status AS publication_status, o.attempt_count,
             o.next_attempt_at, o.last_error_code, o.published_at,
             i.event_id AS inbox_event_id, i.processed_at,
             p.event_id AS projection_event_id, p.projected_at
      FROM transfers t
      LEFT JOIN outbox_events o ON o.transfer_id = t.id
      LEFT JOIN event_inbox i ON i.transfer_id = t.id
      LEFT JOIN transfer_activity_projection p ON p.transfer_id = t.id
      WHERE t.id = ? AND t.status IN ('COMPLETED', 'REJECTED')
      """;

  private final JdbcTemplate jdbc;
  private final TransactionTemplate read;

  public TransferDeliveryController(
      JdbcTemplate jdbc, PlatformTransactionManager manager, EventSettings settings) {
    this.jdbc = jdbc;
    read = new TransactionTemplate(manager);
    read.setReadOnly(true);
    read.setTimeout(settings.dbTimeoutSeconds());
  }

  public enum DeliveryState {
    NOT_APPLICABLE,
    AWAITING_PUBLICATION,
    AWAITING_PROJECTION,
    BLOCKED,
    PROJECTED,
    INCONSISTENT
  }

  public enum PublicationStatus {
    PENDING,
    CLAIMED,
    PUBLISHED,
    BLOCKED
  }

  public record Delivery(
      UUID transferId,
      TransferStatus transferStatus,
      Instant decidedAt,
      DeliveryState deliveryState,
      EventProgress event) {}

  public record EventProgress(
      UUID eventId,
      PublicationStatus publicationStatus,
      int attemptCount,
      Instant nextAttemptAt,
      String lastErrorCode,
      Instant publishedAt,
      Instant processedAt,
      Instant projectedAt) {}

  @GetMapping(
      value = "/internal/transfers/{id}/delivery",
      produces = MediaType.APPLICATION_JSON_VALUE)
  public ResponseEntity<Delivery> inspect(@PathVariable UUID id) {
    // A single SELECT sees one PostgreSQL snapshot. Each join key is unique.
    var delivery =
        read.execute(
            transaction ->
                jdbc.query(FIND_DELIVERY, (row, index) -> mapDelivery(row), id).stream()
                    .findFirst()
                    .orElseThrow(
                        () -> new ApiException(404, "TRANSFER_NOT_FOUND", "Transfer does not exist")));
    return ResponseEntity.ok().cacheControl(CacheControl.noStore()).body(delivery);
  }

  private static Delivery mapDelivery(ResultSet row) throws SQLException {
    UUID eventId = row.getObject("event_id", UUID.class);
    UUID inboxId = row.getObject("inbox_event_id", UUID.class);
    UUID projectionId = row.getObject("projection_event_id", UUID.class);
    var transferStatus = TransferStatus.valueOf(row.getString("transfer_status"));
    EventProgress event = null;
    if (eventId != null) {
      var publicationStatus = PublicationStatus.valueOf(row.getString("publication_status"));
      event =
          new EventProgress(
              eventId,
              publicationStatus,
              row.getInt("attempt_count"),
              publicationStatus == PublicationStatus.PENDING ? instant(row, "next_attempt_at") : null,
              row.getString("last_error_code"),
              instant(row, "published_at"),
              eventId.equals(inboxId) ? instant(row, "processed_at") : null,
              eventId.equals(projectionId) ? instant(row, "projected_at") : null);
    }
    return new Delivery(
        row.getObject("id", UUID.class),
        transferStatus,
        instant(row, "completed_at"),
        deliveryState(transferStatus, event, inboxId, projectionId),
        event);
  }

  private static DeliveryState deliveryState(
      TransferStatus transferStatus, EventProgress event, UUID inboxId, UUID projectionId) {
    if (transferStatus == TransferStatus.REJECTED) {
      return event == null && inboxId == null && projectionId == null
          ? DeliveryState.NOT_APPLICABLE
          : DeliveryState.INCONSISTENT;
    }
    if (event == null) return DeliveryState.INCONSISTENT;
    if (inboxId != null || projectionId != null) {
      // Kafka may deliver before the relay writes its acknowledgement to PostgreSQL.
      return event.eventId().equals(inboxId) && event.eventId().equals(projectionId)
          ? DeliveryState.PROJECTED
          : DeliveryState.INCONSISTENT;
    }
    return switch (event.publicationStatus()) {
      case PENDING, CLAIMED -> DeliveryState.AWAITING_PUBLICATION;
      case PUBLISHED -> DeliveryState.AWAITING_PROJECTION;
      case BLOCKED -> DeliveryState.BLOCKED;
    };
  }

  private static Instant instant(ResultSet row, String column) throws SQLException {
    var timestamp = row.getTimestamp(column);
    return timestamp == null ? null : timestamp.toInstant();
  }
}
