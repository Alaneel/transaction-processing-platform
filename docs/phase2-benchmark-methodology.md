# Event pipeline benchmark methodology

`scripts/event-benchmark.py` exercises real HTTP transfers and samples their durable outbox, inbox and activity projection in PostgreSQL. It uses Python's standard library and the same isolated double-entry funding fixture as the Phase 1 benchmark. It never resets balances, deletes history, stops containers or changes application settings. Change settings explicitly on the named development Compose project between trials.

## Measurements and bounds

Workers send one transfer at a time using a persistent HTTP connection. This is a closed-loop achieved throughput measurement: offered and started operations are the same count, with no client request queue. Each POST has a unique idempotency key and is never retried automatically. A timeout is recorded as ambiguous because the database may have committed. Requests between fresh fixture user accounts are the measurement scope; owner-only issuance funding is excluded from outbox counts.

The script retains counters and fixed logarithmic latency histograms instead of buffering individual response bodies or every latency value. HTTP quantiles are bucket upper bounds with at most 3% bin-width error above 0.01 ms. Mean and maximum HTTP latency are exact accumulated observations. Workload duration, worker count, HTTP/database timeouts, drain wait and sampler records are bounded. The sampling limit is 2,000 snapshots. This bounds client instrumentation memory; the application separately bounds relay batches, producer buffers and consumer poll sizes. PostgreSQL and Kafka storage can grow under a sustained backlog.

| Measurement | Meaning |
| --- | --- |
| Offered / started operations | HTTP calls begun during the measured interval; one in-flight request per worker |
| Completed operations | Responses with HTTP 200/201 and transfer status `COMPLETED` |
| Failed or ambiguous operations | Started operations without a successful completion response; HTTP and exception distributions are retained |
| HTTP latency | Request start through complete response/error, excluding warmup from measured results |
| Event creation / publication / processing rate | Change in scoped committed outbox rows, `PUBLISHED` rows and inbox rows divided by database observation interval; includes setup/inspection around the HTTP workload |
| Publication latency | `outbox.published_at - outbox.created_at`, including backlog wait and the post-acknowledgement database update |
| Propagation latency | `inbox.processed_at - outbox.created_at`; exact PostgreSQL p50/p95/p99/mean/max across scoped processed events, including warmup and backlog wait |
| Drain time | Wall time after the load finishes until all scoped events are published and processed, or the explicit deadline |
| Lock contention | Periodic runtime-role `pg_stat_activity`, blocking-session and ungranted-lock snapshots; brief waits may be missed |
| Query age while blocked | Time since `query_start`, including possible work before the lock wait; this is not exact lock-wait duration |

Publication is the relay's durable recorded status, which can lag Kafka's actual acceptance. Consumer processing can finish before the relay records publication. Thus event rate deltas describe observed database progress; they are not a broker ingress measurement. A duplicate Kafka record contributes one inbox effect and cannot increase the projection row count. Event status endpoint snapshots retain available application counters and consumer lag alongside scoped SQL evidence.

`created_at`, `published_at`, `processed_at` and `projected_at` are captured inside their PostgreSQL transactions, before those transactions commit. Percentiles are exact calculations over the persisted capture timestamps of committed rows; they are not WAL commit timestamps. They can understate final durable latency by the remaining transaction/commit work. The application publication/processing timers include completing their transactions, while the reported SQL percentiles make backlog wait directly inspectable. Catchup completion requires a subsequent query to see every durable outbox/inbox/projection row.

Each event-count snapshot is one SQL statement so its internal counts share a PostgreSQL statement snapshot. During load, after load and after catchup the script verifies one outbox event per scoped completed transfer, one projection per inbox record and two account activity rows per inbox record. It records any sampled invariant violations and fails the run if one occurs. Authoritative ledger/balance reconciliation must pass before and after the run. Fresh fixtures and unique keys separate the experiment from prior traffic, but process-wide actuator counters require an otherwise idle application.

## Reproduce matched throughput trials

Use a separate project and unused loopback ports. The application starts after PostgreSQL readiness and may commit transfers while Kafka is down. Compose `--wait` checks all services when testing the complete development stack.

