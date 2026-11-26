package dev.tpp;

import dev.tpp.application.TransferFaults;
import dev.tpp.events.EventFaults;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;

/** Deterministic failures and bounded pauses at real commit/ack boundaries, never mocked I/O. */
final class EventTestFaults implements EventFaults, TransferFaults {
  private final ConcurrentHashMap<Hook, Plan> eventPlans = new ConcurrentHashMap<>();
  private final ConcurrentHashMap<TransferFaults.Boundary, RuntimeException> transferPlans =
      new ConcurrentHashMap<>();

  void crashOnce(EventFaults.Boundary boundary, UUID eventId) {
    failOnce(boundary, eventId, new EventFaults.Crash("Controlled " + boundary));
  }

  void failOnce(EventFaults.Boundary boundary, UUID eventId, RuntimeException failure) {
    eventPlans.put(new Hook(boundary, eventId), new Plan(failure, null, new AtomicInteger(1)));
  }

  void failTransferOnce(TransferFaults.Boundary boundary) {
    transferPlans.put(boundary, new IllegalStateException("Controlled " + boundary));
  }

  Pause pauseOnce(EventFaults.Boundary boundary, UUID eventId) {
    Pause pause = new Pause(new CountDownLatch(1), new CountDownLatch(1));
    eventPlans.put(new Hook(boundary, eventId), new Plan(null, pause, new AtomicInteger(1)));
    return pause;
  }

  /** Pauses the selected submission without assuming SQL RETURNING or callback order. */
  Pause pauseNth(EventFaults.Boundary boundary, int occurrence) {
    if (occurrence < 1 || occurrence > 1024)
      throw new IllegalArgumentException("Invalid bounded fault occurrence");
    Pause pause = new Pause(new CountDownLatch(1), new CountDownLatch(1));
    eventPlans.put(new Hook(boundary, null), new Plan(null, pause, new AtomicInteger(occurrence)));
    return pause;
  }

  @Override
  public void at(EventFaults.Boundary boundary, UUID eventId) {
    Hook hook = new Hook(boundary, eventId);
    Plan plan = eventPlans.get(hook);
    if (plan == null && eventId != null) {
      hook = new Hook(boundary, null);
      plan = eventPlans.get(hook);
    }
    if (plan == null || plan.remaining().getAndDecrement() != 1 || !eventPlans.remove(hook, plan))
      return;
    if (plan.pause() != null) {
      plan.pause().entered().countDown();
      try {
        if (!plan.pause().release().await(30, TimeUnit.SECONDS))
          throw new IllegalStateException("Controlled event pause timed out at " + boundary);
      } catch (InterruptedException failure) {
        Thread.currentThread().interrupt();
        throw new EventFaults.Crash("Interrupted at " + boundary);
      }
    }
    if (plan.failure() != null) throw plan.failure();
  }

  @Override
  public void at(TransferFaults.Boundary boundary) {
    RuntimeException failure = transferPlans.remove(boundary);
    if (failure != null) throw failure;
  }

  // Independent IDs at one seam can be paused without overwriting another in-flight test plan.
  record Hook(EventFaults.Boundary boundary, UUID eventId) {}

  record Plan(RuntimeException failure, Pause pause, AtomicInteger remaining) {}

  record Pause(CountDownLatch entered, CountDownLatch release) implements AutoCloseable {
    void awaitEntered() throws InterruptedException {
      if (!entered.await(10, TimeUnit.SECONDS))
        throw new AssertionError("Fault boundary not reached");
    }

    @Override
    public void close() {
      release.countDown();
    }
  }

  @TestConfiguration(proxyBeanMethods = false)
  static class Configuration {
    @Bean
    @Primary
    EventTestFaults eventTestFaults() {
      return new EventTestFaults();
    }
  }
}
