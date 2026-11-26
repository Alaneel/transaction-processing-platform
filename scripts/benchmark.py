#!/usr/bin/env python3
"""Closed-loop real HTTP benchmark; SQL funding is explicit, isolated, and double-entry.

Only Python's standard library is required. PostgreSQL inspection/funding additionally
uses either local psql (--db-dsn) or the project's database container (--compose-db).
The generated fixture never deletes data or resets an existing account's balance.
"""

from __future__ import annotations

import argparse
import concurrent.futures
import collections
import datetime as dt
import http.client
from http.client import HTTPException
import json
import math
import os
from pathlib import Path
import platform
import re
import socket
import subprocess
import sys
import threading
import time
from urllib.parse import urlsplit
import uuid


METRICS = (
    "transfer.requests", "transfer.transaction", "transfer.outcomes", "transfer.retries",
    "database.errors", "hikaricp.connections.active", "hikaricp.connections.idle",
    "hikaricp.connections.pending", "hikaricp.connections.max", "http.server.requests",
)
POOL_METRICS = METRICS[5:9]
MAX_AMOUNT = 9_000_000_000_000_000


class Http:
    """One persistent connection per worker; no automatic retry of ambiguous responses."""

    def __init__(self, base_url: str, timeout: float):
        parts = urlsplit(base_url)
        if parts.scheme not in ("http", "https") or not parts.hostname or parts.query or parts.fragment:
            raise ValueError("base URL must be an http(s) origin with an optional path prefix")
        if parts.username or parts.password:
            raise ValueError("credentials in the base URL are unsupported")
        self.prefix = parts.path.rstrip("/")
        constructor = http.client.HTTPSConnection if parts.scheme == "https" else http.client.HTTPConnection
        self.connection = constructor(parts.hostname, parts.port, timeout=timeout)

    def request(self, method: str, path: str, payload=None, headers=None):
        body = None if payload is None else json.dumps(payload, separators=(",", ":"))
        request_headers = {"Accept": "application/json", **(headers or {})}
        if body is not None:
            request_headers["Content-Type"] = "application/json"
        attempts = 2 if method == "GET" else 1
        for attempt in range(attempts):
            try:
                self.connection.request(method, self.prefix + path, body, request_headers)
                response = self.connection.getresponse()
                raw = response.read()
                try:
                    result = json.loads(raw)
                except (json.JSONDecodeError, UnicodeDecodeError):
                    result = None
                return response.status, result
            except (OSError, HTTPException):
                self.connection.close()
                # Read-only inspection may reconnect once when the server expired an idle socket.
                # Transfer POSTs are never retried automatically: their commit may be ambiguous.
                if attempt + 1 == attempts:
                    raise

    def close(self):
        self.connection.close()


class Database:
    def __init__(self, args):
        if args.compose_db:
            self.command = ["docker", "compose"]
            if args.compose_project:
                self.command += ["--project-name", args.compose_project]
            self.command += ["exec", "-T", "db", "psql", "-U", "tpp", "-d", "tpp"]
        elif args.db_dsn:
            self.command = ["psql", "--dbname", args.db_dsn]
        else:
            self.command = None
        self.command_timeout = args.db_command_timeout
        self.runtime_user = args.runtime_db_user

    def query(self, sql: str):
        if self.command is None:
            raise ValueError("database access requires --compose-db or --db-dsn")
        result = subprocess.run(
            self.command + ["-X", "-q", "-t", "-A", "--set", "ON_ERROR_STOP=1"],
            input=sql, text=True, capture_output=True, timeout=self.command_timeout, check=False,
        )
        if result.returncode:
            # Avoid recording DSNs, environment variables, or potentially secret stderr.
            raise RuntimeError(f"PostgreSQL command failed with exit code {result.returncode}")
        return result.stdout.strip()

    def metadata(self):
        return json.loads(self.query("""
SELECT json_build_object('version', version(), 'server_version', current_setting('server_version'),
 'max_connections', current_setting('max_connections'),
 'shared_buffers', current_setting('shared_buffers'),
 'transaction_isolation', current_setting('transaction_isolation'));
"""))

    def locks(self):
        return json.loads(self.query(f"""
SELECT json_build_object(
 'active_sessions', count(*) FILTER (WHERE state = 'active'),
 'lock_waiting_sessions', count(*) FILTER (WHERE wait_event_type = 'Lock'),
 'blocked_sessions', count(*) FILTER (WHERE cardinality(pg_blocking_pids(pid)) > 0),
 'longest_lock_wait_seconds', coalesce(max(extract(epoch FROM (clock_timestamp() - query_start)))
       FILTER (WHERE wait_event_type = 'Lock'), 0),
 'ungranted_locks', (SELECT count(*) FROM pg_locks l JOIN pg_stat_activity a USING (pid)
       WHERE NOT l.granted AND a.datname = current_database() AND a.usename = '{self.runtime_user}'))
FROM pg_stat_activity
WHERE datname = current_database() AND pid <> pg_backend_pid() AND usename = '{self.runtime_user}';
"""))


