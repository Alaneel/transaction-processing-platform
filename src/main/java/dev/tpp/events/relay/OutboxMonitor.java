package dev.tpp.events.relay;

import dev.tpp.events.EventSettings;
import io.micrometer.core.instrument.MeterRegistry;
import java.util.UUID;
import java.util.function.ToDoubleFunction;
import org.springframework.http.MediaType;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.web.bind.annotation.*;

@RestController
public class OutboxMonitor {
  private final OutboxStore store;
  private final EventSettings settings;

  private record Sample(OutboxStore.Stats stats, long observedAt) {}

  private volatile Sample sampled;

  public OutboxMonitor(OutboxStore store, EventSettings settings, MeterRegistry metrics) {
    this.store = store;
    this.settings = settings;
    metrics.gauge("events.outbox.pending", this, m -> m.sample(s -> s.pending() + s.claimed()));
    metrics.gauge("events.outbox.blocked", this, m -> m.sample(OutboxStore.Stats::blocked));
    metrics.gauge(
        "events.outbox.oldest.age",
        this,
        m -> m.sample(OutboxStore.Stats::oldestPendingAgeSeconds));
    metrics.gauge(
        "events.outbox.claim.expired", this, m -> m.sample(OutboxStore.Stats::expiredClaims));
    metrics.gauge(
        "events.outbox.metrics.sample.age",
        this,
        m -> {
          var current = m.sampled;
          return current == null ? Double.NaN : (System.nanoTime() - current.observedAt()) / 1e9;
        });
  }

  private double sample(ToDoubleFunction<OutboxStore.Stats> value) {
    var current = sampled;
    return current == null ? Double.NaN : value.applyAsDouble(current.stats());
  }

  @Scheduled(fixedDelay = 1000, initialDelay = 1000)
  public void refresh() {
    try {
      sampled = new Sample(store.stats(), System.nanoTime());
    } catch (RuntimeException unavailable) {
      /* Gauge sample age makes stale dependency data explicit. */
    }
  }

  public record Status(boolean relayEnabled, boolean consumerEnabled, OutboxStore.Stats outbox) {}

  @GetMapping(value = "/internal/events/status", produces = MediaType.APPLICATION_JSON_VALUE)
  public Status status() {
    return new Status(settings.relayEnabled(), settings.consumerEnabled(), store.stats());
  }

  @GetMapping(value = "/internal/outbox/{eventId}", produces = MediaType.APPLICATION_JSON_VALUE)
  public OutboxStore.Inspection inspect(@PathVariable UUID eventId) {
    return store.inspect(eventId);
  }

  public record Requeue(String reason) {}

  @PostMapping(
      value = "/internal/outbox/{eventId}/requeues",
      produces = MediaType.APPLICATION_JSON_VALUE)
  public java.util.Map<String, String> requeue(
      @PathVariable UUID eventId, @RequestBody Requeue request) {
    store.requeue(eventId, request.reason());
    return java.util.Map.of("eventId", eventId.toString(), "status", "PENDING");
  }
}
