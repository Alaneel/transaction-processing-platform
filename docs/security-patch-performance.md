# Security-dependency comparisons

These two local four-trial populations retain the current bounded relay/lifecycle code in both conditions. They compare six application library patches, rather than repeating the historical serial-versus-batch optimization. **Every committed effect in both populations reconciled**, and committed Kafka offsets caught up on partitions 0, 1 and 2. Timing evidence has different strength between populations.

## Final patched servers — 14 October 2026

The final app, PostgreSQL helper, Kafka library/JRE and native package patches were common to both conditions, apart from the six deliberately old application jars in the local control. **28,065 scoped events reconciled: 27,478 measured completions and 587 completed warmup events.** All four trials exited zero, with no HTTP, sampling or invariant errors.

| Trial | Application dependencies | Measured completions | Transfers/s | Propagation p99, seconds |
|---|---|---:|---:|---:|
| 1 | Prepatch control | 6,881 | 687.2 | 22.334 |
| 2 | Patched release candidate | 7,213 | 720.8 | 18.817 |
| 3 | Patched release candidate | 7,078 | 707.2 | 18.043 |
| 4 | Prepatch control | 6,306 | 630.0 | 17.704 |

The same schedule offered 150 warmup arrivals at 50/s before each trial. The first trial locally shed 13 arrivals, so 137 completed; the other three completed 150 each. Shedding occurs before an HTTP request is sent and is distinct from a rejected or ambiguous request. Each warmup drained before measured input. This finite warmup does not establish steady-state JVM or host behavior.

Every complete benchmark subprocess sampled host wall and monotonic clocks at 250 ms intervals, rejecting backwards/non-finite clocks or interval/cumulative disagreement above one second. All four guards passed; the largest observed cumulative difference was **0.000316 seconds**. The owned process used a temporary power assertion. Outer execution lasted 201.420 seconds by wall time and 201.418 seconds by monotonic time. No global power settings changed.

[Raw reports, SQL fixtures, datasets and logs](benchmarks/security-patch-final-20261014/), [summary](benchmarks/security-patch-final-20261014/summary.json), [clock/offset observations](benchmarks/security-patch-final-20261014/comparison.json), [actual archive inventories](verification/release-final-runtime-inventories.json) and [control provenance](verification/release-final-benchmark-provenance.json) preserve this separate population.

## Earlier servers — 13 October 2026

The earlier security comparison ran before the server/native/build-cache remediation. Its original reports and numbers are retained. Across four fixtures, **39,751 events including 600 warmup events** reconciled with no recorded HTTP, sampling or invariant errors.

| Trial | Application dependencies | Measured completions | Reported transfers/s | Reported propagation p99, seconds |
|---|---|---:|---:|---:|
| 1 | Prepatch control | 7,530 | 752.6 | 16.007 |
| 2 | Patched candidate | 11,063 | 1,105.7 | 14.759 |
| 3 | Patched candidate | 11,221 | 1,121.0 | 15.728 |
| 4 | Prepatch control | 9,337 | 933.2 | 15.854 |

**Complete host-clock continuity is unverified for this earlier population.** Its raw reports lack direct host wall/monotonic samples over the whole workload. Retrospective paired database-wall/host-monotonic observer samples show no disagreement above one second (maximum observed 0.318 seconds), but cannot prove continuity between or outside those observations. Financial/event reconciliation remains independently valid; the reported timing is not promoted to fully validated timing. A separate build log showed a wall/monotonic gap whose cause is unverified, motivating the new guard. No historical number was edited.

[Original raw evidence](benchmarks/security-patch-20261013/), [original summary](benchmarks/security-patch-20261013/summary.json), [retrospective clock scope](verification/release-pre-server-clock-review.json), [original archive inventories](verification/release-runtime-inventories.json) and [original provenance](verification/release-benchmark-provenance.json) remain separate from the final-server run.

## Inputs and interpretation

Each population used eight persistent HTTP clients, ten seconds of closed-loop input, independent balanced account pairs and no automatic POST retry. Each trial creates a fresh double-entry funding fixture; existing database/broker history grows and is retained. Batch size is 16 and sampled admission is disabled. Input throughput excludes warmup; propagation p99 is the exact scoped PostgreSQL percentile of inbox processing time minus outbox creation time, including completed warmup. HTTP latency uses the existing bounded logarithmic histogram.

Both final executable archives have **63 runtime jars** and **84 byte-identical compiled application/configuration entries**, excluding attribution. Only three Tomcat jars (11.0.24 → 11.0.27), Jackson core/databind (3.1.5 → 3.1.7) and LZ4 (1.10.2 → 1.11.4) differ. The control reuses the exact final patched build-stage image and runs `clean package`, forcing recompilation; current build-only patches, JRE digest and OS packages remain common. The old-dependency control is an intentionally affected local experiment, not a distribution artifact.

The host reported macOS 26.7.1/arm64 and 12 logical CPUs; Docker Desktop Engine 24.0.6 reported 13 vCPU and 7.67 GiB. PostgreSQL used default 128 MB shared buffers, 100 connections and read committed isolation. Other portfolio builds/tests/scans/fault suites were paused during timed input. Unrelated legacy services and ordinary host activity were retained.

Only four short trials exist per population. Control throughput drifts, history grows, and cache/order/thermal effects are not isolated; there is no confidence interval. **No causal gain, universal performance improvement, capacity limit or SLA follows.** Cross-population differences cannot isolate server patches from host/history effects. The historical 28-trial optimization and separate 188,884-event acceptance remain unchanged. [Security classification](dependency-security.md) is independent of performance.

After measurement, the wrapper restored the patched app. Guarded cleanup stopped only the owned project's containers and retained both history volumes.

## Reproduce with fresh evidence

Build two immutable local images and verify their actual jar/source inventories first. Start an owned demo, then select a new output directory:

```sh
python3 scripts/demo.py --project tpp-release-readiness
python3 scripts/security-patch-comparison.py \
  --baseline-image sha256:<verified-local-control-image-id> \
  --patched-image sha256:<verified-local-patched-image-id> \
  --output benchmark-results/new-security-comparison
```

The wrapper requires a local Unix Docker endpoint, this checkout's owned project, its actual loopback HTTP binding and exact image identities. It refuses an existing output directory. It changes only the app container, preserves raw errors and clock observations, retains data, and restores the patched image in `finally`. Preserve failed timing and durable-effect evidence separately rather than rewriting a run.