def fixture(workers: int, funding: int, fund_destinations: bool = False, high_uuid_order=None):
    if high_uuid_order not in (None, "all-destinations-before-source"):
        raise ValueError("unsupported high-contention UUID order")
    namespace = uuid.uuid4()

    def account(name):
        return str(uuid.uuid5(namespace, name))

    low = [[account(f"low-source-{i}"), account(f"low-destination-{i}")] for i in range(workers)]
    high_source = account("high-source")
    high = [[high_source, account(f"high-destination-{i}")] for i in range(workers)]
    if high_uuid_order:
        # PostgreSQL UUID ordering compares bytes. Preserve the fresh namespace-derived
        # lower 124 bits, UUID version and variant; only normalize the leading nibble.
        def ordered_uuid(identity, prefix):
            return str(uuid.UUID(int=(uuid.UUID(identity).int & ((1 << 124) - 1)) | (prefix << 124)))

        high_source = ordered_uuid(high_source, 15)
        high = [[high_source, ordered_uuid(pair[1], 0)] for pair in high]
    issuance = account("issuance")
    manifest = {
        "version": 1, "namespace": str(namespace), "created_at": utc_now(),
        "workers": workers, "funding_per_source": funding, "issuance_account": issuance,
        "low": low, "high": high, "account_count": 3 * workers + 2,
    }
    if high_uuid_order:
        manifest["high_uuid_order"] = high_uuid_order
        manifest["high_destinations_sorting_before_source"] = sum(
            uuid.UUID(destination).int < uuid.UUID(source).int for source, destination in high)
    users = sorted({identity for pair in low + high for identity in pair})
    all_ids = sorted(users + [issuance])
    sources = [pair[0] for pair in low] + [high_source]
    if fund_destinations:
        # Open-loop arrivals may reorder or shed either direction; both sides need a reserve.
        sources += [pair[1] for pair in low]
        manifest["funded_low_destinations"] = True
    manifest["funding_transfer_count"] = len(sources)
    sql = [
        "-- Isolated benchmark fixture. Run using the migration owner on a development database.",
        "-- Reusing this fixture intentionally fails instead of mutating prior financial history.",
        "BEGIN;", "INSERT INTO accounts (id, kind, status, unit) VALUES",
        ",\n".join(f"('{identity}', '{'ISSUANCE' if identity == issuance else 'USER'}', 'ACTIVE', 'FIC')"
                   for identity in all_ids) + ";",
        "INSERT INTO balances (account_id, amount) VALUES",
        ",\n".join(f"('{identity}', 0)" for identity in all_ids) + ";",
        "SELECT account_id FROM balances WHERE account_id IN (" + ",".join(f"'{i}'" for i in all_ids)
        + ") ORDER BY account_id FOR UPDATE;",
    ]
    for i, destination in enumerate(sources):
        transfer_id = str(uuid.uuid5(namespace, f"funding-{i}"))
        key = f"benchmark-funding-{namespace}-{i}"
        sql.extend([
            "INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) "
            f"VALUES ('{transfer_id}', '{key}', '{issuance}', '{destination}', {funding}, 'FIC', 'PROCESSING');",
            f"UPDATE balances SET amount = amount - {funding} WHERE account_id = '{issuance}';",
            f"UPDATE balances SET amount = amount + {funding} WHERE account_id = '{destination}';",
            "INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES "
            f"('{transfer_id}', '{issuance}', {-funding}), ('{transfer_id}', '{destination}', {funding});",
            "UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP "
            f"WHERE id = '{transfer_id}';",
        ])
    sql.append("COMMIT;")
    return manifest, "\n".join(sql) + "\n"


