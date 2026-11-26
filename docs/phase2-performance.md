# Phase 2 performance and backpressure evidence

The local measurements demonstrate atomic transfer/outbox persistence and eventual recovery of the activity projection. They also expose a capacity limit: with the default single relay, low-contention HTTP creation exceeded publication by roughly an order of magnitude. Successful HTTP completion therefore does not imply that the activity view is current. The durable backlog grew and subsequently drained; it did not disappear into an application queue.

These are observations from short development trials, not a production capacity claim. The [methodology](phase2-benchmark-methodology.md) describes definitions, bounds and reproduction. All raw reports and isolated funding fixtures are in [benchmarks](benchmarks/).

## Environment and provenance

Measurements ran on 11 October 2026 on an Apple M2 Max, 12 logical cores, 32 GiB RAM, macOS 26.7.1 arm64 and Python 3.13.0. Docker Desktop 24.0.6 allocated 13 virtual CPUs and 7.667 GiB RAM; Compose was 2.22.0. The application used Temurin Java 21.0.12.1+1, PostgreSQL 17.11 Alpine, and official Apache Kafka broker/client 4.3.1. Kafka ran as one KRaft broker/controller with three topic partitions, replication factor one and `acks=all`. This provides no broker replication resilience. PostgreSQL used READ COMMITTED, 128 MiB shared buffers and 100 maximum connections; the application pool maximum was 16.

The measured application image was `sha256:dc8eaa74cdddb7371ae10c94a3e79584c53acb3bbd225ffbb505a103478f4769`. [Recorded provenance](benchmarks/phase2-provenance.json) includes database/broker images and settings. Relay batch size was 16, poll interval 100 ms, lease 15 s and delivery deadline 3 s. The consumer minimum interval was zero except in the explicitly slowed-consumer experiment. All operations targeted `tpp-phase2-validation`, using loopback application port 18080, PostgreSQL 55433 and Kafka 19092. The previously running Phase 1 project was preserved.

The measured image preceded the final fix that retries Kafka consumer construction when the bootstrap DNS name is absent at startup. That fix concerns startup recovery; these timed windows used an already available broker or an already constructed consumer. [Separate final-image evidence](verification/phase2-dns-startup-recovery.json) records image `sha256:aa585ad7255b0a55ded7729456af46d79a3fb5743e2412c97fcfb6a2bb634948`: with the Kafka service container removed, bootstrap lookup failed, application readiness stayed UP, six consumer-construction retries were observed and a transfer committed. Recreating Kafka with the same named volume published the event and created paired activity without restarting the application. Phase 1 container identities and start times were unchanged. Final-image [runtime-role restrictions](verification/phase2-final-runtime-role.txt) and [HTTP/idempotency/event smoke](verification/phase2-final-http-event-smoke.json) passed. These timings are not relabeled as measurements of that later image.

## Matched low-contention trials

Eight closed-loop clients used independent account pairs, persistent HTTP connections, unique idempotency keys and no automatic POST retry. Each trial used a fresh account fixture and a recreated application JVM, three seconds of warmup and ten seconds of measured requests. The order was disabled 1, enabled 1, disabled 2, enabled 2. All earlier backlogs drained before the next timed trial. The consumer remained enabled in every trial; disabling the relay still retained the transactional outbox insertion cost.

| Trial / raw evidence | Offered = started = completed | Completed/s | HTTP p50 / p95 / p99, ms | Mean / maximum, ms |
| --- | ---: | ---: | ---: | ---: |
| [Relay disabled 1](benchmarks/phase2-disabled-1.json) | 10,523 | 1,051.8 | 6.48 / 13.56 / 31.03 | 7.59 / 115.19 |
| [Relay enabled 1](benchmarks/phase2-enabled-1.json) | 11,268 | 1,125.9 | 6.48 / 12.05 / 21.76 | 7.09 / 102.46 |
| [Relay disabled 2](benchmarks/phase2-disabled-2.json) | 13,580 | 1,357.3 | 5.75 / 8.20 / 11.70 | 5.88 / 32.13 |
| [Relay enabled 2](benchmarks/phase2-enabled-2.json) | 12,423 | 1,241.4 | 6.10 / 9.51 / 13.17 | 6.43 / 246.76 |

HTTP quantiles are fixed logarithmic histogram **upper bounds**, with at most 3% bucket-width error above 0.01 ms; mean and maximum are accumulated observations. All four trials had zero HTTP failures or ambiguous transport errors. Enabled trial 2 recorded two internal database retries that ultimately succeeded. The roughly 29% variation between the two disabled observations exceeds any defensible precise estimate of activation overhead. These two samples per setting cannot establish a causal improvement or regression, and this is not a comparison against Phase 1 without an outbox.

