# Testing the transactional core and event pipeline

The normal build runs unit tests, real PostgreSQL integration tests and real PostgreSQL/Kafka fault tests. It does not substitute H2, an embedded broker, mock SQL, or silently skip integration tests when Docker is unavailable. Phase 1's 40 tests remain in the suite. The historical Phase 1/2 results below remain separate from the current Phase 3 verification status.

## Run the suite

Install JDK 21 and start Docker, then run:

```sh
./mvnw -B -ntp clean verify
```

The Maven wrapper selects Maven 3.9.16 and verifies the distribution checksum. Maven Enforcer requires Java 21, Maven 3.9 or newer, convergent dependency versions and release dependencies. SpotBugs 4.10.4.1 runs at verify with maximum effort and medium/high findings. Its narrow, commented exclusions cover shared Spring JDBC/metrics objects and the explicitly whitelisted correlation header; mutable result lists and delivery arrays were fixed rather than broadly excluded. Set `JAVA_HOME` to the installed JDK 21 when the shell defaults to a different Java version. The first build needs public network access for dependencies and the digest-pinned PostgreSQL/Kafka parents, patched packages, compiler and broker jars described in [container sources](../docker/README.md). Later builds reuse local caches. These dependency checks are not a vulnerability-feed audit.

Production/build images and PostgreSQL/Kafka fixtures use immutable multiarch digest pins recorded in [the image inventory](verification/release-image-pins.json). Ryuk cleanup and the startup-check helper are also pinned; cleanup and startup checks remain enabled.

On Docker Desktop for macOS, Testcontainers can resolve the host-side Unix socket even without a `DOCKER_HOST` override. If Ryuk fails to mount a path below `.docker/run`, use the daemon-side socket for its mount:

```sh
DOCKER_HOST="unix://$HOME/.docker/run/docker.sock" \
TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock \
./mvnw -B -ntp clean verify
```

Use your runtime's actual local socket. This override fixes the helper bind mount; it does not disable isolation, assertions or resource cleanup. See [release dependency and toolchain verification](dependency-security.md) for the patched Java 21 build tested locally.

Both unit and integration classes end in `Test`, so Surefire runs them during `test` and `verify`. No extra integration-test profile is required. Test reports appear in `target/surefire-reports`.

The wrapper's Maven distribution normally lives under `~/.m2/wrapper`. For an environment where that directory is unwritable, choose writable caches explicitly:

```sh
MAVEN_USER_HOME=/tmp/tpp-maven ./mvnw -B -ntp -Dmaven.repo.local=/tmp/tpp-maven/repository verify
```

Run unit tests separately during development:

```sh
./mvnw -B -ntp -Dtest=DomainRulesTest,DatabaseErrorsTest,ApiErrorMappingTest test
```

That command deliberately excludes PostgreSQL tests and is insufficient acceptance evidence for the transactional core.

### Browser demo on a real stack

Start an idle, seeded local demo with PostgreSQL and Kafka. With Python Playwright and Chrome installed, run:

```sh
python3 scripts/verify-browser-demo.py --base-url http://127.0.0.1:38080 \
  --channel chrome --output benchmark-results/browser-verification.json
```

The verifier requires an explicit loopback origin and a new report file. It clicks through two fictional transfers and one same-receipt replay. It observes the worker dropping a real committed response, reloads without submitting, recovers through the receipt and checks delivery by ID. It independently finds the lost transfer in both account journals before replay, then confirms that recovery reveals the same persisted entry IDs and signed amounts on desktop and narrow screens. A missing-ID lookup must clear earlier evidence. The fixture's account balances, old and new ledger/activity entries, and reconciliations also rule out an extra debit in that run. The two test transfers remain in the selected demo history. Use an isolated project and avoid concurrent transfers while the verifier measures that history. Add `--screenshots-dir` with an existing directory to retain the rendered states.

Recovery now includes a real browser download and import into an independent browser profile with no saved receipt. Import and reload must not send a transfer. The verifier rejects malformed, oversized, wrong-origin and conflicting files without replacing the browser's saved intent. Only explicit recovery may reuse the key and payload, and the committed test request must replay as HTTP 200. Do not share the downloaded JSON file, which contains the original request key.

The [portable receipt acceptance record](verification/portable-receipt.json) records the closed original session, zero import or reload submissions, exact replay, matching PostgreSQL rows, and additional cross-tab and corrupt-storage checks. It retains hashes, not the exported file or raw key.

Before importing the receipt, the verifier finds the committed transfer by clicking its history row in the empty browser session. The same action must work in a 390-pixel viewport. It also compares the displayed page with the server's order and verifies paging back and returning to the latest page when older rows are available. Viewing the history creates neither a saved receipt nor a transfer. The PostgreSQL history integration test additionally covers rejected and unrelated records, tied decision timestamps, cursor validation, and a full traversal without skips or duplicates.

