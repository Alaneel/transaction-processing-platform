/* The saved intent survives an uncertain response. Delivery lookup is always read-only. */
(() => {
  "use strict";

  const STORAGE_KEY = "tpp.transferLab.intent.v1";
  const LOCK_NAME = "tpp.transferLab.intent";
  const WORKER_PATH = "/demo/delivery-worker.js";
  const TIMEOUT_MS = 10000;
  const WATCH_WINDOW_MS = 60000;
  const WATCH_INTERVAL_MS = 2000;
  const WATCH_REQUEST_MS = 4000;
  const WATCH_READ_LIMIT = 30;
  const MAX_BYTES = 65536;
  const PORTABLE_RECEIPT_KIND = "tpp.transfer-lab-recovery";
  const MAX_RECEIPT_FILE_BYTES = 4096;
  const HISTORY_PAGE_SIZE = 6;
  const ALICE = "00000000-0000-0000-0000-000000000002";
  const BOB = "00000000-0000-0000-0000-000000000003";
  const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
  const TERMINAL = new Set(["COMPLETED", "REJECTED"]);
  const RECEIPT_STATES = new Set(["UNRESOLVED", "UNKNOWN", "CONFLICT", ...TERMINAL]);
  const DELIVERY_STATES = new Set([
    "NOT_APPLICABLE", "AWAITING_PUBLICATION", "AWAITING_PROJECTION", "BLOCKED", "PROJECTED", "INCONSISTENT",
  ]);
  const PROOF_STATES = new Set(["BALANCED_PAIR", "NO_POSTINGS", "INCONSISTENT"]);
  const observation = globalThis.TransferLabDelivery;
  const ids = [
    "submit-form", "direction", "amount", "drop-response", "submit-transfer", "simulation-status",
    "submit-message", "receipt-state", "receipt-key", "receipt-summary", "resume-transfer", "resume-message",
    "transfer-id", "lookup-heading", "lookup-form", "lookup-id", "lookup-transfer", "lookup-message", "delivery-result",
    "download-receipt", "import-receipt", "portable-receipt-message",
    "ledger-state", "publication-state", "projection-state", "delivery-state", "event-id", "origin-message",
    "delivery-attempts", "delivery-error", "delivery-next-at", "delivery-observed-at",
    "delivery-published-at", "delivery-projected-at",
    "watch-start", "watch-stop", "watch-status", "download-observation", "observation-message",
    "proof-state", "proof-transfer-id", "proof-summary", "proof-postings",
    "history-status", "history-items", "history-refresh", "history-older",
  ];
  const ui = Object.fromEntries(ids.map((id) => [id, document.getElementById(id)]));
  if (ids.some((id) => !ui[id])) return;

  let local = false;
  let storageReady = false;
  let receiptInvalid = false;
  let current = null;
  let busy = false;
  let simulationReady = false;
  let observedWorker = null;
  let automaticLookup = "";
  let lookupVersion = 0;
  let deliverySeen = null;
  let ledgerSeen = null;
  let activeWatch = null;
  let historyVersion = 0;
  let historyLoading = false;
  let historyReadingOlder = false;
  let historyOnLatest = true;
  let historyNext = null;
  let historyDisplayed = false;

  function display(id, text, state = "") {
    ui[id].textContent = text;
    ui[id].dataset.state = state;
  }

  function resetProof(label = "Not loaded", message = "Check delivery to read this transfer’s ledger evidence.", state = "pending") {
    display("proof-state", label, state);
    delete ui["proof-state"].dataset.proofState;
    display("proof-transfer-id", "Not loaded");
    display("proof-summary", message);
    ui["proof-postings"].replaceChildren();
    ui["proof-postings"].hidden = true;
  }

  function clearLookupObservation() {
    lookupVersion += 1;
    deliverySeen = null;
    ledgerSeen = null;
    cancelWatch();
    ui["delivery-result"].hidden = true;
    resetDelivery();
    resetProof();
    watchStatus("idle", "Not following. Read delivery before starting.");
    display("observation-message", "Read delivery before downloading an observation.");
    updateControls();
  }

  function loopbackOrigin() {
    const host = location.hostname;
    const ipv4 = /^127\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.test(host)
      && host.split(".").every((part) => Number(part) <= 255);
    return ["http:", "https:"].includes(location.protocol)
      && (host === "localhost" || host === "[::1]" || host === "::1" || ipv4);
  }

  function validAmount(value) {
    return Number.isSafeInteger(value) && value >= 1 && value <= 9000000000000000;
  }

  function validPayload(payload) {
    return payload && typeof payload === "object" && !Array.isArray(payload)
      && Object.keys(payload).length === 4
      && ((payload.sourceAccountId === ALICE && payload.destinationAccountId === BOB)
        || (payload.sourceAccountId === BOB && payload.destinationAccountId === ALICE))
      && payload.unit === "FIC" && validAmount(payload.amount);
  }

  function samePayload(left, right) {
    return ["sourceAccountId", "destinationAccountId", "amount", "unit"]
      .every((key) => left[key] === right[key]);
  }

  function verifiedResult(result, payload, expectedState) {
    if (!result || typeof result !== "object" || !UUID.test(result.id)
      || !TERMINAL.has(result.status) || result.status !== expectedState
      || !samePayload(result, payload)) {
      throw new Error("The response did not identify the saved transfer.");
    }
    if (result.status === "REJECTED"
      && (typeof result.rejectionCode !== "string" || !/^[A-Z0-9_]{1,80}$/.test(result.rejectionCode))) {
      throw new Error("The rejection response was incomplete.");
    }
    return Object.fromEntries([
      "id", "sourceAccountId", "destinationAccountId", "amount", "unit", "status",
      "rejectionCode", "createdAt", "completedAt",
    ].map((key) => [key, result[key] ?? null]));
  }

  function validatedReceipt(value) {
    if (!value || typeof value !== "object" || value.version !== 1
      || value.endpoint !== location.origin || typeof value.idempotencyKey !== "string"
      || !/^lab-[0-9a-f-]{36}$/i.test(value.idempotencyKey)
      || !UUID.test(value.idempotencyKey.slice(4)) || !validPayload(value.payload)
      || typeof value.createdAt !== "string" || !Number.isFinite(Date.parse(value.createdAt))
      || (Object.hasOwn(value, "imported") && value.imported !== true)
      || !RECEIPT_STATES.has(value.state)) {
      throw new Error("The saved request is invalid or belongs to another origin.");
    }
    if (TERMINAL.has(value.state)) verifiedResult(value.result, value.payload, value.state);
    else if (value.result !== null) throw new Error("The saved unresolved request is inconsistent.");
    Object.freeze(value.payload);
    if (value.result) Object.freeze(value.result);
    return Object.freeze(value);
  }

  function readReceipt() {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (raw === null) return { raw: null, receipt: null };
    if (raw.length > MAX_BYTES) throw new Error("The saved request exceeds the local size limit.");
    return { raw, receipt: validatedReceipt(JSON.parse(raw)) };
  }

  function storeReceipt(receipt, expectedRaw) {
    validatedReceipt(receipt);
    if (localStorage.getItem(STORAGE_KEY) !== expectedRaw) {
      throw new Error("The saved request changed in another window. It was not replaced.");
    }
    const raw = JSON.stringify(receipt);
    localStorage.setItem(STORAGE_KEY, raw);
    if (localStorage.getItem(STORAGE_KEY) !== raw) {
      throw new Error("The saved request could not be read back. No new request can be sent.");
    }
    return { raw, receipt };
  }

  class PortableReceiptError extends Error {}

  function parsePortableReceipt(text) {
    const fields = ["kind", "version", "endpoint", "idempotencyKey", "payload", "createdAt"];
    let value;
    try { value = JSON.parse(text); } catch (_) {
      throw new PortableReceiptError("This file is not a valid JSON recovery receipt.");
    }
    if (!value || typeof value !== "object" || Array.isArray(value)
      || Object.keys(value).length !== fields.length || !fields.every((key) => Object.hasOwn(value, key))
      || value.kind !== PORTABLE_RECEIPT_KIND || value.version !== 1) {
      throw new PortableReceiptError("This file is not a supported Transfer Lab recovery receipt.");
    }
    if (value.endpoint !== location.origin) {
      throw new PortableReceiptError("This receipt belongs to a different local URL. Open the original demo URL.");
    }
    if (!validPayload(value.payload)) {
      throw new PortableReceiptError("The recovery receipt does not contain a valid fictional transfer.");
    }
    const { sourceAccountId, destinationAccountId, amount, unit } = value.payload;
    try {
      // Reconstruct the original wire field order. Never trust a file to establish a terminal result.
      return validatedReceipt({
        version: 1, endpoint: location.origin, idempotencyKey: value.idempotencyKey,
        payload: { sourceAccountId, destinationAccountId, amount, unit }, createdAt: value.createdAt,
        imported: true, state: "UNRESOLVED", result: null,
      });
    } catch (_) {
      throw new PortableReceiptError("The receipt request key or creation time is invalid.");
    }
  }

  function downloadReceipt() {
    if (!local || !storageReady || receiptInvalid) return;
    let url;
    try {
      const { receipt } = readReceipt();
      if (!receipt) throw new PortableReceiptError("There is no saved receipt to download.");
      const { endpoint, idempotencyKey, payload, createdAt } = receipt;
      const contents = JSON.stringify({
        kind: PORTABLE_RECEIPT_KIND, version: 1, endpoint, idempotencyKey, payload,
        createdAt: new Date(createdAt).toISOString(),
      }, null, 2) + "\n";
      const file = new Blob([contents], { type: "application/json" });
      if (file.size > MAX_RECEIPT_FILE_BYTES) throw new PortableReceiptError("The saved receipt exceeds the file size limit.");
      url = URL.createObjectURL(file);
      const link = document.createElement("a");
      link.href = url;
      link.download = "transfer-lab-recovery.json";
      document.body.append(link);
      try { link.click(); } finally { link.remove(); }
      display("portable-receipt-message", "The recovery file contains the original request key. Keep it private.", "positive");
    } catch (error) {
      display("portable-receipt-message", error instanceof PortableReceiptError
        ? error.message : "The saved receipt could not be downloaded.", "negative");
    } finally {
      if (url) setTimeout(() => URL.revokeObjectURL(url), 10000);
    }
  }

  async function importReceipt(file) {
    if (!local || !storageReady || receiptInvalid || busy || !navigator.locks?.request) return;
    busy = true;
    updateControls();
    display("portable-receipt-message", "Reading the recovery file locally…", "pending");
    try {
      if (file.size === 0 || file.size > MAX_RECEIPT_FILE_BYTES) {
        throw new PortableReceiptError("Choose a nonempty recovery file no larger than 4 KiB.");
      }
      let text;
      try { text = new TextDecoder("utf-8", { fatal: true }).decode(await file.arrayBuffer()); } catch (_) {
        throw new PortableReceiptError("The recovery file could not be read as UTF-8.");
      }
      const incoming = parsePortableReceipt(text);
      await navigator.locks.request(LOCK_NAME, { mode: "exclusive", ifAvailable: true }, (lock) => {
        if (!lock) throw new PortableReceiptError("Another tab is working on the receipt. Try importing again when it finishes.");
        // Check the last saved state under the same lock used for submit and resume, not the rendered snapshot.
        const snapshot = readReceipt();
        if (snapshot.receipt?.idempotencyKey === incoming.idempotencyKey) {
          if (!samePayload(snapshot.receipt.payload, incoming.payload)) {
            throw new PortableReceiptError("The imported key matches this receipt but the transfer details differ.");
          }
          display("portable-receipt-message", "This exact transfer is already saved. The existing receipt was kept.", "positive");
          return;
        }
        if (snapshot.receipt && !TERMINAL.has(snapshot.receipt.state)) {
          throw new PortableReceiptError("Recover the current unresolved transfer before importing a different receipt.");
        }
        current = storeReceipt(incoming, snapshot.raw);
        automaticLookup = "";
        ui["lookup-id"].value = "";
        clearLookupObservation();
        display("lookup-message", "The imported outcome is not established. Recover the saved request to get its transfer ID.");
        display("submit-message", "Recover the imported transfer before starting another request.");
        display("resume-message", "Recovery is optional. It sends the exact saved request and may commit it if the database never received it.", "unknown");
        display("portable-receipt-message", "Receipt imported locally. No request was sent. Choose Recover this transfer when ready.", "positive");
      });
    } catch (error) {
      display("portable-receipt-message", error instanceof PortableReceiptError ? error.message
        : "The receipt could not be saved. The file was not sent to the server.", "negative");
    } finally {
      busy = false;
      refreshReceipt();
    }
  }

  function probeStorage() {
    const key = `${STORAGE_KEY}.probe.${crypto.randomUUID()}`;
    try {
      localStorage.setItem(key, key);
      if (localStorage.getItem(key) !== key) throw new Error("Local storage read-back failed.");
    } finally {
      if (localStorage.getItem(key) === key) localStorage.removeItem(key);
    }
  }

  function renderReceipt() {
    if (receiptInvalid) {
      display("receipt-state", "Saved request needs inspection", "negative");
      display("receipt-key", "Kept unchanged");
      display("receipt-summary", "No transfer will be sent until the saved request can be validated.");
      display("transfer-id", "Not established");
    } else if (!current?.receipt) {
      display("receipt-state", "No saved request", "pending");
      display("receipt-key", "Created before the first request");
      display("receipt-summary", "Choose a direction and an integer amount in fictional FIC minor units.");
      display("transfer-id", "Available after a response");
    } else {
      const receipt = current.receipt;
      const names = receipt.payload.sourceAccountId === ALICE ? "Alice → Bob" : "Bob → Alice";
      const labels = {
        UNRESOLVED: "Request saved · outcome unresolved", UNKNOWN: "Outcome unknown · resume this request",
        CONFLICT: "Key conflict · inspect before proceeding", COMPLETED: "Financial transfer completed",
        REJECTED: "Financial transfer rejected",
      };
      const state = receipt.state === "COMPLETED" ? "positive"
        : ["REJECTED", "CONFLICT"].includes(receipt.state) ? "negative" : "unknown";
      display("receipt-state", labels[receipt.state], state);
      display("receipt-key", receipt.idempotencyKey);
      const source = receipt.imported ? "restored from a recovery file" : "saved before submission";
      display("receipt-summary", `${names} · ${receipt.payload.amount} FIC minor units · ${source}`);
      display("transfer-id", receipt.result?.id ?? "Not established · resume the saved request");
      if (receipt.result && (!ui["lookup-id"].value || ui["lookup-id"].value === automaticLookup)) {
        if (ui["lookup-id"].value !== receipt.result.id) {
          clearLookupObservation();
          display("lookup-message", "Check delivery for the transfer on this receipt.");
        }
        automaticLookup = receipt.result.id;
        ui["lookup-id"].value = automaticLookup;
      } else if (!receipt.result && automaticLookup && ui["lookup-id"].value === automaticLookup) {
        // An older prefilled identifier must not look like evidence for the unresolved transfer.
        ui["lookup-id"].value = "";
        automaticLookup = "";
        clearLookupObservation();
        display("lookup-message", "The current transfer ID is unknown. Recover it from the saved receipt first.");
      }
    }
    updateControls();
  }

  function updateControls() {
    const canWrite = local && storageReady && !receiptInvalid && !busy && Boolean(navigator.locks?.request);
    const unresolved = current?.receipt && !TERMINAL.has(current.receipt.state);
    ui["submit-transfer"].disabled = !canWrite || Boolean(unresolved);
    ui["resume-transfer"].disabled = !canWrite || !unresolved;
    ui["download-receipt"].disabled = !local || !storageReady || receiptInvalid || !current?.receipt;
    ui["import-receipt"].disabled = !canWrite;
    ui["lookup-transfer"].disabled = !local || busy;
    const selected = selectedTransferId();
    const selectedDelivery = selected && deliverySeen?.value.transferId === selected ? deliverySeen.value : null;
    ui["watch-start"].disabled = !local || busy || !observation || Boolean(activeWatch) || !selectedDelivery
      || observation.classifyDelivery(selectedDelivery) !== "waiting";
    ui["watch-stop"].disabled = !local || !activeWatch;
    ui["download-observation"].disabled = !local || !observation || !selected
      || !(selectedDelivery || ledgerSeen?.value.transferId === selected);
    ui["history-refresh"].disabled = !local || historyLoading;
    ui["history-older"].disabled = !local || historyLoading || !historyNext;
    ui["history-older"].hidden = !historyNext;
    for (const button of ui["history-items"].querySelectorAll(".history-inspect")) {
      button.disabled = !local || busy;
    }
    ui["drop-response"].disabled = !canWrite || Boolean(unresolved) || !simulationReady;
    if (ui["drop-response"].disabled) ui["drop-response"].checked = false;
  }

  function refreshReceipt() {
    try {
      current = readReceipt();
      receiptInvalid = false;
    } catch (_) {
      current = null;
      receiptInvalid = true;
    }
    renderReceipt();
  }

  async function jsonRequest(path, options = {}, { signal, timeoutMs = TIMEOUT_MS } = {}) {
    const controller = new AbortController();
    const abort = () => controller.abort();
    if (signal?.aborted) abort();
    else signal?.addEventListener("abort", abort, { once: true });
    const timer = setTimeout(abort, timeoutMs);
    try {
      const response = await fetch(path, {
        ...options, signal: controller.signal, mode: "same-origin", credentials: "omit",
        cache: "no-store", redirect: "error", referrerPolicy: "no-referrer",
      });
      const reader = response.body?.getReader();
      if (!reader) throw new Error("The response body was unavailable.");
      const parts = [];
      let size = 0;
      while (true) {
        const part = await reader.read();
        if (part.done) break;
        size += part.value.byteLength;
        if (size > MAX_BYTES) {
          await reader.cancel();
          throw new Error("The response exceeded the size limit.");
        }
        parts.push(part.value);
      }
      const bytes = new Uint8Array(size);
      let offset = 0;
      for (const part of parts) {
        bytes.set(part, offset);
        offset += part.byteLength;
      }
      let result = null;
      try { result = JSON.parse(new TextDecoder("utf-8", { fatal: true }).decode(bytes)); } catch (_) { /* Unknown outcome below. */ }
      return { status: response.status, result };
    } finally {
      clearTimeout(timer);
      signal?.removeEventListener("abort", abort);
    }
  }

  async function postSaved(snapshot, messageId, dropResponse) {
    let next;
    try {
      // Verify durable read-back again immediately before any POST, including resume.
      snapshot = storeReceipt(snapshot.receipt, snapshot.raw);
      const headers = { "Content-Type": "application/json", "Idempotency-Key": snapshot.receipt.idempotencyKey };
      if (dropResponse) headers["X-TPP-Demo-Drop-Response"] = "1";
      const response = await jsonRequest("/api/transfers", {
        method: "POST", headers, body: JSON.stringify(snapshot.receipt.payload),
      });
      if ([200, 201, 422].includes(response.status)) {
        const state = response.status === 422 ? "REJECTED" : "COMPLETED";
        const result = verifiedResult(response.result, snapshot.receipt.payload, state);
        next = { ...snapshot.receipt, state, result };
        current = storeReceipt(next, snapshot.raw);
        display(messageId, state === "COMPLETED"
          ? (response.status === 200
            ? "Recovered the original committed transfer. Check its delivery using the recovered ID."
            : "The financial transfer is complete. Use delivery lookup to inspect publication and activity.")
          : `The durable result is REJECTED (${result.rejectionCode}).`, state === "COMPLETED" ? "positive" : "negative");
        if (historyOnLatest && !historyReadingOlder) void readHistory();
      } else {
        const state = response.status === 409 ? "CONFLICT" : "UNKNOWN";
        next = { ...snapshot.receipt, state, result: null };
        current = storeReceipt(next, snapshot.raw);
        display(messageId, state === "CONFLICT"
          ? "The saved key conflicts with another payload. Inspect it; no replacement key was generated."
          : `HTTP ${response.status} did not establish a terminal result. Resume the same saved request.`, state === "CONFLICT" ? "negative" : "unknown");
      }
    } catch (_) {
      // A rejected fetch can follow a server commit. It never establishes failure or success.
      try {
        current = storeReceipt({ ...snapshot.receipt, state: "UNKNOWN", result: null }, snapshot.raw);
      } catch (_) { refreshReceipt(); }
      display(messageId, "Outcome unknown. The request was saved first. Resume this same request; do not create another key.", "unknown");
    }
    renderReceipt();
  }

  async function financialAction(resume) {
    if (!local || !storageReady || busy || receiptInvalid || !navigator.locks?.request) return;
    const messageId = resume ? "resume-message" : "submit-message";
    const requestedDrop = !resume && ui["drop-response"].checked;
    busy = true;
    updateControls();
    try {
      await navigator.locks.request(LOCK_NAME, { mode: "exclusive", ifAvailable: true }, async (lock) => {
        if (!lock) {
          display(messageId, "Another Transfer Lab window is working on the saved request. Wait, then inspect its receipt.", "pending");
          return;
        }
        let snapshot = readReceipt();
        let dropResponse = false;
        if (resume) {
          if (!snapshot.receipt || TERMINAL.has(snapshot.receipt.state)) {
            throw new Error("There is no unresolved saved request to resume.");
          }
          display(messageId, "Resuming the exact saved key and payload…", "pending");
        } else {
          if (snapshot.receipt && !TERMINAL.has(snapshot.receipt.state)) {
            throw new Error("Resume the unresolved saved request before creating another intent.");
          }
          const text = ui.amount.value;
          const amount = /^[1-9]\d{0,15}$/.test(text) ? Number(text) : NaN;
          if (!validAmount(amount)) throw new Error("Enter integer FIC minor units from 1 to 9000000000000000.");
          const direction = ui.direction.value;
          if (!["alice-to-bob", "bob-to-alice"].includes(direction)) throw new Error("Choose a valid direction.");
          dropResponse = requestedDrop;
          if (dropResponse && !simulationReady) throw new Error("The local response-loss simulation is not ready.");
          const payload = { sourceAccountId: direction === "alice-to-bob" ? ALICE : BOB,
            destinationAccountId: direction === "alice-to-bob" ? BOB : ALICE, amount, unit: "FIC" };
          const receipt = { version: 1, endpoint: location.origin, idempotencyKey: `lab-${crypto.randomUUID()}`,
            payload, createdAt: new Date().toISOString(), state: "UNRESOLVED", result: null };
          snapshot = storeReceipt(receipt, snapshot.raw);
          current = snapshot;
          display("portable-receipt-message", "Download this receipt to use the same request in another browser.");
          renderReceipt();
          display(messageId, "Request saved and read back. Waiting for the server response…", "pending");
        }
        await postSaved(snapshot, messageId, resume ? false : dropResponse);
      });
    } catch (error) {
      display(messageId, `${error.message} No new request was sent.`, "negative");
      refreshReceipt();
    } finally {
      busy = false;
      updateControls();
    }
  }

  function verifiedDelivery(result, transferId) {
    if (!result || typeof result !== "object" || result.transferId?.toLowerCase() !== transferId
      || !TERMINAL.has(result.transferStatus) || !DELIVERY_STATES.has(result.deliveryState)
      || typeof result.decidedAt !== "string" || !Number.isFinite(Date.parse(result.decidedAt))
      || !("event" in result)) throw new Error("The delivery response did not match this transfer.");
    if (result.event !== null) {
      const event = result.event;
      if (!event || typeof event !== "object" || typeof event.eventId !== "string" || !UUID.test(event.eventId)
        || !["PENDING", "CLAIMED", "PUBLISHED", "BLOCKED"].includes(event.publicationStatus)
        || !Number.isSafeInteger(event.attemptCount) || event.attemptCount < 0
        || (event.lastErrorCode !== null && (typeof event.lastErrorCode !== "string"
          || !/^[A-Z0-9_]{1,64}$/.test(event.lastErrorCode)))) {
        throw new Error("The delivery response was incomplete.");
      }
      for (const key of ["nextAttemptAt", "publishedAt", "processedAt", "projectedAt"]) {
        if (event[key] !== null && (typeof event[key] !== "string" || !Number.isFinite(Date.parse(event[key])))) {
          throw new Error("The delivery timestamps were incomplete.");
        }
      }
    }
    return { ...result, transferId, event: result.event
      ? { ...result.event, eventId: result.event.eventId.toLowerCase() } : null };
  }

  function verifiedLedgerProof(result, transferId, transferStatus = null) {
    if (!result || typeof result !== "object" || result.transferId?.toLowerCase() !== transferId
      || !TERMINAL.has(result.transferStatus) || (transferStatus && result.transferStatus !== transferStatus)
      || !UUID.test(result.sourceAccountId)
      || !UUID.test(result.destinationAccountId) || !validAmount(result.amount) || result.unit !== "FIC"
      || !PROOF_STATES.has(result.proofState) || !Array.isArray(result.postings) || result.postings.length > 3) {
      throw new Error("The ledger evidence did not match this transfer.");
    }
    const source = result.sourceAccountId.toLowerCase();
    const destination = result.destinationAccountId.toLowerCase();
    const postings = result.postings.map((posting) => {
      if (!posting || typeof posting.entryId !== "string" || !/^[1-9]\d{0,18}$/.test(posting.entryId)
        || !UUID.test(posting.accountId) || !Number.isSafeInteger(posting.delta)) {
        throw new Error("The ledger posting details were incomplete.");
      }
      // Keep the decimal entry ID as text: a PostgreSQL bigint can exceed JavaScript's safe integer range.
      return { entryId: posting.entryId, accountId: posting.accountId.toLowerCase(), delta: posting.delta };
    });
    if (result.proofState === "BALANCED_PAIR"
      && (result.transferStatus !== "COMPLETED" || source === destination || postings.length !== 2
        || postings[0].entryId === postings[1].entryId
        || !postings.some((posting) => posting.accountId === source && posting.delta === -result.amount)
        || !postings.some((posting) => posting.accountId === destination && posting.delta === result.amount))) {
      throw new Error("The reported ledger pair did not match the transfer amount and accounts.");
    }
    if (result.proofState === "NO_POSTINGS" && (result.transferStatus !== "REJECTED" || postings.length !== 0)) {
      throw new Error("The reported absence of postings did not match the rejected transfer.");
    }
    return { ...result, transferId, sourceAccountId: source, destinationAccountId: destination, postings };
  }

  function textElement(tag, className, text) {
    const element = document.createElement(tag);
    element.className = className;
    element.textContent = text;
    return element;
  }

  function verifiedHistory(value, before) {
    if (!value || typeof value !== "object" || !Array.isArray(value.items)
      || value.items.length > HISTORY_PAGE_SIZE
      || (value.nextBefore !== null && (typeof value.nextBefore !== "string"
        || !/^[A-Za-z0-9_-]{39}$/.test(value.nextBefore)
        || value.nextBefore === before || value.items.length < HISTORY_PAGE_SIZE))) {
      throw new Error("Transfer history is incomplete.");
    }
    const seen = new Set();
    const items = value.items.map((item) => {
      if (!item || typeof item !== "object" || typeof item.transferId !== "string" || !UUID.test(item.transferId)
        || !validPayload({ sourceAccountId: item.sourceAccountId, destinationAccountId: item.destinationAccountId,
          amount: item.amount, unit: item.unit })
        || !TERMINAL.has(item.transferStatus) || typeof item.decidedAt !== "string"
        || !Number.isFinite(Date.parse(item.decidedAt))
        || (item.transferStatus === "COMPLETED" ? item.rejectionCode !== null
          : typeof item.rejectionCode !== "string" || !/^[A-Z0-9_]{1,80}$/.test(item.rejectionCode))) {
        throw new Error("Transfer history contains an invalid decision.");
      }
      const id = item.transferId.toLowerCase();
      if (seen.has(id)) throw new Error("Transfer history contains a repeated transfer.");
      seen.add(id);
      return { id, fromAlice: item.sourceAccountId === ALICE, amount: item.amount,
        state: item.transferStatus, decidedAt: item.decidedAt, rejectionCode: item.rejectionCode };
    });
    return { items, nextBefore: value.nextBefore };
  }

  function historyRow(item) {
    const row = document.createElement("li");
    row.className = "history-row";
    row.dataset.transferId = item.id;
    const summary = document.createElement("div");
    summary.className = "history-summary";
    const direction = item.fromAlice ? "Alice → Bob" : "Bob → Alice";
    const amount = `${item.amount.toLocaleString()} FIC`;
    const state = textElement("span", "history-state",
      item.state === "COMPLETED" ? "Completed" : `Rejected · ${item.rejectionCode.replaceAll("_", " ").toLowerCase()}`);
    state.dataset.state = item.state;
    const timestamp = new Intl.DateTimeFormat(undefined, {
      dateStyle: "medium", timeStyle: "medium",
    }).format(new Date(item.decidedAt));
    const metadata = document.createElement("div");
    metadata.className = "history-time";
    const time = textElement("time", "history-decided-at", timestamp);
    time.dateTime = item.decidedAt;
    time.title = item.decidedAt;
    const reference = textElement("code", "history-reference", item.id.slice(0, 8));
    reference.title = item.id;
    metadata.append(time, reference);
    summary.append(textElement("span", "history-direction", direction),
      textElement("span", "history-amount", amount), state, metadata);
    const inspect = textElement("button", "history-inspect", "Inspect");
    inspect.type = "button";
    inspect.setAttribute("aria-label", `Inspect ${direction}, ${amount}, ${timestamp}, transfer ${item.id}`);
    inspect.addEventListener("click", () => {
      if (!local || busy) return;
      automaticLookup = "";
      ui["lookup-id"].value = item.id;
      ui["lookup-heading"].focus();
      void lookup();
    });
    row.append(summary, inspect);
    return row;
  }

  async function readHistory(older = false) {
    if (!local || (older && (!historyNext || historyLoading))) return;
    const before = older ? historyNext : null;
    const version = ++historyVersion;
    historyLoading = true;
    historyReadingOlder = older;
    updateControls();
    display("history-status", older ? "Reading older transfers…" : "Reading recent transfers…", "pending");
    try {
      const params = new URLSearchParams({ limit: String(HISTORY_PAGE_SIZE) });
      if (before) params.set("before", before);
      const response = await jsonRequest(`/internal/demo/transfers?${params}`);
      if (version !== historyVersion) return;
      if (response.status !== 200) throw new Error("Transfer history is unavailable.");
      const page = verifiedHistory(response.result, before);
      ui["history-items"].replaceChildren(...page.items.map(historyRow));
      historyOnLatest = !older;
      historyDisplayed = true;
      historyNext = page.nextBefore;
      const count = page.items.length;
      const status = count
        ? `Showing ${count} ${older ? "older" : "recent"} ${count === 1 ? "transfer" : "transfers"}.`
        : (older ? "There are no older transfers." : "No committed or rejected transfers between Alice and Bob yet.");
      display("history-status", status, count ? "positive" : "");
    } catch (_) {
      if (version !== historyVersion) return;
      display("history-status", historyDisplayed
        ? "Could not read history. The last view is still shown."
        : "Could not read history. Use Refresh latest to try again.", "unknown");
    } finally {
      if (version === historyVersion) {
        historyLoading = false;
        historyReadingOlder = false;
        updateControls();
      }
    }
  }

  function postingRow(posting) {
    const row = document.createElement("li");
    row.className = "proof-posting";
    row.dataset.entryId = posting.entryId;
    const heading = document.createElement("div");
    heading.className = "proof-posting-heading";
    const direction = posting.delta < 0 ? "Debit" : posting.delta > 0 ? "Credit" : "Zero posting";
    const amount = textElement("span", "proof-amount", `${posting.delta > 0 ? "+" : ""}${posting.delta} FIC`);
    amount.dataset.direction = posting.delta < 0 ? "debit" : posting.delta > 0 ? "credit" : "zero";
    heading.append(textElement("span", "proof-direction", direction), amount);
    const name = posting.accountId === ALICE ? "Alice" : posting.accountId === BOB ? "Bob" : "Account";
    const account = textElement("p", "proof-account", name);
    account.append(textElement("code", "proof-account-id", posting.accountId));
    const entry = textElement("div", "proof-entry", "Entry ID");
    entry.append(textElement("code", "proof-entry-id", posting.entryId));
    row.append(heading, account, entry);
    return row;
  }

  function renderLedgerProof(proof) {
    const labels = { BALANCED_PAIR: "Balanced pair", NO_POSTINGS: "No ledger postings", INCONSISTENT: "Needs verification" };
    display("proof-transfer-id", proof.transferId);
    display("proof-summary", proof.proofState === "BALANCED_PAIR"
      ? `Completed transfer. One debit and one credit match ${proof.amount} FIC minor units for this transfer ID.`
      : proof.proofState === "NO_POSTINGS"
        ? "This transfer ID was rejected. No ledger postings were recorded."
        : `This transfer ID has inconsistent ledger evidence. ${proof.postings.length ? "The observed postings are shown below." : "No postings were returned."}`);
    ui["proof-postings"].replaceChildren(...proof.postings.map(postingRow));
    ui["proof-postings"].hidden = proof.postings.length === 0;
    display("proof-state", labels[proof.proofState], proof.proofState === "INCONSISTENT" ? "negative" : "positive");
    ui["proof-state"].dataset.proofState = proof.proofState;
  }

  function resetDelivery(label = "Not observed", state = "pending") {
    display("delivery-state", label, state);
    display("ledger-state", "Not observed");
    display("publication-state", "Not observed");
    display("projection-state", "Not observed");
    display("event-id", "Not available");
    for (const key of ["attempts", "error", "next-at", "observed-at", "published-at", "projected-at"]) {
      display(`delivery-${key}`, "Not observed");
    }
  }

  function observeDelivery(result, observedAt = new Date().toISOString()) {
    deliverySeen = { observedAt, value: result };
    const event = result.event;
    const projected = result.deliveryState === "PROJECTED";
    const inconsistent = result.deliveryState === "INCONSISTENT";
    const projectionText = projected ? "PROJECTED · account activity verified"
      : inconsistent ? "Needs verification · inconsistent delivery evidence"
        : event?.projectedAt ? "Projection recorded · delivery not verified"
          : event ? "Not yet projected" : "Not applicable";
    display("ledger-state", result.transferStatus === "COMPLETED" ? "COMPLETED · financial effect committed" : "REJECTED · no financial transfer effect", result.transferStatus === "COMPLETED" ? "positive" : "negative");
    display("publication-state", event?.publicationStatus ?? "Not applicable", event?.publicationStatus === "PUBLISHED" ? "positive" : "pending");
    display("projection-state", projectionText, projected ? "positive" : inconsistent ? "negative" : "pending");
    display("delivery-state", result.deliveryState, result.deliveryState === "PROJECTED" ? "positive" : ["BLOCKED", "INCONSISTENT"].includes(result.deliveryState) ? "negative" : "pending");
    display("event-id", event?.eventId ?? "No event for this result");
    display("delivery-attempts", event ? String(event.attemptCount) : "Not applicable");
    display("delivery-error", event?.lastErrorCode ?? (event ? "None recorded" : "Not applicable"));
    display("delivery-next-at", event?.nextAttemptAt ?? (event ? "Not scheduled" : "Not applicable"));
    display("delivery-observed-at", deliverySeen.observedAt);
    display("delivery-published-at", event?.publishedAt ?? (event ? "Not recorded" : "Not applicable"));
    display("delivery-projected-at", event?.projectedAt ?? (event ? "Not recorded" : "Not applicable"));
  }

  function selectedTransferId() {
    const id = ui["lookup-id"].value.trim().toLowerCase();
    return UUID.test(id) ? id : null;
  }

  function watchStatus(state, text) {
    const status = ui["watch-status"];
    if (status.dataset.watchState !== state) status.dataset.watchState = state;
    if (status.textContent !== text) status.textContent = text;
  }

  function describeWatch(state) {
    return {
      settled: "Follow complete. Publication is recorded and account activity is projected.",
      blocked: "Follow stopped. Publication is blocked. Inspect the last recorded error.",
      inconsistent: "Follow stopped. Delivery evidence is inconsistent. Inspect before taking action.",
      "not-applicable": "No event to follow. This transfer was rejected.",
      timeout: "Follow ended after up to 60 seconds. The last successful observation is still shown.",
      stopped: "Following stopped. The last successful observation is still shown.",
      unavailable: "Delivery is not available for this selection. Check again to obtain a new observation.",
    }[state];
  }

  function cancelWatch() {
    if (!activeWatch) return;
    const previous = activeWatch;
    activeWatch = null;
    clearTimeout(previous.timer);
    previous.controller.abort();
  }

  function finishWatch(watch, state, text = describeWatch(state)) {
    if (activeWatch !== watch) return;
    cancelWatch();
    watchStatus(state, text);
    updateControls();
  }

  function ownsWatch(watch) {
    return activeWatch === watch && lookupVersion === watch.version && selectedTransferId() === watch.transferId;
  }

  async function pollDelivery(watch) {
    if (!ownsWatch(watch)) return;
    const remaining = watch.deadline - performance.now();
    if (remaining <= 0 || watch.reads >= WATCH_READ_LIMIT) {
      finishWatch(watch, "timeout");
      return;
    }
    watch.reads += 1;
    try {
      const response = await jsonRequest(`/internal/transfers/${watch.transferId}/delivery`, {}, {
        signal: watch.controller.signal, timeoutMs: Math.min(WATCH_REQUEST_MS, remaining),
      });
      if (!ownsWatch(watch)) return;
      if (performance.now() >= watch.deadline) {
        finishWatch(watch, "timeout");
        return;
      }
      if (response.status === 404 && response.result?.code === "TRANSFER_NOT_FOUND") {
        invalidateWatchedObservation("Unavailable", "This transfer is no longer visible to the local service.");
        finishWatch(watch, "unavailable");
        return;
      }
      if (response.status !== 200) throw new Error("Delivery read did not return an observation.");
      const result = verifiedDelivery(response.result, watch.transferId);
      const previous = deliverySeen.value;
      if (result.transferStatus !== previous.transferStatus || result.decidedAt !== previous.decidedAt
        || (previous.event && result.event && previous.event.eventId !== result.event.eventId)) {
        invalidateWatchedObservation("Inconsistent", "The observed transfer identity changed. Check the local database.");
        finishWatch(watch, "inconsistent", "Follow stopped because the transfer or event identity changed between reads.");
        return;
      }
      observeDelivery(result);
      const outcome = observation.classifyDelivery(result);
      if (outcome !== "waiting") {
        finishWatch(watch, outcome);
        return;
      }
      watchStatus("watching", result.deliveryState === "PROJECTED"
        ? "Activity is projected. Still waiting for the recorded publication."
        : "Following delivery. Only this transfer’s delivery status is being read.");
    } catch (_) {
      if (!ownsWatch(watch)) return;
      watchStatus("watching", "Delivery read unavailable. Retrying within the follow window. The last observation is still shown.");
    }
    const delay = watch.deadline - performance.now();
    if (delay <= 0) finishWatch(watch, "timeout");
    else watch.timer = setTimeout(() => { void pollDelivery(watch); }, Math.min(WATCH_INTERVAL_MS, delay));
  }

  function invalidateWatchedObservation(label, detail) {
    deliverySeen = null;
    ledgerSeen = null;
    resetDelivery(label, "unknown");
    resetProof("Unavailable", detail, "unknown");
    display("observation-message", "No current observation can be downloaded.");
    display("lookup-message", detail, "unknown");
  }

  function startWatch() {
    const id = selectedTransferId();
    if (!local || busy || activeWatch || !observation
      || !id || deliverySeen?.value.transferId !== id
      || observation.classifyDelivery(deliverySeen.value) !== "waiting") return;
    const watch = {
      transferId: id, version: lookupVersion, deadline: performance.now() + WATCH_WINDOW_MS,
      controller: new AbortController(), timer: null, reads: 0,
    };
    activeWatch = watch;
    watchStatus("watching", "Following delivery. Only this transfer’s delivery status is being read.");
    updateControls();
    void pollDelivery(watch);
  }

  function downloadObservation() {
    const transferId = selectedTransferId();
    if (!local || !observation || !transferId) return;
    let url;
    try {
      const report = observation.buildReport({
        transferId, exportedAt: new Date().toISOString(), delivery: deliverySeen, ledger: ledgerSeen,
      });
      const file = new Blob([JSON.stringify(report, null, 2) + "\n"], { type: "application/json" });
      url = URL.createObjectURL(file);
      const link = document.createElement("a");
      link.href = url;
      link.download = `transfer-observation-${transferId.slice(0, 8)}.json`;
      document.body.append(link);
      try { link.click(); } finally { link.remove(); }
      display("observation-message", "Observation downloaded. It contains transfer evidence, not recovery credentials.", "positive");
    } catch (_) {
      display("observation-message", "No valid observation can be downloaded for this transfer ID.", "negative");
    } finally {
      if (url) setTimeout(() => URL.revokeObjectURL(url), 10000);
    }
  }

  async function lookup() {
    if (!local || busy) return;
    clearLookupObservation();
    const transferId = selectedTransferId();
    if (!transferId) {
      display("lookup-message", "Enter a valid transfer UUID. No request was sent.", "negative");
      return;
    }
    busy = true;
    updateControls();
    const version = lookupVersion;
    resetProof("Reading postings…", "Reading ledger evidence for this transfer ID.");
    display("proof-transfer-id", transferId);
    display("lookup-message", "Reading delivery status and ledger postings…", "pending");
    try {
      const observe = (path) => jsonRequest(path).then((response) =>
        ({ ...response, observedAt: new Date().toISOString() }));
      const [deliveryRead, proofRead] = await Promise.allSettled([
        observe(`/internal/transfers/${transferId}/delivery`),
        observe(`/internal/transfers/${transferId}/ledger-proof`),
      ]);
      if (version !== lookupVersion || selectedTransferId() !== transferId) return;
      let delivery = null;
      try {
        if (deliveryRead.status !== "fulfilled" || deliveryRead.value.status !== 200) {
          throw new Error("Delivery lookup was unavailable.");
        }
        delivery = verifiedDelivery(deliveryRead.value.result, transferId);
        observeDelivery(delivery, deliveryRead.value.observedAt);
      } catch (_) {
        resetDelivery("Unavailable", "unknown");
      }
      let proof = null;
      try {
        if (proofRead.status !== "fulfilled" || proofRead.value.status !== 200) {
          throw new Error("Ledger lookup was unavailable.");
        }
        proof = verifiedLedgerProof(proofRead.value.result, transferId, delivery?.transferStatus);
        renderLedgerProof(proof);
        ledgerSeen = { observedAt: proofRead.value.observedAt, value: proof };
      } catch (_) {
        resetProof("Unavailable", "Ledger evidence could not be established for this transfer ID. Check again to retry this read.", "unknown");
        display("proof-transfer-id", transferId);
      }
      // Either point read remains useful when the other is unavailable.
      ui["delivery-result"].hidden = !delivery && !proof;
      if (delivery && observation) {
        const state = observation.classifyDelivery(delivery);
        watchStatus(state === "waiting" ? "idle" : state, ({
          waiting: "Delivery has not settled. Follow it to check automatically.",
          settled: "Publication and projection are already recorded.",
          blocked: "Publication is blocked. Inspect the last recorded error before retrying.",
          inconsistent: "Delivery evidence is inconsistent. Inspect before taking action.",
          "not-applicable": "No event to follow. This transfer was rejected.",
        })[state]);
      } else {
        watchStatus("unavailable", describeWatch("unavailable"));
      }
      if (delivery || proof) display("observation-message", "Download the observations shown for this transfer.");
      if (delivery && proof) {
        display("lookup-message", proof.proofState === "INCONSISTENT"
          ? "Delivery status read. Ledger evidence for this transfer ID needs inspection."
          : "Delivery status and ledger evidence read. This lookup submitted no transfer and did not change the saved receipt.",
        proof.proofState === "INCONSISTENT" ? "negative" : "positive");
      } else if (delivery) {
        display("lookup-message", "Delivery status read. Ledger evidence is unavailable; check again to retry this read.", "unknown");
      } else if (proof) {
        display("lookup-message", "Ledger evidence read for this transfer ID. Delivery status is unavailable; check again to retry that read.", "unknown");
      } else {
        const missing = [deliveryRead, proofRead].every((read) => read.status === "fulfilled"
          && read.value.status === 404 && read.value.result?.code === "TRANSFER_NOT_FOUND");
        display("lookup-message", missing
          ? "No transfer with that ID was found. No financial request was submitted."
          : "Delivery and ledger evidence could not be established. Retry this read; no transfer was submitted.", missing ? "negative" : "unknown");
      }
    } catch (_) {
      resetProof("Unavailable", "Ledger evidence was not established for this lookup.", "unknown");
      display("lookup-message", "Delivery status could not be established. Retry this read; no transfer was submitted.", "unknown");
    } finally {
      busy = false;
      updateControls();
    }
  }

  function checkSimulation() {
    const controller = navigator.serviceWorker?.controller;
    // clients.claim() can announce a controller while it is still activating.
    if (controller !== observedWorker) {
      observedWorker?.removeEventListener("statechange", checkSimulation);
      observedWorker = controller;
      observedWorker?.addEventListener("statechange", checkSimulation);
    }
    simulationReady = Boolean(controller && controller.state === "activated"
      && controller.scriptURL === new URL(WORKER_PATH, location.origin).href);
    display("simulation-status", simulationReady
      ? "Ready · a marked new request can simulate a lost response. Resume always uses a normal request."
      : "Response-loss simulation is not ready. Ordinary local requests remain available.", simulationReady ? "positive" : "pending");
    updateControls();
  }

  ui["submit-form"].addEventListener("submit", (event) => { event.preventDefault(); financialAction(false); });
  ui["resume-transfer"].addEventListener("click", (event) => { event.preventDefault(); financialAction(true); });
  ui["download-receipt"].addEventListener("click", downloadReceipt);
  ui["import-receipt"].addEventListener("change", async () => {
    const file = ui["import-receipt"].files?.[0];
    try { if (file) await importReceipt(file); }
    finally { ui["import-receipt"].value = ""; }
  });
  ui["lookup-form"].addEventListener("submit", (event) => { event.preventDefault(); lookup(); });
  ui["watch-start"].addEventListener("click", startWatch);
  ui["watch-stop"].addEventListener("click", () => { if (activeWatch) finishWatch(activeWatch, "stopped"); });
  ui["download-observation"].addEventListener("click", downloadObservation);
  addEventListener("pagehide", () => { if (activeWatch) finishWatch(activeWatch, "stopped"); });
  ui["history-refresh"].addEventListener("click", () => { void readHistory(); });
  ui["history-older"].addEventListener("click", () => { void readHistory(true); });
  ui["lookup-id"].addEventListener("input", () => {
    clearLookupObservation();
    display("lookup-message", "Check delivery for the transfer ID now entered.");
  });
  ui["lookup-form"].addEventListener("reset", () => {
    automaticLookup = "";
    clearLookupObservation();
    display("lookup-message", "Enter a transfer ID to read its delivery and ledger evidence.");
  });
  addEventListener("storage", (event) => {
    if (local && (event.key === STORAGE_KEY || event.key === null)) {
      clearLookupObservation();
      refreshReceipt();
    }
  });

  local = loopbackOrigin();
  if (!local) {
    display("origin-message", "Transfer Lab operates only on a loopback origin. No API request or saved-intent access was made.", "negative");
    display("history-status", "History is available only on a local demo URL.", "negative");
    updateControls();
    return;
  }
  try {
    if (!crypto.randomUUID || !navigator.locks?.request) throw new Error("This browser lacks safe local request coordination.");
    probeStorage();
    storageReady = true;
    display("origin-message", `Local origin: ${location.origin}. Saved requests are kept in this browser.`, "positive");
    display("portable-receipt-message", "Import a file from this demo, or download your receipt after saving a transfer.");
  } catch (_) {
    display("origin-message", "Saving a request safely is unavailable. Transfers are disabled; read-only delivery lookup remains available.", "negative");
    display("portable-receipt-message", "Receipt files are unavailable because this browser cannot safely save a request.", "negative");
  }
  refreshReceipt();
  if ("serviceWorker" in navigator) {
    navigator.serviceWorker.addEventListener("controllerchange", checkSimulation);
    navigator.serviceWorker.register(WORKER_PATH, { scope: "/demo/", updateViaCache: "none" })
      .then(checkSimulation).catch(checkSimulation);
  }
  checkSimulation();
  void readHistory();
})();
