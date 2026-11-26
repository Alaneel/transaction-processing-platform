package dev.tpp.events.consumer;

import dev.tpp.domain.ApiException;
import dev.tpp.events.EventFaults;
import dev.tpp.events.EventSettings;
import dev.tpp.events.EventValidationException;
import io.micrometer.core.instrument.MeterRegistry;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Instant;
import java.util.Arrays;
import java.util.Base64;
import java.util.HexFormat;
import java.util.List;
import java.util.UUID;
import java.util.regex.Pattern;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

/** PostgreSQL-backed DLQ and bounded audited replay; no DB/Kafka dual-write in quarantine. */
@Service
public class QuarantineService {
  private static final Pattern IDENTITY =
      Pattern.compile(
          "\\\"eventId\\\"\\s*:\\s*\\\"([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})\\\"");
  private final JdbcTemplate jdbc;
  private final EventSettings settings;
  private final EventFaults faults;
  private final ObjectProvider<EventProcessor> processors;
  private final MeterRegistry metrics;
  private final TransactionTemplate transaction;

  public QuarantineService(
      JdbcTemplate jdbc,
      EventSettings settings,
      EventFaults faults,
      ObjectProvider<EventProcessor> processors,
      MeterRegistry metrics,
      PlatformTransactionManager manager) {
    this.jdbc = jdbc;
    this.settings = settings;
    this.faults = faults;
    this.processors = processors;
    this.metrics = metrics;
    transaction = new TransactionTemplate(manager);
    transaction.setTimeout(settings.dbTimeoutSeconds());
  }

  public record Quarantined(long id, UUID eventId) {}

  public record QuarantineItem(
      long id,
      UUID eventId,
      String consumerGroup,
      String topic,
      int partition,
      long offset,
      String originalKey,
      String originalPayloadBase64,
      String originalPayloadUtf8,
      String payloadSha256,
      int originalPayloadBytes,
      boolean payloadTruncated,
      String classification,
      String code,
      String message,
      int processingAttempts,
      Instant quarantinedAt,
      int replayAttempts,
      Instant lastReplayAt) {}

  public record ReplayResult(
      long replayId, long quarantineId, int attempt, UUID eventId, String status, String code) {}

  public record ReplayAudit(
      long id,
      long quarantineId,
      int attempt,
      String reason,
      String correctedPayload,
      UUID adoptedEventId,
      String status,
      String resultCode,
      Instant startedAt,
      Instant finishedAt) {}

  private record Reservation(
      long replayId,
      int attempt,
      UUID originalIdentity,
      byte[] payload,
      EventProcessor.Delivery delivery) {}

  public Quarantined record(EventProcessor.Delivery delivery, EventValidationException error) {
    byte[] original = delivery.value() == null ? new byte[0] : delivery.value();
    byte[] prefix =
        Arrays.copyOf(original, Math.min(original.length, EventProcessor.MAX_PAYLOAD_BYTES));
    UUID identity = identity(prefix);
    return EventProcessor.measuredTransaction(
        transaction,
        metrics,
        "quarantine",
        status -> {
          timeout();
          jdbc.update(
              """
              INSERT INTO event_quarantine(consumer_group,source_topic,source_partition,source_offset,
                event_id,original_key,original_payload,payload_sha256,original_payload_bytes,payload_truncated,
                error_classification,error_code,error_message,processing_attempts)
              VALUES (?,?,?,?,?,?,?,?,?,?,'PERMANENT',?,?,?)
              ON CONFLICT (consumer_group,source_topic,source_partition,source_offset) DO NOTHING
              """,
              settings.consumerGroup(),
              delivery.topic(),
              delivery.partition(),
              delivery.offset(),
              identity,
              bounded(delivery.key(), 1024),
              prefix,
              digest(original),
              original.length,
              original.length > EventProcessor.MAX_PAYLOAD_BYTES,
              bounded(error.code(), 64),
              bounded(error.getMessage(), 240),
              delivery.attempts());
          return jdbc.queryForObject(
              """
              SELECT id,event_id FROM event_quarantine
              WHERE consumer_group=? AND source_topic=? AND source_partition=? AND source_offset=?
              """,
              (row, index) -> new Quarantined(row.getLong(1), row.getObject(2, UUID.class)),
              settings.consumerGroup(),
              delivery.topic(),
              delivery.partition(),
              delivery.offset());
        });
  }

