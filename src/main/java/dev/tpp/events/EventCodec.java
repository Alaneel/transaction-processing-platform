package dev.tpp.events;

import dev.tpp.domain.TransferCommand;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Instant;
import java.util.HexFormat;
import java.util.Set;
import java.util.UUID;
import org.springframework.stereotype.Component;
import tools.jackson.core.StreamReadFeature;
import tools.jackson.databind.DeserializationFeature;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;

/** One concrete versioned event contract, with exact numeric checks and canonical serialization. */
@Component
public class EventCodec {
  public static final int MAX_PAYLOAD_BYTES = 1_048_576;
  private static final Set<String> FIELDS =
      Set.of(
          "eventId",
          "eventType",
          "schemaVersion",
          "transferId",
          "aggregateVersion",
          "sourceAccountId",
          "destinationAccountId",
          "amountMinor",
          "unit",
          "occurredAt",
          "correlationId");
  private final JsonMapper mapper =
      JsonMapper.builder()
          .enable(StreamReadFeature.STRICT_DUPLICATE_DETECTION)
          .enable(DeserializationFeature.FAIL_ON_TRAILING_TOKENS)
          .build();

  public TransferCompletedEvent decode(String payload) {
    if (payload == null || payload.getBytes(StandardCharsets.UTF_8).length > MAX_PAYLOAD_BYTES)
      throw invalid("PAYLOAD_SIZE", "Payload is absent or exceeds one MiB");
    JsonNode node;
    try {
      node = mapper.readTree(payload);
    } catch (RuntimeException error) {
      throw invalid("MALFORMED_JSON", "Payload is not valid JSON");
    }
    if (node == null || !node.isObject())
      throw invalid("INVALID_ENVELOPE", "Expected a JSON object");
    if (!node.properties().stream().allMatch(entry -> FIELDS.contains(entry.getKey())))
      throw invalid("UNKNOWN_FIELD", "Envelope contains unsupported fields");
    if (integer(node, "schemaVersion") != 1)
      throw invalid("UNSUPPORTED_SCHEMA", "Only schema version 1 is supported");
    if (!"TransferCompleted".equals(string(node, "eventType")))
      throw invalid("UNSUPPORTED_EVENT", "Unsupported event type");
    if (integer(node, "aggregateVersion") != 1)
      throw invalid("INVALID_AGGREGATE_VERSION", "Terminal transfer aggregate version must be 1");
    UUID source = uuid(node, "sourceAccountId"), destination = uuid(node, "destinationAccountId");
    if (source.equals(destination)) throw invalid("SAME_ACCOUNT", "Transfer accounts must differ");
    long amount = integer(node, "amountMinor");
    if (amount < 1 || amount > TransferCommand.MAX_AMOUNT)
      throw invalid("INVALID_AMOUNT", "Amount is outside the supported range");
    String unit = string(node, "unit");
    if (!"FIC".equals(unit)) throw invalid("UNSUPPORTED_UNIT", "Only FIC is supported");
    String correlationId = string(node, "correlationId");
    if (!correlationId.matches("[A-Za-z0-9._:-]{1,128}"))
      throw invalid("INVALID_CORRELATION", "Invalid correlation identifier");
    Instant occurred;
    try {
      occurred = Instant.parse(string(node, "occurredAt"));
    } catch (RuntimeException error) {
      throw invalid("INVALID_TIMESTAMP", "Invalid occurrence timestamp");
    }
    return new TransferCompletedEvent(
        uuid(node, "eventId"),
        "TransferCompleted",
        1,
        uuid(node, "transferId"),
        1,
        source,
        destination,
        amount,
        unit,
        occurred,
        correlationId);
  }

  public String encode(TransferCompletedEvent event) {
    // Record field order is fixed; ISO UTC Instant and exact integers make retries deterministic.
    return mapper.writeValueAsString(event);
  }

  public String digest(String payload) {
    try {
      return HexFormat.of()
          .formatHex(
              MessageDigest.getInstance("SHA-256")
                  .digest(payload.getBytes(StandardCharsets.UTF_8)));
    } catch (NoSuchAlgorithmException impossible) {
      throw new IllegalStateException(impossible);
    }
  }

  private String string(JsonNode node, String field) {
    JsonNode value = node.get(field);
    if (value == null || !value.isString() || value.asString().isEmpty())
      throw invalid("MISSING_FIELD", "Missing or invalid " + field);
    return value.asString();
  }

  private long integer(JsonNode node, String field) {
    JsonNode value = node.get(field);
    if (value == null || !value.isIntegralNumber() || !value.canConvertToLong())
      throw invalid("INVALID_NUMBER", "Missing or invalid " + field);
    return value.longValue();
  }

  private UUID uuid(JsonNode node, String field) {
    try {
      String value = string(node, field);
      if (!value.matches(
          "[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}"))
        throw new IllegalArgumentException();
      return UUID.fromString(value);
    } catch (RuntimeException error) {
      throw invalid("INVALID_IDENTIFIER", "Missing or invalid " + field);
    }
  }

  private EventValidationException invalid(String code, String message) {
    return new EventValidationException(code, message);
  }
}
