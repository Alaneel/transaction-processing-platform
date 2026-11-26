# ADR 008: Durable PostgreSQL quarantine and bounded audited replay

Status: accepted, 2026-10-11.

Permanent invalid events must allow following records to proceed without losing evidence. Persist original metadata, bounded raw bytes/hash, recoverable identity and classified error in PostgreSQL before advancing Kafka's offset. A unique group/topic/partition/offset constraint tolerates a crash after quarantine commit. This avoids the loss window in acknowledging first and separately publishing a Kafka DLQ record.

Transient dependency failures keep retrying with bounded attempts/timeouts and jittered scheduling; they do not imply a poison event. Unknown outcomes remain ambiguous. Replay reserves a durable STARTED audit and consumes a bounded budget, requires a reason, retains a known identity or explicitly adopts a validated correction, and uses the original inbox processor. Success and its terminal audit commit together; interrupted attempts remain inspectable.

This requires PostgreSQL for evidence and can pause processing during a DB outage. Quarantine/audit history remains immutable and retained; authentication, archive retention and automated remediation are future deployment work.
