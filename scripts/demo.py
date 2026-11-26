#!/usr/bin/env python3
"""Build an isolated local demo and verify real HTTP, ledger and Kafka effects.

Requires Docker Compose and Python 3. No host Java or Python packages are needed.
The selected project's containers and persistent history are retained on completion.
"""

import argparse
from contextlib import contextmanager
from http.client import HTTPException
import json
import os
from pathlib import Path
import re
import stat
import subprocess
import sys
import time
import uuid
from urllib.parse import urlsplit

import benchmark

ROOT = Path(__file__).resolve().parents[1]


def require_local_docker(run, env):
    """Read context metadata first; never connect to a remote Docker endpoint."""
    def local_unix(host):
        if not isinstance(host, str):
            return False
        value = urlsplit(host)
        return value.scheme == "unix" and not value.netloc and value.path.startswith("/") and not value.query and not value.fragment
    declared_host = env.get("DOCKER_HOST")
    if declared_host and not local_unix(declared_host):
        raise RuntimeError("demo requires a local Unix-socket Docker endpoint; DOCKER_HOST points elsewhere")
    command = ["docker", "context", "inspect"]
    if env.get("DOCKER_CONTEXT"):
        command.append(env["DOCKER_CONTEXT"])
    command += ["--format", "{{json .Endpoints.docker.Host}}"]
    context_host = json.loads(run(command, capture=True))
    if not local_unix(context_host):
        raise RuntimeError("demo requires a local Unix-socket Docker context; select a local context")
    # Pin the resolved endpoint for every later command, even if the ambient context changes.
    env["DOCKER_HOST"] = context_host if env.get("DOCKER_CONTEXT") else declared_host or context_host
    for name in ("DOCKER_CONTEXT", "DOCKER_TLS", "DOCKER_TLS_VERIFY", "DOCKER_CERT_PATH"):
        env.pop(name, None)


def owner_parent(owner_path, create=False):
    """Open the fixed metadata directory without following its last component."""
    if owner_path.is_symlink() or owner_path.parent.is_symlink():
        raise RuntimeError("demo ownership record and parent must not be symlinks")
    if not owner_path.parent.exists():
        if not create:
            return None
        owner_path.parent.mkdir(mode=0o700)
    try:
        return os.open(owner_path.parent, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW)
    except OSError as error:
        raise RuntimeError("demo ownership parent must be a regular local directory") from error


def read_owner_at(directory, name, expected_owner=None, make_private=False):
    try:
        descriptor = os.open(name, os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK, dir_fd=directory)
    except FileNotFoundError:
        return None
    except OSError as error:
        raise RuntimeError("demo ownership record cannot follow a link or special file") from error
    with os.fdopen(descriptor, "r", encoding="utf-8") as record:
        info = os.fstat(record.fileno())
        if not stat.S_ISREG(info.st_mode) or info.st_nlink != 1 or info.st_size > 16384:
            raise RuntimeError("demo ownership record must be a single regular file")
        try:
            owner = json.loads(record.read(16385))
        except (ValueError, UnicodeError) as error:
            raise RuntimeError("demo ownership record is invalid") from error
        if not isinstance(owner, dict):
            raise RuntimeError("demo ownership record is invalid")
        if expected_owner is not None and owner != expected_owner:
            raise RuntimeError("demo ownership record belongs to another checkout or project")
        if make_private:
            os.fchmod(record.fileno(), 0o600)
        return owner


def read_owner(owner_path):
    directory = owner_parent(owner_path)
    if directory is None:
        return None
    try:
        return read_owner_at(directory, owner_path.name)
    finally:
        os.close(directory)


