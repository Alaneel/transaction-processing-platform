package dev.tpp.events.consumer;

import dev.tpp.application.DatabaseErrors;
import dev.tpp.events.EventFaults;
import dev.tpp.events.EventSettings;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Timer;
import java.time.Duration;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicReference;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRebalanceListener;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.consumer.OffsetAndMetadata;
import org.apache.kafka.common.KafkaException;
import org.apache.kafka.common.TopicPartition;
import org.apache.kafka.common.config.ConfigException;
import org.apache.kafka.common.errors.WakeupException;
import org.apache.kafka.common.serialization.ByteArrayDeserializer;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.SmartLifecycle;
import org.springframework.stereotype.Component;

/**
 * One bounded record at a time, with explicit offset acknowledgements after durable DB outcomes.
 */
@Component
public class EventConsumerWorker implements SmartLifecycle {
  private static final Logger LOG = LoggerFactory.getLogger(EventConsumerWorker.class);
  private final EventSettings settings;
  private final EventProcessor processor;
  private final EventFaults faults;
  private final MeterRegistry metrics;
  private final AtomicBoolean running = new AtomicBoolean();
  private final AtomicBoolean deliveryPaused = new AtomicBoolean();
  private final AtomicLong offsetFailures = new AtomicLong();
  private final AtomicReference<Double> lag = new AtomicReference<>(Double.NaN);
  private volatile KafkaConsumer<String, byte[]> consumer;
  private volatile Thread runner;
  private EventProcessor.Delivery pending; // only the Kafka-owning thread accesses this field

  public EventConsumerWorker(
      EventSettings settings, EventProcessor processor, EventFaults faults, MeterRegistry metrics) {
    this.settings = settings;
    this.processor = processor;
    this.faults = faults;
    this.metrics = metrics;
    metrics.gauge("events.consumer.lag.max", lag, value -> value.get());
    metrics.gauge("events.consumer.running", running, value -> value.get() ? 1 : 0);
    metrics.gauge("events.consumer.paused", deliveryPaused, value -> value.get() ? 1 : 0);
  }

  @Override
  public synchronized void start() {
    if (!settings.consumerEnabled() || running.get()) return;
    if (runner != null && runner.isAlive())
      throw new IllegalStateException("Prior consumer worker has not terminated");
    running.set(true);
    runner = new Thread(this::run, "tpp-event-consumer-" + UUID.randomUUID());
    runner.setDaemon(true);
    runner.start();
  }

  @Override
  public void stop() {
    Thread current;
    synchronized (this) {
      running.set(false);
      current = runner;
      KafkaConsumer<String, byte[]> active = consumer;
      if (active != null) active.wakeup();
    }
    // A test can pause a fault seam in user code; stop still fences any later offset commit.
    if (current != null && current != Thread.currentThread()) {
      try {
        current.join(3000);
      } catch (InterruptedException interrupted) {
        Thread.currentThread().interrupt();
      }
    }
  }

  @Override
  public void stop(Runnable callback) {
    stop();
    callback.run();
  }

  @Override
  public boolean isRunning() {
    return running.get();
  }

  @Override
  public boolean isAutoStartup() {
    return true;
  }

  @Override
  public int getPhase() {
    return 20;
  }

  public boolean isTerminated() {
    Thread thread = runner;
    return thread == null || !thread.isAlive();
  }

  public long offsetCommitFailures() {
    return offsetFailures.get();
  }

