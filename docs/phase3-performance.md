# Phase 3 performance investigation and comparison

The instrumented serial baseline spent approximately three quarters of its observed relay loop in the configured 100 ms pause. Within active batch work, separate claim, renewal and publication transactions consumed most measured time. The optimized relay removes that pause after a fully successful durable batch, sends within a fixed outstanding bound and reduces renewal/settlement round trips. Actual matched results show faster publication and shorter propagation delays, with HTTP and consumer capacity tradeoffs. All twenty-eight measured trials are retained; final source verification and deployment are recorded separately.

## Baseline evidence

The [baseline provenance](benchmarks/phase3-baseline-provenance.json) records source `cba44277524cb6b10c688a225afee9d396dfd135`, image `sha256:8755901073b5f306e0ccaa5e7271fff931c57b494dbb3a5b342ce99bf78b99e2`, effective settings and the preserved Phase 1/2 stack identities. Its instrumented serial behavior passed 64 automated tests, with zero failures/errors/skips and zero SpotBugs findings before measurement. The isolated Phase 3 application also passed real HTTP/event smoke and runtime-role validation.

The host was an Apple M2 Max with twelve logical CPUs and 32 GiB memory, macOS 26.7.1 arm64 and Python 3.13.0. Docker 24.0.6 / Compose 2.22.0 used a shared VM allocation of thirteen CPUs and approximately 7.667 GiB, with no individual container CPU/memory quota. The application used Temurin 21.0.12.1+1, PostgreSQL 17.11 and Kafka broker/client 4.3.1. Phase 1 and Phase 2 containers stayed running and idle; their unchanged identities are recorded in provenance. This is one local shared-host environment, not an isolated production-capacity test.

The [unprofiled diagnostic](benchmarks/phase3-baseline-diagnostic.json) offered 4,000 scheduled requests at 500/s over eight seconds with eight maximum outstanding requests. It sent 3,796, shed 204 locally and completed 3,786; ten HTTP 422 responses were subsequently verified as `INSUFFICIENT_FUNDS` by the [fixture audit](benchmarks/phase3-baseline-diagnostic-fixture-audit.json). There were no ambiguous transport errors. Funding only one side allowed missing or reordered requests to empty the reverse source. The corrected matched fixture funds both sides, and the original negative result remains retained.

After that input, 2,986 of 3,936 scoped events, including 150 warmup transfers, remained pending. All eventually published and projected, with ledger reconciliation passing and exactly 7,872 paired account activity rows. The original observer reported approximately 116 events/s of catchup. This diagnoses the serial pipeline and is excluded from the matched comparison; the matched harness has a fresh drain-start SQL snapshot after metric inspection.

The [stage analysis](benchmarks/phase3-baseline-stage-analysis.json) provides the decomposition. Its timer observations are sequential, process-wide snapshots rather than an atomic per-fixture trace:

| Observed drain stage | Count | Total time | Mean |
|---|---:|---:|---:|
| Explicit polling pause | 191 | 19.330 s | 101.20 ms/batch |
| Active batch work | 191 | 6.316 s | 33.07 ms/batch |
| Claim transaction | 191 | 0.582 s | 3.05 ms/batch |
| Per-event renewal transaction | 2,970 | 2.140 s | 0.72 ms/event |
| Per-event published-status transaction | 2,970 | 2.064 s | 0.69 ms/event |
| Kafka future wait | 2,970 | 1.211 s | 0.41 ms/event |
| Kafka acknowledgement callback | 2,970 | 1.256 s | 0.42 ms/event |
| Consumer projection transaction | 2,970 | 4.247 s | 1.43 ms/event |
| Consumer offset acknowledgement | 2,970 | 1.177 s | 0.40 ms/event |

Pause was 75.4% of batch-plus-pause time. Claim/renew/publish transactions were 75.8% of active batch work; future waiting was 19.2%. Callback acknowledgement overlaps future waiting and must not be added again. Full batch time includes its nested stages. Consumer projection transaction includes nested work and completion timers. The consumer kept up with baseline publication and mainly waited for records; this baseline does not justify consumer parallelism.

