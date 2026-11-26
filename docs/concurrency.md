# Concurrent correctness

## Choice and alternatives

Transfers use row-level pessimistic locking at PostgreSQL `READ COMMITTED`. The account and balance rows for both participants are fetched with `ORDER BY a.id FOR UPDATE OF a,b`. PostgreSQL's UUID comparison is the order for every application instance; Java UUID comparison is not used because its signed long ordering differs for some UUIDs. The reservation row precedes these locks. Ledger insertion guards reacquire locks already held by the transaction.

This makes the rules easy to inspect: sufficient funds and destination headroom are evaluated from balances protected until commit, followed by SQL increments and corresponding journal writes. No Java synchronized blocks, cache state or process identity participates in correctness.

Optimistic versions would force hot-account retries and complicate multi-row atomicity. Conditional updates can prevent a source overdraft but still need ordered coordination for destination bounds and postings. Serializable transactions would detect more anomalies than these two-row invariants require and introduce additional aborts. None offers a demonstrated benefit in this Phase 1 workload. The chosen approach sacrifices concurrent execution on one shared account for straightforward correctness.

## Workloads and reasoning

- Same source: all writers contend on that row. Each committed debit reduces the amount the next writer observes. Eventually insufficient funds becomes a durable business rejection, not a negative balance.
- Opposite direction: both operations acquire the same two rows in the same order. There is no source-then-destination cycle. Every completed transfer still has one negative and one positive posting.
- Same idempotency key: the unique insert waits on the reserving transaction. After its commit, a fresh statement sees and compares the result. After rollback, a competing request may insert and execute. Same payload replays; different payload conflicts. A lock timeout produces 503 or a bounded fresh attempt, never an invented success.
- Independent account pairs: financial row locks do not overlap, so transactions can execute concurrently, subject to shared CPU, WAL, disk and pool resources.
- Frozen account: account rows are locked alongside balances, so an administrative status change waits behind a current transfer, or a subsequent transfer observes the changed status. There is no public status-edit endpoint.

## Retry and timeout policy

Each retry owns a new database transaction, including a fresh reservation. Retry only 40001, 40P01 and 55P03, at most three attempts with bounded exponential jitter. Constraint violations, business rejections and unexpected runtime exceptions are not retried. 57014 statement cancellation, 57P01/57P02/57P03 database shutdown, Spring transaction deadline expiry and connection errors are dependency failures; they are not automatically retried. Interrupted backoff restores Java interruption and returns 503. `SET LOCAL` equivalents (`set_config(..., true)`) ensure lock/statement settings cannot leak into another pooled request.

Deterministic ordering prevents the transfer path's ordinary two-account cycle; deadlocks can still arise from owner-written administrative SQL, other transaction patterns, DDL, or future features. The classification handles PostgreSQL's deadlock/serialization signals but does not claim they can never occur. Direct SQL writers also receive schema checks; if they acquire accounts in a different order they must tolerate deadlock aborts.

The lock timeout covers waiting on balance/account locks and the unique-key reservation. Long contention can exhaust three attempts and return 503. The identical key remains the recovery identity. If COMMIT succeeds but the connection or client response fails, retrying it retrieves the terminal transfer instead of posting again. No server response claims completion before commit.

## Connection pool exhaustion and multiple instances

Each process has its own finite pool (default16). When all connections are occupied, acquisition waits at most two seconds and maps to 503. Running more instances increases database connections and offered contention, not the number of writers that can safely spend one balance. The DB must be sized for total pools and other clients. There is no admission queue or cross-instance rate limiter in Phase 1. Servlet threads are capped64, and deployment/session limits need further measurement.

Tests start independently wired application contexts and HTTP listeners against the same PostgreSQL database. Workloads alternate between them, use separate JDBC connections and barriers, and verify final SQL totals and snapshot reconciliation. A stopped application context is replaced to verify persistent replay. This checks shared-database correctness; it does not simulate hosts, network partitions, database failover or a PostgreSQL cluster.

## Cost and measured behavior

The ledger projection guard scans each affected account's full indexed posting history at commit. It can run more than once per account in one transaction because balance and ledger triggers are independently deferred. This deliberately prioritizes strong defense against application/SQL bugs over throughput. High contention therefore combines serialization with growing historical scan cost. [Benchmark methodology](benchmark-methodology.md) and the recorded raw runs document actual results. They do not establish production capacity, open-loop saturation or fairness guarantees.
