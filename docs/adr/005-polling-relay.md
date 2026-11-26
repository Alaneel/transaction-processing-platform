# ADR 005: Polling relay with expiring fenced leases

Status: accepted, 2026-10-11.

Use bounded PostgreSQL polling for the concrete transfer outbox. A short `FOR UPDATE SKIP LOCKED` transaction claims ready/expired rows with a fresh token and lease. Kafka send runs outside SQL transactions. Success/failure writes require the current unexpired token; stale owners cannot overwrite a replacement claim. Recover abandoned claims after expiry. The original Phase 2 implementation renewed and settled each event separately; [ADR 009](009-bounded-batch-relay.md) extends this decision with bounded batch renewal, asynchronous sends and per-record fenced batch settlement after measuring its costs.

CDC could stream commit changes with lower polling latency, but introduces connector, replication-slot/WAL retention and operational recovery requirements that this small modular monolith has not demonstrated a need for. Polling uses the database and client already present and makes failure windows directly inspectable.

The trade-offs are polling latency, index/query cost, lease tuning and possible duplicate sends. Fencing protects PostgreSQL state; it cannot prevent an old worker sending to Kafka. Publication uncertainty schedules capped jittered retries without erasing events. Performance evidence should decide whether CDC becomes justified later.