Sampled application CPU reached 0.172 of the JVM's reported process CPU scale, active pool connections reached four of sixteen, and no pending pool connections appeared. These coarse samples do not establish a CPU limit or capture every contention spike.

## Flight recording corroboration

A separate sixty-second diagnostic recording used the same baseline image, with an intentionally accumulated backlog and JFR enabled at application startup. The requested destination dump failed with an I/O error and left a zero-byte file. The completed disk-repository chunk was recovered, validated by the JDK recording summary and scrubbed of initial environment-variable and system-property events. The [provenance](benchmarks/phase3-profile/baseline-jfr-provenance.json), [failure log](benchmarks/phase3-profile/baseline-jfr-failure.txt), [summary](benchmarks/phase3-profile/baseline-jfr-summary.txt) and [bounded analysis](benchmarks/phase3-profile/baseline-jfr-thread-analysis.json) retain both the failure and recovery. The raw binary recording stays in the private evidence archive.

Filtering event start times to the recorded catchup observation window, 18.42 seconds, found 133 relay sleep events totaling 13.45 seconds. Event durations are not clipped at the window boundary, and recording thresholds omit short waits. This independently corroborates the explicit pause. Only ten Java execution samples were retained for each relay and consumer thread during this window; they are too sparse for a precise CPU hotspot claim. The profiled catchup is separate from the unprofiled matched results.

## Matched comparison

The [methodology](phase3-benchmark-methodology.md) and [declared plan](benchmarks/phase3-experiment-plan.json) specify the repeated ABBA comparison, fresh datasets, finite client capacity, fixed 500/s arrival rate, warmup, recovery boundaries and correctness checks. Optional admission is disabled equally in both images to expose durable backlog behavior. Its rejection semantics are validated separately.

The optimized image uses source `66dc7c9cbcdd312f9df5ed427520bc398d7696a0` and image `sha256:fbcc4197cc10a882984330d1416926aecdb87a50816b5404cf0826a14e2ded69`, recorded in [optimized provenance](benchmarks/phase3-optimized-provenance.json). Both images retain batch 16, poll interval 100 ms, linger zero, 4 MiB producer buffer, five maximum broker requests in flight, a sixteen-connection application pool and the sequential consumer. The relay's hard record bound and lease/owner/generation checks remain in place. Historical Phase 2 figures are not the control.

In the independent-pair closed-loop trials, optimized HTTP throughput was 1,079–1,084 completed/s versus baseline 1,220–1,242/s, approximately 12% lower on the two-run means. Its concurrent relay/consumer database work consumes resources that the baseline defers into backlog. Optimized publication had no unpublished events at the input-end observations, but 9,185/9,253 published events awaited projection. Propagation p99 fell from 94.08–109.37 seconds to 13.99–14.45 seconds, and remaining drains from 95.31–110.14 seconds to 12.86–13.02 seconds. This is a pipeline improvement with an HTTP throughput cost, not a universal throughput gain.

At the unchanged 500 scheduled arrivals/s sustained input, optimized publication matched observed creation at 474–478/s while baseline publication was 92–110/s. Optimized still accumulated 2,872/2,410 published-awaiting-projection events; its sequential consumer processed 383–395/s during concurrent input. The original fixed-rate comparison therefore remains unstable at the consumer stage, even though the relay keeps pace with the admitted input. Optimized locally shed 534/649 of 15,000 arrivals versus baseline 191/354; no sent request failed. A separately declared half-rate comparison tests a lower operating point without changing the original rate or consumer implementation.

