# ADR 006: Durable inbox and atomic activity projection

Status: accepted, 2026-10-11.

Kafka and outbox recovery can duplicate records. In-memory deduplication would forget identities on restart and cannot arbitrate independent application instances. Register the stable event ID and canonical payload digest under a PostgreSQL unique constraint, then create the transfer view and paired activity in the same transaction. Require the immutable local outbox origin and strengthen shape/atomicity with database guards.

On duplicate delivery, compare canonical content and return without another side effect. A crash before commit rolls everything back; a crash after commit is recovered through that inbox identity. This provides logical exactly-once effects only inside the defined PostgreSQL activity boundary. The projection never changes authoritative balances.

Retain inbox identities for the full possible replay horizon. This consumes permanent history/storage in the current version. External calls require their own durable boundary; this decision does not make email, another database or arbitrary network effects exactly once.
