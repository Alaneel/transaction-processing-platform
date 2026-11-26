#!/usr/bin/env python3
"""Real HTTP transfer, idempotent retry, Kafka-derived paired activity and reconciliation smoke test.

Run scripts/seed-demo.sql once as the schema owner before invoking this bounded check.
"""

import argparse
from http.client import HTTPException
import json
import sys
import time
import uuid

import benchmark


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--base-url", default="http://127.0.0.1:8080")
    parser.add_argument("--deadline", type=float, default=60)
    args = parser.parse_args()
    if not 1 <= args.deadline <= 180:
        parser.error("deadline must be in [1,180] seconds")
    http = benchmark.Http(args.base_url, 5)
    source = "00000000-0000-0000-0000-000000000002"
    destination = "00000000-0000-0000-0000-000000000003"
    key = f"phase2-smoke-{uuid.uuid4()}"
    payload = {"sourceAccountId": source, "destinationAccountId": destination, "amount": 7, "unit": "FIC"}
    try:
        status, transfer = http.request("POST", "/api/transfers", payload, {"Idempotency-Key": key})
        if status != 201 or not isinstance(transfer, dict) or transfer.get("status") != "COMPLETED":
            raise RuntimeError("smoke transfer failed to complete")
        status, repeated = http.request("POST", "/api/transfers", payload, {"Idempotency-Key": key})
        if status != 200 or repeated != transfer:
            raise RuntimeError("same-key transfer did not return its durable original result")
        transfer_id = transfer["id"]
        deadline = time.perf_counter() + args.deadline
        observed = {}
        while time.perf_counter() < deadline:
            for account, expected_delta in ((source, -7), (destination, 7)):
                after = 0
                matches = []
                # Development smoke fixtures stay small; cap paging to avoid an unbounded scan.
                for _ in range(10):
                    status, page = http.request("GET", f"/api/accounts/{account}/activity?after={after}&limit=100")
                    if status != 200 or not isinstance(page, dict):
                        raise RuntimeError("activity projection endpoint unavailable")
                    entries = page.get("entries", [])
                    matches += [entry for entry in entries if entry.get("transferId") == transfer_id]
                    if len(entries) < 100 or page.get("nextAfter") is None:
                        break
                    after = page["nextAfter"]
                if len(matches) > 1:
                    raise RuntimeError("duplicate account projection effect")
                if matches:
                    if matches[0].get("deltaMinor") != expected_delta or matches[0].get("unit") != "FIC":
                        raise RuntimeError("activity projection has an incorrect amount or unit")
                    observed[account] = matches[0]
            if len(observed) == 2:
                break
            time.sleep(0.2)
        if len(observed) != 2:
            raise RuntimeError("Kafka-derived paired activity did not arrive before the deadline")
        if observed[source]["eventId"] != observed[destination]["eventId"]:
            raise RuntimeError("paired activity does not share one logical event identity")
        authoritative = benchmark.reconciliation(http)
        status, projection = http.request("GET", "/internal/events/reconciliation")
        if status != 200 or not isinstance(projection, dict) or projection.get("discrepancies") != 0:
            raise RuntimeError("projection reconciliation did not pass")
        print(json.dumps({"transferId": transfer_id, "eventId": observed[source]["eventId"],
              "idempotentRetry": "prior result", "pairedActivity": observed,
              "authoritativeReconciliation": authoritative, "projectionReconciliation": projection}, indent=2))
    finally:
        http.close()


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, OSError, ValueError, HTTPException) as error:
        print(f"Event smoke failed: {type(error).__name__}: {error}", file=sys.stderr)
        sys.exit(1)