The original shared-source ABBA is exploratory: completed HTTP rates declined in trial order from 348.8 to 172.8, 82.2 and 45.8/s. The third trial had six dependency HTTP 503 responses and the fourth had three. The [fixture order audit](benchmarks/phase3-high-fixture-order-audit.json) found 0, 1, 4 and 7 destination UUIDs below the shared source, respectively, so the input lock ordering varied with trial position. Every trial sampled waiting/blocked sessions, and later trials recorded substantial transfer retries. These observations do not establish a causal shared-source gain or a unique cause of decline. The additional predeclared high ABBA controls all eight destinations below the source. Potential interaction with projection foreign-key locks remains a hypothesis until supported by further evidence.

## Primary trial results

All tables use the recorded ABBA order. B is the instrumented serial baseline; O is the bounded batch relay. Counts exclude issuance funding. Ordinary final latency distributions include successfully committed warmup transfers; input counts and HTTP rate refer only to measured input. `U/Q` means unpublished / published awaiting projection at the input-end SQL observation. Fresh drain timing counts only work after `drain.starting_events`, not the total backlog divided by a later partial interval.

### Independent pairs, ten-second closed-loop input

| Trial | Completed / locally shed | HTTP completed/s | HTTP p99, ms | HTTP failures | U / Q | Publication p99, s | Propagation p99, s | Remaining drain, s |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 B | 12,431 / 0 | 1242.3 | 13.97 | 0 | 11,727 / 0 | 109.372 | 109.372 | 110.143 |
| 2 O | 10,799 / 0 | 1079.1 | 19.33 | 0 | 0 / 9,185 | 0.127 | 13.988 | 12.860 |
| 3 O | 10,913 / 0 | 1083.8 | 19.91 | 0 | 0 / 9,253 | 0.155 | 14.453 | 13.016 |
| 4 B | 12,213 / 0 | 1220.3 | 16.68 | 0 | 11,507 / 0 | 94.080 | 94.082 | 95.312 |

Closed-loop clients do not impose a fixed external arrival rate. No HTTP request failed in these four trials.

### Sustained input, thirty seconds at 500 scheduled/s

| Trial | Completed / locally shed | HTTP completed/s | HTTP p99, ms | HTTP failures | U / Q | Publication p99, s | Propagation p99, s | Remaining drain, s |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 B | 14,809 / 191 | 493.6 | 13.97 | 0 | 11,476 / 0 | 93.964 | 93.966 | 94.961 |
| 2 O | 14,466 / 534 | 482.2 | 17.18 | 0 | 0 / 2,872 | 0.120 | 8.948 | 4.449 |
| 3 O | 14,351 / 649 | 478.3 | 23.09 | 0 | 0 / 2,410 | 0.116 | 7.371 | 4.513 |
| 4 B | 14,646 / 354 | 488.1 | 15.72 | 0 | 11,850 / 0 | 97.996 | 97.997 | 99.115 |

Every trial offered 15,000 arrivals. Locally shed arrivals never reached the server; all sent requests completed. The optimized consumer backlog grew during both fixed-input windows, so 500/s is not a demonstrated stable end-to-end operating point.

### Exploratory shared source, ten-second closed-loop input

| Trial | Completed / locally shed | HTTP completed/s | HTTP p99, ms | HTTP failures | U / Q | Publication p99, s | Propagation p99, s | Remaining drain, s |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 B | 3,497 / 0 | 348.8 | 35.97 | 0 | 2,419 / 571 | 21.193 | 21.194 | 21.588 |
| 2 O | 1,732 / 0 | 172.8 | 293.33 | 0 | 0 / 1,391 | 0.114 | 9.610 | 2.505 |
| 3 O | 833 / 0 | 82.2 | 691.25 | 6 | 0 / 597 | 0.122 | 8.963 | 1.364 |
| 4 B | 463 / 0 | 45.8 | 711.99 | 3 | 0 / 280 | 0.258 | 9.358 | 1.346 |

The retained nine failures were `HTTP_503:DEPENDENCY_UNAVAILABLE`. Final committed effects still reconciled, but these errors remain workload failures. Their input ordering confound excludes this original series from causal shared-source claims.

### Broker outage and operational recovery

