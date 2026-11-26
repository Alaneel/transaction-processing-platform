package dev.tpp.events;

import java.time.Instant;
import java.util.UUID;

public record TransferCompletedEvent(
    UUID eventId,
    String eventType,
    int schemaVersion,
    UUID transferId,
    long aggregateVersion,
    UUID sourceAccountId,
    UUID destinationAccountId,
    long amountMinor,
    String unit,
    Instant occurredAt,
    String correlationId) {}
