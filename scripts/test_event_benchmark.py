#!/usr/bin/env python3
"""Offline checks for fixed-arrival accounting and its finite concurrency bound."""

import importlib.util
import json
import math
from pathlib import Path
import threading
import tempfile
import time
from types import SimpleNamespace
import unittest
import uuid
from unittest.mock import patch

spec = importlib.util.spec_from_file_location("event_benchmark", Path(__file__).with_name("event-benchmark.py"))
events = importlib.util.module_from_spec(spec)
spec.loader.exec_module(events)
runner_spec = importlib.util.spec_from_file_location("phase3_experiments", Path(__file__).with_name("phase3-experiments.py"))
runner = importlib.util.module_from_spec(runner_spec)
runner_spec.loader.exec_module(runner)


class BenchmarkScheduleTest(unittest.TestCase):
    def test_recovery_invariant_failure_cannot_complete_a_comparison_trial(self):
        class Http:
            def __init__(self, *_):
                pass

            def request(self, _method, path):
                return (200, {"outbox": {"pending": 0, "claimed": 0, "blocked": 0}}) if path.endswith("status") else (200, {"discrepancies": 0, "missingProjection": 0})

            def close(self):
                pass

        def run(command, **_kwargs):
            output = ""
            code = 0
            if command[:3] == ["docker", "image", "inspect"]:
                output = json.dumps([{"Id": "sha256:baseline" if command[-1] == "baseline-image" else "sha256:optimized"}])
            elif command[:2] == ["docker", "inspect"]:
                output = json.dumps([{"Id": "same-application", "Image": "sha256:baseline",
                                      "State": {"StartedAt": "fixture"}, "Config": {"Env": []}}])
            elif "ps" in command:
                output = "same-application"
            elif "scripts/event-benchmark.py" in command:
                recovery = "--observe-only" in command
                report = {"workload": {"error_distribution": {}},
                          "observations": {"invariant_failures": ["controlled broken projection"] if recovery else []},
                          "drain": {"complete": recovery}}
                Path(command[command.index("--output") + 1]).write_text(json.dumps(report))
                code = 2 if recovery else 0
            return SimpleNamespace(returncode=code, stdout=output, stderr="")

        with tempfile.TemporaryDirectory() as directory:
            argv = ["phase3-experiments.py", "--baseline-image", "baseline-image", "--optimized-image", "optimized-image",
                    "--suite", "outage", "--output-directory", directory]
            with patch.object(runner.sys, "argv", argv), patch.object(runner.subprocess, "run", run), patch.object(runner.benchmark, "Http", Http):
                with self.assertRaisesRegex(RuntimeError, "sampled recovery invariant"):
                    runner.main()
            timeline = json.loads((Path(directory) / "phase3-outage-trial-order.json").read_text())
            self.assertFalse(timeline["complete"])
            self.assertEqual(2, timeline["trials"][0]["recoveryExitCode"])
            self.assertIn("sampled recovery invariant", timeline["error"])

    def test_controlled_high_fixture_preserves_fresh_uuids_and_default_order(self):
        namespace = uuid.UUID("12345678-1234-4234-8234-123456789abc")
        with patch.object(events.benchmark.uuid, "uuid4", return_value=namespace):
            default, _ = events.benchmark.fixture(8, 1000, fund_destinations=True)
            controlled, _ = events.benchmark.fixture(8, 1000, fund_destinations=True,
                high_uuid_order="all-destinations-before-source")
        self.assertEqual(str(uuid.uuid5(namespace, "high-source")), default["high"][0][0])
        self.assertNotIn("high_uuid_order", default)
        self.assertEqual(default["low"], controlled["low"])
        self.assertEqual(default["issuance_account"], controlled["issuance_account"])
        self.assertEqual(8, controlled["high_destinations_sorting_before_source"])
        identities = {identity for pair in controlled["low"] + controlled["high"] for identity in pair}
        self.assertEqual(25, len(identities))
        for source, destination in controlled["high"]:
            self.assertLess(uuid.UUID(destination).bytes, uuid.UUID(source).bytes)
            for identity in (source, destination):
                self.assertEqual(5, uuid.UUID(identity).version)
                self.assertEqual(uuid.RFC_4122, uuid.UUID(identity).variant)
        fresh, _ = events.benchmark.fixture(8, 1000, high_uuid_order="all-destinations-before-source")
        self.assertTrue(identities.isdisjoint({identity for pair in fresh["high"] for identity in pair}))
        with self.assertRaises(ValueError):
            events.benchmark.fixture(8, 1000, high_uuid_order="unsupported")

    def test_fixed_arrival_fixture_funds_both_sides_and_records_terminal_rejection_codes(self):
        manifest, sql = events.benchmark.fixture(2, 1000, fund_destinations=True)
        self.assertTrue(manifest["funded_low_destinations"])
        self.assertEqual(5, manifest["funding_transfer_count"])
        for pair in manifest["low"]:
            for identity in pair:
                self.assertIn(f"UPDATE balances SET amount = amount + 1000 WHERE account_id = '{identity}'", sql)
        self.assertEqual("HTTP_422:INSUFFICIENT_FUNDS", events.error_key(422, {"rejectionCode": "INSUFFICIENT_FUNDS"}))

    def test_metric_filters_keep_stages_separate_and_preserve_rolling_max(self):
        seen = []

        class Http:
            def request(self, _method, path):
                seen.append(path)
                return 200, {"measurements": [{"statistic": "COUNT", "value": 4},
                                              {"statistic": "TOTAL_TIME", "value": 0.2},
                                              {"statistic": "MAX", "value": 0.08}]}

        spec = "events.outbox.database.duration@operation=publish,result=committed"
        result = events.metric_snapshot(Http(), [spec])
        self.assertEqual(["/actuator/metrics/events.outbox.database.duration?tag=operation%3Apublish&tag=result%3Acommitted"], seen)
        self.assertEqual(0.08, result["values"][spec]["MAX"])
        self.assertEqual(4, result["values"][spec]["COUNT"])
        with self.assertRaises(ValueError):
            events.metric_spec("events.stage@operation=claim,operation=publish")

    def run_schedule(self, rate, duration, workers, delay, status=201, unexpected=False):
        lock = threading.Lock()
        observed = {"active": 0, "peak": 0, "keys": [], "closed": 0}

        class Http:
            def __init__(self, *_):
                pass

            def request(self, _method, _path, _payload, headers):
                with lock:
                    observed["active"] += 1
                    observed["peak"] = max(observed["peak"], observed["active"])
                    observed["keys"].append(headers["Idempotency-Key"])
                try:
                    time.sleep(delay)
                    if unexpected:
                        raise RuntimeError("test worker failure")
                    return status, {"status": "COMPLETED"} if status == 201 else {"code": "DEPENDENCY_UNAVAILABLE"}
                finally:
                    with lock:
                        observed["active"] -= 1

            def close(self):
                observed["closed"] += 1

        args = SimpleNamespace(arrival_rate=rate, workers=workers, base_url="http://test", timeout=1, scenario="low")
        manifest = {"low": [[f"source-{i}", f"destination-{i}"] for i in range(workers)]}
        with patch.object(events.benchmark, "Http", Http):
            result = events.fixed_arrival_load(args, manifest, "test", duration)
        return result, observed

    def test_slow_requests_shed_arrivals_without_growing_concurrency_or_retrying(self):
        result, observed = self.run_schedule(1000, 0.08, 2, 0.02)
        self.assertEqual(math.ceil(1000 * 0.08), result["offered_operations"])
        self.assertEqual(result["offered_operations"], result["started_operations"] + result["locally_shed_operations"])
        self.assertGreater(result["locally_shed_operations"], 0)
        self.assertLessEqual(observed["peak"], 2)
        self.assertLessEqual(result["peak_outstanding_requests"], 2)
        self.assertEqual(result["started_operations"], len(observed["keys"]))
        self.assertEqual(len(observed["keys"]), len(set(observed["keys"])))
        self.assertEqual(result["started_operations"], result["completed_operations"])
        self.assertEqual(result["started_operations"], result["http_latency_ms"]["count"])
        self.assertEqual(result["started_operations"], result["schedule_lag_ms"]["count"])
        self.assertLessEqual(observed["closed"], 2)

    def test_http_rejections_keep_classification_and_are_distinct_from_local_shedding(self):
        # Capacity covers all four offered arrivals even if the pacer wakes late.
        # The separate slow-request test checks shedding under real contention.
        result, _ = self.run_schedule(30, 0.12, 4, 0.001, status=503)
        self.assertEqual(4, result["started_operations"])
        self.assertEqual(0, result["locally_shed_operations"])
        self.assertEqual(0, result["completed_operations"])
        self.assertEqual(result["started_operations"], result["error_distribution"]["HTTP_503:DEPENDENCY_UNAVAILABLE"])
        self.assertEqual(0, result["ambiguous_client_errors"])

    def test_unexpected_worker_failure_is_visible_without_retaining_futures(self):
        result, _ = self.run_schedule(30, 0.12, 2, 0.001, unexpected=True)
        self.assertEqual(result["started_operations"], result["error_distribution"]["worker:RuntimeError"])
        self.assertEqual(result["started_operations"], result["failed_or_ambiguous_operations"])
        self.assertEqual(0, result["completed_operations"])


if __name__ == "__main__":
    unittest.main()
