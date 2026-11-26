#!/usr/bin/env python3
"""Compare pre-patch and patched immutable app images on an already-owned local demo.

Four fresh-fixture ABBA trials use the existing event-benchmark.py methodology.
No builds, broker faults, resets or volume deletion occur during measurement.
"""

import argparse
import json
import math
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile
import threading
import time

import benchmark
import demo

ROOT = Path(__file__).resolve().parents[1]


def assess_clock_samples(samples, tolerance=1.0):
    """Detect suspension or clock changes without silently certifying timing."""
    failures = []
    if len(samples) < 2:
        failures.append("fewer than two clock observations")
    if any(not math.isfinite(row[key]) for row in samples for key in ("wallSeconds", "monotonicSeconds")):
        failures.append("non-finite clock observation")
        return {"valid": False, "toleranceSeconds": tolerance, "failures": failures, "samples": samples}
    peak = 0.0
    for previous, current in zip(samples, samples[1:]):
        wall = current["wallSeconds"] - previous["wallSeconds"]
        monotonic = current["monotonicSeconds"] - previous["monotonicSeconds"]
        if wall < 0 or monotonic < 0:
            failures.append("clock moved backwards")
        if abs(wall - monotonic) > tolerance:
            failures.append("interval wall/monotonic discontinuity")
    if samples:
        first, last = samples[0], samples[-1]
        peak = max(abs((row["wallSeconds"] - first["wallSeconds"]) -
                       (row["monotonicSeconds"] - first["monotonicSeconds"])) for row in samples)
        if peak > tolerance:
            failures.append("cumulative wall/monotonic discontinuity")
        elapsed_wall = last["wallSeconds"] - first["wallSeconds"]
        elapsed_monotonic = last["monotonicSeconds"] - first["monotonicSeconds"]
        if elapsed_wall <= 0 or elapsed_monotonic <= 0:
            failures.append("non-positive clock interval")
    else:
        elapsed_wall = elapsed_monotonic = 0
    return {"valid": not failures, "toleranceSeconds": tolerance,
            "sampleIntervalSeconds": 0.25, "wallElapsedSeconds": elapsed_wall,
            "monotonicElapsedSeconds": elapsed_monotonic,
            "peakCumulativeDiscontinuitySeconds": peak,
            "failures": sorted(set(failures)), "samples": samples}


class ClockWatch:
    """Sample both host clocks across the complete benchmark subprocess."""

    def __init__(self):
        self.samples = []
        self.stopped = threading.Event()
        self.thread = threading.Thread(target=self._observe, daemon=True)

    def _sample(self):
        self.samples.append({"wallSeconds": time.time(), "monotonicSeconds": time.monotonic()})

    def _observe(self):
        while not self.stopped.wait(0.25):
            self._sample()

    def start(self):
        self._sample()
        self.thread.start()

    def finish(self):
        self.stopped.set()
        self.thread.join()
        self._sample()
        return assess_clock_samples(self.samples)


def check_effects(report):
    if not report.get("drain", {}).get("complete"):
        raise RuntimeError("scoped effects did not drain; retain the report and backlog")
    if report.get("observations", {}).get("invariant_failures"):
        raise RuntimeError("sampled invariant failure; comparison cannot pass")
    final = report["drain"]["final_events"]
    completed = final["completed_transfers"]
    if any(final[name] != completed for name in ("outbox_total", "published", "processed", "projection_rows")):
        raise RuntimeError("final committed event identities/effects do not agree")
    if final["account_activity_rows"] != 2 * completed or final["missing_outbox"] != 0:
        raise RuntimeError("final paired activity or outbox invariant failed")


