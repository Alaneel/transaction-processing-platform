package dev.tpp.domain;

import java.time.Instant;
import java.util.UUID;

public final class Models {
  private Models() {}

  public record Account(UUID id, String status, String unit, Instant createdAt) {}

  public record Balance(UUID accountId, String unit, long amount) {}

  public record Transfer(
      UUID id,
      UUID sourceAccountId,
      UUID destinationAccountId,
      long amount,
      String unit,
      TransferStatus status,
      String rejectionCode,
      Instant createdAt,
      Instant completedAt) {
    public boolean matches(TransferCommand command) {
      return sourceAccountId.equals(command.sourceAccountId())
          && destinationAccountId.equals(command.destinationAccountId())
          && amount == command.amount()
          && unit.equals(command.unit());
    }
  }

  public record LedgerEntry(
      long id, UUID transferId, UUID accountId, long delta, Instant createdAt) {}

  public record LockedAccount(UUID id, String kind, String status, String unit, long amount) {}

  public record Submission(Transfer transfer, boolean replay) {}
}
