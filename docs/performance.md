# Measured local performance

These are retained Phase 1 synchronous-core observations. Current event-pipeline comparisons belong to the [Phase 3 performance report](phase3-performance.md) and its [matched methodology](phase3-benchmark-methodology.md); earlier [Phase 2 event results](phase2-performance.md) remain separate.

These results were measured on 11 October 2026, around 20:53–20:54 Singapore time. They exercise the actual HTTP application, restricted database role, PostgreSQL transactions, ledger constraints, and double-entry SQL fixtures. They are local closed-loop measurements, not a production capacity estimate.

## Environment

| Setting | Measured environment |
| --- | --- |
| Hardware | Apple M2 Max, 12 logical cores, 32 GiB host RAM |
| Host | macOS 26.7.1, arm64; Python 3.13.0 HTTP client |
| Containers | Docker Engine/client 24.0.6, Compose 2.22.0; Docker VM 13 CPUs, 7.667 GiB RAM |
| Application | Version 0.1.0, Spring Boot 4.1.1, Temurin Java 21.0.12.1+1-LTS |
| PostgreSQL | 17.11, Alpine aarch64, `READ COMMITTED`, `shared_buffers=128MB`, `max_connections=100` |
| Connection pool | Hikari maximum 16, minimum idle 2, acquisition timeout 2,000 ms |
| Transfer attempts | Lock timeout 200 ms, statement timeout 3,000 ms, transaction timeout 5 seconds, at most 3 attempts, backoff base 20 ms |
| Network | Host HTTP client to application on loopback port 8080; application to PostgreSQL across the Compose bridge |
| Workloads | 8 then 16 workers; each scenario has 3 seconds warmup and 15 seconds measurement; new account namespace per run |
| Dataset | 26 accounts for 8 workers; 50 for 16 workers; each initial source funded with 1,000,000,000 fictional minor units |

The local application image ID was `sha256:120a408cbc538893a6701abc3efccbcf5237ed1d019abbc3f9d4ded11d7420ef`. PostgreSQL's registry digest was `postgres@sha256:b0f9560a2de083e2cc7382e75f808c7381a32852a7ec49117deedb300e552b24`. Raw reports retain these observed identities and runtime provenance. They do not imply an application image was published.

## HTTP results

Throughput divides completed successful responses by elapsed wall time including the last request's drain. All measured offered requests received HTTP 201 with `COMPLETED` status, so offered and completed rates are equal. Latencies below are successful-response wall times, using nearest-rank percentiles. Warmup is excluded.

| Workers | Scenario | Offered / completed | Elapsed seconds | Completed/s | p50 ms | p95 ms | p99 ms |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 8 | Independent account pairs | 20,105 / 20,105 | 15.006 | 1,339.78 | 5.72 | 8.37 | 11.41 |
| 8 | Shared source | 5,626 / 5,626 | 15.029 | 374.35 | 19.11 | 37.36 | 46.51 |
| 16 | Independent account pairs | 26,844 / 26,844 | 15.009 | 1,788.49 | 8.03 | 14.90 | 25.51 |
| 16 | Shared source | 5,300 / 5,300 | 15.050 | 352.15 | 43.65 | 62.71 | 77.11 |

Every measured scenario had an empty HTTP/client error distribution and zero ambiguous client errors. Pre/post reconciliation returned `consistent=true`, empty mismatch/invalid-transfer lists, and zero global ledger delta and materialized-balance total. This is correctness evidence for the exercised workload; broader rollback, duplicate, timeout, and fault boundaries are covered by the separate PostgreSQL tests.

## Database and resource observations

The database attempt timer includes connection acquisition, SQL, and commit/rollback. Its mean is computed from process-wide actuator count and total-time deltas. Pool/lock values are periodic observations rather than continuous traces.

| Workers | Scenario | Mean DB attempt ms | Lock-wait samples / samples | Max waiting sessions | Max observed query age ms | Peak active / max pool | Mean active utilization |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 8 | Independent pairs | 4.78 | 0 / 23 | 0 | 0 | 8 / 16 | 35.3% |
| 8 | Shared source | 20.60 | 24 / 24 | 7 | 34.06 | 8 / 16 | 43.2% |
| 16 | Independent pairs | 6.77 | 0 / 22 | 0 | 0 | 14 / 16 | 61.9% |
| 16 | Shared source | 44.49 | 24 / 24 | 15 | 62.76 | 16 / 16 | 90.1% |

No sampled pool pending gauge exceeded zero, and sampler error distributions were empty. Separate pool gauges are fetched sequentially, so active/idle snapshots are not atomic. The query age above is measured from `query_start` and can include work before blocking; it is not exact lock-wait duration. No sampled wait in an independent-pair run does not prove that every wait was zero.

Transaction-attempt timer counts exactly matched transfer-request counts in all four measurements, so **no additional retry attempts were observed**. The lazily registered `transfer.retries` and `database.errors` meters returned HTTP 404 both before and after these runs. Raw reports mark these meters unavailable instead of inventing a counter reading of zero. The absence is consistent with the application's counters being created only when their corresponding events occur.

The shared-source workload showed a persistent lock queue, and adding workers increased latency without increasing its measured throughput. The database also verifies affected account balances against ledger history at commit, so this workload includes growing account-history reconciliation cost. These observations do not isolate lock overhead from SQL/constraint work, logging, client scheduling, or storage effects.

## Evidence and reproduction

- [Eight-worker raw report](benchmarks/local-8-workers.json), [dataset](benchmarks/local-8-workers.dataset.json), [funding SQL](benchmarks/local-8-workers.fixture.sql)
- [Sixteen-worker raw report](benchmarks/local-16-workers.json), [dataset](benchmarks/local-16-workers.dataset.json), [funding SQL](benchmarks/local-16-workers.fixture.sql)
- [Full benchmark methodology](benchmark-methodology.md)

The measured commands ran sequentially from the repository root against an already healthy application:

```sh
python3 scripts/benchmark.py --prepare --compose-db \
  --compose-project tpp-phase1-validation --workers 8 --duration 15 --warmup 3 \
  --output docs/benchmarks/local-8-workers.json \
  --environment-notes 'Record the environment and configuration shown above'
python3 scripts/benchmark.py --prepare --compose-db \
  --compose-project tpp-phase1-validation --workers 16 --duration 15 --warmup 3 \
  --output docs/benchmarks/local-16-workers.json \
  --environment-notes 'Record the environment and configuration shown above'
```

The validation Compose project used PostgreSQL host port 55432 because port 5432 was occupied. Host database port choice does not alter application-to-database bridge routing. For a fresh local setup, use the start command in the methodology and pass the matching application URL/project name to the benchmark.

## Limits

Each scenario has one short measurement, without a confidence interval or repeated-trial variance estimate. The application stayed warm between runs, and PostgreSQL contained demo and earlier workload history; measured accounts were fresh and no other traffic/mutations ran during measurement. Fixture SQL and dataset identities are retained, but scheduling and timings are nondeterministic. Logging, JIT/cache state, Docker resource allocation, and account-ledger growth can affect results.

The load is closed-loop, so it measures achieved throughput while workers wait for responses. It does not establish a sustainable offered arrival rate under overload. Sampled pool/lock inspection contributes overhead and can miss brief peaks. No client errors occurred here; the report's successful-response count must not be interpreted as an authoritative commit count when an HTTP response is lost. These local measurements do not establish production readiness, an SLO, long-duration stability, or behavior during dependency failure.
