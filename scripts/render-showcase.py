#!/usr/bin/env python3
"""Render an evidence-backed benchmark SVG; --check needs only Python's standard library.

Rendering requires matplotlib. Source values are read from the four retained raw
reports, checked against their comparison summary, and recorded with SHA-256 hashes.
"""

import argparse
import hashlib
import json
from pathlib import Path
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "docs/assets"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def evidence():
    summary_path = ROOT / "docs/benchmarks/phase3-comparison-summary.json"
    summary = json.loads(summary_path.read_text())
    rows = []
    for trial in summary["suites"]["low"]["trials"]:
        path = ROOT / trial["rawReport"]
        raw = json.loads(path.read_text())
        load = trial["load"]
        throughput = raw["workload"]["completed_transfers_per_second"]
        propagation_ms = raw["drain"]["final_events"]["propagation_latency_ms"]["p99"]
        if throughput != load["httpCompletedPerSecond"] or propagation_ms != load["finalPropagationMillisecondsIncludingWarmup"]["p99"]:
            raise ValueError(f"summary differs from raw report: {trial['rawReport']}")
        if raw["workload"]["failed_or_ambiguous_operations"] != 0 or not raw["drain"]["complete"]:
            raise ValueError("showcase trial no longer has successful HTTP and complete drain")
        rows.append({"position": trial["position"], "condition": trial["condition"],
                     "httpCompletionsPerSecond": throughput, "propagationP99Seconds": propagation_ms / 1000,
                     "rawReport": trial["rawReport"], "rawSha256": digest(path)})
    if [row["condition"] for row in rows] != ["baseline", "optimized", "optimized", "baseline"]:
        raise ValueError("expected retained ABBA trial order")
    return {"definition": "Four retained independent-pair ten-second closed-loop trials, in measured ABBA order",
            "measuredBaselineCommit": "cba44277524cb6b10c688a225afee9d396dfd135",
            "measuredOptimizedCommit": "66dc7c9cbcdd312f9df5ed427520bc398d7696a0",
            "limits": "Single local shared host; two repeats per condition; propagation includes warmup; final lifecycle correction was not rebenchmarked",
            "summarySha256": digest(summary_path), "trials": rows}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="verify checked-in chart/data provenance without rendering")
    args = parser.parse_args()
    data = evidence()
    serialized = json.dumps(data, indent=2) + "\n"
    evidence_hash = hashlib.sha256(serialized.encode()).hexdigest()
    chart_path = ASSETS / "pipeline-tradeoff.svg"
    data_path = ASSETS / "pipeline-tradeoff-data.json"
    if args.check:
        if data_path.read_text() != serialized:
            raise ValueError("showcase data is stale; regenerate")
        chart = ET.parse(chart_path).getroot()
        if chart.get("data-evidence-sha256") != evidence_hash or chart.get("data-generator-sha256") != digest(Path(__file__)):
            raise ValueError("chart provenance is stale; regenerate")
        print("PASS: all four plotted values match raw reports, summary, data and SVG provenance")
        return

    # Imported only when rendering, so CI validation has no extra dependencies.
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    matplotlib.rcParams.update({"font.family": "DejaVu Sans", "svg.fonttype": "none", "svg.hashsalt": "tpp-showcase-v1"})
    colors = ["#64748b" if row["condition"] == "baseline" else "#0f766e" for row in data["trials"]]
    labels = [f"{row['position']} · {'Serial' if row['condition'] == 'baseline' else 'Batch'}" for row in data["trials"]]
    fig, axes = plt.subplots(1, 2, figsize=(12, 4.7), facecolor="#f8fafc")
    fig.subplots_adjust(left=0.085, right=0.975, top=0.70, bottom=0.24, wspace=0.29)
    fig.text(0.065, 0.94, "Faster event propagation has a measured HTTP cost", fontsize=19, color="#0f172a", weight="bold")
    fig.text(0.065, 0.875, "Independent account pairs · 8 clients · 10-second closed-loop input · retained ABBA order", fontsize=10.4, color="#475569")
    for ax, field, title, unit, ymax in [
        (axes[0], "propagationP99Seconds", "Event propagation p99", "seconds · lower is better", 130),
        (axes[1], "httpCompletionsPerSecond", "Committed HTTP throughput", "completions/s · higher is better", 1450),
    ]:
        values = [row[field] for row in data["trials"]]
        ax.set_facecolor("#f8fafc")
        bars = ax.bar(range(4), values, color=colors, width=0.58, zorder=3)
        ax.set_xticks(range(4), labels, fontsize=10, color="#334155")
        ax.set_ylim(0, ymax)
        ax.set_title(title, loc="left", color="#0f172a", fontsize=12.5, weight="bold", pad=20)
        ax.set_ylabel(unit, color="#475569", fontsize=9)
        ax.grid(axis="y", color="#e2e8f0", linewidth=0.7, zorder=0)
        ax.spines[["top", "right", "left"]].set_visible(False)
        ax.spines["bottom"].set_color("#cbd5e1")
        ax.tick_params(axis="both", length=0, labelcolor="#475569")
        for bar, value in zip(bars, values):
            ax.text(bar.get_x() + bar.get_width()/2, value + ymax*0.027, f"{value:.1f}" if field.endswith("Seconds") else f"{value:,.0f}",
                    ha="center", fontsize=10, color="#0f172a", weight="bold")
    fig.text(0.065, 0.115, "Every sent HTTP request completed; every committed event ultimately reconciled. Propagation percentiles include warmup.",
             fontsize=9, color="#334155")
    fig.text(0.065, 0.06, "One local shared host, two repeats per condition. Measured optimized source: 66dc7c9; later lifecycle fix was not rebenchmarked.",
             fontsize=8.7, color="#64748b")
    ASSETS.mkdir(parents=True, exist_ok=True)
    fig.savefig(chart_path, format="svg", metadata={"Date": None, "Creator": "Transaction Processing Platform evidence renderer"})
    plt.close(fig)
    chart = ET.parse(chart_path)
    chart.getroot().set("data-evidence-sha256", evidence_hash)
    chart.getroot().set("data-generator-sha256", digest(Path(__file__)))
    ET.register_namespace("", "http://www.w3.org/2000/svg")
    ET.register_namespace("xlink", "http://www.w3.org/1999/xlink")
    chart.write(chart_path, encoding="utf-8", xml_declaration=True)
    data_path.write_text(serialized)
    print(f"Rendered {chart_path.relative_to(ROOT)} from four retained raw reports")


if __name__ == "__main__":
    main()