def utc_now():
    return dt.datetime.now(dt.timezone.utc).isoformat()


def percentile(sorted_values, quantile):
    if not sorted_values:
        return None
    return sorted_values[max(0, math.ceil(quantile * len(sorted_values)) - 1)]


def latency_summary(values):
    ordered = sorted(values)
    return {
        "count": len(ordered), "p50": percentile(ordered, 0.50),
        "p95": percentile(ordered, 0.95), "p99": percentile(ordered, 0.99),
        "mean": sum(ordered) / len(ordered) if ordered else None,
        "max": ordered[-1] if ordered else None,
    }


def metric_values(http, names):
    values, unavailable = {}, []
    for name in names:
        try:
            status, body = http.request("GET", "/actuator/metrics/" + name)
            if status == 200 and isinstance(body, dict):
                values[name] = {measurement["statistic"]: measurement["value"]
                                for measurement in body.get("measurements", [])}
            else:
                unavailable.append(name)
        except (OSError, HTTPException):
            unavailable.append(name)
    return {"values": values, "unavailable": unavailable}


def metric_delta(before, after):
    deltas = {}
    for name, new in after["values"].items():
        old = before["values"].get(name, {})
        delta = {stat: value - old.get(stat, 0) for stat, value in new.items()
                 if stat in ("COUNT", "TOTAL", "TOTAL_TIME")}
        if "COUNT" in delta and "TOTAL_TIME" in delta:
            delta["MEAN_MS"] = 1000 * delta["TOTAL_TIME"] / delta["COUNT"] if delta["COUNT"] else None
        if delta:
            deltas[name] = delta
    return deltas


def reconciliation(http):
    status, body = http.request("GET", "/internal/reconciliation")
    if status != 200 or not isinstance(body, dict) or body.get("consistent") is not True:
        raise RuntimeError("Reconciliation did not pass; refusing to report a valid workload")
    return body


class Sampler:
    def __init__(self, args, database):
        self.args, self.database = args, database
        self.stop = threading.Event()
        self.samples = []
        self.failures = collections.Counter()
        self.thread = threading.Thread(target=self.run, daemon=True)

    def run(self):
        http = Http(self.args.base_url, self.args.timeout)
        started = time.perf_counter()
        try:
            while not self.stop.is_set():
                sample = {"elapsed_seconds": time.perf_counter() - started}
                sample["pool"] = metric_values(http, POOL_METRICS)
                if self.database.command:
                    try:
                        sample["postgres"] = self.database.locks()
                    except (RuntimeError, OSError, ValueError, subprocess.TimeoutExpired) as error:
                        self.failures[type(error).__name__] += 1
                self.samples.append(sample)
                self.stop.wait(self.args.sample_interval)
        finally:
            http.close()

    def start(self):
        self.thread.start()

    def finish(self):
        self.stop.set()
        self.thread.join(min(self.args.db_command_timeout + 8 * self.args.timeout + 2, 60))
        if self.thread.is_alive():
            self.failures["sampler_shutdown_timeout"] += 1
        samples = list(self.samples)
        locks = [sample["postgres"] for sample in samples if "postgres" in sample]
        pool = {}
        for metric in POOL_METRICS:
            observed = [sample["pool"]["values"][metric]["VALUE"] for sample in samples
                        if "VALUE" in sample["pool"]["values"].get(metric, {})]
            pool[metric] = {"max": max(observed), "mean": sum(observed) / len(observed)} if observed else None
        utilization = []
        for sample in samples:
            gauges = sample["pool"]["values"]
            active = gauges.get("hikaricp.connections.active", {}).get("VALUE")
            maximum = gauges.get("hikaricp.connections.max", {}).get("VALUE")
            if active is not None and maximum:
                utilization.append(active / maximum)
        pool["active_fraction_of_max"] = {
            "max": max(utilization), "mean": sum(utilization) / len(utilization)
        } if utilization else None
        return {
            "sample_count": len(samples), "requested_interval_seconds": self.args.sample_interval,
            "pool": pool,
            "postgres_lock_observations": {
                "sample_count": len(locks),
                "samples_with_lock_waits": sum(sample["lock_waiting_sessions"] > 0 for sample in locks),
                "max_lock_waiting_sessions": max((sample["lock_waiting_sessions"] for sample in locks), default=None),
                "max_blocked_sessions": max((sample["blocked_sessions"] for sample in locks), default=None),
                "max_observed_lock_wait_seconds": max((sample["longest_lock_wait_seconds"] for sample in locks), default=None),
            },
            "sampling_errors": dict(self.failures), "samples": samples,
        }


