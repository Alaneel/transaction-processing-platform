# Evidence index

Claims in the overview are backed by retained local execution files. A configured build, a completed build, a runtime acceptance snapshot and a timed measurement have different meanings.

| Claim | Primary artifact | Boundary and caveat |
|---|---|---|
| 94 successful tests; 34 unit, 60 real dependency integration | [Final clean verification](verification/phase3-clean-verify.json) | Clean source `2c859cb`, 12 October 2026 Singapore time; 0 failures/errors/skips and 0 SpotBugs findings. It is historical local execution, not this showcase refresh or GitHub CI. |
| 188,884 completed events reconciled | [Final runtime acceptance](verification/phase3-final-acceptance.json) | One retained dataset at deployment acceptance: outbox/inbox/projection complete and committed offsets caught up; no load measurement or durability SLA. Includes controlled issuance fixtures. |
| Financial and delivery failures preserve defined effects | [Failure matrix](failure-matrix.md), [test source](../src/test/java/dev/tpp/events/EventPipelineTest.java) | Real PostgreSQL/Kafka scenarios; deliberately scheduled lifecycle races are explicitly distinguished from natural race reproduction. |
| Matched pipeline optimization and tradeoffs | [Primary comparison summary](benchmarks/phase3-comparison-summary.json) | Twenty primary ABBA trials across five suites. Every raw trial is retained, including workload failures and confounds. |
| Lower finite operating point | [250/s summary](benchmarks/phase3-sustainable-250-summary.json) | Four additional trials, with local shedding, a failed global inspection and a retained fourth-trial continuation. No production capacity inference. |
| Controlled shared-source results | [Controlled summary](benchmarks/phase3-high-controlled-summary.json) | Four additional trials retain dependency 503s; this is not a general HTTP performance gain. |
| Current release candidate | [Release verification](verification/release-readiness.json), [dependency assessment](dependency-security.md) | Final104/104 = original 34 unit/60 real dependency + 10 local Unix guards; separate final build-tool/static verification, final server demos and 37 Python checks. Current app/Kafka and active 134 plugin jar scans have 0 matches; test-helper and host limitations remain explicit. |
| Final-server four-trial security control | [Comparison](security-patch-performance.md), [raw ABBA record](benchmarks/security-patch-final-20261014/comparison.json) | 28,065 scoped effects: 27,478 measured + 587 warmup; 13 warmup arrivals locally shed. Identical 84 app/config entries and 63 jars apart from 6 app-library patches; four clock guards pass. No universal performance claim. |
| Earlier four-trial security control | [Original raw ABBA record](benchmarks/security-patch-20261013/comparison.json), [clock review](verification/release-pre-server-clock-review.json) | 39,751 scoped effects reconcile. Whole-host timing continuity is unverified; original reported performance retained separately. |
| Earlier showcase checks | [Portfolio verification](verification/portfolio-verification.json) | Earlier offline unit/static/tooling checks on 13 October 2026, before the local Docker runtime was restored. This is not the final release-candidate run. |

## Trace the chart

The [chart](assets/pipeline-tradeoff.svg) reads these four raw reports in their original baseline/optimized/optimized/baseline order:

- [Trial 1, serial baseline](benchmarks/phase3-low-1-baseline.json)
- [Trial 2, bounded batch](benchmarks/phase3-low-2-optimized.json)
- [Trial 3, bounded batch](benchmarks/phase3-low-3-optimized.json)
- [Trial 4, serial baseline](benchmarks/phase3-low-4-baseline.json)

HTTP throughput comes from `workload.completed_transfers_per_second`. Propagation p99 comes from `drain.final_events.propagation_latency_ms.p99`, divided by 1,000 for seconds. The latter includes warmup completions; input HTTP throughput does not. The [extracted data](assets/pipeline-tradeoff-data.json) records raw-file hashes and source identities. Rendering rejects a mismatch with the retained comparison summary.

The baseline image is source `cba4427`; the optimized measurement image is `66dc7c9`. Final clean source `2c859cb` contains the later relay lifecycle correction. That correction passed separate validation and final runtime acceptance but was not rebenchmarked in the historical optimization comparison. The new dependency comparison uses current lifecycle code in both conditions, so it cannot update that old optimization result. The [full performance report](phase3-performance.md) retains environment, distributions, original negative results and observation limits.

## Regenerate the chart

Verification needs only Python 3 and does not render or change the evidence:

```sh
python3 scripts/render-showcase.py --check
```

Rendering additionally requires Matplotlib. Install it in your chosen Python environment, then run:

```sh
python3 scripts/render-showcase.py
python3 scripts/render-showcase.py --check
```

The SVG records hashes of the plotted data and rendering script. It contains no external assets or executable content. [Editable Mermaid source](assets/architecture.mmd) accompanies the architecture SVG; both describe the same durable boundaries.

## Reproduce the system, then measure it

Run the [guided demo](demo.md) before a benchmark. Preserve fixtures, environment notes, image/source identities and command output. Use the existing [benchmark methodology](phase3-benchmark-methodology.md) for matched comparisons. Avoid builds, tests or unrelated workloads during timed trials. Never overwrite old evidence with a new run or relabel historical results as current-source measurements.

## Public snapshot

This repository starts from a reviewed source snapshot. Historical revision IDs and log hashes identify the original local experiments. Those revisions, machine-local paths and the raw Flight Recorder binary are not part of this repository’s Git history. The retained chart inputs, JSON measurements and profiling summary are available here. [Snapshot provenance](verification/public-snapshot.json) lists the export changes and recording checksum.
