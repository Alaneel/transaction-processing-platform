# Query plans and indexing

[Raw `EXPLAIN (ANALYZE, BUFFERS)` output](query-plans.txt) was captured on the validation Compose PostgreSQL 17.11 database after the two recorded benchmarks, with `ANALYZE` run first. Demo Alice had only two postings; the 16-worker shared source had thousands. The raw file includes table row counts. These observations describe this dataset and planner statistics, not guaranteed plans at other sizes.

The globally unique `transfers(idempotency_key)` constraint supplies an index for durable replay lookup: the recorded plan is an index scan with one returned row. Reservation inserts use that same unique index to arbitrate duplicate concurrent requests. Transfer-ID GETs use the primary key.

`ledger_entries(account_id,id DESC)` supports bounded keyset pages and the account-filtered history sum. An ascending page can scan that index backward. For the tiny Alice subset, PostgreSQL chose a bitmap index/heap scan plus a small sort; for the shared-source page the recorded output shows the planner's choice over the larger subset. Pagination is bounded by LIMIT and never uses deep OFFSET scans.

Projection verification sums all postings for each changed account, with `NUMERIC` aggregation. Its recorded shared-source plan shows the indexed account access and the full row count consumed. There is no claim that the sum is constant time. Because the commit triggers may check the account several times, longer shared histories impose a real cost even when locks are acquired immediately. The benchmark includes that enforcement cost.

The ordered locking query has a Sort on `a.id` below LockRows, confirming that rows reach the locking node in PostgreSQL UUID order for the captured plan. Tiny account/balance tables may use sequential scans and a hash join rather than primary-key probes; that choice is reasonable for the small measured dataset. Future large-dataset testing should recheck estimates, buffer activity and transaction duration before adding indexes.

Reproduce after loading the demo fixture:

```sql
ANALYZE ledger_entries;
ANALYZE transfers;
ANALYZE accounts;
ANALYZE balances;
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM ledger_entries
WHERE account_id='00000000-0000-0000-0000-000000000002' AND id>0
ORDER BY id LIMIT 21;
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM transfers WHERE idempotency_key='demo-transfer-001';
```

Use a funded shared account from a saved benchmark dataset manifest to inspect the full-history sum. `EXPLAIN ANALYZE` executes its query; an ordered `FOR UPDATE` plan acquires locks, so collect that plan outside active load in a short transaction. The recorded plans were collected after workloads completed.
