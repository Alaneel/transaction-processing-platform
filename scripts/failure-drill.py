#!/usr/bin/env python3
"""Run one live Transfer Lab failure drill against a warm, isolated local demo."""

import argparse
from contextlib import contextmanager
from datetime import datetime, timezone
import fcntl
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import re
import signal
import subprocess
import sys
import time
from urllib.parse import urlsplit
import uuid

import demo

ROOT = Path(__file__).resolve().parents[1]
TARGET_SECONDS = 90
STAGES = {
    "preparing": "Check the selected demo",
    "broker-offline": "Stop its Kafka broker",
    "reply-lost": "Lose a committed HTTP reply",
    "receipt-recovered": "Recover the original transfer in a fresh browser",
    "delivery-pending": "Observe committed ledger and pending delivery",
    "delivery-projected": "Follow the same event to projection",
    "verified": "Verify one transfer and one projection in PostgreSQL",
    "failed": "Drill did not verify",
}
PRESENTER_PATHS = {"/demo/" + asset for asset in (
    "failure-drill.html", "failure-drill.css", "failure-drill.js", "demo.css", "favicon.svg",
)}


class DrillError(RuntimeError):
    pass


def require(condition, message):
    if not condition:
        raise DrillError(message)


def stamp():
    return datetime.now(timezone.utc).isoformat()


def load(filename, name):
    spec = importlib.util.spec_from_file_location(name, ROOT / "scripts" / filename)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def project_name(value):
    if not isinstance(value, str) or re.fullmatch(r"[a-z0-9][a-z0-9_-]{0,62}", value) is None:
        raise ValueError("project must be 1–63 lowercase letters, digits, underscores or hyphens")
    return value


def numeric_origin(value):
    if not isinstance(value, str) or re.fullmatch(r"http://127\.0\.0\.1:[0-9]{1,5}/?", value) is None:
        raise ValueError("base URL must be http://127.0.0.1:PORT without credentials or a path")
    port = urlsplit(value).port
    if not port:
        raise ValueError("base URL must have a valid nonzero port")
    return f"http://127.0.0.1:{port}"


def public_details(details):
    """Send only bounded evidence, never browser request data, to the presenter."""
    data = {}
    for key in ("transferId", "eventId"):
        value = details.get(key)
        if isinstance(value, str) and re.fullmatch(r"[\da-f]{8}(?:-[\da-f]{4}){3}-[\da-f]{12}", value, re.ASCII):
            data[key] = value
    for key in ("httpStatus", "replayHttpStatus", "sourceDelta", "destinationDelta", "eventDiscrepancies",
                "outboxCount", "inboxCount", "projectionCount", "activityCount", "activitySum"):
        value = details.get(key)
        if type(value) is int and abs(value) <= 9000000000000000:
            data[key] = value
    for key in ("ledgerConsistent", "appRestarted", "withinTarget", "freshContext", "ledgerUnchanged"):
        value = details.get(key)
        if type(value) is bool:
            data[key] = value
    enums = {
        "deliveryState": {"AWAITING_PUBLICATION", "AWAITING_PROJECTION", "PROJECTED"},
        "publicationStatus": {"PENDING", "CLAIMED", "PUBLISHED"},
        "projectionState": {"PROJECTED", "NOT_PROJECTED"},
    }
    for key, accepted in enums.items():
        value = details.get(key)
        if type(value) is str and value in accepted:
            data[key] = value
    ids = details.get("postingIds")
    if isinstance(ids, (tuple, list)) and len(ids) == 2 and all(
            type(value) is str and re.fullmatch(r"[1-9][0-9]{0,18}", value) for value in ids):
        data["postingIds"] = list(ids)
    return data


