# Transactional outbox and recovery

The database owns the event, and Kafka carries a copy after commit. PostgreSQL cannot atomically commit a local transfer and an ordinary Kafka send. Sending first can publish a transfer that later rolls back; committing first and then sending without durable intent can lose the event on a crash. V2 instead appends one immutable `TransferCompleted` event when a transfer becomes `COMPLETED`, inside that same transaction. The deferred completed-transfer check also requires its outbox row. Any insert/constraint failure rolls back the balances, postings, transfer and event together.

The concrete PostgreSQL trigger is intentional: a completed transfer written through a controlled issuance fixture must obey the same event invariant as an HTTP transfer. This database side effect is part of the documented commit boundary. There is no Kafka call or optional event flag in that transaction. `REJECTED` transfers do not create activity events, and replaying either terminal request does not transition it again. V1 is unchanged. V2 backfills existing completed history with one newly allocated stable identity per transfer; a real upgrade test compares all original rows before and after migration.

## Durable state and bounded evidence

`outbox_events` has a UUID event primary key and a unique transfer foreign key. It stores event/schema/aggregate version, exact immutable JSONB payload, creation time, status and monotonically increasing claim attempts. The payload must match the completed origin, including its accounts, integer amount, unit and completion timestamp. Event identity and payload cannot be rewritten or deleted. Published delivery evidence is terminal and immutable.

| State | Meaning | Recovery |
| --- | --- | --- |
| `PENDING` | Durable intent eligible at `next_attempt_at` | Worker claims when due |
| `CLAIMED` | Owner and random fencing token have an expiring lease | Live owner can renew; an expired claim can be reclaimed |
| `PUBLISHED` | Kafka acknowledged, and the live token committed topic/partition/offset evidence | No relay publication retry |
| `BLOCKED` | Permanently invalid configuration/serialization/envelope | Fix the cause and explicitly audit a requeue |

Only the last error is stored on the event: bounded code, classification, safe detail (256 characters) and timestamp. Counts and immutable requeue audits provide additional evidence; this is not an unlimited exception log. A send timeout or a failure recording publication can follow Kafka acceptance, so the relay records `AMBIGUOUS` rather than claiming the message was absent. Permanent failures retain the event. Transient or uncertain publication has controlled scheduling without an arbitrary discard limit.

## Relay algorithm

1. One batch coordinator per relay instance claims at most the configured batch size (default 16, maximum 100) and the currently available Kafka record permits. The short `FOR UPDATE SKIP LOCKED` transaction commits a fresh event-specific token, owner, lease and attempt count. Distinct instances coordinate through PostgreSQL.
2. One bounded renewal transaction refreshes only still-live claim generations and returns the committed event IDs. Lost generations are skipped. All network calls remain outside database transactions.
3. The coordinator decodes each immutable envelope and submits asynchronous sends. Before submission it registers that event ID and claim token in `PublicationBatch`. Callbacks complete only that generation's in-memory slot; they perform no SQL, blocking fault hooks or current-owner lookup. Completion order does not determine event identity.
4. A semaphore bounds actual outstanding Kafka records across batches, including callbacks that arrive after a batch deadline. A callback or synchronous submission failure releases its permit exactly once. A timeout does not release an outstanding send's permit. There is no executor or growing Java completion queue.
5. One monotonic batch deadline covers enqueue progress and callback collection. A send already entered can additionally consume its configured metadata/buffer blocking bound. Unsubmitted work is `TRANSIENT/BATCH_NOT_SENT`; submitted work without a resolved outcome is `AMBIGUOUS/DELIVERY_UNCERTAIN`. A successful acknowledgement must have the configured topic and nonnegative partition/offset. Freezing the result list makes late, duplicate and wrong-generation callbacks harmless.
6. One bounded SQL status transaction updates the immutable per-record result set. Every row requires its event ID, `CLAIMED` state, original token and unexpired lease. Acknowledged rows become PUBLISHED with their own Kafka position; failed rows become PENDING with jittered retry scheduling or BLOCKED for a permanent error. The transaction returns applied event IDs only after commit. Stale rows do not count as success. A database statement/commit failure produces no assumed publication successes and leaves durable recovery to leases; Kafka may already contain copies.
7. A full batch of committed publication successes immediately continues. Empty, partial, failed and stale batches retain the configured 100 ms default pause. Retry times remain durable and exponential (default base 250 ms, cap 30 seconds), so an outage cannot create a tight retry loop.