The publication bottleneck is clearer than the HTTP comparison:

| Enabled trial | Creation / publication / processing per second during observation | Scoped events after warmup + load | Unpublished after load | Remaining publication/processing during drain | Drain wall time |
| --- | ---: | ---: | ---: | ---: | ---: |
| Enabled 1 | 1,103.7 / 61.1 / 61.1 | 14,942 | 14,078 | 14,078 / 14,078 | 123.47 s |
| Enabled 2 | 1,215.5 / 63.4 / 63.5 | 15,947 | 15,070 | 15,070 / 15,070 | 142.70 s |

Event rates use scoped committed SQL count deltas over their database observation timestamps, including inspection around the HTTP interval. They are not broker ingress rates. No HTTP load ran during the drains. Dividing the remaining published count by the recorded drain time gives approximately 114.0/s and 105.6/s for those drain observations. The final inbox/projection counts equaled 14,942 and 15,947, with exactly twice as many account activity rows. Each event had one recorded publication attempt and no retained publication error.

Disabled trials accumulated 13,781 and 17,652 scoped events, including warmup, with zero publications. After enabling the relay, [catchup 1](benchmarks/phase2-disabled-1-catchup.json) observed another 11,608 publications and 11,610 inbox effects over 93.90 s; [catchup 2](benchmarks/phase2-disabled-2-catchup.json) observed 16,701 of each over 135.41 s. Some events had already drained before these observation windows began. Their partial-window counts and times must not be presented as the time to process the whole original backlog.

## Event latency includes backlog wait

The following percentiles cover every processed scoped event, including warmup, after catchup. They use `event_inbox.processed_at - outbox_events.created_at`.

| Experiment | Propagation p50 / p95 / p99, seconds | Maximum, seconds |
| --- | ---: | ---: |
| Enabled 1 | 70.09 / 118.08 / 122.41 | 123.46 |
| Enabled 2 | 77.28 / 135.75 / 140.60 | 141.81 |
| Broker outage and recovery | 112.93 / 140.78 / 143.30 | 143.90 |
| Slowed consumer and restoration | 28.96 / 47.05 / 48.70 | 49.05 |
| Shared-source contention | 2.33 / 4.63 / 4.85 | 4.95 |

These SQL percentiles are exact calculations over persisted timestamps of committed rows. The timestamps are captured **inside** transactions, before commit; they are not WAL commit timestamps and can understate final durable latency by remaining transaction/commit work. The outage and configuration-restoration cases include intentional waiting and operator delay. They are not idle-pipeline processing latency measurements. Catchup completion was separately confirmed by a later query observing all durable rows.

## Actual broker outage

Only the owned Kafka container was stopped; PostgreSQL and the application stayed running. [Control evidence](benchmarks/phase2-outage-control.json) records the stopped broker and HTTP readiness 200/UP. In [five seconds of fresh transfers](benchmarks/phase2-outage.json), all 8,120 offered requests completed with no HTTP errors, while all 8,120 outbox events remained unpublished and unprocessed. The database observation rates were 1,570.2 creations/s, zero publications/s and zero processing/s. The achieved HTTP rate of 1,622.7/s is an outage observation, not another matched baseline trial.

The same broker was restored with its volume retained and the application was **not restarted**. [Recovery evidence](benchmarks/phase2-outage-recovery.json) observed 8,065 remaining publications and 8,120 inbox effects over 67.08 s; 55 publications were already visible when the observation began. All 8,120 events eventually had one inbox/projection effect and 16,240 account activity rows. Eight events had multiple publication attempts, with maximum attempt count five and 8,150 total attempts. Seven retained `AMBIGUOUS` last-error classifications remained inspectable after success. There were no permanent blocked events, missing effects or reconciliation discrepancies.

## Slower active consumer

With Kafka and the relay active, the consumer minimum interval was set to 100 ms. The [five-second trial](benchmarks/phase2-slow-consumer.json) completed all 5,309 HTTP requests. Scoped SQL rates were 1,017.6 creations/s, 62.30 publications/s and **8.24 processing/s**. The post-load snapshot showed 325 published events, 43 inbox effects and 282 published events awaiting processing. An independently timed [broker group snapshot](benchmarks/phase2-group-slow-consumer.txt) showed lag 376 across the three partitions. Those snapshots were taken at different times while publication continued, so their counts need not match.

