# ADR 010: Optional sampled backlog admission after key arbitration

Status: accepted, 2026-10-11.

Asynchronous publication and projection can lag committed financial transfers. Keep admission disabled by default and add a best-effort PostgreSQL sample of unpublished event count/oldest age and published-without-inbox count/oldest age. One bounded statement and scheduled thread per instance avoid querying these totals for every transfer. Initial or stale evidence fails closed when enabled; failed sampling retains the previous real sample. High thresholds close admission and lower thresholds reopen it with hysteresis.

Check a new key only after the durable unique-index reservation succeeds, inside the same financial transaction, before account locks and mutations. A denial rolls the reservation back without a terminal transfer, balance change, posting, or outbox row. Prior-key replay and payload conflict bypass admission and retain existing concurrency semantics. This placement avoids a preliminary lookup race and permits safe retries during recovery.

This is a configurable pressure signal, not a hard shared capacity cap. Concurrent requests, stale-but-valid samples, in-flight work, and separate instance hysteresis allow overshoot. Counts include blocked, issuance, and backfilled events; published events without an inbox effect remain pressure even when quarantined. The sampling query scans retained history and should be evaluated as datasets grow. Defaults are examples, not evidence of safe production capacity. Inspect cached status and bounded-reason metrics, and select thresholds through measured overload experiments as described in the [policy and limitations](../backpressure.md).
