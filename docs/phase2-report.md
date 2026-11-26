# Transaction Processing Platform Phase 2 Completion Report

Phase 2 is complete locally. The preserved transactional ledger now drives recoverable Kafka delivery and a durable account activity projection. A clean checkout passed 64 tests, including every Phase 1 regression and all required event failure scenarios. The final Docker image passed real HTTP, database privilege and absent Kafka DNS recovery checks on 11 October 2026.

## Implemented

Versioned `TransferCompleted` events commit in a PostgreSQL outbox with the existing request identity, terminal transfer, balances and paired postings. A Flyway upgrade backfills completed Phase 1 history without rewriting financial records. Rejected requests and idempotent replays create no extra event.

The relay provides bounded claims, expiring ownership tokens, fenced status writes, capped retry jitter, Kafka delivery metadata and audited requeue. The consumer validates the contract and immutable local origin, deduplicates through a durable inbox, and creates queryable debit and credit activity. Poison records enter PostgreSQL quarantine before acknowledgement; bounded replay preserves identity and an audit trail. Inspection APIs, reconciliation, metrics, OpenAPI, Compose and CI configuration are included.

## Architecture

The system remains a Java 21 and Spring Boot 4.1.1 modular monolith using explicit JDBC, PostgreSQL 17.11 and Kafka 4.3.1. PostgreSQL remains the authority for spendable balances.

The financial transaction commits its outbox event before the HTTP response. Relay claiming and publication status each use short SQL transactions, with Kafka communication between them. The consumer commits inbox identity, transfer projection and two activity rows in one database transaction. Its Kafka offset advances afterward, including when the durable result is quarantine. Database transactions and Kafka acknowledgements have separate durability boundaries.

## Correctness

Executed regressions verified balanced immutable postings, conserved value, nonnegative user balances, safe concurrent spending, durable request idempotency and rollback of partial mutations. The populated V1 upgrade preserved complete account, balance, transfer and ledger snapshots.

Every committed completion has one immutable logical outbox identity. Kafka may contain duplicates, while the unique inbox and transactional projection protect one successful activity effect per event. Database guards reject incomplete consumer effects and mutation of protected history. Financial and projection reconciliation passed after fault and benchmark recovery. These guarantees assume the documented privileges, storage durability and retention horizon; they do not establish universal exactly-once transport or formal verification.

## Fault Injection

All required scenarios executed against real PostgreSQL and Kafka, with intermediate SQL state, independent broker records/offsets and final projection assertions. [The failure matrix](failure-matrix.md) records detailed boundaries.

| Scenario | Observed outcome |
| --- | --- |
| F1 Financial rollback | No completed transfer, partial postings or committed outbox event survived. |
| F2 Lost response after commit | The prior durable result replayed with one logical event. |
| F3 Kafka unavailable | Valid transfers committed; retained events published and projected after recovery. |
| F4 Relay crash before send | The durable claim expired and a replacement delivered the event. |
| F5 Kafka accepted before status write | Resend produced duplicate transport with stable identity and one activity effect. |
| F6 Consumer crash before SQL commit | Inbox and projection rolled back; redelivery completed them together. |
| F7 Consumer commit before offset commit | Redelivery found the inbox and did not repeat activity. |
| F8 Poison message | Quarantine committed before offset advancement; later valid records and audited corrected replay proceeded. |
| F9 Multiple relay owners | Competing claims progressed; stale tokens could not overwrite replacement ownership. |
| F10 Consumer handoff | Shutdown/reassignment retained the unacknowledged record and safe deduplication. |

Additional tests covered forged origins, replay identity/budget, permanent blocking/requeue, real database contention during rebalance and startup error classification. The final image also started with Kafka's service container and DNS name absent: readiness remained UP, a transfer committed, six construction retries were observed, and the same app published/projected the event after Kafka returned. [Deployment evidence](verification/phase2-dns-startup-recovery.json) confirms the original Phase 1 containers and volumes remained unchanged.

## Tests

Implementation commit `503ed39` passed `./mvnw -B -ntp clean verify` from a fresh local clone in 114 seconds, finishing at 22:03:57 Singapore time. The actual command used explicit writable Maven caches, as recorded in [testing instructions](testing.md).