The measured baseline at `cba4427` retained the Phase 2 serial algorithm. During its drain, poll pauses consumed 19.330 seconds and batch work 6.316 seconds; per-event renewal/publication SQL consumed another 4.204 seconds within that batch work. Those observations justified the bounded asynchronous/batched implementation and productive-batch continuation; producer linger, buffer size and broker-request limit remain unchanged. See [measurement methodology](phase3-benchmark-methodology.md) and [raw diagnostic](benchmarks/phase3-baseline-diagnostic.json).

Default lease is 15 seconds; Kafka delivery timeout 3 seconds, request timeout 1 second and metadata/buffer blocking timeout 1 second. The batch callback deadline is delivery plus max-block plus 1 second (5 seconds by default). PostgreSQL relay transactions retain their 3-second budget and 250 ms lock timeout. The producer has a 4 MiB configured buffer and at most five in-flight broker requests per connection; broker requests can contain several records, so that setting does not replace the record semaphore. Buffer memory is one client allocation bound, not a claim that the whole JVM consumes only 4 MiB.

Stopping fences coordinator work, interrupts the coordinator and closes the producer within a requested one-second budget, then joins within one combined delivery/max-block/shutdown allowance. Eager stop flags and interrupts precede the lifecycle monitor; inside that shared start/producer monitor, stop reasserts the flags and recaptures the current worker/coordinator so an already-admitted start cannot escape the original capture. Unsettled claims remain recoverable; callbacks never persist SQL after cancellation. Restart refuses a still-live old worker or active batch. OS DNS, connection acquisition and database cleanup can extend observed shutdown; `isTerminated()` distinguishes a stop request from actual termination. A lease that expires during a slow batch loses the status fence rather than weakening it. The [lifecycle regression evidence](verification/phase3-lifecycle-red-green.json) separates the modeled scheduling window from actual Kafka shutdown/restart checks.

Lease configuration is independently bounded but is not automatically sized from every send/DB deadline. Keep it comfortably above maximum metadata blocking, delivery wait and status-write time, with scheduler/GC margin. A consistently undersized lease can repeatedly append stable duplicates while preventing the relay from recording PUBLISHED; fencing and inbox safety still hold, but publication progress requires correcting that configuration. The defaults leave this margin. No finite lease prevents a sufficiently long process pause.

Producer configuration explicitly sets `acks=all`, idempotence enabled, maximum five in-flight requests per connection, maximum protocol retries, zero linger and bounded delivery/max-block timeouts. Protocol retries are still bounded by delivery timeout. These settings reduce duplicates within one producer session. A new relay attempt, process restart or the acknowledgement-before-database-status crash window can publish another record with the same stable event ID. Real tests observe that duplicate and verify one inbox/projection effect. See the [event contract](event-contract.md) for key/ordering semantics and the [failure matrix](failure-matrix.md) for executed boundaries.

The ready/expired partial indexes and oldest-backlog index serve different eligibility/order paths. The [measured populated-backlog plan](benchmarks/phase2-query-plans-backlog.txt) selected 16 claims from 13,790 pending rows using the backlog-age index and incremental sort, examining 33 candidate rows. The full claim/update probe took 2.179 ms, including 1.130 ms in the guard trigger, and was rolled back. Its volatile time predicates were filters rather than time index bounds, but this measured case did not scan the whole backlog. Large blocked/not-yet-due prefixes can produce a different plan or scanning cost; this one observation does not prove constant cost for all status distributions.

## Inspection and recovery

