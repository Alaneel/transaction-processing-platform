# Architecture

The platform is a modular monolith with a synchronous financial core and independently managed event workers. Java 21 and Spring Boot 4.1.1 provide HTTP transport, validation, JDBC transactions, a bounded Hikari pool and Micrometer/Actuator. PostgreSQL 17.11 stores the authoritative ledger, balances, outbox, consumer inbox, activity projection and quarantine audits. Flyway owns versioned DDL. Kafka broker/client 4.3.1 provide asynchronous transport outside the financial transaction.

The completed Phase 1 snapshot is commit `2fd2543`, with its historical [testing](testing.md), [performance](performance.md), [query plans](query-plans.md) and ADRs 001–003 preserved. The Phase 2 event pipeline is retained at implementation commit `503ed39`. Phase 3 adds bounded asynchronous batch publication and optional sampled admission while preserving those financial and consumer boundaries. Historical measurements remain separate from the [matched Phase 3 methodology](phase3-benchmark-methodology.md).

## Boundaries

- `domain`: exact value limits, validated transfer commands, terminal lifecycle semantics, and result records. No JDBC or HTTP dependencies.
- `persistence`: parameterized, explicit SQL in `LedgerStore`; no hidden ORM flushes or process-local financial locks.
- `application`: transaction ownership, account operations, transfer execution/retry policy, read-only reconciliation, and an injectable no-op fault seam.
- `http`: request validation, status/error mapping, resource routes and correlation identifiers. Controllers delegate financial decisions.
- `events`: one concrete versioned event codec, validated worker configuration and injectable event failure seams.
- `events.relay`: short SQL claims, fenced publication evidence, a bounded Kafka producer and outbox inspection/metrics.
- `events.consumer`: raw Kafka polling and explicit offsets, transactional inbox/activity effects, durable quarantine/replay and read-only projection inspection.

The application is one deployable artifact. Its schema is fixed to `public`; test runs create independent databases rather than changing production name resolution. Migration credentials and runtime credentials are separate in Compose. Runtime credentials cannot disable triggers, rewrite ledger entries, truncate history, or complete issuance transfers. The local Compose database owner is privileged for setup and controlled fixtures; it is not a hardened production administration design.

## Transfer lifecycle

1. Validate amount, account identifiers, supported unit and the `Idempotency-Key` syntax. No durable request exists for malformed input.
2. Start a fresh `READ COMMITTED` transaction. Apply transaction-local lock and statement timeouts.
3. Insert a `PROCESSING` transfer with the unique key and the full canonical request fields, using `ON CONFLICT DO NOTHING`.
4. If the key exists, the insert waits for the other writer to commit or roll back. A subsequent statement sees the durable result at `READ COMMITTED`. Compare all four payload fields. Return it on equality; raise conflict on mismatch. A timeout while waiting is an infrastructure error, never a false replay.
5. For a new key, check the optional cached admission signal. A refusal rolls back its reservation before financial mutation. Then lock both account and balance rows in **PostgreSQL UUID order**. Check existence, USER kind, ACTIVE status, FIC unit, sufficient funds and destination headroom under those locks.
6. Business rejection becomes `REJECTED` with a reason and no postings. Success updates both balances, appends the source negative and destination positive postings, and becomes `COMPLETED`. Its AFTER UPDATE trigger inserts exactly one immutable `TransferCompleted` outbox event in this transaction.
7. PostgreSQL checks deferred constraints at commit: terminal state, exact paired postings, balance/ledger agreement and the required completed-transfer outbox event. `TransactionTemplate.execute` returns only after commit succeeds. The controller then emits the terminal response.

`PROCESSING` exists only inside the transaction and cannot commit. There is no durable PENDING queue or FAILED state. A confirmed transaction rollback removes the reservation and all effects. Connection loss around COMMIT can be ambiguous: the terminal result may already be durable, so it is recovered with the same key. A response failure after commit leaves the terminal row intact. A subsequent identical request retrieves that result, including on another application instance or after restart.

## HTTP contract

The static, versioned [OpenAPI specification](../src/main/resources/static/openapi.yaml) is served at `/openapi.yaml`. Successful new transfers return 201 with Location; completed replays return 200. New and replayed business rejections return 422 and the same transfer schema, including `rejectionCode`. `Idempotency-Replayed` distinguishes them. Resource GETs return 200, even for a rejected transfer.

Malformed input returns 400, missing resources 404, payload/key conflicts 409, exhausted lock retries and dependency/timeouts 503. Errors have `code`, `message` and `correlationId`. An unexpected internal failure returns 500; clients must still reuse the same key because a lost response does not prove rollback. Each response includes `X-Correlation-ID`; safe supplied identifiers are echoed, otherwise generated. Unsupported fields and fractional numeric amounts are rejected. FIC is the only supported unit; there is no implicit conversion.

