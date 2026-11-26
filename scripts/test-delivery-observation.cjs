"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const test = require("node:test");
const vm = require("node:vm");
const helperPath = path.join(__dirname, "../src/main/resources/static/demo/delivery-observation.js");
const { classifyDelivery, buildReport } = require(helperPath);

const TRANSFER = "10000000-0000-0000-0000-000000000001";
const OTHER_TRANSFER = "10000000-0000-0000-0000-000000000002";
const SOURCE = "20000000-0000-0000-0000-000000000001";
const DESTINATION = "20000000-0000-0000-0000-000000000002";
const OTHER = "20000000-0000-0000-0000-000000000003";
const EVENT = "30000000-0000-0000-0000-000000000001";
const OBSERVED = "2026-11-23T12:00:00.123Z";
const EXPORTED = "2026-11-23T12:00:01Z";

function delivery() {
  return { observedAt: OBSERVED, value: {
    transferId: TRANSFER, transferStatus: "COMPLETED", decidedAt: "2026-11-23T11:59:59Z",
    deliveryState: "PROJECTED", event: {
      eventId: EVENT, publicationStatus: "PUBLISHED", attemptCount: 1, nextAttemptAt: null,
      lastErrorCode: null, publishedAt: OBSERVED, processedAt: OBSERVED, projectedAt: OBSERVED,
    },
  } };
}

function ledger() {
  return { observedAt: OBSERVED, value: {
    transferId: TRANSFER, transferStatus: "COMPLETED", sourceAccountId: SOURCE,
    destinationAccountId: DESTINATION, amount: 7, unit: "FIC", proofState: "BALANCED_PAIR",
    postings: [
      { entryId: "9007199254740993", accountId: SOURCE, delta: -7 },
      { entryId: "9007199254740994", accountId: DESTINATION, delta: 7 },
    ],
  } };
}

function report(overrides = {}) {
  return buildReport({ transferId: TRANSFER, exportedAt: EXPORTED, delivery: delivery(), ledger: ledger(), ...overrides });
}

test("classic browser and CommonJS expose only the frozen pure API", () => {
  const context = vm.createContext({});
  vm.runInContext(fs.readFileSync(helperPath, "utf8"), context);
  assert.deepEqual(Object.keys(context), ["TransferLabDelivery"]);
  assert.deepEqual(Object.keys(context.TransferLabDelivery), ["classifyDelivery", "buildReport"]);
  assert.ok(Object.isFrozen(context.TransferLabDelivery));
  assert.ok(Object.isFrozen(require(helperPath)));
});

test("settled requires both projection and recorded publication", () => {
  const value = delivery().value;
  assert.equal(classifyDelivery(value), "settled");
  for (const publication of ["PENDING", "CLAIMED", undefined]) {
    assert.equal(classifyDelivery({ ...value, event: { publicationStatus: publication } }), "waiting");
  }
  assert.equal(classifyDelivery({ ...value, deliveryState: "AWAITING_PROJECTION" }), "waiting");
  assert.equal(classifyDelivery(null), "waiting");
});

test("inconsistent and not-applicable take priority, while blocked overrides projection", () => {
  assert.equal(classifyDelivery({ deliveryState: "PROJECTED", event: { publicationStatus: "BLOCKED" } }), "blocked");
  assert.equal(classifyDelivery({ deliveryState: "BLOCKED", event: { publicationStatus: "PUBLISHED" } }), "blocked");
  assert.equal(classifyDelivery({ deliveryState: "INCONSISTENT", event: { publicationStatus: "BLOCKED" } }), "inconsistent");
  assert.equal(classifyDelivery({ deliveryState: "INCONSISTENT" }), "inconsistent");
  assert.equal(classifyDelivery({ deliveryState: "NOT_APPLICABLE", event: null }), "not-applicable");
  assert.equal(classifyDelivery({ deliveryState: "NOT_APPLICABLE", event: { publicationStatus: "BLOCKED" } }), "not-applicable");
});

