# ADR 001: Synchronous SQL boundary and durable terminal idempotency

Status: accepted, 2026-10-11.

A transfer must atomically reserve its identity, debit and credit accounts, append paired immutable postings and persist its result. PostgreSQL owns one transaction for these operations. Use Spring JDBC with visible SQL, ordered row locks and READ COMMITTED isolation. PROCESSING is a transient state guarded against commit; COMPLETED and REJECTED are terminal and immutable. Store the request fields beside the globally unique idempotency key, rather than relying on a hash, in-memory state or a TTL.

Business rejections are durable so a retry cannot later turn insufficient funds into a new movement. Invalid transport/domain syntax is not reserved. Infrastructure failures roll back and return dependency/internal errors, with possible commit ambiguity explained to clients. The identical key/payload is mandatory for safe recovery.

This chooses a small monolith and synchronous response over a speculative async state machine. The trade-off is row contention and permanent key retention. There is no tenant/authentication namespace yet; any later tenancy design must explicitly migrate key scope. Kafka/outbox belongs in a later measured requirement and must preserve this SQL boundary.
