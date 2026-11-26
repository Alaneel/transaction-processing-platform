# ADR 002: enforce final ledger invariants in PostgreSQL

Status: accepted.

## Context

A transfer writes several related rows: its durable idempotency identity, two balances and two immutable postings. Individual check constraints cannot express a two-posting journal or prove that a materialized balance agrees with all ledger history. Application validation alone would permit an incorrect persistence path to commit inconsistent accounting.

Phase 1 executes transfers synchronously. It needs a temporary reservation state inside the transaction, but has no background worker that can complete a persisted pending transfer. Unknown-account requests need durable business rejection and replay.

## Decision

Use explicit JDBC transactions at `READ COMMITTED`, deterministic database UUID ordering for account/balance locks, and `DEFERRABLE INITIALLY DEFERRED` PostgreSQL constraint triggers for cross-row invariants. Every transfer is inserted as `PROCESSING` and transitions exactly once to `COMPLETED` or `REJECTED`. `PROCESSING` is uncommittable.

At commit, completed transfers require exactly their source debit and destination credit with equal magnitude; rejected transfers require no postings. Every changed account must have a balance matching its ledger sum. `USER` balances are nonnegative. Summation uses `NUMERIC`; individual values use bounded `BIGINT` integer minor units in the fictional single unit `FIC`.

A before-insert posting trigger locks the transfer and affected balance row. This ensures all ledger writers participate in projection-row serialization. The application already owns the reservation and both ordered balance locks before posting. The verifier takes a fresh statement snapshot after acquiring its balance lock.

Protect ledger and terminal-transfer history with immediate mutation guards and deny runtime update/delete/truncate capabilities where they are not required. Explicit statement triggers cover `TRUNCATE`. Account identity/kind/unit and balance identity are immutable. Every account must receive its zero balance in the creating transaction.

Transfer request source/destination IDs have no foreign keys so unknown-account rejections can be persisted. Actual postings retain foreign keys, and the exact completed-journal check connects them to the requested pair.

Use a bounded-negative issuance account only through owner-operated fixtures. The public service rejects issuance participation. The named runtime role `tpp_app` cannot create issuance accounts or complete issuance transfers, but may durably reject such reservations. Migrations use separate owner credentials and the fixed `public` schema.

## Consequences

An exception during writes or deferred checking rolls back the complete journal, balances and reservation. A response failure after commit is recovered through the durable idempotency result. No persisted processing state or repair worker is required.

The schema is specific to PostgreSQL. Tests use real PostgreSQL and cannot substitute an in-memory database. Multi-statement read-only reconciliation uses `REPEATABLE READ` to avoid inconsistent snapshots during concurrent activity.

Full account-ledger summation at commit is straightforward to inspect and test, but its work grows with account history and lengthens lock occupancy under contention. Duplicate deferred invocations add cost. Benchmark results should expose that cost; an optimization must preserve the invariant under direct SQL and concurrent application instances.

The database owner and superuser can bypass controls by changing schema/trigger definitions. Separate runtime privileges reduce accidental mutation and restrict the application credential; they do not establish protection from a malicious administrator or untrusted arbitrary application SQL. Administrative fixtures and corruption tests must run only on isolated data with owner credentials.

Application business rules, including active-account eligibility and HTTP validation, stay in the service. Database checks enforce the accounting state, value range, journal correspondence, projection consistency and immutable history. Cross-currency exchange, real funding, authentication and asynchronous settlement remain outside Phase 1.