def workload(args, manifest, scenario, duration, phase):
    ready = threading.Barrier(args.workers + 1)
    deadline = [0.0]
    request_namespace = uuid.uuid4()

    def worker(index):
        http = Http(args.base_url, args.timeout)
        pair = manifest[scenario][index]
        responses = collections.Counter()
        errors = collections.Counter()
        latencies, successful_latencies = [], []
        offered = successful = replied = 0
        ready.wait()
        try:
            while time.perf_counter() < deadline[0]:
                # Independent pairs alternate direction; high contention has one shared source.
                source, destination = pair if scenario == "high" or offered % 2 == 0 else pair[::-1]
                payload = {"sourceAccountId": source, "destinationAccountId": destination, "amount": 1, "unit": "FIC"}
                key = f"benchmark-{request_namespace}-{index}-{offered}"
                offered += 1
                started = time.perf_counter()
                try:
                    status, body = http.request("POST", "/api/transfers", payload,
                                                {"Idempotency-Key": key, "X-Correlation-ID": key})
                    elapsed = (time.perf_counter() - started) * 1000
                    replied += 1
                    responses[str(status)] += 1
                    if status in (200, 201) and isinstance(body, dict) and body.get("status") == "COMPLETED":
                        successful += 1
                        successful_latencies.append(elapsed)
                    else:
                        code = body.get("code") or body.get("rejectionCode") or "unclassified" if isinstance(body, dict) else "non_json_response"
                        errors[f"HTTP_{status}:{code}"] += 1
                except (OSError, HTTPException, ValueError) as error:
                    elapsed = (time.perf_counter() - started) * 1000
                    errors[f"client:{type(error).__name__}"] += 1
                latencies.append(elapsed)
        finally:
            http.close()
        return offered, replied, successful, responses, errors, latencies, successful_latencies

    with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as executor:
        futures = [executor.submit(worker, index) for index in range(args.workers)]
        started = time.perf_counter()
        deadline[0] = started + duration
        ready.wait()
        results = [future.result() for future in futures]
        elapsed = time.perf_counter() - started
    responses, errors = collections.Counter(), collections.Counter()
    all_latencies, successful_latencies = [], []
    for result in results:
        responses.update(result[3])
        errors.update(result[4])
        all_latencies.extend(result[5])
        successful_latencies.extend(result[6])
    offered, replied, successful = (sum(result[index] for result in results) for index in range(3))
    return {
        "scenario": scenario, "phase": phase, "workers": args.workers,
        "requested_duration_seconds": duration, "elapsed_including_drain_seconds": elapsed,
        "offered_requests": offered, "received_http_responses": replied,
        "completed_transfers": successful, "ambiguous_client_errors": offered - replied,
        "offered_requests_per_second": offered / elapsed,
        "completed_transfers_per_second": successful / elapsed,
        "http_status_distribution": dict(responses), "error_distribution": dict(errors),
        "request_latency_ms": latency_summary(all_latencies),
        "completed_transfer_latency_ms": latency_summary(successful_latencies),
    }