  public ReplayResult replay(long id, String reason, String correctedPayload) {
    if (reason == null || reason.isBlank() || reason.length() > 500)
      throw new ApiException(
          400, "INVALID_REPLAY_REASON", "Replay needs a nonblank reason up to 500 characters");
    byte[] corrected =
        correctedPayload == null ? null : correctedPayload.getBytes(StandardCharsets.UTF_8);
    if (corrected != null && corrected.length > EventProcessor.MAX_PAYLOAD_BYTES)
      throw new ApiException(400, "PAYLOAD_TOO_LARGE", "Corrected payload exceeds 1 MiB");

    // Reserve durably before execution. A process interruption consumes an attempt and leaves
    // STARTED evidence: operators may inspect/retry it, rather than declaring an uncertain failure.
    Reservation reservation =
        EventProcessor.measuredTransaction(
            transaction,
            metrics,
            "replay_reserve",
            status -> {
              timeout();
              var rows =
                  jdbc.query(
                      "SELECT * FROM event_quarantine WHERE id=? FOR UPDATE",
                      (row, index) -> {
                        int attempts = row.getInt("replay_attempts");
                        if (attempts >= settings.maxReplayAttempts())
                          throw new ApiException(
                              409, "REPLAY_LIMIT_REACHED", "Quarantine replay limit reached");
                        if (corrected == null && row.getBoolean("payload_truncated"))
                          throw new ApiException(
                              400,
                              "CORRECTION_REQUIRED",
                              "Truncated evidence requires a corrected payload");
                        byte[] payload =
                            corrected == null ? row.getBytes("original_payload") : corrected;
                        return new Reservation(
                            0,
                            attempts + 1,
                            row.getObject("event_id", UUID.class),
                            payload,
                            new EventProcessor.Delivery(
                                row.getString("source_topic"),
                                row.getInt("source_partition"),
                                row.getLong("source_offset"),
                                row.getString("original_key"),
                                payload,
                                attempts + 1));
                      },
                      id);
              if (rows.isEmpty())
                throw new ApiException(
                    404, "QUARANTINE_NOT_FOUND", "Quarantine record does not exist");
              Reservation chosen = rows.getFirst();
              jdbc.update(
                  "UPDATE event_quarantine SET"
                      + " replay_attempts=replay_attempts+1,last_replay_at=clock_timestamp() WHERE"
                      + " id=?",
                  id);
              long replayId =
                  java.util.Objects.requireNonNull(
                      jdbc.queryForObject(
                          """
                          INSERT INTO event_quarantine_replays(quarantine_id,attempt,reason,corrected_payload)
                          VALUES (?,?,?,?) RETURNING id
                          """,
                          Long.class,
                          id,
                          chosen.attempt(),
                          reason.strip(),
                          corrected));
              return new Reservation(
                  replayId,
                  chosen.attempt(),
                  chosen.originalIdentity(),
                  chosen.payload(),
                  chosen.delivery());
            });

    EventProcessor processor = processors.getObject();
    UUID[] adopted = new UUID[1];
    try {
      var event = processor.decode(reservation.payload());
      adopted[0] = event.eventId();
      if (reservation.originalIdentity() != null
          && !reservation.originalIdentity().equals(event.eventId()))
        throw new EventValidationException(
            "REPLAY_IDENTITY_MISMATCH", "Correction must retain the original event identity");
      EventProcessor.ProcessingResult result =
          EventProcessor.measuredTransaction(
              transaction,
              metrics,
              "replay_projection",
              status -> {
                processor.configureTimeouts();
                var applied = processor.applyWithinTransaction(event, reservation.delivery());
                terminal(
                    reservation.replayId(),
                    event.eventId(),
                    applied.outcome() == EventProcessor.Outcome.DUPLICATE
                        ? "DUPLICATE"
                        : "SUCCEEDED",
                    null);
                faults.at(EventFaults.Boundary.CONSUMER_BEFORE_COMMIT, event.eventId());
                faults.at(EventFaults.Boundary.REPLAY_BEFORE_COMMIT, event.eventId());
                return applied;
              });
      processor.recordCommittedResult(result, "replay");
      faults.at(EventFaults.Boundary.CONSUMER_AFTER_COMMIT, event.eventId());
      processor.recordResult(result);
      String outcome =
          result.outcome() == EventProcessor.Outcome.DUPLICATE ? "DUPLICATE" : "SUCCEEDED";
      metrics.counter("events.quarantine.replays", "outcome", outcome.toLowerCase()).increment();
      return new ReplayResult(
          reservation.replayId(), id, reservation.attempt(), result.eventId(), outcome, null);
    } catch (EventValidationException permanent) {
      EventProcessor.measuredTransaction(
          transaction,
          metrics,
          "replay_reject",
          status -> {
            timeout();
            terminal(reservation.replayId(), adopted[0], "REJECTED", permanent.code());
            return null;
          });
      metrics.counter("events.quarantine.replays", "outcome", "rejected").increment();
      return new ReplayResult(
          reservation.replayId(),
          id,
          reservation.attempt(),
          adopted[0],
          "REJECTED",
          permanent.code());
    }
    // Transient/ambiguous errors and injected crashes propagate; STARTED preserves uncertainty.
  }

