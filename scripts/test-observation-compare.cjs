"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const test = require("node:test");
const vm = require("node:vm");
const helperPath = path.join(__dirname, "../src/main/resources/static/demo/observation-compare.js");
const { compareReports } = require(helperPath);
const { buildReport } = require("../src/main/resources/static/demo/delivery-observation.js");

const TRANSFER = "10000000-0000-0000-0000-000000000001";
const EVENT = "20000000-0000-0000-0000-000000000001";
const SOURCE = "30000000-0000-0000-0000-000000000001";
const DESTINATION = "30000000-0000-0000-0000-000000000002";
const T0 = "2026-11-27T00:00:00.000Z";
const T1 = "2026-11-27T00:00:01.000Z";
const T2 = "2026-11-27T00:00:02.000Z";

function report() {
  return buildReport({ transferId: TRANSFER, exportedAt: T1,
    delivery: { observedAt: T0, value: {
      transferId: TRANSFER, transferStatus: "COMPLETED", decidedAt: T0,
      deliveryState: "PROJECTED", event: {
        eventId: EVENT, publicationStatus: "PUBLISHED", attemptCount: 1, lastErrorCode: null,
        nextAttemptAt: null, publishedAt: T0, processedAt: T0, projectedAt: T0,
      },
    } },
    ledger: { observedAt: T0, value: {
      transferId: TRANSFER, transferStatus: "COMPLETED", proofState: "BALANCED_PAIR", amount: 7, unit: "FIC",
      sourceAccountId: SOURCE, destinationAccountId: DESTINATION,
      postings: [{ entryId: "9007199254740993", accountId: SOURCE, delta: -7 },
        { entryId: "9007199254740994", accountId: DESTINATION, delta: 7 }],
    } },
  });
}

function rows(value) {
  return Object.fromEntries(value.rows.map((row) => [row.key, row]));
}

function controlled(action) {
  assert.throws(action, (error) => error.name === "ObservationComparisonError"
    && !error.message.includes("PRIVATE_SECRET") && error.message.length < 160);
}

test("classic and CommonJS expose a frozen pure API without requiring browser services", () => {
  const context = vm.createContext({});
  vm.runInContext(fs.readFileSync(helperPath, "utf8"), context);
  assert.deepEqual(Object.keys(context), ["TransferLabComparison"]);
  assert.deepEqual(Object.keys(context.TransferLabComparison), ["compareReports"]);
  assert.ok(Object.isFrozen(context.TransferLabComparison));
  assert.ok(Object.isFrozen(require(helperPath)));
});

test("two actual formatter exports produce the exact comparison shape", () => {
  const output = compareReports(report(), report());
  assert.deepEqual(Object.keys(output), ["transferId", "exportOrder", "readOrderWarning", "rows"]);
  assert.equal(output.transferId, TRANSFER);
  assert.equal(output.exportOrder, "same-time");
  assert.equal(output.readOrderWarning, false);
  assert.deepEqual(output.rows.map((row) => row.key),
    ["decision", "delivery", "publication", "attempts", "last-error", "projected-at", "event", "ledger"]);
  for (const row of output.rows) {
    assert.deepEqual(Object.keys(row), ["key", "label", "first", "second", "status"]);
    assert.equal(typeof row.first, "string");
    assert.equal(typeof row.second, "string");
    assert.equal(row.status, "same");
    assert.match(row.label, /^Recorded /);
  }
});

test("recorded stage changes are displayed without claiming a trusted final result", () => {
  const first = report(), second = report();
  first.delivery.deliveryState = "AWAITING_PUBLICATION";
  first.delivery.event.publicationStatus = "PENDING";
  first.delivery.event.attemptCount = 2;
  first.delivery.event.lastErrorCode = "DELIVERY_UNCERTAIN";
  first.delivery.event.projectedAt = null;
  second.exportedAt = T2;
  const output = compareReports(first, second);
  assert.equal(output.exportOrder, "as-listed");
  const compared = rows(output);
  for (const key of ["delivery", "publication", "attempts", "last-error", "projected-at"]) assert.equal(compared[key].status, "changed");
  assert.equal(compared.event.status, "same");
  assert.equal(compared.ledger.status, "same");
  assert.ok(!JSON.stringify(output).includes("verified true"));
});

test("posting order does not matter and bigint identities remain exact strings", () => {
  const first = report(), second = report();
  const original = JSON.stringify(first);
  second.ledger.postings.reverse();
  assert.equal(rows(compareReports(first, second)).ledger.status, "same");
  assert.equal(JSON.stringify(first), original);
  second.ledger.postings[0].entryId = "9007199254740995";
  const changed = rows(compareReports(first, second)).ledger;
  assert.equal(changed.status, "changed");
  assert.ok(changed.first.includes("9007199254740994"));
  assert.ok(changed.second.includes("9007199254740995"));
  second.ledger.postings[0].entryId = "9007199254740994";
  second.ledger.postings[0].delta = -7;
  assert.equal(rows(compareReports(first, second)).ledger.status, "changed");
});

