"""Real browser portion of the owned Kafka outage / lost-response drill.

The caller owns preflight, the already-stopped broker, the Browser, and final
broker restoration. This helper never starts Docker or emits a receipt/key.
``baseline`` is the unchanged ``verify-browser-demo.ReadOnlyHttp.snapshot()``
mapping captured before the outage: Alice/Bob -> balance, ledger, activity.
"""

import hashlib
import json
from pathlib import Path
import tempfile
import time
import uuid


def _require(condition, message):
    if not condition:
        raise AssertionError(message)


def _effects(verifier, baseline, current, transfer_id=None, event_id=None, projected=False):
    """Check independent account histories; return the single new signed pair."""
    rows = {}
    for account, delta in ((verifier.ALICE, -7), (verifier.BOB, 7)):
        before, after = baseline[account], current[account]
        _require(after["balance"] == before["balance"] + delta,
                 "the drill changed a balance beyond its single seven-FIC transfer")
        _require(all(after["ledger"].get(identity) == row
                     for identity, row in before["ledger"].items()),
                 "the drill changed existing ledger history")
        added = [row for identity, row in after["ledger"].items()
                 if identity not in before["ledger"]]
        _require(len(added) == 1 and added[0]["accountId"] == account
                 and added[0]["delta"] == delta,
                 "the drill did not create exactly one signed posting per account")
        if transfer_id is not None:
            _require(added[0]["transferId"] == transfer_id,
                     "the posting identity changed during receipt recovery")
        rows[account] = added[0]
        _require(all(after["activity"].get(identity) == row
                     for identity, row in before["activity"].items()),
                 "the drill changed existing account activity")
        activity = [row for identity, row in after["activity"].items()
                    if identity not in before["activity"]]
        _require(len(activity) == (1 if projected else 0),
                 "the drill produced an unexpected number of account activity effects")
        if projected:
            _require(activity[0]["transferId"] == transfer_id
                     and activity[0]["eventId"] == event_id
                     and activity[0]["deltaMinor"] == delta,
                     "projection did not preserve the same transfer/event and signed amount")
    _require(len({row["transferId"] for row in rows.values()}) == 1,
             "the independently observed debit and credit belong to different transfers")
    return rows


def _pending(value, transfer_id, event_id=None):
    _require(value["transferId"] == transfer_id and value["transferStatus"] == "COMPLETED"
             and value["deliveryState"] == "AWAITING_PUBLICATION"
             and value["event"]["publicationStatus"] in ("PENDING", "CLAIMED"),
             "the stopped broker did not leave the committed transfer awaiting publication")
    if event_id is not None:
        _require(value["event"]["eventId"] == event_id,
                 "delivery changed the original committed event identity")


