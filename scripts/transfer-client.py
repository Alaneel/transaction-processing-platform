#!/usr/bin/env python3
"""Submit or recover a fictional FIC transfer using an immutable local intent receipt.

Requires POSIX Python 3.10+ and an already running local API. No Docker or SQL access.
The receipt contains no credentials and is never rewritten. Resume uses its exact
endpoint, idempotency key and payload. A digest detects accidental receipt edits;
it does not authenticate changes made by the owner of the file.
"""

import argparse
from datetime import datetime
import hashlib
import http.client
import ipaddress
import json
import math
import os
from pathlib import Path
import signal
import stat
import sys
from urllib.parse import urlsplit
import uuid


MAX_AMOUNT = 9_000_000_000_000_000
MAX_RECEIPT = 16_384
MAX_RESPONSE = 65_536


def canonical(value):
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=True).encode("ascii")


def endpoint_checked(value):
    if not isinstance(value, str) or any(ord(c) <= 32 or ord(c) == 127 for c in value):
        raise ValueError("endpoint must be an HTTP loopback origin")
    parsed = urlsplit(value)
    if (parsed.scheme != "http" or parsed.username is not None or parsed.password is not None
            or parsed.path not in ("", "/") or parsed.query or parsed.fragment):
        raise ValueError("endpoint must be an HTTP loopback origin without credentials or a path")
    host = parsed.hostname
    if host == "localhost":
        host = "127.0.0.1"
    if not host or "%" in host or not ipaddress.ip_address(host).is_loopback:
        raise ValueError("endpoint must use a loopback IP address or localhost")
    port = parsed.port if parsed.port is not None else 80
    if not 1 <= port <= 65535:
        raise ValueError("endpoint port must be in [1,65535]")
    origin = f"http://{'[' + host + ']' if ':' in host else host}:{port}"
    return origin, host, port


def uuid_checked(value):
    if not isinstance(value, str):
        raise ValueError("identifiers must be UUID strings")
    return str(uuid.UUID(value))


def payload_checked(value):
    fields = {"sourceAccountId", "destinationAccountId", "amount", "unit"}
    if not isinstance(value, dict) or set(value) != fields:
        raise ValueError("payload has unexpected fields")
    source = uuid_checked(value["sourceAccountId"])
    destination = uuid_checked(value["destinationAccountId"])
    amount = value["amount"]
    if source == destination:
        raise ValueError("source and destination must differ")
    if type(amount) is not int or not 1 <= amount <= MAX_AMOUNT or value["unit"] != "FIC":
        raise ValueError("amount must be integer FIC minor units in [1,9000000000000000]")
    return {"sourceAccountId": source, "destinationAccountId": destination, "amount": amount, "unit": "FIC"}


def receipt_checked(value):
    fields = {"version", "endpoint", "idempotencyKey", "payload", "intentSha256"}
    if not isinstance(value, dict) or set(value) != fields or type(value["version"]) is not int or value["version"] != 1:
        raise ValueError("receipt schema is unsupported")
    if endpoint_checked(value["endpoint"])[0] != value["endpoint"]:
        raise ValueError("receipt endpoint is not canonical")
    if payload_checked(value["payload"]) != value["payload"]:
        raise ValueError("receipt payload is not canonical")
    key = value["idempotencyKey"]
    if not isinstance(key, str) or not key.startswith("client-") or key != "client-" + uuid_checked(key[7:]):
        raise ValueError("receipt idempotency key is invalid")
    intent = {key: value[key] for key in fields - {"intentSha256"}}
    if value["intentSha256"] != hashlib.sha256(canonical(intent)).hexdigest():
        raise ValueError("receipt digest mismatch; original intent must be recovered before retry")
    return value


def private_directory(path, create):
    # Traverse every component through an anchored descriptor without following links.
    # Non-private ancestors such as /private/tmp are permitted; the final directory
    # must be owned by this user and private before any intent is read or published.
    absolute = Path(os.path.abspath(path))
    directory = os.open(absolute.anchor, os.O_RDONLY | os.O_DIRECTORY)
    try:
        for component in absolute.parent.parts[1:]:
            if create:
                try:
                    os.mkdir(component, mode=0o700, dir_fd=directory)
                except FileExistsError:
                    pass
                else:
                    # Persist each new directory entry as well as the receipt itself.
                    os.fsync(directory)
            child = os.open(component, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW, dir_fd=directory)
            os.close(directory)
            directory = child
        info = os.fstat(directory)
        if info.st_uid != os.getuid() or stat.S_IMODE(info.st_mode) & 0o077:
            raise ValueError("receipt directory must be owned by you with mode 0700")
        return directory, absolute
    except BaseException:
        os.close(directory)
        raise


