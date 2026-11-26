# Code map

Start with a boundary, then read the implementation and its failure assertions together. This is one modular monolith; the folders do not imply independently deployed services.

| Question | Implementation | Evidence and design |
|---|---|---|
| What happens inside the financial transaction? | [TransferService](../src/main/java/dev/tpp/application/TransferService.java), [LedgerStore](../src/main/java/dev/tpp/persistence/LedgerStore.java) | [TransferPostgresTest](../src/test/java/dev/tpp/TransferPostgresTest.java), [ADR 001](adr/001-transaction-boundary.md) |
| What prevents partial or rewritten history? | [V1 ledger migration](../src/main/resources/db/migration/V1__transactional_ledger.sql) | [Ledger invariants](ledger-and-invariants.md), [ADR 002](adr/002-database-invariants.md) |
| Why can transfers commit without Kafka? | [V2 outbox migration](../src/main/resources/db/migration/V2__transactional_outbox.sql) | [ADR 004](adr/004-transactional-outbox.md), failure matrix F1–F3 |
| How do claims, deadlines and stale workers interact? | [OutboxRelay](../src/main/java/dev/tpp/events/relay/OutboxRelay.java), [OutboxStore](../src/main/java/dev/tpp/events/relay/OutboxStore.java), [PublicationBatch](../src/main/java/dev/tpp/events/relay/PublicationBatch.java) | [Outbox algorithm](outbox.md), [PublicationBatchTest](../src/test/java/dev/tpp/events/PublicationBatchTest.java), [ADR 009](adr/009-bounded-batch-relay.md) |
| What makes redelivery safe? | [EventProcessor](../src/main/java/dev/tpp/events/consumer/EventProcessor.java), [EventConsumerWorker](../src/main/java/dev/tpp/events/consumer/EventConsumerWorker.java), [V3 inbox migration](../src/main/resources/db/migration/V3__durable_consumer_projection.sql) | [EventPipelineTest](../src/test/java/dev/tpp/events/EventPipelineTest.java), [consumer reliability](consumer-reliability.md), [ADRs 006–008](adr/) |
| Where is one transfer in the pipeline? | [TransferDeliveryController](../src/main/java/dev/tpp/events/TransferDeliveryController.java), [transfer client](../scripts/transfer-client.py) | [State definitions](operations.md#transfer-delivery-progress), [local demo](demo.md#check-a-transfers-delivery-progress) |
| What happens when the browser loses a committed response? | [Browser demo](../src/main/resources/static/demo/index.html), [receipt UI](../src/main/resources/static/demo/demo.js), [scoped response drop](../src/main/resources/static/demo/delivery-worker.js) | [Browser walkthrough](demo.md#try-the-browser-demo) |
| How is overload rejected without leaving a key reservation? | [BacklogAdmission](../src/main/java/dev/tpp/application/BacklogAdmission.java), [BacklogSampler](../src/main/java/dev/tpp/application/BacklogSampler.java) | [BackpressurePostgresTest](../src/test/java/dev/tpp/BackpressurePostgresTest.java), [ADR 010](adr/010-sampled-backlog-admission.md) |
| How are independent checks performed? | [ReconciliationService](../src/main/java/dev/tpp/application/ReconciliationService.java), [ProjectionService](../src/main/java/dev/tpp/events/consumer/ProjectionService.java) | [Ledger invariants](ledger-and-invariants.md), [runtime acceptance](verification/phase3-final-acceptance.json) |
| How were the measurements generated? | [Event benchmark](../scripts/event-benchmark.py), [experiment orchestrator](../scripts/phase3-experiments.py), [summary generator](../scripts/summarize-phase3.py) | [Matched methodology](phase3-benchmark-methodology.md), [retained raw reports](benchmarks/) |

## A fifteen-minute reading path

1. Read `TransferService.submit/execute` and the V1 deferred checks. Locate the commit boundary and the distinct business rejection/rollback paths.
2. Read the V2 completion trigger. It explains why replay cannot generate a second logical event and why Kafka cannot hold a financial transaction open.
3. Read the relay's claim → renew → send → freeze → settle sequence and the immutable callback slots. Inspect `acknowledgedBatchCommitFailureRollsBackEveryStatusAndRecoversStableIdentities` and `partialBrokerOutageAndDeadlineKeepActualProducerWorkBoundedAcrossTheNextBatch` in `EventPipelineTest`.
4. Read `EventProcessor.applyWithinTransaction` and the worker's explicit offset acknowledgement. Inspect F6/F7 in the [failure matrix](failure-matrix.md), including the duplicate after commit.
5. Compare all four low-contention trials in the [performance report](phase3-performance.md). Faster propagation, lower HTTP throughput and the later unbenchmarked lifecycle fix are part of the same engineering result.

The [walkthrough](portfolio-walkthrough.md) connects these choices into the measured optimization story. The [operations reference](operations.md) retains the complete API, configuration and historical verification details.
