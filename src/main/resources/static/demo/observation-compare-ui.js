(() => {
  "use strict";

  const byId = (id) => document.getElementById(id);
  const first = byId("first-report");
  const second = byId("second-report");
  const compare = byId("compare-reports");
  const clear = byId("clear-reports");
  const status = byId("compare-status");
  const result = byId("compare-result");
  const transferId = byId("compare-transfer-id");
  const clocks = ["first", "second"].map((side) => [byId(`compare-${side}-time`),
    byId(`compare-${side}-delivery-time`), byId(`compare-${side}-ledger-time`)]);
  const orderNote = byId("compare-order-note");
  const rows = byId("compare-rows");
  const comparison = globalThis.TransferLabComparison;
  const LIMIT = 8192;
  const verdicts = { same: "Match", changed: "Changed", "not-comparable": "Not comparable" };
  let selection = 0;

  class FileError extends Error {}

  function announce(message, state = "neutral") {
    status.dataset.state = state;
    status.textContent = message;
  }

  function removeResult() {
    result.hidden = true;
    rows.replaceChildren();
    transferId.textContent = "";
    for (const time of clocks.flat()) {
      time.removeAttribute("datetime");
      time.textContent = "";
    }
    orderNote.hidden = true;
    orderNote.textContent = "";
  }

  function filesChanged() {
    selection += 1;
    removeResult();
    const count = Number(first.files.length === 1) + Number(second.files.length === 1);
    compare.disabled = count !== 2;
    clear.disabled = count === 0;
    announce(count === 2 ? "Two observation files selected. Ready to compare."
      : count === 1 ? "Choose one more observation file."
        : "Choose two observations of the same transfer.");
  }

  async function read(file, label) {
    if (file.size === 0) throw new FileError(`${label} file is empty.`);
    if (file.size > LIMIT) throw new FileError(`${label} file is larger than 8 KiB.`);
    try {
      return JSON.parse(new TextDecoder("utf-8", { fatal: true }).decode(await file.arrayBuffer()));
    } catch {
      throw new FileError(`${label} file could not be read as UTF-8 JSON.`);
    }
  }

  function cell(tag, className, value) {
    const element = document.createElement(tag);
    element.className = className;
    element.textContent = value;
    return element;
  }

  function render(value, firstReport, secondReport) {
    transferId.textContent = value.transferId;
    [firstReport, secondReport].forEach((report, index) => {
      const stamps = [report.exportedAt, report.delivery?.observedAt, report.ledger?.observedAt];
      clocks[index].forEach((element, clock) => {
        const time = stamps[clock];
        if (time) element.setAttribute("datetime", time);
        element.textContent = time ?? "Not observed";
      });
    });
    const order = [];
    if (value.exportOrder === "reversed") order.push("The second file was exported earlier than the first.");
    if (value.exportOrder === "same-time") order.push("The files have the same export time.");
    if (value.readOrderWarning) {
      order.push("The timestamps do not establish a forward sequence for all readings. Check the file order and compare the recorded values only.");
    }
    orderNote.hidden = order.length === 0;
    orderNote.textContent = order.join(" ");

    const table = document.createDocumentFragment();
    const counts = { same: 0, changed: 0, "not-comparable": 0 };
    for (const item of value.rows) {
      const row = document.createElement("tr");
      row.className = "compare-row";
      row.dataset.field = item.key;
      row.dataset.comparison = item.status;
      const label = cell("th", "compare-label", item.label);
      label.scope = "row";
      row.append(label, cell("td", "compare-first", item.first), cell("td", "compare-second", item.second),
        cell("td", "compare-verdict", verdicts[item.status]));
      counts[item.status] += 1;
      table.append(row);
    }
    rows.append(table);
    result.hidden = false;
    announce(`Comparison ready. ${counts.changed} changed, ${counts.same} matching, ${counts["not-comparable"]} not comparable.`, "positive");
  }

  async function compareSelected() {
    if (compare.disabled) return;
    const current = ++selection;
    const firstFile = first.files[0];
    const secondFile = second.files[0];
    removeResult();
    compare.disabled = true;
    announce("Reading the selected files…", "pending");
    try {
      const [firstReport, secondReport] = await Promise.all([read(firstFile, "First"), read(secondFile, "Second")]);
      if (current !== selection) return;
      render(comparison.compareReports(firstReport, secondReport), firstReport, secondReport);
    } catch (error) {
      if (current !== selection) return;
      removeResult();
      const controlled = error instanceof FileError || error?.name === "ObservationComparisonError";
      announce(controlled ? error.message : "These files could not be compared.", "negative");
    } finally {
      if (current === selection) compare.disabled = false;
    }
  }

  if (!comparison || typeof comparison.compareReports !== "function") {
    announce("Comparison is unavailable. Reload this page to try again.", "negative");
    return;
  }
  first.addEventListener("change", filesChanged);
  second.addEventListener("change", filesChanged);
  compare.addEventListener("click", compareSelected);
  clear.addEventListener("click", () => {
    first.value = "";
    second.value = "";
    filesChanged();
    first.focus();
  });
  filesChanged();
})();
