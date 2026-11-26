package dev.tpp.application;

import dev.tpp.domain.ApiException;
import io.micrometer.core.instrument.MeterRegistry;
import java.time.Instant;
import java.util.Locale;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.LongSupplier;
import java.util.function.Supplier;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.SmartLifecycle;
import org.springframework.stereotype.Component;

/** Best-effort sampled admission, after durable key arbitration and before financial mutations. */
@Component
public class BacklogAdmission implements SmartLifecycle {
  private static final Logger LOG = LoggerFactory.getLogger(BacklogAdmission.class);
  private final BackpressureSettings settings;
  private final Supplier<BacklogSampler.Pressure> source;
  private final MeterRegistry metrics;
  private final LongSupplier nanoTime;
  private final AtomicReference<Snapshot> latest = new AtomicReference<>();
  private volatile ScheduledExecutorService executor;

  private enum Reason {
    DISABLED,
    NONE,
    UNAVAILABLE,
    STALE,
    UNPUBLISHED_COUNT,
    UNPUBLISHED_AGE,
    PUBLISHED_UNPROCESSED_COUNT,
    PUBLISHED_UNPROCESSED_AGE,
    RECOVERING;

    String label() {
      return name().toLowerCase(Locale.ROOT);
    }
  }

  private record Snapshot(
      BacklogSampler.Pressure pressure,
      long sampledNanos,
      Instant observedAt,
      Reason pressureReason) {}

  public record Status(
      boolean enabled,
      boolean bestEffort,
      boolean admitting,
      String reason,
      BacklogSampler.Pressure pressure,
      Instant observedAt,
      Double sampleAgeSeconds) {}

  @Autowired
  public BacklogAdmission(
      BackpressureSettings settings, BacklogSampler sampler, MeterRegistry metrics) {
    this(settings, sampler::sample, metrics, System::nanoTime);
  }

  BacklogAdmission(
      BackpressureSettings settings,
      Supplier<BacklogSampler.Pressure> source,
      MeterRegistry metrics,
      LongSupplier nanoTime) {
    this.settings = settings;
    this.source = source;
    this.metrics = metrics;
    this.nanoTime = nanoTime;
    metrics.gauge(
        "transfer.admission.open",
        this,
        value -> allowed(value.reason(value.latest.get())) ? 1 : 0);
    metrics.gauge(
        "transfer.admission.sample.age",
        this,
        value -> value.latest.get() == null ? Double.NaN : value.ageSeconds(value.latest.get()));
    metrics.gauge(
        "transfer.admission.unpublished",
        this,
        value ->
            value.latest.get() == null ? Double.NaN : value.latest.get().pressure().unpublished());
    metrics.gauge(
        "transfer.admission.published.unprocessed",
        this,
        value ->
            value.latest.get() == null
                ? Double.NaN
                : value.latest.get().pressure().publishedUnprocessed());
    metrics.gauge(
        "transfer.admission.unpublished.oldest.age",
        this,
        value ->
            value.latest.get() == null
                ? Double.NaN
                : value.latest.get().pressure().oldestUnpublishedAgeSeconds());
    metrics.gauge(
        "transfer.admission.published.unprocessed.oldest.age",
        this,
        value ->
            value.latest.get() == null
                ? Double.NaN
                : value.latest.get().pressure().oldestPublishedUnprocessedAgeSeconds());
  }

  /** Also callable by deterministic real-database checks; disabled policy never queries. */
  public synchronized void refresh() {
    if (!settings.enabled()) return;
    long started = nanoTime.getAsLong();
    String outcome = "failure";
    try {
      BacklogSampler.Pressure pressure = source.get();
      Snapshot prior = latest.get();
      Reason pressureReason = highPressure(pressure);
      if (pressureReason == Reason.NONE
          && prior != null
          && prior.pressureReason() != Reason.NONE
          && !belowReopenThresholds(pressure)) pressureReason = Reason.RECOVERING;
      latest.set(new Snapshot(pressure, started, Instant.now(), pressureReason));
      outcome = "success";
    } catch (RuntimeException failure) {
      // Keep prior evidence; monotonic age makes it stale. Never manufacture an empty sample.
      LOG.warn("Backlog sample unavailable type={}", failure.getClass().getSimpleName());
    } finally {
      metrics
          .timer("transfer.admission.sample.duration", "outcome", outcome)
          .record(Math.max(0, nanoTime.getAsLong() - started), TimeUnit.NANOSECONDS);
    }
  }

