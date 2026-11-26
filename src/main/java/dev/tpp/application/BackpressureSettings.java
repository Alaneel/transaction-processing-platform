package dev.tpp.application;

import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

@Validated
@ConfigurationProperties("tpp.backpressure")
public record BackpressureSettings(
    boolean enabled,
    @Min(1) @Max(1_000_000_000) long maxUnpublished,
    @Min(1) @Max(604800) long maxUnpublishedAgeSeconds,
    @Min(1) @Max(1_000_000_000) long maxPublishedUnprocessed,
    @Min(1) @Max(604800) long maxPublishedUnprocessedAgeSeconds,
    @Min(1) @Max(99) int reopenPercent,
    @Min(100) @Max(60000) int sampleIntervalMs,
    @Min(100) @Max(300000) int maxSampleAgeMs,
    @Min(1) @Max(10) int queryTimeoutSeconds) {
  @AssertTrue(message = "sample freshness limit must cover the sampling interval")
  public boolean isValidFreshnessRelationship() {
    return maxSampleAgeMs >= sampleIntervalMs;
  }
}