class OwnedStack:
    def __init__(self, project, base, verifier, watch):
        self.project, self.base, self.verifier, self.watch = project, base, verifier, watch
        self.environment = dict(os.environ)
        self.owner = ROOT / "benchmark-results" / (project + ".owner.json")

    def run(self, command, capture=False, timeout=12):
        result = subprocess.run(command, cwd=ROOT, env=self.environment, text=True,
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=timeout)
        require(result.returncode == 0, f"Owned Docker operation failed ({command[1]}).")
        return result.stdout if capture else None

    def inspect(self, container, field):
        return self.run(["docker", "inspect", "--format", field, container], capture=True).strip()

    def service(self, service):
        ids = self.run(["docker", "ps", "--no-trunc", "--filter", f"label=com.docker.compose.project={self.project}",
                        "--filter", f"label=com.docker.compose.service={service}",
                        "--format", "{{.ID}}"], capture=True).split()
        require(len(ids) == 1 and re.fullmatch(r"[0-9a-f]{64}", ids[0]),
                f"Expected one running {service} container in the owned demo.")
        return ids[0]

    def preflight(self):
        expected = {"project": self.project, "workingDirectory": str(ROOT)}
        require(demo.read_owner(self.owner) == expected, "Start the matching demo from this checkout first.")
        demo.require_local_docker(self.run, self.environment)
        demo.require_owned_project(self.run, self.project, self.owner)
        self.app, self.kafka, self.db = (self.service(name) for name in ("app", "kafka", "db"))
        self.app_started = self.inspect(self.app, "{{.State.StartedAt}}")
        self.db_started = self.inspect(self.db, "{{.State.StartedAt}}")
        ports = json.loads(self.inspect(self.app, "{{json .NetworkSettings.Ports}}"))
        host, port = self.verifier.local_origin(self.base)
        require(ports.get("8080/tcp") == [{"HostIp": host, "HostPort": str(port)}],
                "The captured app is not bound only to the selected loopback address.")
        require(self.inspect(self.kafka, "{{.State.Health.Status}}") == "healthy", "Kafka is not healthy.")
        self.http = self.verifier.ReadOnlyHttp(host, port)
        self.verifier.fixture_gate(self.http, 8)
        settings = self.http.get("/internal/events/status")
        require(settings["relayEnabled"] and settings["consumerEnabled"], "Enable both event workers first.")
        events = self.http.get("/internal/events/reconciliation")
        require(events["discrepancies"] == 0 and events["missingProjection"] == 0
                and events["publishedAwaitingProjection"] == 0, "Start with a reconciled, idle demo.")
        baseline = self.http.snapshot()
        require(baseline[self.verifier.ALICE]["balance"] >= 7, "The demo Alice account needs at least 7 FIC.")
        return baseline

    def stop_broker(self):
        require(self.service("kafka") == self.kafka and self.service("app") == self.app
                and self.service("db") == self.db, "A demo container was replaced after preflight.")
        self.run(["docker", "stop", "--time", "2", self.kafka])
        require(self.inspect(self.kafka, "{{.State.Running}}") == "false", "The captured broker did not stop.")

    def restore_broker(self):
        if self.inspect(self.kafka, "{{.State.Running}}") != "true":
            self.run(["docker", "start", self.kafka])

    def check_restored(self):
        self.watch.wait_for("captured Kafka health restoration", 38,
                            lambda: self.inspect(self.kafka, "{{.State.Health.Status}}") == "healthy")
        require(self.service("kafka") == self.kafka, "Kafka identity changed during the drill.")
        require(self.service("app") == self.app and self.inspect(self.app, "{{.State.StartedAt}}") == self.app_started
                and self.service("db") == self.db and self.inspect(self.db, "{{.State.StartedAt}}") == self.db_started,
                "The application or database restarted during the drill.")

    def sql(self, select):
        return json.loads(self.run(["docker", "exec", self.db, "psql", "-X", "-U", "tpp", "-d", "tpp",
                                     "-v", "ON_ERROR_STOP=1", "-qAt", "-c",
                                     f"BEGIN READ ONLY; SET LOCAL statement_timeout='5s'; {select}; COMMIT"],
                                    capture=True))

    def totals(self):
        return self.sql("""SELECT json_build_object('transfers',(SELECT count(*) FROM transfers),
          'postings',(SELECT count(*) FROM ledger_entries), 'outbox',(SELECT count(*) FROM outbox_events),
          'inbox',(SELECT count(*) FROM event_inbox),
          'projection',(SELECT count(*) FROM transfer_activity_projection),
          'activity',(SELECT count(*) FROM account_activity))""")

    def proof(self, transfer_id, event_id):
        transfer, event = str(uuid.UUID(transfer_id)), str(uuid.UUID(event_id))
        return self.sql(f"""WITH t AS (SELECT * FROM transfers WHERE id='{transfer}'::uuid),
              p AS (SELECT * FROM ledger_entries WHERE transfer_id='{transfer}'::uuid),
              o AS (SELECT * FROM outbox_events WHERE transfer_id='{transfer}'::uuid),
              i AS (SELECT * FROM event_inbox WHERE transfer_id='{transfer}'::uuid),
              v AS (SELECT * FROM transfer_activity_projection WHERE transfer_id='{transfer}'::uuid),
              a AS (SELECT * FROM account_activity WHERE transfer_id='{transfer}'::uuid)
            SELECT json_build_object(
              'completedTransfer',(SELECT count(*) FROM t WHERE status='COMPLETED' AND amount=7 AND unit='FIC'
                    AND source_account_id='{uuid.UUID(self.verifier.ALICE)}'::uuid
                    AND destination_account_id='{uuid.UUID(self.verifier.BOB)}'::uuid),
              'postings',(SELECT json_agg(json_build_object('entryId',p.id::text,'delta',p.delta,
                    'role',CASE WHEN p.account_id=t.source_account_id THEN 'SOURCE'
                               WHEN p.account_id=t.destination_account_id THEN 'DESTINATION' ELSE 'OTHER' END)
                    ORDER BY p.id) FROM p,t),
              'outboxCount',(SELECT count(*) FROM o),'inboxCount',(SELECT count(*) FROM i),
              'projectionCount',(SELECT count(*) FROM v),'activityCount',(SELECT count(*) FROM a),
              'activitySum',(SELECT sum(delta_minor) FROM a),
              'matchingPublishedEvent',(SELECT count(*) FROM o WHERE event_id='{event}'::uuid AND status='PUBLISHED'),
              'matchingInboxEvent',(SELECT count(*) FROM i WHERE event_id='{event}'::uuid),
              'matchingProjectionEvent',(SELECT count(*) FROM v WHERE event_id='{event}'::uuid),
              'matchingSignedActivity',(SELECT count(*) FROM a,t WHERE a.event_id='{event}'::uuid AND
                   ((a.account_id=t.source_account_id AND a.delta_minor=-t.amount) OR
                    (a.account_id=t.destination_account_id AND a.delta_minor=t.amount))))""")


