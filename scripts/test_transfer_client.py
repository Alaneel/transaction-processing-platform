#!/usr/bin/env python3
"""Real loopback HTTP/subprocess client tests; these do not model PostgreSQL/Kafka durability."""

import hashlib
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
import os
from pathlib import Path
import socket
import subprocess
import sys
import tempfile
import threading
import time
import unittest
import uuid


CLIENT = Path(__file__).with_name("transfer-client.py")
SOURCE = "00000000-0000-0000-0000-000000000002"
DESTINATION = "00000000-0000-0000-0000-000000000003"
TRANSFER = "20000000-0000-4000-8000-000000000001"
EVENT = "30000000-0000-4000-8000-000000000001"


class TransferClientTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.directory = Path(self.temporary.name).resolve()
        self.directory.chmod(0o700)
        self.receipt = self.directory / "intents" / "first.json"
        self.records = {}
        self.requests = []
        self.gets = []
        self.effects = 0
        self.mode = "normal"
        self.delivery = {
            "transferId": TRANSFER, "transferStatus": "COMPLETED", "decidedAt": "2026-11-23T00:00:00Z",
            "deliveryState": "AWAITING_PUBLICATION", "event": {
                "eventId": EVENT, "publicationStatus": "PENDING", "attemptCount": 0,
                "nextAttemptAt": "2026-11-23T00:00:00Z", "lastErrorCode": None,
                "publishedAt": None, "processedAt": None, "projectedAt": None}}
        self.committed = threading.Event()
        outer = self

        class Handler(BaseHTTPRequestHandler):
            def log_message(self, *_):
                pass

            def do_GET(self):
                outer.gets.append(self.path)
                if outer.mode == "delivery-missing":
                    return self.reply(404, {"code": "TRANSFER_NOT_FOUND"})
                if outer.mode == "delivery-error":
                    return self.reply(503, {"code": "DEPENDENCY_UNAVAILABLE"})
                if outer.mode == "delivery-slow":
                    time.sleep(1)
                if outer.mode == "delivery-redirect":
                    self.send_response(307)
                    self.send_header("Location", "http://127.0.0.1:1/foreign")
                    self.send_header("Content-Length", "0")
                    self.end_headers()
                    return
                return self.reply(200, outer.delivery)

            def do_POST(self):
                payload = json.loads(self.rfile.read(int(self.headers["Content-Length"])))
                key = self.headers["Idempotency-Key"]
                outer.requests.append((key, payload))
                call = len(outer.requests)
                if outer.mode == "503" and call == 1:
                    return self.reply(503, {"code": "DEPENDENCY_UNAVAILABLE"})
                if outer.mode == "conflict":
                    return self.reply(409, {"code": "IDEMPOTENCY_CONFLICT"})
                if outer.mode == "redirect":
                    self.send_response(307)
                    self.send_header("Location", "http://127.0.0.1:1/foreign")
                    self.send_header("Content-Length", "0")
                    self.end_headers()
                    return
                if key in outer.records:
                    result = outer.records[key]
                    if any(result[k] != value for k, value in payload.items()):
                        return self.reply(409, {"code": "IDEMPOTENCY_CONFLICT"})
                    status = 422 if result["status"] == "REJECTED" else 200
                else:
                    rejected = outer.mode == "rejected"
                    result = dict(payload, id=str(uuid.uuid4()), status="REJECTED" if rejected else "COMPLETED",
                                  rejectionCode="INSUFFICIENT_FUNDS" if rejected else None,
                                  createdAt="2026-11-23T00:00:00Z",
                                  completedAt=None if rejected else "2026-11-23T00:00:00Z")
                    outer.records[key] = result
                    outer.effects += not rejected
                    status = 422 if rejected else 201
                outer.committed.set()
                if outer.mode == "drop" and call == 1:
                    self.connection.shutdown(socket.SHUT_RDWR)
                    self.connection.close()
                    return
                if outer.mode == "stall" and call == 1:
                    time.sleep(1)
                if outer.mode == "slow_headers" and call == 1:
                    try:
                        for value in b"HTTP/1.1 201 Created\r\n":
                            self.connection.send(bytes([value]))
                            time.sleep(0.08)
                    except OSError:
                        pass
                    return
                self.reply(status, result)

            def reply(self, status, body):
                raw = json.dumps(body).encode()
                try:
                    self.send_response(status)
                    self.send_header("Content-Type", "application/json")
                    self.send_header("Content-Length", str(len(raw)))
                    self.end_headers()
                    self.wfile.write(raw)
                except (BrokenPipeError, ConnectionResetError):
                    pass

        self.server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
        self.thread = threading.Thread(target=self.server.serve_forever, daemon=True)
        self.thread.start()
        self.endpoint = f"http://127.0.0.1:{self.server.server_port}"

    def tearDown(self):
        self.server.shutdown()
        self.server.server_close()
        self.thread.join(2)
        self.temporary.cleanup()

    def command(self, operation="transfer", *extra):
        args = [sys.executable, str(CLIENT), operation, "--receipt", str(self.receipt)]
        if operation == "transfer":
            args += ["--endpoint", self.endpoint, "--source", SOURCE, "--destination", DESTINATION, "--amount", "7"]
        return args + list(extra)

    def run_client(self, operation="transfer", *extra):
        return subprocess.run(self.command(operation, *extra), text=True, capture_output=True, timeout=5)

    def run_status(self, *extra):
        command = [sys.executable, str(CLIENT), "status", "--endpoint", self.endpoint,
                   "--transfer-id", TRANSFER, *extra]
        return subprocess.run(command, text=True, capture_output=True, timeout=5)

    def test_status_reads_pending_then_projected_without_submitting_or_creating_receipt(self):
        pending = self.run_status()
        self.assertEqual(pending.returncode, 0, pending.stderr)
        self.assertEqual(json.loads(pending.stdout)["result"]["deliveryState"], "AWAITING_PUBLICATION")
        self.delivery["deliveryState"] = "PROJECTED"
        self.delivery["event"].update(publicationStatus="PUBLISHED", attemptCount=1,
                                      publishedAt="2026-11-23T00:00:01Z",
                                      processedAt="2026-11-23T00:00:02Z", projectedAt="2026-11-23T00:00:02Z")
        projected = self.run_status()
        self.assertEqual(projected.returncode, 0, projected.stderr)
        observed = json.loads(projected.stdout)
        self.assertEqual(observed["command"], "status")
        self.assertEqual(observed["state"], "OBSERVED")
        self.assertEqual(observed["result"]["transferStatus"], "COMPLETED")
        self.assertEqual(observed["result"]["deliveryState"], "PROJECTED")
        self.assertEqual(self.gets, [f"/internal/transfers/{TRANSFER}/delivery"] * 2)
        self.assertEqual(self.requests, [])
        self.assertFalse(self.receipt.parent.exists())

    def test_status_displays_rejection_and_additional_delivery_states_without_rewriting_intent(self):
        self.assertEqual(self.run_client().returncode, 0)
        before = self.receipt.read_bytes()
        for state, publication in [("AWAITING_PROJECTION", "PUBLISHED"), ("BLOCKED", "BLOCKED"),
                                   ("INCONSISTENT", "PUBLISHED")]:
            with self.subTest(state=state):
                self.delivery["deliveryState"] = state
                self.delivery["event"]["publicationStatus"] = publication
                result = self.run_status()
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(json.loads(result.stdout)["result"]["deliveryState"], state)
        self.delivery.update(transferStatus="REJECTED", deliveryState="NOT_APPLICABLE", event=None)
        result = self.run_status()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIsNone(json.loads(result.stdout)["result"]["event"])
        self.assertEqual(self.receipt.read_bytes(), before)
        self.assertEqual(len(self.requests), 1)

    def test_status_unknown_transfer_is_not_found_without_creating_an_intent(self):
        self.mode = "delivery-missing"
        result = self.run_status()
        self.assertEqual(result.returncode, 4, result.stderr)
        self.assertEqual(json.loads(result.stdout)["state"], "NOT_FOUND")
        self.assertEqual(len(self.gets), 1)
        self.assertEqual(self.requests, [])
        self.assertFalse(self.receipt.parent.exists())

    def test_status_rejects_mismatched_or_malformed_success_and_omits_unknown_fields(self):
        self.delivery["unrecognizedSensitiveField"] = "must-not-print"
        result = self.run_status()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn("must-not-print", result.stdout)
        for field, value in [("transferId", str(uuid.uuid4())), ("decidedAt", "not-a-date"),
                             ("deliveryState", "NEW_UNKNOWN_STATE")]:
            with self.subTest(field=field):
                previous = self.delivery[field]
                self.delivery[field] = value
                result = self.run_status()
                self.delivery[field] = previous
                self.assertEqual(result.returncode, 3, result.stderr)
                self.assertEqual(json.loads(result.stdout)["state"], "UNAVAILABLE")
        self.assertEqual(self.requests, [])
        self.assertFalse(self.receipt.parent.exists())

    def test_status_timeout_and_dependency_failure_never_submit_a_transfer(self):
        for mode in ("delivery-slow", "delivery-error"):
            with self.subTest(mode=mode):
                self.mode = mode
                started = time.monotonic()
                result = self.run_status("--timeout", "0.2")
                self.assertEqual(result.returncode, 3, result.stderr)
                self.assertEqual(json.loads(result.stdout)["state"], "UNAVAILABLE")
                self.assertLess(time.monotonic() - started, 1.5)
        self.assertEqual(self.requests, [])
        self.assertFalse(self.receipt.parent.exists())

    def test_status_redirect_is_not_followed_or_retried(self):
        self.mode = "delivery-redirect"
        result = self.run_status()
        self.assertEqual(result.returncode, 4, result.stderr)
        self.assertEqual(json.loads(result.stdout)["state"], "UNAVAILABLE")
        self.assertEqual(len(self.gets), 1)
        self.assertEqual(self.requests, [])

    def test_status_invalid_input_is_refused_before_network_or_receipt_access(self):
        for args in [("--transfer-id", "invalid"), ("--endpoint", "http://192.0.2.1:8080"),
                     ("--endpoint", "http://user:password@127.0.0.1:8080")]:
            with self.subTest(args=args):
                result = self.run_status(*args)
                self.assertEqual(result.returncode, 2, result.stderr)
        self.assertEqual(self.gets, [])
        self.assertEqual(self.requests, [])
        self.assertFalse(self.receipt.parent.exists())

    def test_lost_response_then_fresh_process_recovers_one_effect_and_immutable_intent(self):
        self.mode = "drop"
        first = self.run_client()
        self.assertEqual(first.returncode, 3, first.stderr)
        self.assertEqual(json.loads(first.stdout)["state"], "UNKNOWN")
        before = self.receipt.read_bytes()
        saved = json.loads(before)
        self.assertEqual(self.receipt.stat().st_mode & 0o777, 0o600)
        self.assertEqual(self.receipt.parent.stat().st_mode & 0o777, 0o700)
        second = self.run_client("resume")
        self.assertEqual(second.returncode, 0, second.stderr)
        result = json.loads(second.stdout)
        self.assertEqual(result["httpStatus"], 200)
        self.assertEqual(result["result"]["id"], self.records[saved["idempotencyKey"]]["id"])
        self.assertEqual(self.effects, 1)
        self.assertEqual(self.requests[0], self.requests[1])
        self.assertEqual(self.receipt.read_bytes(), before)
        self.assertEqual(list(self.receipt.parent.iterdir()), [self.receipt])

    def test_terminated_client_after_server_commit_can_resume(self):
        self.mode = "stall"
        process = subprocess.Popen(self.command(), text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        try:
            self.assertTrue(self.committed.wait(2))
            process.terminate()
            process.communicate(timeout=2)
        finally:
            if process.poll() is None:
                process.kill()
                process.communicate()
        before = self.receipt.read_bytes()
        recovered = self.run_client("resume")
        self.assertEqual(recovered.returncode, 0, recovered.stderr)
        self.assertEqual(json.loads(recovered.stdout)["httpStatus"], 200)
        self.assertEqual(self.effects, 1)
        self.assertEqual(self.receipt.read_bytes(), before)

    def test_absolute_deadline_bounds_slow_headers_and_keeps_resume_possible(self):
        self.mode = "slow_headers"
        started = time.monotonic()
        first = self.run_client("transfer", "--timeout", "0.2")
        self.assertEqual(first.returncode, 3, first.stderr)
        self.assertLess(time.monotonic() - started, 1.5)
        second = self.run_client("resume")
        self.assertEqual(second.returncode, 0, second.stderr)
        self.assertEqual(self.effects, 1)

    def test_durable_rejection_replays_same_rejected_result(self):
        self.mode = "rejected"
        first, second = self.run_client(), self.run_client("resume")
        self.assertEqual((first.returncode, second.returncode), (1, 1))
        self.assertEqual(json.loads(first.stdout)["result"], json.loads(second.stdout)["result"])
        self.assertEqual(self.effects, 0)

    def test_dependency_failure_preserves_intent_for_one_later_effect(self):
        self.mode = "503"
        first = self.run_client()
        self.assertEqual(first.returncode, 3, first.stderr)
        before = self.receipt.read_bytes()
        self.assertEqual(self.effects, 0)
        second = self.run_client("resume")
        self.assertEqual(second.returncode, 0, second.stderr)
        self.assertEqual(json.loads(second.stdout)["httpStatus"], 201)
        self.assertEqual(self.effects, 1)
        self.assertEqual(self.receipt.read_bytes(), before)

    def test_conflict_is_explicit_and_never_rewrites_intent(self):
        self.mode = "conflict"
        first = self.run_client()
        self.assertEqual(first.returncode, 4, first.stderr)
        self.assertEqual(json.loads(first.stdout)["state"], "CONFLICT")
        before = self.receipt.read_bytes()
        second = self.run_client("resume")
        self.assertEqual(second.returncode, 4, second.stderr)
        self.assertEqual(self.effects, 0)
        self.assertEqual(self.receipt.read_bytes(), before)

    def test_existing_receipt_write_failure_sends_no_request(self):
        self.receipt.parent.mkdir(mode=0o700)
        self.receipt.write_text("existing unrelated content")
        self.receipt.chmod(0o600)
        result = self.run_client()
        self.assertEqual(result.returncode, 2, result.stderr)
        self.assertEqual(self.requests, [])
        self.assertEqual(self.receipt.read_text(), "existing unrelated content")

    def test_linked_parent_or_leaf_is_refused_before_network(self):
        actual = self.directory / "actual"
        actual.mkdir(mode=0o700)
        self.receipt.parent.symlink_to(actual, target_is_directory=True)
        result = self.run_client()
        self.assertEqual(result.returncode, 2, result.stderr)
        self.assertEqual(self.requests, [])
        self.assertEqual(list(actual.iterdir()), [])
        self.receipt.parent.unlink()
        self.receipt.parent.mkdir(mode=0o700)
        victim = actual / "victim"
        victim.write_text("unchanged")
        self.receipt.symlink_to(victim)
        result = self.run_client("resume")
        self.assertEqual(result.returncode, 2, result.stderr)
        self.assertEqual(self.requests, [])
        self.assertEqual(victim.read_text(), "unchanged")

    def test_modified_or_nonprivate_receipt_is_refused_before_retry(self):
        self.assertEqual(self.run_client().returncode, 0)
        original = self.receipt.read_bytes()
        receipt = json.loads(original)
        receipt["payload"]["amount"] = 8
        self.receipt.write_text(json.dumps(receipt))
        result = self.run_client("resume")
        self.assertEqual(result.returncode, 2, result.stderr)
        self.assertEqual(len(self.requests), 1)
        self.receipt.write_bytes(original)
        self.receipt.chmod(0o644)
        result = self.run_client("resume")
        self.assertEqual(result.returncode, 2, result.stderr)
        self.assertEqual(len(self.requests), 1)

    def test_redirect_is_not_followed_and_unsafe_endpoint_is_refused(self):
        self.mode = "redirect"
        result = self.run_client()
        self.assertEqual(result.returncode, 4, result.stderr)
        self.assertEqual(len(self.requests), 1)
        for endpoint in ["http://192.0.2.1:8080", "http://user:password@127.0.0.1:8080",
                         self.endpoint + "/other", self.endpoint + "?token=secret"]:
            with self.subTest(endpoint=endpoint):
                self.receipt.unlink()
                result = self.run_client("transfer", "--endpoint", endpoint)
                self.assertEqual(result.returncode, 2, result.stderr)
                self.assertFalse(self.receipt.exists())
                self.assertEqual(len(self.requests), 1)
                # Keep a sentinel for the next iteration; it must never be touched by validation.
                self.receipt.write_text("sentinel")
                self.receipt.chmod(0o600)


if __name__ == "__main__":
    unittest.main()