test("missing sections and null events are not equal evidence", () => {
  const first = report(), second = report();
  first.ledger = null;
  assert.equal(rows(compareReports(first, second)).ledger.status, "not-comparable");
  second.ledger = null;
  assert.equal(rows(compareReports(first, second)).ledger.status, "not-comparable");
  first.delivery = null;
  controlled(() => compareReports(first, second));
  const ledgerOnly = report();
  ledgerOnly.delivery = null;
  const result = rows(compareReports(ledgerOnly, report()));
  for (const key of ["decision", "delivery", "publication", "event"]) assert.equal(result[key].status, "not-comparable");
  assert.equal(result.ledger.status, "same");
  const noEvent = report();
  noEvent.delivery.event = null;
  assert.equal(rows(compareReports(noEvent, noEvent)).publication.status, "not-comparable");
});

test("event identity mismatch is explicit and prevents cross-event stage equality", () => {
  const second = report();
  second.delivery.event.eventId = "20000000-0000-0000-0000-000000000002";
  const output = rows(compareReports(report(), second));
  assert.equal(output.event.status, "changed");
  for (const key of ["publication", "attempts", "last-error", "projected-at"]) assert.equal(output[key].status, "not-comparable");
  assert.equal(output.ledger.status, "same");
});

test("time ordering uses epoch chronology including offsets and nanosecond fractions", () => {
  const first = report(), second = report();
  first.exportedAt = "2026-11-27T01:00:00+02:00";
  second.exportedAt = "2026-11-27T00:00:00Z";
  assert.equal(compareReports(first, second).exportOrder, "as-listed");
  assert.equal(compareReports(second, first).exportOrder, "reversed");
  assert.equal(compareReports(second, first).readOrderWarning, true);
  first.exportedAt = "2026-11-27T00:00:00.000000001Z";
  second.exportedAt = "2026-11-27T00:00:00.000000002Z";
  assert.equal(compareReports(first, second).exportOrder, "as-listed");
  second.exportedAt = "2026-11-27T01:00:00.000000001+01:00";
  assert.equal(compareReports(first, second).exportOrder, "same-time");
});

test("either section's reversed observation times warns independently of export order", () => {
  for (const section of ["delivery", "ledger"]) {
    const first = report(), second = report();
    first.exportedAt = T1;
    second.exportedAt = T2;
    first[section].observedAt = T2;
    second[section].observedAt = T0;
    const output = compareReports(first, second);
    assert.equal(output.exportOrder, "as-listed");
    assert.equal(output.readOrderWarning, true);
  }
});

test("private receipts, wrong format and all extra nested fields fail closed", () => {
  controlled(() => compareReports({ kind: "tpp.transfer-lab-recovery", idempotencyKey: "PRIVATE_SECRET" }, report()));
  for (const edit of [
    (value) => { value.kind = "another-format"; },
    (value) => { value.version = 2; },
    (value) => { value.endpoint = "PRIVATE_SECRET"; },
    (value) => { value.delivery.raw = "PRIVATE_SECRET"; },
    (value) => { value.delivery.event.idempotencyKey = "PRIVATE_SECRET"; },
    (value) => { value.ledger.sourceAccountId = "PRIVATE_SECRET"; },
    (value) => { value.ledger.postings[0].accountId = "PRIVATE_SECRET"; },
  ]) {
    const value = report();
    edit(value);
    controlled(() => compareReports(value, report()));
  }
});

test("wrong identities, types, dates and internal decision disagreement are controlled errors", () => {
  const wrong = report();
  wrong.transferId = "10000000-0000-0000-0000-000000000002";
  controlled(() => compareReports(wrong, report()));
  for (const edit of [
    (value) => { value.ledger.postings[0].entryId = 9007199254740992; },
    (value) => { value.ledger.postings[0].role = "ACCOUNT"; },
    (value) => { value.delivery.event.attemptCount = true; },
    (value) => { value.delivery.event.lastErrorCode = { private: "PRIVATE_SECRET" }; },
    (value) => { value.exportedAt = "2026-02-30T00:00:00Z"; },
    (value) => { value.exportedAt = "2026-11-27T00:00:00"; },
    (value) => { value.ledger.transferStatus = "REJECTED"; },
    (value) => { delete value.delivery.event.projectedAt; },
  ]) {
    const value = report();
    edit(value);
    controlled(() => compareReports(value, report()));
  }
});
