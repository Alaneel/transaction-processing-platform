#!/usr/bin/env python3
"""Bounded HTTP/event benchmark against a named, independently started development stack.

Only Python's standard library and docker/psql are needed. This script creates fresh
double-entry fixtures, reads PostgreSQL/Kafka evidence, and sends real HTTP requests.
It never stops containers, changes event settings, deletes data, or resets balances.
Use named Compose projects and externally change settings for matched/backlog trials.
"""

from __future__ import annotations

import argparse
import bisect
import collections
import copy
import concurrent.futures
import datetime as dt
from http.client import HTTPException
import json
import math
import os
from pathlib import Path
import platform
import re
import subprocess
import sys
import threading
import time
import uuid
from urllib.parse import urlencode

import benchmark


EVENT_METRICS = (
    "events.outbox.publications", "events.outbox.retries", "events.outbox.claim.recoveries",
    "events.outbox.publication.latency", "events.consumer.processing.duration",
    "events.consumer.outcomes", "events.consumer.retries", "events.consumer.lag.max",
    "events.consumer.offset.commit.failures", "events.projection.propagation.duration",
    "events.outbox.claim.records", "events.outbox.claim.batch.size",
    "events.outbox.kafka.enqueue.duration", "events.outbox.kafka.ack.duration",
    "events.outbox.kafka.wait.duration", "events.outbox.batch.duration",
    "events.outbox.producer.create.duration", "events.outbox.poll.pause.duration",
    "events.outbox.settlement.failures", "events.outbox.inflight.records",
    *(f"events.outbox.publications@outcome={outcome}" for outcome in ("success", "transient", "ambiguous", "permanent", "stale")),
    *(f"events.outbox.database.duration@operation={operation}" for operation in ("claim", "renew", "publish", "fail", "renew_batch", "settle")),
    *(f"events.outbox.kafka.acknowledgements@outcome={outcome}" for outcome in ("accepted", "failed")),
    *(f"events.outbox.send.attempts@kind={kind}" for kind in ("first", "retry")),
    "events.consumer.ingestion.records", "events.consumer.paused", "events.consumer.quarantine.records",
    *(f"events.consumer.poll.duration@outcome={outcome}" for outcome in ("empty", "received", "failure")),
    *(f"events.consumer.database.transaction.duration@operation=projection,result={result}" for result in ("committed", "failed")),
    *(f"events.consumer.database.work.duration@operation=projection,result={result}" for result in ("completed", "failed")),
    *(f"events.consumer.database.completion.duration@operation=projection,result={result}" for result in ("committed", "failed")),
    *(f"events.projection.commits@source=kafka,outcome={outcome}" for outcome in ("processed", "duplicate")),
    *(f"events.consumer.offset.acknowledgement.duration@outcome={outcome}" for outcome in ("success", "failure")),
    *(f"events.consumer.pause.duration@reason={reason}" for reason in ("startup_retry", "retry", "optional_delay")),
)
RESOURCE_METRICS = benchmark.POOL_METRICS + ("process.cpu.usage", "jvm.memory.used", "jvm.threads.live",
                                           "events.outbox.inflight.records")


class Histogram:
    """Fixed 530 logarithmic buckets; quantiles are bucket upper bounds, never a reservoir."""

    BOUNDS = [0.01 * 1.03 ** n for n in range(530)]

    def __init__(self):
        self.buckets = [0] * (len(self.BOUNDS) + 1)
        self.count = 0
        self.total = 0.0
        self.maximum = 0.0

    def add(self, milliseconds):
        self.buckets[bisect.bisect_left(self.BOUNDS, milliseconds)] += 1
        self.count += 1
        self.total += milliseconds
        self.maximum = max(self.maximum, milliseconds)

    def merge(self, other):
        for n, value in enumerate(other.buckets):
            self.buckets[n] += value
        self.count += other.count
        self.total += other.total
        self.maximum = max(self.maximum, other.maximum)

    def quantile(self, fraction):
        if not self.count:
            return None
        target = math.ceil(fraction * self.count)
        accumulated = 0
        for n, count in enumerate(self.buckets):
            accumulated += count
            if accumulated >= target:
                return self.BOUNDS[n] if n < len(self.BOUNDS) else self.maximum

    def summary(self):
        return {"count": self.count, "mean": self.total / self.count if self.count else None,
                "max": self.maximum, "p50_upper_bound": self.quantile(0.50),
                "p95_upper_bound": self.quantile(0.95), "p99_upper_bound": self.quantile(0.99),
                "quantile_note": "fixed logarithmic histogram, <=3% bin-width error above 0.01ms"}


