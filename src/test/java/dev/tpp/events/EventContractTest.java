package dev.tpp;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import dev.tpp.events.EventCodec;
import dev.tpp.events.EventValidationException;
import dev.tpp.events.RetryDelay;
import dev.tpp.events.TransferCompletedEvent;
import java.time.Instant;
import java.util.UUID;
import org.junit.jupiter.api.Test;

class EventContractTest {
  private final EventCodec codec = new EventCodec();
  private final TransferCompletedEvent event = new TransferCompletedEvent(
      UUID.fromString("00000000-0000-0000-0000-000000000001"), "TransferCompleted", 1,
      UUID.fromString("00000000-0000-0000-0000-000000000002"), 1,
      UUID.fromString("00000000-0000-0000-0000-000000000003"),
      UUID.fromString("00000000-0000-0000-0000-000000000004"), 100, "FIC",
      Instant.parse("2026-10-11T00:00:00.123456Z"), "test-correlation");

  @Test
  void canonicalRoundTripKeepsStableIdentityExactMinorUnitsAndMicrosecondTimestamp() {
    String encoded = codec.encode(event);
    assertThat(codec.decode(encoded)).isEqualTo(event);
    assertThat(codec.encode(codec.decode(encoded))).isEqualTo(encoded);
    assertThat(codec.digest(encoded)).hasSize(64);
    assertThat(codec.digest(codec.encode(codec.decode(encoded)))).isEqualTo(codec.digest(encoded));
    assertThat(encoded).contains("\"amountMinor\":100", "2026-10-11T00:00:00.123456Z");
  }

  @Test
  void contractRejectsUnknownVersionsImpreciseNumbersAndImpossibleBusinessFields() {
    String encoded = codec.encode(event);
    for (String invalid : new String[] {
        encoded.replace("\"schemaVersion\":1", "\"schemaVersion\":2"),
        encoded.replace("\"schemaVersion\":1", "\"schemaVersion\":4294967297"),
        encoded.replace("\"amountMinor\":100", "\"amountMinor\":100.0"),
        encoded.replace("\"amountMinor\":100", "\"amountMinor\":9000000000000001"),
        encoded.replace("\"amountMinor\":100", "\"amountMinor\":0"),
        encoded.replace(event.destinationAccountId().toString(), event.sourceAccountId().toString()),
        encoded.replace("\"unit\":\"FIC\"", "\"unit\":\"USD\""),
        encoded.replace("\"eventType\":\"TransferCompleted\"", "\"eventType\":\"BalanceSet\""),
        encoded.substring(0, encoded.length() - 1) + ",\"accountOwner\":\"unnecessary\"}",
        encoded.replace("2026-10-11T00:00:00.123456Z", "invalid-time")}) {
      assertThatThrownBy(() -> codec.decode(invalid)).isInstanceOf(EventValidationException.class);
    }
  }

  @Test
  void ambiguousJsonEnvelopesAreRejectedInsteadOfAcceptingHiddenDuplicateOrTrailingFields() {
    String encoded = codec.encode(event);
    String duplicate = encoded.substring(0, encoded.length() - 1) + ",\"amountMinor\":101}";
    assertThatThrownBy(() -> codec.decode(duplicate)).isInstanceOf(EventValidationException.class);
    assertThatThrownBy(() -> codec.decode(encoded + "{}"))
        .isInstanceOf(EventValidationException.class);
    assertThatThrownBy(() -> codec.decode("{" )).isInstanceOf(EventValidationException.class);
    assertThatThrownBy(() -> codec.decode("[]")).isInstanceOf(EventValidationException.class);
  }

  @Test
  void retryJitterAlwaysHasPositiveDelayAndRemainsBoundedAfterLongOutage() {
    for (int attempt : new int[] {1, 2, 10, 100, Integer.MAX_VALUE}) {
      for (int sample = 0; sample < 100; sample++) {
        assertThat(RetryDelay.milliseconds(attempt, 25, 200)).isBetween(1L, 200L);
      }
    }
  }
}
