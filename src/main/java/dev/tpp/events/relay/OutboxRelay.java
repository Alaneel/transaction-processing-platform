package dev.tpp.events.relay;

import static dev.tpp.events.EventFaults.Boundary.*;

import dev.tpp.events.EventCodec;
import dev.tpp.events.EventFaults;
import dev.tpp.events.EventSettings;
import dev.tpp.events.EventValidationException;
import io.micrometer.core.instrument.MeterRegistry;
import jakarta.annotation.PreDestroy;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.CancellationException;
import java.util.concurrent.Semaphore;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.function.Supplier;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringSerializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.context.SmartLifecycle;
import org.springframework.stereotype.Component;

/** Short SQL claims, network I/O outside transactions, then fenced delivery evidence. */
@Component
public class OutboxRelay implements SmartLifecycle {
  private static final Logger LOG = LoggerFactory.getLogger(OutboxRelay.class);
  private final OutboxStore store;
  private final EventSettings settings;
  private final EventCodec codec;
  private final EventFaults faults;
  private final MeterRegistry metrics;
  private final Semaphore inFlight;
  private final AtomicBoolean batchActive = new AtomicBoolean();
  private final AtomicBoolean stopInProgress = new AtomicBoolean();
  private final UUID owner = UUID.randomUUID();
  private volatile boolean running;
  private volatile boolean stopping;
  private volatile Thread worker;
  private volatile Thread coordinator;
  private KafkaProducer<String, String> producer;

  public OutboxRelay(
      OutboxStore store,
      EventSettings settings,
      EventCodec codec,
      EventFaults faults,
      MeterRegistry metrics) {
    this.store = store;
    this.settings = settings;
    this.codec = codec;
    this.faults = faults;
    this.metrics = metrics;
    inFlight = new Semaphore(settings.batchSize());
    for (String outcome : new String[] {"success", "transient", "ambiguous", "permanent", "stale"})
      metrics.counter("events.outbox.publications", "outcome", outcome);
    metrics.counter("events.outbox.retries");
    metrics.counter("events.outbox.claim.recoveries");
    metrics.counter("events.outbox.settlement.failures");
    metrics.gauge(
        "events.outbox.inflight.records",
        inFlight,
        permits -> settings.batchSize() - permits.availablePermits());
  }