def save_receipt(path, receipt):
    directory, absolute = private_directory(path, create=True)
    temporary = ".transfer-" + uuid.uuid4().hex + ".tmp"
    created = False
    try:
        descriptor = os.open(temporary, os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW, 0o600, dir_fd=directory)
        created = True
        with os.fdopen(descriptor, "wb") as stream:
            os.fchmod(stream.fileno(), 0o600)
            stream.write(canonical(receipt) + b"\n")
            stream.flush()
            os.fsync(stream.fileno())
        # Complete bytes appear atomically and exclusively; never replace an old receipt.
        os.link(temporary, absolute.name, src_dir_fd=directory, dst_dir_fd=directory, follow_symlinks=False)
        os.unlink(temporary, dir_fd=directory)
        created = False
        os.fsync(directory)
        return absolute
    finally:
        if created:
            os.unlink(temporary, dir_fd=directory)
        os.close(directory)


def read_receipt(path):
    directory, absolute = private_directory(path, create=False)
    try:
        descriptor = os.open(absolute.name, os.O_RDONLY | os.O_NONBLOCK | os.O_NOFOLLOW, dir_fd=directory)
        with os.fdopen(descriptor, "rb") as stream:
            info = os.fstat(stream.fileno())
            if (not stat.S_ISREG(info.st_mode) or info.st_nlink != 1 or info.st_uid != os.getuid()
                    or stat.S_IMODE(info.st_mode) != 0o600 or info.st_size > MAX_RECEIPT):
                raise ValueError("receipt must be a single owner-only regular file with mode 0600")
            raw = stream.read(MAX_RECEIPT + 1)
            if len(raw) > MAX_RECEIPT:
                raise ValueError("receipt exceeds size limit")
        return absolute, receipt_checked(json.loads(raw))
    finally:
        os.close(directory)


def direct_request(endpoint, method, path, timeout, body=None, headers=None):
    """Use direct HTTP with no proxy/redirect support and an absolute deadline."""
    _, host, port = endpoint_checked(endpoint)
    connection = http.client.HTTPConnection(host, port, timeout=timeout)
    previous_handler = signal.getsignal(signal.SIGALRM)

    def expired(*_):
        raise TimeoutError("request deadline exceeded")

    signal.signal(signal.SIGALRM, expired)
    signal.setitimer(signal.ITIMER_REAL, timeout)
    try:
        connection.request(method, path, body=body, headers=headers or {})
        response = connection.getresponse()
        body = response.read(MAX_RESPONSE + 1)
        if len(body) > MAX_RESPONSE:
            raise ValueError("response exceeds size limit")
        try:
            result = json.loads(body)
        except (ValueError, UnicodeError):
            result = None
        return response.status, result
    finally:
        signal.setitimer(signal.ITIMER_REAL, 0)
        signal.signal(signal.SIGALRM, previous_handler)
        connection.close()


def request(receipt, timeout):
    return direct_request(receipt["endpoint"], "POST", "/api/transfers", timeout,
                          canonical(receipt["payload"]), {
                              "Content-Type": "application/json",
                              "Idempotency-Key": receipt["idempotencyKey"]})


def date_time_checked(value, nullable=False):
    if value is None and nullable:
        return None
    if not isinstance(value, str) or datetime.fromisoformat(value.replace("Z", "+00:00")).utcoffset() is None:
        raise ValueError("delivery timestamp is invalid")
    return value


def delivery_checked(result, transfer_id):
    if not isinstance(result, dict) or uuid_checked(result.get("transferId")) != transfer_id:
        raise ValueError("delivery response identifies a different transfer")
    if result.get("transferStatus") not in ("COMPLETED", "REJECTED"):
        raise ValueError("delivery transfer status is invalid")
    states = {"NOT_APPLICABLE", "AWAITING_PUBLICATION", "AWAITING_PROJECTION", "BLOCKED", "PROJECTED", "INCONSISTENT"}
    if result.get("deliveryState") not in states:
        raise ValueError("delivery state is invalid")
    observed = {"transferId": transfer_id, "transferStatus": result["transferStatus"],
                "decidedAt": date_time_checked(result.get("decidedAt")),
                "deliveryState": result["deliveryState"], "event": None}
    if "event" not in result:
        raise ValueError("delivery event field is missing")
    event = result["event"]
    if event is not None:
        fields = {"eventId", "publicationStatus", "attemptCount", "nextAttemptAt", "lastErrorCode",
                  "publishedAt", "processedAt", "projectedAt"}
        if not isinstance(event, dict) or not fields <= set(event):
            raise ValueError("delivery event fields are missing")
        if (event["publicationStatus"] not in ("PENDING", "CLAIMED", "PUBLISHED", "BLOCKED")
                or type(event["attemptCount"]) is not int or event["attemptCount"] < 0
                or (event["lastErrorCode"] is not None and not isinstance(event["lastErrorCode"], str))):
            raise ValueError("delivery event metadata is invalid")
        observed["event"] = {key: event[key] for key in fields}
        observed["event"]["eventId"] = uuid_checked(event["eventId"])
        for key in ("nextAttemptAt", "publishedAt", "processedAt", "projectedAt"):
            date_time_checked(event[key], nullable=True)
    return observed


