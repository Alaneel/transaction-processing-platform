package dev.tpp.application;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import dev.tpp.application.BacklogSampler.Pressure;
import dev.tpp.domain.ApiException;
import dev.tpp.http.ApiErrorHandler;
import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import jakarta.validation.Validation;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Stream;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;
import org.springframework.mock.web.MockHttpServletRequest;

class BacklogAdmissionTest {
  private static BackpressureSettings settings(boolean enabled) {
    return new BackpressureSettings(enabled, 10, 100, 10, 100, 75, 1000, 5000, 2);
  }

  @Test
  void configurationValidationRejectsAnUnsafeThresholdAndFreshnessCombination() {
    try (var validators = Validation.buildDefaultValidatorFactory()) {
      assertThat(validators.getValidator().validate(settings(false))).isEmpty();
      assertThat(
              validators
                  .getValidator()
                  .validate(new BackpressureSettings(true, 0, 100, 10, 100, 100, 1000, 500, 2)))
          .extracting(violation -> violation.getPropertyPath().toString())
          .contains("maxUnpublished", "reopenPercent", "validFreshnessRelationship");
    }
  }

  @Test
  void disabledPolicyDoesNotScheduleOrSampleAndAdmitsWithoutInventedPressure() {
    var metrics = new SimpleMeterRegistry();
    try {
      var queries = new AtomicInteger();
      var policy =
          new BacklogAdmission(
              settings(false),
              () -> {
                queries.incrementAndGet();
                throw new AssertionError("Disabled admission must not query");
              },
              metrics,
              System::nanoTime);
      policy.start();
      policy.refresh();
      policy.requireCapacity();
      assertThat(queries.get()).isZero();
      assertThat(policy.isRunning()).isFalse();
      assertThat(policy.status().admitting()).isTrue();
      assertThat(policy.status().reason()).isEqualTo("disabled");
      assertThat(policy.status().pressure()).isNull();
      assertThat(metrics.get("transfer.admission.unpublished").gauge().value()).isNaN();
    } finally {
      metrics.close();
    }
  }

  @Test
  void initialAndStaleSamplesFailClosedWhileFreshRecoveryAdmits() {
    var metrics = new SimpleMeterRegistry();
    try {
      var clock = new AtomicLong();
      var policy =
          new BacklogAdmission(settings(true), () -> new Pressure(0, 0, 0, 0), metrics, clock::get);
      assertBlocked(policy, "BACKLOG_STATUS_UNAVAILABLE", "unavailable");
      policy.refresh();
      policy.requireCapacity();
      clock.set(5_000_000_000L);
      policy.requireCapacity(); // Exact freshness limit still qualifies.
      clock.incrementAndGet();
      assertBlocked(policy, "BACKLOG_STATUS_UNAVAILABLE", "stale");
      policy.refresh();
      policy.requireCapacity();
      assertThat(policy.status().sampleAgeSeconds()).isZero();
    } finally {
      metrics.close();
    }
  }

  @ParameterizedTest
  @MethodSource("thresholds")
  void eachCountAndAgeThresholdClosesAtItsBoundary(Pressure pressure, String reason) {
    var metrics = new SimpleMeterRegistry();
    try {
      var policy = new BacklogAdmission(settings(true), () -> pressure, metrics, () -> 0);
      policy.refresh();
      assertBlocked(policy, "EVENT_BACKLOG_OVERLOADED", reason);
      assertThat(
              metrics
                  .get("transfer.admission.decisions")
                  .tag("outcome", "blocked")
                  .tag("reason", reason)
                  .counter()
                  .count())
          .isEqualTo(1);
    } finally {
      metrics.close();
    }
  }

  static Stream<Arguments> thresholds() {
    return Stream.of(
        Arguments.of(new Pressure(10, 0, 0, 0), "unpublished_count"),
        Arguments.of(new Pressure(0, 100, 0, 0), "unpublished_age"),
        Arguments.of(new Pressure(0, 0, 10, 0), "published_unprocessed_count"),
        Arguments.of(new Pressure(0, 0, 0, 100), "published_unprocessed_age"));
  }