  public void requireCapacity() {
    if (!settings.enabled()) return;
    Reason reason = reason(latest.get());
    metrics
        .counter(
            "transfer.admission.decisions",
            "outcome",
            allowed(reason) ? "allowed" : "blocked",
            "reason",
            reason.label())
        .increment();
    if (reason == Reason.UNAVAILABLE || reason == Reason.STALE)
      throw new ApiException(
          503,
          "BACKLOG_STATUS_UNAVAILABLE",
          "Event backlog status is unavailable or stale; retry with the same Idempotency-Key");
    if (!allowed(reason))
      throw new ApiException(
          503,
          "EVENT_BACKLOG_OVERLOADED",
          "Event backlog exceeds configured admission thresholds; retry with the same"
              + " Idempotency-Key");
  }

  public Status status() {
    Snapshot snapshot = latest.get();
    Reason reason = reason(snapshot);
    return new Status(
        settings.enabled(),
        true,
        allowed(reason),
        reason.label(),
        snapshot == null ? null : snapshot.pressure(),
        snapshot == null ? null : snapshot.observedAt(),
        snapshot == null ? null : ageSeconds(snapshot));
  }

  private Reason reason(Snapshot snapshot) {
    if (!settings.enabled()) return Reason.DISABLED;
    if (snapshot == null) return Reason.UNAVAILABLE;
    if (nanoTime.getAsLong() - snapshot.sampledNanos()
        > TimeUnit.MILLISECONDS.toNanos(settings.maxSampleAgeMs())) return Reason.STALE;
    return snapshot.pressureReason();
  }

  private double ageSeconds(Snapshot snapshot) {
    return Math.max(0, nanoTime.getAsLong() - snapshot.sampledNanos()) / 1e9;
  }

  private Reason highPressure(BacklogSampler.Pressure pressure) {
    if (pressure.unpublished() >= settings.maxUnpublished()) return Reason.UNPUBLISHED_COUNT;
    if (pressure.oldestUnpublishedAgeSeconds() >= settings.maxUnpublishedAgeSeconds())
      return Reason.UNPUBLISHED_AGE;
    if (pressure.publishedUnprocessed() >= settings.maxPublishedUnprocessed())
      return Reason.PUBLISHED_UNPROCESSED_COUNT;
    if (pressure.oldestPublishedUnprocessedAgeSeconds()
        >= settings.maxPublishedUnprocessedAgeSeconds()) return Reason.PUBLISHED_UNPROCESSED_AGE;
    return Reason.NONE;
  }

  private boolean belowReopenThresholds(BacklogSampler.Pressure pressure) {
    double factor = settings.reopenPercent() / 100.0;
    return pressure.unpublished() <= settings.maxUnpublished() * factor
        && pressure.oldestUnpublishedAgeSeconds() <= settings.maxUnpublishedAgeSeconds() * factor
        && pressure.publishedUnprocessed() <= settings.maxPublishedUnprocessed() * factor
        && pressure.oldestPublishedUnprocessedAgeSeconds()
            <= settings.maxPublishedUnprocessedAgeSeconds() * factor;
  }

  private static boolean allowed(Reason reason) {
    return reason == Reason.NONE || reason == Reason.DISABLED;
  }

  @Override
  public synchronized void start() {
    if (!settings.enabled() || executor != null) return;
    executor =
        Executors.newSingleThreadScheduledExecutor(
            task -> {
              Thread thread = new Thread(task, "backlog-admission-sampler");
              thread.setDaemon(true);
              return thread;
            });
    executor.scheduleWithFixedDelay(
        this::refresh, 0, settings.sampleIntervalMs(), TimeUnit.MILLISECONDS);
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
