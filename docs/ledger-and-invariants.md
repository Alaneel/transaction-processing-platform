# Ledger and invariants

The ledger is the authoritative history. `balances` is a materialized projection used for locked, constant-time spend checks. PostgreSQL verifies that projection against the ledger before a transaction commits. Reconciliation independently recomputes the same relationships from a consistent database snapshot.

## Exact values and issuance

`FIC` is a fictional unit with integer minor units. There is no exchange rate, real-money integration, or floating-point value calculation. An individual transfer is in `1..9,000,000,000,000,000`. A ledger delta is nonzero with absolute magnitude at most that limit. A balance is in `-9,000,000,000,000,000..9,000,000,000,000,000`; `USER` balances additionally must be nonnegative. PostgreSQL `BIGINT` stores the individual values; aggregate ledger sums use `NUMERIC`, so an aggregate cannot overflow a 64-bit integer.

Ordinary transfers conserve value. For a transfer of `n` from account `s` to account `d`, the only valid completed journal is:

| Account | Ledger delta | Materialized change |
| --- | ---: | ---: |
| Source `s` | `-n` | `-n` |
| Destination `d` | `+n` | `+n` |
| Total | `0` | `0` |

The controlled funding fixture uses an `ISSUANCE` account. Its negative balance records issued value as an equal liability inside the same model. Giving a user `1,000,000` produces an issuance debit of `-1,000,000` and user credit of `+1,000,000`. The total remains zero, including the issuance account. Issuance still has the supported balance bound and must reconcile.

`scripts/seed-demo.sql` creates fixed account IDs ending in `0001` for issuance, `0002` for Alice, and `0003` for Bob. It posts two distinct, completed issuance transfers of `1,000,000` each. An advisory transaction lock serializes repeated seed runs. Fixed idempotency keys make rerunning the fixture safe without resetting existing balances or journal entries. Run the seed with owner credentials after migrations.

The public API creates and returns only `USER` accounts and rejects transfers involving issuance accounts. The runtime database role `tpp_app` also cannot create an issuance account or complete a transfer involving one. It can reserve and reject such a request, preserving durable rejection and replay semantics. Controlled fixtures and benchmarks use the schema owner; there is no public funding endpoint.

## Commit boundary

The synchronous state machine is `PROCESSING -> COMPLETED | REJECTED`. `PROCESSING` exists only inside the transaction that reserved the idempotency key. A deferred constraint trigger rejects a commit that would leave it durable. Terminal rows cannot be updated or deleted.

One PostgreSQL transaction reserves the transfer, locks the account and balance rows, checks business rules, updates both balances, inserts both postings, and transitions the transfer to its terminal state. Infrastructure failure rolls back that entire transaction, including the idempotency reservation. A business rejection commits a terminal transfer with no postings and no balance changes. The HTTP response is produced after the transaction manager successfully commits, including deferred checks.

`DEFERRABLE INITIALLY DEFERRED` constraint triggers inspect the transaction's final state. This permits the temporarily incomplete journal needed while writing two postings, but enforces these facts at commit:

1. Every account has one balance row.
2. Every completed transfer has exactly two postings: its source debit of exactly `-amount` and its destination credit of exactly `amount`. Their sum is zero.
3. A rejected transfer has no postings.
4. No transfer remains `PROCESSING`.
5. Every account whose balance or ledger changed has a materialized balance equal to its full ledger sum.
6. A `USER` account has a nonnegative balance.

The nonnegative `USER` check also runs immediately before balance insert/update. Primary keys, foreign keys, checks and uniqueness enforce identities, supported values, `FIC`, valid state shape, distinct source/destination IDs, and one posting per transfer/account pair.

Requested account IDs on `transfers` deliberately have no foreign keys. This allows a rejected request for an unknown account to remain durable and replayable. Actual postings reference existing transfers and accounts with foreign keys. The completed-transfer constraint requires the exact requested account pair, so a completed transfer cannot use the unknown-account exception.

## Concurrent correctness

The application uses `READ COMMITTED` and database row locks. It first reserves the globally unique idempotency key with `INSERT ... ON CONFLICT DO NOTHING`. A concurrent duplicate waits for the first transaction to finish; the next SQL statement sees its committed result under `READ COMMITTED`. Payload equality produces replay; a different payload produces an explicit conflict.