| Trial | Completed / locally shed | Input U / Q | Input processing/s | Restore to health-ready, s | Remaining processed / drain s | Restore to final SQL observation, s | Propagation p99, s |
|---|---:|---:|---:|---:|---:|---:|---:|
| 1 B | 3,899 / 101 | 3,899 / 0 | 0.00 | 6.726 | 3,378 / 33.039 | 42.133 | 42.239 |
| 2 O | 3,963 / 37 | 3,963 / 0 | 0.00 | 6.716 | 2,135 / 3.926 | 12.988 | 19.609 |
| 3 O | 3,961 / 39 | 3,961 / 0 | 0.00 | 6.728 | 2,063 / 3.865 | 12.912 | 19.023 |
| 4 B | 3,973 / 27 | 3,973 / 0 | 0.00 | 6.721 | 3,250 / 29.491 | 38.540 | 38.011 |

Each trial offered 4,000 arrivals while the owned broker was stopped. All sent transfers committed with zero publication and processing during input. Recovery retained the broker volume and unchanged application process. Optimized final SQL recorded fifteen events with a second publication attempt in each trial; baseline recorded none. These are durable attempt counts, not evidence that the broker accepted duplicate records. Every committed event had one final inbox/projection effect and two activity rows. The final observed recovery column includes broker startup and inspection, and is an upper observation boundary, not the exact instant the last event committed.

### Slowed consumer and operational recovery

| Trial | Completed / locally shed | Input U / Q | Input processing/s | Restore to health-ready, s | Remaining processed / drain s | Restore to final SQL observation, s | Propagation p99, s |
|---|---:|---:|---:|---:|---:|---:|---:|
| 1 B | 3,976 / 24 | 3,080 / 827 | 8.35 | 10.956 | 1,544 / 13.727 | 27.223 | 28.761 |
| 2 O | 3,960 / 40 | 0 / 3,891 | 8.36 | 11.131 | 0 / 0.223 | 13.914 | 17.194 |
| 3 O | 3,924 / 76 | 0 / 3,856 | 8.24 | 10.953 | 0 / 0.215 | 13.671 | 17.728 |
| 4 B | 3,958 / 42 | 3,190 / 700 | 8.25 | 11.058 | 1,942 / 18.549 | 32.197 | 33.284 |

Each trial offered 4,000 arrivals with the minimum consumer interval set to 100 ms. Publication continued while processing fell to approximately 8/s. Restoring interval zero recreated the entire application, including relay, producer and pool. Both optimized fixtures were already fully processed before the fresh drain-start observation: zero remaining processing and approximately 0.22s inspection do not measure their total catchup throughput. The restoration-to-final-observation column keeps that earlier progress visible. All sent requests completed without HTTP errors.

### Sampled resources and contention

These samples span input and subsequent drain, with different durations per trial. Waiting/blocked sample counts therefore indicate observations, not comparable incident rates. Memory is sampled JVM used memory, not peak RSS. CPU is the JVM process usage gauge on the shared VM; coarse samples do not isolate CPU saturation.

| Suite, condition | Active pool max / 16 | Pending pool max | CPU gauge max | JVM used max, MiB | Waiting / blocked / total samples |
|---|---:|---:|---:|---:|---:|
| low, B | 10 | 0 | 0.308 | 187.5 | 4 / 4 / 165 |
| low, O | 9 | 0 | 0.332 | 205.3 | 4 / 3 / 34 |
| high, B | 11 | 0 | 0.119 | 180.1 | 16 / 16 / 35 |
| high, O | 10 | 0 | 1.000 | 181.0 | 16 / 16 / 20 |
| sustained, B | 8 | 0 | 0.168 | 184.2 | 2 / 2 / 176 |
| sustained, O | 10 | 0 | 0.208 | 183.2 | 9 / 9 / 50 |
| outage, B | 4 | 0 | 0.177 | 172.6 | 0 / 0 / 14 |
| outage, O | 3 | 0 | 0.199 | 177.8 | 0 / 0 / 14 |
| consumer, B | 3 | 0 | 0.176 | 178.9 | 0 / 0 / 14 |
| consumer, O | 4 | 0 | 0.197 | 185.2 | 0 / 0 / 14 |