def exercise(browser, verifier, watch, http, base, baseline, restore_broker, emit):
    """Exercise one new seven-FIC browser intent, followed by one explicit replay.

    ``verifier`` and ``watch`` are the loaded existing browser/watch verifier
    modules. ``emit(stage, safe_details)`` receives only the four documented
    public stages. ``restore_broker()`` starts the same caller-owned broker;
    the caller must also restore it from its outer finally on every failure.
    All Playwright waits and HTTP helpers are bounded. The caller closes Browser.
    """
    host, port = verifier.local_origin(base)
    _require(base == f"http://{host}:{port}", "the drill needs a canonical numeric loopback origin")
    _require(set(baseline) == {verifier.ALICE, verifier.BOB}
             and baseline[verifier.ALICE]["balance"] >= 7,
             "the drill baseline is missing the funded fictional account pair")
    contexts, page_posts, failures, script_errors = [], [], [], []

    def new_session(label):
        context = browser.new_context(viewport={"width": 1365, "height": 1000},
                                      service_workers="allow")
        contexts.append(context)
        context.add_init_script(verifier.OBSERVER)
        page = context.new_page()
        page.set_default_timeout(25000)
        page.on("pageerror", lambda error: script_errors.append(str(error)))

        def request_seen(request):
            if request.method == "POST":
                page_posts.append({"session": label, "transfer": request.url == base + "/api/transfers"})

        def request_failed(request):
            if request.method == "POST":
                failures.append({"session": label, "failure": request.failure,
                                 "transfer": request.url == base + "/api/transfers"})

        page.on("request", request_seen)
        page.on("requestfailed", request_failed)
        _require(page.goto(base + "/demo/index.html").status == 200,
                 "the owned transfer demo is unavailable")
        return context, page

    def safe_stage(transfer_id, event_id, postings, delivery):
        return {"transferId": transfer_id, "eventId": event_id,
                "httpStatus": 201, "deliveryState": delivery["deliveryState"],
                "publicationStatus": delivery["event"]["publicationStatus"],
                "postingIds": [posting["entryId"] for posting in postings],
                "sourceDelta": -7, "destinationDelta": 7}

    try:
        source_context, source = new_session("initial")
        _require(verifier.storage_snapshot(source) == {} and not page_posts,
                 "the initial browser session did not begin with empty receipt storage")
        source.locator("#submit-form").wait_for(state="visible")
        source.wait_for_function("""() => !document.querySelector('#drop-response').disabled
          && navigator.serviceWorker.controller?.scriptURL.endsWith('/demo/delivery-worker.js')""")
        _require(not source.locator("#drop-response").is_checked(), "response loss was already armed")
        source.locator("#direction").select_option("alice-to-bob")
        source.locator("#amount").fill("7")
        source.locator("#drop-response").check()
        source.locator("#submit-transfer").click()
        verifier.wait_receipt(source, "UNKNOWN")
        source.wait_for_function("""() => window.__tppVerification.workerMessages
          .some(message => message.type === 'tpp-response-dropped' && message.status === 201)""")
        lost_observation = verifier.observation(source)
        _require(len(lost_observation["posts"]) == 1 and len(page_posts) == 1
                 and page_posts[0] == {"session": "initial", "transfer": True},
                 "the lost response triggered another browser submission")
        lost = lost_observation["posts"][0]
        lost_intent = verifier.intent(lost)
        _require(lost_intent["status"] is None and lost_intent["error"] == "TypeError"
                 and lost_intent["dropHeader"] == "1"
                 and lost_observation["workerMessages"] == [{"type": "tpp-response-dropped", "status": 201}]
                 and failures == [{"session": "initial", "failure": "net::ERR_FAILED", "transfer": True}],
                 "the page did not lose the one real committed HTTP 201 through its service worker")
        _require(source.locator("#submit-transfer").is_disabled()
                 and source.locator("#resume-transfer").is_enabled()
                 and source.locator("#lookup-id").input_value() == "",
                 "the ambiguous UI did not require an explicit recovery action")
        saved = verifier.saved_receipt(source)
        source_receipt = json.loads(saved)
        _require(source_receipt["state"] == "UNKNOWN"
                 and source_receipt["idempotencyKey"] == lost["key"]
                 and source_receipt["payload"] == json.loads(lost["body"]),
                 "the persisted unknown receipt changed its original intent")

        committed = http.snapshot()
        original_rows = _effects(verifier, baseline, committed)
        transfer_id = str(uuid.UUID(original_rows[verifier.ALICE]["transferId"]))
        original_proof = verifier.proof_for_committed_transfer(http, transfer_id, original_rows)
        pending_before_replay = http.get(f"/internal/transfers/{transfer_id}/delivery")
        _pending(pending_before_replay, transfer_id)
        event_id = str(uuid.UUID(pending_before_replay["event"]["eventId"]))
        postings = [{"entryId": str(original_rows[account]["id"]), "delta": delta, "role": role}
                    for account, delta, role in ((verifier.ALICE, -7, "SOURCE"),
                                                (verifier.BOB, 7, "DESTINATION"))]
        emit("reply-lost", {**safe_stage(transfer_id, event_id, postings, pending_before_replay),
                            "browserState": "UNKNOWN", "initialBrowserPostCount": 1,
                            "upstream201ConfirmedByWorker": True, "ledgerObservedBeforeReplay": True})

        source.reload()
        verifier.wait_receipt(source, "UNKNOWN")
        _require(verifier.saved_receipt(source) == saved
                 and not verifier.observation(source)["posts"] and len(page_posts) == 1,
                 "reloading the unknown receipt changed or automatically resubmitted it")
        source_storage = verifier.storage_snapshot(source)
        with tempfile.TemporaryDirectory(prefix="tpp-failure-drill-receipt-") as directory:
            private_path = Path(directory) / "recovery.json"
            with source.expect_download() as downloaded:
                source.locator("#download-receipt").click()
            downloaded.value.save_as(private_path)
            private_path.chmod(0o600)
            _require(private_path.stat().st_size <= 4096, "the portable receipt exceeded its size bound")
            receipt_bytes = private_path.read_bytes()
            portable = json.loads(receipt_bytes)
            fields = {"kind", "version", "endpoint", "idempotencyKey", "payload", "createdAt"}
            _require(isinstance(portable, dict) and set(portable) == fields
                     and portable["kind"] == "tpp.transfer-lab-recovery"
                     and type(portable["version"]) is int and portable["version"] == 1
                     and portable["endpoint"] == base and portable["idempotencyKey"] == lost["key"]
                     and portable["payload"] == json.loads(lost["body"])
                     and portable["createdAt"] == source_receipt["createdAt"],
                     "the real downloaded receipt changed the private intent or included an authoritative result")
            _require(verifier.storage_snapshot(source) == source_storage
                     and not verifier.observation(source)["posts"] and len(page_posts) == 1,
                     "downloading the receipt mutated or resubmitted the unknown intent")
            source_context.close()
            contexts.remove(source_context)

            recovery_context, recovery = new_session("recovery")
            recovery.wait_for_function("() => !document.querySelector('#import-receipt').disabled")
            _require(verifier.storage_snapshot(recovery) == {} and len(page_posts) == 1,
                     "the independent recovery session did not begin without a saved receipt")
            recovery.locator("#import-receipt").set_input_files(str(private_path))
            recovery.wait_for_function("""() => document.querySelector('#import-receipt').value === ''
              && document.querySelector('#portable-receipt-message').dataset.state === 'positive'""")
            verifier.wait_receipt(recovery, "UNRESOLVED")
            imported = json.loads(verifier.saved_receipt(recovery))
            _require(imported["state"] == "UNRESOLVED" and imported["result"] is None
                     and all(imported[field] == portable[field]
                             for field in ("version", "endpoint", "idempotencyKey", "payload", "createdAt"))
                     and not verifier.observation(recovery)["posts"] and len(page_posts) == 1,
                     "import trusted a result, changed the original intent, or submitted a request")
            imported_storage = verifier.storage_snapshot(recovery)
            recovery.reload()
            verifier.wait_receipt(recovery, "UNRESOLVED")
            _require(verifier.storage_snapshot(recovery) == imported_storage
                     and not verifier.observation(recovery)["posts"] and len(page_posts) == 1
                     and recovery.locator("#submit-transfer").is_disabled()
                     and recovery.locator("#resume-transfer").is_enabled(),
                     "reloading the imported receipt changed it or bypassed explicit resume")

        recovery.locator("#resume-transfer").click()
        verifier.wait_receipt(recovery, "COMPLETED")
        replayed = verifier.observation(recovery)["posts"]
        _require(len(replayed) == 1 and len(page_posts) == 2
                 and page_posts[-1] == {"session": "recovery", "transfer": True},
                 "explicit recovery made more than one browser replay")
        replay = replayed[0]
        _require(replay["key"] == lost["key"] and replay["body"] == lost["body"]
                 and replay["drop"] is None and replay["status"] == 200
                 and replay.get("replayed") == "true"
                 and recovery.locator("#transfer-id").inner_text().strip() == transfer_id
                 and json.loads(verifier.saved_receipt(recovery))["result"]["id"] == transfer_id,
                 "the unchanged portable intent did not replay the original transfer as HTTP 200")
        _require(http.snapshot() == committed
                 and http.get(f"/internal/transfers/{transfer_id}/ledger-proof") == original_proof,
                 "receipt replay changed a balance, physical posting, or preexisting history")
        pending_after_replay = http.get(f"/internal/transfers/{transfer_id}/delivery")
        _pending(pending_after_replay, transfer_id, event_id)
        emit("receipt-recovered", {**safe_stage(transfer_id, event_id, postings, pending_after_replay),
                                   "replayHttpStatus": 200, "sameIntent": True,
                                   "freshContext": True, "ledgerUnchanged": True, "importPostCount": 0})

        _require(recovery.locator("#lookup-id").input_value() == transfer_id,
                 "recovery did not select the original transfer for delivery inspection")
        delivery_url = base + f"/internal/transfers/{transfer_id}/delivery"
        with recovery.expect_response(lambda response: response.url == delivery_url) as response:
            recovery.locator("#lookup-transfer").click()
        recovery.wait_for_function("() => document.querySelector('#delivery-state').textContent === 'AWAITING_PUBLICATION'")
        verifier.check_proof_panel(recovery, original_proof)
        browser_pending = response.value.json()
        _pending(browser_pending, transfer_id, event_id)
        pending_raw, pending_observation = watch.download_observation(recovery)
        watch.validate_observation(pending_observation, transfer_id, browser_pending, original_proof, lost["key"], base)
        _require(len(page_posts) == 2 and len(verifier.observation(recovery)["posts"]) == 1,
                 "delivery inspection or observation download submitted another intent")
        emit("delivery-pending", {**safe_stage(transfer_id, event_id, postings, browser_pending),
                                  "replayHttpStatus": 200,
                                  "attemptCount": browser_pending["event"]["attemptCount"],
                                  "lastErrorCode": browser_pending["event"]["lastErrorCode"]})

        recovery.locator("#watch-start").click()
        recovery.locator("#watch-status[data-watch-state='watching']").wait_for()
        started = time.monotonic()
        restore_broker()
        remaining_ms = int((55 - (time.monotonic() - started)) * 1000)
        _require(remaining_ms > 0, "broker restoration exhausted the bounded follow window")
        recovery.locator("#watch-status[data-watch-state='settled']").wait_for(timeout=remaining_ms)
        elapsed = time.monotonic() - started
        _require(elapsed < 55 and recovery.locator("#watch-stop").is_disabled(),
                 "the automatic follow exceeded its bounded window or left a timer running")
        final_delivery = http.get(f"/internal/transfers/{transfer_id}/delivery")
        _require(final_delivery["transferId"] == transfer_id and final_delivery["transferStatus"] == "COMPLETED"
                 and final_delivery["deliveryState"] == "PROJECTED"
                 and final_delivery["event"]["publicationStatus"] == "PUBLISHED"
                 and final_delivery["event"]["eventId"] == event_id,
                 "broker restoration did not publish and project the same committed event")
        _require(http.get(f"/internal/transfers/{transfer_id}/ledger-proof") == original_proof,
                 "broker recovery changed the original physical ledger proof")
        verifier.check_proof_panel(recovery, original_proof)
        final_rows = _effects(verifier, baseline, http.snapshot(), transfer_id, event_id, projected=True)
        _require(final_rows == original_rows, "recovery replaced the original signed ledger postings")
        settled_raw, settled_observation = watch.download_observation(recovery)
        watch.validate_observation(settled_observation, transfer_id, final_delivery, original_proof, lost["key"], base)
        _require(len(page_posts) == 2 and len(verifier.observation(recovery)["posts"]) == 1
                 and len(failures) == 1 and not script_errors,
                 "following or export caused another browser write, network failure, or script error")
        emit("delivery-projected", {**safe_stage(transfer_id, event_id, postings, final_delivery),
                                    "replayHttpStatus": 200, "samePhysicalPostings": True,
                                    "activityEffectPerAccount": 1})
        comparison = watch.compare_observations(browser, base, transfer_id, pending_raw, settled_raw)
        ledger_reconciliation = http.get("/internal/reconciliation")
        events_reconciliation = http.get("/internal/events/reconciliation")
        _require(ledger_reconciliation["consistent"] is True
                 and events_reconciliation["discrepancies"] == 0
                 and events_reconciliation["missingProjection"] == 0,
                 "the completed drill did not reconcile its financial and event effects")
        return {
            "transferId": transfer_id, "eventId": event_id,
            "httpStatus": 201, "replayHttpStatus": 200,
            "deliveryState": "PROJECTED", "publicationStatus": "PUBLISHED",
            "ledger": {"proofState": "BALANCED_PAIR", "amount": 7, "unit": "FIC",
                       "postings": postings, "sourceDelta": -7, "destinationDelta": 7,
                       "observedBeforeReplay": True, "unchangedAcrossReplayAndRecovery": True,
                       "existingHistoryPreserved": True, "activityEffectPerAccount": 1},
            "receipt": {"downloadSha256": hashlib.sha256(receipt_bytes).hexdigest(),
                        "keySha256": hashlib.sha256(lost["key"].encode()).hexdigest(),
                        "sourceContextClosedBeforeImport": True, "independentContextInitiallyEmpty": True,
                        "unknownReceiptSurvivedReload": True, "importedState": "UNRESOLVED",
                        "noAuthoritativeResultImported": True, "importPostCount": 0, "reloadPostCount": 0},
            "replyLoss": {"upstreamHttpStatus": 201, "pageHttpStatus": None,
                          "browserState": "UNKNOWN", "workerConfirmedNew201": True,
                          "browserFailure": "net::ERR_FAILED", "automaticRetryCount": 0},
            "observations": {"pending": pending_observation, "settled": settled_observation,
                             "pendingSha256": hashlib.sha256(pending_raw).hexdigest(),
                             "settledSha256": hashlib.sha256(settled_raw).hexdigest()},
            "comparison": comparison,
            "browser": {"initialPostCount": 1, "replayPostCount": 1, "totalPostCount": 2,
                        "logicalTransferCount": 1, "networkFailureCount": 1,
                        "followSettledAfterSeconds": round(elapsed, 3), "scriptErrors": []},
            "reconciliation": {"ledgerConsistent": True, "eventDiscrepancies": 0, "missingProjection": 0},
        }
    finally:
        for context in reversed(contexts):
            context.close()
