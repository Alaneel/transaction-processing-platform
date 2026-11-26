# Best-effort event backlog admission

Financial transfers can complete faster than publication or activity projection. Optional admission checks limit new work when either stage accumulates pressure. They are disabled by default and do not establish a hard backlog cap, broker health guarantee, or production capacity estimate.

`BacklogAdmission` samples PostgreSQL through one scheduled thread per application instance. A single bounded statement counts all outbox rows that are not `PUBLISHED`, and all `PUBLISHED` rows without a matching `event_inbox` row. It also computes each group’s oldest age from immutable `outbox_events.created_at`. Thus `PENDING`, `CLAIMED`, and `BLOCKED` contribute publication pressure; a published event that requires quarantine replay continues to contribute consumer pressure until it reaches the inbox. Issuance and migration-backfilled events are included. The query observes a database statement snapshot, not Kafka offsets or producer connectivity.

For a new transfer key, `TransferService` first reserves the key using the existing unique constraint inside its financial transaction. It then checks the cached admission sample, before taking account locks or writing balances, postings, terminal status, or an outbox event. Denial throws an HTTP 503 error and rolls the reservation back. The key can be retried later. A prior key still follows durable arbitration: an identical payload replays its committed completed or rejected result, and a different payload returns HTTP 409. Those paths bypass admission, including when the sample is unknown or stale. No preliminary key lookup introduces a race between these decisions.

The policy closes when any count or age is **greater than or equal to** its configured high threshold. After pressure closes it, all four dimensions must fall to or below their respective threshold multiplied by `reopen-percent` before it reopens. This hysteresis prevents reopening as soon as one event drains. A fresh sample below the high thresholds admits normally until another high threshold is reached. Initial sample absence and excessive sample age fail closed only when the policy is enabled. Sampling failure retains the last real evidence; it does not substitute zero pressure. That evidence becomes unusable as it ages.

Sample freshness uses monotonic elapsed time measured from before connection acquisition and the query. The returned `observedAt` is application wall-clock time after a successful query. It is not the financial commit time or PostgreSQL WAL durability timestamp. Sampling uses a JDBC statement timeout, while connection acquisition retains the application pool’s configured timeout. The next scheduled sample begins after the previous sample finishes and the configured interval passes; there is no overlapping sampling or queued query backlog. Stopping the sampler cancels future scheduling; cached evidence remains available and expires normally.

Concurrent requests and other application instances can all use the same older sample and admit more work before the next sample closes admission. Work already in flight also continues. Hysteresis is local to each instance, and the sampling statement scans retained event history. These are intentional trade-offs of a sampled signal. Thresholds must be selected from measurements and operational needs; the defaults below are examples, not measured safety limits. The policy neither reserves shared capacity nor prevents backlog overshoot.

## Operating strategy

| Condition | Evidence and response |
| --- | --- |
| Temporary burst | Watch committed unpublished and published-without-inbox counts and ages. PostgreSQL/Kafka absorb accepted work durably; the relay's outstanding-record semaphore and consumer's one pending delivery bound application-held work. Drain the burst before declaring steady-state capacity. |
| Sustained excess input | Compare committed input, publication and projection over the same observation interval. Growing backlog means the offered rate is unsustainable even if HTTP succeeds. Enable measured count/age thresholds to refuse new keys and let accepted work drain; clients retain keys and retry after recovery. |
| Kafka unavailable | Unpublished count/age, producer failures, durable next-attempt times and lease recovery explain pressure. No financial commit depends on a broker ACK. Capped jittered retries and partial-batch polling pauses prevent a tight failure loop. Restore the broker and verify publication, projection and committed offsets separately. |
| Consumer slower than publication | Published-without-inbox count/age and independent broker group lag reveal the downstream limit. Inspect processing/DB/offset timers, retry and quarantine counters. Admission can restrict new work without discarding existing Kafka records or weakening offset safety. |
| PostgreSQL slowdown | Pool pending connections, sampled lock waits and claim/settlement/projection transaction durations distinguish DB pressure from broker delay. Bounded statements and transactions fail/retry; stale admission evidence fails closed when enabled. Failed status settlement leaves claims recoverable rather than counting ACKs as committed publication. |
| Retained storage pressure | Count/age thresholds are early operating signals. Monitor actual PostgreSQL and Kafka volume bytes/free space independently: this policy does not measure disk capacity, reserve space or cap historical storage. Stop admitting new work before exhaustion and plan retention/archive with the deduplication horizon intact. |

The matched [performance experiments](phase3-performance.md) deliberately disable optional admission in both images to observe each stage's capacity and overload behavior. The real PostgreSQL/HTTP tests separately verify refusal, replay and recovery semantics. Neither establishes a universally safe threshold. Alert examples are sustained positive backlog slope, unavailable/stale sampling, any structural reconciliation discrepancy, increasing expired claims, rising quarantine, or low volume free space; select durations and byte limits for the actual deployment.