class InvariantViolation(RuntimeError):
    pass


class Events:
    def __init__(self, database, manifest):
        self.database = database
        account_ids = sorted({identity for scenario in ("low", "high")
                              for pair in manifest[scenario] for identity in pair})
        for identity in account_ids:
            uuid.UUID(identity)
        self.accounts = ",".join(f"'{identity}'::uuid" for identity in account_ids)

    def query(self):
        return json.loads(self.database.query(f"""
WITH scope AS (SELECT id FROM transfers WHERE source_account_id IN ({self.accounts})
 AND destination_account_id IN ({self.accounts}) AND status='COMPLETED'),
events AS (SELECT o.* FROM outbox_events o JOIN scope s ON s.id=o.transfer_id),
processed AS (SELECT i.*,o.created_at,o.published_at FROM event_inbox i
 JOIN events o ON o.event_id=i.event_id)
SELECT json_build_object(
 'database_time',clock_timestamp(),
 'completed_transfers',(SELECT count(*) FROM scope),
 'outbox_total',(SELECT count(*) FROM events),
 'published',(SELECT count(*) FROM events WHERE status='PUBLISHED'),
 'unpublished',(SELECT count(*) FROM events WHERE status<>'PUBLISHED'),
 'claimed',(SELECT count(*) FROM events WHERE status='CLAIMED'),
 'publication_attempts',(SELECT coalesce(sum(attempt_count),0) FROM events),
 'retried_events',(SELECT count(*) FROM events WHERE attempt_count>1),
 'maximum_attempt_count',(SELECT coalesce(max(attempt_count),0) FROM events),
 'last_error_counts',json_build_object(
   'transient',(SELECT count(*) FROM events WHERE last_error_classification='TRANSIENT'),
   'ambiguous',(SELECT count(*) FROM events WHERE last_error_classification='AMBIGUOUS'),
   'permanent',(SELECT count(*) FROM events WHERE last_error_classification='PERMANENT')),
 'recorded_kafka_positions',(SELECT count(DISTINCT (kafka_topic,kafka_partition,kafka_offset))
    FROM events WHERE status='PUBLISHED'),
 'oldest_unpublished_age_seconds',(SELECT coalesce(extract(epoch FROM
   clock_timestamp()-min(created_at)),0) FROM events WHERE status<>'PUBLISHED'),
 'processed',(SELECT count(*) FROM processed),
 'projection_rows',(SELECT count(*) FROM transfer_activity_projection p JOIN scope s ON s.id=p.transfer_id),
 'account_activity_rows',(SELECT count(*) FROM account_activity p JOIN scope s ON s.id=p.transfer_id),
 'published_unprocessed',(SELECT count(*) FROM events o WHERE status='PUBLISHED'
   AND NOT EXISTS(SELECT 1 FROM event_inbox i WHERE i.event_id=o.event_id)),
 'missing_outbox',(SELECT count(*) FROM scope s WHERE NOT EXISTS
   (SELECT 1 FROM outbox_events o WHERE o.transfer_id=s.id)),
 'publication_latency_ms',(SELECT json_build_object('count',count(*),
   'p50',percentile_cont(0.50) WITHIN GROUP(ORDER BY extract(epoch FROM published_at-created_at)*1000),
   'p95',percentile_cont(0.95) WITHIN GROUP(ORDER BY extract(epoch FROM published_at-created_at)*1000),
   'p99',percentile_cont(0.99) WITHIN GROUP(ORDER BY extract(epoch FROM published_at-created_at)*1000),
   'mean',avg(extract(epoch FROM published_at-created_at)*1000),
   'max',max(extract(epoch FROM published_at-created_at)*1000)) FROM events WHERE published_at IS NOT NULL),
 'propagation_latency_ms',(SELECT json_build_object('count',count(*),
   'p50',percentile_cont(0.50) WITHIN GROUP(ORDER BY extract(epoch FROM processed_at-created_at)*1000),
   'p95',percentile_cont(0.95) WITHIN GROUP(ORDER BY extract(epoch FROM processed_at-created_at)*1000),
   'p99',percentile_cont(0.99) WITHIN GROUP(ORDER BY extract(epoch FROM processed_at-created_at)*1000),
   'mean',avg(extract(epoch FROM processed_at-created_at)*1000),
   'max',max(extract(epoch FROM processed_at-created_at)*1000)) FROM processed));
"""))