For a new reservation, a single query locks account and balance rows in PostgreSQL UUID order. It locks account status as well as balance, so a simultaneous status change cannot invalidate the application's check before commit. These locks are shared by every application instance connected to the database. They remain held while the source funds and destination capacity are checked and the journal is written.

Before a posting is inserted, a trigger locks its transfer row and the affected balance row. The application already holds these locks. Requiring every ledger writer to lock the projection row prevents a deferred projection check from racing another transaction's posting. The projection verifier acquires the balance lock and then performs its sum in a separate SQL statement, obtaining a fresh `READ COMMITTED` snapshot after any lock wait. Existing postings cannot change because the ledger is immutable.

The application's sorted pair locking avoids its opposite-direction balance-lock cycle. Arbitrary direct SQL writers that acquire locks in another order can still deadlock; PostgreSQL aborts a participant. The application retries only classified transient transaction errors with bounded attempts. Timeouts and infrastructure failures never become successful or rejected financial outcomes.

## Immutable history and privileges

Before-row triggers reject all ledger updates and deletes, all account/balance/transfer deletes, balance identity changes, account identity/kind/unit/creation-time changes, and terminal transfer changes. Separate before-statement triggers reject `TRUNCATE`, which bypasses row deletion triggers. A posting may be appended only while its transfer is `PROCESSING`. Transfer request identity, payload and creation time cannot change while finishing the reservation.

The local setup uses separate migration-owner and runtime credentials. Flyway grants `tpp_app` only:

| Resource | Runtime permissions |
| --- | --- |
| `accounts` | `SELECT`, `INSERT`, `UPDATE(status)` |
| `balances`, `transfers` | `SELECT`, `INSERT`, `UPDATE` |
| `ledger_entries` | `SELECT`, `INSERT` |
| Ledger identity sequence | `USAGE`, `SELECT` |
| `public` schema | `USAGE` |

The account update permission also permits `SELECT ... FOR UPDATE OF accounts`; no account-status mutation endpoint is exposed. Runtime has no history deletion, truncation, schema ownership, or trigger-disabling permission. Public schema creation and public execution of the trigger functions are revoked. Functions resolve a fixed `pg_catalog, public` search path, and ledger table references are explicitly qualified. Migrations and the application use the `public` schema.

This model assumes trusted application code, a restricted runtime credential, PostgreSQL enforcing its transactions/triggers, and owner credentials being reserved for migration and controlled fixtures. It does not protect against a schema owner or superuser deliberately disabling/dropping triggers, altering tables, restoring modified data, or changing role grants. SQL executed with owner credentials is an administrative capability. Application decisions such as rejecting frozen accounts are enforced by the service under account locks; the database's accounting guards protect amounts, journal shape, projection agreement and immutable history.

## Reconciliation and cost

`GET /internal/reconciliation` runs read-only at `REPEATABLE READ`, so its multiple queries share one snapshot while transfers continue. It reports accounts with missing/mismatched balances or negative `USER` balances, invalid transfer journals/transient states, total ledger delta, and total materialized balance. Both totals should be zero when issuance accounts are included. It reports inconsistencies without repairing or rewriting history.

The controlled corruption test temporarily disables only `balances_reconcile` as the owner, changes a positive balance without a posting, reenables the guard, and verifies that reconciliation reports the discrepancy. Ordinary runtime SQL cannot perform this trigger alteration. Reenabling a trigger does not retrospectively repair corrupt data; the test restores its own fixture explicitly.

Commit-time projection verification sums the account's entire posting history. The `(account_id, id DESC)` index supports account-ledger access and account-filtered sums, but the sum still grows with that account's history. Both balance changes and postings schedule verification, so a completed transfer performs repeated account checks at commit. This intentionally favors an inspectable correctness guarantee over high throughput. It extends the time that hot account locks are held. Performance results must therefore state workload contention and accumulated ledger size. A future optimization needs equivalent concurrency guarantees and measured evidence before replacing the full-sum check.

The unique idempotency-key index serves reservation/replay, primary keys serve resource lookup, the transfer/account unique index serves completed-journal verification, and the account/entry index serves keyset ledger pagination. There are no unused source/destination-transfer indexes or asynchronous messaging tables in Phase 1.