`GET /internal/events/status` provides current pending, claimed, published, blocked, expired-claim counts and oldest outstanding age. `GET /internal/outbox/{eventId}` returns the immutable event, attempt count, latest error, claim state, Kafka evidence, consumer processing/projection timestamps, and latest associated quarantine ID. Publication means broker acknowledgement recorded; it does not imply consumer processing. Processing may even precede the final relay status update. SQL remains the full audit interface:

```sql
SELECT event_id, transfer_id, status, attempt_count, next_attempt_at,
       lease_until, kafka_topic, kafka_partition, kafka_offset,
       last_error_classification, last_error_code
FROM outbox_events WHERE status <> 'PUBLISHED' ORDER BY created_at, event_id LIMIT 50;
SELECT * FROM outbox_requeue_audit WHERE event_id = :'event_id' ORDER BY id;
```

After fixing a permanently invalid topic, permissions or configuration, use:

```sh
curl -X POST http://localhost:8080/internal/outbox/EVENT_UUID/requeues \
  -H 'Content-Type: application/json' \
  -d '{"reason":"Corrected topic configuration; retain original identity"}'
```

Only a `BLOCKED` event can be requeued. The reason and requeue are committed together, and a trigger requires audit evidence. Requeue changes scheduling rather than payload or identity. In local inspection APIs there is no authentication; loopback binding is the boundary, and public deployment is outside scope.

## Signals and storage limits

Outbox gauges expose outstanding/blocked count, oldest outstanding age, expired claims and gauge sample age. Counters expose success/permanent/transient/ambiguous/stale publication outcomes, retries and recovered claims; the timer measures creation-to-recorded-publication time. Rates come from counter deltas. Individual IDs appear in structured logs, never metric labels. A stale gauge sample means the last database poll failed, not that the backlog was cleared. Growing oldest age with flat successful publication rate and increasing backlog indicates delivery trouble; a `BLOCKED` record requires intervention.

Outbox and projection gauges begin unavailable (NaN) until a successful snapshot. Outbox statistics and monotonic observation time are one immutable sample, preventing a count from being paired with another refresh's timestamp. Failed refreshes retain the prior sample and increase its age. The optional [backlog admission policy](backpressure.md) additionally uses count, age and freshness signals; it is a best-effort operating threshold, never a hard storage cap.

All outbox records, inbox rows, projection records, quarantine evidence and audits are retained indefinitely. Deletion and truncation guards deliberately prevent an unreviewed purge. The Compose broker retains logs for seven days with a persistent named volume; losing an unprocessed published record to retention can require a future controlled republish/rebuild path, which is not implemented. Disk capacity and retention policy remain operational responsibilities. Full-count monitoring/reconciliation grows with history and must be redesigned before large production datasets. A privileged database owner can disable safeguards; a single local broker with replication factor one does not demonstrate replicated durability.

## Stage measurements and ordering

Relay timers expose full batch time, producer creation, claim/renewal/status transaction time, enqueue time, callback acknowledgement time, callback collection wait and explicit poll pause. `events.outbox.database.duration` has bounded operation tags (`claim`, `renew_batch`, `settle`; retained single-row helpers use `renew`, `publish`, `fail`). `events.outbox.settlement.failures` counts batches whose status transaction did not return confirmed success. `events.outbox.inflight.records` reports occupied record permits. Claim throughput, send attempts and acknowledged records are separate from committed publication throughput. Kafka acknowledgement/collection timers overlap, and database durations are children of batch duration; do not add every timer together. Stored SQL timestamps are transaction-local observations, not exact WAL commit times.

Claims are selected by age/UUID, but SQL RETURNING, asynchronous callbacks, concurrent publishers and retries provide no global or per-account publication order. The transfer-completed projection has one terminal version-one event per transfer and additive paired activity, so effects for distinct events commute. Activity ID order represents processing order; use occurrence timestamps for display without claiming strict occurrence-time delivery. Kafka partition order cannot repair races before append. A future ordered aggregate state machine would need another explicitly tested design.