def error_key(status, body):
    """Keep bounded application error classifications without retaining arbitrary response text."""
    code = (body.get("code") or body.get("rejectionCode")) if isinstance(body, dict) else None
    if isinstance(code, str) and re.fullmatch(r"[A-Z_]{1,64}", code):
        return f"HTTP_{status}:{code}"
    return f"HTTP_{status}"


def metric_spec(spec):
    pieces = spec.split("@")
    if len(pieces) > 2 or not re.fullmatch(r"[a-zA-Z0-9_.-]{1,100}", pieces[0]):
        raise ValueError("invalid metric name")
    tags = []
    if len(pieces) == 2:
        for tag in pieces[1].split(","):
            pair = tag.split("=")
            if len(pair) != 2 or any(not re.fullmatch(r"[a-zA-Z0-9_.-]{1,64}", item) for item in pair):
                raise ValueError("invalid metric filter")
            tags.append(tuple(pair))
        if len(tags) > 3 or len({key for key, _ in tags}) != len(tags):
            raise ValueError("metric filters require at most three distinct tags")
    return pieces[0], tags


def metric_snapshot(http, specifications):
    """Filter stages independently; retain every actuator measurement including rolling MAX."""
    values, unavailable = {}, []
    for specification in specifications:
        name, tags = metric_spec(specification)
        suffix = "?" + urlencode([("tag", f"{key}:{value}") for key, value in tags]) if tags else ""
        try:
            status, body = http.request("GET", "/actuator/metrics/" + name + suffix)
            if status == 200 and isinstance(body, dict):
                values[specification] = {m["statistic"]: m["value"] for m in body.get("measurements", [])}
            else:
                unavailable.append(specification)
        except (OSError, HTTPException):
            unavailable.append(specification)
    return {"values": values, "unavailable": unavailable,
            "max_note": "MAX is a rolling actuator snapshot, not an additive counter or an exact interval percentile"}


def load(args, manifest, phase, duration):
    if phase == "warmup" and args.warmup_arrival_rate is not None:
        args = copy.copy(args)
        args.arrival_rate = args.warmup_arrival_rate
    if args.arrival_rate is not None:
        return fixed_arrival_load(args, manifest, phase, duration)
    return closed_loop_load(args, manifest, phase, duration)


