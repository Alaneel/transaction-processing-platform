/* Pure observation formatting. This file never reads storage, contacts an API, or changes the page. */
(() => {
  "use strict";

  const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
  const INSTANT = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d{1,9})?(?:Z|[+-]\d{2}:\d{2})$/;
  const TERMINAL = new Set(["COMPLETED", "REJECTED"]);
  const DELIVERY = new Set(["NOT_APPLICABLE", "AWAITING_PUBLICATION", "AWAITING_PROJECTION", "BLOCKED", "PROJECTED", "INCONSISTENT"]);
  const PUBLICATION = new Set(["PENDING", "CLAIMED", "PUBLISHED", "BLOCKED"]);
  const PROOF = new Set(["BALANCED_PAIR", "NO_POSTINGS", "INCONSISTENT"]);

  function object(value) {
    return value !== null && typeof value === "object" && !Array.isArray(value);
  }

  function id(value) {
    if (typeof value !== "string" || !UUID.test(value)) throw new Error("Invalid observation transfer identity.");
    return value.toLowerCase();
  }

  function instant(value, nullable = false) {
    if (nullable && value === null) return null;
    if (typeof value !== "string" || !INSTANT.test(value) || !Number.isFinite(Date.parse(value))) {
      throw new Error("Invalid observation timestamp.");
    }
    return value;
  }

  function classifyDelivery(delivery) {
    if (delivery?.deliveryState === "INCONSISTENT") return "inconsistent";
    if (delivery?.deliveryState === "NOT_APPLICABLE") return "not-applicable";
    if (delivery?.deliveryState === "BLOCKED" || delivery?.event?.publicationStatus === "BLOCKED") return "blocked";
    if (delivery?.deliveryState === "PROJECTED" && delivery?.event?.publicationStatus === "PUBLISHED") return "settled";
    return "waiting";
  }

  function source(observation, transferId) {
    if (!object(observation) || !object(observation.value)
      || id(observation.value.transferId) !== transferId || !TERMINAL.has(observation.value.transferStatus)) {
      throw new Error("Observation does not match the requested terminal transfer.");
    }
    return { observedAt: instant(observation.observedAt), value: observation.value };
  }

  function deliveryReport(observation, transferId) {
    const { observedAt, value } = source(observation, transferId);
    if (!DELIVERY.has(value.deliveryState) || !("event" in value)) throw new Error("Invalid delivery observation.");
    let event = null;
    if (value.event !== null) {
      const original = value.event;
      if (!object(original) || !PUBLICATION.has(original.publicationStatus)
        || !Number.isSafeInteger(original.attemptCount) || original.attemptCount < 0
        || (original.lastErrorCode !== null
          && (typeof original.lastErrorCode !== "string" || !/^[A-Z0-9_]{1,64}$/.test(original.lastErrorCode)))) {
        throw new Error("Invalid publication observation.");
      }
      event = {
        eventId: id(original.eventId), publicationStatus: original.publicationStatus,
        attemptCount: original.attemptCount, nextAttemptAt: instant(original.nextAttemptAt, true),
        lastErrorCode: original.lastErrorCode, publishedAt: instant(original.publishedAt, true),
        processedAt: instant(original.processedAt, true), projectedAt: instant(original.projectedAt, true),
      };
    }
    return { observedAt, transferStatus: value.transferStatus, decidedAt: instant(value.decidedAt),
      deliveryState: value.deliveryState, event };
  }

  function ledgerReport(observation, transferId) {
    const { observedAt, value } = source(observation, transferId);
    if (!PROOF.has(value.proofState) || !Number.isSafeInteger(value.amount)
      || value.amount < 1 || value.amount > 9000000000000000 || value.unit !== "FIC"
      || !Array.isArray(value.postings) || value.postings.length > 3) {
      throw new Error("Invalid ledger observation.");
    }
    const sourceId = id(value.sourceAccountId);
    const destinationId = id(value.destinationAccountId);
    const postings = value.postings.map((posting) => {
      if (!object(posting) || typeof posting.entryId !== "string" || !/^[1-9]\d{0,18}$/.test(posting.entryId)
        || !Number.isSafeInteger(posting.delta) || Math.abs(posting.delta) > 9000000000000000) {
        throw new Error("Invalid ledger posting observation.");
      }
      const account = id(posting.accountId);
      return { entryId: posting.entryId, delta: posting.delta,
        role: account === sourceId ? "SOURCE" : account === destinationId ? "DESTINATION" : "OTHER" };
    });
    return { observedAt, transferStatus: value.transferStatus, proofState: value.proofState,
      amount: value.amount, unit: value.unit, postings };
  }

  function buildReport({ transferId, exportedAt, delivery = null, ledger = null } = {}) {
    const requestedId = id(transferId);
    const time = instant(exportedAt);
    if (delivery === null && ledger === null) throw new Error("No delivery or ledger observation is available.");
    const deliveryValue = delivery === null ? null : deliveryReport(delivery, requestedId);
    const ledgerValue = ledger === null ? null : ledgerReport(ledger, requestedId);
    if (deliveryValue && ledgerValue && deliveryValue.transferStatus !== ledgerValue.transferStatus) {
      throw new Error("Delivery and ledger transfer statuses disagree.");
    }
    return { kind: "tpp.transfer-lab-delivery-observation", version: 1, transferId: requestedId,
      exportedAt: time, delivery: deliveryValue, ledger: ledgerValue };
  }

  const api = Object.freeze({ classifyDelivery, buildReport });
  globalThis.TransferLabDelivery = api;
  if (typeof module === "object" && module !== null && module.exports) module.exports = api;
})();