Optimized sampled outstanding records never exceeded sixteen; the raw reports retain gauge gaps rather than substituting zero. In the original shared-source series, transfer retry deltas were unavailable in B1, then 126, 178 and 174. Every high trial sampled eight waiting and eight blocked observations. Retained-history growth, scheduling and resource costs can also confound trial order; account-order differences are demonstrated inputs, while the precise blocking cause remains unverified.

The [derived comparison summary](benchmarks/phase3-comparison-summary.json) links every raw load/recovery report, exact event counts, timer deltas and trial timeline. All twenty primary trials finished with one outbox/inbox/projection effect per scoped completed transfer, two activity rows per projection, passing ledger reconciliation, no sampled invariant failures or ambiguous client errors, and committed offsets equal to broker log end in all three partitions.


## Separate 250/s operating point

This once-declared half-rate ABBA retains thirty seconds at 250 scheduled arrivals/s, eight maximum outstanding requests, the same drained warmup and unchanged images/resources. Every trial offered 7,500 arrivals; all sent requests completed, and locally shed arrivals never reached the server.

| Trial | Completed / locally shed | HTTP completed/s | HTTP p99, ms | Input U / Q | Propagation p99, ms | Remaining drain, s |
|---|---:|---:|---:|---:|---:|---:|
| 1 B | 7,490 / 10 | 249.7 | 15.72 | 4,376 / 0 | 40203.14 | 41.116 |
| 2 O | 7,427 / 73 | 247.6 | 33.90 | 0 / 0 | 314.26 | 0.283 |
| 3 O | 7,433 / 67 | 247.8 | 44.24 | 0 / 0 | 303.97 | 0.296 |
| 4 B | 7,461 / 39 | 248.7 | 15.26 | 4,461 / 0 | 41624.64 | 42.606 |

Both optimized input windows ended without durable publication or projection backlog. Their sampled peaks were 25/29 unpublished and 40/56 published-awaiting-projection events, with propagation p99 314/304 ms. This is an observed thirty-second flow operating point at approximately 248 admitted HTTP transfers/s; it does not establish production capacity or long-duration stability. Both baseline trials accumulated backlog and needed approximately 41–43 seconds of remaining catchup. Optimized HTTP p99 was 33.90–44.24 ms versus baseline 15.26–15.72 ms, another visible HTTP latency cost of concurrent pipeline work.

The original attempt stopped after O3's scoped SQL and broker-offset gates: the global projection reconciliation endpoint repeatedly failed while PostgreSQL parallel queries could not expand shared-memory segments within the container's **64 MiB `/dev/shm`** limit. This was an operational inspection failure, not an observed loss or remaining event backlog. The [bounded inspection](benchmarks/phase3-sustainable-250/gate-stop-inspection.json) preserves the errors. A separate [unchanged-environment reconfirmation](benchmarks/phase3-sustainable-250/o3-post-stop-reconfirmation.json) observed all 178,795 global events published/processed, zero discrepancies and caught-up committed offsets, with the same application identity.

The [original stopped timeline](benchmarks/phase3-sustainable-250/phase3-sustained-trial-order.json) remains incomplete. Original planned B4 continued once in a [separate timeline](benchmarks/phase3-sustainable-250-continuation/phase3-sustained-trial-order.json), with the same source-66 workload harness verified against its committed files, same images/settings, fresh fixture, explicit planned position and interruption gap. Earlier conditions were not rerun or overwritten, and shared-memory or other resource configuration was not changed. The [combined summary](benchmarks/phase3-sustainable-250-summary.json) records both the complete ordered measured series and its operational failure. The demonstrated monitoring/shared-memory limit remains a deployment constraint.


## Controlled shared-source comparison