def closed_loop_load(args, manifest, phase, duration):
    ready = threading.Barrier(args.workers + 1)
    deadline = [0.0]
    namespace = uuid.uuid4()

    def worker(index):
        http = benchmark.Http(args.base_url, args.timeout)
        pair = manifest[args.scenario][index]
        offered = responses = completed = 0
        codes, errors = collections.Counter(), collections.Counter()
        latency, successful_latency = Histogram(), Histogram()
        ready.wait()
        try:
            while time.perf_counter() < deadline[0]:
                source, destination = pair if args.scenario == "high" or offered % 2 == 0 else pair[::-1]
                key = f"event-bench-{namespace}-{index}-{offered}"
                offered += 1
                started = time.perf_counter()
                try:
                    status, body = http.request("POST", "/api/transfers",
                        {"sourceAccountId": source, "destinationAccountId": destination, "amount": 1, "unit": "FIC"},
                        {"Idempotency-Key": key, "X-Correlation-ID": key})
                    elapsed = (time.perf_counter() - started) * 1000
                    responses += 1
                    codes[str(status)] += 1
                    if status in (200, 201) and isinstance(body, dict) and body.get("status") == "COMPLETED":
                        completed += 1
                        successful_latency.add(elapsed)
                    else:
                        errors[error_key(status, body)] += 1
                except (OSError, HTTPException, ValueError) as error:
                    elapsed = (time.perf_counter() - started) * 1000
                    errors[f"client:{type(error).__name__}"] += 1
                latency.add(elapsed)
        finally:
            http.close()
        return offered, responses, completed, codes, errors, latency, successful_latency

    with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as executor:
        futures = [executor.submit(worker, n) for n in range(args.workers)]
        started = time.perf_counter()
        deadline[0] = started + duration
        ready.wait()
        results = [future.result() for future in futures]
        elapsed = time.perf_counter() - started
    codes, errors = collections.Counter(), collections.Counter()
    latency, successful = Histogram(), Histogram()
    for result in results:
        codes.update(result[3])
        errors.update(result[4])
        latency.merge(result[5])
        successful.merge(result[6])
    offered, responses, completed = (sum(r[n] for r in results) for n in range(3))
    return {"phase": phase, "scenario": args.scenario, "workers": args.workers,
            "load_model": "closed-loop", "locally_shed_operations": 0,
            "requested_duration_seconds": duration, "elapsed_including_drain_seconds": elapsed,
            "offered_operations": offered, "started_operations": offered,
            "completed_operations": completed, "failed_or_ambiguous_operations": offered - completed,
            "received_responses": responses, "ambiguous_client_errors": offered - responses,
            "completed_transfers_per_second": completed / elapsed,
            "http_status_distribution": dict(codes), "error_distribution": dict(errors),
            "http_latency_ms": latency.summary(), "completed_http_latency_ms": successful.summary()}


