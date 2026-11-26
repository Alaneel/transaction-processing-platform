# TransferCompleted event contract

The transfer domain owns one versioned `TransferCompleted` event for every committed completed transfer. It represents a fact already committed to PostgreSQL, not a command to change balances. Its consumers create independent activity views. Rejected transfers have no event in this version because no rejection projection is implemented.

## Version 1 envelope

An illustrative event:

```json
{
  "eventId": "00000000-0000-0000-0000-000000000001",
  "eventType": "TransferCompleted",
  "schemaVersion": 1,
  "transferId": "00000000-0000-0000-0000-000000000002",
  "aggregateVersion": 1,
  "sourceAccountId": "00000000-0000-0000-0000-000000000003",
  "destinationAccountId": "00000000-0000-0000-0000-000000000004",
  "amountMinor": 100,
  "unit": "FIC",
  "occurredAt": "2026-10-11T00:00:00.123456Z",
  "correlationId": "example-request-001"
}
```

| Field | Version 1 rule |
| --- | --- |
| `eventId` | Stable full UUID stored once in the transfer's outbox row |
| `eventType` | Exactly `TransferCompleted` |
| `schemaVersion` | Exact integral value `1` |
| `transferId` | Completed transfer UUID; Kafka record key |
| `aggregateVersion` | Exact integral value `1`, representing this sole terminal aggregate event |
| Source/destination | Full distinct account UUIDs; both ordinary users and modeled issuance are possible |
| `amountMinor` | Exact integral `1..9,000,000,000,000,000`; fractional/oversized values are invalid |
| `unit` | Exactly fictional `FIC`; no conversion or FX |
| `occurredAt` | ISO instant derived from the completed transfer's PostgreSQL timestamp |
| `correlationId` | 1–128 safe ASCII letters, digits, dots, underscores, colons or hyphens |

All fields are required. Unknown fields, duplicate JSON fields, trailing JSON objects, malformed UTF-8, absent values, unsupported type/version and invalid identifiers are rejected. The consumer payload cap is one MiB. It additionally verifies semantic equality with the immutable local outbox event, rejecting a well-formed forged identity or changed transfer fact.

The [portable v1 JSON Schema](schemas/transfer-completed-v1.schema.json) mirrors the [OpenAPI event schema](../src/main/resources/static/openapi.yaml). The Java validator also enforces distinct accounts, UTF-8/size limits and committed-origin equality. A JSON parser must reject duplicate names/trailing documents before schema validation; JSON Schema cannot recover those distinctions after parsing.

No owner names, credentials, client idempotency keys, balance snapshots or customer information enter the envelope. Account IDs and fictional transferred amounts are sufficient for the implemented projection.

## Serialization and stable identity

The database stores immutable JSONB; its key ordering is not treated as wire serialization. `EventCodec` decodes and serializes the concrete Java record in fixed field order with exact integer values, normalized UUIDs and ISO instants. Each relay retry uses that canonical form. The consumer's SHA-256 digest covers canonical serialization, so insignificant JSON formatting differences do not create separate logical identities.

The event UUID is created in the completion transaction and reused across publication attempts. A rolled-back completion emits no durable event. Idempotent request replay never creates another event. Migration V2 backfills already completed Phase 1 transfers with one durable identity apiece and an explicit `migration-backfill` correlation identifier. Their occurrence timestamps remain historical.

## Topic, key and ordering

The default topic is `tpp.transfer-completed.v1`; the default dedicated activity group is `tpp-activity-v1`. The UTF-8 Kafka key is the transfer UUID. Compose auto-creates topics with three partitions; tests explicitly create isolated topics. Provisioning/partition policy is a deployment concern, not a schema registry feature.

With a fixed partition count, records for one transfer key use the same partition. V1 has one logical terminal event per transfer, with possible transport duplicates. Transfer keys distribute independent transfers even when one source account is hot. Choosing the source account would concentrate that account's transfers but still could not simultaneously order the other account's activity.

There is no global or per-account ordering across transfers. Multiple consumers can process different partitions concurrently, and a later transfer may appear in activity before an earlier one. Occurrence time and projection time are both queryable. Leased relay retries can also change publication order. No sequence number is claimed to order a multi-account stream; `aggregateVersion=1` is a per-transfer fact.

Increasing partition count can change the partition selected for an existing key, so old and new records for that transfer may span partitions. Stable inbox identity still deduplicates them, but ordering across that change is not guaranteed. More consumers than partitions do not add useful partition processing parallelism. A future ordered aggregate model would need an explicit ordering/migration design.

## Compatibility policy

V1 validation is intentionally strict. Unsupported versions are quarantined with evidence instead of being guessed or silently downgraded. Additive envelope fields are also incompatible with this validator. Preserve V1 for its existing consumers; introduce an explicit new schema and normally a new versioned topic for incompatible evolution, then deploy/migrate consumers deliberately. No V2 decoder, schema registry, automatic upcaster or dual-publication rollout is implemented yet.

## Producer semantics

The relay explicitly configures Kafka client 4.3.1 rather than depending on changing defaults: `acks=all`, `enable.idempotence=true`, retries `Integer.MAX_VALUE` within the delivery deadline, maximum five in-flight requests per connection, `linger.ms=0`, UTF-8 string serializers, a 4 MiB producer buffer and one MiB maximum request size. Default delivery timeout is 3,000 ms, request timeout 1,000 ms and maximum metadata/buffer block 1,000 ms. SQL transactions never cover these network waits.

Idempotence protects supported producer-session retries. Resending the same outbox event after process restart or after acknowledged publication whose DB status was not saved is a separate send and can append another record. `acks=all` means all current in-sync replicas according to the broker's policy; the local single-replica setup cannot prove resilience to disk loss. See the official [Kafka 4.3 producer configuration](https://kafka.apache.org/43/configuration/producer-configs/) and [consumer API](https://kafka.apache.org/43/javadoc/org/apache/kafka/clients/consumer/KafkaConsumer.html). No exactly-once transport is claimed.
