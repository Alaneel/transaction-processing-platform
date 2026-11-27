#!/usr/bin/env python3
"""Offline launcher boundaries; no Docker, HTTP, browser or live financial effects."""

from contextlib import redirect_stderr
import importlib.util
import io
import json
from pathlib import Path
import unittest
from unittest.mock import Mock, call, patch


spec = importlib.util.spec_from_file_location("failure_drill", Path(__file__).with_name("failure-drill.py"))
drill = importlib.util.module_from_spec(spec)
spec.loader.exec_module(drill)


class FailureDrillBoundaryTest(unittest.TestCase):
    def test_invalid_project_or_origin_is_rejected_before_docker_or_output(self):
        invalid = [
            ["--project", "../another-project"],
            ["--project", "WrongProject"],
            ["--project", "x" * 64],
            ["--base-url", "http://192.0.2.1:18080"],
            ["--base-url", "http://user:password@127.0.0.1:18080"],
            ["--base-url", "http://127.0.0.1:18080/other"],
            ["--base-url", "http://127.0.0.1:18080?token=private"],
            ["--base-url", "http://127.0.0.1:18080#fragment"],
            ["--base-url", "http://localhost:18080"],
            ["--base-url", "http://127.0.0.1:65536"],
        ]
        for arguments in invalid:
            with self.subTest(arguments=arguments), patch.object(drill.subprocess, "run") as docker, \
                    patch.object(drill.demo, "output_directory") as output, \
                    patch.object(drill, "live_drill") as exercise, redirect_stderr(io.StringIO()):
                with self.assertRaises(SystemExit) as error:
                    drill.main(arguments)
                self.assertEqual(error.exception.code, 2)
                docker.assert_not_called()
                output.assert_not_called()
                exercise.assert_not_called()

    def test_explicit_local_project_and_origin_are_preserved_and_normalized(self):
        self.assertEqual(drill.project_name("tpp-ci-123-2"), "tpp-ci-123-2")
        self.assertEqual(drill.numeric_origin("http://127.0.0.1:18080/"), "http://127.0.0.1:18080")

    def test_missing_or_foreign_owner_stops_before_any_docker_command(self):
        stack = drill.OwnedStack("tpp-test-drill", "http://127.0.0.1:18080", Mock(), Mock())
        owners = [None,
                  {"project": "another-project", "workingDirectory": str(drill.ROOT)},
                  {"project": "tpp-test-drill", "workingDirectory": "/another/checkout"}]
        for owner in owners:
            with self.subTest(owner=owner), patch.object(drill.demo, "read_owner", return_value=owner), \
                    patch.object(stack, "run") as docker, \
                    patch.object(drill.subprocess, "run") as subprocess:
                with self.assertRaises(drill.DrillError):
                    stack.preflight()
                docker.assert_not_called()
                subprocess.assert_not_called()

    def test_exercise_exception_restores_only_the_same_captured_stack(self):
        stack = Mock(spec_set=["stop_broker", "restore_broker"])
        with self.assertRaisesRegex(RuntimeError, "exercise failed"):
            with drill.broker_outage(stack) as restore:
                self.assertIs(restore, stack.restore_broker)
                raise RuntimeError("exercise failed")
        self.assertEqual(stack.mock_calls, [call.stop_broker(), call.restore_broker()])

    def test_uncertain_stop_or_interrupt_still_attempts_captured_broker_restoration(self):
        for failure in (TimeoutError("stop result unknown"), KeyboardInterrupt()):
            with self.subTest(failure=type(failure).__name__):
                stack = Mock(spec_set=["stop_broker", "restore_broker"])
                stack.stop_broker.side_effect = failure
                entered = False
                with self.assertRaises(type(failure)):
                    with drill.broker_outage(stack):
                        entered = True
                self.assertFalse(entered)
                self.assertEqual(stack.mock_calls, [call.stop_broker(), call.restore_broker()])

    def test_explicit_restore_callback_does_not_remove_finally_recovery(self):
        stack = Mock(spec_set=["stop_broker", "restore_broker"])
        with self.assertRaisesRegex(RuntimeError, "later failure"):
            with drill.broker_outage(stack) as restore:
                restore()
                raise RuntimeError("later failure")
        self.assertEqual(stack.mock_calls,
                         [call.stop_broker(), call.restore_broker(), call.restore_broker()])

    def test_restore_uses_captured_container_id_without_service_rediscovery(self):
        stack = drill.OwnedStack("tpp-test-drill", "http://127.0.0.1:18080", Mock(), Mock())
        stack.kafka = "a" * 64
        for running in ("false", "true"):
            with self.subTest(running=running), patch.object(stack, "inspect", return_value=running) as inspect, \
                    patch.object(stack, "run") as command, patch.object(stack, "service") as discovery:
                stack.restore_broker()
                inspect.assert_called_once_with(stack.kafka, "{{.State.Running}}")
                discovery.assert_not_called()
                if running == "false":
                    command.assert_called_once_with(["docker", "start", stack.kafka])
                else:
                    command.assert_not_called()

    def test_owned_browser_unroutes_and_closes_every_context_before_browser_exit(self):
        browser = Mock(spec_set=["contexts", "close"])
        first = Mock(spec_set=["unroute_all", "close"])
        second = Mock(spec_set=["unroute_all", "close"])
        browser.contexts = [first, second]
        operations = Mock()
        operations.attach_mock(first, "first")
        operations.attach_mock(second, "second")
        operations.attach_mock(browser, "browser")

        drill.close_owned_browser(browser)

        self.assertEqual(operations.mock_calls, [
            call.first.unroute_all(behavior="ignoreErrors"), call.first.close(),
            call.second.unroute_all(behavior="ignoreErrors"), call.second.close(),
            call.browser.close(),
        ])

    def test_owned_browser_exit_is_attempted_when_context_cleanup_fails(self):
        for failing_operation in ("unroute_all", "close"):
            with self.subTest(failing_operation=failing_operation):
                browser = Mock(spec_set=["contexts", "close"])
                context = Mock(spec_set=["unroute_all", "close"])
                browser.contexts = [context]
                failure = RuntimeError("context cleanup failed")
                getattr(context, failing_operation).side_effect = failure
                operations = Mock()
                operations.attach_mock(context, "context")
                operations.attach_mock(browser, "browser")

                with self.assertRaises(RuntimeError) as error:
                    drill.close_owned_browser(browser)

                self.assertIs(error.exception, failure)
                expected = [call.context.unroute_all(behavior="ignoreErrors")]
                if failing_operation == "close":
                    expected.append(call.context.close())
                expected.append(call.browser.close())
                self.assertEqual(operations.mock_calls, expected)

    def test_presenter_allowlist_keeps_evidence_and_omits_private_inputs(self):
        transfer_id = "10000000-0000-4000-8000-000000000001"
        event_id = "20000000-0000-4000-8000-000000000001"
        details = {
            "transferId": transfer_id, "eventId": event_id, "httpStatus": 201, "replayHttpStatus": 200,
            "sourceDelta": -7, "destinationDelta": 7, "ledgerConsistent": True,
            "appRestarted": False, "deliveryState": "PROJECTED", "publicationStatus": "PUBLISHED",
            "projectionState": "PROJECTED", "postingIds": ["9007199254740993", "9007199254740994"],
            "idempotencyKey": "PRIVATE_SENTINEL_KEY", "endpoint": "http://PRIVATE_SENTINEL_HOST",
            "password": "PRIVATE_SENTINEL_PASSWORD", "dbUrl": "jdbc:PRIVATE_SENTINEL_DB",
            "receipt": {"payload": "PRIVATE_SENTINEL_RECEIPT"},
            "exception": {"message": "PRIVATE_SENTINEL_EXCEPTION"}, "payload": "PRIVATE_SENTINEL_PAYLOAD",
            "outboxCount": {"secret": "PRIVATE_SENTINEL_OBJECT"},
        }
        result = drill.public_details(details)
        self.assertEqual(result, {key: details[key] for key in (
            "transferId", "eventId", "httpStatus", "replayHttpStatus", "sourceDelta", "destinationDelta",
            "ledgerConsistent", "appRestarted", "deliveryState", "publicationStatus", "projectionState", "postingIds")})
        self.assertNotIn("PRIVATE_SENTINEL", json.dumps(result))
        result["postingIds"].append("3")
        self.assertEqual(len(details["postingIds"]), 2)
        self.assertEqual(drill.public_details({"httpStatus": True, "deliveryState": "PRIVATE_SENTINEL",
                                              "transferId": "PRIVATE_SENTINEL", "postingIds": [1, 2]}), {})


if __name__ == "__main__":
    unittest.main()
