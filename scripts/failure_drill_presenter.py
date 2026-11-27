"""Bound the disposable headed drill viewer independently of Playwright close.

The CLI calls this class serially. A new Python session owns its Playwright
driver; no existing browser session is attached. Only the new Browser's CDP
process ID, pinned to its complete command/start identity and temporary
Playwright profile, may receive the detached-browser cleanup fallback.
"""

import importlib.util
import json
import math
import os
from pathlib import Path
import re
import select
import signal
import stat
import subprocess
import sys
import time

MAX_LINE = 16384
COMMAND_TIMEOUT = 10
STARTUP_TIMEOUT = 12


def _require(condition, message):
    if not condition:
        raise RuntimeError(message)


def _launcher():
    path = Path(__file__).with_name("failure-drill.py")
    spec = importlib.util.spec_from_file_location("failure_drill_presenter_launcher", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def _process_identity(pid, timeout=0.4):
    """Keep the exact identity private; it contains a temporary profile path."""
    try:
        result = subprocess.run(["ps", "-p", str(pid), "-o", "lstart=", "-o", "command="],
                                stdout=subprocess.PIPE, stderr=subprocess.DEVNULL,
                                text=True, timeout=timeout, check=False)
    except (OSError, subprocess.TimeoutExpired):
        return None
    identity = result.stdout.strip()
    if result.returncode or not identity:
        return None
    return identity


class HeadedPresenter:
    def __init__(self, base, channel, capture):
        _require(channel in ("chrome", "chromium"), "Unsupported headed viewer channel.")
        _require(isinstance(base, str) and re.fullmatch(r"http://127\.0\.0\.1:[0-9]{1,5}/?", base),
                 "Headed viewer requires the selected numeric loopback origin.")
        self._process = None
        self._buffer = bytearray()
        self._sequence = 0
        self._cleanup = None
        self._browser_pid = None
        self._browser_identity = None
        arguments = [sys.executable, str(Path(__file__).resolve()), "--worker", base, channel]
        inherited = ()
        if capture is not None:
            _require(type(capture) is int and capture >= 0, "Invalid viewer capture directory descriptor.")
            info = os.fstat(capture)
            _require(stat.S_ISDIR(info.st_mode) and info.st_uid == os.getuid()
                     and stat.S_IMODE(info.st_mode) & 0o077 == 0,
                     "Viewer captures require an owned private directory descriptor.")
            inherited = (capture,)
            arguments.append(str(capture))
        self._process = subprocess.Popen(arguments, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                                         stderr=subprocess.DEVNULL, bufsize=0,
                                         start_new_session=True, pass_fds=inherited)
        os.set_blocking(self._process.stdin.fileno(), False)
        os.set_blocking(self._process.stdout.fileno(), False)
        try:
            deadline = time.monotonic() + STARTUP_TIMEOUT
            identity_message = self._read(deadline)
            _require(type(identity_message.get("browserPid")) is int,
                     "The headed viewer did not identify its disposable browser.")
            pid = identity_message["browserPid"]
            _require(pid > 1 and pid not in (os.getpid(), self._process.pid),
                     "The headed viewer reported an invalid disposable browser process.")
            identity = _process_identity(pid)
            _require(identity is not None and "--remote-debugging-pipe" in identity
                     and re.search(r"--user-data-dir=\S*playwright_chromiumdev_profile-[^\s]+", identity),
                     "Could not pin the disposable headed browser identity.")
            self._browser_pid, self._browser_identity = pid, identity
            _require(self._read(deadline).get("ready") is True,
                     "The headed viewer did not become ready.")
        except BaseException:
            self.close()
            raise

    def _read(self, deadline):
        while True:
            newline = self._buffer.find(b"\n")
            if newline >= 0:
                raw = bytes(self._buffer[:newline])
                del self._buffer[:newline + 1]
                _require(len(raw) <= MAX_LINE, "Headed viewer response exceeded its bound.")
                try:
                    value = json.loads(raw)
                except (ValueError, UnicodeError):
                    raise RuntimeError("The headed viewer returned an invalid response.") from None
                _require(isinstance(value, dict), "The headed viewer returned an invalid response.")
                return value
            _require(len(self._buffer) <= MAX_LINE, "Headed viewer response exceeded its bound.")
            remaining = deadline - time.monotonic()
            _require(remaining > 0, "The headed viewer response timed out.")
            readable, _, _ = select.select([self._process.stdout], [], [], remaining)
            _require(readable, "The headed viewer response timed out.")
            chunk = os.read(self._process.stdout.fileno(), min(4096, MAX_LINE + 1 - len(self._buffer)))
            _require(chunk, "The headed viewer closed before acknowledging its command.")
            self._buffer.extend(chunk)

    def _exchange(self, command, timeout=COMMAND_TIMEOUT, **values):
        self._sequence += 1
        request = {"id": self._sequence, "command": command, **values}
        raw = json.dumps(request, separators=(",", ":"), allow_nan=False).encode() + b"\n"
        _require(len(raw) <= MAX_LINE, "Headed viewer command exceeded its bound.")
        deadline = time.monotonic() + timeout
        sent = 0
        while sent < len(raw):
            remaining = deadline - time.monotonic()
            _require(remaining > 0, "The headed viewer command timed out.")
            _, writable, _ = select.select([], [self._process.stdin], [], remaining)
            _require(writable, "The headed viewer command timed out.")
            try:
                written = os.write(self._process.stdin.fileno(), raw[sent:])
            except (BrokenPipeError, OSError):
                raise RuntimeError("The headed viewer closed before receiving its command.") from None
            _require(written > 0, "The headed viewer stopped accepting commands.")
            sent += written
        response = self._read(deadline)
        _require(response.get("id") == self._sequence and response.get("ok") is True,
                 "The headed viewer did not acknowledge its command.")

    def publish(self, step, seq):
        _require(self._cleanup is None, "The headed viewer has already closed.")
        # The launcher already applies public_details; no request or receipt is
        # transported, and extra top-level report fields are deliberately omitted.
        selected = {key: step[key] for key in ("stage", "details", "elapsedSeconds")}
        self._exchange("publish", step=selected, seq=seq)

    def check(self, browser_result):
        _require(self._cleanup is None, "The headed viewer has already closed.")
        selected = {key: browser_result[key] for key in ("transferId", "eventId")}
        self._exchange("check", result=selected)

    def _group_alive(self):
        try:
            os.killpg(self._process.pid, 0)
            return True
        except ProcessLookupError:
            return False

    def _browser_alive(self):
        if self._browser_identity is None:
            return False
        identity = _process_identity(self._browser_pid)
        if identity is not None:
            return identity == self._browser_identity
        # An unavailable ps result is not evidence that Chrome exited. An
        # unknown existing process is never signalled as our pinned browser.
        try:
            os.kill(self._browser_pid, 0)
            return True
        except ProcessLookupError:
            return False

    def _signal_owned(self, signum):
        # Popen created this process group; never discover targets by name.
        try:
            os.killpg(self._process.pid, signum)
        except ProcessLookupError:
            pass
        # Chrome can detach from the driver's group. Revalidate its complete
        # original start/command identity immediately before each exact-PID signal.
        if self._browser_identity is not None and _process_identity(self._browser_pid) == self._browser_identity:
            try:
                os.kill(self._browser_pid, signum)
            except ProcessLookupError:
                pass

    def _wait_exit(self, timeout):
        deadline = time.monotonic() + timeout
        while True:
            self._process.poll()  # Reap the worker before testing its group.
            if not self._group_alive() and not self._browser_alive():
                return True
            if time.monotonic() >= deadline:
                return False
            time.sleep(0.03)

    def close(self):
        if self._cleanup is not None:
            return self._cleanup
        if self._process is None:
            self._cleanup = {"mode": "graceful"}
            return self._cleanup
        mode = "graceful"
        try:
            # The worker acknowledges before attempting page/context/browser
            # close, so a Playwright shutdown hang cannot hold up this process.
            if self._process.poll() is None:
                try:
                    self._exchange("close", timeout=0.5)
                except (RuntimeError, OSError, ValueError):
                    pass
            if not self._wait_exit(1):
                mode = "terminated-owned-viewer"
                self._signal_owned(signal.SIGTERM)
                if not self._wait_exit(1):
                    self._signal_owned(signal.SIGKILL)
                    _require(self._wait_exit(1), "Could not terminate the disposable headed viewer.")
            self._cleanup = {"mode": mode}
            return self._cleanup
        finally:
            for stream in (self._process.stdin, self._process.stdout):
                if stream is not None:
                    stream.close()


def _reply(value):
    raw = json.dumps(value, separators=(",", ":"), allow_nan=False).encode() + b"\n"
    _require(len(raw) <= MAX_LINE, "Viewer response exceeded its bound.")
    sys.stdout.buffer.write(raw)
    sys.stdout.buffer.flush()


def _worker(base, channel, capture):
    launcher = _launcher()
    base = launcher.numeric_origin(base)
    _require(channel in ("chrome", "chromium"), "Unsupported viewer channel.")
    if capture is not None:
        info = os.fstat(capture)
        _require(stat.S_ISDIR(info.st_mode) and info.st_uid == os.getuid()
                 and stat.S_IMODE(info.st_mode) & 0o077 == 0, "Invalid private capture descriptor.")
    from playwright.sync_api import sync_playwright
    playwright = sync_playwright().start()
    browser = None
    try:
        browser = playwright.chromium.launch(channel=channel, headless=False, timeout=8000)
        cdp = browser.new_browser_cdp_session()
        try:
            processes = cdp.send("SystemInfo.getProcessInfo")["processInfo"]
            browser_pids = [item["id"] for item in processes if item.get("type") == "browser"]
            _require(len(browser_pids) == 1 and type(browser_pids[0]) is int, "Browser identity is unavailable.")
            # Pin Chrome in the parent before loading the presenter, whose
            # network/navigation or later close may itself become unresponsive.
            _reply({"browserPid": browser_pids[0]})
        finally:
            cdp.detach()
        presenter = launcher.Presenter(browser, base, capture)
        _reply({"ready": True})
        previous_id = 0
        while True:
            raw = sys.stdin.buffer.readline(MAX_LINE + 1)
            if not raw:
                break
            _require(len(raw) <= MAX_LINE and raw.endswith(b"\n"), "Invalid viewer command size.")
            message = json.loads(raw)
            _require(isinstance(message, dict) and type(message.get("id")) is int
                     and message["id"] > previous_id, "Invalid viewer command identity.")
            previous_id = message["id"]
            command = message.get("command")
            if command == "close":
                _require(set(message) == {"id", "command"}, "Invalid close command.")
                _reply({"id": previous_id, "ok": True})
                break
            try:
                if command == "publish":
                    _require(set(message) == {"id", "command", "step", "seq"}, "Invalid publish command.")
                    step = message["step"]
                    _require(isinstance(step, dict) and set(step) == {"stage", "details", "elapsedSeconds"}
                             and step["stage"] in launcher.STAGES and isinstance(step["details"], dict)
                             and type(step["elapsedSeconds"]) in (int, float)
                             and math.isfinite(step["elapsedSeconds"]) and 0 <= step["elapsedSeconds"] <= 86400
                             and type(message["seq"]) is int and 1 <= message["seq"] <= 32,
                             "Invalid public stage evidence.")
                    step["details"] = launcher.public_details(step["details"])
                    presenter.publish(step, message["seq"])
                elif command == "check":
                    _require(set(message) == {"id", "command", "result"}, "Invalid check command.")
                    result = message["result"]
                    _require(isinstance(result, dict) and set(result) == {"transferId", "eventId"}
                             and all(isinstance(value, str) and re.fullmatch(
                                 r"[\da-f]{8}(?:-[\da-f]{4}){3}-[\da-f]{12}", value, re.ASCII)
                                     for value in result.values()), "Invalid public result identity.")
                    presenter.check(result)
                else:
                    raise RuntimeError("Unknown viewer command.")
            except Exception:
                _reply({"id": previous_id, "ok": False})
                break
            _reply({"id": previous_id, "ok": True})
    finally:
        if browser is not None:
            # Dispose this isolated page/context first; browser.close itself can
            # hang on macOS, which is why the parent owns bounded termination.
            launcher.close_owned_browser(browser)
        playwright.stop()


def _main():
    _require(len(sys.argv) in (4, 5) and sys.argv[1] == "--worker", "Internal headed viewer worker only.")
    capture = int(sys.argv[4]) if len(sys.argv) == 5 else None
    _worker(sys.argv[2], sys.argv[3], capture)


if __name__ == "__main__":
    try:
        _main()
    except BaseException:
        # IPC errors and tracebacks must not disclose a directory or report.
        sys.exit(1)