After the original twenty-four measured trials, the additional predeclared ABBA fixed all eight destinations below the shared source in every fresh fixture. [PostgreSQL preflight](benchmarks/phase3-controlled-fixture-preflight.json) confirmed the byte-order relation. Source images remain cba4427/66dc7c9; the optional fixture extension and clearer global-inspection failure reporting use immutable harness `b11a593c7ec2f47252495a2af000de274d9872fd`, gated by [seven offline checks](verification/phase3-controlled-harness.json). Defaults and the original twenty-four-trial harness were unchanged before their completion.

| Trial | Offered / completed | HTTP dependency failures | HTTP completed/s | HTTP p99, ms | Transfer retry delta | Input U / Q | Publication p99, ms | Propagation p99, s |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 B | 450 / 443 | 7 | 42.4 | 711.99 | 178 | 0 / 252 | 331.85 | 9.144 |
| 2 O | 489 / 486 | 3 | 47.7 | 711.99 | 183 | 0 / 268 | 125.41 | 8.209 |
| 3 O | 451 / 449 | 2 | 44.6 | 711.99 | 171 | 0 / 291 | 126.21 | 9.517 |
| 4 B | 424 / 414 | 10 | 40.6 | 711.99 | 169 | 0 / 237 | 303.27 | 9.230 |

All four had zero warmup HTTP errors, no ambiguous client failures, complete scoped projection/ledger checks and final committed-offset catchup. Each sampled eight waiting and eight blocked observations; active pool maxima were nine or ten of sixteen, pending pool observations stayed zero and CPU gauge maxima were approximately 0.043–0.047. These samples support database contention, without establishing a CPU or pool-capacity limit. The controlled series retains seventeen baseline and five optimized `HTTP_503:DEPENDENCY_UNAVAILABLE` failures. Their approximately 712 ms HTTP p99 and substantial retries expose a shared-source contention limit in both images. Observed optimized HTTP rates were somewhat higher in these two repeats, but the small sample, failures and resource/history uncertainty do not establish a general causal shared-source HTTP gain. Publication p99 improved, while propagation still took approximately 8–10 seconds at p99. The [controlled summary](benchmarks/phase3-high-controlled-summary.json) links all raw fixtures, stage/resource observations and the complete [timeline](benchmarks/phase3-high-controlled/phase3-high-trial-order.json).


The [bounded post-timing PostgreSQL log inspection](benchmarks/phase3-shared-source-post-timing-log-inspection.json) found 185/186/173/179 available lock-timeout errors in controlled B/O/O/B windows, including warmup/drain. Contexts show the ordered `FOR UPDATE` account/balance query. These log counts differ from transfer retry counters and include only retained records; the original B1 log window had no available records and remains unknown. The logs corroborate actual account-lock timeouts, but do not demonstrate a particular foreign-key lock cycle or establish it as the unique causal bottleneck.

## Optimized consumer-stage diagnosis

The separately retained [optimized diagnostic](benchmarks/phase3-profile/optimized-stage-diagnostic.json) and [stage analysis](benchmarks/phase3-profile/optimized-stage-analysis.json) use source/harness `66dc7c9cbcdd312f9df5ed427520bc398d7696a0` and image `sha256:fbcc4197cc10a882984330d1416926aecdb87a50816b5404cf0826a14e2ded69`. The unchanged consumer remained sequential. At 500 scheduled arrivals/s for eight seconds, 3,934 requests completed, 66 were locally shed, and none failed. All 4,084 scoped events including warmup were published by the input-end SQL observation; 949 still awaited projection.

During that concurrent input, the consumer's projection database transaction averaged 2.080 ms, offset acknowledgement 0.432 ms, and received-record poll 0.106 ms. Once HTTP input stopped, the corresponding transaction and offset means dropped to 0.897 ms and 0.171 ms. The fresh drain-start snapshot excluded 136 projections completed during preceding inspection; the remaining 813 completed in 1.331 seconds, approximately 611/s. All committed effects reconciled and no event required a second publication attempt.

