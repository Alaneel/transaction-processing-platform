package dev.tpp;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import dev.tpp.domain.ApiException;
import dev.tpp.domain.Models.Transfer;
import dev.tpp.domain.TransferCommand;
import dev.tpp.domain.TransferStatus;
import java.time.Instant;
import java.util.UUID;
import org.junit.jupiter.api.Test;

class DomainRulesTest {
  private final UUID source = UUID.fromString("00000000-0000-0000-0000-000000000001");
  private final UUID destination = UUID.fromString("00000000-0000-0000-0000-000000000002");

  @Test
  void exactMinorUnitBoundsAcceptOneAndMaximumButRejectZeroNegativeAndOverflow() {
    assertThat(command(1).amount()).isEqualTo(1);
    assertThat(command(TransferCommand.MAX_AMOUNT).amount()).isEqualTo(9_000_000_000_000_000L);
    for (long amount :
        new long[] {0, -1, Long.MIN_VALUE, TransferCommand.MAX_AMOUNT + 1, Long.MAX_VALUE}) {
      assertThatThrownBy(() -> command(amount))
          .isInstanceOfSatisfying(
              ApiException.class,
              error -> {
                assertThat(error.status()).isEqualTo(400);
                assertThat(error.code()).isEqualTo("INVALID_AMOUNT");
              });
    }
  }

  @Test
  void bothAccountIdentifiersAreRequiredAndSelfTransfersAreInvalid() {
    assertThatThrownBy(() -> new TransferCommand(null, destination, 1, "FIC"))
        .isInstanceOf(ApiException.class);
    assertThatThrownBy(() -> new TransferCommand(source, null, 1, "FIC"))
        .isInstanceOf(ApiException.class);
    assertThatThrownBy(() -> new TransferCommand(source, source, 1, "FIC"))
        .isInstanceOfSatisfying(
            ApiException.class, error -> assertThat(error.code()).isEqualTo("SAME_ACCOUNT"));
  }

  @Test
  void unsupportedOrAmbiguousUnitsCannotEnterDomain() {
    for (String unit : new String[] {null, "", "fic", "USD", " FIC", "FIC "}) {
      assertThatThrownBy(() -> new TransferCommand(source, destination, 1, unit))
          .isInstanceOfSatisfying(
              ApiException.class, error -> assertThat(error.code()).isEqualTo("UNSUPPORTED_UNIT"));
    }
  }

  @Test
  void keyValidationHasBoundedPrintableIdentityWithoutWhitespaceNormalization() {
    assertThat(TransferCommand.validateKey("invoice-01:retry_2.3"))
        .isEqualTo("invoice-01:retry_2.3");
    assertThat(TransferCommand.validateKey("x".repeat(128))).hasSize(128);
    for (String key :
        new String[] {
          null, "", " ", "with space", "x".repeat(129), "newline\n", "非ascii", "slash/key"
        }) {
      assertThatThrownBy(() -> TransferCommand.validateKey(key))
          .isInstanceOfSatisfying(
              ApiException.class,
              error -> assertThat(error.code()).isEqualTo("INVALID_IDEMPOTENCY_KEY"));
    }
  }

  @Test
  void onlyTransientProcessingCanMoveIntoTerminalStates() {
    for (TransferStatus from : TransferStatus.values()) {
      for (TransferStatus to : TransferStatus.values()) {
        assertThat(from.canTransitionTo(to))
            .as("transition %s -> %s", from, to)
            .isEqualTo(from == TransferStatus.PROCESSING && to != TransferStatus.PROCESSING);
      }
    }
    assertThat(TransferStatus.PROCESSING.canTransitionTo(null)).isFalse();
  }

  @Test
  void idempotencyComparisonIncludesEveryFinancialPayloadField() {
    Transfer prior =
        new Transfer(
            UUID.randomUUID(),
            source,
            destination,
            10,
            "FIC",
            TransferStatus.COMPLETED,
            null,
            Instant.EPOCH,
            Instant.EPOCH.plusSeconds(1));
    assertThat(prior.matches(command(10))).isTrue();
    assertThat(prior.matches(command(11))).isFalse();
    assertThat(prior.matches(new TransferCommand(destination, source, 10, "FIC"))).isFalse();
    assertThat(prior.matches(new TransferCommand(source, UUID.randomUUID(), 10, "FIC"))).isFalse();
    assertThat(prior.matches(new TransferCommand(UUID.randomUUID(), destination, 10, "FIC")))
        .isFalse();
  }

  private TransferCommand command(long amount) {
    return new TransferCommand(source, destination, amount, "FIC");
  }
}