Ledger pages use ascending immutable entry IDs and an exclusive `after` cursor, with `limit` 1–100. They are live reads, not a multi-request snapshot. The account balance lock serializes posting/commit order for that account. Rolled-back identity values may leave gaps. An empty final page has a null next cursor.

Read-only `/internal/reconciliation` scans the complete dataset in one `REPEATABLE READ` snapshot; it reports mismatches and invalid journals and performs no repairs. It includes issuance in global conservation totals. It has a ten-second transaction timeout and is intended for educational/local inspection, not unlimited reporting over a large production dataset.

## Resources, errors and observability

Defaults: 16 maximum DB connections, two minimum idle, two-second acquisition timeout; at most three transfer transaction attempts, 200ms lock timeout, three-second statement timeout, five-second Spring transaction timeout. Backoff starts at 20ms with jitter and doubles between attempts. Configuration is bounded and validated. These are operational bounds, not a strict end-to-end SLA: pool acquisition, individual statements, retries and HTTP response time all contribute. Graceful shutdown allows in-flight requests ten seconds; crashes are handled by PostgreSQL transaction rollback or committed replay.

Only SQLSTATE 40001 (serialization failure), 40P01 (deadlock) and 55P03 (lock timeout) are retried. Statement cancellation 57014, database shutdown 57P01/57P02/57P03, Spring transaction deadline expiry and connection errors receive 503 without automatic retry; a connection loss around COMMIT may be ambiguous. Pool acquisition failures also receive 503. Constraint/programming errors receive 500. The service does not convert arbitrary infrastructure failures into business rejection.

Structured JSON logs contain transfer IDs, outcomes, retry classifications and correlation IDs. They do not contain request keys, submitted account payloads, passwords or SQL exception text. Actuator exposes HTTP request timers, transfer request/transaction timers, bounded outcome/error/retry counters, Hikari pool gauges, and DB-backed readiness. Liveness deliberately does not depend on DB availability. Metrics and reconciliation are unauthenticated: Compose binds ports to loopback and public deployment is outside Phase 1.

## Atomic event ownership

V1 retains the original financial schema. V2 adds `outbox_events` and trigger/deferred checks; V3 adds inbox, projection and quarantine. The completed transfer owns one stable event UUID and one immutable JSONB envelope. A unique transfer foreign key makes repeat creation impossible, and the payload guard verifies it describes the completed transfer. All completed transfers receive events, including controlled issuance; historical completed transfers receive one migration-backfill event. REJECTED transfers do not emit events because there is no implemented rejection consumer.

The trigger executes in the same PostgreSQL transaction as completion. An outbox failure rolls back balances, postings, reservation and terminal state. Rolled-back event UUIDs are not observable business identities. Request replay returns the existing terminal row without another completion transition, preserving its event identity. The transaction-local request correlation identifier enters the event; database fixtures and migration backfill use explicit safe fallback identifiers.

Nothing in this boundary calls Kafka. Readiness includes the database and excludes Kafka. A broker outage accumulates durable events and can consume database storage. Default-off [backlog admission](backpressure.md) can reject a new reservation before financial mutations; identical-key recovery and conflict arbitration still use the committed result. An overload exception rolls the new reservation back. Sampled thresholds are best-effort and allow concurrent overshoot, never a hard capacity guarantee. This is the concrete reason for the [outbox decision](adr/004-transactional-outbox.md).

## Claim, publication and crash recovery

`OutboxStore.claim` runs a short bounded transaction. Eligible PENDING records whose scheduled retry time has arrived and CLAIMED records whose lease expired are selected with `FOR UPDATE SKIP LOCKED`. Updating the rows records a worker UUID, fresh claim token, lease deadline and monotonically increasing attempt count. Multiple instances skip each other's live locked claims.

`OutboxRelay` uses one coordinator per instance, a bounded asynchronous record set and one reusable producer. A short batch renewal retains live generations; callbacks only complete immutable event/token slots in memory. One deadline freezes results and one bounded SQL transaction persists each acknowledged/failed row with its own token and live-lease fence. Publication metrics and return counts follow committed status, not callbacks. Outstanding records remain bounded across timeout and cancellation. Full successful batches continue immediately; idle/error paths retain a pause. See [the implemented algorithm](outbox.md) and [ADR 009](adr/009-bounded-batch-relay.md).

Fencing protects database state, not Kafka's network. A paused old worker can still send after another worker has claimed the event. A crash after acknowledgement but before the PUBLISHED update also leaves recoverable CLAIMED state. Retrying either case can append another Kafka record with the same event ID. Producer idempotence reduces retries within a producer session; it does not deduplicate independent outbox resend operations or producer restarts.