def fixed_arrival_load(args, manifest, phase, duration):
    """Pace fixed arrivals, with at most workers outstanding and no growing request queue.

    Missed arrivals remain visible as local shedding instead of silently slowing offered load.
    HTTP latency excludes schedule lag, which has a separate bounded histogram. Workers never
    retry a POST, and executor submission is fenced by a finite permit count.
    """
    namespace = uuid.uuid4()
    permits = threading.BoundedSemaphore(args.workers)
    local = threading.local()
    clients = []
    state_lock = threading.Lock()
    state = {"responses": 0, "completed": 0, "outstanding": 0, "peak_outstanding": 0}
    codes, errors = collections.Counter(), collections.Counter()
    latency, successful_latency, schedule_lag = Histogram(), Histogram(), Histogram()

    def worker(index, scheduled_at):
        try:
            if not hasattr(local, "http"):
                local.http = benchmark.Http(args.base_url, args.timeout)
                with state_lock:
                    clients.append(local.http)
            pair = manifest[args.scenario][index % args.workers]
            source, destination = pair if args.scenario == "high" or (index // args.workers) % 2 == 0 else pair[::-1]
            key = f"event-bench-{namespace}-{index}"
            started = time.perf_counter()
            lag = max(0, started - scheduled_at) * 1000
            completed = False
            response_status = None
            failure = None
            try:
                status, body = local.http.request("POST", "/api/transfers",
                    {"sourceAccountId": source, "destinationAccountId": destination, "amount": 1, "unit": "FIC"},
                    {"Idempotency-Key": key, "X-Correlation-ID": key})
                response_status = status
                completed = status in (200, 201) and isinstance(body, dict) and body.get("status") == "COMPLETED"
                if not completed:
                    failure = error_key(status, body)
            except (OSError, HTTPException, ValueError) as error:
                failure = f"client:{type(error).__name__}"
            elapsed = (time.perf_counter() - started) * 1000
            with state_lock:
                schedule_lag.add(lag)
                latency.add(elapsed)
                if response_status is not None:
                    state["responses"] += 1
                    codes[str(response_status)] += 1
                if completed:
                    state["completed"] += 1
                    successful_latency.add(elapsed)
                if failure:
                    errors[failure] += 1
        except Exception as error:
            # Executor futures are deliberately not retained; surface unexpected worker failures.
            with state_lock:
                errors[f"worker:{type(error).__name__}"] += 1
        finally:
            with state_lock:
                state["outstanding"] -= 1
            permits.release()

    # The finite total controls clock rounding and ensures the same intended input per trial.
    intended = math.ceil(duration * args.arrival_rate)
    admitted = shed = 0
    started = time.perf_counter()
    try:
        with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as executor:
            for index in range(intended):
                scheduled_at = started + index / args.arrival_rate
                wait = scheduled_at - time.perf_counter()
                if wait > 0:
                    time.sleep(wait)
                if not permits.acquire(blocking=False):
                    shed += 1
                    continue
                with state_lock:
                    state["outstanding"] += 1
                    state["peak_outstanding"] = max(state["peak_outstanding"], state["outstanding"])
                admitted += 1
                executor.submit(worker, index, scheduled_at)
            # Preserve the fixed offered interval even if the last response finishes early.
            remaining = started + duration - time.perf_counter()
            if remaining > 0:
                time.sleep(remaining)
            arrival_elapsed = time.perf_counter() - started
        elapsed = time.perf_counter() - started
    finally:
        for client in clients:
            client.close()
    return {"phase": phase, "scenario": args.scenario, "workers": args.workers,
            "load_model": "fixed-arrival", "configured_arrivals_per_second": args.arrival_rate,
            "requested_duration_seconds": duration, "arrival_interval_elapsed_seconds": arrival_elapsed,
            "elapsed_including_drain_seconds": elapsed, "offered_operations": intended,
            "started_operations": admitted, "locally_shed_operations": shed,
            "peak_outstanding_requests": state["peak_outstanding"],
            "completed_operations": state["completed"], "failed_or_ambiguous_operations": admitted - state["completed"],
            "received_responses": state["responses"], "ambiguous_client_errors": admitted - state["responses"],
            "offered_arrivals_per_second": intended / arrival_elapsed,
            "completed_transfers_per_second": state["completed"] / elapsed,
            "completed_per_requested_interval_second": state["completed"] / duration,
            "http_status_distribution": dict(codes), "error_distribution": dict(errors),
            "http_latency_ms": latency.summary(), "completed_http_latency_ms": successful_latency.summary(),
            "schedule_lag_ms": schedule_lag.summary(),
            "local_shedding_note": "scheduled arrivals with no worker permit never reach the server; no unbounded client queue"}


class Sampler:
    def __init__(self, args, database, events):
        self.args, self.database, self.events = args, database, events
        self.samples = []
        self.errors = collections.Counter()
        self.stop = threading.Event()
        self.started = time.perf_counter()
        self.thread = threading.Thread(target=self.run, daemon=True)

    def sample(self, http):
        sample = {"elapsed_seconds": time.perf_counter() - self.started}
        try:
            sample["events"] = self.events.query()
            sample["postgres_locks"] = self.database.locks()
            assert_event_invariants(sample["events"])
        except InvariantViolation as error:
            sample["invariant_failure"] = str(error)
        except (OSError, ValueError, RuntimeError, subprocess.TimeoutExpired) as error:
            self.errors[type(error).__name__] += 1
        sample["consumer_lag"] = benchmark.metric_values(http, ("events.consumer.lag.max",))
        sample["resources"] = benchmark.metric_values(http, RESOURCE_METRICS)
        self.samples.append(sample)
        return sample

    def run(self):
        http = benchmark.Http(self.args.base_url, self.args.timeout)
        try:
            while not self.stop.is_set() and len(self.samples) < 2000:
                self.sample(http)
                self.stop.wait(self.args.sample_interval)
        finally:
            http.close()

    def start(self):
        self.thread.start()

    def finish(self):
        self.stop.set()
        self.thread.join(min(60, self.args.db_command_timeout * 2 + self.args.timeout * 16 + 2))
        if self.thread.is_alive():
            raise RuntimeError("event sampler did not finish within its timeout")
        failures = [sample["invariant_failure"] for sample in self.samples if "invariant_failure" in sample]
        return {"sample_interval_seconds": self.args.sample_interval,
                "sample_limit": 2000, "samples": self.samples, "sampling_errors": dict(self.errors),
                "invariant_failures": failures}


def assert_event_invariants(state):
    if state["missing_outbox"] != 0 or state["outbox_total"] != state["completed_transfers"]:
        raise InvariantViolation("completed-transfer/outbox atomicity failed")
    if state["processed"] != state["projection_rows"] or state["account_activity_rows"] != 2 * state["processed"]:
        raise InvariantViolation("inbox/projection atomicity or deduplication invariant failed")


def status_snapshot(http):
    try:
        code, body = http.request("GET", "/internal/events/status")
        return {"http_status": code, "body": body}
    except (OSError, HTTPException) as error:
        return {"error": type(error).__name__}


def arguments():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--base-url", default="http://127.0.0.1:8080")
    parser.add_argument("--scenario", choices=("low", "high"), default="low")
    parser.add_argument("--high-uuid-order", choices=("all-destinations-before-source",),
                        help="optional controlled shared-source account order; default fixture is unchanged")
    parser.add_argument("--workers", type=int, default=8)
    parser.add_argument("--arrival-rate", type=float,
                        help="fixed scheduled arrivals/second; finite worker capacity sheds excess locally")
    parser.add_argument("--duration", type=float, default=10)
    parser.add_argument("--warmup", type=float, default=3)
    parser.add_argument("--warmup-arrival-rate", type=float,
                        help="separate bounded fixed-arrival warmup, including before closed-loop measurement")
    parser.add_argument("--warmup-drain-timeout", type=float, default=0,
                        help="wait up to this many seconds for warmup events before measuring; 0 preserves backlog")
    parser.add_argument("--timeout", type=float, default=5)
    parser.add_argument("--sample-interval", type=float, default=1)
    parser.add_argument("--db-command-timeout", type=float, default=5)
    parser.add_argument("--runtime-db-user", default="tpp_app")
    db = parser.add_mutually_exclusive_group(required=True)
    db.add_argument("--compose-db", action="store_true")
    db.add_argument("--db-dsn")
    parser.add_argument("--compose-project")
    fixture = parser.add_mutually_exclusive_group(required=True)
    fixture.add_argument("--prepare", action="store_true")
    fixture.add_argument("--dataset", type=Path)
    parser.add_argument("--funding", type=int, default=1_000_000_000)
    parser.add_argument("--label", required=True, help="record externally controlled relay/consumer/broker configuration")
    parser.add_argument("--environment-notes", default="")
    parser.add_argument("--metric", action="append", default=[],
                        help="extra metric, optionally name@tag=value[,tag=value]; up to 32 times")
    parser.add_argument("--observe-only", action="store_true", help="sample a prior dataset without issuing HTTP requests")
    parser.add_argument("--drain-timeout", type=float, default=120, help="0 skips catchup; otherwise wait bounded seconds for all scoped effects")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if not 1 <= args.workers <= 256 or not 0 < args.duration <= 300 or not 0 <= args.warmup <= 120:
        parser.error("workers must be in [1,256], duration in (0,300], warmup in [0,120]")
    if args.arrival_rate is not None and (not math.isfinite(args.arrival_rate) or not 0 < args.arrival_rate <= 10000):
        parser.error("arrival rate must be finite and in (0,10000]")
    if args.warmup_arrival_rate is not None and (not math.isfinite(args.warmup_arrival_rate) or not 0 < args.warmup_arrival_rate <= 10000):
        parser.error("warmup arrival rate must be finite and in (0,10000]")
    if not 0 <= args.warmup_drain_timeout <= 600:
        parser.error("warmup drain timeout must be in [0,600]")
    try:
        for name in args.metric:
            metric_spec(name)
    except ValueError as error:
        parser.error(str(error))
    if len(args.metric) > 32:
        parser.error("at most 32 additional metric specifications are supported")
    if not 0 < args.timeout <= 60 or not 0 < args.db_command_timeout <= 60 or not 0.5 <= args.sample_interval <= 60:
        parser.error("timeouts must be in (0,60], sample interval in [0.5,60]")
    if not 0 <= args.drain_timeout <= 600:
        parser.error("drain timeout must be in [0,600]")
    if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]{0,62}", args.runtime_db_user):
        parser.error("runtime database user must be a simple PostgreSQL role name")
    if args.compose_project and (not args.compose_db or not re.fullmatch(r"[a-z0-9][a-z0-9_-]*", args.compose_project)):
        parser.error("--compose-project requires --compose-db and a valid Compose project name")
    funding_count = 2 * args.workers + 1 if args.arrival_rate is not None or args.warmup_arrival_rate is not None else args.workers + 1
    if not 1 <= args.funding <= benchmark.MAX_AMOUNT // funding_count:
        parser.error("unsupported fixture funding")
    if args.high_uuid_order and args.scenario != "high":
        parser.error("--high-uuid-order requires the high-contention scenario")
    if args.observe_only and args.prepare:
        parser.error("--observe-only requires a prior --dataset")
    return args