def write_owner(owner_path, owner):
    """Publish a private complete record atomically; never overwrite another record."""
    directory = owner_parent(owner_path, create=True)
    temporary = ".owner-" + uuid.uuid4().hex + ".tmp"
    created = False
    try:
        existing = read_owner_at(directory, owner_path.name, owner, make_private=True)
        if existing is not None:
            return
        descriptor = os.open(temporary, os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW,
                             0o600, dir_fd=directory)
        created = True
        with os.fdopen(descriptor, "w", encoding="utf-8") as record:
            record.write(json.dumps(owner, indent=2) + "\n")
            record.flush()
            os.fsync(record.fileno())
        # Publish the complete inode exclusively; never replace a racing ownership record.
        try:
            os.link(temporary, owner_path.name, src_dir_fd=directory, dst_dir_fd=directory,
                    follow_symlinks=False)
        except FileExistsError as error:
            raise RuntimeError("demo ownership record appeared concurrently; retry after review") from error
    finally:
        if created:
            os.unlink(temporary, dir_fd=directory)
        os.close(directory)


def require_owned_project(run, project, owner_path):
    """Refuse foreign containers or unidentified persistent history before Compose mutation."""
    recorded_owner = read_owner(owner_path)
    owner = {"project": project, "workingDirectory": str(ROOT)}
    if recorded_owner is not None and recorded_owner != owner:
        raise RuntimeError("demo ownership record belongs to another checkout or project")
    ids = run(["docker", "ps", "-a", "--filter", f"label=com.docker.compose.project={project}",
               "--format", "{{.ID}}"], capture=True).split()
    for container_id in ids:
        labels = json.loads(run(["docker", "inspect", "--format", "{{json .Config.Labels}}", container_id], capture=True))
        if labels.get("com.docker.compose.project.working_dir") != str(ROOT):
            raise RuntimeError("selected Compose project belongs to another checkout; choose a different --project")
    volumes = run(["docker", "volume", "ls", "--filter", f"label=com.docker.compose.project={project}",
                   "--format", "{{.Name}}"], capture=True).split()
    if volumes and not ids:
        if recorded_owner != owner:
            raise RuntimeError("existing demo volumes have no ownership record for this checkout; choose another --project")
    return owner


def output_directory(path):
    """Anchor every output-directory component; never traverse a symlink."""
    absolute = path if path.is_absolute() else Path.cwd() / path
    parts = absolute.parts
    directory = os.open(parts[0], os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW)
    try:
        for part in parts[1:]:
            try:
                child = os.open(part, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW, dir_fd=directory)
            except FileNotFoundError:
                os.mkdir(part, mode=0o700, dir_fd=directory)
                child = os.open(part, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW, dir_fd=directory)
            os.close(directory)
            directory = child
        return directory
    except OSError as error:
        os.close(directory)
        raise RuntimeError("demo output directories must be regular directories without symlinks") from error


def regular_output(directory, name, flags):
    try:
        descriptor = os.open(name, flags | os.O_NOFOLLOW | os.O_NONBLOCK, 0o600, dir_fd=directory)
    except FileNotFoundError:
        return None
    except OSError as error:
        raise RuntimeError("demo report/log cannot follow links or special files") from error
    info = os.fstat(descriptor)
    if not stat.S_ISREG(info.st_mode) or info.st_nlink != 1:
        os.close(descriptor)
        raise RuntimeError("demo report/log must be a single regular file")
    return descriptor


def existing_report(directory, name, project):
    descriptor = regular_output(directory, name, os.O_RDONLY)
    if descriptor is None:
        return False
    with os.fdopen(descriptor, "r", encoding="utf-8") as record:
        if os.fstat(record.fileno()).st_size > 1024 * 1024:
            raise RuntimeError("existing demo report is too large")
        try:
            data = json.load(record)
        except (ValueError, UnicodeError) as error:
            raise RuntimeError("existing demo report is invalid; choose a new output") from error
        if not isinstance(data, dict) or data.get("project") != project or not isinstance(data.get("smoke"), dict):
            raise RuntimeError("existing demo report is not from this project; choose a new output")
        return True