  private void run() {
    try (KafkaConsumer<String, byte[]> active = connect()) {
      if (active == null) return;
      consumer = active;
      if (!running.get()) return;
      active.subscribe(
          List.of(settings.topic()),
          new ConsumerRebalanceListener() {
            @Override
            public void onPartitionsRevoked(Collection<TopicPartition> partitions) {
              discardRevoked(partitions);
              metrics.counter("events.consumer.rebalances", "transition", "revoked").increment();
            }

            @Override
            public void onPartitionsLost(Collection<TopicPartition> partitions) {
              discardRevoked(partitions);
              metrics.counter("events.consumer.rebalances", "transition", "lost").increment();
            }

            @Override
            public void onPartitionsAssigned(Collection<TopicPartition> partitions) {
              metrics.counter("events.consumer.rebalances", "transition", "assigned").increment();
            }

            // Never commit an offset during revocation. A committed effect can be redelivered
            // safely.
            private void discardRevoked(Collection<TopicPartition> partitions) {
              if (pending != null && partitions.contains(partition(pending))) pending = null;
            }
          });

      int consecutiveFailures = 0;
      while (running.get()) {
        try {
          if (pending == null) {
            var records = poll(active);
            updateLag(active);
            if (records.isEmpty()) continue;
            // max.poll.records=1 bounds pending business work to exactly one delivery.
            var record = records.iterator().next();
            pending =
                new EventProcessor.Delivery(
                    record.topic(),
                    record.partition(),
                    record.offset(),
                    record.key(),
                    record.value(),
                    1);
            metrics.counter("events.consumer.ingestion.records").increment();
          }
          EventProcessor.Delivery delivery = pending;
          var result = processor.process(delivery);
          if (result.eventId() != null)
            faults.at(EventFaults.Boundary.CONSUMER_BEFORE_OFFSET_COMMIT, result.eventId());
          if (!running.get()) break;
          // Only the individual processed record is acknowledged; no later partition offset.
          acknowledge(active, delivery);
          pending = null;
          consecutiveFailures = 0;
          if (settings.consumerMinIntervalMs() > 0)
            heartbeatBackoff(active, settings.consumerMinIntervalMs(), "optional_delay");
        } catch (EventFaults.Crash crash) {
          LOG.warn("Consumer stopped at injected crash boundary; record remains unacknowledged");
          break;
        } catch (WakeupException stopping) {
          if (running.get()) throw stopping;
          break;
        } catch (RuntimeException failure) {
          if (!DatabaseErrors.dependencyUnavailable(failure)
              && !(failure instanceof KafkaException)) {
            // Unexpected application/invariant errors retain the record and stop for inspection.
            LOG.error(
                "Consumer stopped on unclassified error type={} sqlstate={}",
                failure.getClass().getSimpleName(),
                DatabaseErrors.metricState(failure));
            break;
          }
          metrics
              .counter(
                  "events.consumer.retries",
                  "cause",
                  failure instanceof KafkaException ? "kafka" : "database")
              .increment();
          LOG.warn(
              "Consumer retry type={} sqlstate={} attempt={}",
              failure.getClass().getSimpleName(),
              DatabaseErrors.metricState(failure),
              consecutiveFailures + 1);
          consecutiveFailures = Math.min(30, consecutiveFailures + 1);
          if (pending != null)
            pending =
                new EventProcessor.Delivery(
                    pending.topic(),
                    pending.partition(),
                    pending.offset(),
                    pending.key(),
                    pending.value(),
                    Math.min(Integer.MAX_VALUE - 1, pending.attempts()) + 1);
          heartbeatBackoff(active, backoff(consecutiveFailures), "retry");
        }
      }
    } catch (WakeupException ignoredOnStop) {
      if (running.get()) LOG.error("Consumer unexpectedly interrupted");
    } catch (RuntimeException failure) {
      LOG.error("Consumer runner terminated type={}", failure.getClass().getSimpleName());
    } finally {
      consumer = null;
      pending = null;
      running.set(false);
      deliveryPaused.set(false);
      lag.set(Double.NaN);
    }
  }

  private KafkaConsumer<String, byte[]> connect() {
    int failures = 0;
    while (running.get()) {
      try {
        faults.at(EventFaults.Boundary.CONSUMER_BEFORE_CONNECT, null);
        return new KafkaConsumer<>(configuration());
      } catch (RuntimeException failure) {
        if (!bootstrapDnsUnavailable(failure)) throw failure;
        // Kafka 4.3.1 rejects construction when every bootstrap hostname is unresolved.
        // Retry that dependency condition; other configuration errors require intervention.
        failures = Math.min(30, failures + 1);
        metrics.counter("events.consumer.startup.retries").increment();
        LOG.warn("Consumer bootstrap DNS unavailable; construction retry attempt={}", failures);
        if (!startupBackoff(backoff(failures))) return null;
      }
    }
    return null;
  }

  private static boolean bootstrapDnsUnavailable(RuntimeException failure) {
    for (Throwable cause = failure; cause != null; cause = cause.getCause()) {
      if (cause instanceof ConfigException
          && "No resolvable bootstrap urls given in bootstrap.servers".equals(cause.getMessage()))
        return true;
    }
    return false;
  }

  private ConsumerRecords<String, byte[]> poll(KafkaConsumer<String, byte[]> active) {
    Timer.Sample timer = Timer.start(metrics);
    String outcome = "failure";
    try {
      var records = active.poll(Duration.ofMillis(250));
      outcome = records.isEmpty() ? "empty" : "received";
      return records;
    } finally {
      timer.stop(metrics.timer("events.consumer.poll.duration", "outcome", outcome));
    }
  }

  private void acknowledge(KafkaConsumer<String, byte[]> active, EventProcessor.Delivery delivery) {
    Timer.Sample timer = Timer.start(metrics);
    String outcome = "failure";
    try {
      active.commitSync(
          Map.of(partition(delivery), new OffsetAndMetadata(delivery.offset() + 1)),
          Duration.ofMillis(settings.requestTimeoutMs()));
      outcome = "success";
    } catch (KafkaException offsetFailure) {
      offsetFailures.incrementAndGet();
      metrics.counter("events.consumer.offset.commit.failures").increment();
      throw offsetFailure;
    } finally {
      timer.stop(
          metrics.timer("events.consumer.offset.acknowledgement.duration", "outcome", outcome));
    }
  }