  private void terminal(long id, UUID identity, String status, String code) {
    if (jdbc.update(
            """
            UPDATE event_quarantine_replays SET adopted_event_id=?,status=?,result_code=?,
              finished_at=clock_timestamp() WHERE id=? AND status='STARTED'
            """,
            identity,
            status,
            code,
            id)
        != 1) throw new IllegalStateException("Replay reservation is already terminal");
  }

  public List<QuarantineItem> list(long after, int limit) {
    validatePage(after, limit);
    return jdbc.query(
        "SELECT * FROM event_quarantine WHERE id>? ORDER BY id LIMIT ?",
        (row, index) -> item(row),
        after,
        limit);
  }

  public QuarantineItem get(long id) {
    return jdbc
        .query("SELECT * FROM event_quarantine WHERE id=?", (row, index) -> item(row), id)
        .stream()
        .findFirst()
        .orElseThrow(
            () ->
                new ApiException(404, "QUARANTINE_NOT_FOUND", "Quarantine record does not exist"));
  }

  public List<ReplayAudit> replays(long id) {
    get(id);
    return jdbc.query(
        "SELECT * FROM event_quarantine_replays WHERE quarantine_id=? ORDER BY attempt",
        (row, index) ->
            new ReplayAudit(
                row.getLong("id"),
                id,
                row.getInt("attempt"),
                row.getString("reason"),
                row.getBytes("corrected_payload") == null
                    ? null
                    : new String(row.getBytes("corrected_payload"), StandardCharsets.UTF_8),
                row.getObject("adopted_event_id", UUID.class),
                row.getString("status"),
                row.getString("result_code"),
                row.getTimestamp("started_at").toInstant(),
                instant(row, "finished_at")),
        id);
  }

  private QuarantineItem item(java.sql.ResultSet row) throws java.sql.SQLException {
    byte[] payload = row.getBytes("original_payload");
    return new QuarantineItem(
        row.getLong("id"),
        row.getObject("event_id", UUID.class),
        row.getString("consumer_group"),
        row.getString("source_topic"),
        row.getInt("source_partition"),
        row.getLong("source_offset"),
        row.getString("original_key"),
        Base64.getEncoder().encodeToString(payload),
        new String(payload, StandardCharsets.UTF_8),
        row.getString("payload_sha256"),
        row.getInt("original_payload_bytes"),
        row.getBoolean("payload_truncated"),
        row.getString("error_classification"),
        row.getString("error_code"),
        row.getString("error_message"),
        row.getInt("processing_attempts"),
        row.getTimestamp("quarantined_at").toInstant(),
        row.getInt("replay_attempts"),
        instant(row, "last_replay_at"));
  }

  private static Instant instant(java.sql.ResultSet row, String column)
      throws java.sql.SQLException {
    var timestamp = row.getTimestamp(column);
    return timestamp == null ? null : timestamp.toInstant();
  }

  static void validatePage(long after, int limit) {
    if (after < 0 || limit < 1 || limit > 100)
      throw new ApiException(
          400, "INVALID_PAGE", "Page requires after >= 0 and limit between 1 and 100");
  }

  private void timeout() {
    jdbc.queryForObject(
        "SELECT set_config('statement_timeout', ?, true)",
        String.class,
        settings.dbTimeoutSeconds() * 1000 + "ms");
    jdbc.queryForObject("SELECT set_config('lock_timeout', '500ms', true)", String.class);
  }

  private static UUID identity(byte[] payload) {
    var match = IDENTITY.matcher(new String(payload, StandardCharsets.UTF_8));
    return match.find() ? UUID.fromString(match.group(1)) : null;
  }

  private static String bounded(String value, int maximum) {
    if (value == null) return null;
    return value.substring(0, Math.min(maximum, value.length()));
  }

  private static String digest(byte[] payload) {
    try {
      return HexFormat.of().formatHex(MessageDigest.getInstance("SHA-256").digest(payload));
    } catch (NoSuchAlgorithmException impossible) {
      throw new IllegalStateException(impossible);
    }
  }
}
