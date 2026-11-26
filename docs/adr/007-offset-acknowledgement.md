# ADR 007: Sequential processing and explicit post-commit offsets

Status: accepted, 2026-10-11.

Disable Kafka automatic commits and poll one business record at a time on each worker's Kafka-owning thread. Commit only that partition's `offset + 1` after PostgreSQL inbox/projection or quarantine commit. Rebalance callbacks commit nothing; shutdown fences subsequent acknowledgements. A failed/ambiguous offset acknowledgement safely repeats inbox processing.

During transient retry, pause delivery but poll for liveness and rebalances. Newly assigned records returned inside that poll are sought back to their original positions. Committing a later offset without this accounting could permanently skip an earlier unprocessed effect.

The simpler sequential design trades throughput for inspectable offset safety. Multiple instances can handle separate partitions. No parallel executor or contiguous-offset tracker is implemented. A future parallel consumer must prove its acknowledgement accounting, rather than copying this single-record strategy into asynchronous work.