  private boolean startupBackoff(long milliseconds) {
    Timer.Sample timer = Timer.start(metrics);
    deliveryPaused.set(true);
    try {
      long deadline = System.nanoTime() + Duration.ofMillis(milliseconds).toNanos();
      while (running.get() && System.nanoTime() < deadline) {
        try {
          Thread.sleep(
              Math.min(
                  100, Math.max(1, Duration.ofNanos(deadline - System.nanoTime()).toMillis())));
        } catch (InterruptedException interrupted) {
          Thread.currentThread().interrupt();
          return false;
        }
      }
      return true;
    } finally {
      deliveryPaused.set(false);
      timer.stop(metrics.timer("events.consumer.pause.duration", "reason", "startup_retry"));
    }
  }

  private void heartbeatBackoff(
      KafkaConsumer<String, byte[]> active, long milliseconds, String reason) {
    Timer.Sample timer = Timer.start(metrics);
    deliveryPaused.set(true);
    try {
      var paused = active.assignment();
      active.pause(paused);
      long deadline = System.nanoTime() + Duration.ofMillis(milliseconds).toNanos();
      try {
        while (running.get() && System.nanoTime() < deadline) {
          // Pausing fetch delivery preserves the failed record while polling services heartbeats
          // and rebalance callbacks. Revocation drops only the in-memory pending reference.
          active.pause(active.assignment());
          var unexpected =
              active.poll(
                  Duration.ofMillis(
                      Math.min(
                          100,
                          Math.max(1, Duration.ofNanos(deadline - System.nanoTime()).toMillis()))));
          // A rebalance can assign a partition inside poll, after pause's assignment snapshot.
          // Return any newly fetched record to its position, otherwise a later commit could skip
          // it.
          for (var record : unexpected) {
            var partition = new TopicPartition(record.topic(), record.partition());
            if (active.assignment().contains(partition)) active.seek(partition, record.offset());
          }
        }
      } finally {
        if (running.get()) active.resume(active.assignment());
      }
    } finally {
      deliveryPaused.set(false);
      timer.stop(metrics.timer("events.consumer.pause.duration", "reason", reason));
    }
  }

  private long backoff(int attempt) {
    long exponential =
        Math.min(
            settings.retryMaxMs(),
            settings.retryBaseMs() * (1L << Math.min(20, Math.max(0, attempt - 1))));
    return ThreadLocalRandom.current()
        .nextLong(Math.max(1, exponential / 2), Math.max(2, exponential + 1));
  }

  private static TopicPartition partition(EventProcessor.Delivery delivery) {
    return new TopicPartition(delivery.topic(), delivery.partition());
  }

  private void updateLag(KafkaConsumer<String, byte[]> active) {
    double maximum = Double.NaN;
    for (var entry : active.metrics().entrySet()) {
      if (entry.getKey().name().equals("records-lag-max")
          && entry.getValue().metricValue() instanceof Number number)
        maximum =
            Double.isNaN(maximum) ? number.doubleValue() : Math.max(maximum, number.doubleValue());
    }
    lag.set(maximum);
  }

  private Properties configuration() {
    Properties properties = new Properties();
    properties.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, settings.bootstrapServers());
    properties.put(ConsumerConfig.GROUP_ID_CONFIG, settings.consumerGroup());
    properties.put(ConsumerConfig.CLIENT_ID_CONFIG, "tpp-projection-" + UUID.randomUUID());
    properties.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
    properties.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, ByteArrayDeserializer.class);
    properties.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, false);
    properties.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
    properties.put(ConsumerConfig.ISOLATION_LEVEL_CONFIG, "read_committed");
    properties.put(ConsumerConfig.MAX_POLL_RECORDS_CONFIG, 1);
    properties.put(ConsumerConfig.MAX_POLL_INTERVAL_MS_CONFIG, 300_000);
    properties.put(
        ConsumerConfig.MAX_PARTITION_FETCH_BYTES_CONFIG, EventProcessor.MAX_PAYLOAD_BYTES);
    properties.put(ConsumerConfig.FETCH_MAX_BYTES_CONFIG, 4 * EventProcessor.MAX_PAYLOAD_BYTES);
    properties.put(ConsumerConfig.REQUEST_TIMEOUT_MS_CONFIG, settings.requestTimeoutMs());
    properties.put(
        ConsumerConfig.DEFAULT_API_TIMEOUT_MS_CONFIG, Math.max(3000, settings.requestTimeoutMs()));
    properties.put(ConsumerConfig.SESSION_TIMEOUT_MS_CONFIG, 10_000);
    properties.put(ConsumerConfig.HEARTBEAT_INTERVAL_MS_CONFIG, 1000);
    return properties;
  }
}
