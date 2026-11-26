# ADR 004: Transfer-owned transactional outbox

Status: accepted, 2026-10-11.

Publishing directly to Kafka before SQL commit can expose a rolled-back transfer; publishing after commit can lose the event if the process crashes. Put one immutable `TransferCompleted` event in PostgreSQL within the existing financial transaction instead. An AFTER completion trigger creates it, a unique transfer foreign key prevents another logical event, and a deferred check requires the event at commit. Backfill completed Phase 1 history during V2 migration. Ordinary idempotent replay never repeats completion.

The relay delivers after commit, so Kafka availability is excluded from financial commit/readiness. Stable identity permits consumer deduplication across the unavoidable Kafka-accepted/DB-unrecorded crash window. REJECTED events are omitted because no rejection use case exists.

This adds PostgreSQL write/storage cost and durable backlog during outages. Trigger behavior is explicit, documented and tested, including fixture issuance and rollback. At-least-once delivery depends on eventual dependency recovery and retained history; no XA transaction or exactly-once transport is claimed.
