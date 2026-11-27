#!/usr/bin/env python3
"""Verify real delivery following through one owned local Kafka outage.

Requires an already-running, idle demo.py project with its matching ownership
record, seeded fictional accounts, enabled Kafka workers, Python Playwright and
an installed Chrome browser. Commits one new seven-FIC transfer while Kafka is
stopped; verifies browser stop/restart, automatic recovery, redacted exports and
offline comparison of the two real downloaded observations.
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
from urllib.parse import urlsplit
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


def validate_observation(document, transfer_id, expected_delivery, original_proof, key, base):
    require_fields(document, ("kind", "version", "transferId", "exportedAt", "delivery", "ledger"), "observation")
    require(document["kind"] == "tpp.transfer-lab-delivery-observation"
            and type(document["version"]) is int and document["version"] == 1
            and document["transferId"] == transfer_id, "observation changed its identity or format")
    require_time(document["exportedAt"])
    delivery = document["delivery"]
    require_fields(delivery, ("observedAt", "transferStatus", "decidedAt", "deliveryState", "event"), "delivery")
    require_time(delivery["observedAt"])
    require((delivery["transferStatus"], delivery["deliveryState"], delivery["decidedAt"])
            == ("COMPLETED", expected_delivery["deliveryState"], expected_delivery["decidedAt"]),
            "exported delivery differs from the observed transfer state")
    require_fields(delivery["event"], ("eventId", "publicationStatus", "attemptCount", "nextAttemptAt",
                   "lastErrorCode", "publishedAt", "processedAt", "projectedAt"), "event")
    require(delivery["event"] == expected_delivery["event"], "exported event differs from the browser's durable observation")
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


def download_observation(page):
    # The file is an actual browser download. It is kept only in a private
    # temporary directory; later imports use precisely these downloaded bytes.
    with tempfile.TemporaryDirectory(prefix="tpp-watch-observation-") as directory:
        with page.expect_download() as download:
            page.locator("#download-observation").click()
        path = Path(directory) / "observation.json"
        download.value.save_as(path)
        path.chmod(0o600)
        require(path.stat().st_size <= 65536, "observation export exceeded the bounded inspection")
        raw = path.read_bytes()
        return raw, json.loads(raw)


def compare_observations(browser, base, transfer_id, pending_raw, settled_raw):
    context = browser.new_context(service_workers="block")
    forbidden_requests, script_errors = [], []

    def guard_request(route):
        request = route.request
        path = urlsplit(request.url).path
        if request.method == "POST" or path.startswith(("/api/", "/internal/")):
            forbidden_requests.append({"method": request.method, "path": path})
            route.abort()
        else:
            route.continue_()

    context.route("**/*", guard_request)
    try:
        page = context.new_page()
        page.set_default_timeout(30000)
        page.on("pageerror", lambda error: script_errors.append(str(error)))
        require(page.goto(base + "/demo/compare.html").status == 200,
                "the offline observation comparator is unavailable")
        storage_count = "Object.keys(localStorage).length + Object.keys(sessionStorage).length"
        require(page.evaluate(storage_count) == 0,
                "the independent comparator context did not start without a receipt")
        policy = page.locator('meta[http-equiv="Content-Security-Policy"]').get_attribute("content")
        require("connect-src 'none'" in policy, "the comparator page did not disable network connections")
        context.set_offline(True)

        def import_bytes(selector, name, raw):
            page.locator(selector).set_input_files({"name": name, "mimeType": "application/json", "buffer": raw})

        import_bytes("#first-report", "outage-observation.json", pending_raw)
        import_bytes("#second-report", "settled-observation.json", settled_raw)
        page.locator("#compare-reports").click()
        page.locator("#compare-result").wait_for(state="visible")
        require(page.locator("#compare-transfer-id").inner_text().strip() == transfer_id,
                "the comparator did not retain the real transfer identity")
        pending, settled = json.loads(pending_raw), json.loads(settled_raw)
        for side, source in (("first", pending), ("second", settled)):
            for suffix, timestamp in (("time", source["exportedAt"]), ("delivery-time", source["delivery"]["observedAt"]),
                                      ("ledger-time", source["ledger"]["observedAt"])):
                clock = page.locator(f"#compare-{side}-{suffix}")
                require(clock.get_attribute("datetime") == timestamp and clock.inner_text() == timestamp,
                        "the comparator did not distinguish export and observation clocks")
        first_publication = pending["delivery"]["event"]["publicationStatus"]
        expected_rows = {
            "delivery": ("changed", "AWAITING_PUBLICATION", "PROJECTED"),
            "publication": ("changed", first_publication, "PUBLISHED"),
            "event": ("same", pending["delivery"]["event"]["eventId"], pending["delivery"]["event"]["eventId"]),
            "ledger": ("same", "BALANCED_PAIR", "BALANCED_PAIR"),
        }
        for field, (comparison, first, second) in expected_rows.items():
            row = page.locator(f'.compare-row[data-field="{field}"]')
            require(row.get_attribute("data-comparison") == comparison
                    and first in row.locator(".compare-first").inner_text()
                    and second in row.locator(".compare-second").inner_text(),
                    "the comparator changed the expected " + field + " evidence")
        require(page.locator('.compare-row[data-field="decision"]').get_attribute("data-comparison") == "same",
                "the comparator changed the committed financial decision")
        ledger = page.locator('.compare-row[data-field="ledger"]')
        for posting in pending["ledger"]["postings"]:
            line = f'#{posting["entryId"]} · {posting["delta"]:+d} {posting["role"]}'
            require(all(line in ledger.locator(column).inner_text() for column in (".compare-first", ".compare-second")),
                    "the comparator did not display an exact signed ledger entry")
        page.set_viewport_size({"width": 390, "height": 844})
        require(page.evaluate("document.documentElement.scrollWidth") <= 390,
                "the real observation comparison overflowed the narrow viewport")
        for field in expected_rows:
            require(page.locator(f'.compare-row[data-field="{field}"]').is_visible(),
                    "the narrow comparison hid a required evidence row")

        import_bytes("#first-report", "settled-observation.json", settled_raw)
        import_bytes("#second-report", "outage-observation.json", pending_raw)
        page.locator("#compare-reports").click()
        page.locator("#compare-order-note").wait_for(state="visible")
        require("PROJECTED" in page.locator('.compare-row[data-field="delivery"] .compare-first').inner_text(),
                "the comparator silently reordered reversed files")

        # Replacing a file must immediately discard the preceding successful
        # result. Negative fixtures are copies only; neither real file changes.
        mismatch = json.loads(settled_raw)
        mismatch["transferId"] = str(uuid.uuid4())
        import_bytes("#second-report", "different-transfer.json", json.dumps(mismatch).encode())
        page.locator("#compare-result").wait_for(state="hidden")
        page.locator("#compare-reports").click()
        page.locator("#compare-status[data-state='negative']").wait_for()
        require(page.locator("#compare-result").is_hidden(),
                "different transfer IDs retained a stale comparison")
        receipt = {"kind": "tpp.transfer-lab-recovery", "version": 1}
        import_bytes("#second-report", "recovery-receipt.json", json.dumps(receipt).encode())
        page.locator("#compare-reports").click()
        page.locator("#compare-status[data-state='negative']").wait_for()
        require(page.locator("#compare-result").is_hidden(),
                "a recovery receipt was accepted as an observation")
        page.locator("#clear-reports").click()
        require(page.locator("#compare-result").is_hidden()
                and not page.locator("#first-report").input_value()
                and not page.locator("#second-report").input_value(),
                "clear retained selected observation files or comparison output")
        require(page.evaluate(storage_count) == 0,
                "offline comparison wrote browser storage")
        require(not forbidden_requests and not script_errors,
                "offline comparison attempted an API request, POST, or raised a JavaScript error")
        return {
            "firstSha256": hashlib.sha256(pending_raw).hexdigest(),
            "secondSha256": hashlib.sha256(settled_raw).hexdigest(),
            "realBrowserDownloads": True,
            "independentContext": True,
            "browserOfflineForComparison": True,
            "delivery": {"first": "AWAITING_PUBLICATION", "second": "PROJECTED", "comparison": "changed"},
            "publication": {"first": first_publication, "second": "PUBLISHED", "comparison": "changed"},
            "sameEventAndLedger": True,
            "exportAndObservationTimesShownSeparately": True,
            "narrowViewportWidth": 390,
            "reversedFileOrderFlaggedWithoutReordering": True,
            "staleResultCleared": True,
            "differentTransferRejected": True,
            "recoveryReceiptRejected": True,
            "clearRemovedFiles": True,
            "apiRequestCount": 0,
            "postCount": 0,
            "storageEntries": 0,
            "scriptErrors": [],
        }
    finally:
        context.close()


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
        attention = http.get("/internal/demo/delivery-attention")
        queue_row = next((item for item in attention["items"] if item["transferId"] == transfer_id), None)
        require(attention["sampleLimit"] == 50 and 1 <= attention["sampledCount"] <= 50
                and queue_row is not None and queue_row["attentionState"] == "AWAITING_PUBLICATION"
                and queue_row["attemptCount"] >= during["event"]["attemptCount"],
                "the bounded attention query did not surface the pending committed transfer")

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
                row = page.locator(f'#attention-items .attention-row[data-transfer-id="{transfer_id}"]')
                row.wait_for(state="visible")
                require(row.get_attribute("data-attention-state") == "AWAITING_PUBLICATION"
                        and "attempt" in row.locator(".attention-details").inner_text(),
                        "the browser attention row did not explain the pending publication")
                delivery_url = base + "/internal/transfers/" + transfer_id + "/delivery"
                with page.expect_response(lambda response: response.url == delivery_url) as observed:
                    row.locator(".attention-inspect").click()
                require(page.locator("#lookup-id").input_value() == transfer_id,
                        "attention navigation did not select the transfer without an entered ID")
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
                pending_raw, pending_observation = download_observation(page)
                validate_observation(pending_observation, transfer_id, browser_during, original_proof, key, base)
                require(pending_observation["delivery"]["deliveryState"] == "AWAITING_PUBLICATION"
                        and pending_observation["delivery"]["event"]["publicationStatus"] in ("PENDING", "CLAIMED"),
                        "the first downloaded observation was not captured during the real Kafka outage")
                mobile = browser.new_context(viewport={"width": 390, "height": 844}, is_mobile=True, has_touch=True)
                try:
                    mobile.on("request", lambda request: browser_posts.append(request.url)
                              if request.method == "POST" else None)
                    narrow = mobile.new_page()
                    narrow.goto(base + "/demo/index.html#delivery-attention")
                    narrow.locator(f'#attention-items .attention-row[data-transfer-id="{transfer_id}"]').wait_for()
                    require(narrow.evaluate("document.documentElement.scrollWidth") <= 390,
                            "the pending attention row overflowed the narrow viewport")
                finally:
                    mobile.close()
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
                page.wait_for_function("""id => !document.querySelector('#attention-refresh').disabled
                  && ['positive','pending'].includes(document.querySelector('#attention-status').dataset.state)
                  && !Array.from(document.querySelectorAll('#attention-items .attention-row'))
                    .some(row => row.dataset.transferId === id)""", arg=transfer_id)
                after_attention = http.get("/internal/demo/delivery-attention")
                require(all(item["transferId"] != transfer_id for item in after_attention["items"]),
                        "a fully settled transfer remained in delivery attention")
                final_proof = http.get("/internal/transfers/" + transfer_id + "/ledger-proof")
                require(final_proof == original_proof, "broker recovery changed the physical ledger postings")
                verifier.check_proof_panel(page, final_proof)
                require(page.locator("#publication-state").inner_text().strip() == "PUBLISHED"
                        and "PROJECTED" in page.locator("#projection-state").inner_text(),
                        "settled page did not show both publication and projection success")
                settled_raw, exported = download_observation(page)
                validate_observation(exported, transfer_id, final_delivery, original_proof, key, base)
                report["observation"] = exported
                report["observationSha256"] = hashlib.sha256(settled_raw).hexdigest()
                report["observationComparison"] = compare_observations(
                    browser, base, transfer_id, pending_raw, settled_raw)
                require(page.evaluate("Object.keys(localStorage).length") == 0,
                        "read-only browser unexpectedly created a saved receipt")
                require(page.locator("#watch-stop").is_disabled(), "settled follow left its timer active")
                require(not browser_posts and not script_errors, "browser wrote a transfer or reported a JavaScript error")
                report["browser"] = {"postCount": 0, "watchState": "settled",
                                     "automaticFollowReads": len(delivery_reads) - prior_reads,
                                     "settledAfterSeconds": round(elapsed, 3),
                                     "samePostingIdsAndEvent": True, "userStopCancelledFutureReads": True,
                                     "savedReceiptCreated": False, "scriptErrors": []}
                report["attention"] = {"sampleLimit": attention["sampleLimit"],
                                       "sampledDuringOutage": attention["sampledCount"],
                                       "pendingTransferId": transfer_id, "foundFromFreshBrowser": True,
                                       "inspectedWithoutEnteringId": True,
                                       "pendingRowFitsNarrowViewport": True,
                                       "removedAfterSettlementFromBrowserAndApi": True}
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