test("report has exact allowlisted fields and preserves decimal bigint IDs", () => {
  const value = report();
  assert.deepEqual(Object.keys(value), ["kind", "version", "transferId", "exportedAt", "delivery", "ledger"]);
  assert.equal(value.kind, "tpp.transfer-lab-delivery-observation");
  assert.equal(value.version, 1);
  assert.deepEqual(Object.keys(value.delivery), ["observedAt", "transferStatus", "decidedAt", "deliveryState", "event"]);
  assert.deepEqual(Object.keys(value.delivery.event), ["eventId", "publicationStatus", "attemptCount", "nextAttemptAt",
    "lastErrorCode", "publishedAt", "processedAt", "projectedAt"]);
  assert.deepEqual(Object.keys(value.ledger), ["observedAt", "transferStatus", "proofState", "amount", "unit", "postings"]);
  assert.deepEqual(value.ledger.postings, [
    { entryId: "9007199254740993", delta: -7, role: "SOURCE" },
    { entryId: "9007199254740994", delta: 7, role: "DESTINATION" },
  ]);
});

test("extra secrets, endpoint and all account IDs are omitted at every level", () => {
  const observedDelivery = delivery();
  const observedLedger = ledger();
  const extras = { idempotencyKey: "DO_NOT_EXPORT_KEY", endpoint: "http://DO_NOT_EXPORT_ENDPOINT",
    receipt: { secret: "DO_NOT_EXPORT_RECEIPT" }, raw: "DO_NOT_EXPORT_RAW", accountId: OTHER };
  Object.assign(observedDelivery, extras);
  Object.assign(observedDelivery.value, extras);
  Object.assign(observedDelivery.value.event, extras);
  Object.assign(observedLedger, extras);
  Object.assign(observedLedger.value, extras);
  Object.assign(observedLedger.value.postings[0], { secret: "DO_NOT_EXPORT_POSTING" });
  const raw = JSON.stringify(report({ ...extras, delivery: observedDelivery, ledger: observedLedger }));
  for (const forbidden of ["DO_NOT_EXPORT", SOURCE, DESTINATION, OTHER, "idempotencyKey", "endpoint", "receipt", "accountId"]) {
    assert.ok(!raw.includes(forbidden), forbidden);
  }
});

test("single available observation is exported without manufacturing its missing peer", () => {
  assert.equal(report({ delivery: null }).delivery, null);
  assert.equal(report({ ledger: null }).ledger, null);
  const rejected = delivery();
  rejected.value = { ...rejected.value, transferStatus: "REJECTED", deliveryState: "NOT_APPLICABLE", event: null };
  assert.equal(report({ delivery: rejected, ledger: null }).delivery.event, null);
});

test("OTHER posting role preserves inconsistent evidence without exposing its account", () => {
  const value = ledger();
  value.value.proofState = "INCONSISTENT";
  value.value.postings.push({ entryId: "9007199254740995", accountId: OTHER, delta: 1 });
  const output = report({ ledger: value }).ledger.postings;
  assert.deepEqual(output[2], { entryId: "9007199254740995", delta: 1, role: "OTHER" });
  assert.ok(!JSON.stringify(output).includes(OTHER));
});

test("missing observations, mismatched transfer IDs and statuses fail closed", () => {
  assert.throws(() => report({ delivery: null, ledger: null }), /No delivery or ledger/);
  for (const field of ["delivery", "ledger"]) {
    const value = field === "delivery" ? delivery() : ledger();
    value.value.transferId = OTHER_TRANSFER;
    assert.throws(() => report({ [field]: value }), /does not match/);
  }
  const rejected = ledger();
  rejected.value.transferStatus = "REJECTED";
  rejected.value.proofState = "NO_POSTINGS";
  rejected.value.postings = [];
  assert.throws(() => report({ ledger: rejected }), /statuses disagree/);
});

test("malformed observations cannot be silently dropped or copied into the report", () => {
  assert.throws(() => report({ exportedAt: "not-a-timestamp" }), /timestamp/);
  assert.throws(() => report({ delivery: {} }), /does not match/);
  const value = delivery();
  value.value.event.lastErrorCode = { idempotencyKey: "secret" };
  assert.throws(() => report({ delivery: value }), /publication/);
  const numericId = ledger();
  numericId.value.postings[0].entryId = 9007199254740992;
  assert.throws(() => report({ ledger: numericId }), /posting/);
});

test("formatting does not mutate inputs or retain mutable nested arrays", () => {
  const observedDelivery = delivery();
  const observedLedger = ledger();
  const before = JSON.stringify({ observedDelivery, observedLedger });
  const result = report({ delivery: observedDelivery, ledger: observedLedger });
  assert.equal(JSON.stringify({ observedDelivery, observedLedger }), before);
  observedLedger.value.postings[0].delta = -999;
  observedDelivery.value.event.attemptCount = 999;
  assert.equal(result.ledger.postings[0].delta, -7);
  assert.equal(result.delivery.event.attemptCount, 1);
});
