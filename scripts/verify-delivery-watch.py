#!/usr/bin/env python3
"""Verify real delivery following through one owned local Kafka outage.

Requires an already-running, idle demo.py project with its matching ownership
record, seeded fictional accounts, enabled Kafka workers, Python Playwright and
an installed Chrome browser. Commits one new seven-FIC transfer while Kafka is
stopped; verifies browser stop/restart, automatic recovery and redacted export.
Only the selected project's captured Kafka container is stopped/started. Its
history is retained, and broker restoration is attempted even when a check fails.
"""

import argparse
import datetime
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile
import time
import uuid

REPO = Path(__file__).resolve().parents[1]


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def now():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def load_script(name, filename):
    sys.path.insert(0, str(REPO / "scripts"))
    spec = importlib.util.spec_from_file_location(name, REPO / "scripts" / filename)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def wait_for(description, timeout, condition):
    deadline = time.monotonic() + timeout
    while True:
        value = condition()
        if value:
            return value
        require(time.monotonic() < deadline, description + " exceeded its deadline")
        time.sleep(min(0.25, max(0, deadline - time.monotonic())))


def require_fields(value, fields, label):
    require(isinstance(value, dict) and set(value) == set(fields), label + " has unexpected fields")


def require_time(value):
    require(isinstance(value, str), "observation timestamp is missing")
    datetime.datetime.fromisoformat(value.replace("Z", "+00:00"))


def validate_observation(document, transfer_id, final_delivery, original_proof, key, base):
    require_fields(document, ("kind", "version", "transferId", "exportedAt", "delivery", "ledger"), "observation")
    require(document["kind"] == "tpp.transfer-lab-delivery-observation"
            and type(document["version"]) is int and document["version"] == 1
            and document["transferId"] == transfer_id, "observation changed its identity or format")
    require_time(document["exportedAt"])
    delivery = document["delivery"]
    require_fields(delivery, ("observedAt", "transferStatus", "decidedAt", "deliveryState", "event"), "delivery")
    require_time(delivery["observedAt"])
    require((delivery["transferStatus"], delivery["deliveryState"], delivery["decidedAt"])
            == ("COMPLETED", "PROJECTED", final_delivery["decidedAt"]), "exported delivery is not settled")
    require_fields(delivery["event"], ("eventId", "publicationStatus", "attemptCount", "nextAttemptAt",
                   "lastErrorCode", "publishedAt", "processedAt", "projectedAt"), "event")
    require(delivery["event"] == final_delivery["event"], "exported event differs from durable final evidence")
    ledger = document["ledger"]
    require_fields(ledger, ("observedAt", "transferStatus", "proofState", "amount", "unit", "postings"), "ledger")
    require_time(ledger["observedAt"])
    require((ledger["transferStatus"], ledger["proofState"], ledger["amount"], ledger["unit"])
            == ("COMPLETED", "BALANCED_PAIR", 7, "FIC"), "exported ledger proof is not the original signed pair")
    expected = {}
    for posting in original_proof["postings"]:
        role = "SOURCE" if posting["accountId"] == original_proof["sourceAccountId"] else "DESTINATION"
        expected[posting["entryId"]] = (posting["delta"], role)
    require(isinstance(ledger["postings"], list) and len(ledger["postings"]) == 2, "export did not retain two postings")
    actual = {}
    for posting in ledger["postings"]:
        require_fields(posting, ("entryId", "delta", "role"), "posting")
        require(isinstance(posting["entryId"], str) and re.fullmatch(r"[1-9][0-9]*", posting["entryId"]),
                "exported entry ID lost its decimal-string form")
        actual[posting["entryId"]] = (posting["delta"], posting["role"])
    require(actual == expected, "observation changed the original physical posting IDs or signed amounts")
    text = json.dumps(document)
    require(all(value not in text for value in (key, base, original_proof["sourceAccountId"],
                                               original_proof["destinationAccountId"])),
            "observation disclosed a request key, endpoint or account identity")