@contextmanager
def broker_outage(stack):
    try:
        stack.stop_broker()
        yield stack.restore_broker
    finally:
        # Even a stop command that times out might have stopped Kafka.
        stack.restore_broker()


@contextmanager
def project_lock(stack):
    directory = demo.owner_parent(stack.owner)
    require(directory is not None, "Start the matching demo from this checkout first.")
    descriptor = None
    try:
        descriptor = demo.regular_output(directory, stack.project + ".failure-drill.lock",
                                         os.O_RDWR | os.O_CREAT)
        try:
            fcntl.flock(descriptor, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError as error:
            raise DrillError("A failure drill is already using this owned project.") from error
        yield
    finally:
        if descriptor is not None:
            os.close(descriptor)
        os.close(directory)


class Presenter:
    def __init__(self, browser, base, capture, narrow=False):
        self.narrow = narrow
        viewport = {"width": 390, "height": 844} if narrow else {"width": 1150, "height": 905}
        self.context = browser.new_context(viewport=viewport, service_workers="block")
        self.capture = capture
        self.page = self.context.new_page()
        self.page.set_default_timeout(6000)
        self.page.set_default_navigation_timeout(6000)
        self.api_or_write_requests = 0
        self.page_errors = 0

        def gate(route):
            parsed = urlsplit(route.request.url)
            if route.request.method != "GET" or parsed.path.startswith(("/api/", "/internal/")):
                self.api_or_write_requests += 1
            if route.request.method == "GET" and f"{parsed.scheme}://{parsed.netloc}" == base and parsed.path in PRESENTER_PATHS:
                route.continue_()
            else:
                route.abort()

        def page_error(_error):
            self.page_errors += 1

        self.context.route("**/*", gate)
        self.page.on("pageerror", page_error)
        require(self.page.goto(base + "/demo/failure-drill.html").status == 200, "The live presenter is not available.")
        self.page.wait_for_function("() => typeof window.TransferFailureDrill?.present === 'function'")
        require(self.page.locator("#drill-mode").get_attribute("data-state") == "waiting"
                and self.page.locator("#drill-result").is_hidden(), "The presenter claimed a result before the drill.")
        self.context.set_offline(True)

    def publish(self, step, seq):
        result = self.page.evaluate("update => window.TransferFailureDrill.present(update)", step)
        require(result["stage"] == step["stage"], "The presenter did not show the reported stage.")
        if self.capture is not None:
            data = self.page.screenshot(animations="disabled")
            descriptor = demo.regular_output(self.capture, f"{seq:02d}-{step['stage']}.png",
                                             os.O_WRONLY | os.O_CREAT | os.O_EXCL)
            with os.fdopen(descriptor, "wb") as stream:
                stream.write(data)

    def check(self, browser_result):
        page = self.page
        require(page.locator("#drill-result").is_visible()
                and page.locator("#drill-result").get_attribute("data-stage") == "verified",
                "The presenter did not distinguish a verified run.")
        require(page.locator(".drill-steps [data-state=observed]").count() == 7
                and page.locator("#drill-transfer-id").inner_text() == browser_result["transferId"]
                and page.locator("#drill-event-id").inner_text() == browser_result["eventId"]
                and page.locator("#drill-projection-count").inner_text() == "1"
                and page.locator("#drill-ledger-check").inner_text() == "No new postings",
                "The presenter did not show the original identity and exact scope.")
        if self.narrow:
            require(page.evaluate("document.documentElement.scrollWidth") <= 390,
                    "The presenter did not fit a 390-pixel viewport.")
        storage = page.evaluate("localStorage.length + sessionStorage.length")
        require(self.api_or_write_requests == 0 and self.page_errors == 0 and storage == 0,
                "The offline presenter made a request, stored data or failed.")


def verify_sql(stack, before, result):
    expected = {"transfers": 1, "postings": 2, "outbox": 1, "inbox": 1, "projection": 1, "activity": 2}
    after = stack.totals()
    require({key: after[key] - before[key] for key in expected} == expected,
            "The isolated demo did not add exactly one transfer and one projection.")
    proof = stack.proof(result["transferId"], result["eventId"])
    exact = {"completedTransfer": 1, "outboxCount": 1, "inboxCount": 1, "projectionCount": 1,
             "activityCount": 2, "activitySum": 0, "matchingPublishedEvent": 1, "matchingInboxEvent": 1,
             "matchingProjectionEvent": 1, "matchingSignedActivity": 2}
    require(all(proof[key] == value for key, value in exact.items()), "The matching SQL event did not satisfy the drill.")
    require({(row["entryId"], row["delta"], row["role"]) for row in proof["postings"]}
            == {(row["entryId"], row["delta"], row["role"]) for row in result["ledger"]["postings"]}
            and len(proof["postings"]) == 2, "SQL posting IDs or signed amounts differ from browser evidence.")
    ledger = stack.http.get("/internal/reconciliation")
    events = stack.http.get("/internal/events/reconciliation")
    require(ledger["consistent"] is True and events["discrepancies"] == 0 and events["missingProjection"] == 0,
            "Ledger or event reconciliation did not pass.")
    return proof, expected


def close_owned_browser(browser):
    # Close our isolated contexts before asking the browser process to exit.
    # In particular, the visible offline presenter can retain a pending route.
    try:
        for context in list(browser.contexts):
            context.unroute_all(behavior="ignoreErrors")
            context.close()
    finally:
        browser.close()


def live_drill(args, report, capture):
    from playwright.sync_api import sync_playwright
    from failure_drill_browser import exercise

    verifier = load("verify-browser-demo.py", "drill_browser_verifier")
    watch = load("verify-delivery-watch.py", "drill_delivery_verifier")
    stack = OwnedStack(args.project, args.base_url, verifier, watch)
    clock = time.monotonic()
    presenter = None

    def emit(stage, details=None):
        elapsed = round(time.monotonic() - clock, 3)
        safe = public_details(details or {})
        if stage == "verified":
            safe["withinTarget"] = elapsed <= TARGET_SECONDS
        step = {"stage": stage, "details": safe, "elapsedSeconds": elapsed}
        report["steps"].append(step)
        print(f"{step['elapsedSeconds']:6.1f}s  {STAGES[stage]}", flush=True)
        if presenter:
            presenter.publish(step, len(report["steps"]))

    with project_lock(stack):
        emit("preparing")
        baseline = stack.preflight()
        before = stack.totals()
        with sync_playwright() as playwright:
            browser = playwright.chromium.launch(channel=args.channel, headless=True)
            try:
                if args.headed:
                    from failure_drill_presenter import HeadedPresenter
                    presenter = HeadedPresenter(args.base_url, args.channel, capture)
                else:
                    presenter = Presenter(browser, args.base_url, capture)
                presenter.publish(report["steps"][0], 1)
                try:
                    with broker_outage(stack) as restore:
                        emit("broker-offline")
                        report["browser"] = exercise(browser, verifier, watch, stack.http, args.base_url,
                                                     baseline, restore, emit)
                finally:
                    stack.check_restored()
                    report["brokerRestored"] = True
                    report["appAndDatabaseNotRestarted"] = True
                proof, increments = verify_sql(stack, before, report["browser"])
                report["sqlProof"], report["isolatedRowIncrements"] = proof, increments
                details = {**proof, "ledgerConsistent": True, "eventDiscrepancies": 0, "appRestarted": False}
                emit("verified", details)
                presenter.check(report["browser"])
                # Use a separate headless viewport. Resizing the spectator's physical
                # macOS window is neither necessary nor supported at phone dimensions.
                mobile = Presenter(browser, args.base_url, capture=None, narrow=True)
                try:
                    for index, step in enumerate(report["steps"], start=1):
                        mobile.publish(step, index)
                    mobile.check(report["browser"])
                finally:
                    mobile.context.close()
                report["presenter"] = {"offlineAfterLoad": True, "narrowViewportWidth": 390, "visibleStageCount": 7,
                                       "apiOrWriteRequests": 0, "browserStorageEntries": 0}
                report["withinTarget"] = report["steps"][-1]["elapsedSeconds"] <= TARGET_SECONDS
                report["complete"] = True
            except BaseException:
                try:
                    emit("failed")
                except Exception:
                    pass
                raise
            finally:
                try:
                    if args.headed and presenter and report["complete"]:
                        # Window stays long enough to see the verified summary. This is not part of the measured drill.
                        # Use the launcher clock; a backgrounded browser page can throttle its timers.
                        time.sleep(10)
                finally:
                    try:
                        if args.headed and presenter:
                            cleanup = presenter.close()
                            if "presenter" in report:
                                report["presenter"]["viewerCleanup"] = cleanup
                    finally:
                        close_owned_browser(browser)


@contextmanager
def capture_directory(path):
    if path is None:
        yield None
        return
    parent = demo.output_directory(path.parent)
    try:
        if path.name in ("", ".", ".."):
            raise ValueError("capture directory must be a new named directory")
        os.mkdir(path.name, mode=0o700, dir_fd=parent)
        descriptor = os.open(path.name, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW, dir_fd=parent)
        try:
            yield descriptor
        finally:
            os.close(descriptor)
    finally:
        os.close(parent)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project", default="tpp-portfolio-demo", help="already-running demo.py project")
    parser.add_argument("--base-url", default="http://127.0.0.1:38080", help="numeric loopback app origin")
    parser.add_argument("--channel", default="chrome", choices=("chrome", "chromium"))
    parser.add_argument("--headed", action="store_true", help="show the browser presentation during the real drill")
    parser.add_argument("--output", type=Path, help="exclusive private JSON report, by default in benchmark-results")
    parser.add_argument("--capture-dir", type=Path, help="new directory for redacted presenter stage captures")
    args = parser.parse_args(argv)
    try:
        args.project = project_name(args.project)
        args.base_url = numeric_origin(args.base_url)
        output = args.output or ROOT / "benchmark-results" / f"failure-drill-{uuid.uuid4().hex}.json"
        if output.suffix != ".json":
            raise ValueError("output must be a new .json file")
        directory = demo.output_directory(output.parent)
        try:
            descriptor = demo.regular_output(directory, output.name, os.O_WRONLY | os.O_CREAT | os.O_EXCL)
        finally:
            os.close(directory)
    except (ValueError, OSError, RuntimeError) as error:
        parser.error(str(error))
    report = {"complete": False, "project": args.project, "startedAt": stamp(),
              "targetSecondsAfterStartup": TARGET_SECONDS, "steps": [],
              "launcherSha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
              "scope": "One 7-FIC demo transfer. A real Kafka stop and start of the same owned container."}
    try:
        with capture_directory(args.capture_dir) as capture:
            live_drill(args, report, capture)
    except (Exception, KeyboardInterrupt) as error:
        report["complete"] = False
        report["error"] = {"type": type(error).__name__,
                           "afterStage": next((step["stage"] for step in reversed(report["steps"])
                                               if step["stage"] != "failed"), None)}
        if isinstance(error, DrillError):
            message = str(error)
        elif isinstance(error, (ImportError, ModuleNotFoundError)):
            message = "Install Playwright and use an installed Chrome channel."
        else:
            message = "A drill assertion or dependency did not complete. Check the last stage and original broker health."
        print(message, file=sys.stderr)
    finally:
        report["finishedAt"] = stamp()
        with os.fdopen(descriptor, "w", encoding="utf-8") as stream:
            stream.write(json.dumps(report, indent=2) + "\n")
        print(f"Evidence: {output}", flush=True)
    return 0 if report["complete"] else 1


def interrupt(_signal, _frame):
    raise KeyboardInterrupt


if __name__ == "__main__":
    signal.signal(signal.SIGTERM, interrupt)
    raise SystemExit(main())
