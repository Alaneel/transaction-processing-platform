#!/usr/bin/env python3
"""Offline authorization-boundary checks. They do not simulate real delivery or integration."""

import json
from contextlib import redirect_stdout
import io
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import demo


class DemoBoundaryTest(unittest.TestCase):
    def test_remote_host_refused_without_even_reading_context(self):
        calls = []
        with self.assertRaisesRegex(RuntimeError, "DOCKER_HOST"):
            demo.require_local_docker(lambda *a, **k: calls.append(a), {"DOCKER_HOST": "tcp://remote.example:2376"})
        self.assertEqual(calls, [])

    def test_remote_context_refused_before_any_daemon_call(self):
        calls = []
        def run(command, **kwargs):
            calls.append(command)
            return json.dumps("ssh://remote.example")
        with self.assertRaisesRegex(RuntimeError, "local Unix-socket"):
            demo.require_local_docker(run, {})
        self.assertEqual(len(calls), 1)
        self.assertEqual(calls[0][:3], ["docker", "context", "inspect"])

    def test_local_unix_context_is_accepted(self):
        demo.require_local_docker(lambda *a, **k: json.dumps("unix:///var/run/docker.sock"), {})

    def test_query_bearing_unix_endpoint_is_refused(self):
        with self.assertRaisesRegex(RuntimeError, "local Unix-socket"):
            demo.require_local_docker(lambda *a, **k: json.dumps("unix:///local.sock?remote=1"), {})

    def test_context_endpoint_is_pinned_and_tls_overrides_removed(self):
        env = {"DOCKER_CONTEXT": "local-context", "DOCKER_HOST": "unix:///another.sock",
               "DOCKER_TLS_VERIFY": "1", "DOCKER_TLS": "1", "DOCKER_CERT_PATH": "/foreign/certs"}
        demo.require_local_docker(lambda *a, **k: json.dumps("unix:///local.sock"), env)
        self.assertEqual(env, {"DOCKER_HOST": "unix:///local.sock"})

    def test_compose_file_environment_cannot_redirect_the_command_plan(self):
        output = io.StringIO()
        with patch.dict(os.environ, {"COMPOSE_FILE": "/foreign/compose.yaml"}), patch("sys.argv", ["demo.py", "--dry-run"]), redirect_stdout(output):
            demo.main()
        commands = json.loads(output.getvalue())["commands"]
        for command in commands[:3]:
            self.assertEqual(command[:4], ["docker", "compose", "--file", str(demo.ROOT / "compose.yaml")])

    def test_uncertain_broker_stop_still_attempts_restore(self):
        commands = []
        def run(command, **kwargs):
            commands.append(command)
            if "stop" in command:
                raise RuntimeError("uncertain stop")
            return "container-id\n" if "ps" in command else "fixed-start-time\n"
        with patch.object(demo.benchmark, "Http"):
            with self.assertRaisesRegex(RuntimeError, "uncertain stop"):
                demo.outage(run, ["docker", "compose", "--file", str(demo.ROOT / "compose.yaml"), "--project-name", "tpp-test"], [], "http://127.0.0.1:38080")
        self.assertEqual(commands[-1][-6:], ["up", "--detach", "--wait", "--wait-timeout", "180", "kafka"])

    def test_foreign_project_refused_before_volume_or_compose_operations(self):
        calls = []
        def run(command, **kwargs):
            calls.append(command)
            if command[1] == "ps":
                return "container-id\n"
            return json.dumps({"com.docker.compose.project.working_dir": "/another/checkout"})
        with tempfile.TemporaryDirectory() as directory:
            with self.assertRaisesRegex(RuntimeError, "another checkout"):
                demo.require_owned_project(run, "tpp-test", Path(directory) / "owner.json")
        self.assertEqual(len(calls), 2)
        self.assertTrue(all(command[1] in ("ps", "inspect") for command in calls))

    def test_unidentified_orphan_volume_refused(self):
        def run(command, **kwargs):
            return "" if command[1] == "ps" else "tpp-test_pgdata\n"
        with tempfile.TemporaryDirectory() as directory:
            with self.assertRaisesRegex(RuntimeError, "ownership record"):
                demo.require_owned_project(run, "tpp-test", Path(directory) / "owner.json")

    def test_saved_owner_allows_retained_volume_reuse(self):
        def run(command, **kwargs):
            return "" if command[1] == "ps" else "tpp-test_pgdata\n"
        expected = {"project": "tpp-test", "workingDirectory": str(demo.ROOT)}
        with tempfile.TemporaryDirectory() as directory:
            owner_path = Path(directory) / "owner.json"
            owner_path.write_text(json.dumps(expected))
            self.assertEqual(demo.require_owned_project(run, "tpp-test", owner_path), expected)

    def test_owner_leaf_symlink_is_refused_before_daemon_or_victim_write(self):
        with tempfile.TemporaryDirectory() as directory:
            victim = Path(directory) / "victim.json"
            victim.write_text("private existing content")
            owner = Path(directory) / "owner.json"
            owner.symlink_to(victim)
            calls = []
            with self.assertRaisesRegex(RuntimeError, "symlinks"):
                demo.require_owned_project(lambda *a, **k: calls.append(a), "tpp-test", owner)
            with self.assertRaisesRegex(RuntimeError, "symlinks"):
                demo.write_owner(owner, {})
            self.assertEqual(calls, [])
            self.assertEqual(victim.read_text(), "private existing content")

    def test_dangling_owner_symlink_is_not_created_or_followed(self):
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / "missing.json"
            owner = Path(directory) / "owner.json"
            owner.symlink_to(target)
            with self.assertRaisesRegex(RuntimeError, "symlinks"):
                demo.write_owner(owner, {})
            self.assertFalse(target.exists())
            self.assertTrue(owner.is_symlink())

    def test_parent_symlink_and_dangling_parent_are_refused(self):
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / "other"
            target.mkdir()
            parent = Path(directory) / "metadata"
            for destination in (target, Path(directory) / "missing"):
                parent.symlink_to(destination, target_is_directory=True)
                with self.assertRaisesRegex(RuntimeError, "symlinks"):
                    demo.write_owner(parent / "owner.json", {})
                with self.assertRaisesRegex(RuntimeError, "symlinks"):
                    demo.read_owner(parent / "owner.json")
                parent.unlink()
            self.assertEqual(list(target.iterdir()), [])

    def test_complete_owner_is_private_atomic_and_reusable(self):
        expected = {"project": "tpp-test", "workingDirectory": str(demo.ROOT)}
        with tempfile.TemporaryDirectory() as directory:
            parent = Path(directory) / "metadata"
            owner = parent / "owner.json"
            demo.write_owner(owner, expected)
            self.assertEqual(demo.read_owner(owner), expected)
            self.assertEqual(owner.stat().st_mode & 0o777, 0o600)
            self.assertEqual(owner.stat().st_nlink, 1)
            self.assertEqual(list(parent.iterdir()), [owner])
            owner.chmod(0o644)
            original = owner.read_bytes()
            demo.write_owner(owner, expected)
            self.assertEqual(owner.read_bytes(), original)
            self.assertEqual(owner.stat().st_mode & 0o777, 0o600)

    def test_foreign_owner_is_never_replaced(self):
        with tempfile.TemporaryDirectory() as directory:
            owner = Path(directory) / "owner.json"
            owner.write_text(json.dumps({"project": "another"}))
            before = owner.read_bytes()
            with self.assertRaisesRegex(RuntimeError, "another checkout or project"):
                demo.write_owner(owner, {"project": "tpp-test"})
            self.assertEqual(owner.read_bytes(), before)

    def test_racing_owner_publish_is_exclusive_and_cleans_only_own_temporary(self):
        with tempfile.TemporaryDirectory() as directory:
            owner = Path(directory) / "owner.json"
            def concurrent_publish(*args, **kwargs):
                owner.write_text("concurrent record")
                raise FileExistsError()
            with patch.object(demo.os, "link", side_effect=concurrent_publish):
                with self.assertRaisesRegex(RuntimeError, "appeared concurrently"):
                    demo.write_owner(owner, {"project": "tpp-test"})
            self.assertEqual(owner.read_text(), "concurrent record")
            self.assertEqual(list(Path(directory).iterdir()), [owner])

    def test_hard_link_and_fifo_owner_are_refused_without_blocking(self):
        with tempfile.TemporaryDirectory() as directory:
            victim = Path(directory) / "victim"
            victim.write_text("{}")
            owner = Path(directory) / "owner.json"
            os.link(victim, owner)
            with self.assertRaisesRegex(RuntimeError, "single regular file"):
                demo.read_owner(owner)
            owner.unlink()
            os.mkfifo(owner)
            with self.assertRaisesRegex(RuntimeError, "single regular file"):
                demo.read_owner(owner)

    def test_main_refuses_default_linked_metadata_parent_before_any_write(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory).resolve() / "checkout"
            root.mkdir()
            victim = root.parent / "other"
            victim.mkdir()
            log = victim / "demo.log"
            log.write_text("untouched log")
            report = victim / "demo.json"
            report.write_text('{"project":"tpp-portfolio-demo","smoke":{},"sentinel":1}')
            before = report.read_bytes()
            (root / "benchmark-results").symlink_to(victim, target_is_directory=True)
            with patch.object(demo, "ROOT", root), patch("sys.argv", ["demo.py"]), patch.object(demo.subprocess, "run") as docker:
                with self.assertRaisesRegex(RuntimeError, "symlinks"):
                    demo.main()
                docker.assert_not_called()
            self.assertEqual(log.read_text(), "untouched log")
            self.assertEqual(report.read_bytes(), before)

    def test_main_refuses_linked_log_and_report_before_any_daemon_call(self):
        for leaf in ("demo.log", "demo.json"):
            with self.subTest(leaf=leaf), tempfile.TemporaryDirectory() as directory:
                root = Path(directory).resolve()
                output = root / "benchmark-results"
                output.mkdir()
                victim = root / "victim"
                victim.write_text("private unchanged content")
                (output / leaf).symlink_to(victim)
                with patch.object(demo, "ROOT", root), patch("sys.argv", ["demo.py"]), patch.object(demo.subprocess, "run") as docker:
                    with self.assertRaisesRegex(RuntimeError, "links or special files"):
                        demo.main()
                    docker.assert_not_called()
                self.assertEqual(victim.read_text(), "private unchanged content")
                self.assertEqual(list(output.iterdir()), [output / leaf])

    def test_main_refuses_hardlinked_and_special_output_without_blocking(self):
        for leaf in ("demo.log", "demo.json"):
            for kind in ("hardlink", "fifo"):
                with self.subTest(leaf=leaf, kind=kind), tempfile.TemporaryDirectory() as directory:
                    root = Path(directory).resolve()
                    output = root / "benchmark-results"
                    output.mkdir()
                    victim = root / "victim"
                    victim.write_text("private unchanged content")
                    target = output / leaf
                    if kind == "hardlink":
                        os.link(victim, target)
                    else:
                        os.mkfifo(target)
                    with patch.object(demo, "ROOT", root), patch("sys.argv", ["demo.py"]), patch.object(demo.subprocess, "run") as docker:
                        with self.assertRaisesRegex(RuntimeError, "single regular file|special files"):
                            demo.main()
                        docker.assert_not_called()
                    self.assertEqual(victim.read_text(), "private unchanged content")

    def test_custom_output_is_private_atomic_and_preserves_append_intent(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory).resolve() / "custom" / "demo.json"
            first = {"project": "tpp-test", "smoke": {"first": True}}
            with demo.report_files(output, "tpp-test") as (log, publish):
                log.write("first\n")
                publish(first)
            old_inode = output.stat().st_ino
            second = {"project": "tpp-test", "smoke": {"second": True}}
            with demo.report_files(output, "tpp-test") as (log, publish):
                log.write("second\n")
                publish(second)
            self.assertEqual(json.loads(output.read_text()), second)
            self.assertNotEqual(output.stat().st_ino, old_inode)
            self.assertEqual(output.with_suffix(".log").read_text(), "first\nsecond\n")
            for file in output.parent.iterdir():
                self.assertEqual(file.stat().st_mode & 0o777, 0o600)
                self.assertEqual(file.stat().st_nlink, 1)
            self.assertEqual({p.name for p in output.parent.iterdir()}, {"demo.json", "demo.log"})

    def test_invalid_or_foreign_report_is_preserved_before_log_append(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory).resolve() / "demo.json"
            log = output.with_suffix(".log")
            log.write_text("untouched")
            for before in ("private arbitrary data", '{"project":"another","smoke":{}}'):
                output.write_text(before)
                with self.assertRaisesRegex(RuntimeError, "existing demo report"):
                    with demo.report_files(output, "tpp-test"):
                        self.fail("unsafe report entered writable context")
                self.assertEqual(output.read_text(), before)
                self.assertEqual(log.read_text(), "untouched")


if __name__ == "__main__":
    unittest.main()
