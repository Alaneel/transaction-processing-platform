#!/usr/bin/env python3
"""Check an already-running local transfer lab with a real Chromium browser.

Requires Playwright and a browser installation. Commits exactly two fresh 7-FIC
transfers through the UI and resumes one lost response. Never starts Docker,
seeds accounts, clears history, or retries automatically after a failed check.
"""

import argparse
import datetime
import hashlib
import http.client
import ipaddress
import json
import os
from pathlib import Path
import re
import sys
import tempfile
import time
from urllib.parse import urlsplit
import uuid

ALICE = "00000000-0000-0000-0000-000000000002"
BOB = "00000000-0000-0000-0000-000000000003"
ISSUANCE = "00000000-0000-0000-0000-000000000001"
RECEIPT_KEY = "tpp.transferLab.intent.v1"

# Observe native window.fetch without replacing responses or changing transport.
# The worker separately confirms that its real upstream response was HTTP 201.
OBSERVER = r"""
(() => {
  const observed = {posts: [], workerMessages: []};
  Object.defineProperty(window, '__tppVerification', {value: observed});
  navigator.serviceWorker?.addEventListener('message', event => {
    if (event.data?.type === 'tpp-response-dropped' && observed.workerMessages.length < 8)
      observed.workerMessages.push({type: event.data.type, status: event.data.status});
  });
  const original = window.fetch;
  window.fetch = async function(input, init) {
    const url = new URL(typeof input === 'string' ? input : input.url, location.href);
    const method = String(init?.method || input?.method || 'GET').toUpperCase();
    let record;
    if (url.origin === location.origin && url.pathname === '/api/transfers' && method === 'POST') {
      if (observed.posts.length >= 16) throw new Error('Verification observed too many submissions');
      const headers = new Headers(init?.headers || input?.headers);
      record = {key: headers.get('Idempotency-Key'), body: init?.body,
        drop: headers.get('X-TPP-Demo-Drop-Response'), status: null, error: null};
      observed.posts.push(record);
    }
    try {
      const response = await original.apply(this, arguments);
      if (record) {
        record.status = response.status;
        record.replayed = response.headers.get('Idempotency-Replayed');
      }
      return response;
    } catch (error) {
      if (record) record.error = error?.name || 'Error';
      throw error;
    }
  };
})();
"""


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def utc_now():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def local_origin(value):
    parsed = urlsplit(value)
    try:
        address = ipaddress.ip_address(parsed.hostname or "")
        port = parsed.port
    except ValueError as error:
        raise ValueError("base URL must have a numeric loopback host and valid port") from error
    if (parsed.scheme != "http" or str(address) != "127.0.0.1"
            or not port or parsed.username or parsed.password
            or parsed.path not in ("", "/") or parsed.query or parsed.fragment):
        raise ValueError("base URL must be http://127.0.0.1:PORT without credentials or a path")
    return parsed.hostname, port


class ReadOnlyHttp:
    def __init__(self, host, port):
        self.host, self.port = host, port

    def get(self, path):
        require(path.startswith("/") and not path.startswith("//"), "invalid local read path")
        connection = http.client.HTTPConnection(self.host, self.port, timeout=5)
        try:
            connection.request("GET", path, headers={"Accept": "application/json"})
            response = connection.getresponse()
            body = response.read(1024 * 1024 + 1)
            require(len(body) <= 1024 * 1024, "HTTP evidence exceeded the response bound")
            require(response.status == 200, f"GET {path}: expected 200, got {response.status}")
            return json.loads(body)
        finally:
            connection.close()

    def entries(self, account, activity=False):
        cursor, result = 0, {}
        suffix, field, next_field = ("activity", "entries", "nextAfter") if activity else (
            "ledger", "items", "nextCursor")
        for _ in range(50):
            page = self.get(f"/api/accounts/{account}/{suffix}?after={cursor}&limit=100")
            for row in page[field]:
                identity = row["id"]
                require(type(identity) is int and identity > cursor and identity not in result,
                        "pagination repeated or reordered an existing entry")
                result[identity] = row
            following = page[next_field]
            if following is None:
                return result
            require(type(following) is int and following > cursor, "pagination did not advance")
            cursor = following
        raise AssertionError("account history exceeded the bounded 5,000-entry inspection")

    def snapshot(self):
        return {account: {
            "balance": self.get(f"/api/accounts/{account}/balance")["amount"],
            "ledger": self.entries(account), "activity": self.entries(account, activity=True),
        } for account in (ALICE, BOB)}