@contextmanager
def report_files(output, project):
    """Append a private regular log and atomically publish a same-project JSON report."""
    directory = output_directory(output.parent)
    log_name = output.with_suffix(".log").name
    try:
        if output.name == log_name:
            raise RuntimeError("demo JSON output must differ from its .log companion")
        existing_report(directory, output.name, project)  # Validate before any log append.
        descriptor = regular_output(directory, log_name, os.O_WRONLY | os.O_APPEND | os.O_CREAT)
        with os.fdopen(descriptor, "a", encoding="utf-8") as log:
            os.fchmod(log.fileno(), 0o600)
            def publish(report):
                present = existing_report(directory, output.name, project)
                temporary = ".report-" + uuid.uuid4().hex + ".tmp"
                descriptor = os.open(temporary, os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW,
                                     0o600, dir_fd=directory)
                try:
                    with os.fdopen(descriptor, "w", encoding="utf-8") as result:
                        result.write(json.dumps(report, indent=2) + "\n")
                        result.flush()
                        os.fsync(result.fileno())
                    if present:
                        os.replace(temporary, output.name, src_dir_fd=directory, dst_dir_fd=directory)
                    else:
                        os.link(temporary, output.name, src_dir_fd=directory, dst_dir_fd=directory,
                                follow_symlinks=False)
                finally:
                    try:
                        os.unlink(temporary, dir_fd=directory)
                    except FileNotFoundError:
                        pass
            yield log, publish
    finally:
        os.close(directory)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project", default="tpp-portfolio-demo")
    parser.add_argument("--app-port", type=int, default=38080)
    parser.add_argument("--db-port", type=int, default=55436)
    parser.add_argument("--kafka-port", type=int, default=39092)
    parser.add_argument("--broker-outage", action="store_true",
                        help="stop this demo's broker, commit/replay a transfer, then recover it")
    parser.add_argument("--no-build", action="store_true", help="reuse the selected project's built image")
    parser.add_argument("--stop", action="store_true", help="stop this project's containers; retain all volumes")
    parser.add_argument("--dry-run", action="store_true", help="print the selected commands without changing anything")
    parser.add_argument("--output", type=Path, default=ROOT / "benchmark-results/demo.json")
    args = parser.parse_args()
    if not re.fullmatch(r"[a-z0-9][a-z0-9_-]{0,62}", args.project):
        parser.error("project must be 1–63 lowercase letters, digits, underscores or hyphens")
    ports = (args.app_port, args.db_port, args.kafka_port)
    if len(set(ports)) != 3 or any(port < 1024 or port > 65535 for port in ports):
        parser.error("ports must be three distinct numbers in [1024,65535]")
    if args.stop and args.broker_outage:
        parser.error("--stop and --broker-outage cannot be combined")
    env = dict(os.environ, APP_PORT=str(args.app_port), DB_PORT=str(args.db_port),
               KAFKA_PORT=str(args.kafka_port), EVENTS_RELAY_ENABLED="true",
               EVENTS_CONSUMER_ENABLED="true", BACKPRESSURE_ENABLED="false")
    compose = ["docker", "compose", "--file", str(ROOT / "compose.yaml"), "--project-name", args.project]
    up = compose + ["up", "--detach", "--wait", "--wait-timeout", "240"]
    if not args.no_build:
        up.append("--build")
    seed = compose + ["exec", "-T", "db", "psql", "-U", "tpp", "-d", "tpp", "-v", "ON_ERROR_STOP=1"]
    base = f"http://127.0.0.1:{args.app_port}"
    smoke = [sys.executable, "scripts/event-smoke.py", "--base-url", base]
    plan = {"project": args.project, "baseUrl": base, "ports": dict(zip(("app", "db", "kafka"), ports)),
            "commands": [compose + ["down"]] if args.stop else [up, seed, seed, smoke],
            "sqlInputs": [] if args.stop else ["scripts/seed-demo.sql", "scripts/verify-runtime-role.sql"],
            "brokerOutage": args.broker_outage, "volumes": "retained"}
    if args.broker_outage:
        plan["outageCommands"] = [compose + ["stop", "kafka"],
                                  ["HTTP", "POST /api/transfers: commit, replay, changed-payload conflict"],
                                  ["HTTP", "GET /internal/transfers/{id}/delivery: awaiting publication"],
                                  compose + ["up", "--detach", "--wait", "--wait-timeout", "180", "kafka"],
                                  ["HTTP/SQL", "verify projected delivery, original event and paired effect"]]
    if args.dry_run:
        print(json.dumps(plan, indent=2))
        return

    # Ownership and output preflight must precede even the first log write.
    owner_path = ROOT / "benchmark-results" / f"{args.project}.owner.json"
    recorded_owner = read_owner(owner_path)
    if recorded_owner is not None and recorded_owner != {"project": args.project, "workingDirectory": str(ROOT)}:
        raise RuntimeError("demo ownership record belongs to another checkout or project")
    if os.path.abspath(args.output) == str(owner_path):
        raise RuntimeError("demo report cannot replace its ownership record")
    # Capture command output privately; never interpolate shell commands.
    log_path = args.output.with_suffix(".log")
    with report_files(args.output, args.project) as (log, publish):
        def run(command, sql=None, capture=False):
            result = subprocess.run(command, cwd=ROOT, env=env, input=sql, text=True,
                                    stdout=subprocess.PIPE, stderr=subprocess.STDOUT, check=False)
            log.write("COMMAND: " + " ".join(command) + "\n" + result.stdout + "\n")
            log.flush()
            if result.returncode:
                raise RuntimeError(f"command failed ({result.returncode}); inspect {log_path}")
            return result.stdout if capture else None

        require_local_docker(run, env)
        try:
            version = run(["docker", "info", "--format", "{{.ServerVersion}}"], capture=True)
            if not re.fullmatch(r"[0-9][0-9A-Za-z.+_-]*\s*", version):
                raise RuntimeError("Docker did not return a running server version")
        except RuntimeError as error:
            raise RuntimeError(f"Docker daemon unavailable; start a working Docker runtime, then retry. Details: {log_path}") from error
        owner = require_owned_project(run, args.project, owner_path)
        if args.stop:
            run(compose + ["down"])
            print(f"Stopped {args.project}; PostgreSQL and Kafka history is retained.")
            return
        write_owner(owner_path, owner)
        print(f"Starting {args.project} at {base}; build output is in {log_path}", flush=True)
        run(up)
        run(seed, (ROOT / "scripts/seed-demo.sql").read_text())
        run(seed, (ROOT / "scripts/verify-runtime-role.sql").read_text())
        report = {"project": args.project, "baseUrl": base,
                  "observedAt": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
                  "smoke": json.loads(run(smoke, capture=True))}
        http = benchmark.Http(base, 5)
        try:
            report["delivery"] = observe_delivery(
                http, report["smoke"]["transferId"], report["smoke"]["eventId"], "PROJECTED")
        finally:
            http.close()
        if args.broker_outage:
            report["brokerOutage"] = outage(run, compose, seed, base)
        publish(report)
        print("PASS: committed transfer, durable same-key replay, paired Kafka activity and reconciliations.")
        print(f"Transfer delivery: {base}/internal/transfers/{report['smoke']['transferId']}/delivery")
        if args.broker_outage:
            print("PASS: transfer committed with broker stopped; its stable event recovered without restarting the app.")
        print(f"Evidence: {args.output}\nOpenAPI: {base}/openapi.yaml\nStop and retain history: python3 scripts/demo.py --project {args.project} --stop")


