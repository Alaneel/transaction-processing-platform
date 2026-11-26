#!/usr/bin/env python3
"""Temporary real-app check: lose one committed response, then resume immutable intent.

Requires seeded demo accounts and enabled Kafka workers. Does not start Docker,
create accounts, seed data, or modify source. It commits exactly one fresh
7-FIC transfer if the CLI honors its documented no-automatic-retry contract.
"""

import argparse
import datetime
import hashlib
import http.client
from http.server import BaseHTTPRequestHandler, HTTPServer
import ipaddress
import json
import os
from pathlib import Path
import socket
import stat
import subprocess
import sys
import tempfile
import threading
import time
from urllib.parse import urlsplit
import uuid


SOURCE = "00000000-0000-0000-0000-000000000002"
DESTINATION = "00000000-0000-0000-0000-000000000003"
PAYLOAD = {"sourceAccountId": SOURCE, "destinationAccountId": DESTINATION,
           "amount": 7, "unit": "FIC"}
MAX_BODY = 65536


def utc_now():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def local_origin(value):
    parsed = urlsplit(value)
    try:
        address = ipaddress.ip_address(parsed.hostname or "")
        port = parsed.port
    except ValueError as failure:
        raise ValueError("base URL must have a numeric loopback host and valid port") from failure
    if (parsed.scheme != "http" or not address.is_loopback or address.version != 4
            or not port or parsed.username or parsed.password
            or parsed.path not in ("", "/") or parsed.query or parsed.fragment):
        raise ValueError("base URL must be http://127.x.x.x:PORT with no credentials or path")
    return parsed.hostname, port


