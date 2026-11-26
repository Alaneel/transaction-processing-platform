package dev.tpp.events;

import jakarta.validation.constraints.*;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

@Validated
@ConfigurationProperties("tpp.events")
public record EventSettings(
    @NotBlank String bootstrapServers,
    @Pattern(regexp = "[A-Za-z0-9._-]{1,249}") String topic,
    @Pattern(regexp = "[A-Za-z0-9._-]{1,128}") String consumerGroup,
    boolean relayEnabled,
    boolean consumerEnabled,
    @Min(10) @Max(30000) int pollIntervalMs,
    @Min(1) @Max(100) int batchSize,
    @Min(200) @Max(300000) int leaseMs,
    @Min(500) @Max(30000) int deliveryTimeoutMs,
    @Min(100) @Max(15000) int requestTimeoutMs,
    @Min(100) @Max(15000) int maxBlockMs,
    @Min(10) @Max(10000) int retryBaseMs,
    @Min(10) @Max(300000) int retryMaxMs,
    @Min(1) @Max(30) int dbTimeoutSeconds,
    @Min(1) @Max(10) int maxReplayAttempts,
    @Min(0) @Max(10000) int consumerMinIntervalMs) {
  @AssertTrue(message = "delivery timeout must cover request timeout and retry cap must cover base")
  public boolean isValidTimeoutRelationship() {
    return deliveryTimeoutMs >= requestTimeoutMs && retryMaxMs >= retryBaseMs;
  }
}
