package dev.tpp.events.consumer;

import io.micrometer.core.instrument.MeterRegistry;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.SmartLifecycle;
import org.springframework.stereotype.Component;

/** Bounded periodic snapshots avoid executing SQL separately for every scraped gauge. */
@Component
public class ProjectionMetrics implements SmartLifecycle {
  private static final Logger LOG = LoggerFactory.getLogger(ProjectionMetrics.class);
  private final ProjectionService projection;
  private final AtomicReference<ProjectionService.Report> latest = new AtomicReference<>();
  private volatile ScheduledExecutorService executor;

  public ProjectionMetrics(ProjectionService projection, MeterRegistry metrics) {
    this.projection = projection;
    metrics.gauge(
        "events.projection.processed",
        latest,
        value -> value.get() == null ? Double.NaN : value.get().processedEvents());
    metrics.gauge(
        "events.projection.pending",
        latest,
        value -> value.get() == null ? Double.NaN : value.get().missingProjection());
    metrics.gauge(
        "events.consumer.quarantine.records",
        latest,
        value -> value.get() == null ? Double.NaN : value.get().quarantinedRecords());
    metrics.gauge(
        "events.projection.discrepancies",
        latest,
        value -> value.get() == null ? Double.NaN : value.get().discrepancies());
    metrics.gauge(
        "events.projection.oldest.unprocessed.age",
        latest,
        value ->
            value.get() == null
                ? Double.NaN
                : value.get().oldestUnprocessedAgeSeconds() == null
                    ? 0
                    : value.get().oldestUnprocessedAgeSeconds());
    metrics.gauge(
        "events.projection.last.processed.epoch",
        latest,
        value ->
            value.get() == null || value.get().lastProcessedAt() == null
                ? Double.NaN
                : value.get().lastProcessedAt().getEpochSecond());
    metrics.gauge(
        "events.projection.metrics.snapshot.age",
        latest,
        value ->
            value.get() == null
                ? Double.NaN
                : java.time.Duration.between(value.get().checkedAt(), java.time.Instant.now())
                        .toMillis()
                    / 1000.0);
  }

  @Override
  public synchronized void start() {
    if (executor != null) return;
    executor =
        Executors.newSingleThreadScheduledExecutor(
            task -> {
              Thread thread = new Thread(task, "tpp-projection-metrics");
              thread.setDaemon(true);
              return thread;
            });
    executor.scheduleWithFixedDelay(
        () -> {
          try {
            latest.set(projection.reconcile());
          } catch (RuntimeException failure) {
            LOG.warn(
                "Projection metrics snapshot unavailable type={}",
                failure.getClass().getSimpleName());
          }
        },
        0,
        5,
        TimeUnit.SECONDS);
  }

  @Override
  public synchronized void stop() {
    if (executor != null) executor.shutdownNow();
    executor = null;
  }

  @Override
  public boolean isRunning() {
    return executor != null;
  }

  @Override
  public int getPhase() {
    return 10;
  }

  @Override
  public boolean isAutoStartup() {
    return true;
  }
}
