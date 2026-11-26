# Guided local demo

This demonstrates a real HTTP transfer, durable replay and Kafka-derived account activity. All balances use fictional integer FIC minor units. There is no public funding API.

## Start and verify

Prerequisites: Python 3, Docker with Compose and a running Docker daemon. The first build downloads Maven/Java dependencies. Use `docker info` to confirm the daemon before starting.

```sh
python3 scripts/demo.py --dry-run
python3 scripts/demo.py
```

The script owns the named `tpp-portfolio-demo` Compose project. It accepts only a local Unix-socket Docker context, refuses container labels from another checkout, and refuses orphaned project volumes without its local ownership record. Keep `benchmark-results/<project>.owner.json` when stopping and later reusing this demo's volumes. Its complete JSON is published exclusively and atomically with mode 0600; the script refuses owner-record/parent symlinks, dangling links, hard links, special files and mismatched records before daemon operations. Existing matching records are retained and made private. Defaults use loopback app/database/Kafka ports 38080/55436/39092 and force both workers on, with sampled admission off. Override ports and project together when running multiple copies:

```sh
python3 scripts/demo.py --project tpp-second-demo \
  --app-port 38081 --db-port 55437 --kafka-port 39093
```

The script waits for the full stack, runs the idempotent owner-only balanced fixture, probes runtime-role restrictions, then runs the existing [HTTP/event smoke check](../scripts/event-smoke.py). It prints `PASS` only after observed effects and reconciliations succeed. JSON and command logs are retained under ignored `benchmark-results/`; sharing them requires a secrets/path review. Report/log directories and leaves are opened without following symlinks; hard links and special files are refused before daemon calls. Logs append privately with mode0600; successful JSON reports are published atomically. Existing reports must be valid results from the same project. An explicit `--output` may select another regular directory; use canonical parents rather than linked directories.

| Observation | Expected result |
|---|---|
| New transfer | HTTP 201, `COMPLETED`, one durable transfer |
| Identical key and payload | HTTP 200, the exact original result |
| Source/destination activity | One event identity with -7/+7, after Kafka delivery |
| Financial reconciliation | Balanced journals and account balances equal ledger sums |
| Projection reconciliation | Zero structural discrepancies |

Funding credits Alice and Bob 1,000,000 minor units each and debits the dedicated issuance account by 2,000,000. Rerunning the fixture does not fund twice. Containers and volumes are retained. Demo requests add real fictional history; the script never truncates tables.

## Try the browser demo

