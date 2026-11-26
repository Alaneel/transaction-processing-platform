package dev.tpp.events.relay;

import dev.tpp.events.EventValidationException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;
import java.util.concurrent.CompletionException;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import org.apache.kafka.clients.producer.RecordMetadata;
import org.apache.kafka.common.errors.AuthenticationException;
import org.apache.kafka.common.errors.AuthorizationException;
import org.apache.kafka.common.errors.InvalidTopicException;
import org.apache.kafka.common.errors.RecordTooLargeException;
import org.apache.kafka.common.errors.SerializationException;

/**
 * Bounded callback state only; the coordinator owns leases, SQL, deadlines and producer permits.
 */
public final class PublicationBatch {
  private static final int MAXIMUM_SIZE = 100;
  private final List<OutboxStore.Claim> claims;
  private final String expectedTopic;
  private final Map<Identity, Entry> entries = new LinkedHashMap<>();
  private int terminalCount;
  private List<Result> snapshot;

  public PublicationBatch(List<OutboxStore.Claim> claims, String expectedTopic) {
    this.claims = List.copyOf(claims);
    if (this.claims.size() > MAXIMUM_SIZE)
      throw new IllegalArgumentException("Publication batch exceeds its fixed record bound");
    if (expectedTopic == null || expectedTopic.isBlank() || expectedTopic.length() > 249)
      throw new IllegalArgumentException("Invalid expected Kafka topic");
    this.expectedTopic = expectedTopic;
    var eventIds = new java.util.HashSet<UUID>();
    for (var claim : this.claims) {
      Objects.requireNonNull(claim.eventId(), "eventId");
      Objects.requireNonNull(claim.claimToken(), "claimToken");
      if (!eventIds.add(claim.eventId()))
        throw new IllegalArgumentException("Duplicate logical event in publication batch");
      entries.put(new Identity(claim.eventId(), claim.claimToken()), new Entry(claim));
    }
  }

  public List<OutboxStore.Claim> claims() {
    return claims;
  }

  /** Mark before Producer.send: Kafka can invoke its callback before send returns. */
  public synchronized boolean beginSend(UUID eventId, UUID token) {
    var entry = writable(eventId, token);
    if (entry == null || entry.begun) return false;
    entry.begun = true;
    return true;
  }

  public synchronized boolean acknowledge(UUID eventId, UUID token, KafkaPosition position) {
    var entry = writable(eventId, token);
    if (entry == null || !entry.begun) return false;
    if (position == null || !expectedTopic.equals(position.topic())) {
      return complete(
          entry,
          failure(
              entry.claim,
              "INVALID_KAFKA_ACK",
              "AMBIGUOUS",
              "Invalid Kafka acknowledgement",
              false));
    }
    return complete(entry, new Result(entry.claim, position, null, null, null, false));
  }

  public synchronized boolean fail(
      UUID eventId,
      UUID token,
      String code,
      String classification,
      String safeDetail,
      boolean permanent) {
    var entry = writable(eventId, token);
    if (entry == null) return false;
    return complete(entry, failure(entry.claim, code, classification, safeDetail, permanent));
  }

  /** Known local/producer failures preserve the Phase 2 permanent-versus-uncertain distinction. */
  public boolean fail(UUID eventId, UUID token, Throwable error) {
    Objects.requireNonNull(error, "error");
    Throwable cause = error;
    int depth = 0;
    while ((cause instanceof ExecutionException || cause instanceof CompletionException)
        && cause.getCause() != null
        && depth++ < 16) cause = cause.getCause();
    boolean permanent =
        cause instanceof EventValidationException
            || cause instanceof AuthenticationException
            || cause instanceof AuthorizationException
            || cause instanceof SerializationException
            || cause instanceof RecordTooLargeException
            || cause instanceof InvalidTopicException;
    String code =
        cause instanceof EventValidationException validation
            ? validation.code()
            : permanent ? "KAFKA_PERMANENT_ERROR" : "DELIVERY_UNCERTAIN";
    return fail(
        eventId,
        token,
        code,
        permanent ? "PERMANENT" : "AMBIGUOUS",
        cause.getClass().getSimpleName(),
        permanent);
  }

