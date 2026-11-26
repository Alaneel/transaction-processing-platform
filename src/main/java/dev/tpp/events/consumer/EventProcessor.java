package dev.tpp.events.consumer;

import dev.tpp.events.EventCodec;
import dev.tpp.events.EventFaults;
import dev.tpp.events.EventSettings;
import dev.tpp.events.EventValidationException;
import dev.tpp.events.TransferCompletedEvent;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Timer;
import java.nio.ByteBuffer;
import java.nio.charset.CharacterCodingException;
import java.nio.charset.CodingErrorAction;
import java.nio.charset.StandardCharsets;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

/** The only business side-effect boundary: inbox plus paired activity in one DB transaction. */
@Service
public class EventProcessor {
  public static final int MAX_PAYLOAD_BYTES = 1_048_576;
  private static final Logger LOG = LoggerFactory.getLogger(EventProcessor.class);
  private final JdbcTemplate jdbc;
  private final EventCodec codec;
  private final EventFaults faults;
  private final EventSettings settings;
  private final QuarantineService quarantine;
  private final MeterRegistry metrics;
  private final TransactionTemplate transaction;

  public EventProcessor(
      JdbcTemplate jdbc,
      EventCodec codec,
      EventFaults faults,
      EventSettings settings,
      QuarantineService quarantine,
      MeterRegistry metrics,
      PlatformTransactionManager manager) {
    this.jdbc = jdbc;
    this.codec = codec;
    this.faults = faults;
    this.settings = settings;
    this.quarantine = quarantine;
    this.metrics = metrics;
    transaction = new TransactionTemplate(manager);
    transaction.setTimeout(settings.dbTimeoutSeconds());
  }

  public record Delivery(
      String topic, int partition, long offset, String key, byte[] value, int attempts) {
    public Delivery {
      if (topic == null
          || topic.isBlank()
          || topic.length() > 249
          || partition < 0
          || offset < 0
          || attempts < 1) throw new IllegalArgumentException("Invalid delivery metadata");
      value = value == null ? null : value.clone();
    }

    @Override
    public byte[] value() {
      return value == null ? null : value.clone();
    }
  }

  public enum Outcome {
    PROCESSED,
    DUPLICATE,
    QUARANTINED
  }

  public record ProcessingResult(UUID eventId, Outcome outcome, Long quarantineId) {}

  public ProcessingResult process(Delivery delivery) {
    Timer.Sample timer = Timer.start(metrics);
    try {
      TransferCompletedEvent event;
      try {
        event = decode(delivery.value());
      } catch (EventValidationException permanent) {
        return quarantine(delivery, permanent);
      }
      try (var correlation = MDC.putCloseable("correlationId", event.correlationId());
          var identity = MDC.putCloseable("eventId", event.eventId().toString());
          var transfer = MDC.putCloseable("transferId", event.transferId().toString())) {
        try {
          ProcessingResult result =
              measuredTransaction(
                  transaction,
                  metrics,
                  "projection",
                  status -> {
                    configureTimeouts();
                    ProcessingResult applied = applyWithinTransaction(event, delivery);
                    faults.at(EventFaults.Boundary.CONSUMER_BEFORE_COMMIT, event.eventId());
                    return applied;
                  });
          recordCommittedResult(result, "kafka");
          // A crash here is an ambiguous transport outcome, never a poison event.
          faults.at(EventFaults.Boundary.CONSUMER_AFTER_COMMIT, event.eventId());
          recordResult(result);
          if (result.outcome() == Outcome.PROCESSED)
            metrics
                .timer("events.projection.propagation.duration")
                .record(java.time.Duration.between(event.occurredAt(), java.time.Instant.now()));
          LOG.info(
              "Consumer durable result outcome={} topic={} partition={} offset={}",
              result.outcome(),
              delivery.topic(),
              delivery.partition(),
              delivery.offset());
          return result;
        } catch (EventValidationException permanent) {
          return quarantine(delivery, permanent);
        }
      }
    } finally {
      timer.stop(metrics.timer("events.consumer.processing.duration"));
    }
  }

  TransferCompletedEvent decode(byte[] value) {
    if (value == null) throw invalid("NULL_PAYLOAD", "Tombstones are not transfer events");
    if (value.length > MAX_PAYLOAD_BYTES)
      throw invalid("PAYLOAD_TOO_LARGE", "Event payload exceeds the 1 MiB supported limit");
    try {
      String raw =
          StandardCharsets.UTF_8
              .newDecoder()
              .onMalformedInput(CodingErrorAction.REPORT)
              .onUnmappableCharacter(CodingErrorAction.REPORT)
              .decode(ByteBuffer.wrap(value))
              .toString();
      return codec.decode(raw);
    } catch (CharacterCodingException invalidUtf8) {
      throw invalid("INVALID_UTF8", "Event payload must contain valid UTF-8");
    }
  }

  void configureTimeouts() {
    jdbc.queryForObject(
        "SELECT set_config('statement_timeout', ?, true)",
        String.class,
        settings.dbTimeoutSeconds() * 1000 + "ms");
    jdbc.queryForObject("SELECT set_config('lock_timeout', '500ms', true)", String.class);
  }