Retryable publication uncertainty schedules another PENDING attempt using capped exponential equal jitter. The producer has bounded delivery/request/metadata waits and a 4 MiB buffer; the relay holds only one bounded claimed batch. Network/send/status-write failures are conservatively classified AMBIGUOUS because acceptance may have happened. Permanent contract, serialization, topic or authorization failures become BLOCKED and retain evidence. They require a reasoned audited requeue after correcting the cause. No arbitrary retry count silently erases an event.

The local broker is one persistent KRaft node with replication factor one and `min.insync.replicas=1`. Producer `acks=all` therefore acknowledges that one in-sync replica; it does not demonstrate tolerance of broker disk loss. Kafka retention is seven days in Compose. A consumer falling behind beyond retention can lose access to unread Kafka records even though outbox history remains; automatic retention-loss detection/rebuild is not implemented.

## Consumer effect and offset boundaries

The raw Kafka consumer receives one record per poll and validates UTF-8, contract version/type and exact business fields. It also checks that the event identity and semantic payload match the immutable local outbox origin. The processor inserts an inbox identity and canonical SHA-256 digest, one transfer projection and paired account activity in one bounded PostgreSQL transaction. Unique constraints serialize competing duplicate attempts. A duplicate with the same canonical content returns without repeating activity. Immutable-history guards and a deferred paired-effect check strengthen this transaction boundary.

After that transaction commits, the worker explicitly commits only that partition's next offset. Crashes before the DB commit roll back; crashes after it and before the offset commit can redeliver and deduplicate. Rebalance callbacks commit no offsets. Shutdown fences later acknowledgements. The consumer pauses delivery during transient DB/Kafka retry backoff but continues polling for heartbeats and rebalances. Any record returned on a newly assigned partition inside such a poll is sought back, preserving its unprocessed position.

Permanent invalid records instead commit a PostgreSQL quarantine before offset acknowledgement. No separate Kafka DLQ publish can disappear between an offset commit and durable evidence. One MiB raw evidence is retained; oversize payloads explicitly retain a prefix, complete original length and hash. Controlled replay durably reserves a bounded attempt, applies the same origin/inbox processor, and commits any successful effect with the terminal replay audit. Interrupted/uncertain attempts retain STARTED evidence. See [consumer reliability](consumer-reliability.md) and [failure matrix](failure-matrix.md).

The activity projection is never the authority for account balances. `GET /api/accounts/{id}/activity` is eventually consistent; it includes occurrence and processing timestamps. Event reconciliation uses a repeatable-read snapshot and reports ordinary missing/awaiting projections separately from malformed links, paired activity and origin discrepancies. The guarantee is logical exactly-once effects within this PostgreSQL projection boundary, with at-least-once Kafka delivery/processing attempts. It is not universal exactly-once delivery or atomic DB/Kafka offset commit.

## Worker resources and operational visibility

Host defaults disable relay and consumer; Compose explicitly enables both. Spring manages their lifecycle independently of request handling. Defaults bound claims to 16, polling to 100 ms, leases to 15 seconds, producer delivery to three seconds, producer request/metadata waits to one second, and event DB transactions to three seconds. Retries start at 250 ms and cap at 30 seconds with jitter. Consumer work is sequential with one pending delivery, bounded fetch buffers and a five-minute maximum poll interval. Shared pools and CPU still allow messaging workloads to affect transfer latency; Kafka is not a commit dependency, but resource contention is real.

`GET /internal/events/status` reports durable outbox status counts. `GET /internal/outbox/{eventId}` shows event payload/identity, attempts, claim/error/publication metadata, successful processing times and any quarantine evidence. Separate metrics describe publication outcomes/backlog age, lease recovery, consumer attempt outcomes/duration, retries, duplicates, quarantine rows, offset failures, available local record lag and projection freshness/discrepancies. SQL gauges are cached, with sample age exposed. Outbox and projection gauges begin unavailable until their first successful sample; failed refreshes retain the prior snapshot and expose its age. Outbox count/time values are sampled atomically into one immutable object.

All financial and messaging history remains retained; casual deletion/truncation is prohibited. Retention must preserve the possible Kafka replay horizon and audit requirements, or inbox removal can reopen duplicate-effect risk. A designed archive/rebuild path, multi-broker failure experiments and PostgreSQL failover remain future work. Reproduction and capacity interpretation belong to the [Phase 3 methodology](phase3-benchmark-methodology.md), with earlier [Phase 2 evidence](phase2-performance.md) retained separately.
