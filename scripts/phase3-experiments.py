#!/usr/bin/env python3
"""Run one counterbalanced suite against existing immutable local images.

Only an explicitly named Phase 3 project is mutated. No image builds, data resets,
volume deletion, broad Docker cleanup or changes to Phase 1/2 are performed.
"""

import argparse
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile
import time

import benchmark


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--baseline-image", required=True)
    parser.add_argument("--optimized-image", required=True)
    parser.add_argument("--suite", required=True, choices=("low", "high", "sustained", "outage", "consumer"))
    parser.add_argument("--high-uuid-order", choices=("all-destinations-before-source",))
    parser.add_argument("--harness-source-commit", help="required immutable harness revision for controlled-account trials")
    parser.add_argument("--git-executable", default="git", help="Git executable used to verify immutable harness provenance")
    parser.add_argument("--compose-project", default="tpp-phase3-validation")
    parser.add_argument("--order", default="baseline,optimized,optimized,baseline")
    parser.add_argument("--workers", type=int, default=8)
    parser.add_argument("--duration", type=float, default=10)
    parser.add_argument("--arrival-rate", type=float, default=500)
    parser.add_argument("--warmup", type=float, default=3)
    parser.add_argument("--warmup-arrival-rate", type=float, default=50)
    parser.add_argument("--drain-timeout", type=float, default=180)
    parser.add_argument("--consumer-interval-ms", type=int, default=100)
    parser.add_argument("--output-directory", type=Path, default=Path("docs/benchmarks"))
    args = parser.parse_args()
    order = args.order.split(",")
    if args.high_uuid_order and args.suite != "high":
        parser.error("controlled UUID order requires the high suite")
    if args.high_uuid_order and not args.harness_source_commit:
        parser.error("controlled-account trials require an immutable harness source commit")
    if args.harness_source_commit and not re.fullmatch(r"[0-9a-f]{40}", args.harness_source_commit):
        parser.error("harness source commit must be a full lowercase Git object ID")
    if not re.fullmatch(r"tpp-phase3-[a-z0-9_-]+", args.compose_project):
        parser.error("only a project named tpp-phase3-* is supported")
    if not 2 <= len(order) <= 12 or set(order) != {"baseline", "optimized"}:
        parser.error("order must contain both image conditions and 2 to 12 trials")
    if not 1 <= args.workers <= 256 or not 0 < args.duration <= 300 or not 0 < args.arrival_rate <= 10000:
        parser.error("invalid worker, duration or arrival bound")
    if not 0 <= args.warmup <= 120 or not 0 < args.warmup_arrival_rate <= 10000 or not 1 <= args.drain_timeout <= 600:
        parser.error("invalid warmup or drain bound")
    if not 1 <= args.consumer_interval_ms <= 10000:
        parser.error("consumer interval must be in [1,10000]")
    args.output_directory.mkdir(parents=True, exist_ok=True)
    environment = os.environ.copy()
    environment.update(DB_PORT="55434", APP_PORT="28080", KAFKA_PORT="29092",
                       EVENTS_RELAY_ENABLED="true", EVENTS_CONSUMER_ENABLED="true",
                       EVENTS_CONSUMER_MIN_INTERVAL_MS="0", EVENTS_RELAY_BATCH_SIZE="16",
                       EVENTS_POLL_INTERVAL_MS="100", BACKPRESSURE_ENABLED="false")

    def run(command, timeout=240, allow_failure=False):
        completed = subprocess.run(command, text=True, capture_output=True, env=environment, timeout=timeout)
        if completed.returncode and not allow_failure:
            raise RuntimeError(f"{command[0]} operation failed with exit {completed.returncode}; no data was reset")
        return completed

    if args.harness_source_commit:
        actual_commit = run([args.git_executable, "rev-parse", "HEAD"]).stdout.strip()
        if actual_commit != args.harness_source_commit:
            raise RuntimeError("current checkout differs from the declared immutable harness revision")
        run([args.git_executable, "diff", "--quiet", "HEAD", "--", "scripts"])

    images = {mode: json.loads(run(["docker", "image", "inspect", image]).stdout)[0]["Id"]
              for mode, image in (("baseline", args.baseline_image), ("optimized", args.optimized_image))}
    if images["baseline"] == images["optimized"]:
        parser.error("comparison requires different immutable image identities")
    timeline = {"suite": args.suite, "plannedOrder": order, "images": images,
                "arguments": {key: str(value) if isinstance(value, Path) else value for key, value in vars(args).items()},
                "startedAt": benchmark.utc_now(), "trials": []}
    timeline["loadPolicy"] = "Backpressure disabled in both conditions to expose durable capacity; finite HTTP client shedding stays visible"
    timeline_path = args.output_directory / f"phase3-{args.suite}-trial-order.json"
    if timeline_path.exists():
        parser.error("trial timeline already exists; use a fresh output directory rather than overwrite evidence")

    def save():
        timeline_path.write_text(json.dumps(timeline, indent=2) + "\n")

    http = benchmark.Http("http://127.0.0.1:28080", 5)
    try:
        with tempfile.TemporaryDirectory(prefix="tpp-phase3-suite-") as temporary:
            override = Path(temporary) / "image.json"
            compose = ["docker", "compose", "--project-name", args.compose_project,
                       "-f", "compose.yaml", "-f", str(override)]

            def apply_image(mode, interval):
                override.write_text(json.dumps({"services": {"app": {
                    "image": images[mode], "environment": {
                        "JAVA_TOOL_OPTIONS": "", "EVENTS_RELAY_ENABLED": "true",
                        "EVENTS_CONSUMER_ENABLED": "true", "EVENTS_CONSUMER_MIN_INTERVAL_MS": str(interval),
                        "EVENTS_RELAY_BATCH_SIZE": "16", "EVENTS_POLL_INTERVAL_MS": "100",
                        "BACKPRESSURE_ENABLED": "false"}}}}))
                run(compose + ["up", "-d", "--no-deps", "--no-build", "--force-recreate",
                               "--wait", "--wait-timeout", "120", "app"])

            def app_identity(mode):
                identity = run(compose + ["ps", "-q", "app"]).stdout.strip()
                value = json.loads(run(["docker", "inspect", identity]).stdout)[0]
                if value["Image"] != images[mode]:
                    raise RuntimeError("actual application image differs from the planned immutable image")
                settings = sorted(item for item in value["Config"]["Env"]
                                  if item.startswith(("EVENTS_", "BACKPRESSURE_", "JAVA_TOOL_OPTIONS=")))
                return {"id": value["Id"], "image": value["Image"], "startedAt": value["State"]["StartedAt"],
                        "effectiveEnvironment": settings}

            def broker_group_snapshot():
                result = run(compose + ["exec", "-T", "kafka", "/opt/kafka/bin/kafka-consumer-groups.sh",
                                        "--bootstrap-server", "kafka:9092", "--group", "tpp-activity-v1", "--describe"],
                             timeout=30, allow_failure=True)
                partitions = []
                for line in result.stdout.splitlines():
                    fields = line.split()
                    if len(fields) >= 6 and fields[:2] == ["tpp-activity-v1", "tpp.transfer-completed.v1"]:
                        if all(value.isdigit() for value in fields[2:6]):
                            partitions.append({"partition": int(fields[2]), "committedOffset": int(fields[3]),
                                               "logEndOffset": int(fields[4]), "lag": int(fields[5])})
                known = {value["partition"] for value in partitions} == {0, 1, 2} and len(partitions) == 3
                return {"observedAt": benchmark.utc_now(), "exitCode": result.returncode,
                        "output": result.stdout[-8000:], "diagnostic": result.stderr[-2000:],
                        "partitions": partitions, "totalCommittedLag": sum(value["lag"] for value in partitions) if known else None,
                        "note": "Independent broker offset/lag snapshot, sequential after SQL/HTTP observations"}

            def require_offsets_drained():
                observations = []
                deadline = time.monotonic() + 30
                while len(observations) < 15:
                    value = broker_group_snapshot()
                    observations.append(value)
                    if value["exitCode"] == 0 and value["totalCommittedLag"] == 0 and all(
                            partition["committedOffset"] == partition["logEndOffset"] for partition in value["partitions"]):
                        return {"complete": True, "observations": observations}
                    if time.monotonic() >= deadline:
                        break
                    time.sleep(1)
                return {"complete": False, "observations": observations}

            def require_previous_drained():
                # Both endpoints query committed database state. Allow bounded in-flight
                # completion after scoped drain; non-200 observations remain an operational
                # failure distinct from a demonstrated durable backlog.
                deadline = time.monotonic() + 30
                last_observation = None
                while True:
                    code, body = http.request("GET", "/internal/events/status")
                    code2, reconciliation = http.request("GET", "/internal/events/reconciliation")
                    last_observation = {"observedAt": benchmark.utc_now(), "statusHttpCode": code,
                                        "status": body, "reconciliationHttpCode": code2,
                                        "reconciliation": reconciliation}
                    if code == 200 and code2 == 200:
                        if reconciliation.get("discrepancies"):
                            raise RuntimeError("prior projection reconciliation has discrepancies")
                        if not any(body["outbox"][k] for k in ("pending", "claimed", "blocked")) and not reconciliation.get("missingProjection"):
                            return
                    if time.monotonic() >= deadline:
                        timeline["globalDrainGuardFailure"] = last_observation
                        if code != 200 or code2 != 200:
                            raise RuntimeError("global drain inspection unavailable; refusing to start a new condition")
                        raise RuntimeError("prior global backlog is not drained; refusing to start a new condition")
                    time.sleep(1)

            for position, mode in enumerate(order, 1):
                require_previous_drained()
                interval = args.consumer_interval_ms if args.suite == "consumer" else 0
                apply_image(mode, interval)
                output = args.output_directory / f"phase3-{args.suite}-{position}-{mode}.json"
                trial = {"position": position, "condition": mode, "image": images[mode],
                         "startedAt": benchmark.utc_now(), "output": str(output), "consumerIntervalMs": interval}
                trial["applicationBeforeLoad"] = app_identity(mode)
                timeline["trials"].append(trial)
                save()
                print(f"Starting {args.suite} trial {position}: {mode}", flush=True)
                if args.suite == "outage":
                    trial["brokerStopRequestedAt"] = benchmark.utc_now()
                    run(compose + ["stop", "kafka"])
                    trial["brokerStoppedAt"] = benchmark.utc_now()
                common = [sys.executable, "scripts/event-benchmark.py", "--compose-db", "--compose-project", args.compose_project,
                          "--base-url", "http://127.0.0.1:28080", "--workers", str(args.workers),
                          "--scenario", "high" if args.suite == "high" else "low",
                          "--label", f"{args.suite}-{position}-{mode}", "--environment-notes",
                          f"immutable image {images[mode]}; trial {position}/{len(order)}; no JFR, builds or tests"]
                if args.high_uuid_order:
                    common += ["--high-uuid-order", args.high_uuid_order]
                command = common + ["--prepare", "--duration", str(args.duration), "--output", str(output)]
                if args.suite in ("sustained", "outage", "consumer"):
                    command += ["--arrival-rate", str(args.arrival_rate)]
                if args.suite in ("outage", "consumer"):
                    command += ["--warmup", "0", "--drain-timeout", "0"]
                else:
                    command += ["--warmup", str(args.warmup), "--warmup-arrival-rate", str(args.warmup_arrival_rate),
                                "--warmup-drain-timeout", str(args.drain_timeout), "--drain-timeout", str(args.drain_timeout)]
                process = run(command, timeout=900, allow_failure=True)
                trial["loadExitCode"] = process.returncode
                report = json.loads(output.read_text())
                trial["httpErrors"] = report.get("workload", {}).get("error_distribution", {})
                trial["warmupHttpErrors"] = report.get("warmup", {}).get("error_distribution", {})
                trial["applicationAfterLoad"] = app_identity(mode)
                if args.suite != "outage":
                    trial["brokerAfterLoad"] = broker_group_snapshot()
                if report.get("observations", {}).get("invariant_failures"):
                    raise RuntimeError("sampled event invariant failed; inspect retained report")
                if process.returncode >= 2:
                    raise RuntimeError("load observer failed beyond a retained HTTP-error/catchup outcome")
                if args.suite in ("outage", "consumer"):
                    if args.suite == "outage":
                        trial["brokerRestoreRequestedAt"] = benchmark.utc_now()
                        run(compose + ["up", "-d", "--no-deps", "--no-build", "--wait", "--wait-timeout", "120", "kafka"])
                        trial["brokerRestoredAt"] = benchmark.utc_now()
                        trial["applicationAfterBrokerRecovery"] = app_identity(mode)
                        if trial["applicationBeforeLoad"]["id"] != trial["applicationAfterBrokerRecovery"]["id"]:
                            raise RuntimeError("application changed during broker recovery")
                    else:
                        trial["consumerBudgetRestoreRequestedAt"] = benchmark.utc_now()
                        apply_image(mode, 0)
                        trial["consumerBudgetRestoredAt"] = benchmark.utc_now()
                        trial["applicationAfterConsumerBudgetRecovery"] = app_identity(mode)
                    recovery = output.with_name(output.stem + "-recovery.json")
                    result = run(common + ["--dataset", str(output.with_suffix(".dataset.json")), "--observe-only",
                                           "--duration", "1", "--warmup", "0", "--drain-timeout", str(args.drain_timeout),
                                           "--output", str(recovery)], timeout=900, allow_failure=True)
                    trial["recoveryExitCode"] = result.returncode
                    trial["recoveryOutput"] = str(recovery)
                    report = json.loads(recovery.read_text())
                    if report.get("observations", {}).get("invariant_failures"):
                        raise RuntimeError("sampled recovery invariant failed; inspect retained report")
                    if result.returncode:
                        raise RuntimeError("recovery observer did not exit successfully; inspect retained report")
                if not report.get("drain", {}).get("complete"):
                    raise RuntimeError("catchup did not finish; preserve backlog and inspect reports")
                trial["brokerAfterDrain"] = require_offsets_drained()
                if not trial["brokerAfterDrain"]["complete"]:
                    raise RuntimeError("SQL effects drained but final committed Kafka offsets are not proven caught up")
                require_previous_drained()
                trial["finishedAt"] = benchmark.utc_now()
                trial["committedEvents"] = report["drain"]["final_events"]["completed_transfers"]
                save()
            timeline["complete"] = True
            timeline["finishedAt"] = benchmark.utc_now()
            save()
            print(json.dumps({"timeline": str(timeline_path), "complete": True}, indent=2))
    except Exception as error:
        timeline["complete"] = False
        timeline["error"] = str(error)
        save()
        raise
    finally:
        http.close()


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, ValueError, OSError, subprocess.TimeoutExpired) as error:
        print(f"Phase 3 suite failed: {type(error).__name__}: {error}", file=sys.stderr)
        sys.exit(1)