def arguments():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--base-url", default="http://127.0.0.1:8080")
    parser.add_argument("--scenario", choices=("low", "high", "both"), default="both")
    parser.add_argument("--workers", type=int, default=8)
    parser.add_argument("--duration", type=float, default=10, help="measured seconds per scenario, excluding warmup")
    parser.add_argument("--warmup", type=float, default=3, help="warmup seconds per scenario")
    parser.add_argument("--timeout", type=float, default=5, help="HTTP response timeout in seconds")
    parser.add_argument("--sample-interval", type=float, default=0.5)
    parser.add_argument("--db-command-timeout", type=float, default=5)
    parser.add_argument("--runtime-db-user", default="tpp_app", help="runtime database role to inspect for lock waits")
    db = parser.add_mutually_exclusive_group()
    db.add_argument("--db-dsn", help="psql connection URI; prefer PGPASSWORD/PGPASSFILE instead of embedding passwords")
    db.add_argument("--compose-db", action="store_true", help="use docker compose exec db psql as the fixture owner")
    parser.add_argument("--compose-project", help="Compose project name used with --compose-db")
    parser.add_argument("--prepare", action="store_true", help="provision a fresh isolated dataset through explicit owner SQL")
    parser.add_argument("--prepare-only", action="store_true", help="provision and save the dataset without sending transfers")
    parser.add_argument("--dataset", type=Path, help="previously prepared dataset manifest; account funds must still be sufficient")
    parser.add_argument("--funding", type=int, default=1_000_000_000, help="fictional minor units per source in a new fixture")
    parser.add_argument("--output", type=Path, help="JSON result path; fixture SQL and dataset manifest are saved alongside")
    parser.add_argument("--environment-notes", default="", help="record app version/configuration, Docker allocation, and other relevant context")
    args = parser.parse_args()
    if not 1 <= args.workers <= 256:
        parser.error("workers must be between 1 and 256")
    if not 0 < args.duration <= 300 or not 0 <= args.warmup <= 120:
        parser.error("duration must be in (0,300], warmup in [0,120]")
    if not 0 < args.timeout <= 60 or not 0 < args.db_command_timeout <= 60 or not 0.1 <= args.sample_interval <= 60:
        parser.error("timeouts must be in (0,60], sample interval in [0.1,60]")
    if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]{0,62}", args.runtime_db_user):
        parser.error("runtime database user must be a simple PostgreSQL role name")
    if args.compose_project and (not args.compose_db or not re.fullmatch(r"[a-z0-9][a-z0-9_-]*", args.compose_project)):
        parser.error("--compose-project needs --compose-db and a valid Compose project name")
    if not 1 <= args.funding <= MAX_AMOUNT // (args.workers + 1):
        parser.error("funding exceeds the supported total issuance range")
    if args.prepare == bool(args.dataset):
        parser.error("choose exactly one of --prepare and --dataset")
    if args.prepare and not (args.compose_db or args.db_dsn):
        parser.error("--prepare needs explicit owner database access: --compose-db or --db-dsn")
    if args.prepare_only and not args.prepare:
        parser.error("--prepare-only requires --prepare")
    return args