The normal zero-ms consumer budget was restored through a controlled application recreation. [Catchup](benchmarks/phase2-slow-consumer-recovery.json) observed 2,472 remaining publications and inbox effects over 20.76 s after its observation began. Final counts were 5,309 published/inbox/projection rows and 10,618 account activity rows, with no retries or errors. This demonstrates a nonzero consumer processing rate below publication rate, durable broker backlog and eventual catchup. It does not show that disk usage is bounded under indefinite overload.

## Shared source, locks and resource samples

The separate [shared-source trial](benchmarks/phase2-high-contention.json) used eight clients spending from one funded source, one second of warmup and five seconds of measured load. It started 569 requests: 566 completed and **three returned HTTP 503**. There were no transport ambiguities. Achieved completion was 112.7/s; all-response HTTP p50/p95/p99 upper bounds were 22.41/260.62/691.25 ms, with maximum 690.67 ms. Successful-response p99 was 443.69 ms. The script returned a failure exit status to preserve the HTTP failures, even though subsequent reconciliation and event catchup succeeded.

Application counters recorded 67 internal transfer retries and 70 database errors during the measured interval. [Captured warning logs](benchmarks/phase2-high-contention-errors.json) identify PostgreSQL `55P03` lock timeouts in the transfer retry path. This supports contention and exhausted bounded retries as the cause of the 503 responses; individual error response bodies were not retained. All 666 committed transfers including warmup retained their outbox; catchup completed in 1.17 s after load, with 666 inbox/projection effects and 1,332 activity rows. No relay retry was required.

| Trial | Load samples / samples observing lock waits | Maximum blocked sessions | Peak sampled active pool / pending acquisition | Peak sampled process CPU fraction | Peak sampled JVM used memory |
| --- | ---: | ---: | ---: | ---: | ---: |
| Disabled 1 | 7 / 0 | 0 | 8 / 0 | 0.282 | 172.5 MiB |
| Enabled 1 | 7 / 2 | 1 | 9 / 0 | 0.265 | 183.8 MiB |
| Disabled 2 | 8 / 0 | 0 | 9 / 0 | 0.235 | 172.7 MiB |
| Enabled 2 | 8 / 0 | 0 | 10 / 0 | 0.258 | 183.3 MiB |
| Shared source | 4 / 4 | 9 | 10 / 0 | 0.062 | 172.1 MiB |

The shared-source case's maximum sampled query age while waiting was 177.5 ms; this includes work before waiting and is not an exact lock-wait duration. CPU is the JVM's sampled process usage gauge, not whole-host utilization. These sequential snapshots can miss short peaks, and gauges are not all sampled atomically. There were no sampler errors or sampled event invariant violations. The contrast between broad lock waits, low CPU and finite pool usage supports row-lock serialization as the shared-source limit; it does not prove there are no other costs.

## Actual relay query plans

Owner-run probes executed the application's bounded claim/update SQL inside `BEGIN`/`ROLLBACK`, preserving visible claims. The [initial tiny-table plan](benchmarks/phase2-query-plans-initial.txt) reasonably used a sequential scan. With 13,790 pending rows, the [backlog plan](benchmarks/phase2-query-plans-backlog.txt) used `outbox_backlog_age_idx`, incremental sort and 33 candidate rows to claim 16. Eligible selection took about 0.092 ms; the complete update took 2.179 ms, including 1.130 ms of guard-trigger time and 496 buffer hits. The volatile eligibility timestamps remained filters, but this observed plan avoided a full backlog scan. No speculative index/query rewrite was warranted by this measurement.

After all experiments, [the drained plan](benchmarks/phase2-query-plans-drained.txt) saw 76,484 published events and no eligible events, used the same partial age index and completed in 0.325 ms with ten buffer hits. [Broker group offsets](benchmarks/phase2-group-drained.txt) showed lag zero in all three partitions. These plan timings are single local observations, not distributions.

## Bounds and limits

Client instrumentation uses fixed 530-bucket histograms, bounded timeouts and at most 2,000 sampler snapshots. The relay uses finite batches and bounded producer buffers; the consumer uses bounded poll batches and commits effects before offsets. Backpressure is retained in PostgreSQL/Kafka rather than an unbounded Java collection. Durable storage and retained financial history can still grow; storage admission, retention, archival and multi-broker operation require separate work.

All recovery observations reached complete scoped publication/processing, paired activity and authoritative reconciliation. Their error history remains in the raw reports. Short trials, JVM/cache state, accumulating database history, sampling work and Docker scheduling limit precision. Closed-loop clients reduce offered traffic when requests slow, so these results cannot establish a sustainable fixed external arrival rate. Single-host, single-broker recovery is not a database failover, broker failover or production availability experiment.