This diagnostic shows that the relay now kept pace with admitted input and the consumer accumulated backlog while sharing resources with HTTP work. Database transaction time dominated its measured processing costs; treating offset acknowledgement alone as the bottleneck would misread the evidence. The difference after input stops suggests resource competition, without isolating its precise cause. The sequential consumer is therefore retained. The matched 500/s experiment preserved that rate and showed growing consumer backlog. The separate 250/s comparison observed a lower flow operating point while retaining its operational monitoring failure.

The actual thirty-second optimized sustained trials corroborate that diagnosis. Projection transactions averaged 2.036–2.091 ms during concurrent input, successful offset acknowledgements 0.352–0.358 ms and received-record polls 0.050–0.051 ms. During the subsequent consumer drains, transaction means fell to 1.052–1.103 ms and offset means to 0.195–0.199 ms. Fresh remaining consumer progress was 2,564/2,174 events in 4.449/4.513 seconds, approximately 576/482/s; earlier inspection progress is excluded. The relay's active batches averaged 6.016–7.598 ms, with claim 1.568–1.791 ms, batch renewal 1.379–2.105 ms, settlement 1.539–2.204 ms and batch future wait 0.900–0.917 ms. Partial/idle batches still slept; observing 22.94–24.46 seconds of pauses while publication keeps up does not identify a backlog bottleneck.

## Latency distributions across repeats

Each cell is the observed range across the two repeats of that condition, not a confidence interval. HTTP p50/p95/p99 are the retained histogram upper bounds for all measured HTTP requests, including failures in shared-source cases. SQL propagation percentiles use final committed scoped rows, including successful ordinary warmup; outage/consumer values come from their recovery reports. Rounded equal values may share a histogram bucket. Transaction-local capture times retain the durability limitation described below.

| Suite, condition | HTTP p50, ms | HTTP p95, ms | HTTP p99, ms | Propagation p50, s | Propagation p95, s | Propagation p99, s |
|---|---:|---:|---:|---:|---:|---:|
| Low, B | 6.10 | 10.09–10.70 | 13.97–16.68 | 49.299–63.787 | 90.497–105.622 | 94.082–109.372 |
| Low, O | 6.67 | 12.41 | 19.33–19.91 | 9.356–9.926 | 13.425–13.945 | 13.988–14.453 |
| High exploratory, B | 22.41–33.90 | 30.12–671.11 | 35.97–711.99 | 3.032–11.289 | 8.396–20.441 | 9.358–21.194 |
| High exploratory, O | 19.91–21.13 | 245.66–443.69 | 293.33–691.25 | 3.419–4.417 | 7.985–8.874 | 8.963–9.610 |
| 500/s, B | 4.54 | 8.20–8.70 | 13.97–15.72 | 48.398–52.014 | 90.330–94.172 | 93.966–97.997 |
| 500/s, O | 4.68–4.82 | 8.45–8.70 | 17.18–23.09 | 2.930–3.519 | 6.204–7.423 | 7.371–8.948 |
| Outage, B | 3.92–4.04 | 7.73–8.20 | 13.17–21.76 | 25.083–29.153 | 36.743–41.237 | 38.011–42.239 |
| Outage, O | 3.92–4.04 | 8.20–8.45 | 15.72–17.18 | 14.215–14.464 | 18.431–18.966 | 19.023–19.609 |
| Slow consumer, B | 3.92 | 7.51–8.70 | 13.56–17.69 | 16.105–19.826 | 27.805–32.264 | 28.761–33.284 |
| Slow consumer, O | 4.04–4.28 | 9.51–10.39 | 17.69–18.22 | 12.342–12.668 | 16.610–17.072 | 17.194–17.728 |
| 250/s, B | 4.16 | 7.73–8.20 | 15.26–15.72 | 21.093–22.503 | 38.724–40.204 | 40.203–41.625 |
| 250/s, O | 4.16 | 7.97–9.23 | 33.90–44.24 | 0.091–0.094 | 0.199–0.221 | 0.304–0.314 |
| High controlled, B | 32.92–205.73 | 691.25 | 711.99 | 2.675–2.937 | 7.712–8.294 | 9.144–9.230 |
| High controlled, O | 34.92–40.48 | 671.11–691.25 | 711.99 | 2.520–3.194 | 7.687–8.660 | 8.209–9.517 |