def await_projected(http, transfer, timeout):
    deadline = time.monotonic() + timeout
    while True:
        progress = http.get(f"/internal/transfers/{transfer}/delivery")
        require(progress["transferId"] == transfer and progress["transferStatus"] == "COMPLETED",
                "delivery lookup changed the committed transfer identity or decision")
        if progress["deliveryState"] == "PROJECTED":
            require(progress["event"]["processedAt"] and progress["event"]["projectedAt"],
                    "projected timestamps are missing")
            return progress
        require(progress["deliveryState"] not in ("BLOCKED", "INCONSISTENT"),
                "delivery reached a blocked or inconsistent state")
        require(time.monotonic() < deadline, "transfer projection did not converge before its deadline")
        time.sleep(min(0.1, max(0, deadline - time.monotonic())))


def fixture_gate(http, timeout):
    require(http.get("/actuator/health/readiness")["status"] == "UP", "application is not ready")
    funding_progress = []
    for account, suffix in ((ALICE, "2"), (BOB, "3")):
        value = http.get(f"/api/accounts/{account}")
        require(value["id"] == account and value["status"] == "ACTIVE" and value["unit"] == "FIC",
                "selected origin does not contain the expected active FIC demo accounts")
        identity = f"10000000-0000-0000-0000-00000000000{suffix}"
        funding = http.get(f"/api/transfers/{identity}")
        require(funding["status"] == "COMPLETED" and funding["sourceAccountId"] == ISSUANCE
                and funding["destinationAccountId"] == account and funding["amount"] == 1000000
                and funding["unit"] == "FIC", "selected origin does not match the seeded demo history")
        funding_progress.append(await_projected(http, identity, timeout))
    ledger = http.get("/internal/reconciliation")
    require(ledger["consistent"] is True, "fixture ledger is inconsistent")
    return {"ready": "UP", "accounts": [ALICE, BOB], "funding": funding_progress}


def observation(page):
    return page.evaluate("window.__tppVerification")


def saved_receipt(page):
    raw = page.evaluate("key => localStorage.getItem(key)", RECEIPT_KEY)
    require(isinstance(raw, str), "browser did not persist its request receipt")
    return raw


def wait_receipt(page, state):
    page.wait_for_function(
        """({key, state}) => {
          const receipt = JSON.parse(localStorage.getItem(key) || 'null');
          const tone = state === 'COMPLETED' ? 'positive' : 'unknown';
          return receipt?.state === state &&
            document.querySelector('#receipt-state')?.dataset.state === tone;
        }""", arg={"key": RECEIPT_KEY, "state": state})


def intent(post):
    expected = {"sourceAccountId": ALICE, "destinationAccountId": BOB, "amount": 7, "unit": "FIC"}
    require(isinstance(post.get("key"), str) and post["key"], "browser omitted its idempotency key")
    require(json.loads(post["body"]) == expected, "browser submitted a different transfer intent")
    return {"keySha256": hashlib.sha256(post["key"].encode()).hexdigest(), "payload": expected,
            "status": post["status"], "replayed": post.get("replayed"), "error": post["error"],
            "dropHeader": post["drop"]}


def layout(page):
    dimensions = page.evaluate("({viewport: innerWidth, content: document.documentElement.scrollWidth})")
    require(dimensions["content"] <= dimensions["viewport"] + 1, "demo overflows its viewport")
    return dimensions


def screenshot(page, args, label, report):
    if not args.screenshots:
        return
    parent = args.screenshots.resolve(strict=True)
    path = parent / (args.output.stem + "-" + label + ".png")
    # The UI shows its request key; do not publish that key in retained screenshots.
    data = page.screenshot(full_page=True, mask=[page.locator("#receipt-key")])
    descriptor = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW, 0o600)
    with os.fdopen(descriptor, "wb") as stream:
        stream.write(data)
    report.setdefault("screenshots", []).append({
        "state": label, "path": str(path), "sha256": hashlib.sha256(data).hexdigest(),
    })


