/* The saved intent survives an uncertain response. Delivery lookup is always read-only. */
(() => {
  "use strict";

  const STORAGE_KEY = "tpp.transferLab.intent.v1";
  const LOCK_NAME = "tpp.transferLab.intent";
  const WORKER_PATH = "/demo/delivery-worker.js";
  const TIMEOUT_MS = 10000;
  const MAX_BYTES = 65536;
  const ALICE = "00000000-0000-0000-0000-000000000002";
  const BOB = "00000000-0000-0000-0000-000000000003";
  const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
  const TERMINAL = new Set(["COMPLETED", "REJECTED"]);
  const RECEIPT_STATES = new Set(["UNRESOLVED", "UNKNOWN", "CONFLICT", ...TERMINAL]);
  const DELIVERY_STATES = new Set([
    "NOT_APPLICABLE", "AWAITING_PUBLICATION", "AWAITING_PROJECTION", "BLOCKED", "PROJECTED", "INCONSISTENT",
  ]);
  const ids = [
    "submit-form", "direction", "amount", "drop-response", "submit-transfer", "simulation-status",
    "submit-message", "receipt-state", "receipt-key", "receipt-summary", "resume-transfer", "resume-message",
    "transfer-id", "lookup-form", "lookup-id", "lookup-transfer", "lookup-message", "delivery-result",
    "ledger-state", "publication-state", "projection-state", "delivery-state", "event-id", "origin-message",
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

  function display(id, text, state = "") {
    ui[id].textContent = text;
    ui[id].dataset.state = state;
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
      display("receipt-summary", `${names} · ${receipt.payload.amount} FIC minor units · saved before submission`);
      display("transfer-id", receipt.result?.id ?? "Not established · resume the saved request");
      if (receipt.result && (!ui["lookup-id"].value || ui["lookup-id"].value === automaticLookup)) {
        if (ui["lookup-id"].value !== receipt.result.id) {
          ui["delivery-result"].hidden = true;
          display("lookup-message", "Check delivery for the transfer on this receipt.");
        }
        automaticLookup = receipt.result.id;
        ui["lookup-id"].value = automaticLookup;
      } else if (!receipt.result && automaticLookup && ui["lookup-id"].value === automaticLookup) {
        // An older prefilled identifier must not look like evidence for the unresolved transfer.
        ui["lookup-id"].value = "";
        automaticLookup = "";
        ui["delivery-result"].hidden = true;
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
    ui["lookup-transfer"].disabled = !local || busy;
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

  async function jsonRequest(path, options = {}) {
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), TIMEOUT_MS);
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
      if (!event || typeof event !== "object" || !UUID.test(event.eventId)
        || !["PENDING", "CLAIMED", "PUBLISHED", "BLOCKED"].includes(event.publicationStatus)
        || !Number.isSafeInteger(event.attemptCount) || event.attemptCount < 0) {
        throw new Error("The delivery response was incomplete.");
      }
      for (const key of ["nextAttemptAt", "publishedAt", "processedAt", "projectedAt"]) {
        if (event[key] !== null && (typeof event[key] !== "string" || !Number.isFinite(Date.parse(event[key])))) {
          throw new Error("The delivery timestamps were incomplete.");
        }
      }
    }
    return result;
  }

  async function lookup() {
    if (!local || busy) return;
    const transferId = ui["lookup-id"].value.trim().toLowerCase();
    if (!UUID.test(transferId)) {
      display("lookup-message", "Enter a valid transfer UUID. No request was sent.", "negative");
      return;
    }
    busy = true;
    updateControls();
    ui["delivery-result"].hidden = true;
    display("lookup-message", "Reading delivery status…", "pending");
    try {
      const response = await jsonRequest(`/internal/transfers/${transferId}/delivery`);
      if (response.status === 404 && response.result?.code === "TRANSFER_NOT_FOUND") {
        display("lookup-message", "No transfer with that ID was found. No financial request was submitted.", "negative");
        return;
      }
      if (response.status !== 200) throw new Error("Delivery lookup was unavailable.");
      const result = verifiedDelivery(response.result, transferId);
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
      ui["delivery-result"].hidden = false;
      display("lookup-message", "Delivery status read. This lookup submitted no transfer and did not change the saved receipt.", "positive");
    } catch (_) {
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
  ui["lookup-form"].addEventListener("submit", (event) => { event.preventDefault(); lookup(); });
  addEventListener("storage", (event) => { if (local && (event.key === STORAGE_KEY || event.key === null)) refreshReceipt(); });

  local = loopbackOrigin();
  if (!local) {
    display("origin-message", "Transfer Lab operates only on a loopback origin. No API request or saved-intent access was made.", "negative");
    updateControls();
    return;
  }
  try {
    if (!crypto.randomUUID || !navigator.locks?.request) throw new Error("This browser lacks safe local request coordination.");
    probeStorage();
    storageReady = true;
    display("origin-message", `Local origin: ${location.origin}. Saved requests are kept in this browser.`, "positive");
  } catch (_) {
    display("origin-message", "Saving a request safely is unavailable. Transfers are disabled; read-only delivery lookup remains available.", "negative");
  }
  refreshReceipt();
  if ("serviceWorker" in navigator) {
    navigator.serviceWorker.addEventListener("controllerchange", checkSimulation);
    navigator.serviceWorker.register(WORKER_PATH, { scope: "/demo/", updateViaCache: "none" })
      .then(checkSimulation).catch(checkSimulation);
  }
  checkSimulation();
})();