def offsets(run, compose):
    observations = []
    for _ in range(5):
        output = run(compose + ["exec", "-T", "kafka", "/opt/kafka/bin/kafka-consumer-groups.sh",
                                "--bootstrap-server", "kafka:9092", "--group", "tpp-activity-v1", "--describe"], timeout=30)
        partitions = []
        for line in output.splitlines():
            fields = line.split()
            if len(fields) >= 6 and fields[:2] == ["tpp-activity-v1", "tpp.transfer-completed.v1"] and all(v.isdigit() for v in fields[2:6]):
                partitions.append({"partition": int(fields[2]), "committed": int(fields[3]), "logEnd": int(fields[4]), "lag": int(fields[5])})
        observations.append({"observedAt": benchmark.utc_now(), "partitions": partitions})
        if len(partitions) == 3 and {p["partition"] for p in partitions} == {0, 1, 2} and all(p["committed"] == p["logEnd"] and p["lag"] == 0 for p in partitions):
            return {"complete": True, "observations": observations}
        time.sleep(1)
    return {"complete": False, "observations": observations}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--baseline-image", required=True)
    parser.add_argument("--patched-image", required=True)
    parser.add_argument("--project", default="tpp-release-readiness")
    parser.add_argument("--app-port", type=int, default=38080)
    parser.add_argument("--db-port", type=int, default=55436)
    parser.add_argument("--kafka-port", type=int, default=39092)
    parser.add_argument("--duration", type=float, default=10)
    parser.add_argument("--workers", type=int, default=8)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if not re.fullmatch(r"[a-z0-9][a-z0-9_-]{0,62}", args.project):
        parser.error("invalid project name")
    if any(not re.fullmatch(r"sha256:[a-f0-9]{64}", image) for image in (args.baseline_image, args.patched_image)):
        parser.error("images must be immutable local sha256 identities")
    if args.baseline_image == args.patched_image:
        parser.error("image identities must differ")
    ports = (args.app_port, args.db_port, args.kafka_port)
    if len(set(ports)) != 3 or any(not 1024 <= p <= 65535 for p in ports):
        parser.error("three distinct unprivileged ports are required")
    if not 1 <= args.workers <= 32 or not 1 <= args.duration <= 30:
        parser.error("workers must be [1,32], duration [1,30] seconds")
    if args.output.exists():
        parser.error("output directory exists; use a new path to preserve observations")
    env = dict(os.environ, APP_PORT=str(args.app_port), DB_PORT=str(args.db_port), KAFKA_PORT=str(args.kafka_port),
               EVENTS_RELAY_ENABLED="true", EVENTS_CONSUMER_ENABLED="true", BACKPRESSURE_ENABLED="false",
               EVENTS_RELAY_BATCH_SIZE="16", EVENTS_POLL_INTERVAL_MS="100", EVENTS_CONSUMER_MIN_INTERVAL_MS="0",
               COMPOSE_FILE=str(ROOT / "compose.yaml"))
    env.pop("COMPOSE_PROFILES", None)

    def run(command, capture=True, timeout=240):
        result = subprocess.run(command, cwd=ROOT, env=env, capture_output=True, text=True, timeout=timeout)
        if result.returncode:
            raise RuntimeError(f"{command[0]} operation failed ({result.returncode})")
        return result.stdout

    demo.require_local_docker(run, env)
    demo.require_owned_project(run, args.project, ROOT / "benchmark-results" / f"{args.project}.owner.json")
    selected_compose = ["docker", "compose", "--file", str(ROOT / "compose.yaml"), "--project-name", args.project]
    initial_app = run(selected_compose + ["ps", "--quiet", "app"]).strip()
    if not initial_app:
        raise RuntimeError("start the owned demo before comparison")
    binding = json.loads(run(["docker", "inspect", "--format", '{{json (index .NetworkSettings.Ports "8080/tcp")}}', initial_app]))
    if binding != [{"HostIp": "127.0.0.1", "HostPort": str(args.app_port)}]:
        raise RuntimeError("selected demo's actual loopback HTTP binding differs from the request")
    for image in (args.baseline_image, args.patched_image):
        if run(["docker", "image", "inspect", "--format", "{{.Id}}", image]).strip() != image:
            raise RuntimeError("local image identity differs from the declared input")
    args.output.mkdir(parents=True)
    timeline_path = args.output / "comparison.json"
    timeline = {"purpose": "Security-dependency comparison; both app images retain the final bounded relay/lifecycle code",
                "order": ["baseline", "patched", "patched", "baseline"], "project": args.project,
                "images": {"baseline": args.baseline_image, "patched": args.patched_image},
                "startedAt": benchmark.utc_now(), "durationSeconds": args.duration, "workers": args.workers,
                "methodology": "Independent pairs; closed-loop input;150 fixed-arrival warmup requests; fresh balanced fixture per trial",
                "trials": []}
    save = lambda: timeline_path.write_text(json.dumps(timeline, indent=2) + "\n")
    http = benchmark.Http(f"http://127.0.0.1:{args.app_port}", 5)
    try:
        with tempfile.TemporaryDirectory(prefix="tpp-security-comparison-") as temporary:
            override = Path(temporary) / "image.json"
            compose = ["docker", "compose", "--file", str(ROOT / "compose.yaml"), "--file", str(override), "--project-name", args.project]
            try:
                for position, condition in enumerate(timeline["order"], 1):
                    status, state = http.request("GET", "/internal/events/status")
                    status2, projection = http.request("GET", "/internal/events/reconciliation")
                    if status != 200 or status2 != 200 or any(state["outbox"][key] for key in ("pending", "claimed", "blocked")) or projection.get("discrepancies") or projection.get("missingProjection"):
                        raise RuntimeError("prior committed backlog is not proven drained")
                    override.write_text(json.dumps({"services": {"app": {"image": timeline["images"][condition]}}}))
                    run(compose + ["up", "--detach", "--no-deps", "--no-build", "--force-recreate", "--wait", "--wait-timeout", "180", "app"])
                    actual = run(compose + ["ps", "--quiet", "app"]).strip()
                    if run(["docker", "inspect", "--format", "{{.Image}}", actual]).strip() != timeline["images"][condition]:
                        raise RuntimeError("running image differs from measured condition")
                    report_path = args.output / f"trial-{position}-{condition}.json"
                    command = [sys.executable, str(ROOT / "scripts/event-benchmark.py"), "--base-url", f"http://127.0.0.1:{args.app_port}",
                               "--compose-db", "--compose-project", args.project, "--prepare", "--scenario", "low", "--workers", str(args.workers),
                               "--duration", str(args.duration), "--warmup", "3", "--warmup-arrival-rate", "50", "--warmup-drain-timeout", "180",
                               "--drain-timeout", "180", "--label", f"security-{position}-{condition}", "--output", str(report_path),
                               "--environment-notes", f"immutable image {timeline['images'][condition]}; both images share pinned Java/PostgreSQL/Kafka; no builds, tests or profiling during input"]
                    clock = ClockWatch()
                    trial = {"position": position, "condition": condition, "image": timeline["images"][condition],
                             "report": report_path.name, "exitCode": None}
                    timeline["trials"].append(trial)
                    save()
                    clock.start()
                    try:
                        result = subprocess.run(command, cwd=ROOT, env=env, capture_output=True, text=True, timeout=420)
                    finally:
                        clock_result = clock.finish()
                        trial["clockGuard"] = clock_result
                        save()
                    report_path.with_suffix(".log").write_text(result.stdout + "\n" + result.stderr)
                    trial["exitCode"] = result.returncode
                    save()
                    if result.returncode >= 2 or not report_path.exists():
                        raise RuntimeError("benchmark failed; retained reports are not a passing observation")
                    report = json.loads(report_path.read_text())
                    check_effects(report)
                    trial["httpErrors"] = report.get("workload", {}).get("error_distribution", {})
                    trial["warmupErrors"] = report.get("warmup", {}).get("error_distribution", {})
                    trial["ledgerReconciliation"] = benchmark.reconciliation(http)
                    trial["committedKafkaOffsets"] = offsets(run, compose)
                    save()
                    if not trial["committedKafkaOffsets"]["complete"]:
                        save()
                        raise RuntimeError("final committed Kafka offsets are not proven caught up")
                    if trial["httpErrors"] or trial["warmupErrors"]:
                        raise RuntimeError("HTTP errors observed; timing is not a passing comparison")
                    if not clock_result["valid"]:
                        raise RuntimeError("clock discontinuity observed; durable effects remain recorded separately")
                    trial["complete"] = True
                    save()
                    print(f"Completed {position}/4: {condition}; committed effects reconcile", flush=True)
                timeline["complete"] = True
                timeline["finishedAt"] = benchmark.utc_now()
                save()
            finally:
                # Leave this owned project on patched code even if measurement fails or is interrupted.
                override.write_text(json.dumps({"services": {"app": {"image": args.patched_image}}}))
                run(compose + ["up", "--detach", "--no-deps", "--no-build", "--force-recreate", "--wait", "--wait-timeout", "180", "app"])
                timeline["patchedImageRestored"] = True
                save()
    except BaseException as error:
        timeline["complete"] = False
        timeline["errorType"] = type(error).__name__
        timeline["error"] = str(error)
        save()
        raise
    finally:
        http.close()


if __name__ == "__main__":
    try:
        main()
    except (OSError, RuntimeError, ValueError, subprocess.TimeoutExpired) as error:
        print(f"Security comparison failed: {error}", file=sys.stderr)
        sys.exit(1)
