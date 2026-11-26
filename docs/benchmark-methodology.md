# Benchmark methodology

`scripts/benchmark.py` sends real `POST /api/transfers` requests using Python's standard library. Every worker owns a persistent HTTP connection and waits for its previous response before issuing the next request. This is a **closed-loop workload**, so observed throughput is achieved request rate, not a configured arrival rate. It does not demonstrate behavior under an unlimited queue or simulate a particular real payment system.

## Reproduce a run

Start the application and PostgreSQL from the repository root. The example uses separate local ports and a named Compose project so it can coexist with other development services:

```sh
DB_PORT=55432 APP_PORT=18080 docker compose --project-name tpp-demo up --build -d --wait
python3 scripts/benchmark.py --base-url http://127.0.0.1:18080 \
  --prepare --compose-db --compose-project tpp-demo \
  --workers 8 --duration 10 --warmup 3 \
  --output benchmark-results/local.json \
  --environment-notes 'Java 21; application 0.1.0; default pool 16; record Docker CPU/memory allocation here'
```

The default Compose credentials are development credentials. The migration owner `tpp` provisions fixtures; the running application uses restricted role `tpp_app`. A local `psql` connection is another option: replace the Compose arguments with `--db-dsn postgresql://tpp@127.0.0.1:55432/tpp` and supply authentication through `PGPASSFILE` or `PGPASSWORD`. Do not put passwords in saved environment notes.

Generated artifacts sit alongside the result:

| Artifact | Contents |
| --- | --- |
| `local.json` | Environment, counts, latency summaries, metric snapshots/deltas, resource samples, reconciliation results |
| `local.dataset.json` | Exact namespace, account identities, funding, and worker pairs |
| `local.fixture.sql` | Reproducible double-entry funding transaction |

`--prepare-only` creates the fixture and manifest without running the HTTP workload. `--dataset benchmark-results/local.dataset.json` reuses an existing funded dataset instead of `--prepare`; it does not reset its balances. A fresh `--prepare` run creates a separate namespace. Run the same SQL against a fresh migrated database to reproduce the exact identities. Applying it twice to the same database fails on primary keys, leaving previous financial history unchanged.

## Datasets and contention

For `W` workers, preparation creates `3W + 2` accounts: one issuance account, `W` independent low-contention pairs, one shared high-contention source, and `W` high-contention destinations. Each initial source receives 1,000,000,000 fictional minor units by default. Owner SQL records an issuance transfer, updates both balances, inserts equal and opposite ledger postings, and completes the transfer in one transaction. The issuance account's negative balance is part of reconciliation; funding is never an HTTP minting operation.

Low-contention workers transfer one unit back and forth within their own pair. High-contention workers all debit the same source and credit separate destinations. This isolates source-account contention from destination-account contention. Each request has a unique idempotency key and correlation ID; duplicate request behavior belongs to correctness tests, rather than the throughput comparison. The dataset is reproducible; thread scheduling and measured timing are not deterministic.

Each scenario first runs a warmup, then takes a reconciliation snapshot and counter baseline, then measures for `--duration` seconds. Workers finish their current request after the deadline. The reported elapsed time includes this drain. Warmup counts and timings are retained separately and excluded from measured throughput, request percentiles, and counter deltas. Funding has ample headroom for ordinary local runs, but a reused high-contention source can eventually exhaust its funds.

## Measurements

| Measurement | Definition and practical limits |
| --- | --- |
| Offered requests | HTTP calls started by workers during the measured interval |
| Received responses | Calls for which the complete HTTP response body was received, including errors |
| Completed transfers | HTTP 200/201 responses whose JSON transfer status is `COMPLETED` |
| Throughput | Offered or completed count divided by elapsed wall time including final-request drain |
| p50/p95/p99 | Nearest-rank percentiles of request wall time, from request start through complete response/error; successful response latency is also reported separately |
| Errors | HTTP status/code distribution and client exception classes; a client timeout is ambiguous and does not prove that the database rolled back |
| Database attempt duration | `transfer.transaction` count and total-time deltas produce a mean attempt duration including transaction acquisition, SQL, and commit/rollback; this is an application timer rather than a PostgreSQL statement timer |
| Retries/database errors | Deltas of `transfer.retries` and `database.errors`; raw metric snapshots retain available totals |
| Connection pool | Sampled `hikaricp.connections.active`, `.idle`, `.pending`, and `.max` gauges, with maxima and means |
| Lock contention | Periodic `pg_stat_activity`, `pg_blocking_pids`, and `pg_locks` observations for runtime role `tpp_app`; short waits can occur between snapshots and go unseen |

The maximum observed lock-wait age is calculated from `query_start`, so it can include statement work before blocking. It is not the exact PostgreSQL lock-wait duration. Sampling includes connection and inspection overhead; the requested sampling interval is a pause between completed samples rather than a guaranteed fixed cadence. Raw timestamps make this visible.

Actuator timers/counters are process-wide. Run without unrelated traffic. The benchmark's own metric requests contribute to `http.server.requests`; they do not contribute to transfer timers. Read-only inspection GETs may reconnect once when an idle connection expires; transfer POSTs are not retried by the harness. Database observation requires owner/read access; missing meter endpoints and sampler failures are recorded explicitly. With only `--dataset` and no database connection option, HTTP benchmarking and actuator sampling still work, while PostgreSQL version/lock observations are unavailable.

Pre/post reconciliation must pass or the script fails. HTTP/client errors are saved in the report and cause exit status 1; setup/readiness/reconciliation failures cause exit status 2. The benchmark does not automatically retry an ambiguous client result, so successful-response count can be smaller than durable commit count when responses fail. Correctness tests separately verify recovery with the same idempotency key.

## Report context and interpretation

The JSON records OS, architecture, logical CPU count, Python version, hostname, PostgreSQL version/settings, worker count, dataset size, and duration. Use `--environment-notes` to record hardware model, RAM, Java/application version, Docker resource allocation, application configuration changes, and other workloads. Resource observations show the configured connection-pool maximum. Reports under `benchmark-results/` are ignored by Git; a deliberately selected path under `docs/benchmarks/` can retain measured evidence.

Local results are evidence about this workload on the recorded machine. Repeat with fresh fixtures and consistent configuration before drawing comparisons; a first run can be affected by JIT compilation, caches, log output, and storage warmup. Report actual outcomes, including errors and missing measurements. These measurements neither establish production readiness nor replace concurrent correctness and failure-path tests.