def proof_for_committed_transfer(http, transfer_id, ledger_by_account):
    proof = http.get(f"/internal/transfers/{transfer_id}/ledger-proof")
    require((proof["transferId"], proof["transferStatus"], proof["proofState"])
            == (transfer_id, "COMPLETED", "BALANCED_PAIR"), "proof did not confirm the original transfer")
    require((proof["sourceAccountId"], proof["destinationAccountId"], proof["amount"], proof["unit"])
            == (ALICE, BOB, 7, "FIC"), "proof changed the committed transfer intent")
    expected = {account: (str(row["id"]), row["delta"]) for account, row in ledger_by_account.items()}
    actual = {row["accountId"]: (row["entryId"], row["delta"]) for row in proof["postings"]}
    require(len(proof["postings"]) == 2 and actual == expected,
            "proof did not match the independent account ledgers")
    return proof


def observe_lost_transfer_before_replay(http, before, normal_id):
    ledger_by_account = {}
    for account, delta in ((ALICE, -7), (BOB, 7)):
        after = http.entries(account)
        require(all(after.get(identity) == row for identity, row in before[account]["ledger"].items()),
                "existing ledger history changed before replay")
        added = [row for identity, row in after.items() if identity not in before[account]["ledger"]]
        require(len(added) == 2 and all(
            (row["accountId"], row["delta"]) == (account, delta) for row in added)
                and sum(row["transferId"] == normal_id for row in added) == 1,
                "lost response did not leave just one new committed effect per account before replay")
        ledger_by_account[account] = next(row for row in added if row["transferId"] != normal_id)
    transfer_ids = {row["transferId"] for row in ledger_by_account.values()}
    require(len(transfer_ids) == 1, "lost transfer was not posted to both accounts before replay")
    return ledger_by_account, proof_for_committed_transfer(http, transfer_ids.pop(), ledger_by_account)


def check_proof_panel(page, proof):
    page.wait_for_function(
        "() => document.querySelector('#proof-state')?.dataset.proofState === 'BALANCED_PAIR'")
    require(page.locator("#proof-transfer-id").inner_text() == proof["transferId"],
            "the panel did not identify the transfer scoped by the posting proof")
    rows = page.locator("#proof-postings .proof-posting")
    require(rows.count() == 2, "proof panel did not render exactly two posting rows")
    for posting in proof["postings"]:
        entry_id, delta = posting["entryId"], posting["delta"]
        row = page.locator(f'#proof-postings .proof-posting[data-entry-id="{entry_id}"]')
        require(row.count() == 1 and row.is_visible(), "a durable posting row is absent or hidden")
        text = " ".join(row.inner_text().replace("−", "-").split())
        require(re.search(rf"(?<![0-9]){entry_id}(?![0-9])", text) is not None
                and f"{delta:+d} FIC" in text and posting["accountId"] in text,
                "the panel did not show the real entry ID, account and signed amount")


def storage_snapshot(page):
    return page.evaluate("""Object.fromEntries(
      Object.keys(localStorage).sort().map(key => [key, localStorage.getItem(key)]))""")