  /** Used by controlled replay inside its own transaction; validation precedes every insert. */
  ProcessingResult applyWithinTransaction(TransferCompletedEvent event, Delivery delivery) {
    String canonical = codec.encode(event);
    String hash = codec.digest(canonical);
    var origin =
        jdbc.query(
            "SELECT payload::text FROM outbox_events WHERE event_id=? AND transfer_id=?",
            (row, index) -> row.getString(1),
            event.eventId(),
            event.transferId());
    if (origin.isEmpty())
      throw invalid("UNKNOWN_EVENT_ORIGIN", "Event identity has no committed local origin");
    TransferCompletedEvent expected = codec.decode(origin.getFirst());
    if (!expected.equals(event))
      throw invalid("EVENT_ORIGIN_MISMATCH", "Payload differs from its committed event origin");

    // Checking origin also rejects a forged event for an existing transfer. Origin is immutable.
    int registered =
        jdbc.update(
            """
            INSERT INTO event_inbox(event_id,transfer_id,payload_hash,event_type,schema_version,
              source_topic,source_partition,source_offset,correlation_id)
            VALUES (?,?,?,?,?,?,?,?,?) ON CONFLICT (event_id) DO NOTHING
            """,
            event.eventId(),
            event.transferId(),
            hash,
            event.eventType(),
            event.schemaVersion(),
            delivery.topic(),
            delivery.partition(),
            delivery.offset(),
            event.correlationId());
    if (registered == 0) {
      String priorHash =
          jdbc.queryForObject(
              "SELECT payload_hash FROM event_inbox WHERE event_id=?",
              String.class,
              event.eventId());
      if (!hash.equals(priorHash))
        throw invalid("EVENT_ID_COLLISION", "A processed event identity has different content");
      return new ProcessingResult(event.eventId(), Outcome.DUPLICATE, null);
    }
    jdbc.update(
        """
        INSERT INTO transfer_activity_projection(transfer_id,event_id,source_account_id,
          destination_account_id,amount_minor,unit,occurred_at)
        VALUES (?,?,?,?,?,?,?)
        """,
        event.transferId(),
        event.eventId(),
        event.sourceAccountId(),
        event.destinationAccountId(),
        event.amountMinor(),
        event.unit(),
        java.sql.Timestamp.from(event.occurredAt()));
    jdbc.update(
        """
        INSERT INTO account_activity(account_id,event_id,transfer_id,delta_minor,unit,occurred_at)
        VALUES (?,?,?,?,?,?),(?,?,?,?,?,?)
        """,
        event.sourceAccountId(),
        event.eventId(),
        event.transferId(),
        -event.amountMinor(),
        event.unit(),
        java.sql.Timestamp.from(event.occurredAt()),
        event.destinationAccountId(),
        event.eventId(),
        event.transferId(),
        event.amountMinor(),
        event.unit(),
        java.sql.Timestamp.from(event.occurredAt()));
    return new ProcessingResult(event.eventId(), Outcome.PROCESSED, null);
  }

  void recordResult(ProcessingResult result) {
    metrics
        .counter("events.consumer.outcomes", "outcome", result.outcome().name().toLowerCase())
        .increment();
  }

  void recordCommittedResult(ProcessingResult result, String source) {
    metrics
        .counter(
            "events.projection.commits",
            "source",
            source,
            "outcome",
            result.outcome().name().toLowerCase())
        .increment();
  }

  /** Records nested monotonic durations after transaction completion, outside its callback. */
  static <T> T measuredTransaction(
      TransactionTemplate transaction,
      MeterRegistry metrics,
      String operation,
      TransactionCallback<T> callback) {
    long started = System.nanoTime();
    long[] work = new long[2];
    boolean[] workCompleted = new boolean[1];
    String result = "failed";
    try {
      T applied =
          transaction.execute(
              status -> {
                work[0] = System.nanoTime();
                try {
                  T value = callback.doInTransaction(status);
                  workCompleted[0] = true;
                  return value;
                } finally {
                  work[1] = System.nanoTime();
                }
              });
      result = "committed";
      return applied;
    } finally {
      long finished = System.nanoTime();
      metrics
          .timer(
              "events.consumer.database.transaction.duration",
              "operation",
              operation,
              "result",
              result)
          .record(finished - started, TimeUnit.NANOSECONDS);
      if (work[0] != 0)
        metrics
            .timer(
                "events.consumer.database.work.duration",
                "operation",
                operation,
                "result",
                workCompleted[0] ? "completed" : "failed")
            .record(work[1] - work[0], TimeUnit.NANOSECONDS);
      if (workCompleted[0])
        metrics
            .timer(
                "events.consumer.database.completion.duration",
                "operation",
                operation,
                "result",
                result)
            .record(finished - work[1], TimeUnit.NANOSECONDS);
    }
  }

  private ProcessingResult quarantine(Delivery delivery, EventValidationException error) {
    QuarantineService.Quarantined result = quarantine.record(delivery, error);
    ProcessingResult processed =
        new ProcessingResult(result.eventId(), Outcome.QUARANTINED, result.id());
    recordResult(processed);
    LOG.warn(
        "Consumer quarantined topic={} partition={} offset={} code={} quarantineId={}",
        delivery.topic(),
        delivery.partition(),
        delivery.offset(),
        error.code(),
        result.id());
    return processed;
  }

  private static EventValidationException invalid(String code, String message) {
    return new EventValidationException(code, message);
  }
}