The [recent-transfer acceptance record](verification/recent-transfers.json) records the V3-to-V4 upgrade with unchanged financial rows and verifies real Chrome history navigation. The final local build passed 112 Java and 54 Python checks.

The browser verifier also downloads a delivery observation, checks that publication and projection agree with the displayed state, and matches the signed entry IDs directly to the ledger point read. It verifies that export leaves the saved receipt untouched and emits no financial request. For the isolated formatting and redaction checks, run `node --test scripts/test-delivery-observation.cjs`.

The [delivery-follow acceptance record](verification/delivery-follow.json) documents an actual owned Kafka stop and restart, no app restart, no browser POST, stable postings and a redacted download. A separate virtual-clock check verifies timeout and transfer-selection cancellation.

`DemoDeliveryAttentionPostgresTest` verifies all five queue states, severity and age ordering, the strict 50-completed-transfer sample, fixed-account scope, and no writes. Its rare inconsistency cases use controlled corruption in a disposable PostgreSQL database. The real Kafka stop/restart verifier separately opens the affected transfer from the queue in Chrome with no typed ID, checks the narrow layout, and verifies that the same transfer drops out after settlement.

The [delivery-attention acceptance record](verification/delivery-attention.json) includes real queue discovery and removal through a Kafka outage, the separate failed-refresh check, and the final 115 Java, 54 Python and 10 Node results.

The same Chrome outage verifier downloads the real pending and recovered observations and compares them in a separate, offline browser context. It checks that delivery and publication change while the event ID and signed ledger entries match. It also checks that export and reading times are shown separately, replacing a file clears the previous result, and the comparison does not contact the API or use browser storage. See the [observation comparison acceptance record](verification/observation-comparison.json). Run `node --test scripts/test-observation-compare.cjs` for schema, exact entry ID, incomplete-report, and timestamp edge cases.

The [ledger-proof acceptance record](verification/ledger-proof.json) includes the exact tested image and assets, a real Kafka outage with unchanged ledger evidence, real Chrome recovery and direct PostgreSQL counts. The full local run passed 109 Java and 54 Python tests.

The [v0.2.2 browser acceptance record](verification/browser-demo.json) is the previous verification snapshot. It includes the real network failure, unchanged saved receipt after reload, HTTP 200 replay, exact PostgreSQL evidence and final regression counts.

### Real broker outage in the browser

With a seeded, idle demo already running and Python Playwright plus Chrome installed, run:

```sh
python3 scripts/verify-delivery-watch.py --project tpp-portfolio-demo \
  --base-url http://127.0.0.1:38080 --channel chrome \
  --output benchmark-results/browser-delivery-watch.json
```

Use the project name and loopback URL from the launcher. The verifier checks the launcher's ownership marker, the local Docker endpoint, the selected app binding and seeded identities before stopping the owned Kafka container. It submits one fictional 7-FIC transfer, watches it in Chrome, and restores the same broker even if validation fails. The application and database are not restarted. Use an isolated stack and avoid concurrent transfer or Docker operations during the test. The Chrome client itself sends no POST and the observation export contains no recovery credentials. CI runs this alongside the browser history and recovery checks.