def status(endpoint, transfer_id, timeout):
    outcome = {"command": "status", "endpoint": endpoint, "transferId": transfer_id}
    try:
        http_status, result = direct_request(endpoint, "GET", f"/internal/transfers/{transfer_id}/delivery", timeout)
        if http_status == 200:
            outcome.update(state="OBSERVED", httpStatus=http_status, result=delivery_checked(result, transfer_id))
            code = 0
        elif http_status == 404 and isinstance(result, dict) and result.get("code") == "TRANSFER_NOT_FOUND":
            outcome.update(state="NOT_FOUND", httpStatus=http_status)
            code = 4
        else:
            outcome.update(state="UNAVAILABLE", httpStatus=http_status,
                           message="Delivery status was not established. This read submitted no transfer.")
            code = 4 if http_status < 500 else 3
    except (OSError, TimeoutError, http.client.HTTPException, ValueError, TypeError):
        outcome.update(state="UNAVAILABLE",
                       message="Delivery status was not established. This read submitted no transfer.")
        code = 3
    print(json.dumps(outcome, indent=2))
    return code


def submit(path, receipt, timeout):
    outcome = {"receipt": str(path), "idempotencyKey": receipt["idempotencyKey"]}
    try:
        status, result = request(receipt, timeout)
        if status in (200, 201, 422):
            terminal = "REJECTED" if status == 422 else "COMPLETED"
            if (not isinstance(result, dict) or result.get("status") != terminal
                    or payload_checked({key: result.get(key) for key in receipt["payload"]}) != receipt["payload"]):
                raise ValueError("response does not match the saved transfer")
            uuid_checked(result.get("id"))
            outcome.update(state=terminal, httpStatus=status, result=result)
            code = 0 if terminal == "COMPLETED" else 1
        else:
            message = ("Key conflict requires inspection; the saved intent was retained."
                       if status == 409 else "Saved intent retained. Resume the same receipt; do not generate another key.")
            outcome.update(state="CONFLICT" if status == 409 else "UNKNOWN", httpStatus=status, message=message)
            code = 4 if status < 500 else 3
    except (OSError, TimeoutError, http.client.HTTPException, ValueError):
        outcome.update(state="UNKNOWN", message="Outcome not established. Resume the same receipt; do not generate another key.")
        code = 3
    print(json.dumps(outcome, indent=2))
    return code


def timeout_checked(value):
    try:
        timeout = float(value)
    except ValueError as error:
        raise argparse.ArgumentTypeError("timeout must be in [0.1,30] seconds") from error
    if not math.isfinite(timeout) or not 0.1 <= timeout <= 30:
        raise argparse.ArgumentTypeError("timeout must be in [0.1,30] seconds")
    return timeout


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    transfer = commands.add_parser("transfer", help="save a new intent, then submit it once")
    transfer.add_argument("--endpoint", default="http://127.0.0.1:38080")
    transfer.add_argument("--source", required=True)
    transfer.add_argument("--destination", required=True)
    transfer.add_argument("--amount", required=True, type=int, help="integer FIC minor units")
    for command in (transfer, commands.add_parser("resume", help="resubmit exactly the saved endpoint/key/payload")):
        command.add_argument("--receipt", required=True, type=Path)
        command.add_argument("--timeout", type=timeout_checked, default=5.0)
    inspect = commands.add_parser("status", help="read delivery status by transfer ID; never submit or resume")
    inspect.add_argument("--transfer-id", required=True)
    inspect.add_argument("--endpoint", default="http://127.0.0.1:38080")
    inspect.add_argument("--timeout", type=timeout_checked, default=5.0)
    args = parser.parse_args()
    try:
        if args.command == "status":
            endpoint = endpoint_checked(args.endpoint)[0]
            transfer_id = uuid_checked(args.transfer_id)
            return status(endpoint, transfer_id, args.timeout)
        if args.command == "transfer":
            intent = {"version": 1, "endpoint": endpoint_checked(args.endpoint)[0],
                      "idempotencyKey": "client-" + str(uuid.uuid4()),
                      "payload": payload_checked({"sourceAccountId": args.source,
                                                  "destinationAccountId": args.destination,
                                                  "amount": args.amount, "unit": "FIC"})}
            receipt = dict(intent, intentSha256=hashlib.sha256(canonical(intent)).hexdigest())
            path = save_receipt(args.receipt, receipt)
        else:
            path, receipt = read_receipt(args.receipt)
    except (OSError, ValueError, TypeError) as error:
        print("No request sent: " + str(error), file=sys.stderr)
        return 2
    return submit(path, receipt, args.timeout)


if __name__ == "__main__":
    sys.exit(main())