## Final source and deployed acceptance

All twenty-eight timed workloads, drains and offset gates finished before the final lifecycle correction. The final source, `2c859cb28d3b1898a2a7d25c5c87d7a0a0a3dbe4`, changes production code from measured source 66dc7c9 only by seven stop-path lines that recapture an admitted start worker and reassert shutdown fencing. Publication hot-path behavior, the sequential consumer and schema remain unchanged. The [lifecycle red/green evidence](verification/phase3-lifecycle-red-green.json) retains the original failing scheduling regression and corrected real publication/restart checks. These performance figures belong to the measured source-66 image; the final lifecycle correction was not benchmarked again.

Two earlier clean runs failed producer-work setup assertions and remain retained as [first](verification/phase3-clean-first-failure.json) and [second](verification/phase3-clean-second-failure.json) attempts. Their [batch-bound](verification/phase3-partial-bound-correction.json) and [shutdown](verification/phase3-shutdown-correction.json) fixture corrections establish actual outstanding sends using the real paused broker. The final [literal clean-checkout verification](verification/phase3-clean-verify.json) passed **94 tests: 34 unit and 60 real-dependency integration**, with zero failures/errors/skips, zero SpotBugs bugs/errors and all four dependency/version enforcement rules passing. It finished at 00:11:26 +08 on 12 October 2026. Dependency convergence/release checks are not a vulnerability audit, and hosted CI was not executed locally.

The [final local build](verification/phase3-final-build.json) used that verified clean checkout and produced `tpp-phase3-final:2c859cb`, image `sha256:3da213ca031c1f2aa0c229c35dcce2ee0bd5c719055e4c3186d335127bc5b0ee`. [Deployment](verification/phase3-final-deploy.json) recreated only the owned Phase 3 application. [Runtime provenance](verification/phase3-final-runtime-provenance.json) and the [before/after preservation check](verification/phase3-final-preservation.json) retain Phase 1/2 container identities and start times, plus Phase 3 database/broker identities, images, start times and named data volumes across this final build/deployment. PostgreSQL shared memory remains 64 MiB.

The deployed [runtime-role check](verification/phase3-final-runtime-role.txt) rejected issuance/history rewrites and trigger disabling, with all attempted mutations rolled back. A [fresh HTTP completion and same-key replay](verification/phase3-final-http-event-smoke.json) retained one logical event and account activity of -7/+7 FIC. [Final acceptance](verification/phase3-final-acceptance.json) independently checked one completed transfer, two balanced ledger rows, one published outbox/payload identity, one inbox and transfer projection, and two matching activity rows. Actual application connections used restricted `tpp_app`. Readiness was UP, admission was disabled with no sampled pressure, and all 188,884 global completed events were published/processed/projected with zero discrepancies or remaining backlog. Broker committed offsets equaled log end in all three partitions, with zero lag. This is final deployment acceptance, separate from performance measurement.

## Interpretation limits

HTTP percentiles are fixed-histogram upper bounds with up to 3% bin-width error above 0.01 ms. Database propagation percentiles use persisted `outbox.created_at` and `event_inbox.processed_at` capture timestamps on committed rows; these are not WAL commit timestamps, and remaining transaction completion can make them understate final durable latency. Full transaction timers separately include commit and cleanup. Timer MAX values are rolling actuator observations, not interval percentile distributions.

A single host, finite client concurrency, single unreplicated broker, sequential monitoring snapshots and accumulating database history limit generalization. Short fixed-input windows and backlog drains measure these experiments; neither establishes production capacity by itself. Correctness assertions verify the observed committed effects and complement the real PostgreSQL/Kafka failure regression.
