#!/usr/bin/env python3
"""Offline guards ensure benchmark bookkeeping cannot certify incomplete durable effects."""

import importlib.util
from pathlib import Path
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location("security_comparison", Path(__file__).with_name("security-patch-comparison.py"))
comparison = importlib.util.module_from_spec(spec)
spec.loader.exec_module(comparison)


class ComparisonGuardTest(unittest.TestCase):
    def report(self):
        return {"drain": {"complete": True, "final_events": {"completed_transfers": 3, "outbox_total": 3,
                "published": 3, "processed": 3, "projection_rows": 3, "account_activity_rows": 6, "missing_outbox": 0}},
                "observations": {"invariant_failures": []}}

    def test_balanced_complete_population_is_accepted(self):
        comparison.check_effects(self.report())

    def test_each_incomplete_identity_boundary_is_rejected(self):
        for field in ("outbox_total", "published", "processed", "projection_rows"):
            with self.subTest(field=field):
                report = self.report()
                report["drain"]["final_events"][field] = 2
                with self.assertRaisesRegex(RuntimeError, "identities/effects"):
                    comparison.check_effects(report)

    def test_missing_outbox_or_unpaired_effect_is_rejected(self):
        for field, value in (("missing_outbox", 1), ("account_activity_rows", 5)):
            with self.subTest(field=field):
                report = self.report()
                report["drain"]["final_events"][field] = value
                with self.assertRaisesRegex(RuntimeError, "paired activity or outbox"):
                    comparison.check_effects(report)

    def test_failed_drain_and_sampled_corruption_are_rejected(self):
        for report in (dict(self.report(), drain={"complete": False}),
                       dict(self.report(), observations={"invariant_failures": ["corruption"]})):
            with self.assertRaises(RuntimeError):
                comparison.check_effects(report)

    def test_complete_independent_offset_positions_are_required(self):
        def response(partitions):
            return "\n".join(f"tpp-activity-v1 tpp.transfer-completed.v1 {partition} 10 10 0" for partition in partitions)
        good = comparison.offsets(lambda *a, **k: response([0, 1, 2]), [])
        self.assertTrue(good["complete"])
        with patch.object(comparison.time, "sleep"):
            bad = comparison.offsets(lambda *a, **k: response([0, 0, 2]), [])
        self.assertFalse(bad["complete"])
        self.assertEqual(len(bad["observations"]), 5)

    def test_aligned_clock_samples_are_accepted(self):
        result = comparison.assess_clock_samples([
            {"wallSeconds": 100 + i, "monotonicSeconds": 50 + i} for i in range(4)])
        self.assertTrue(result["valid"])
        self.assertEqual(result["wallElapsedSeconds"], 3)

    def test_forward_backward_and_canceling_jumps_are_rejected(self):
        for wall in ([100, 103, 104], [100, 99, 102], [100, 104, 102]):
            with self.subTest(wall=wall):
                result = comparison.assess_clock_samples([
                    {"wallSeconds": value, "monotonicSeconds": 50 + index}
                    for index, value in enumerate(wall)])
                self.assertFalse(result["valid"])

    def test_monotonic_backwards_nonfinite_or_missing_samples_are_rejected(self):
        for values in ([{"wallSeconds": 100, "monotonicSeconds": 50}],
                       [{"wallSeconds": 100, "monotonicSeconds": 50}, {"wallSeconds": 101, "monotonicSeconds": 49}],
                       [{"wallSeconds": 100, "monotonicSeconds": 50}, {"wallSeconds": float("nan"), "monotonicSeconds": 51}]):
            with self.subTest(values=values):
                self.assertFalse(comparison.assess_clock_samples(values)["valid"])


if __name__ == "__main__":
    unittest.main()