```sh
DB_PORT=55433 APP_PORT=18080 KAFKA_PORT=19092 \
  docker compose --project-name tpp-phase2-experiment up --build -d --wait --wait-timeout 180

EVENTS_RELAY_ENABLED=false EVENTS_CONSUMER_ENABLED=true \
  DB_PORT=55433 APP_PORT=18080 KAFKA_PORT=19092 \
  docker compose --project-name tpp-phase2-experiment up -d --no-deps --force-recreate --wait app
python3 scripts/event-benchmark.py --prepare --compose-db \
  --compose-project tpp-phase2-experiment --base-url http://127.0.0.1:18080 \
  --workers 8 --duration 10 --warmup 3 --drain-timeout 0 \
  --label relay-disabled --output benchmark-results/disabled-1.json

EVENTS_RELAY_ENABLED=true EVENTS_CONSUMER_ENABLED=true \
  DB_PORT=55433 APP_PORT=18080 KAFKA_PORT=19092 \
  docker compose --project-name tpp-phase2-experiment up -d --no-deps --force-recreate --wait app
```

Wait for old pending events to drain before measuring the next enabled trial. Repeat the benchmark command with a fresh `--prepare` fixture, `--label relay-enabled` and a new output path. Use the same image, workers, warmup, duration, relay settings, connection pool, machine allocation and source contention. Alternate the enabled/disabled order across repeated trials; restarting the application changes JIT/cache state, so provide the same warmup and retain trial order. A disabled relay still incurs the atomic outbox insertion cost. Keep the consumer enabled in both settings, with an idle consumer during disabled trials. This compares activating publication and its downstream processing while preserving the consumer's configuration; it does not compare against the old Phase 1 application without an outbox.

The script saves JSON results, a dataset manifest and its funding SQL side by side. Replay the same fixture against a fresh migrated database if exact account identities are needed. Applying the fixture twice fails on existing keys and leaves prior history intact.

## Producer backlog and recovery

After the complete stack passes its smoke test, stop only the named project's Kafka service, run a fresh transfer workload with `--drain-timeout 0`, and inspect its unpublished counts. This establishes transfer creation rate greater than zero publication rate during an actual broker outage. Restart that same Kafka container and run `--observe-only --dataset <prior.dataset.json> --duration 10 --warmup 0 --drain-timeout 120`. Keep raw sampling timestamps to measure durable progress and recovery time. These steps affect only the selected experimental project; do not use broad Docker pruning or stop unrelated containers.

For a separate rate mismatch with the broker available, lower `EVENTS_RELAY_BATCH_SIZE` and increase `EVENTS_POLL_INTERVAL_MS`. A growing unpublished count shows transfer creation exceeding the available relay budget. Restore ordinary relay settings and measure catchup. Report actual rates and counts, including any failures; an assumed batch rate is not measured throughput.

## Consumer backpressure

Use `EVENTS_CONSUMER_MIN_INTERVAL_MS` as an explicit processing rate budget while leaving the broker and relay active. A sufficiently small budget allows publication to outpace consumption. Measure fresh transfers and retain scoped `published_unprocessed` counts plus available consumer lag. Restore the normal budget and use observe-only on the prior dataset to measure catchup. Pausing the consumer entirely is another documented limit case, but a slowed active consumer demonstrates a nonzero processing rate below publication rate.

The slower consumer may affect the measured HTTP rate through shared PostgreSQL resources. This is part of the modular monolith experiment, and should not be attributed solely to Kafka. Keep ordering, retry and correctness assertions separate from capacity interpretation.

## Query plans and interpretation

Capture `EXPLAIN (ANALYZE, BUFFERS)` on the relay's actual bounded eligible-event selection before and during a populated backlog. Use the same indexes and SQL predicates as the application. Record rows, loops, timing and buffer observations rather than claiming that index presence alone proves query performance. An owner-run probe may include row locking inside a transaction; roll that inspection transaction back immediately so it does not change claims.

Local short trials have scheduling, cache, JIT and storage uncertainty. PostgreSQL trigger costs grow with account history. Sampling and reconciliation add work. A closed-loop workload slows its offered rate as requests slow and cannot establish a sustainable external arrival rate. Retain full trial order, hardware, Docker allocation, Java/PostgreSQL/Kafka/client versions, application image identity, errors, unavailable meters and raw evidence. Report measured observations with these limits; do not label configured CI as executed or infer production readiness.