def portable_recovery_context(browser, source_page, args, base, lost, saved, watch_errors):
    """Export through the UI and import in a separate session without submitting the receipt."""
    source_storage = storage_snapshot(source_page)
    with tempfile.TemporaryDirectory(prefix="tpp-portable-receipt-") as temporary:
        private_path = Path(temporary) / "recovery.json"
        with source_page.expect_download() as download:
            source_page.locator("#download-receipt").click()
        download.value.save_as(private_path)
        private_path.chmod(0o600)
        exported_bytes = private_path.read_bytes()
        require(len(exported_bytes) <= 4096, "downloaded recovery receipt exceeded its size limit")
        portable = json.loads(exported_bytes)
        fields = {"kind", "version", "endpoint", "idempotencyKey", "payload", "createdAt"}
        require(isinstance(portable, dict) and set(portable) == fields,
                "portable download contains missing or authoritative receipt fields")
        source_receipt = json.loads(saved)
        require(portable["kind"] == "tpp.transfer-lab-recovery"
                and type(portable["version"]) is int and portable["version"] == 1
                and portable["endpoint"] == base and portable["idempotencyKey"] == lost["key"]
                and portable["payload"] == json.loads(lost["body"])
                and portable["createdAt"] == source_receipt["createdAt"],
                "portable download changed the saved request identity")
        require(storage_snapshot(source_page) == source_storage
                and not observation(source_page)["posts"],
                "downloading the receipt changed storage or submitted a request")
        # Closing the source session proves recovery does not rely on its storage or live page.
        source_page.context.close()

        recovery_context = browser.new_context(
            viewport={"width": 1365, "height": 1000}, service_workers="allow")
        recovery_context.add_init_script(OBSERVER)
        recovery_page = recovery_context.new_page()
        recovery_page.set_default_timeout(args.timeout * 1000)
        watch_errors(recovery_page)
        actual_posts = []
        recovery_page.on("request", lambda request: actual_posts.append(request.url)
                         if request.method == "POST" else None)
        require(recovery_page.goto(base + "/demo/index.html").status == 200,
                "fresh recovery session could not open the demo")
        recovery_page.wait_for_function(
            "() => document.querySelector('#import-receipt') && !document.querySelector('#import-receipt').disabled")
        require(storage_snapshot(recovery_page) == {} and not actual_posts,
                "independent browser context did not start with empty local storage")

        def import_file(upload, tone, preserve=True):
            previous = storage_snapshot(recovery_page)
            recovery_page.locator("#import-receipt").set_input_files(upload)
            # Finally clears the input, preventing a stale message from satisfying this wait.
            recovery_page.wait_for_function("""tone => {
              const input = document.querySelector('#import-receipt');
              return input && input.value === ''
                && document.querySelector('#portable-receipt-message')?.dataset.state === tone;
            }""", arg=tone)
            require(not actual_posts and not observation(recovery_page)["posts"],
                    "importing a file submitted a transfer instead of requiring explicit resume")
            if preserve:
                require(storage_snapshot(recovery_page) == previous,
                        "a blocked or same-intent import replaced existing local storage")

        def upload(name, value):
            data = value if isinstance(value, bytes) else json.dumps(value).encode()
            return {"name": name + ".json", "mimeType": "application/json", "buffer": data}

        # This is a different browser origin but the same owned app port, not another service.
        wrong_origin = dict(portable, endpoint=base.replace("127.0.0.1", "localhost"))
        for name, value in (
                ("wrong-origin", wrong_origin),
                ("oversized", exported_bytes + b" " * (4097 - len(exported_bytes))),
                ("malformed", b'{"kind":')):
            import_file(upload(name, value), "negative")
        import_file(str(private_path), "positive", preserve=False)
        wait_receipt(recovery_page, "UNRESOLVED")
        imported = json.loads(saved_receipt(recovery_page))
        require(imported["state"] == "UNRESOLVED" and imported["result"] is None
                and all(imported[field] == portable[field]
                        for field in ("version", "endpoint", "idempotencyKey", "payload", "createdAt")),
                "portable import trusted a terminal result or changed the original intent")
        imported_storage = storage_snapshot(recovery_page)
        different = dict(portable, idempotencyKey="lab-" + str(uuid.uuid4()))
        import_file(upload("different-intent", different), "negative")
        import_file(str(private_path), "positive")
        require(storage_snapshot(recovery_page) == imported_storage,
                "same-intent import rewrote the pending local receipt")
        recovery_page.reload()
        wait_receipt(recovery_page, "UNRESOLVED")
        require(storage_snapshot(recovery_page) == imported_storage
                and not actual_posts and not observation(recovery_page)["posts"],
                "reloading the imported intent changed storage or automatically submitted it")
        require(recovery_page.locator("#submit-transfer").is_disabled()
                and recovery_page.locator("#resume-transfer").is_enabled(),
                "imported unresolved intent did not require explicit recovery")
        evidence = {
            "downloadSha256": hashlib.sha256(exported_bytes).hexdigest(),
            "downloadFields": sorted(fields), "kind": portable["kind"], "version": 1,
            "keySha256": hashlib.sha256(portable["idempotencyKey"].encode()).hexdigest(),
            "sourceStorageUnchanged": True, "sourceContextClosedBeforeImport": True,
            "independentContextInitiallyEmpty": True, "importedState": "UNRESOLVED",
            "noAuthoritativeResultImported": True, "importAndReloadPostCount": 0,
            "blockedImports": ["wrong-origin", "oversized", "malformed", "different-intent"],
            "blockedImportsPreservedAllStorage": True, "sameIntentImportWasNoOp": True,
            "privateTemporaryDownloadRemoved": True,
        }
        return recovery_context, recovery_page, evidence