def execute_check(args, report):
    verifier = load_script("tpp_watch_browser_verifier", "verify-browser-demo.py")
    demo = load_script("tpp_watch_demo_owner", "demo.py")
    host, port = verifier.local_origin(args.base_url)
    base = f"http://{host}:{port}"
    project = args.project
    environment = dict(os.environ)
    owner_path = REPO / "benchmark-results" / (project + ".owner.json")
    expected_owner = {"project": project, "workingDirectory": str(REPO)}
    require(demo.read_owner(owner_path) == expected_owner,
            "selected demo needs an existing ownership record matching this checkout and project")

    def run(command, capture=False, timeout=30):
        result = subprocess.run(command, cwd=REPO, env=environment, text=True,
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=timeout)
        if result.returncode:
            # Do not include raw command output, environment, credentials or submitted intent.
            raise RuntimeError("owned Docker operation failed: " + command[1])
        return result.stdout if capture else None

    demo.require_local_docker(run, environment)
    demo.require_owned_project(run, project, owner_path)

    def one_service(service):
        ids = run(["docker", "ps", "--filter", "label=com.docker.compose.project=" + project,
                   "--filter", "label=com.docker.compose.service=" + service,
                   "--format", "{{.ID}}"], capture=True).split()
        require(len(ids) == 1, "expected exactly one running owned " + service + " container")
        return ids[0]

    app_id, kafka_id, db_id = (one_service(service) for service in ("app", "kafka", "db"))

    def inspect(container, field):
        return run(["docker", "inspect", "--format", field, container], capture=True).strip()

    ports = json.loads(inspect(app_id, "{{json .NetworkSettings.Ports}}"))
    require(any(binding["HostIp"] == "127.0.0.1" and binding["HostPort"] == str(port)
                for binding in ports.get("8080/tcp", []) or []), "owned app is not bound to the selected loopback port")
    app_started = inspect(app_id, "{{.State.StartedAt}}")
    require(inspect(kafka_id, "{{.State.Health.Status}}") == "healthy", "Kafka is not healthy before the controlled outage")
    http = verifier.ReadOnlyHttp(host, port)
    verifier.fixture_gate(http, 30)
    settings = http.get("/internal/events/status")
    require(settings["relayEnabled"] and settings["consumerEnabled"], "Kafka workers must be enabled")
    require(http.get("/api/accounts/" + verifier.ALICE + "/balance")["amount"] >= 7, "Alice needs seven fictional units")
    report["preflight"] = {"ownedProject": project, "loopbackPort": port, "ready": "UP",
                           "ownedAppId": app_id, "ownedKafkaId": kafka_id, "fixtureValidated": True}
    key = "watch-outage-" + str(uuid.uuid4())
    report["keySha256"] = hashlib.sha256(key.encode()).hexdigest()
    restart_required = False

    def restart_broker():
        run(["docker", "start", kafka_id])

    try:
        # Fence cleanup before stop, including a timed-out or interrupted stop command.
        restart_required = True
        run(["docker", "stop", "--time", "2", kafka_id])
        require(inspect(kafka_id, "{{.State.Running}}") == "false", "owned broker did not stop")
        connection = verifier.http.client.HTTPConnection(host, port, timeout=30)
        try:
            payload = {"sourceAccountId": verifier.ALICE, "destinationAccountId": verifier.BOB,
                       "amount": 7, "unit": "FIC"}
            connection.request("POST", "/api/transfers", json.dumps(payload),
                               {"Content-Type": "application/json", "Idempotency-Key": key})
            response = connection.getresponse()
            transfer = json.loads(response.read(65537))
            require(response.status == 201 and transfer["status"] == "COMPLETED", "the one outage POST did not establish a new committed transfer")
            transfer_id = str(uuid.UUID(transfer["id"]))
        finally:
            connection.close()
        report["transferId"] = transfer_id
        report["newHttpStatus"] = 201

        def failed_attempt():
            value = http.get("/internal/transfers/" + transfer_id + "/delivery")
            require(value["transferStatus"] == "COMPLETED" and value["deliveryState"] == "AWAITING_PUBLICATION",
                    "broker-down delivery did not remain awaiting publication")
            event = value["event"]
            return value if event["attemptCount"] > 0 and event["lastErrorCode"] else None

        during = wait_for("persisted failed publication attempt", args.error_timeout, failed_attempt)
        event_id = during["event"]["eventId"]
        original_proof = http.get("/internal/transfers/" + transfer_id + "/ledger-proof")
        require(original_proof["proofState"] == "BALANCED_PAIR" and len(original_proof["postings"]) == 2,
                "broker outage changed the authoritative ledger proof")
        report["duringOutage"] = {"deliveryState": during["deliveryState"],
                                  "eventId": event_id, "attemptCount": during["event"]["attemptCount"],
                                  "lastErrorCode": during["event"]["lastErrorCode"]}

        from playwright.sync_api import sync_playwright
        with sync_playwright() as playwright:
            browser = playwright.chromium.launch(channel=args.channel, headless=True)
            try:
                context = browser.new_context(service_workers="allow")
                browser_posts, delivery_reads, script_errors = [], [], []
                context.on("request", lambda request: browser_posts.append(request.url)
                           if request.method == "POST" else None)
                page = context.new_page()
                page.set_default_timeout(30000)
                page.on("pageerror", lambda error: script_errors.append(str(error)))
                page.on("request", lambda request: delivery_reads.append(request.url)
                        if request.method == "GET" and request.url == base + "/internal/transfers/" + transfer_id + "/delivery" else None)
                require(page.goto(base + "/demo/index.html").status == 200, "browser demo is unavailable")
                page.locator("#lookup-id").fill(transfer_id)
                delivery_url = base + "/internal/transfers/" + transfer_id + "/delivery"
                with page.expect_response(lambda response: response.url == delivery_url) as observed:
                    page.locator("#lookup-transfer").click()
                page.wait_for_function("() => document.querySelector('#delivery-state')?.textContent === 'AWAITING_PUBLICATION'")
                verifier.check_proof_panel(page, original_proof)
                require(re.search(r"[1-9][0-9]*", page.locator("#delivery-attempts").inner_text()), "retry count is not visible")
                browser_during = observed.value.json()
                require(browser_during["event"]["attemptCount"] > 0
                        and browser_during["event"]["lastErrorCode"]
                        and browser_during["event"]["lastErrorCode"] in page.locator("#delivery-error").inner_text(),
                        "persisted failure code is not visible")
                for selector in ("#delivery-next-at", "#delivery-observed-at"):
                    require(page.locator(selector).is_visible() and page.locator(selector).inner_text().strip(),
                            "delivery observation/retry field is unavailable")
                prior_reads = len(delivery_reads)
                with page.expect_response(lambda response: response.url == delivery_url):
                    page.locator("#watch-start").click()
                page.locator("#watch-status[data-watch-state='watching']").wait_for()
                page.locator("#watch-stop").click()
                page.locator("#watch-status[data-watch-state='stopped']").wait_for()
                after_stop = len(delivery_reads)
                require(after_stop > prior_reads, "stopped watch never made an observation")
                page.wait_for_timeout(2400)
                require(len(delivery_reads) == after_stop, "stop did not cancel future delivery reads")
                require(page.locator("#watch-start").is_enabled(), "stopped pending watch could not be restarted")
                prior_reads = after_stop
                page.locator("#watch-start").click()
                page.locator("#watch-status[data-watch-state='watching']").wait_for()
                watch_started = time.monotonic()
                # Start the same broker immediately; let the real watcher see recovery in progress.
                restart_broker()
                remaining_ms = int((55 - (time.monotonic() - watch_started)) * 1000)
                require(remaining_ms > 0, "starting Kafka consumed the bounded watch window")
                page.locator("#watch-status[data-watch-state='settled']").wait_for(timeout=remaining_ms)
                elapsed = time.monotonic() - watch_started
                require(elapsed < 55, "watch recovery exceeded its bounded window")
                require(len(delivery_reads) > prior_reads, "delivery settled without an automatic follow read")
                final_delivery = http.get("/internal/transfers/" + transfer_id + "/delivery")
                require(final_delivery["deliveryState"] == "PROJECTED"
                        and final_delivery["event"]["publicationStatus"] == "PUBLISHED"
                        and final_delivery["event"]["eventId"] == event_id, "watch did not settle the same event")
                final_proof = http.get("/internal/transfers/" + transfer_id + "/ledger-proof")
                require(final_proof == original_proof, "broker recovery changed the physical ledger postings")
                verifier.check_proof_panel(page, final_proof)
                require(page.locator("#publication-state").inner_text().strip() == "PUBLISHED"
                        and "PROJECTED" in page.locator("#projection-state").inner_text(),
                        "settled page did not show both publication and projection success")
                with tempfile.TemporaryDirectory(prefix="tpp-watch-observation-") as directory:
                    with page.expect_download() as download:
                        page.locator("#download-observation").click()
                    path = Path(directory) / "observation.json"
                    download.value.save_as(path)
                    path.chmod(0o600)
                    raw = path.read_bytes()
                    require(len(raw) <= 65536, "observation export exceeded the bounded inspection")
                    exported = json.loads(raw)
                    validate_observation(exported, transfer_id, final_delivery, original_proof, key, base)
                    report["observation"] = exported
                    report["observationSha256"] = hashlib.sha256(raw).hexdigest()
                require(page.evaluate("Object.keys(localStorage).length") == 0,
                        "read-only browser unexpectedly created a saved receipt")
                require(page.locator("#watch-stop").is_disabled(), "settled follow left its timer active")
                require(not browser_posts and not script_errors, "browser wrote a transfer or reported a JavaScript error")
                report["browser"] = {"postCount": 0, "watchState": "settled",
                                     "automaticFollowReads": len(delivery_reads) - prior_reads,
                                     "settledAfterSeconds": round(elapsed, 3),
                                     "samePostingIdsAndEvent": True, "userStopCancelledFutureReads": True,
                                     "savedReceiptCreated": False, "scriptErrors": []}
                context.close()
            finally:
                browser.close()
    finally:
        if restart_required:
            # Starting an already-running owned container is a no-op. Always attempt recovery,
            # even when an inspect call or the earlier start failed partway through.
            restart_broker()
            wait_for("owned Kafka health restoration", 90,
                     lambda: inspect(kafka_id, "{{.State.Health.Status}}") == "healthy")
            report["brokerRestored"] = True
    require(one_service("app") == app_id and inspect(app_id, "{{.State.StartedAt}}") == app_started,
            "application identity or start time changed during recovery")
    report["applicationNotRestarted"] = True
    report["ledgerReconciliation"] = http.get("/internal/reconciliation")["consistent"]
    require(report["ledgerReconciliation"] is True, "ledger did not reconcile after recovery")
    events = http.get("/internal/events/reconciliation")
    require(events["discrepancies"] == 0 and events["missingProjection"] == 0, "event recovery did not reconcile")
    # Independent SQL through only the captured owned database container, never a supplied URL.
    query = ("SELECT json_build_object('outbox',(SELECT count(*) FROM outbox_events WHERE transfer_id='" + transfer_id + "'::uuid),"
             "'inbox',(SELECT count(*) FROM event_inbox WHERE transfer_id='" + transfer_id + "'::uuid),"
             "'projection',(SELECT count(*) FROM transfer_activity_projection WHERE transfer_id='" + transfer_id + "'::uuid),"
             "'activity',(SELECT count(*) FROM account_activity WHERE transfer_id='" + transfer_id + "'::uuid),"
             "'activitySum',(SELECT sum(delta_minor) FROM account_activity WHERE transfer_id='" + transfer_id + "'::uuid));")
    effect = json.loads(run(["docker", "exec", db_id, "psql", "-U", "tpp", "-d", "tpp", "-At", "-c", query], capture=True))
    require(effect == {"outbox": 1, "inbox": 1, "projection": 1, "activity": 2, "activitySum": 0}, "SQL did not confirm one exact durable event effect")
    report["sqlEffect"] = effect


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project", required=True,
                        help="existing demo.py Compose project owned by this checkout")
    parser.add_argument("--base-url", required=True,
                        help="the selected app's explicit numeric loopback origin")
    parser.add_argument("--output", type=Path,
                        help="new private JSON report; parent directory must exist")
    parser.add_argument("--channel", default="chrome", choices=("chrome", "chromium"))
    parser.add_argument("--error-timeout", type=int, default=150,
                        help="seconds to observe persisted publication failure (30–180)")
    args = parser.parse_args()
    if not re.fullmatch(r"[a-z0-9][a-z0-9_-]{0,62}", args.project):
        parser.error("project must be 1–63 lowercase letters, digits, underscores or hyphens")
    if not 30 <= args.error_timeout <= 180:
        parser.error("error timeout must be within 30–180 seconds")
    descriptor = None
    try:
        verifier = load_script("tpp_watch_origin_validation", "verify-browser-demo.py")
        verifier.local_origin(args.base_url)
        if args.output:
            parent = args.output.parent.resolve(strict=True)
            descriptor = os.open(parent / args.output.name,
                                 os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW, 0o600)
    except (ValueError, OSError) as error:
        parser.error(str(error))
    report = {"startedAt": now(), "project": args.project, "complete": False,
              "scriptSha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
              "scope": "One new 7-FIC HTTP transfer during an owned Kafka outage; browser makes no POSTs"}
    result = 1
    try:
        execute_check(args, report)
        report["complete"] = True
        result = 0
    except BaseException as error:
        report["error"] = {"type": type(error).__name__, "message": str(error)}
    finally:
        report["finishedAt"] = now()
        if descriptor is not None:
            with os.fdopen(descriptor, "w", encoding="utf-8") as stream:
                json.dump(report, stream, indent=2)
                stream.write("\n")
        print(json.dumps(report, indent=2))
    return result


if __name__ == "__main__":
    raise SystemExit(main())