| Verification | Executed result |
| --- | --- |
| Unit tests | 16 passed |
| Core PostgreSQL regressions | 28 passed |
| PostgreSQL and Kafka pipeline scenarios | 19 passed |
| Populated V1 migration upgrade | 1 passed |
| Total | 64 passed; zero failures, errors or skips |
| SpotBugs Max effort and Medium threshold | Zero retained findings or analysis errors |
| Dependency convergence and release checks | Passed |
| Final Compose image | Healthy; HTTP/event smoke and restricted runtime-role probe passed |

[Clean-checkout results](verification/phase2-clean-verify.json), [final HTTP/event smoke](verification/phase2-final-http-event-smoke.json) and [runtime-role evidence](verification/phase2-final-runtime-role.txt) preserve observations. GitHub Actions is configured; hosted CI has not run because the repository has not been pushed.

## Performance

Four matched trials used eight clients, fresh independent account pairs/JVMs, three seconds of warmup and ten seconds of measured load on an Apple M2 Max with 32 GiB RAM. Docker allocated 13 virtual CPUs and 7.667 GiB RAM. Relay-enabled HTTP completion measured 1,125.9 and 1,241.4 transfers/s; disabled trials measured 1,051.8 and 1,357.3/s. All four had zero HTTP failures. Variation prevents a precise causal estimate of activation overhead.

The default relay drained backlog at approximately 106–124 recorded publications/s across observed catchup intervals. Creation exceeded publication, so enabled-trial propagation p99 reached 122.41 and 140.60 seconds. These SQL timestamp measurements include queue waiting and warmup; timestamps are captured inside transactions, rather than at WAL commit.

During an actual five-second broker outage, all 8,120 requests completed and retained their events. Recovery without an app restart produced 8,120 projection effects and 16,240 activity rows. A slowed active consumer processed 8.24/s while publication measured 62.3/s; restoring normal processing drained all 5,309 events. The shared-source trial completed 566 of 569 requests and retained three HTTP 503 responses, with 67 internal retries and evidence of PostgreSQL lock timeouts. Every committed event subsequently projected once and reconciled cleanly.

The backlog claim query used an index, examined 33 candidates to claim 16 events, and completed its update in 2.179 ms. This observation supports investigating sequential sends, polling and per-event status work before changing indexes. [The performance report](phase2-performance.md) includes raw reports, resource/lock samples, exact observation intervals and uncertainty. Timings belong to the recorded benchmark image; the final startup fix was verified separately.

## Limitations

The local deployment has one broker with replication factor one, no authentication/authorization, and no tested PostgreSQL failover, host power loss or storage corruption. Injected crashes verify specific transaction boundaries, without emulating those broader failures.

Kafka retention is seven days; automatic reconstruction after unread records expire is not implemented. SQL history is retained indefinitely and reconciliation costs grow with history. Application buffering is bounded, while durable backlog and disk usage can grow under sustained overload. Privileged database owners can bypass protections. Consumer retry counters/backoff are process-local, and operating-system DNS construction can outlast the bounded shutdown join. This is educational infrastructure with documented assumptions, not a production readiness claim.

## Resume Candidates

- Built a Java/PostgreSQL/Kafka platform with an atomic outbox, fenced relay leases, durable consumer deduplication and audited quarantine replay while preserving double-entry ledger invariants.
- Validated rollback, ambiguous publication, consumer crashes, competing publishers and rebalance recovery through 64 automated tests, including 48 real dependency integration tests.
- Measured HTTP throughput, publication capacity, lock contention and recovery, exposing the gap between approximately 1,200 HTTP transfers/s and 106–124 recorded publications/s under the local configuration.

## Phase 3

1. Design and test archival, retention and projection reconstruction so broker expiry and long-lived SQL history have an explicit recovery policy.
2. Exercise replicated Kafka and PostgreSQL backup/restore or failover, including storage and network failure assumptions beyond single-host restart.
3. Increase measured relay/projection capacity with bounded concurrency or batching, preserving fencing, duplicate tolerance and safe offset acknowledgement; validate with longer repeated and fixed-arrival workloads.