With the local stack running, open [Transfer Lab](http://127.0.0.1:38080/demo/index.html), or the **Browser demo** URL printed by the launcher. Use that URL if you changed the app port. The page uses the seeded Alice and Bob accounts and fictional FIC minor units.

1. Select an account direction and amount, then send a transfer. The page saves a receipt in this browser before the request can leave it.
2. To practice a lost reply, check **Lose the reply on purpose** before sending a new transfer. Wait for the page to report that the result is unknown. Reload the page if you want to simulate restarting the client, then click **Recover this transfer**. Recovery uses the same request identity and payload.
3. Use the prefilled transfer ID or paste another ID, then select **Check delivery**. The lookup separates the committed ledger decision from recorded publication and committed activity projection. Click again if publication or projection is still pending.

Use a modern browser with local storage and Web Locks to submit and recover transfers. The loss switch also requires a service worker on the local page. The worker intercepts only a transfer explicitly marked for the demo. It drops the browser-facing response after the real service returns a new committed result. Regular transfers, rejections and read-only lookups still use their ordinary responses. A pending receipt survives a reload in the same browser and origin. Keep that origin pointed at the same demo database. Clearing browser data or replacing its database can remove the recovery path.

## Demonstrate broker outage and recovery

```sh
python3 scripts/demo.py --broker-outage
```

After the ordinary smoke check, the script stops only its selected project's Kafka service. While it is stopped, a new transfer must return 201, an identical retry must return 200, and a changed amount under the same key must return 409. The committed outbox event must remain pending/claimed and unprocessed.

The broker is restarted in a `finally` block, retaining its volume. The application is not deliberately restarted. The script waits up to 90 seconds for that same event to become published and projected, checks one inbox row and two balanced activity rows directly in SQL, then runs both reconciliations. A failure exits nonzero and retains the log. This demonstrates broker process interruption with persistent storage, not broker disk loss, network partitions or redundant-cluster durability.

Both modes were executed successfully on 14 October 2026, finishing at 13:11:24 UTC, using the final patched application/PostgreSQL/Kafka images and ownership/output safeguards: [normal result](verification/release-normal-demo.json), [outage result](verification/release-outage-demo.json), and [complete release verification](verification/release-readiness.json). The outage report proves 201/200/409 responses, the same recovered event, unchanged application container/start time, one inbox row, two activity rows with delta sum zero, and both reconciliations. The earlier showcase refresh had only offline checks; that limitation is historical.

## Make and recover your own transfer

With the demo running, use the [transfer client](../scripts/transfer-client.py) on macOS or Linux with Python 3.10 or newer. It writes a private receipt before the first POST. Each invocation sends one request. Choose a new receipt path only for a genuinely new transfer.

```sh
python3 scripts/transfer-client.py transfer \
  --source 00000000-0000-0000-0000-000000000002 \
  --destination 00000000-0000-0000-0000-000000000003 \
  --amount 7 --receipt benchmark-results/intents/alice-to-bob.json

python3 scripts/transfer-client.py resume \
  --receipt benchmark-results/intents/alice-to-bob.json
```

The default endpoint is `http://127.0.0.1:38080`. Set `--endpoint` on the initial `transfer` when using a different local port. `resume` uses the saved endpoint, key and payload without overrides. Use the same demo database and volume when resuming. Reusing the port with a replacement database cannot recover a result from the previous one. On macOS use a canonical path if storing receipts under a temporary directory. The client refuses linked receipt paths and requires a private directory.

| Outcome | Meaning and next action |
|---|---|
| `COMPLETED` (exit 0) | HTTP 201 committed a new transfer or HTTP 200 returned the original result. |
| `REJECTED` (exit 1) | HTTP 422 recorded a durable business rejection. |
| Invalid input or receipt (exit 2) | No request was sent. |
| `UNKNOWN` (exit 3) | The result is uncertain. Resume the **same** receipt. |
| Other HTTP refusal (exit 4) | Inspect the response status. A 409 is an identity conflict. Keep the original receipt. |

To reproduce a lost response against the running, idle demo, use this bounded [verification script](../scripts/verify-transfer-client.py). It moves seven fictional units between the two seeded accounts once, even though two client processes issue POSTs.

```sh
python3 scripts/verify-transfer-client.py --base-url http://127.0.0.1:38080 \
  --cli scripts/transfer-client.py
```

[Observed recovery](verification/transfer-client-recovery.json) records the captured HTTP 201, dropped response, subsequent HTTP 200 with the same transfer ID, paired ledger and Kafka activity entries, and a direct PostgreSQL check for one published event, inbox row and projection. The client receipt preserves request identity through a process restart. It does not identify a replacement database or recover a deleted volume.

## Check a transfer's delivery progress

Copy `result.id` from a completed or rejected transfer response. The demo prints a direct link for its sample transfer. You can check progress without the original receipt or idempotency key:

```sh
# Replace TRANSFER_ID with the UUID from the transfer response.
python3 scripts/transfer-client.py status --transfer-id TRANSFER_ID
curl -fsS http://127.0.0.1:38080/internal/transfers/TRANSFER_ID/delivery
```

Set `--endpoint` if the demo is on a different local port. `status` performs one read and never retries or submits a transfer. Its exit code 0 means the lookup succeeded, even if delivery is pending or blocked. Exit 4 identifies an unknown ID or another HTTP refusal, 3 means the observation is unavailable, and 2 means invalid local input.

Read `transferStatus` first. `COMPLETED` means the ledger committed. `AWAITING_PUBLICATION` and `AWAITING_PROJECTION` describe asynchronous work after that commit. `PROJECTED` means the activity effect committed, and `BLOCKED` calls for operator investigation. A rejected transfer returns `NOT_APPLICABLE` and no event. If a response was lost and you do not have a transfer ID, resume the original receipt first.

The broker-outage demo saves observations before and after recovery under `brokerOutage.deliveryDuringOutage` and `brokerOutage.deliveryAfterRecovery`. The [verified example](verification/transfer-delivery-status.json) shows the same completed transfer and event moving from `AWAITING_PUBLICATION` to `PROJECTED`. See the [full state meanings](operations.md#transfer-delivery-progress).

## Inspect the API manually

Open [OpenAPI](http://127.0.0.1:38080/openapi.yaml), or read the [checked-in contract](../src/main/resources/static/openapi.yaml).

```sh
curl -sS http://127.0.0.1:38080/api/accounts/00000000-0000-0000-0000-000000000002/balance
curl -sS http://127.0.0.1:38080/internal/reconciliation
curl -sS http://127.0.0.1:38080/internal/events/status
curl -sS http://127.0.0.1:38080/internal/events/reconciliation
```

The [operations reference](operations.md#api-examples) contains complete transfer, replay, conflict, activity and operator endpoint examples. Adapt its default port 8080 to this demo's port 38080. These interfaces are unauthenticated trusted-local inspection tools.

## Stop and retain history

```sh
python3 scripts/demo.py --stop
```

Use the same `--project` when you chose another name. This stops containers and retains PostgreSQL/Kafka volumes. To permanently discard this demo's disposable history, deliberately run `docker compose --project-name tpp-portfolio-demo down --volumes` from this checkout. Never apply that command to a project containing history you want to keep.

## When startup fails

- **Docker daemon unavailable:** start or repair Docker through your normal local setup; the demo cannot substitute mocked dependencies.
- **Port already in use:** choose three unused ports; leave unrelated services alone.
- **Project belongs to another checkout:** choose another project name. The script refuses replacement.
- **Unsafe or mismatched ownership record:** do not replace the record or use linked metadata. Choose a fresh project name and preserve unidentified history.
- **Existing volumes have no ownership record:** choose a fresh project name. The script leaves the unidentified history intact.
- **Remote Docker context:** select your local Unix-socket Docker context; the demo does not operate remote infrastructure.
- **Credentials changed on an existing volume:** initial role setup runs only on a fresh database volume. Changing `DB_PASSWORD`/`MIGRATION_PASSWORD` alone cannot update existing roles.
- **Projection timeout:** inspect delivery using the transfer ID first. For deeper diagnostics follow its event ID to `/internal/outbox/{eventId}` and inspect this project's app/Kafka logs. To recover an uncertain financial result, resume the original receipt or use the same key and payload.

Do not expose these local ports publicly. [Security posture](../SECURITY.md) records the concrete limitations and fixture credentials.