def observe_delivery(http, transfer_id, event_id, state):
    status, result = http.request("GET", f"/internal/transfers/{transfer_id}/delivery")
    event = result.get("event") if isinstance(result, dict) else None
    if (status != 200 or not isinstance(event, dict) or result.get("transferId") != transfer_id
            or result.get("transferStatus") != "COMPLETED" or result.get("deliveryState") != state
            or event.get("eventId") != event_id):
        raise RuntimeError(f"delivery inspection did not observe {state} for the original transfer and event")
    return result


def outage(run, compose, sql_command, base):
    http = benchmark.Http(base, 5)
    payload = {"sourceAccountId": "00000000-0000-0000-0000-000000000002",
               "destinationAccountId": "00000000-0000-0000-0000-000000000003", "amount": 7, "unit": "FIC"}
    key = f"portfolio-outage-{uuid.uuid4()}"
    app_before = run(compose + ["ps", "--quiet", "app"], capture=True).strip()
    if not app_before:
        raise RuntimeError("application container identity unavailable before outage")
    app_started_before = run(["docker", "inspect", "--format", "{{.State.StartedAt}}", app_before], capture=True).strip()
    try:
        # Even an uncertain stop error or interruption must attempt restoration.
        run(compose + ["stop", "kafka"])
        status, transfer = http.request("POST", "/api/transfers", payload, {"Idempotency-Key": key})
        if status != 201 or transfer.get("status") != "COMPLETED":
            raise RuntimeError("broker-outage transfer did not commit")
        status, replay = http.request("POST", "/api/transfers", payload, {"Idempotency-Key": key})
        if status != 200 or replay != transfer:
            raise RuntimeError("broker-outage same-key replay changed the durable result")
        status, conflict = http.request("POST", "/api/transfers", dict(payload, amount=8), {"Idempotency-Key": key})
        if status != 409 or conflict.get("code") != "IDEMPOTENCY_CONFLICT":
            raise RuntimeError("changed-payload key did not conflict")
        transfer_id = str(uuid.UUID(transfer["id"]))
        query = f"SELECT event_id FROM outbox_events WHERE transfer_id='{transfer_id}'::uuid;"
        event_id = str(uuid.UUID(run(sql_command + ["-At", "-c", query], capture=True).strip()))
        status, pending = http.request("GET", f"/internal/outbox/{event_id}")
        if status != 200 or pending.get("status") not in ("PENDING", "CLAIMED") or pending.get("processedAt") is not None:
            raise RuntimeError("outage event was not durably pending and unprocessed")
        delivery_during = observe_delivery(http, transfer_id, event_id, "AWAITING_PUBLICATION")
    except BaseException:
        http.close()
        raise
    finally:
        # Restore even if the check fails; preserve the broker volume and app process.
        try:
            run(compose + ["up", "--detach", "--wait", "--wait-timeout", "180", "kafka"])
        except Exception:
            http.close()
            raise
    try:
        if run(compose + ["ps", "--quiet", "app"], capture=True).strip() != app_before:
            raise RuntimeError("application container changed during broker recovery")
        if run(["docker", "inspect", "--format", "{{.State.StartedAt}}", app_before], capture=True).strip() != app_started_before:
            raise RuntimeError("application process restarted during broker recovery")
        deadline = time.monotonic() + 90
        recovered = None
        while time.monotonic() < deadline:
            status, recovered = http.request("GET", f"/internal/outbox/{event_id}")
            if status == 200 and recovered.get("status") == "PUBLISHED" and recovered.get("projectedAt") is not None:
                break
            time.sleep(0.25)
        else:
            raise RuntimeError("outage event did not recover within 90 seconds")
        delivery_after = observe_delivery(http, transfer_id, event_id, "PROJECTED")
        ledger = benchmark.reconciliation(http)
        status, projection = http.request("GET", "/internal/events/reconciliation")
        if status != 200 or projection.get("discrepancies") != 0 or projection.get("missingProjection") != 0:
            raise RuntimeError("post-recovery projection did not reconcile")
        # Verify the exact effect through SQL independently of the polling condition.
        query = ("SELECT json_build_object('inbox', (SELECT count(*) FROM event_inbox WHERE event_id='" + event_id + "'::uuid), "
                 "'activityRows', (SELECT count(*) FROM account_activity WHERE event_id='" + event_id + "'::uuid), "
                 "'activityDeltaSum', (SELECT sum(delta_minor) FROM account_activity WHERE event_id='" + event_id + "'::uuid));")
        effect = json.loads(run(sql_command + ["-At", "-c", query], capture=True))
        if effect != {"inbox": 1, "activityRows": 2, "activityDeltaSum": 0}:
            raise RuntimeError("recovered event did not have one inbox and one balanced activity pair")
        return {"transferId": transfer_id, "eventId": event_id, "newHttpStatus": 201, "replayHttpStatus": 200,
                "changedPayloadHttpStatus": 409, "duringOutage": pending["status"], "afterRecovery": recovered["status"],
                "deliveryDuringOutage": delivery_during, "deliveryAfterRecovery": delivery_after,
                "applicationContainerAndStartTimeUnchanged": True, "effect": effect,
                "ledgerReconciliation": ledger, "projectionReconciliation": projection}
    finally:
        http.close()


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, RuntimeError, HTTPException) as error:
        print(f"Demo failed: {error}", file=sys.stderr)
        sys.exit(1)