Both optimized thirty-second runs at 500 scheduled arrivals/s accumulated consumer backlog despite keeping publication caught up. At the separately declared 250/s operating point, both runs processed about 245 accepted events/s with no input-end backlog and 304–314 ms propagation p99. These short local observations justify monitoring downstream pressure; they do not establish long-duration capacity or validate the default admission thresholds. Global reconciliation also encountered a parallel-query shared-memory allocation failure at 178,795 retained events before later unchanged-environment checks succeeded. Observe query availability and container resource limits alongside durable backlog.

## Configuration

All fields are validated on startup, including when disabled. Positive thresholds, a reopen percentage from 1 to 99, and a freshness limit at least as large as the sampling interval are required. Compose exposes the same environment variables as the application.

| Environment variable | Default | Meaning |
| --- | ---: | --- |
| `BACKPRESSURE_ENABLED` | `false` | Start sampling and enforce admission |
| `BACKPRESSURE_MAX_UNPUBLISHED` | `10000` | High publication count threshold |
| `BACKPRESSURE_MAX_UNPUBLISHED_AGE_SECONDS` | `60` | High oldest unpublished age threshold |
| `BACKPRESSURE_MAX_PUBLISHED_UNPROCESSED` | `10000` | High published-without-inbox count threshold |
| `BACKPRESSURE_MAX_PUBLISHED_UNPROCESSED_AGE_SECONDS` | `60` | High oldest published-without-inbox age threshold |
| `BACKPRESSURE_REOPEN_PERCENT` | `75` | Low threshold as a percentage of each high threshold |
| `BACKPRESSURE_SAMPLE_INTERVAL_MS` | `1000` | Delay after each completed sampling attempt |
| `BACKPRESSURE_MAX_SAMPLE_AGE_MS` | `5000` | Maximum usable sample age |
| `BACKPRESSURE_QUERY_TIMEOUT_SECONDS` | `2` | Sampling statement timeout |

For example, `BACKPRESSURE_ENABLED=true docker compose up --build` enables the defaults. Existing local history may already exceed the age threshold; inspect the status before submitting new transfers. With admission disabled, this component starts no sampling thread, makes no sampling query, and adds no admission decision counter to transfer requests.

## Inspection and responses

`GET /internal/backpressure` reads only cached state:

```json
{
  "enabled": true,
  "bestEffort": true,
  "admitting": false,
  "reason": "unpublished_count",
  "pressure": {
    "unpublished": 10000,
    "oldestUnpublishedAgeSeconds": 12.4,
    "publishedUnprocessed": 3,
    "oldestPublishedUnprocessedAgeSeconds": 0.7
  },
  "observedAt": "2026-10-11T12:00:00Z",
  "sampleAgeSeconds": 0.2
}
```

This is an illustrative response, not a recorded benchmark. Before the first sample, `pressure`, `observedAt`, and `sampleAgeSeconds` are null. A disabled policy reports `admitting: true` and `reason: disabled`. Enabled reasons are `none`, `unavailable`, `stale`, `unpublished_count`, `unpublished_age`, `published_unprocessed_count`, `published_unprocessed_age`, or `recovering`.

Pressure or hysteresis denial returns `EVENT_BACKLOG_OVERLOADED`. Initial or stale evidence returns `BACKLOG_STATUS_UNAVAILABLE`. Both use HTTP 503, `Retry-After: 1`, the normal structured error body, and the request correlation ID. A client retries with the same `Idempotency-Key` and payload. No rejected financial result is persisted for an admission denial. Input validation still precedes the financial transaction; account-level business validation for a new key occurs after admission.

## Metrics and verification

`transfer.admission.decisions` counts `allowed` or `blocked` decisions with the bounded reasons above. `transfer.admission.sample.duration` times successful and failed attempts, including connection acquisition and the statement. Gauges expose `transfer.admission.open`, `transfer.admission.sample.age`, `transfer.admission.unpublished`, `transfer.admission.published.unprocessed`, and each group’s `.oldest.age`. Unknown pressure and age gauges are `NaN`, rather than invented zeros. HTTP transfer outcome metrics classify both admission errors as `overloaded`, separately from dependency errors. There are no account, event, key, or exception-message metric labels.

Focused unit checks cover disabled behavior, initial and stale evidence, threshold boundaries, hysteresis, sampling failure/recovery, configuration validation, and error responses. Real PostgreSQL/HTTP checks cover prior-key replay/conflict during pressure, concurrent new-key denial with unchanged financial history and balances, consumer backlog count and age, statement timeout, and recovery using the same denied key. The admission fixtures advance valid publication states directly and invoke the production inbox processor; they are not Kafka delivery evidence. Execution results belong to the current verification report and must be recorded after the suite runs. Sustainable overload and matched throughput trials remain separate measured experiments.
