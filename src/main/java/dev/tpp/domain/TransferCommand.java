package dev.tpp.domain;

import java.util.UUID;

public record TransferCommand(
    UUID sourceAccountId, UUID destinationAccountId, long amount, String unit) {
  public static final long MAX_AMOUNT = 9_000_000_000_000_000L;

  public TransferCommand {
    if (sourceAccountId == null || destinationAccountId == null)
      throw new ApiException(400, "INVALID_ACCOUNT", "Both account identifiers are required");
    if (sourceAccountId.equals(destinationAccountId))
      throw new ApiException(400, "SAME_ACCOUNT", "Source and destination must differ");
    if (amount <= 0 || amount > MAX_AMOUNT)
      throw new ApiException(
          400, "INVALID_AMOUNT", "Amount must be between 1 and 9000000000000000 minor units");
    validateUnit(unit);
  }

  public static void validateUnit(String unit) {
    if (!"FIC".equals(unit))
      throw new ApiException(400, "UNSUPPORTED_UNIT", "Only the fictional unit FIC is supported");
  }

  public static String validateKey(String key) {
    if (key == null || !key.matches("[A-Za-z0-9._:-]{1,128}"))
      throw new ApiException(
          400,
          "INVALID_IDEMPOTENCY_KEY",
          "Idempotency-Key must contain 1–128 letters, digits, dots, underscores, colons or"
              + " hyphens");
    return key;
  }
}