The [Transfer Failure Drill](demo.md#run-the-transfer-failure-drill) separately exercises both failure boundaries on **one** transfer. While Kafka is stopped, the browser loses a real committed reply. A second browser session imports its private receipt and explicitly replays the original request. The drill reads both account ledgers before and after the replay, follows the recovered event to projection, and independently checks original posting IDs and row increments in PostgreSQL. The presenter only receives allowlisted evidence. Use `--capture-dir` with a new directory to retain presenter frames without recording the receipt UI. See the [live drill acceptance](verification/transfer-failure-drill.json).

## Release history and Docker boundary

The final clean verification completed at **13 October 2026, 23:09:14 UTC** (14 October in Singapore): **104 checks, zero failures/errors/skips**. It retains all original 34 unit and 60 real dependency tests, with ten additional separate-process preconnection guards. The final build-only Snappy patch passed a subsequent plugin/static verification; unchanged backend and integration assertions were not repeated solely for that tool change. [Release evidence](verification/release-readiness.json) separates these runs from the historical phases below.

`TestImages` builds the reviewed server derivatives using only fixed public input bytes, rather than uploading the checkout as Docker context. It rejects symlinked or oversized inputs, fingerprints the context and records the actual local image ID. The October run was Linux arm64. The [November public release](verification/public-release-2026-11-26.json) also exercised Linux amd64 on GitHub and rebuilt the Linux arm64 demos locally.

Before constructing or connecting a Docker SDK client, `TestDockerBoundary` rejects remote or ambiguous endpoints, Docker contexts/machine selection, TLS/host overrides, custom providers and unsafe configuration files. It validates a canonical Unix socket and pins that socket in memory. If an inherited configuration is refused, deliberately select a trusted local Unix socket and remove the conflicting override. It does not rewrite your home configuration. Guard tests invoke the actual lazy fixture path in separate Java processes; fake remote listeners observe no connections. The shaded vendor HTTP client remains a [documented test-tool risk](dependency-security.md).

The explicit `TPP_TEST_DB_URL` path below retains its existing behavior and is separate from the Docker endpoint guard. It creates/drops a uniquely named database on the selected PostgreSQL server; use it only deliberately with a dedicated server.

The local [transfer delivery iteration](verification/transfer-delivery-status.json) passed **105 Java tests and 54 Python tests** on 26 November 2026. Delivery tests use real PostgreSQL and Kafka for rejected, pending, claimed, blocked, published, and projected observations. One test also proves that projection can commit while the relay's publication record is still `CLAIMED`. The isolated Compose demo verifies the same event before and after broker recovery with the restricted runtime role. These local observations predate tagging v0.2.1. The v0.2.1 release notes separately link its hosted verification.

## PostgreSQL lifecycle and isolation

`PgTestSupport` starts PostgreSQL 17.11 with Testcontainers 2.0.5. It creates a unique `tpp_test_<uuid>` database, migrates its `public` schema, and starts independent Spring Boot application contexts on random HTTP ports. Real Java HTTP clients submit requests to those listeners. Each application has its own connection pool; direct JDBC fixtures and blocking transactions use additional database connections.

At cleanup, the helper closes all application contexts, drops only its randomly named database, and stops its container. Tests do not reset financial history with `TRUNCATE` or delete journal records. Fixtures create separate accounts and preserve the same immutable history rules as ordinary transfers.

An explicit PostgreSQL server can replace the Phase 1 helper's PostgreSQL container:

```sh
TPP_TEST_DB_URL=jdbc:postgresql://localhost:5432/postgres \
TPP_TEST_DB_USER=postgres \
TPP_TEST_DB_PASSWORD=local-test-password \
./mvnw -B -ntp -Dtest=TransferPostgresTest test
```

Use a dedicated local test server and an administrative test credential with `CREATEDB` and permission to migrate its new database. The helper creates and drops a separate database on that server. The default test username and password are both `tpp` when corresponding variables are omitted. These are fixture credentials, not an application's production runtime role. A server connection or privilege failure fails the suite.

The default Testcontainers path was executed for the recorded results below. The explicit-server path uses the same Phase 1 tests but was not separately exercised in that recorded run. Full Phase 2 verification still requires Docker for its PostgreSQL/Kafka containers.

## Unit checks

Twelve unit tests cover exact minor-unit bounds, required and distinct account identifiers, the single supported unit, bounded idempotency identities, the transient-to-terminal state machine, and payload equality. Error-classification tests distinguish retryable transaction SQLSTATEs from constraint violations, statement cancellation, Spring transaction deadlines, connection failures, database shutdown/recovery signals, and ordinary programming exceptions. Error-mapping tests verify response status, stable codes, correlation IDs, bounded metric labels, and absence of private exception details in responses.

## End-to-end PostgreSQL checks

Twenty-eight integration tests exercise:

| Area | Evidence |
| --- | --- |
| Successful transfer | Real HTTP account creation/read, committed transfer lookup, exact balances, two balanced postings, correlation header |
| Business rejection | Insufficient funds remains rejected after later funding; frozen source/destination and destination limit reject without postings; unknown account returns a durable rejection |
| Durable idempotency | Same payload replays; changed source, destination, or amount conflicts; replay survives application shutdown and fresh startup |
| Concurrent duplicates | Twenty simultaneous requests alternate between independently wired application instances and produce one completed effect |
| Concurrent conflict | Two simultaneous different payloads with one key produce one creation and one conflict |
| Overspending | Twenty-four concurrent transfers from a source funded for ten successes produce exactly ten completions and fourteen rejections |
| Opposite directions | Twenty concurrent bidirectional transfers preserve both funded balances without lost updates |
| API boundaries | Invalid/missing/decimal/out-of-range amounts, unsupported unit, self-transfer, malformed JSON, invalid key, missing resources, invalid pagination, unsupported request media type (415), and unacceptable response media type (406) |
| Ledger pagination | Exclusive keyset cursor traverses the account's journal in order without duplicates |
| Real contention | A separate JDBC transaction holds a row lock; lock timeout causes a fresh retry that succeeds after release, or bounded exhaustion with 503 and no partial request |
| Real statement timeout | A held row lock with a shorter PostgreSQL statement timeout returns 503 without transaction retry |
| Spring transaction deadline | A pause after the first posting crosses the transaction deadline; the next JDBC call returns 503, rolls back both balances and the partial journal, and permits safe retry |
| Pool exhaustion | Holding both connections in a two-connection application pool produces 503, leaves no durable request, and recovers with the same key after release |
| Schema protection | Ordinary writes cannot invent value or make a user balance negative; incomplete processing, missing balance, invalid completion, and inconsistent projection fail; terminal transfer and ledger history cannot be changed |
| Reconciliation | Independent SQL sums and the HTTP snapshot report agree after workloads; controlled privileged corruption is detected without automatic repair |

The helper's funding fixture records a complete issuance transaction: a special `ISSUANCE` account receives a negative posting and the user receives the equal positive posting. Both balances and postings commit together. Each issuance account stays inside the supported range, and total ledger and materialized balances remain zero when issuance accounts are included. No public funding endpoint is introduced.

The generated workload uses `Random(20261011L)` for 120 transfers among six funded accounts and tracks an independent in-memory expected-balance model. It includes business rejections and duplicate retries. This is a reproducible generated invariant check, not a claim of formal verification or a shrinking property-test framework.

## Fault boundaries and ambiguous responses

`TransferFaults` is an injected interface with a stateless no-op production implementation. A test-only bean supplies bounded one-shot failures and response latches; no HTTP endpoint or runtime setting enables arbitrary faults.

| Boundary | Expected observation |
| --- | --- |
| Before transaction | No reservation, balances, or postings persist; an identical retry can execute |
| After first posting | The transaction rolls back both balances, the partial journal, and reservation |
| Before commit | All financial changes roll back; known transient SQLSTATEs retry with a fresh transaction |
| After commit | An injected response failure returns 500 while the completed transfer remains durable; a peer instance replays it |
| Before replay response | The response can fail without changing the original transfer or posting a second effect |

The suite also uses a real HTTP client timeout. The server pauses after successful database commit, the client times out after 500ms, and a second application instance recovers the same key while the original response is still paused. Exactly two postings remain for that transfer. This distinguishes lost acknowledgment from database rollback.

Synthetic nested SQL exceptions at the before-commit seam cover serialization failure (`40001`), deadlock (`40P01`), and lock timeout (`55P03`) classification. A repeated serialization failure exhausts exactly three attempts and leaves no durable row. Real database row-lock and statement-timeout tests separately exercise PostgreSQL error behavior. The tests do not deliberately provoke a real PostgreSQL deadlock or database failover.

The corruption test runs as the schema owner, temporarily disables `balances_reconcile`, changes one positive materialized balance, reenables the guard, and verifies that repeated reconciliation calls report the discrepancy without changing it. A `finally` block restores only that fixture's balance. This models privileged administrative corruption outside the runtime role's threat boundary.

## Recorded Phase 1 execution

On 11 October 2026, the local Java 21 build ran against actual PostgreSQL 17.11 through Testcontainers:

```sh
JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home \
./mvnw -B -ntp -Dmaven.repo.local=/private/tmp/tpp-m2 clean verify
```

Results: **40 tests, 0 failures, 0 errors, 0 skipped**. The 28-test PostgreSQL class completed in **13.83 seconds** in the latest complete run, which finished at 20:55:34 Singapore time. The three unit classes contributed 12 passing tests. These are executed results, not inferred from compilation. Individual assertions and timings are in the generated Surefire reports.

## Limits and benchmarks

The integration workload tests separate HTTP listeners and connection pools inside one JVM sharing one PostgreSQL server. It verifies that correctness depends on database transactions rather than an in-process lock, but does not simulate separate hosts, network partitions, PostgreSQL failover, durable-storage corruption, or power loss. Main integration requests use the database owner so that fixtures and controlled corruption can run; runtime-role restrictions are validated separately in the local setup, not counted among these 40 test assertions.

Thread barriers coordinate concurrent submissions. PostgreSQL row locks and explicit independent blocking connections provide genuine database contention. A successful run does not establish all possible schedules, fairness, capacity, or absence of every future deadlock.

Performance execution is separate from acceptance tests. See [benchmark methodology](benchmark-methodology.md) for dataset setup, worker counts, throughput, latency quantiles, transaction timing, lock sampling, errors, retries, and the measured low/high contention runs. Benchmarks do not replace invariant checks or justify production-readiness claims.

## Deployed runtime role probe

After the local seed, run `docker compose exec -T db psql -U tpp -d tpp < scripts/verify-runtime-role.sql`. The script switches to `tpp_app`, checks that issuance creation/completion, ledger updates and trigger disabling are refused, and rolls back every attempted mutation. This was executed successfully against the Compose PostgreSQL 17.11 deployment; it is separate from the 40 automated tests.

## Phase 2 contract, fault and upgrade checks

`EventContractTest` adds four unit tests for deterministic v1 encoding/validation, duplicate fields and concatenated JSON rejection, and bounded jitter. Producer acknowledgement/duplicate behavior is exercised through the real Kafka scenarios; the configured memory and timeout limits are documented and inspected rather than claimed as separate unit assertions. The complete unit subset is:

```sh
./mvnw -B -ntp -Dtest=DomainRulesTest,DatabaseErrorsTest,ApiErrorMappingTest,EventContractTest test
```

`EventPipelineTest` runs 19 integration scenarios with an actual Apache Kafka 4.3.1 broker and PostgreSQL 17.11. Each case uses a unique topic/group and isolated database. The test broker has a fixed available host-port binding so stopping/starting the same owned container preserves its advertised address and stored log. Cleanup is restricted to suite-owned containers and random databases; it never prunes unrelated Docker resources.

All F1–F10 boundaries execute, with assertions on absent/committed SQL effects, actual broker records or log end offsets, durable consumer offsets, inbox uniqueness and paired activity. Tests also cover concurrent request identity, fenced stale workers, permanent invalid-topic blocking and audited requeue, schema-enforced inbox atomicity, replay crash ambiguity, forged-origin/replay budget, and real database-lock retry while group membership changes. Two startup regressions inject Kafka construction errors: the exact unresolved-bootstrap cause retries before actual Kafka processing/offset progress, while other configuration failures stop without retry and retain the record for explicit recovery. Poison testing pauses immediately before offset commit to verify that its quarantine evidence is already committed. Production fault beans are stateless no-ops; test latches/failures are bounded. See the [failure matrix](failure-matrix.md) for individual methods and observations.

`OutboxMigrationUpgradeTest` first migrates a populated database to V1, records complete account/balance/ledger/transfer rows, then applies V2 through V4. It verifies exact preservation of those rows, one stable event per old completion (none for rejected history), immutable backfill and no changes on repeat migration, historical idempotency replay and reconciliation. The V4 transfer-history index must be present. This protects an existing Phase 1 installation rather than merely testing fresh migrations.

## Recorded full Phase 2 execution

The 11 October 2026 `clean verify` from a fresh local clone of implementation commit `503ed39` finished at **22:03:57 Singapore time** in **114 seconds**. It passed **64 tests, 0 failures, 0 errors, 0 skipped**:

| Class | Tests | Dependency |
| --- | ---: | --- |
| DomainRulesTest | 6 | Unit |
| DatabaseErrorsTest | 3 | Unit |
| ApiErrorMappingTest | 3 | Unit |
| EventContractTest | 4 | Unit |
| TransferPostgresTest | 28 | PostgreSQL |
| EventPipelineTest | 19 | PostgreSQL and Kafka |
| OutboxMigrationUpgradeTest | 1 | PostgreSQL |
| Total | **64** | **16 unit + 48 integration** |

The Kafka pipeline class took 93.860 seconds; the Phase 1 regression class took 9.997 seconds; the migration upgrade took 1.950 seconds. SpotBugs reported zero retained findings/errors, and dependency convergence/release checks passed. [Machine-readable verification](verification/phase2-clean-verify.json) preserves class counts and observed timings; Surefire generates the full reports in `target/surefire-reports`. The exact cache-configured local command was:

```sh
JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home \
MAVEN_USER_HOME=/private/tmp/tpp-maven-wrapper \
./mvnw -B -ntp -Dmaven.repo.local=/private/tmp/tpp-m2 clean verify
```

The fresh `tpp-phase2-validation` Compose project on PostgreSQL host port 55433, HTTP 18080 and Kafka 19092 passed startup, the restricted-role SQL probe, and `scripts/event-smoke.py`. An actual transfer and same-key replay produced one event and paired -7/+7 activity; financial and event reconciliations passed. These local execution checks are separate from the 64 automated tests. The final rebuilt image also passed an actual missing-service DNS experiment: with the Kafka container absent, readiness remained UP, construction retries were observed and a valid transfer committed; after broker recreation on its retained volume, the same app published/projected that event and reconciled cleanly. [Saved DNS recovery evidence](verification/phase2-dns-startup-recovery.json) is separate from the two injected constructor-failure tests. The original Phase 1 project was retained untouched.

GitHub Actions is configured to run the same clean tests/static/dependency checks, build the image, start a uniquely named Compose project, run the seed, runtime-role probe and actual event smoke, upload reports, and clean up only that project. **The hosted workflow has not been executed:** no remote/push is configured for this local repository. Local verification is not represented as hosted CI evidence.

Network/storage power loss, multi-broker Kafka replication/ISR failure, PostgreSQL failover and offset retention expiry remain outside the executed fault matrix. Injected Java crash seams model exact transaction/acknowledgement boundaries; they do not emulate host power failure. [Consumer reliability](consumer-reliability.md) defines the durability and ordering limits; [Phase 2 performance](phase2-performance.md) records separately executed backpressure experiments.

## Phase 3 bounded publication and admission checks

The final fresh clean clone of **`2c859cb28d3b1898a2a7d25c5c87d7a0a0a3dbe4` passed `clean verify`: 94 tests, 34 unit and 60 real dependency integration, with zero failures/errors/skips**. It completed in 3 minutes 31 seconds at **00:11:26 Singapore time on 12 October 2026**. SpotBugs at Max effort/Medium threshold reported zero bugs/errors; all four Enforcer rules passed for Java version, Maven version, dependency convergence and release dependencies. [Saved execution evidence](verification/phase3-clean-verify.json) includes every executed method, per-class times, report/log hashes and actual producer observations. [Final-image runtime acceptance](verification/phase3-final-acceptance.json) subsequently passed; its checks are separate from the automated test count.

Earlier gates remain preserved. The [first complete Phase 3 test phase](verification/phase3-initial-verify.json) passed 92 tests but failed its later SpotBugs stage. An added actual deferred-COMMIT scenario passed a [focused 10-test run](verification/phase3-commit-focused.json) with the reverse-ACK scenario and all eight batch unit checks. Reviewed fixes passed [separate static/dependency verification](verification/phase3-static-verify.json) at measured source `66dc7c9`. These historical and focused runs are distinguished from the final clean success.

Review also found a lifecycle scheduling race in which stop could capture the old worker before an already-admitted start assigned its replacement. After all twenty-eight timed windows, the [new regression against measured source `66dc7c9`](verification/phase3-lifecycle-red-green.json) failed the intended late-worker-interruption assertion, with one expected failure and no errors/skips. The minimal correction at `1737a27` passed the lifecycle and actual outstanding-send shutdown cases together: two tests, zero failures/errors/skips in 35.799 seconds. Reflection controls the scheduling window; the green restart uses actual HTTP/Kafka effects. This later correction changes lifecycle coordination, not the measured publication hot path, and was not rebenchmarked. [Separate skipped-test static/dependency verification](verification/phase3-lifecycle-static.json) passed in 7.559 seconds with zero SpotBugs bugs/errors; it is not a full-suite pass.

Two subsequent fresh clean-checkout runs failed different transport-fixture setup assertions. Their complete reports remain visible:

| Attempt | Observed result | Setup failure and follow-up |
| --- | --- | --- |
| [`1737a27`, finished 11 October at 23:48:50 Singapore time](verification/phase3-clean-first-failure.json) | 94 tests; 1 failure, 0 errors/skips; static stage not reached | Partial-batch test expected six outstanding sends but observed zero. Broker stop allowed synchronous metadata failures and unsent outcomes, so the intended state was not established. |
| [`7668f94`, finished 12 October at 00:02:27 Singapore time](verification/phase3-clean-second-failure.json) | 94 tests; 1 failure, 0 errors/skips; static stage not reached | The corrected partial-batch case passed, but shutdown setup expected one outstanding send and observed zero. The later real paused-broker correction passed focused execution, recorded separately below. |

The [corrected partial-batch case](verification/phase3-partial-bound-correction.json) passed focused execution with zero failures/errors/skips in 32.137 seconds and then passed in the second full-suite attempt. It pauses/unpauses the suite-owned real broker after explicitly observing two accepted ACKs and zero in-flight work. Test-only request/delivery limits are 10 seconds, lease 30 seconds and coordinator budget 11.5 seconds; six actual enqueues resume while enough delivery time remains to inspect the outstanding bound. Production and measured configuration stay unchanged.

The [shutdown correction](verification/phase3-shutdown-correction.json) also pauses the real broker after two accepted ACKs and zero in-flight work. Its first paused attempt established actual outstanding work but failed the unchanged eight-second assertion: a 10-second delivery setting made the configured stop budget 12 seconds. That failure remains recorded. Restoring the original five-second delivery and ten-second lease, with request timeout five seconds, passed one focused case with zero failures/errors/skips at 00:07:21 Singapore time on 12 October. Before stop, three send/enqueue attempts yielded two accepted ACKs, zero failed ACKs and one actual outstanding send. Stop took 7.002 seconds, left a terminated coordinator and zero in-flight work, retained four claims, and recovered their stable-ID projection effects with reconciliation. The manual coordinator uses a reusable executor thread, whose join can consume the configured stop budget even after its batch exits.

Final source `2c859cb28d3b1898a2a7d25c5c87d7a0a0a3dbe4` has the same production code as `1737a27`; later changes correct only test fixtures. Its final clean run passed both corrected scenarios, again observing six outstanding sends and two next claims, and one shutdown send followed by stop in 7.004 seconds. The 27-case pipeline class took 186.538 seconds; core PostgreSQL regressions took 9.541 seconds, admission integration 5.763 seconds and V1 upgrade 1.805 seconds.

Final deployment used image `sha256:3da213ca031c1f2aa0c229c35dcce2ee0bd5c719055e4c3186d335127bc5b0ee`, [built from the literal clean verified checkout](verification/phase3-final-build.json). Only the Phase 3 application at port 28080 was recreated. The [runtime role probe](verification/phase3-final-runtime-role.txt) verified restricted `tpp_app` writes; actual application-role connections and readiness UP were independently observed. [HTTP/event smoke](verification/phase3-final-http-event-smoke.json) submitted a new transfer and replayed its key, with exactly one stable event/inbox/projection, two ledger entries and paired -7/+7 activity. Financial reconciliation passed, and global event reconciliation observed 188,884 completed/published/processed/projected events with zero discrepancies, backlog or quarantine. Disabled admission returned `reason=disabled` and no sample.

[Acceptance completed at 00:14:35 Singapore time on 12 October](verification/phase3-final-acceptance.json), with independently inspected committed/log-end offsets 62,627, 63,202 and 63,055 in partitions 0, 1 and 2, each lag zero. [Runtime provenance](verification/phase3-final-runtime-provenance.json) confirms unchanged Phase 1/2 container identities/start times and retained Phase 3 database/broker identities, images and named data volumes. Broker start time had changed during the declared outage trials. The final image was accepted after the lifecycle correction; the optimized performance image at `66dc7c9` stayed fixed across measurement and was not rebenchmarked afterward.

The executed final suite contains 34 unit checks and 60 real-dependency integration scenarios:

| Class or preserved coverage | Passed tests | Dependency |
| --- | ---: | --- |
| Preserved Phase 1, event-contract and V1-upgrade classes | 45 | 16 unit + 29 PostgreSQL |
| EventPipelineTest | 27 | PostgreSQL and Kafka: 19 retained + 8 new |
| PublicationBatchTest | 8 | Unit |
| BacklogAdmissionTest | 10 | Unit: 6 ordinary + 4 threshold cases |
| BackpressurePostgresTest | 4 | PostgreSQL and real HTTP |
| Total | **94** | **34 unit + 60 integration** |

[PublicationBatchTest](../src/test/java/dev/tpp/events/PublicationBatchTest.java) checks immutable bounded claims/results; reverse acknowledgement mapping; unknown-token, unsubmitted and duplicate callbacks; deadline distinction between never-sent and uncertain work; topic/position validation and permanent error classification; synchronous failure winning over a later callback; 50 cancellation/callback races; and interruptible monotonic waiting. These are local callback-state assertions, not mock evidence of Kafka delivery or PostgreSQL commit.

The eight added [PostgreSQL/Kafka class methods](../src/test/java/dev/tpp/events/EventPipelineTest.java) cover the bounded relay/store and independent broker evidence. The lifecycle race schedule itself is explicitly simulated:

| Method | Assertions at the boundary |
| --- | --- |
| [`acknowledgedBatchWhoseActualStatusTransactionFailsRecoversWithoutOptimisticSuccess`](../src/test/java/dev/tpp/events/EventPipelineTest.java) | Four actual Kafka records exist; an independent table lock makes status SQL fail. Relay returns zero, success count does not increase, and four claims remain durable. Lease recovery republishes stable IDs and yields one effect each. |
| [`acknowledgedBatchCommitFailureRollsBackEveryStatusAndRecoversStableIdentities`](../src/test/java/dev/tpp/events/EventPipelineTest.java) | A suite-owned deferred constraint checks that all three acknowledged statuses were updated, advances a nontransactional test sequence, then raises `23514` at COMMIT. Relay returns zero; all status/token/owner/lease/attempt/time fields roll back and success metrics remain unchanged. Stable-ID resend yields two actual copies and one logical effect. Focused and final clean runs passed. |
| [`crashDuringRealInFlightBatchLeavesEveryClaimRecoverableAndIgnoresLateCallbacks`](../src/test/java/dev/tpp/events/EventPipelineTest.java) | Two real records and their ACK callbacks precede an owned broker pause. A third actual send remains outstanding when the coordinator crashes; late callbacks release permits while all four claims remain unchanged and no publication success is invented. Expiry/recovery completes the effects. |
| [`reverseRealAcknowledgementsSettleLiveRecordsWhileFencingOneReplacedGeneration`](../src/test/java/dev/tpp/events/EventPipelineTest.java) | Actual broker metadata is fed into batch state in reverse order. Two renewed generations settle with their individual offsets; the replaced token is excluded and the peer generation survives. Resending that event deduplicates its projection. |
| [`expiredBatchSettlementCannotOverwriteNewOwnerPublicationEvidence`](../src/test/java/dev/tpp/events/EventPipelineTest.java) | A paused acknowledged batch expires. A peer claims/publishes one event; releasing the stale coordinator applies zero old statuses and preserves the peer's offset. Remaining claims recover. |
| [`partialBrokerOutageAndDeadlineKeepActualProducerWorkBoundedAcrossTheNextBatch`](../src/test/java/dev/tpp/events/EventPipelineTest.java) — **corrected case passed** | Two actual accepted ACKs and zero in-flight sends precede real broker pause. Eight send/enqueue attempts yield two ACKs and six actual outstanding sends after the 11.5-second coordinator budget. The next batch claims no more than two records, rejects an overlapping coordinator, and keeps outstanding producer work within eight before callback drain, unpause and recovery. Test-only request/delivery limits are 10 seconds and lease 30 seconds. |
| [`shutdownWithActualOutstandingProducerWorkIsBoundedAndPreservesRetryEligibility`](../src/test/java/dev/tpp/events/EventPipelineTest.java) — **focused and final clean case passed** | Two accepted ACKs and zero in-flight work precede actual broker pause. Three send/enqueue attempts then produce two accepted ACKs, zero failed ACKs and one actual outstanding send. Final clean stop takes 7.004 seconds under the unchanged eight-second assertion, terminates the coordinator, releases work and blocks further batches; four claims recover and reconcile. Test-only request/delivery are five seconds and lease ten seconds. The manual executor join can consume the configured seven-second stop budget; arbitrary OS/JVM DNS construction remains outside this bound. |
| [`stopRecapturesAnAdmittedStartWorkerAndSameInstanceRestartPublishesRealEvent`](../src/test/java/dev/tpp/events/EventPipelineTest.java) — **red/green passed** | Reflection models the field writes of an already-admitted start while the stop thread is blocked on the relay lifecycle monitor. Stop recaptures, interrupts and terminates the replacement worker; a real same-instance restart then automatically publishes an actual HTTP completion through Kafka, produces one complete projection effect, advances offsets and reconciles. The simulated field-write schedule is not evidence that an uncontrolled JVM run naturally reproduced the race. |

The existing F6/F7 consumer crash scenarios also assert instrumentation semantics. Before SQL commit, the failed transaction/work/completion timers increase without a committed projection count or offset acknowledgement. After SQL commit but before offset commit, committed timers and the processed-effect counter increase once; restart records a duplicate without another processed effect. These checks distinguish durable effects, attempted processing, and acknowledged offsets.

[BacklogAdmissionTest](../src/test/java/dev/tpp/application/BacklogAdmissionTest.java) covers validated threshold/freshness combinations, disabled zero-query behavior, initially unknown and stale snapshots, all four count/age boundaries, hysteresis across every dimension, retained evidence during sampling failure, monotonic recovery, and overload error/correlation/Retry-After mapping. It uses a concrete monotonic clock and sample seam to make freshness decisions deterministic.

[BackpressurePostgresTest](../src/test/java/dev/tpp/BackpressurePostgresTest.java) adds four actual PostgreSQL/HTTP scenarios: disabled behavior; prior-key replay/conflict during pressure plus twelve concurrent new-key denials with no financial or key residue; published-without-inbox count/age closure and recovery; and a real sampling statement timeout that leaves stale evidence and rejects before mutations. A denied key succeeds after drain/recovery. Publication-state fixtures advance valid database transitions directly and invoke the production inbox processor; they are not independent Kafka delivery evidence. [Admission documentation](backpressure.md) states the best-effort sampling and overshoot limits.

Run only these new unit classes during development with `-Dtest=PublicationBatchTest,BacklogAdmissionTest`, or admission integration with `-Dtest=BackpressurePostgresTest`. Acceptance still requires the complete clean suite and actual Kafka regressions. No build, integration suite or image build runs concurrently with timed Phase 3 performance trials. The [matched methodology](phase3-benchmark-methodology.md) and [performance evidence](phase3-performance.md) retain those separate execution boundaries.

The [twenty completed primary performance trials](benchmarks/phase3-comparison-summary.json) separately observed eventual outbox/inbox/projection completeness, paired activity, passing ledger reconciliation, no sampled invariant failures or ambiguous client errors, and zero final committed-offset lag in all three partitions. The original shared-source suite retained nine dependency HTTP 503s; the [account-order audit](benchmarks/phase3-high-fixture-order-audit.json) documents a fixture confound. These observations supplement the fault assertions and remain distinct from the final clean verification.

The additional [250/s operating-point series](benchmarks/phase3-sustainable-250-summary.json) and [controlled shared-source series](benchmarks/phase3-high-controlled-summary.json) bring the retained comparison to twenty-eight measured trials. Optimized 250/s input ended with no publication or projection backlog and 304–314 ms propagation p99, across thirty-second windows with local shedding. After its third trial, the global inspection gate failed on a PostgreSQL parallel-query shared-memory allocation under the unchanged 64 MiB `/dev/shm` limit. [Independent reconfirmation](benchmarks/phase3-sustainable-250/o3-post-stop-reconfirmation.json) found 178,795 global effects complete, zero discrepancies and caught-up offsets with the same app/configuration. The fourth trial continued once in a separate retained timeline, preserving the stopped attempt and observation gap. No measured condition was rerun or resource configuration changed.

The controlled fixture extension used [seven separately executed offline checks](verification/phase3-controlled-harness.json) at harness `b11a593`, after the original twenty-four trials. All eight destinations sort below the source; the measured application images stay unchanged. Its B/O/O/B runs retained 7/3/2/10 dependency HTTP 503s and approximately 712 ms HTTP p99, despite passing final scoped effects, ledger and committed-offset checks. These finite workload results do not imply clean HTTP behavior or production capacity.

Performance recovery observations have narrower boundaries than the fault tests. Outage attempt counts do not independently count Kafka duplicates. Consumer-delay restoration recreates the entire app, including producer, pool and JVM; both optimized fixtures finished before the fresh recovery snapshot, so no recovery processing rate was observed. The 500/s sustained input still built consumer backlog and shed arrivals locally. Those limits remain visible in the reports.