def check_effects(http, before, report):
    after = http.snapshot()
    progress = {case["transferId"]: case["delivery"] for case in (
        report["normal"], report["lostResponse"])}
    effects = {}
    for account, delta in ((ALICE, -7), (BOB, 7)):
        require(after[account]["balance"] == before[account]["balance"] + 2 * delta,
                "balance changed beyond the two intended transfers")
        effects[account] = {"balanceBefore": before[account]["balance"],
                            "balanceAfter": after[account]["balance"]}
        for table, amount_field in (("ledger", "delta"), ("activity", "deltaMinor")):
            old, current = before[account][table], after[account][table]
            require(all(current.get(identity) == row for identity, row in old.items()),
                    f"existing {table} history changed")
            added = [row for identity, row in current.items() if identity not in old]
            require(len(added) == 2 and {row["transferId"] for row in added} == set(progress)
                    and all(row[amount_field] == delta and row["accountId"] == account for row in added),
                    f"{table} did not contain exactly one intended effect per transfer/account")
            if table == "activity":
                require(all(row["eventId"] == progress[row["transferId"]]["event"]["eventId"]
                            for row in added), "activity changed the stable event identity")
            effects[account][table] = added
    report["independentEffects"] = effects
    report["finalReconciliation"] = http.get("/internal/reconciliation")
    report["finalEventReconciliation"] = http.get("/internal/events/reconciliation")
    require(report["finalReconciliation"]["consistent"] is True, "final ledger is inconsistent")
    require(report["finalEventReconciliation"]["discrepancies"] == 0
            and report["finalEventReconciliation"]["missingProjection"] == 0,
            "final event reconciliation is inconsistent or has outstanding projections")