def run_check(args):
    host, port = local_origin(args.base_url)
    cli = args.cli.resolve(strict=True)
    if not cli.is_file():
        raise ValueError("CLI path must identify an existing regular Python file")
    work = Path(tempfile.mkdtemp(prefix="tpp-transfer-cli-live-")).resolve()
    receipt = work / "intent.json"
    report = {"startedAt": utc_now(), "baseUrl": args.base_url, "cli": str(cli),
              "cliSha256": hashlib.sha256(cli.read_bytes()).hexdigest(),
              "workDirectory": str(work), "receiptPath": str(receipt),
              "scope": "One fresh 7-FIC transfer and same-key resume; HTTP observations only",
              "relayObservations": [], "clientProcesses": [], "checks": {}, "complete": False}
    deadline = time.monotonic() + 90
    state = {"receiptBytes": None, "result": None, "failure": None}

    def remaining(cap=5):
        value = deadline - time.monotonic()
        if value <= 0:
            raise RuntimeError("live check exceeded its 90-second overall deadline")
        return min(cap, value)

    def request(method, path, payload=None, headers=None):
        connection = http.client.HTTPConnection(host, port, timeout=remaining())
        try:
            connection.request(method, path, body=payload, headers=headers or {})
            response = connection.getresponse()
            body = response.read(MAX_BODY + 1)
            if len(body) > MAX_BODY:
                raise RuntimeError("application response exceeded the bounded inspection size")
            return response.status, {name.lower(): value for name, value in response.getheaders()}, json.loads(body)
        finally:
            connection.close()

    def get(path):
        status, _, body = request("GET", path)
        if status != 200 or not isinstance(body, dict):
            raise RuntimeError(f"read-only inspection failed: {path}, HTTP {status}")
        return body

    def read_intent():
        info = receipt.lstat()
        if (not stat.S_ISREG(info.st_mode) or stat.S_IMODE(info.st_mode) != 0o600
                or info.st_nlink != 1 or info.st_size > MAX_BODY):
            raise RuntimeError("intent must be one bounded private regular file, mode0600")
        raw = receipt.read_bytes()
        intent = json.loads(raw)
        if (intent.get("version") != 1 or intent.get("payload") != PAYLOAD
                or intent.get("endpoint") != report["relayUrl"]):
            raise RuntimeError("persisted intent differs from the requested immutable transfer")
        return raw, intent

    class Relay(BaseHTTPRequestHandler):
        protocol_version = "HTTP/1.1"

        def setup(self):
            super().setup()
            self.connection.settimeout(5)

        def log_message(self, *_args):
            pass

        def do_POST(self):
            try:
                ordinal = len(report["relayObservations"]) + 1
                if self.path != "/api/transfers" or ordinal > 2 or self.headers.get("Transfer-Encoding"):
                    raise RuntimeError("unexpected relay request or automatic retry")
                length = int(self.headers.get("Content-Length", "0"))
                if not 1 <= length <= MAX_BODY:
                    raise RuntimeError("invalid bounded relay request body")
                body = self.rfile.read(length)
                if len(body) != length or json.loads(body) != PAYLOAD:
                    raise RuntimeError("relay observed a changed transfer payload")
                raw, intent = read_intent()
                key = self.headers.get("Idempotency-Key")
                if not key or key != intent.get("idempotencyKey"):
                    raise RuntimeError("request did not use the already-persisted idempotency key")
                if state["receiptBytes"] is None:
                    state["receiptBytes"] = raw
                elif raw != state["receiptBytes"]:
                    raise RuntimeError("receipt bytes changed before resume")
                status, headers, result = request("POST", "/api/transfers", body,
                    {"Content-Type": "application/json", "Idempotency-Key": key})
                observation = {"ordinal": ordinal, "observedAt": utc_now(),
                               "idempotencyKey": key, "payload": json.loads(body),
                               "backendHttpStatus": status, "backendResult": result,
                               "idempotencyReplayed": headers.get("idempotency-replayed"),
                               "privateIntentExistedBeforeForwarding": True}
                report["relayObservations"].append(observation)
                if ordinal == 1:
                    if status != 201 or not isinstance(result, dict) or result.get("status") != "COMPLETED":
                        raise RuntimeError("first forwarded request did not commit one new transfer")
                    uuid.UUID(result["id"])
                    state["result"] = result
                    observation["clientResponse"] = "deliberately dropped after full backend response"
                    self.close_connection = True
                    self.connection.shutdown(socket.SHUT_RDWR)
                    self.connection.close()
                    return
                if status != 200 or result != state["result"]:
                    raise RuntimeError("resume did not return HTTP200 with the exact original result")
                response = json.dumps(result).encode()
                self.send_response(status)
                self.send_header("Content-Type", "application/json")
                self.send_header("Content-Length", str(len(response)))
                self.send_header("Connection", "close")
                self.end_headers()
                self.wfile.write(response)
                self.close_connection = True
                observation["clientResponse"] = "forwarded exact original result"
            except Exception as failure:
                state["failure"] = {"type": type(failure).__name__, "message": str(failure)}
                self.close_connection = True
                try:
                    self.send_error(502, "live-check relay failed")
                except OSError:
                    pass

    def run_client(arguments, expected_code, expected_state):
        command = [sys.executable, str(cli), *arguments]
        value = subprocess.run(command, capture_output=True, text=True,
                               timeout=remaining(20), env=dict(os.environ, PYTHONDONTWRITEBYTECODE="1"))
        observed = {"command": command, "finishedAt": utc_now(), "exitCode": value.returncode,
                    "stdout": value.stdout[:MAX_BODY], "stderr": value.stderr[:MAX_BODY]}
        report["clientProcesses"].append(observed)
        if len(value.stdout) > MAX_BODY or len(value.stderr) > MAX_BODY:
            raise RuntimeError("client output exceeded the inspection bound")
        parsed = json.loads(value.stdout)
        observed["parsed"] = parsed
        if value.returncode != expected_code or parsed.get("state") != expected_state:
            raise RuntimeError("CLI exit code/state did not match the expected lost-response/resume outcome")
        if state["failure"]:
            raise RuntimeError(f"relay failed: {state['failure']}")
        return parsed

    def matching_page(account, collection, transfer_id):
        after = 0
        matches = []
        for _ in range(20):
            page = get(f"/api/accounts/{account}/{collection}?after={after}&limit=100")
            field, cursor = ("items", "nextCursor") if collection == "ledger" else ("entries", "nextAfter")
            matches.extend(row for row in page[field] if row.get("transferId") == transfer_id)
            following = page.get(cursor)
            if following is None:
                return matches
            if not isinstance(following, int) or following <= after:
                raise RuntimeError("inspection pagination did not advance")
            after = following
        raise RuntimeError("seeded account history exceeded the bounded 2,000-row scan")

    server = HTTPServer(("127.0.0.1", 0), Relay)
    report["relayUrl"] = f"http://127.0.0.1:{server.server_port}"
    thread = threading.Thread(target=server.serve_forever, kwargs={"poll_interval": 0.05}, daemon=True)
    thread.start()
    try:
        report["readiness"] = get("/actuator/health/readiness")
        if report["readiness"].get("status") != "UP":
            raise RuntimeError("application readiness is not UP")
        initial = {account: get(f"/api/accounts/{account}/balance") for account in (SOURCE, DESTINATION)}
        if initial[SOURCE].get("amount", 0) < 7:
            raise RuntimeError("seeded source has insufficient fictional FIC")
        first = run_client(["transfer", "--endpoint", report["relayUrl"], "--source", SOURCE,
                            "--destination", DESTINATION, "--amount", "7", "--receipt", str(receipt),
                            "--timeout", "2"], 3, "UNKNOWN")
        if first.get("httpStatus") is not None:
            raise RuntimeError("lost-response client incorrectly claimed a known HTTP status")
        if len(report["relayObservations"]) != 1:
            raise RuntimeError("first process made more than one POST attempt")
        raw, intent = read_intent()
        report["persistedIntent"] = intent
        report["checks"]["PrivateImmutableIntentExistedBeforeFirstPost"] = raw == state["receiptBytes"]
        second = run_client(["resume", "--receipt", str(receipt), "--timeout", "2"], 0, "COMPLETED")
        if len(report["relayObservations"]) != 2 or receipt.read_bytes() != raw:
            raise RuntimeError("resume changed intent or made an unexpected number of requests")
        if second.get("httpStatus") != 200 or second.get("result") != state["result"]:
            raise RuntimeError("CLI completed output differs from the captured original result")
        report["checks"]["NewProcessResumedSameKeyPayloadAndOriginalResult"] = True
        transfer_id = state["result"]["id"]
        report["transferId"] = transfer_id
        report["ledger"] = {account: matching_page(account, "ledger", transfer_id)
                            for account in (SOURCE, DESTINATION)}
        for account, delta in ((SOURCE, -7), (DESTINATION, 7)):
            rows = report["ledger"][account]
            if len(rows) != 1 or rows[0].get("delta") != delta:
                raise RuntimeError("transfer does not have exactly one correct ledger entry per account")
        report["checks"]["ExactlyTwoBalancedLedgerEntries"] = True
        while True:
            activity = {account: matching_page(account, "activity", transfer_id)
                        for account in (SOURCE, DESTINATION)}
            if any(len(rows) > 1 for rows in activity.values()):
                raise RuntimeError("duplicate account activity effect")
            if all(activity.values()):
                break
            time.sleep(min(0.2, remaining()))
        source, destination = activity[SOURCE][0], activity[DESTINATION][0]
        if (source.get("deltaMinor") != -7 or destination.get("deltaMinor") != 7
                or source.get("unit") != "FIC" or destination.get("unit") != "FIC"
                or source.get("eventId") != destination.get("eventId")):
            raise RuntimeError("activity pair has incorrect amounts or logical event identity")
        report["activity"] = activity
        report["eventId"] = source["eventId"]
        report["checks"]["ExactlyOnePairedKafkaActivityEffect"] = True
        final = {account: get(f"/api/accounts/{account}/balance") for account in (SOURCE, DESTINATION)}
        report["balances"] = {"before": initial, "after": final}
        if (final[SOURCE]["amount"] - initial[SOURCE]["amount"] != -7
                or final[DESTINATION]["amount"] - initial[DESTINATION]["amount"] != 7):
            raise RuntimeError("balances do not reflect exactly one 7-FIC transfer; seeded accounts must be idle")
        report["ledgerReconciliation"] = get("/internal/reconciliation")
        report["projectionReconciliation"] = get("/internal/events/reconciliation")
        if (report["ledgerReconciliation"].get("consistent") is not True
                or report["projectionReconciliation"].get("discrepancies") != 0
                or report["projectionReconciliation"].get("missingProjection") != 0):
            raise RuntimeError("final ledger/projection reconciliation did not pass")
        report["checks"]["SingleBalanceEffectAndCleanReconciliation"] = True
        report["complete"] = all(report["checks"].values())
    except Exception as failure:
        report["failure"] = {"type": type(failure).__name__, "message": str(failure)}
    finally:
        server.shutdown()
        server.server_close()
        thread.join(2)
        report["relayFailure"] = state["failure"]
        report["finishedAt"] = utc_now()
        (work / "report.json").write_text(json.dumps(report, indent=2) + "\n")
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--base-url", required=True)
    parser.add_argument("--cli", type=Path, required=True)
    args = parser.parse_args()
    try:
        report = run_check(args)
    except Exception as failure:
        report = {"complete": False, "failure": {"type": type(failure).__name__, "message": str(failure)}}
    print(json.dumps(report, indent=2))
    return 0 if report["complete"] else 1


if __name__ == "__main__":
    sys.exit(main())