def main():
    args = arguments()
    database = Database(args)
    run_id = str(uuid.uuid4())
    output = args.output or Path("benchmark-results") / f"{dt.datetime.now(dt.timezone.utc):%Y%m%dT%H%M%SZ}-{run_id}.json"
    output.parent.mkdir(parents=True, exist_ok=True)
    if args.prepare:
        manifest, sql = fixture(args.workers, args.funding)
        fixture_path = output.with_suffix(".fixture.sql")
        dataset_path = output.with_suffix(".dataset.json")
        fixture_path.write_text(sql, encoding="utf-8")
        database.query(sql)
        dataset_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    else:
        dataset_path = args.dataset
        manifest = json.loads(dataset_path.read_text(encoding="utf-8"))
        if manifest.get("version") != 1 or manifest.get("workers", 0) < args.workers:
            raise ValueError("dataset format invalid or has fewer pairs than requested workers")
        for scenario in ("low", "high"):
            pairs = manifest.get(scenario)
            if not isinstance(pairs, list) or len(pairs) < args.workers:
                raise ValueError("dataset has fewer account pairs than requested workers")
            for pair in pairs:
                if len(pair) != 2 or pair[0] == pair[1]:
                    raise ValueError("dataset has an invalid account pair")
                for identity in pair:
                    uuid.UUID(identity)
    print(f"Dataset: {dataset_path}", flush=True)
    if args.prepare_only:
        return 0
    metadata = {
        "started_at": utc_now(), "python": platform.python_version(),
        "os": platform.platform(), "architecture": platform.machine(),
        "logical_cpu_count": os.cpu_count(), "hostname": socket.gethostname(),
        "base_url": args.base_url, "environment_notes": args.environment_notes,
        "dataset": manifest, "dataset_path": str(dataset_path), "run_id": run_id,
        "load_model": "closed-loop persistent HTTP: each worker waits for the previous response; no retries",
        "latency_definition": "wall time from HTTP request start to full response/error, nearest-rank percentiles",
        "throughput_definition": "requests or successful transfer responses divided by wall time including final request drain",
        "lock_sampling_note": "periodic snapshots can miss short waits; wait age includes statement execution before blocking",
        "metrics_note": "actuator counters are process-wide; run without unrelated traffic; sampler contributes HTTP metrics",
    }
    if database.command:
        metadata["postgres"] = database.metadata()
    http = Http(args.base_url, args.timeout)
    results = []
    report = {"environment": metadata, "results": results}
    try:
        status, body = http.request("GET", "/actuator/health/readiness")
        if status != 200 or not isinstance(body, dict) or body.get("status") != "UP":
            raise RuntimeError("Application readiness is not UP")
        scenarios = ("low", "high") if args.scenario == "both" else (args.scenario,)
        for scenario in scenarios:
            print(f"Running {scenario}: {args.workers} workers, {args.warmup}s warmup + {args.duration}s measurement", flush=True)
            warmup = workload(args, manifest, scenario, args.warmup, "warmup") if args.warmup else None
            before_reconciliation = reconciliation(http)
            before_metrics = metric_values(http, METRICS)
            sampler = Sampler(args, database)
            sampler.start()
            try:
                result = workload(args, manifest, scenario, args.duration, "measurement")
            finally:
                observations = sampler.finish()
            after_metrics = metric_values(http, METRICS)
            result.update({
                "warmup": warmup, "metrics_before": before_metrics, "metrics_after": after_metrics,
                "metric_deltas": metric_delta(before_metrics, after_metrics), "observations": observations,
                "reconciliation_before": before_reconciliation, "reconciliation_after": reconciliation(http),
            })
            results.append(result)
            output.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
            latency = result["completed_transfer_latency_ms"]
            print(f"{scenario}: {result['completed_transfers_per_second']:.2f} completed/s; "
                  f"offered={result['offered_requests']}, completed={result['completed_transfers']}; "
                  f"p50={latency['p50']}ms p95={latency['p95']}ms p99={latency['p99']}ms; "
                  f"errors={result['error_distribution']}", flush=True)
    finally:
        http.close()
    report["finished_at"] = utc_now()
    output.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"Results: {output}", flush=True)
    return 1 if any(result["error_distribution"] for result in results) else 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (RuntimeError, ValueError, OSError, HTTPException, subprocess.TimeoutExpired) as error:
        print(f"Benchmark failed: {type(error).__name__}: {error}", file=sys.stderr)
        sys.exit(2)