def run_browser(args, report, http, base):
    from playwright.sync_api import sync_playwright

    before = http.snapshot()
    require(before[ALICE]["balance"] >= 14, "Alice needs 14 FIC for the two bounded checks")
    require(all(len(before[account][table]) <= 4998 for account in (ALICE, BOB)
                for table in ("ledger", "activity")), "history needs room for two bounded new entries")
    with sync_playwright() as playwright:
        launch = {"headless": not args.headed}
        if args.channel:
            launch["channel"] = args.channel
        browser = playwright.chromium.launch(**launch)
        try:
            context = browser.new_context(viewport={"width": 1365, "height": 1000}, service_workers="allow")
            context.add_init_script(OBSERVER)
            page = context.new_page()
            page.set_default_timeout(args.timeout * 1000)
            console_errors, script_errors = [], []

            def watch_errors(target):
                target.on("console", lambda message: console_errors.append({
                    "text": message.text, "location": message.location,
                }) if message.type == "error" else None)
                target.on("pageerror", lambda error: script_errors.append(str(error)))

            watch_errors(page)
            failed_requests = []
            page.on("requestfailed", lambda request: failed_requests.append({
                "url": request.url, "method": request.method, "failure": request.failure,
            }) if request.url == base + "/api/transfers" else None)
            require(page.goto(base + "/demo/index.html").status == 200, "demo page is unavailable")
            page.locator("#submit-form").wait_for(state="visible")
            page.locator("#direction").select_option("alice-to-bob")
            page.locator("#amount").fill("7")
            require(not page.locator("#drop-response").is_checked(), "simulation starts armed")
            page.locator("#submit-transfer").click()
            wait_receipt(page, "COMPLETED")
            normal = observation(page)
            require(len(normal["posts"]) == 1, "normal submission made unexpected requests")
            require(not failed_requests, "normal submission reported an unexpected network failure")
            normal_intent = intent(normal["posts"][0])
            require(normal_intent["status"] == 201 and normal_intent["replayed"] == "false"
                    and normal_intent["dropHeader"] is None, "normal UI transfer did not commit once")
            first = page.locator("#transfer-id").inner_text().strip()
            require(json.loads(saved_receipt(page))["result"]["id"] == first,
                    "visible normal transfer differs from its durable browser receipt")
            require(page.locator("#lookup-id").input_value() == first,
                    "the normal transfer did not prefill its ID for delivery lookup")
            report["normal"] = {"transferId": first, "intent": normal_intent,
                                "delivery": await_projected(http, first, args.timeout)}
            page.wait_for_function("() => !document.querySelector('#drop-response').disabled && navigator.serviceWorker.controller?.scriptURL.endsWith('/demo/delivery-worker.js')")
            page.locator("#drop-response").check()
            page.locator("#submit-transfer").click()
            wait_receipt(page, "UNKNOWN")
            page.wait_for_function("() => window.__tppVerification.workerMessages.some(m => m.type === 'tpp-response-dropped' && m.status === 201)")
            require(page.locator("#lookup-id").input_value() == "",
                    "the unresolved transfer still displayed the previous prefilled ID")
            ambiguous = observation(page)
            require(len(ambiguous["posts"]) == 2, "lost response triggered an automatic retry")
            lost = ambiguous["posts"][-1]
            lost_intent = intent(lost)
            require(lost_intent["status"] is None and lost_intent["error"]
                    and lost_intent["dropHeader"] == "1", "page did not observe the real failed fetch")
            require(lost["key"] != normal["posts"][0]["key"], "new intent reused the prior key")
            require(len(failed_requests) == 1 and failed_requests[0]["method"] == "POST"
                    and failed_requests[0]["failure"] == "net::ERR_FAILED",
                    "browser did not report exactly the intentional failed POST")
            saved = saved_receipt(page)
            require(saved, "ambiguous intent was not durably saved before reload")
            original_rows, original_proof = observe_lost_transfer_before_replay(http, before, first)
            screenshot(page, args, "unknown", report)
            page.reload()
            wait_receipt(page, "UNKNOWN")
            require(saved_receipt(page) == saved,
                    "reload rewrote the unresolved saved intent")
            require(not observation(page)["posts"], "reload automatically submitted an intent")
            require(page.locator("#submit-transfer").is_disabled()
                    and page.locator("#resume-transfer").is_enabled(),
                    "unresolved receipt must offer resume and prevent a replacement submission")
            context, page, portable_evidence = portable_recovery_context(
                browser, page, args, base, lost, saved, watch_errors)
            report["portableReceipt"] = portable_evidence
            page.locator("#resume-transfer").click()
            wait_receipt(page, "COMPLETED")
            resumed = observation(page)
            require(len(resumed["posts"]) == 1, "resume made unexpected submission attempts")
            replay = resumed["posts"][0]
            replay_intent = intent(replay)
            require(replay["key"] == lost["key"] and replay["body"] == lost["body"]
                    and replay["drop"] is None and replay["status"] == 200
                    and replay.get("replayed") == "true", "resume did not replay the unchanged intent")
            second = page.locator("#transfer-id").inner_text().strip()
            require(first != second, "distinct intents returned the same transfer identity")
            require(second == original_proof["transferId"], "receipt recovered a different transfer than the ledger")
            require(json.loads(saved_receipt(page))["result"]["id"] == second,
                    "visible recovered transfer differs from its durable browser receipt")
            require(page.locator("#lookup-id").input_value() == second
                    and "Recovered the original committed transfer" in page.locator("#resume-message").inner_text(),
                    "the page did not identify the replay or prefill the recovered transfer ID")
            report["lostResponse"] = {"transferId": second, "intent": lost_intent,
                "workerProof": ambiguous["workerMessages"], "browserNetworkFailures": failed_requests,
                "receiptSurvivedReloadUnchanged": True, "reloadPostCount": 0,
                "replay": replay_intent, "delivery": await_projected(http, second, args.timeout)}
            report["portableReceipt"]["recoveredOriginalTransferId"] = second
            report["portableReceipt"]["replayStatus"] = replay["status"]
            page.locator("#lookup-id").fill(second)
            page.locator("#lookup-transfer").click()
            page.wait_for_function(
                "() => document.querySelector('#delivery-state')?.textContent === 'PROJECTED'")
            after_proof = proof_for_committed_transfer(http, second, original_rows)
            require(after_proof == original_proof, "replay changed the original durable posting evidence")
            check_proof_panel(page, after_proof)
            report["ledgerProof"] = {"unchangedAcrossReplay": True, "observedBeforeReplay": original_proof,
                                     "observedAfterReplay": after_proof}
            report["desktopLayout"] = layout(page)
            screenshot(page, args, "desktop-projected", report)

            unknown_id = str(uuid.uuid4())
            page.locator("#lookup-id").fill(unknown_id)
            require(page.locator("#proof-state").get_attribute("data-proof-state") is None
                    and page.locator("#proof-postings .proof-posting").count() == 0,
                    "editing the lookup to another ID retained stale posting evidence")
            missing_path = base + f"/internal/transfers/{unknown_id}/ledger-proof"
            with page.expect_response(lambda response: response.url == missing_path) as missing:
                page.locator("#lookup-transfer").click()
            require(missing.value.status == 404, "unrecognized transfer proof did not return HTTP 404")
            require(page.locator("#proof-state").get_attribute("data-proof-state") is None
                    and page.locator("#proof-postings .proof-posting").count() == 0,
                    "unknown lookup restored stale posting evidence")
            report["ledgerProof"]["unknownLookupClearedPreviousProof"] = True

            mobile = browser.new_context(viewport={"width": 390, "height": 844}, is_mobile=True,
                                         has_touch=True, service_workers="allow")
            mobile.add_init_script(OBSERVER)
            mobile_page = mobile.new_page()
            watch_errors(mobile_page)
            mobile_page.set_default_timeout(args.timeout * 1000)
            mobile_page.goto(base + "/demo/index.html")
            mobile_page.locator("#submit-form").wait_for(state="visible")
            mobile_page.locator("#lookup-id").fill(second)
            mobile_page.locator("#lookup-transfer").click()
            check_proof_panel(mobile_page, after_proof)
            report["mobileLayout"] = layout(mobile_page)
            require(not observation(mobile_page)["posts"], "mobile page load submitted a transfer")
            screenshot(mobile_page, args, "mobile", report)
            lost_console_errors = [entry for entry in console_errors
                if "net::ERR_FAILED" in entry["text"]
                and entry["location"].get("url") == base + "/api/transfers"]
            missing_urls = {missing_path, base + f"/internal/transfers/{unknown_id}/delivery"}
            missing_console_errors = [entry for entry in console_errors
                if "404" in entry["text"] and entry["location"].get("url") in missing_urls]
            unexpected_console_errors = [entry for entry in console_errors
                if entry not in lost_console_errors and entry not in missing_console_errors]
            report["browserErrors"] = {
                "intentionalLostResponse": lost_console_errors, "intentionalMissingLookup": missing_console_errors,
                "unexpectedConsole": unexpected_console_errors, "scriptErrors": script_errors,
            }
            require(not script_errors, "browser reported an unexpected page JavaScript error")
            require(not unexpected_console_errors, "browser reported an unexpected console error")
            mobile.close()
            context.close()
        finally:
            browser.close()
    check_effects(http, before, report)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--base-url", required=True)
    parser.add_argument("--output", type=Path, required=True, help="new JSON file; parent must exist")
    parser.add_argument("--screenshots-dir", "--screenshots", dest="screenshots", type=Path,
                        help="existing directory for private full-page PNGs")
    parser.add_argument("--channel", choices=("chrome", "chromium", "msedge"))
    parser.add_argument("--headed", action="store_true")
    parser.add_argument("--timeout", type=int, default=60)
    args = parser.parse_args()
    if not 10 <= args.timeout <= 180:
        parser.error("timeout must be within 10–180 seconds")
    try:
        host, port = local_origin(args.base_url)
        base = f"http://{host}:{port}"
        parent = args.output.parent.resolve(strict=True)
        if args.screenshots:
            require(args.screenshots.resolve(strict=True).is_dir(), "screenshots need an existing directory")
            for label in ("unknown", "desktop-projected", "mobile"):
                candidate = args.screenshots / (args.output.stem + "-" + label + ".png")
                require(not candidate.exists() and not candidate.is_symlink(),
                        "screenshot output already exists; choose a fresh report name")
        descriptor = os.open(parent / args.output.name,
                             os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW, 0o600)
    except (AssertionError, ValueError, OSError) as error:
        parser.error(str(error))
    report = {"startedAt": utc_now(), "baseUrl": base, "complete": False,
        "scriptSha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
              "scope": "Two fresh 7-FIC UI transfers, same-key replay, and scoped posting evidence before and after replay; no Docker operations",
        "limits": "Fixture identity uses local origin and seeded funding history. PostgreSQL row counts remain a separate operator check."}
    result = 1
    try:
        http = ReadOnlyHttp(host, port)
        report["fixtureGate"] = fixture_gate(http, args.timeout)
        run_browser(args, report, http, base)
        report["complete"] = True
        result = 0
    except Exception as error:
        report["error"] = {"type": type(error).__name__, "message": str(error)}
        print(f"Browser verification failed: {error}", file=sys.stderr)
    finally:
        report["finishedAt"] = utc_now()
        with os.fdopen(descriptor, "w", encoding="utf-8") as stream:
            json.dump(report, stream, indent=2)
            stream.write("\n")
    if result == 0:
        print(f"Browser verification passed; history retained. Evidence: {args.output}")
    return result


if __name__ == "__main__":
    raise SystemExit(main())
