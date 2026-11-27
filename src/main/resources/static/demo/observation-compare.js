/* Pure comparison of recorded observations. No report is treated as trusted server evidence. */
(() => {
  "use strict";

  const KIND = "tpp.transfer-lab-delivery-observation";
  const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
  const TIME = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:\.(\d{1,9}))?(Z|[+-]\d{2}:\d{2})$/;
  const TERMINAL = new Set(["COMPLETED", "REJECTED"]);
  const DELIVERY = new Set(["NOT_APPLICABLE", "AWAITING_PUBLICATION", "AWAITING_PROJECTION", "BLOCKED", "PROJECTED", "INCONSISTENT"]);
  const PUBLICATION = new Set(["PENDING", "CLAIMED", "PUBLISHED", "BLOCKED"]);
  const PROOF = new Set(["BALANCED_PAIR", "NO_POSTINGS", "INCONSISTENT"]);
  const ROLES = new Set(["SOURCE", "DESTINATION", "OTHER"]);

  function invalid(message = "Observation has unsupported fields or values.") {
    const error = new Error(message);
    error.name = "ObservationComparisonError";
    return error;
  }

  function object(value) {
    return value !== null && typeof value === "object" && !Array.isArray(value);
  }

  function fields(value, expected) {
    if (!object(value) || Reflect.ownKeys(value).length !== expected.length
      || expected.some((key) => !Object.prototype.hasOwnProperty.call(value, key))) throw invalid();
  }

  function identity(value) {
    if (typeof value !== "string" || !UUID.test(value)) throw invalid();
    return value.toLowerCase();
  }

  function timestamp(value, nullable = false) {
    if (nullable && value === null) return null;
    const match = typeof value === "string" && TIME.exec(value);
    if (!match) throw invalid("Observation timestamps must include a valid timezone.");
    const [, yearText, monthText, dayText, hourText, minuteText, secondText, fraction = "", zone] = match;
    const year = Number(yearText), month = Number(monthText), day = Number(dayText);
    const leap = year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0);
    const days = [31, leap ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month < 1 || month > 12 || day < 1 || day > days[month - 1]
      || Number(hourText) > 23 || Number(minuteText) > 59 || Number(secondText) > 59) throw invalid();
    const seconds = Date.parse(`${yearText}-${monthText}-${dayText}T${hourText}:${minuteText}:${secondText}${zone}`);
    if (!Number.isSafeInteger(seconds)) throw invalid();
    return { text: value, epoch: BigInt(seconds) * 1000000n + BigInt(fraction.padEnd(9, "0")) };
  }

  function delivery(value) {
    if (value === null) return null;
    fields(value, ["observedAt", "transferStatus", "decidedAt", "deliveryState", "event"]);
    if (!TERMINAL.has(value.transferStatus) || !DELIVERY.has(value.deliveryState)) throw invalid();
    let event = null;
    if (value.event !== null) {
      const row = value.event;
      fields(row, ["eventId", "publicationStatus", "attemptCount", "nextAttemptAt", "lastErrorCode",
        "publishedAt", "processedAt", "projectedAt"]);
      if (!PUBLICATION.has(row.publicationStatus) || !Number.isSafeInteger(row.attemptCount) || row.attemptCount < 0
        || (row.lastErrorCode !== null && (typeof row.lastErrorCode !== "string" || !/^[A-Z0-9_]{1,64}$/.test(row.lastErrorCode)))) throw invalid();
      event = {
        eventId: identity(row.eventId), publicationStatus: row.publicationStatus, attemptCount: row.attemptCount,
        nextAttemptAt: timestamp(row.nextAttemptAt, true), lastErrorCode: row.lastErrorCode,
        publishedAt: timestamp(row.publishedAt, true), processedAt: timestamp(row.processedAt, true),
        projectedAt: timestamp(row.projectedAt, true),
      };
    }
    return { observedAt: timestamp(value.observedAt), transferStatus: value.transferStatus,
      decidedAt: timestamp(value.decidedAt), deliveryState: value.deliveryState, event };
  }

  function ledger(value) {
    if (value === null) return null;
    fields(value, ["observedAt", "transferStatus", "proofState", "amount", "unit", "postings"]);
    if (!TERMINAL.has(value.transferStatus) || !PROOF.has(value.proofState)
      || !Number.isSafeInteger(value.amount) || value.amount < 1 || value.amount > 9000000000000000
      || value.unit !== "FIC" || !Array.isArray(value.postings) || value.postings.length > 3) throw invalid();
    const postings = value.postings.map((posting) => {
      fields(posting, ["entryId", "delta", "role"]);
      if (typeof posting.entryId !== "string" || !/^[1-9]\d{0,18}$/.test(posting.entryId)
        || !Number.isSafeInteger(posting.delta) || Math.abs(posting.delta) > 9000000000000000
        || !ROLES.has(posting.role)) throw invalid();
      return { entryId: posting.entryId, delta: posting.delta, role: posting.role };
    });
    postings.sort((a, b) => a.entryId.length - b.entryId.length
      || (a.entryId < b.entryId ? -1 : a.entryId > b.entryId ? 1 : 0)
      || a.delta - b.delta || (a.role < b.role ? -1 : a.role > b.role ? 1 : 0));
    return { observedAt: timestamp(value.observedAt), transferStatus: value.transferStatus,
      proofState: value.proofState, amount: value.amount, unit: value.unit, postings };
  }

  function report(value) {
    if (object(value) && (value.kind === "tpp.transfer-lab-recovery"
      || "idempotencyKey" in value || "endpoint" in value || "receipt" in value)) {
      throw invalid("Use a delivery observation, not a private recovery receipt.");
    }
    if (!object(value) || value.kind !== KIND || value.version !== 1) {
      throw invalid("Choose a version 1 delivery observation report.");
    }
    fields(value, ["kind", "version", "transferId", "exportedAt", "delivery", "ledger"]);
    const parsed = { transferId: identity(value.transferId), exportedAt: timestamp(value.exportedAt),
      delivery: delivery(value.delivery), ledger: ledger(value.ledger) };
    if (!parsed.delivery && !parsed.ledger) throw invalid("Observation contains no delivery or ledger read.");
    if (parsed.delivery && parsed.ledger && parsed.delivery.transferStatus !== parsed.ledger.transferStatus) {
      throw invalid("Delivery and ledger decisions disagree in an observation.");
    }
    return parsed;
  }

  function row(key, label, first, second, comparable, equal) {
    return { key, label, first, second, status: !comparable ? "not-comparable" : equal ? "same" : "changed" };
  }

  function ledgerText(value) {
    if (!value) return "Not observed";
    const postings = value.postings.map((posting) =>
      `#${posting.entryId} · ${posting.delta > 0 ? "+" : ""}${posting.delta} ${posting.role}`).join("\n");
    return `${value.transferStatus} · ${value.proofState} · ${value.amount} ${value.unit}\n${postings || "No postings"}`;
  }

  function compareReports(first, second) {
    const a = report(first), b = report(second);
    if (a.transferId !== b.transferId) throw invalid("Choose observations for the same transfer.");
    const exportOrder = a.exportedAt.epoch < b.exportedAt.epoch ? "as-listed"
      : a.exportedAt.epoch > b.exportedAt.epoch ? "reversed" : "same-time";
    const ad = a.delivery, bd = b.delivery, ae = ad?.event, be = bd?.event;
    const deliveryComparable = Boolean(ad && bd);
    const eventComparable = Boolean(ae && be);
    const sameEvent = eventComparable && ae.eventId === be.eventId;
    const ledgerComparable = Boolean(a.ledger && b.ledger);
    const timeText = (value) => value ? value.text : "Not recorded";
    const decisionText = (value) => value ? `${value.transferStatus} · ${value.decidedAt.text}` : "Not observed";
    const ledgerKey = (value) => value ? JSON.stringify([value.transferStatus, value.proofState, value.amount,
      value.unit, value.postings.map((posting) => [posting.entryId, posting.delta, posting.role])]) : null;
    return {
      transferId: a.transferId, exportOrder,
      readOrderWarning: exportOrder === "reversed"
        || Boolean(ad && bd && ad.observedAt.epoch > bd.observedAt.epoch)
        || Boolean(a.ledger && b.ledger && a.ledger.observedAt.epoch > b.ledger.observedAt.epoch),
      rows: [
        row("decision", "Recorded decision", decisionText(ad), decisionText(bd), deliveryComparable,
          deliveryComparable && ad.transferStatus === bd.transferStatus && ad.decidedAt.epoch === bd.decidedAt.epoch),
        row("delivery", "Recorded delivery state", ad?.deliveryState ?? "Not observed", bd?.deliveryState ?? "Not observed",
          deliveryComparable, deliveryComparable && ad.deliveryState === bd.deliveryState),
        row("publication", "Recorded publication", ae?.publicationStatus ?? "Not observed", be?.publicationStatus ?? "Not observed",
          sameEvent, sameEvent && ae.publicationStatus === be.publicationStatus),
        row("attempts", "Recorded attempts", ae ? String(ae.attemptCount) : "Not observed", be ? String(be.attemptCount) : "Not observed",
          sameEvent, sameEvent && ae.attemptCount === be.attemptCount),
        row("last-error", "Recorded last error", ae ? ae.lastErrorCode ?? "None recorded" : "Not observed",
          be ? be.lastErrorCode ?? "None recorded" : "Not observed", sameEvent, sameEvent && ae.lastErrorCode === be.lastErrorCode),
        row("projected-at", "Recorded projection time", ae ? timeText(ae.projectedAt) : "Not observed",
          be ? timeText(be.projectedAt) : "Not observed", sameEvent,
          sameEvent && ae.projectedAt?.epoch === be.projectedAt?.epoch),
        row("event", "Recorded event identity", ae?.eventId ?? "Not observed", be?.eventId ?? "Not observed",
          eventComparable, sameEvent),
        row("ledger", "Recorded ledger evidence", ledgerText(a.ledger), ledgerText(b.ledger), ledgerComparable,
          ledgerComparable && ledgerKey(a.ledger) === ledgerKey(b.ledger)),
      ],
    };
  }

  const api = Object.freeze({ compareReports });
  globalThis.TransferLabComparison = api;
  if (typeof module === "object" && module !== null && module.exports) module.exports = api;
})();