  public static Map<String, Object> producerProperties(EventSettings settings) {
    Map<String, Object> config = new HashMap<>();
    config.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, settings.bootstrapServers());
    config.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
    config.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
    config.put(ProducerConfig.ACKS_CONFIG, "all");
    config.put(ProducerConfig.ENABLE_IDEMPOTENCE_CONFIG, true);
    config.put(ProducerConfig.RETRIES_CONFIG, Integer.MAX_VALUE);
    config.put(ProducerConfig.MAX_IN_FLIGHT_REQUESTS_PER_CONNECTION, 5);
    config.put(ProducerConfig.DELIVERY_TIMEOUT_MS_CONFIG, settings.deliveryTimeoutMs());
    config.put(ProducerConfig.REQUEST_TIMEOUT_MS_CONFIG, settings.requestTimeoutMs());
    config.put(ProducerConfig.MAX_BLOCK_MS_CONFIG, settings.maxBlockMs());
    config.put(ProducerConfig.LINGER_MS_CONFIG, 0);
    config.put(ProducerConfig.BUFFER_MEMORY_CONFIG, 4_194_304L);
    config.put(ProducerConfig.MAX_REQUEST_SIZE_CONFIG, 1_048_576);
    config.put(ProducerConfig.CLIENT_ID_CONFIG, "tpp-outbox-relay");
    return config;
  }

  private synchronized KafkaProducer<String, String> producer() {
    if (stopping || Thread.currentThread().isInterrupted())
      throw new CancellationException("Relay is stopping");
    if (producer == null)
      producer =
          metrics
              .timer("events.outbox.producer.create.duration")
              .record(() -> new KafkaProducer<>(producerProperties(settings)));
    return producer;
  }

  /**
   * Public one-batch operation supports deterministic crash tests and controlled local experiments.
   */
  public int relayOnce() {
    if (stopping || !batchActive.compareAndSet(false, true)) return 0;
    coordinator = Thread.currentThread();
    var batchTimer = io.micrometer.core.instrument.Timer.start(metrics);
    try {
      if (stopping || Thread.currentThread().isInterrupted()) return 0;
      return publishBatch();
    } finally {
      batchTimer.stop(metrics.timer("events.outbox.batch.duration"));
      coordinator = null;
      batchActive.set(false);
    }
  }

  private int publishBatch() {
    int capacity = inFlight.availablePermits();
    if (capacity == 0) return 0;
    var claims =
        database("claim", () -> store.claim(owner, Math.min(settings.batchSize(), capacity)));
    metrics.summary("events.outbox.claim.batch.size").record(claims.size());
    metrics.counter("events.outbox.claim.records").increment(claims.size());
    if (claims.isEmpty()) return 0;
    for (var claim : claims) {
      if (claim.recoveredLease()) metrics.counter("events.outbox.claim.recoveries").increment();
      if (claim.attemptCount() > 1) metrics.counter("events.outbox.retries").increment();
      faults.at(RELAY_AFTER_CLAIM, claim.eventId());
    }
    var renewed = database("renew_batch", () -> store.renewBatch(claims));
    var live = claims.stream().filter(claim -> renewed.contains(claim.eventId())).toList();
    metrics
        .counter("events.outbox.publications", "outcome", "stale")
        .increment(claims.size() - live.size());
    if (live.isEmpty()) return 0;
    var batch = new PublicationBatch(live, settings.topic());
    // One deadline also limits a sequence of producer.send calls that each block for max.block.ms.
    long deadline =
        System.nanoTime()
            + TimeUnit.MILLISECONDS.toNanos(
                (long) settings.deliveryTimeoutMs() + settings.maxBlockMs() + 1000);
    try {
      for (var claim : live) {
        if (stopping || Thread.currentThread().isInterrupted()) {
          batch.cancel();
          return 0; // Accepted work remains CLAIMED; recovery requires the durable lease fence.
        }
        if (System.nanoTime() >= deadline) break;
        try {
          var event = codec.decode(claim.payload());
          try (var ignored = MDC.putCloseable("correlationId", event.correlationId())) {
            faults.at(RELAY_BEFORE_SEND, claim.eventId());
            if (stopping || Thread.currentThread().isInterrupted()) {
              batch.cancel();
              return 0;
            }
            if (System.nanoTime() >= deadline || !inFlight.tryAcquire()) break;
            var released = new AtomicBoolean();
            batch.beginSend(claim.eventId(), claim.claimToken());
            try {
              var active = producer();
              metrics
                  .counter(
                      "events.outbox.send.attempts",
                      "kind",
                      claim.attemptCount() > 1 ? "retry" : "first")
                  .increment();
              long sentAt = System.nanoTime();
              metrics
                  .timer("events.outbox.kafka.enqueue.duration")
                  .record(
                      () ->
                          active.send(
                              new ProducerRecord<>(
                                  settings.topic(),
                                  claim.transferId().toString(),
                                  codec.encode(event)),
                              (metadata, failure) -> {
                                boolean validAcknowledgement = false;
                                try {
                                  // Slot/generation completion happens first. Never run SQL or
                                  // fault seams
                                  // on Kafka's I/O thread. A timed-out old batch cannot be
                                  // reopened.
                                  if (failure != null)
                                    batch.fail(claim.eventId(), claim.claimToken(), failure);
                                  else if (metadata == null)
                                    batch.fail(
                                        claim.eventId(),
                                        claim.claimToken(),
                                        "INVALID_KAFKA_ACK",
                                        "AMBIGUOUS",
                                        "Missing acknowledgement metadata",
                                        false);
                                  else {
                                    var position =
                                        new PublicationBatch.KafkaPosition(
                                            metadata.topic(),
                                            metadata.partition(),
                                            metadata.offset());
                                    validAcknowledgement =
                                        settings.topic().equals(position.topic());
                                    batch.acknowledge(
                                        claim.eventId(), claim.claimToken(), position);
                                  }
                                } catch (RuntimeException invalidMetadata) {
                                  batch.fail(
                                      claim.eventId(),
                                      claim.claimToken(),
                                      "INVALID_KAFKA_ACK",
                                      "AMBIGUOUS",
                                      "Invalid acknowledgement metadata",
                                      false);
                                } finally {
                                  releaseOnce(released);
                                }
                                metrics
                                    .timer("events.outbox.kafka.ack.duration")
                                    .record(System.nanoTime() - sentAt, TimeUnit.NANOSECONDS);
                                metrics
                                    .counter(
                                        "events.outbox.kafka.acknowledgements",
                                        "outcome",
                                        validAcknowledgement ? "accepted" : "failed")
                                    .increment();
                              }));
            } catch (RuntimeException enqueueFailure) {
              batch.fail(claim.eventId(), claim.claimToken(), enqueueFailure);
              releaseOnce(released); // Synchronous throw and callback may both occur.
            }
          }
        } catch (EventFaults.Crash crash) {
          throw crash;
        } catch (EventValidationException invalid) {
          batch.fail(
              claim.eventId(),
              claim.claimToken(),
              invalid.code(),
              "PERMANENT",
              invalid.getMessage(),
              true);
        }
      }
      long waitingAt = System.nanoTime();
      try {
        batch.awaitUntil(deadline);
      } catch (InterruptedException interrupted) {
        Thread.currentThread().interrupt();
        batch.cancel();
        return 0;
      } finally {
        metrics
            .timer("events.outbox.kafka.wait.duration")
            .record(System.nanoTime() - waitingAt, TimeUnit.NANOSECONDS);
      }
      var results = batch.finish();
      if (stopping || Thread.currentThread().isInterrupted()) return 0;
      // Test crash hooks run only on this coordinator, after the immutable per-record ACK snapshot.
      for (var result : results) {
        if (!result.acknowledged()) continue;
        faults.at(RELAY_AFTER_KAFKA_ACK, result.claim().eventId());
        faults.at(RELAY_BEFORE_STATUS_COMMIT, result.claim().eventId());
      }
      if (stopping || Thread.currentThread().isInterrupted()) return 0;
      Set<UUID> applied;
      try {
        applied = database("settle", () -> store.settle(results));
      } catch (RuntimeException statusFailure) {
        metrics.counter("events.outbox.settlement.failures").increment();
        LOG.warn(
            "Batch publication status unavailable records={} errorType={}",
            results.size(),
            statusFailure.getClass().getSimpleName());
        return 0; // No optimistic successes. Unknown commit outcomes safely deduplicate on retry.
      }
      int published = 0;
      for (var result : results) {
        var claim = result.claim();
        if (!applied.contains(claim.eventId())) {
          metrics.counter("events.outbox.publications", "outcome", "stale").increment();
        } else if (result.acknowledged()) {
          published++;
          metrics.counter("events.outbox.publications", "outcome", "success").increment();
          metrics
              .timer("events.outbox.publication.latency")
              .record(Duration.between(claim.createdAt(), java.time.Instant.now()));
          LOG.info(
              "Event published eventId={} transferId={} partition={} offset={}",
              claim.eventId(),
              claim.transferId(),
              result.position().partition(),
              result.position().offset());
        } else {
          metrics
              .counter(
                  "events.outbox.publications",
                  "outcome",
                  result.classification().toLowerCase(java.util.Locale.ROOT))
              .increment();
          LOG.warn(
              "Event publication not confirmed eventId={} transferId={} classification={}"
                  + " errorCode={}",
              claim.eventId(),
              claim.transferId(),
              result.classification(),
              result.code());
        }
      }
      return published;
    } finally {
      batch.cancel(); // Also freezes on Crash; late callbacks are local evidence only.
    }
  }

  private void releaseOnce(AtomicBoolean released) {
    if (released.compareAndSet(false, true)) inFlight.release();
  }

  private <T> T database(String operation, Supplier<T> action) {
    // The store returns after TransactionTemplate completes commit/rollback and cleanup.
    return metrics.timer("events.outbox.database.duration", "operation", operation).record(action);
  }

  @Override
  public synchronized void start() {
    if (running
        || stopInProgress.get()
        || !settings.relayEnabled()
        || batchActive.get()
        || (worker != null && worker.isAlive())) return;
    stopping = false;
    running = true;
    worker = new Thread(this::run, "outbox-relay");
    worker.setDaemon(true);
    worker.start();
  }

  private void run() {
    try {
      while (running && !Thread.currentThread().isInterrupted()) {
        boolean fullSuccess = false;
        try {
          fullSuccess = relayOnce() == settings.batchSize();
        } catch (EventFaults.Crash crash) {
          LOG.warn("Relay stopped at controlled boundary");
          break;
        } catch (RuntimeException error) {
          LOG.warn("Relay dependency unavailable errorType={}", error.getClass().getSimpleName());
        }
        // Immediately continue productive full batches. Idle, partial, stale and failed work keeps
        // the configured pause; per-event retry eligibility still lives in PostgreSQL.
        if (fullSuccess) continue;
        try {
          long pausedAt = System.nanoTime();
          try {
            Thread.sleep(settings.pollIntervalMs());
          } finally {
            metrics
                .timer("events.outbox.poll.pause.duration")
                .record(System.nanoTime() - pausedAt, TimeUnit.NANOSECONDS);
          }
        } catch (InterruptedException stop) {
          Thread.currentThread().interrupt();
          break;
        }
      }
    } finally {
      running = false;
    }
  }

  @Override
  public void stop() {
    if (!stopInProgress.compareAndSet(false, true)) return;
    try {
      stopWorker();
    } finally {
      stopInProgress.set(false);
    }
  }

  private void stopWorker() {
    stopping = true;
    running = false;
    long deadline =
        System.nanoTime()
            + TimeUnit.MILLISECONDS.toNanos(
                (long) settings.deliveryTimeoutMs() + settings.maxBlockMs() + 1500);
    Thread activeBatch = coordinator;
    Thread activeWorker = worker;
    if (activeBatch != null && activeBatch != Thread.currentThread()) activeBatch.interrupt();
    if (activeWorker != null && activeWorker != Thread.currentThread()) activeWorker.interrupt();
    KafkaProducer<String, String> current;
    synchronized (this) {
      // An already-admitted start may have installed a worker while stop waited for this monitor.
      stopping = true;
      running = false;
      activeBatch = coordinator;
      activeWorker = worker;
      current = producer;
      producer = null;
    }
    if (activeBatch != null && activeBatch != Thread.currentThread()) activeBatch.interrupt();
    if (activeWorker != null && activeWorker != Thread.currentThread()) activeWorker.interrupt();
    if (current != null) current.close(Duration.ofSeconds(1));
    try {
      joinUntil(activeBatch, deadline);
      if (activeWorker != activeBatch) joinUntil(activeWorker, deadline);
    } catch (InterruptedException error) {
      Thread.currentThread().interrupt();
    }
  }

  private static void joinUntil(Thread thread, long deadline) throws InterruptedException {
    if (thread == null || thread == Thread.currentThread()) return;
    long remaining = deadline - System.nanoTime();
    if (remaining > 0) TimeUnit.NANOSECONDS.timedJoin(thread, remaining);
  }

  public boolean isTerminated() {
    Thread activeWorker = worker;
    return !batchActive.get() && (activeWorker == null || !activeWorker.isAlive());
  }

  @Override
  public void stop(Runnable callback) {
    stop();
    callback.run();
  }

  /** Also closes a producer created by a manual batch while automatic relay startup is disabled. */
  @PreDestroy
  public void destroy() {
    stop();
  }

  @Override
  public boolean isRunning() {
    return running;
  }

  @Override
  public int getPhase() {
    return Integer.MAX_VALUE - 100;
  }
}