def main():
    args = arguments()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    database = benchmark.Database(args)
    if args.prepare:
        manifest, sql = benchmark.fixture(args.workers, args.funding,
                                          fund_destinations=args.arrival_rate is not None or args.warmup_arrival_rate is not None,
                                          high_uuid_order=args.high_uuid_order)
        args.output.with_suffix(".fixture.sql").write_text(sql, encoding="utf-8")
        database.query(sql)
        dataset_path = args.output.with_suffix(".dataset.json")
        dataset_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    else:
        dataset_path = args.dataset
        manifest = json.loads(dataset_path.read_text(encoding="utf-8"))
        if manifest.get("version") != 1 or manifest.get("workers", 0) < args.workers:
            raise ValueError("invalid dataset or insufficient worker pairs")
        for scenario in ("low", "high"):
            pairs = manifest.get(scenario)
            if not isinstance(pairs, list) or len(pairs) < args.workers:
                raise ValueError("dataset has fewer account pairs than requested workers")
            for pair in pairs:
                if not isinstance(pair, list) or len(pair) != 2 or pair[0] == pair[1]:
                    raise ValueError("dataset has an invalid account pair")
                for identity in pair:
                    uuid.UUID(identity)
    if args.high_uuid_order:
        if manifest.get("high_uuid_order") != args.high_uuid_order or any(
                uuid.UUID(destination).int >= uuid.UUID(source).int
                for source, destination in manifest["high"][:args.workers]):
            raise ValueError("dataset does not match the declared high-contention UUID order")
    events = Events(database, manifest)
    http = benchmark.Http(args.base_url, args.timeout)
    measured_metrics = tuple(dict.fromkeys(benchmark.METRICS + EVENT_METRICS + tuple(args.metric)))
    report = {"environment": {"started_at": benchmark.utc_now(), "label": args.label,
              "environment_notes": args.environment_notes, "python": platform.python_version(),
              "os": platform.platform(), "architecture": platform.machine(), "logical_cpu_count": os.cpu_count(),
              "postgres": database.metadata(), "dataset": manifest, "dataset_path": str(dataset_path),
              "load_model": ("fixed-arrival bounded outstanding requests, local shedding, no POST retry"
                             if args.arrival_rate is not None else "closed-loop persistent HTTP, no POST retry, bounded per-worker histograms"),
              "configured_arrivals_per_second": args.arrival_rate,
              "event_latency_definition": "database inbox.processed_at minus outbox.created_at, exact database percentiles; includes backlog wait",
              "publication_latency_definition": "database outbox.published_at minus created_at; may lag Kafka acceptance",
              "scope": "user-to-user transfers between fresh fixture accounts; issuance funding excluded"}}

    def save():
        args.output.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")

    try:
        report["reconciliation_before"] = benchmark.reconciliation(http)
        report["events_before_warmup"] = events.query()
        report["event_status_before"] = status_snapshot(http)
        if not args.observe_only and args.warmup:
            report["warmup"] = load(args, manifest, "warmup", args.warmup)
            if args.warmup_drain_timeout:
                warmup_drain_started = time.perf_counter()
                deadline = warmup_drain_started + args.warmup_drain_timeout
                state = events.query()
                while state["unpublished"] or state["completed_transfers"] != state["processed"]:
                    if time.perf_counter() >= deadline:
                        report["warmup_drain"] = {"complete": False, "last_events": state}
                        save()
                        raise RuntimeError("warmup events did not drain before measurement")
                    time.sleep(args.sample_interval)
                    state = events.query()
                report["warmup_drain"] = {"complete": True, "elapsed_seconds": time.perf_counter() - warmup_drain_started,
                                          "final_events": state}
        report["events_before"] = events.query()
        report["metrics_before"] = metric_snapshot(http, measured_metrics)
        sampler = Sampler(args, database, events)
        sampler.start()
        try:
            if args.observe_only:
                time.sleep(args.duration)
            else:
                report["workload"] = load(args, manifest, "measurement", args.duration)
            report["events_after_workload"] = events.query()
            assert_event_invariants(report["events_after_workload"])
            report["metrics_after"] = metric_snapshot(http, measured_metrics)
            report["metric_deltas"] = benchmark.metric_delta(report["metrics_before"], report["metrics_after"])
            save()
            drain_started = time.perf_counter()
            deadline = drain_started + args.drain_timeout
            # Metric inspection can allow substantial catchup. Take a fresh committed snapshot
            # before counting drain progress instead of attributing that earlier work to this wait.
            drain_initial = events.query()
            latest = drain_initial
            while args.drain_timeout and (latest["unpublished"] or latest["completed_transfers"] != latest["processed"]):
                if time.perf_counter() >= deadline:
                    break
                time.sleep(args.sample_interval)
                latest = events.query()
            elapsed = time.perf_counter() - drain_started
            report["drain"] = {"requested_timeout_seconds": args.drain_timeout, "elapsed_seconds": elapsed,
                "starting_events": drain_initial,
                "complete": latest["unpublished"] == 0 and latest["completed_transfers"] == latest["processed"],
                "published_during_drain": latest["published"] - drain_initial["published"],
                "processed_during_drain": latest["processed"] - drain_initial["processed"],
                "final_events": latest}
            report["metrics_after_drain"] = metric_snapshot(http, measured_metrics)
            report["drain_metric_deltas"] = benchmark.metric_delta(report["metrics_after"], report["metrics_after_drain"])
        finally:
            report["observations"] = sampler.finish()
        report["reconciliation_after"] = benchmark.reconciliation(http)
        report["event_status_after"] = status_snapshot(http)
        assert_event_invariants(report["drain"]["final_events"])
        report["finished_at"] = benchmark.utc_now()
        save()
        before, after = report["events_before"], report["events_after_workload"]
        seconds = (dt.datetime.fromisoformat(after["database_time"])
                   - dt.datetime.fromisoformat(before["database_time"])).total_seconds()
        report["event_rate_observation_interval_seconds"] = seconds
        report["event_rate_note"] = "scoped durable count deltas over database observation times; interval includes measurement setup/inspection"
        report["event_rates_per_second"] = {"creation": (after["outbox_total"] - before["outbox_total"]) / seconds,
            "publication": (after["published"] - before["published"]) / seconds,
            "processing": (after["processed"] - before["processed"]) / seconds}
        drain = report["drain"]
        report["drain_rates_per_second"] = {
            "publication": drain["published_during_drain"] / drain["elapsed_seconds"] if drain["elapsed_seconds"] > 0.001 else None,
            "processing": drain["processed_during_drain"] / drain["elapsed_seconds"] if drain["elapsed_seconds"] > 0.001 else None}
        report["drain_rate_note"] = "only progress after the recorded drain start; excludes recovery before observation"
        save()
        if report["observations"]["invariant_failures"]:
            raise InvariantViolation("an event invariant failed during the measured interval; inspect saved observations")
        print(json.dumps({"output": str(args.output), "label": args.label,
              "workload": report.get("workload"), "rates": report["event_rates_per_second"],
              "drain": report["drain"]}, indent=2), flush=True)
        return 1 if (report.get("workload", {}).get("error_distribution")
                     or (args.drain_timeout > 0 and not report["drain"]["complete"])) else 0
    finally:
        http.close()


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (RuntimeError, ValueError, OSError, HTTPException, subprocess.TimeoutExpired) as error:
        print(f"Event benchmark failed: {type(error).__name__}: {error}", file=sys.stderr)
        sys.exit(2)
