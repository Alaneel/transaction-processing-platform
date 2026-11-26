package dev.tpp.application;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

@Validated
@ConfigurationProperties("tpp.transfer")
public record TransferSettings(
    @Min(1) @Max(5) int maxAttempts,
    @Min(1) @Max(5000) int lockTimeoutMs,
    @Min(1) @Max(30000) int statementTimeoutMs,
    @Min(1) @Max(60) int transactionTimeoutSeconds,
    @Min(1) @Max(1000) int backoffMs) {}
