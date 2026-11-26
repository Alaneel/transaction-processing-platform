#!/usr/bin/env python3
"""Summarize pipeline thread events inside a benchmark's observed timestamp window."""

import argparse
import collections
import datetime as dt
import json
from pathlib import Path
import re
import subprocess


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--jfr-tool", default="jfr")
    parser.add_argument("--recording", type=Path, required=True)
    parser.add_argument("--window-report", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.recording.stat().st_size > 32 * 1024 * 1024:
        parser.error("analysis supports recordings bounded to 32 MiB")
    window = json.loads(args.window_report.read_text())
    begin = dt.datetime.fromisoformat(window["environment"]["started_at"])
    finish = dt.datetime.fromisoformat(window["finished_at"])
    selected = "jdk.ThreadSleep,jdk.ThreadPark,jdk.JavaMonitorWait,jdk.SocketRead,jdk.ExecutionSample,jdk.NativeMethodSample"
    result = subprocess.run([args.jfr_tool, "print", "--json", "--events", selected, "--stack-depth", "16",
                             str(args.recording)], text=True, capture_output=True, check=True, timeout=60)
    grouped = collections.defaultdict(lambda: {"count": 0, "durationSeconds": 0.0,
                                                "states": collections.Counter(), "topFrames": collections.Counter()})
    for event in json.loads(result.stdout)["recording"]["events"]:
        values = event["values"]
        stamp = dt.datetime.fromisoformat(values["startTime"].replace("Z", "+00:00"))
        if not begin <= stamp <= finish:
            continue
        thread = values.get("eventThread") or values.get("sampledThread") or {}
        name = thread.get("javaName", "unknown")
        if name != "outbox-relay" and not name.startswith("tpp-event-consumer"):
            continue
        item = grouped[(name, event["type"])]
        item["count"] += 1
        if "duration" in values:
            duration = re.fullmatch(r"PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+(?:\.\d+)?)S)?", values["duration"])
            if duration:
                item["durationSeconds"] += 3600 * float(duration[1] or 0) + 60 * float(duration[2] or 0) + float(duration[3] or 0)
        if "state" in values:
            item["states"][str(values["state"])] += 1
        frames = (values.get("stackTrace") or {}).get("frames", [])
        if frames:
            method = frames[0]["method"]
            item["topFrames"][method.get("type", {}).get("name", "?") + "." + method.get("name", "?")] += 1
    report = {"recording": str(args.recording), "windowReport": str(args.window_report),
              "windowStart": begin.isoformat(), "windowEnd": finish.isoformat(),
              "selection": "event starts inside observed report window; duration is full event duration; JFR thresholds omit brief waits",
              "threads": [{"thread": name, "event": event, "count": value["count"],
                           "durationSeconds": value["durationSeconds"], "states": dict(value["states"]),
                           "topFrames": dict(value["topFrames"])} for (name, event), value in sorted(grouped.items())]}
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({"output": str(args.output), "groups": len(report["threads"])}, indent=2))


if __name__ == "__main__":
    main()