  /** Uses an absolute System.nanoTime deadline; waiting never changes callback or permit state. */
  public synchronized boolean awaitUntil(long monotonicDeadlineNanos) throws InterruptedException {
    while (terminalCount < claims.size() && snapshot == null) {
      long remaining = monotonicDeadlineNanos - System.nanoTime();
      if (remaining <= 0) return false;
      TimeUnit.NANOSECONDS.timedWait(this, remaining);
    }
    return terminalCount == claims.size();
  }

  /** Freeze once: a timeout is uncertainty, while an unstarted record is known not to be sent. */
  public synchronized List<Result> finish() {
    if (snapshot != null) return List.copyOf(snapshot);
    snapshot =
        List.copyOf(
            entries.values().stream()
                .map(
                    entry -> {
                      if (entry.result != null) return entry.result;
                      return entry.begun
                          ? failure(
                              entry.claim,
                              "DELIVERY_UNCERTAIN",
                              "AMBIGUOUS",
                              "Kafka outcome unresolved at batch deadline",
                              false)
                          : failure(
                              entry.claim,
                              "BATCH_NOT_SENT",
                              "TRANSIENT",
                              "Record was not submitted",
                              false);
                    })
                .toList());
    notifyAll();
    return List.copyOf(snapshot);
  }

  /** A cancelled snapshot is inspectable; crash/shutdown coordinators decide whether to persist. */
  public List<Result> cancel() {
    return finish();
  }

  public synchronized boolean isFinished() {
    return snapshot != null;
  }

  private Entry writable(UUID eventId, UUID token) {
    if (snapshot != null) return null;
    var entry = entries.get(new Identity(eventId, token));
    return entry == null || entry.result != null ? null : entry;
  }

  private boolean complete(Entry entry, Result result) {
    entry.result = result;
    terminalCount++;
    notifyAll();
    return true;
  }

  private static Result failure(
      OutboxStore.Claim claim,
      String code,
      String classification,
      String safeDetail,
      boolean permanent) {
    Objects.requireNonNull(safeDetail, "safeDetail");
    return new Result(
        claim,
        null,
        code,
        classification,
        safeDetail.substring(0, Math.min(256, safeDetail.length())),
        permanent);
  }

  public record KafkaPosition(String topic, int partition, long offset) {
    public KafkaPosition {
      if (topic == null || topic.isBlank() || topic.length() > 249 || partition < 0 || offset < 0)
        throw new IllegalArgumentException("Invalid Kafka position");
    }

    public static KafkaPosition from(RecordMetadata metadata) {
      Objects.requireNonNull(metadata, "metadata");
      return new KafkaPosition(metadata.topic(), metadata.partition(), metadata.offset());
    }
  }

  public record Result(
      OutboxStore.Claim claim,
      KafkaPosition position,
      String code,
      String classification,
      String safeDetail,
      boolean permanent) {
    public Result {
      Objects.requireNonNull(claim, "claim");
      if (position != null) {
        if (code != null || classification != null || safeDetail != null || permanent)
          throw new IllegalArgumentException("Acknowledgement cannot also be a failure");
      } else if (code == null
          || code.isBlank()
          || code.length() > 64
          || !("TRANSIENT".equals(classification)
              || "AMBIGUOUS".equals(classification)
              || "PERMANENT".equals(classification))
          || safeDetail == null
          || safeDetail.length() > 256
          || permanent != "PERMANENT".equals(classification)) {
        throw new IllegalArgumentException("Invalid classified publication failure");
      }
    }

    public boolean acknowledged() {
      return position != null;
    }
  }

  private record Identity(UUID eventId, UUID claimToken) {}

  private static final class Entry {
    private final OutboxStore.Claim claim;
    private boolean begun;
    private Result result;

    private Entry(OutboxStore.Claim claim) {
      this.claim = claim;
    }
  }
}