  @Test
  void reopeningRequiresEveryDimensionToReachItsLowWatermark() {
    var metrics = new SimpleMeterRegistry();
    try {
      var pressure = new AtomicReference<>(new Pressure(10, 0, 0, 0));
      var policy = new BacklogAdmission(settings(true), pressure::get, metrics, () -> 0);
      policy.refresh();
      assertBlocked(policy, "EVENT_BACKLOG_OVERLOADED", "unpublished_count");
      pressure.set(new Pressure(9, 0, 0, 0));
      policy.refresh();
      assertBlocked(policy, "EVENT_BACKLOG_OVERLOADED", "recovering");
      pressure.set(new Pressure(7, 0, 7, 76));
      policy.refresh();
      assertBlocked(policy, "EVENT_BACKLOG_OVERLOADED", "recovering");
      pressure.set(new Pressure(7, 75, 7, 75));
      policy.refresh();
      policy.requireCapacity();
      pressure.set(new Pressure(9, 99, 9, 99));
      policy.refresh();
      policy
          .requireCapacity(); // Below high watermarks remains open until pressure actually closes.
    } finally {
      metrics.close();
    }
  }

  @Test
  void samplingFailureRetainsEvidenceThenFreshnessClosesAndRecoveryReopens() {
    var metrics = new SimpleMeterRegistry();
    try {
      var clock = new AtomicLong();
      var failure = new AtomicReference<RuntimeException>();
      var policy =
          new BacklogAdmission(
              settings(true),
              () -> {
                if (failure.get() != null) throw failure.get();
                return new Pressure(3, 2, 1, 1);
              },
              metrics,
              clock::get);
      policy.refresh();
      failure.set(new IllegalStateException("Simulated sample dependency outage"));
      clock.set(6_000_000_000L);
      policy.refresh();
      assertThat(policy.status().pressure().unpublished()).isEqualTo(3);
      assertBlocked(policy, "BACKLOG_STATUS_UNAVAILABLE", "stale");
      assertThat(
              metrics
                  .get("transfer.admission.sample.duration")
                  .tag("outcome", "failure")
                  .timer()
                  .count())
          .isEqualTo(1);
      failure.set(null);
      policy.refresh();
      policy.requireCapacity();
    } finally {
      metrics.close();
    }
  }

  @Test
  void overloadResponsesHaveTheirOwnOutcomeAndPreserveCorrelationAndRetryHeader() {
    var metrics = new SimpleMeterRegistry();
    try {
      var request = new MockHttpServletRequest("POST", "/api/transfers");
      request.setAttribute("correlationId", "admission-test");
      for (String code : new String[] {"EVENT_BACKLOG_OVERLOADED", "BACKLOG_STATUS_UNAVAILABLE"}) {
        var response =
            new ApiErrorHandler(metrics)
                .domain(new ApiException(503, code, "Retry safely"), request);
        assertThat(response.getStatusCode().value()).isEqualTo(503);
        assertThat(response.getHeaders().getFirst("Retry-After")).isEqualTo("1");
        assertThat(response.getBody().correlationId()).isEqualTo("admission-test");
      }
      assertThat(metrics.get("transfer.outcomes").tag("outcome", "overloaded").counter().count())
          .isEqualTo(2);
      assertThat(metrics.find("transfer.outcomes").tag("outcome", "dependency_failure").counter())
          .isNull();
    } finally {
      metrics.close();
    }
  }

  private static void assertBlocked(BacklogAdmission policy, String code, String reason) {
    assertThatThrownBy(policy::requireCapacity)
        .isInstanceOf(ApiException.class)
        .satisfies(error -> assertThat(((ApiException) error).code()).isEqualTo(code));
    assertThat(policy.status().admitting()).isFalse();
    assertThat(policy.status().reason()).isEqualTo(reason);
  }
}
