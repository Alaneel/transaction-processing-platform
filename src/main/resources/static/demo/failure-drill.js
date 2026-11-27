(() => {
  "use strict";

  const stages = ["preparing", "broker-offline", "reply-lost", "receipt-recovered", "delivery-pending", "delivery-projected", "verified"];
  const descriptions = {
    preparing: "Checking the owned local stack before the drill.",
    "broker-offline": "The broker outage is observed. Financial work can still commit.",
    "reply-lost": "The transfer committed, but its response was deliberately lost.",
    "receipt-recovered": "The original result was recovered from the same saved intent.",
    "delivery-pending": "The financial result is committed. Event delivery is still waiting.",
    "delivery-projected": "The same event has reached its projection. Checking final effects.",
    verified: "The local runner reports that its final checks passed.",
    failed: "The runner stopped before all checks passed. Reported observations are retained."
  };
  const uuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
  const positiveDecimal = /^[1-9][0-9]{0,18}$/;
  const integer = (value) => Number.isSafeInteger(value);
  const count = (value) => integer(value) && value >= 0;
  const boolean = (value) => typeof value === "boolean";
  const member = (values) => (value) => values.includes(value);
  const validators = {
    transferId: (value) => typeof value === "string" && uuid.test(value),
    eventId: (value) => typeof value === "string" && uuid.test(value),
    httpStatus: (value) => integer(value) && value >= 100 && value <= 599,
    replayHttpStatus: (value) => integer(value) && value >= 100 && value <= 599,
    deliveryState: member(["NOT_APPLICABLE", "AWAITING_PUBLICATION", "AWAITING_PROJECTION", "BLOCKED", "PROJECTED", "INCONSISTENT"]),
    publicationStatus: member(["PENDING", "CLAIMED", "PUBLISHED", "BLOCKED"]),
    projectionState: member(["PENDING", "AWAITING_PROJECTION", "PROJECTED", "INCONSISTENT", "NOT_APPLICABLE"]),
    postingIds: (value) => Array.isArray(value) && value.length === 2 && value.every((id) => typeof id === "string" && positiveDecimal.test(id)) && value[0] !== value[1],
    sourceDelta: integer,
    destinationDelta: integer,
    ledgerConsistent: boolean,
    ledgerUnchanged: boolean,
    freshContext: boolean,
    eventDiscrepancies: count,
    outboxCount: count,
    inboxCount: count,
    projectionCount: count,
    activityCount: count,
    activitySum: integer,
    appRestarted: boolean,
    withinTarget: boolean
  };
  const byId = (id) => document.getElementById(id);
  const evidence = Object.create(null);
  const observed = new Set();
  let lastStage = -1;
  let stopped = false;
  let elapsed = null;

  function write(id, text, state) {
    const element = byId(id);
    element.textContent = text;
    if (state) element.dataset.state = state;
    else delete element.dataset.state;
  }

  const known = (key) => Object.hasOwn(evidence, key);
  const signed = (value) => `${value > 0 ? "+" : ""}${value}`;

  function renderEvidence() {
    for (const key of ["transferId", "eventId"]) {
      if (known(key)) write(key === "transferId" ? "drill-transfer-id" : "drill-event-id", evidence[key]);
    }
    if (known("httpStatus")) write("drill-http-status", `HTTP ${evidence.httpStatus}`, evidence.httpStatus === 201 ? "positive" : "negative");
    if (known("replayHttpStatus")) {
      const context = known("freshContext") ? (evidence.freshContext ? " · fresh context" : " · fresh context not verified") : "";
      write("drill-replay-status", `HTTP ${evidence.replayHttpStatus}${context}`, evidence.replayHttpStatus === 200 && evidence.freshContext !== false ? "positive" : "negative");
    }
    if (known("postingIds")) write("drill-posting-ids", evidence.postingIds.join(" / "));
    if (known("sourceDelta") && known("destinationDelta")) {
      write("drill-ledger-deltas", `${signed(evidence.sourceDelta)} / ${signed(evidence.destinationDelta)} FIC`, evidence.sourceDelta === -7 && evidence.destinationDelta === 7 ? "positive" : "negative");
    }
    if (known("ledgerUnchanged")) write("drill-ledger-check", evidence.ledgerUnchanged ? "No new postings" : "Postings changed", evidence.ledgerUnchanged ? "positive" : "negative");
    if (known("deliveryState")) {
      const publication = known("publicationStatus") ? ` · ${evidence.publicationStatus}` : "";
      write("drill-delivery-state", `${evidence.deliveryState}${publication}`, evidence.deliveryState === "PROJECTED" ? "positive" : evidence.deliveryState === "INCONSISTENT" || evidence.deliveryState === "BLOCKED" ? "negative" : undefined);
    } else if (known("projectionState")) write("drill-delivery-state", evidence.projectionState);
    if (known("projectionCount")) write("drill-projection-count", String(evidence.projectionCount), evidence.projectionCount === 1 ? "positive" : "negative");
    if (["outboxCount", "inboxCount", "activityCount"].some(known)) {
      const values = ["outboxCount", "inboxCount", "activityCount"].map((key) => known(key) ? String(evidence[key]) : "?");
      const sum = known("activitySum") ? ` · activity sum ${signed(evidence.activitySum)}` : "";
      write("drill-effects", `${values.join(" / ")}${sum}`);
    }
    if (known("ledgerConsistent") || known("eventDiscrepancies")) {
      const ledger = known("ledgerConsistent") ? `Ledger ${evidence.ledgerConsistent ? "consistent" : "inconsistent"}` : "Ledger not observed";
      const events = known("eventDiscrepancies") ? `events ${evidence.eventDiscrepancies} discrepancies` : "events not observed";
      const complete = known("ledgerConsistent") && known("eventDiscrepancies");
      write("drill-event-check", `${ledger}; ${events}`, complete ? evidence.ledgerConsistent && evidence.eventDiscrepancies === 0 ? "positive" : "negative" : undefined);
    }
    if (known("appRestarted")) write("drill-app-restarted", evidence.appRestarted ? "Yes" : "No", evidence.appRestarted ? "negative" : "positive");
    if (known("withinTarget")) write("drill-within-target", evidence.withinTarget ? "Met in this run" : "Missed in this run", evidence.withinTarget ? "positive" : "negative");
  }

  async function present(input) {
    if (!input || typeof input !== "object" || Array.isArray(input)) throw new TypeError("A drill observation is required.");
    const { stage, details = {}, elapsedSeconds } = input;
    if (typeof stage !== "string" || !Object.hasOwn(descriptions, stage)) throw new TypeError("Unknown drill stage.");
    if (!details || typeof details !== "object" || Array.isArray(details)) throw new TypeError("Drill details must be an object.");
    if (elapsedSeconds !== undefined && (typeof elapsedSeconds !== "number" || !Number.isFinite(elapsedSeconds) || elapsedSeconds < 0 || elapsedSeconds > 86400)) throw new TypeError("Invalid drill elapsed time.");
    const index = stages.indexOf(stage);
    if ((stopped && stage !== "failed") || (stage !== "failed" && index < lastStage)) throw new TypeError("Drill stages cannot move backwards. Reload for a new drill.");
    const next = Object.create(null);
    for (const [key, validate] of Object.entries(validators)) {
      if (!Object.hasOwn(details, key)) continue;
      const value = details[key];
      if (!validate(value)) throw new TypeError(`Invalid drill evidence field: ${key}.`);
      next[key] = key === "postingIds" ? value.slice() : key === "transferId" || key === "eventId" ? value.toLowerCase() : value;
      if ((key === "transferId" || key === "eventId") && known(key) && evidence[key] !== next[key]) throw new TypeError("A drill cannot change its observed identity. Reload for a new drill.");
    }
    Object.assign(evidence, next);
    if (elapsedSeconds !== undefined) elapsed = Math.max(elapsed ?? 0, elapsedSeconds);
    if (elapsed !== null) write("drill-elapsed", `${elapsed.toFixed(1)} s`);
    byId("drill-launch-tip").hidden = true;
    const terminal = stage === "failed" || stage === "verified";
    write("drill-mode", terminal ? stage === "verified" ? "Verified" : "Stopped" : "Live local", terminal ? stage : "running");
    write("drill-status", descriptions[stage]);
    byId("drill-status").dataset.stage = stage;
    for (const step of document.querySelectorAll(".drill-steps [data-stage]")) step.removeAttribute("aria-current");
    if (stage === "failed") stopped = true;
    else {
      lastStage = index;
      observed.add(stage);
      const step = document.querySelector(`.drill-steps [data-stage="${stage}"]`);
      step.dataset.state = "observed";
      step.setAttribute("aria-current", "step");
      step.querySelector(".drill-check").textContent = "✓";
      step.querySelector(".drill-step-state").textContent = "Observed";
    }
    for (const scene of document.querySelectorAll(".drill-scene")) {
      if ([...scene.querySelectorAll("[data-stage]")].every((step) => observed.has(step.dataset.stage))) scene.dataset.state = "observed";
    }
    renderEvidence();
    if (terminal) {
      const result = byId("drill-result");
      result.hidden = false;
      result.dataset.stage = stage;
      write("drill-result-heading", stage === "verified" ? "One transfer, recovered and checked." : "The drill stopped.");
      write("drill-result-message", stage === "verified"
        ? "The runner reports that its ledger, replay and delivery checks passed. Review the reported values alongside this result."
        : "Some checks did not complete. Earlier observations remain visible; review the runner’s terminal output for the failure and broker restoration.");
    }
    return Object.freeze({ stage, elapsedSeconds: elapsed, observedStages: Object.freeze([...observed]) });
  }

  globalThis.TransferFailureDrill = Object.freeze({ present });
})();
