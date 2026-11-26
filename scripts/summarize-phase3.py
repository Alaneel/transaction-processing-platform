#!/usr/bin/env python3
"""Derive compact comparison evidence from retained, completed Phase 3 trial timelines."""

import argparse
import json
from pathlib import Path
import sys


def summarize(report):
    workload = report.get("workload", {})
    before, after = report["events_before"], report["events_after_workload"]
    final = report["drain"]["final_events"]
    samples = report["observations"]["samples"]

    def resource_max(name):
        values = [sample.get("resources", {}).get("values", {}).get(name, {}).get("VALUE")
                  for sample in samples]
        values = [value for value in values if isinstance(value, (int, float))]
        return max(values) if values else None

    def event_max(name):
        values = [sample.get("events", {}).get(name) for sample in samples]
        values = [value for value in values if isinstance(value, (int, float))]
        return max(values) if values else None

    lag_values = [sample.get("consumer_lag", {}).get("values", {})
                  .get("events.consumer.lag.max", {}).get("VALUE") for sample in samples]
    lag_values = [value for value in lag_values if isinstance(value, (int, float))]
    return {
        "label": report["environment"]["label"],
        "loadModel": workload.get("load_model", report["environment"]["load_model"]) if workload else "observe-only",
        "offered": workload.get("offered_operations"),
        "started": workload.get("started_operations"),
        "locallyShed": workload.get("locally_shed_operations"),
        "completed": workload.get("completed_operations"),
        "failedOrAmbiguous": workload.get("failed_or_ambiguous_operations"),
        "httpErrors": workload.get("error_distribution", {}),
        "ambiguousClientErrors": workload.get("ambiguous_client_errors"),
        "httpElapsedIncludingResponsesSeconds": workload.get("elapsed_including_drain_seconds"),
        "httpCompletedPerSecond": workload.get("completed_transfers_per_second"),
        "httpLatencyMilliseconds": workload.get("http_latency_ms"),
        "successfulHttpLatencyMilliseconds": workload.get("completed_http_latency_ms"),
        "scheduledArrivalLagMilliseconds": workload.get("schedule_lag_ms"),
        "databaseObservationSeconds": report["event_rate_observation_interval_seconds"],
        "observedEventRatesPerSecond": report["event_rates_per_second"],
        "committedDuringLoad": after["outbox_total"] - before["outbox_total"],
        "publishedDuringLoad": after["published"] - before["published"],
        "processedDuringLoad": after["processed"] - before["processed"],
        "unpublishedAfterLoad": after["unpublished"],
        "publishedUnprocessedAfterLoad": after["published_unprocessed"],
        "peakSampledUnpublished": event_max("unpublished"),
        "peakSampledPublishedUnprocessed": event_max("published_unprocessed"),
        "peakSampledMaxPartitionLag": max(lag_values) if lag_values else None,
        "drainElapsedSeconds": report["drain"]["elapsed_seconds"],
        "drainPublicationCount": report["drain"]["published_during_drain"],
        "drainProcessingCount": report["drain"]["processed_during_drain"],
        "drainRatesPerSecond": report["drain_rates_per_second"],
        "drainComplete": report["drain"]["complete"],
        "finalScopedEventsIncludingWarmup": final["completed_transfers"],
        "finalPropagationMillisecondsIncludingWarmup": final["propagation_latency_ms"],
        "finalPublicationMillisecondsIncludingWarmup": final["publication_latency_ms"],
        "finalRetriedEvents": final["retried_events"],
        "finalPublicationAttempts": final["publication_attempts"],
        "finalMaximumAttemptCount": final["maximum_attempt_count"],
        "finalMissingOutbox": final["missing_outbox"],
        "finalPublished": final["published"],
        "finalProcessed": final["processed"],
        "finalActivityRows": final["account_activity_rows"],
        "ledgerConsistent": report["reconciliation_after"]["consistent"],
        "sampleCount": len(samples),
        "lockWaitingSamples": sum(bool(sample.get("postgres_locks", {}).get("lock_waiting_sessions")) for sample in samples),
        "blockedSamples": sum(bool(sample.get("postgres_locks", {}).get("blocked_sessions")) for sample in samples),
        "samplingErrors": report["observations"]["sampling_errors"],
        "sampledInvariantFailures": report["observations"]["invariant_failures"],
        "maxSampledResources": {name: resource_max(name) for name in (
            "hikaricp.connections.active", "hikaricp.connections.pending", "process.cpu.usage",
            "jvm.memory.used", "jvm.threads.live", "events.outbox.inflight.records")},
        "loadStageMetricDeltas": report["metric_deltas"],
        "drainStageMetricDeltas": report["drain_metric_deltas"],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--directory", type=Path, default=Path("docs/benchmarks"))
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    result = {"definition": "Derived from retained trial files; source paths and observation boundaries are preserved",
              "limits": "Sequential SQL/metric/resource snapshots; HTTP histogram upper bounds; transaction-local DB timestamp percentiles; drain rates exclude progress before fresh drain-start SQL snapshot",
              "suites": {}}
    for suite in ("low", "high", "sustained", "outage", "consumer"):
        path = args.directory / f"phase3-{suite}-trial-order.json"
        timeline = json.loads(path.read_text())
        if not timeline.get("complete"):
            raise ValueError(f"{suite} timeline is incomplete; do not summarize as a completed comparison")
        trials = []
        for trial in timeline["trials"]:
            report = json.loads(Path(trial["output"]).read_text())
            value = {"position": trial["position"], "condition": trial["condition"], "image": trial["image"],
                     "rawReport": trial["output"], "loadExitCode": trial["loadExitCode"],
                     "load": summarize(report)}
            if "recoveryOutput" in trial:
                value["recoveryRawReport"] = trial["recoveryOutput"]
                value["recovery"] = summarize(json.loads(Path(trial["recoveryOutput"]).read_text()))
            trials.append(value)
        result["suites"][suite] = {"timeline": str(path), "plannedOrder": timeline["plannedOrder"],
                                  "actualOrder": [trial["condition"] for trial in timeline["trials"]], "trials": trials}
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({"output": str(args.output), "suites": len(result["suites"])}, indent=2))


if __name__ == "__main__":
    try:
        main()
    except (ValueError, KeyError, OSError) as error:
        print(f"Cannot summarize incomplete evidence: {type(error).__name__}: {error}", file=sys.stderr)
        sys.exit(1)
