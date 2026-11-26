package dev.tpp;

import static dev.tpp.KafkaTestSupport.await;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import dev.tpp.application.TransferFaults;
import dev.tpp.events.EventFaults;
import dev.tpp.events.EventSettings;
import dev.tpp.events.consumer.EventConsumerWorker;
import dev.tpp.events.relay.OutboxRelay;
import dev.tpp.events.relay.OutboxStore;
import dev.tpp.events.relay.PublicationBatch;
import io.micrometer.core.instrument.MeterRegistry;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.Callable;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.KafkaException;
import org.apache.kafka.common.config.ConfigException;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.junit.jupiter.api.Timeout;
import org.testcontainers.postgresql.PostgreSQLContainer;

/** Each scenario uses actual HTTP, PostgreSQL 17.11 and Apache Kafka, with fresh DB/topic/group. */
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@Timeout(90)
class EventPipelineTest {
  private PostgreSQLContainer postgres;
  private KafkaTestSupport kafka;
  private PgTestSupport db;
  private PgTestSupport.Application app;
  private EventTestFaults faults;
  private String topic;
  private String group;
  private boolean stoppedBroker;
  private boolean pausedBroker;

  @BeforeAll
  void startOwnedRealDependencies() {
    postgres =
        new PostgreSQLContainer(TestImages.postgres()).withImagePullPolicy(image -> false)
            .withDatabaseName("phase2_tests")
            .withUsername("tpp")
            .withPassword("tpp");
    postgres.start();
    kafka = new KafkaTestSupport();
    kafka.start();
  }

  @BeforeEach
  void isolatedApplicationAndTopic() throws Exception {
    db = new PgTestSupport(postgres.getJdbcUrl(), postgres.getUsername(), postgres.getPassword());
    topic = "phase2-" + UUID.randomUUID();
    group = "projection-" + UUID.randomUUID();
    kafka.createTopic(topic);
    app = startApplication(Map.of());
    faults = app.context().getBean(EventTestFaults.class);
  }

  @AfterEach
  void cleanOnlyThisTestsDatabase() throws Exception {
    if (pausedBroker) {
      kafka.unpauseBroker();
      pausedBroker = false;
    }
    if (stoppedBroker) {
      kafka.restartBroker();
      stoppedBroker = false;
    }
    if (db != null) db.close();
  }

  @AfterAll
  void removeOnlySuiteOwnedContainers() {
    if (kafka != null) kafka.close();
    if (postgres != null) postgres.stop();
  }

  @Test
  void f1RollbackDoesNotCommitOutboxOrPublishAndDoesNotLeavePartialLedger() throws Exception {
    Pair pair = fundedPair();
    long before = db.scalar("SELECT count(*) FROM outbox_events");
    long brokerBefore = kafka.endOffset(topic);
    String key = key();
    faults.failTransferOnce(TransferFaults.Boundary.BEFORE_COMMIT);
    assertThat(submit(pair, key).status()).isEqualTo(500);
    assertThat(db.scalar("SELECT count(*) FROM transfers WHERE idempotency_key=?", key)).isZero();
    assertThat(db.scalar("SELECT count(*) FROM outbox_events")).isEqualTo(before);
    assertThat(db.scalar("SELECT amount FROM balances WHERE account_id=?", pair.source()))
        .isEqualTo(1000);
    assertThat(db.scalar("SELECT amount FROM balances WHERE account_id=?", pair.destination()))
        .isZero();
    assertThat(relay(app).relayOnce()).isZero();
    assertThat(kafka.endOffset(topic)).isEqualTo(brokerBefore);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void f2LostHttpResponseKeepsOneLogicalEventAndDurableIdempotentResult() throws Exception {
    Pair pair = fundedPair();
    String key = key();
    faults.failTransferOnce(TransferFaults.Boundary.AFTER_COMMIT);
    assertThat(submit(pair, key).status()).isEqualTo(500);
    UUID transferId =
        UUID.fromString(text("SELECT id::text FROM transfers WHERE idempotency_key=?", key));
    UUID eventId = eventId(transferId);
    assertThat(db.scalar("SELECT count(*) FROM outbox_events WHERE transfer_id=?", transferId))
        .isEqualTo(1);
    var replay = submit(pair, key);
    assertThat(replay.status()).isEqualTo(200);
    assertThat(replay.id()).isEqualTo(transferId);
    assertThat(eventId(transferId)).isEqualTo(eventId);
    publishPending();
    assertThat(kafka.records(topic, eventId, 1)).hasSize(1);
    assertProjectedOnce(transferId, eventId);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void concurrentIdempotentRequestsCreateOneOutboxAndOneKafkaDerivedEffect() throws Exception {
    Pair pair = fundedPair();
    var peer = startApplication(Map.of("tpp.events.consumer-enabled", false));
    String key = key();
    List<Callable<PgTestSupport.Response>> tasks = new ArrayList<>();
    for (int index = 0; index < 12; index++) {
      var target = index % 2 == 0 ? app : peer;
      tasks.add(
          () ->
              db.post(
                  target,
                  "/api/transfers",
                  PgTestSupport.transfer(pair.source(), pair.destination(), 10),
                  key));
    }
    var results = PgTestSupport.concurrently(tasks);
    assertThat(results).allSatisfy(result -> assertThat(result.status()).isIn(200, 201));
    assertThat(results.stream().filter(result -> result.status() == 201).count()).isEqualTo(1);
    UUID transfer = results.getFirst().id();
    assertThat(results.stream().map(PgTestSupport.Response::id).distinct())
        .containsExactly(transfer);
    assertThat(db.scalar("SELECT count(*) FROM outbox_events WHERE transfer_id=?", transfer))
        .isEqualTo(1);
    publishPending();
    assertProjectedOnce(transfer, eventId(transfer));
    assertThat(kafka.records(topic, eventId(transfer), 1)).hasSize(1);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void databaseRejectsIncompleteInboxCommitAndImmutableOutboxPayloadMutation() throws Exception {
    Pair pair = fundedPair();
    UUID transfer = completed(pair);
    UUID event = eventId(transfer);
    String original = payload(event);
    try (Connection connection = db.connect()) {
      connection.setAutoCommit(false);
      execute(
          connection,
          "INSERT INTO"
              + " event_inbox(event_id,transfer_id,payload_hash,event_type,schema_version,source_topic,source_partition,source_offset,correlation_id)"
              + " VALUES (?,?,?,'TransferCompleted',1,?,0,1,'test-atomicity')",
          event,
          transfer,
          "0".repeat(64),
          topic);
      assertThatThrownBy(connection::commit).isInstanceOf(SQLException.class);
      connection.rollback();
    }
    assertThat(db.scalar("SELECT count(*) FROM event_inbox WHERE event_id=?", event)).isZero();
    assertThat(
            db.scalar("SELECT count(*) FROM transfer_activity_projection WHERE event_id=?", event))
        .isZero();
    assertThatThrownBy(
            () ->
                db.execute(
                    "UPDATE outbox_events SET payload=jsonb_set(payload,'{amountMinor}','11') WHERE"
                        + " event_id=?",
                    event))
        .isInstanceOf(SQLException.class);
    assertThat(payload(event)).isEqualTo(original);
    publishPending();
    assertThat(kafka.records(topic, event, 1)).hasSize(1);
    assertProjectedOnce(transfer, event);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void permanentKafkaTopicFailurePreservesBlockedEvidenceAndAuditedRequeueRecovers()
      throws Exception {
    Pair pair = fundedPair();
    UUID transfer = completed(pair);
    UUID event = eventId(transfer);
    var invalidPublisher =
        startApplication(Map.of("tpp.events.consumer-enabled", false, "tpp.events.topic", "."));
    assertThat(relay(invalidPublisher).relayOnce()).isZero();
    assertThat(status(event)).isEqualTo("BLOCKED");
    assertThat(text("SELECT last_error_classification FROM outbox_events WHERE event_id=?", event))
        .isEqualTo("PERMANENT");
    assertThat(db.scalar("SELECT count(*) FROM event_inbox WHERE event_id=?", event)).isZero();
    assertThat(
            db.post(
                    app,
                    "/internal/outbox/" + event + "/requeues",
                    "{\"reason\":\"Corrected invalid topic configuration\"}",
                    null)
                .status())
        .isEqualTo(200);
    assertThat(status(event)).isEqualTo("PENDING");
    assertThat(db.scalar("SELECT count(*) FROM outbox_requeue_audit WHERE event_id=?", event))
        .isEqualTo(1);
    publishPending();
    assertThat(eventId(transfer)).isEqualTo(event);
    assertThat(kafka.records(topic, event, 1)).hasSize(1);
    assertProjectedOnce(transfer, event);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void f3KafkaOutagePreservesHttpAvailabilityAndDurableBacklogUntilRecovery() throws Exception {
    Pair pair = fundedPair();
    kafka.stopBroker();
    stoppedBroker = true;
    List<UUID> transfers = new ArrayList<>();
    for (int index = 0; index < 3; index++) {
      var result = submit(pair, key());
      assertThat(result.status()).isEqualTo(201);
      transfers.add(result.id());
    }
    assertThat(db.scalar("SELECT count(*) FROM outbox_events WHERE status<>'PUBLISHED'"))
        .isEqualTo(3);
    assertThat(relay(app).relayOnce()).isZero();
    assertThat(db.scalar("SELECT count(*) FROM outbox_events WHERE status<>'PUBLISHED'"))
        .isEqualTo(3);
    assertThat(
            db.scalar(
                "SELECT count(*) FROM transfer_activity_projection WHERE transfer_id IN (?,?,?)",
                transfers.toArray()))
        .isZero();
    assertLedgerAndOutboxInvariants();
    kafka.restartBroker();
    stoppedBroker = false;
    publishPending();
    for (UUID transfer : transfers) {
      assertThat(kafka.records(topic, eventId(transfer), 1)).hasSize(1);
      assertProjectedOnce(transfer, eventId(transfer));
    }
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void f4CrashAfterDurableClaimBeforeSendRecoversAfterLeaseExpiry() throws Exception {
    Pair pair = fundedPair();
    UUID transfer = completed(pair);
    UUID event = eventId(transfer);
    long brokerBefore = kafka.endOffset(topic);
    faults.crashOnce(EventFaults.Boundary.RELAY_BEFORE_SEND, event);
    assertThatThrownBy(() -> relay(app).relayOnce()).isInstanceOf(EventFaults.Crash.class);
    assertThat(status(event)).isEqualTo("CLAIMED");
    assertThat(db.scalar("SELECT count(*) FROM event_inbox WHERE event_id=?", event)).isZero();
    assertThat(kafka.endOffset(topic)).isEqualTo(brokerBefore);
    awaitLeaseExpiry(event);
    publishPending();
    assertThat(kafka.records(topic, event, 1)).hasSize(1);
    assertProjectedOnce(transfer, event);
    assertThat(status(event)).isEqualTo("PUBLISHED");
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void f5CrashAfterKafkaAckCausesStableDuplicateTransportAndSingleBusinessEffect()
      throws Exception {
    Pair pair = fundedPair();
    UUID transfer = completed(pair);
    UUID event = eventId(transfer);
    faults.crashOnce(EventFaults.Boundary.RELAY_AFTER_KAFKA_ACK, event);
    assertThatThrownBy(() -> relay(app).relayOnce()).isInstanceOf(EventFaults.Crash.class);
    var first = kafka.records(topic, event, 1).getFirst();
    assertThat(status(event)).isEqualTo("CLAIMED");
    assertProjectedOnce(transfer, event);
    awaitLeaseExpiry(event);
    publishPending();
    var delivered = kafka.records(topic, event, 2);
    assertThat(delivered).hasSize(2);
    assertThat(delivered)
        .allSatisfy(
            record -> {
              assertThat(record.key()).isEqualTo(transfer.toString());
              assertThat(record.value()).isEqualTo(first.value());
            });
    await("duplicate consumer attempt", Duration.ofSeconds(15), () -> duplicateCount(app) >= 1);
    assertProjectedOnce(transfer, event);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void f6ConsumerCrashBeforeDbCommitRollsBackInboxAndProjectionAndCanRedeliver() throws Exception {
    Pair pair = fundedPair();
    UUID transfer = completed(pair);
    UUID event = eventId(transfer);
    long failedTransactions =
        timerCount(
            app,
            "events.consumer.database.transaction.duration",
            "operation",
            "projection",
            "result",
            "failed");
    long failedCompletions =
        timerCount(
            app,
            "events.consumer.database.completion.duration",
            "operation",
            "projection",
            "result",
            "failed");
    long acknowledgements = timerCount(app, "events.consumer.offset.acknowledgement.duration");
    double processedCommits =
        counterCount(app, "events.projection.commits", "source", "kafka", "outcome", "processed");
    faults.crashOnce(EventFaults.Boundary.CONSUMER_BEFORE_COMMIT, event);
    publishPending();
    long offset = kafka.records(topic, event, 1).getFirst().offset();
    await("consumer crash before commit", Duration.ofSeconds(15), () -> !worker(app).isRunning());
    assertThat(db.scalar("SELECT count(*) FROM event_inbox WHERE event_id=?", event)).isZero();
    assertThat(
            db.scalar("SELECT count(*) FROM transfer_activity_projection WHERE event_id=?", event))
        .isZero();
    assertThat(db.scalar("SELECT count(*) FROM account_activity WHERE event_id=?", event)).isZero();
    assertThat(kafka.committedOffset(group, topic)).isLessThanOrEqualTo(offset);
    assertThat(
            timerCount(
                app,
                "events.consumer.database.transaction.duration",
                "operation",
                "projection",
                "result",
                "failed"))
        .isEqualTo(failedTransactions + 1);
    assertThat(
            timerCount(
                app,
                "events.consumer.database.work.duration",
                "operation",
                "projection",
                "result",
                "failed"))
        .isGreaterThanOrEqualTo(1);
    assertThat(
            timerCount(
                app,
                "events.consumer.database.completion.duration",
                "operation",
                "projection",
                "result",
                "failed"))
        .isEqualTo(failedCompletions);
    assertThat(timerCount(app, "events.consumer.offset.acknowledgement.duration"))
        .isEqualTo(acknowledgements);
    assertThat(
            counterCount(
                app, "events.projection.commits", "source", "kafka", "outcome", "processed"))
        .isEqualTo(processedCommits);
    await(
        "crashed consumer thread exits", Duration.ofSeconds(10), () -> worker(app).isTerminated());
    worker(app).start();
    assertProjectedOnce(transfer, event);
    awaitCommitted(offset + 1);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void f7ConsumerCrashAfterDbCommitBeforeOffsetCommitRedeliversWithoutRepeatedEffects()
      throws Exception {
    Pair pair = fundedPair();
    UUID transfer = completed(pair);
    UUID event = eventId(transfer);
    long committedTransactions =
        timerCount(
            app,
            "events.consumer.database.transaction.duration",
            "operation",
            "projection",
            "result",
            "committed");
    long committedCompletions =
        timerCount(
            app,
            "events.consumer.database.completion.duration",
            "operation",
            "projection",
            "result",
            "committed");
    long acknowledgements = timerCount(app, "events.consumer.offset.acknowledgement.duration");
    double processedCommits =
        counterCount(app, "events.projection.commits", "source", "kafka", "outcome", "processed");
    faults.crashOnce(EventFaults.Boundary.CONSUMER_AFTER_COMMIT, event);
    publishPending();
    long offset = kafka.records(topic, event, 1).getFirst().offset();
    await("consumer crash after commit", Duration.ofSeconds(15), () -> !worker(app).isRunning());
    assertProjectedOnce(transfer, event);
    assertThat(kafka.committedOffset(group, topic)).isLessThanOrEqualTo(offset);
    assertThat(
            timerCount(
                app,
                "events.consumer.database.transaction.duration",
                "operation",
                "projection",
                "result",
                "committed"))
        .isEqualTo(committedTransactions + 1);
    assertThat(
            timerCount(
                app,
                "events.consumer.database.completion.duration",
                "operation",
                "projection",
                "result",
                "committed"))
        .isEqualTo(committedCompletions + 1);
    assertThat(
            counterCount(
                app, "events.projection.commits", "source", "kafka", "outcome", "processed"))
        .isEqualTo(processedCommits + 1);
    assertThat(timerCount(app, "events.consumer.offset.acknowledgement.duration"))
        .isEqualTo(acknowledgements);
    await(
        "crashed consumer thread exits", Duration.ofSeconds(10), () -> worker(app).isTerminated());
    worker(app).start();
    awaitCommitted(offset + 1);
    await("redelivery recognized", Duration.ofSeconds(15), () -> duplicateCount(app) >= 1);
    assertThat(
            counterCount(
                app, "events.projection.commits", "source", "kafka", "outcome", "processed"))
        .isEqualTo(processedCommits + 1);
    assertThat(
            counterCount(
                app, "events.projection.commits", "source", "kafka", "outcome", "duplicate"))
        .isGreaterThanOrEqualTo(1);
    assertProjectedOnce(transfer, event);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void f8PoisonQuarantineIsDurableBeforeOffsetAdvanceAndCorrectedReplayIsAuditable()
      throws Exception {
    Pair pair = fundedPair();
    UUID invalidTransfer = completed(pair);
    UUID invalidEvent = eventId(invalidTransfer);
    String payload = payload(invalidEvent);
    String unsupported = payload.replace("\"schemaVersion\": 1", "\"schemaVersion\": 999");
    assertThat(unsupported).isNotEqualTo(payload);
    UUID validTransfer = completed(pair);
    UUID validEvent = eventId(validTransfer);
    org.apache.kafka.clients.producer.RecordMetadata poison;
    org.apache.kafka.clients.producer.RecordMetadata malformed;
    org.apache.kafka.clients.producer.RecordMetadata valid;
    try (var pause =
        faults.pauseOnce(EventFaults.Boundary.CONSUMER_BEFORE_OFFSET_COMMIT, invalidEvent)) {
      poison = kafka.publish(topic, invalidTransfer.toString(), unsupported);
      malformed = kafka.publish(topic, "malformed", "{");
      valid = kafka.publish(topic, validTransfer.toString(), payload(validEvent));
      pause.awaitEntered();
      assertThat(
              db.scalar(
                  "SELECT count(*) FROM event_quarantine WHERE source_topic=? AND source_offset=?",
                  topic,
                  poison.offset()))
          .isEqualTo(1);
      assertThat(kafka.committedOffset(group, topic)).isLessThanOrEqualTo(poison.offset());
      assertThat(db.scalar("SELECT count(*) FROM event_inbox WHERE event_id=?", invalidEvent))
          .isZero();
    }
    await(
        "both poison records quarantined",
        Duration.ofSeconds(15),
        () -> db.scalar("SELECT count(*) FROM event_quarantine WHERE source_topic=?", topic) == 2);
    assertProjectedOnce(validTransfer, validEvent);
    awaitCommitted(valid.offset() + 1);
    assertThat(db.scalar("SELECT count(*) FROM event_inbox WHERE event_id=?", invalidEvent))
        .isZero();
    assertThat(
            text(
                "SELECT error_classification FROM event_quarantine WHERE source_topic=? AND"
                    + " source_offset=?",
                topic,
                poison.offset()))
        .isEqualTo("PERMANENT");
    assertThat(
            text(
                "SELECT error_code FROM event_quarantine WHERE source_topic=? AND source_offset=?",
                topic,
                poison.offset()))
        .isEqualTo("UNSUPPORTED_SCHEMA");
    assertThat(
            db.scalar(
                "SELECT count(*) FROM event_quarantine WHERE source_topic=? AND source_offset=? AND"
                    + " event_id IS NULL AND original_payload_bytes=1",
                topic,
                malformed.offset()))
        .isEqualTo(1);
    long quarantine =
        db.scalar(
            "SELECT id FROM event_quarantine WHERE source_topic=? AND source_offset=?",
            topic,
            poison.offset());
    String body =
        "{\"reason\":\"Operator corrected supported schema after inspecting"
            + " origin\",\"correctedPayload\":"
            + quote(payload)
            + "}";
    assertThat(db.post(app, "/internal/quarantine/" + quarantine + "/replays", body, null).status())
        .isEqualTo(200);
    assertProjectedOnce(invalidTransfer, invalidEvent);
    assertThat(
            db.scalar(
                "SELECT count(*) FROM event_quarantine_replays WHERE quarantine_id=? AND"
                    + " adopted_event_id=? AND status='SUCCEEDED'",
                quarantine,
                invalidEvent))
        .isEqualTo(1);
    assertThat(db.post(app, "/internal/quarantine/" + quarantine + "/replays", body, null).status())
        .isEqualTo(200);
    assertThat(
            db.scalar(
                "SELECT count(*) FROM event_quarantine_replays WHERE quarantine_id=? AND"
                    + " status='DUPLICATE'",
                quarantine))
        .isEqualTo(1);
    assertProjectedOnce(invalidTransfer, invalidEvent);
    assertThat(db.scalar("SELECT replay_attempts FROM event_quarantine WHERE id=?", quarantine))
        .isEqualTo(2);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void replayCrashRollsBackEffectButKeepsReservedAuditAndAllowsSafeRetry() throws Exception {
    Pair pair = fundedPair();
    UUID transfer = completed(pair);
    UUID event = eventId(transfer);
    var poison =
        kafka.publish(
            topic,
            transfer.toString(),
            payload(event).replace("\"schemaVersion\": 1", "\"schemaVersion\": 999"));
    await(
        "replay candidate quarantined",
        Duration.ofSeconds(15),
        () ->
            db.scalar(
                    "SELECT count(*) FROM event_quarantine WHERE source_offset=? AND"
                        + " source_topic=?",
                    poison.offset(),
                    topic)
                == 1);
    long quarantine =
        db.scalar(
            "SELECT id FROM event_quarantine WHERE source_offset=? AND source_topic=?",
            poison.offset(),
            topic);
    faults.crashOnce(EventFaults.Boundary.REPLAY_BEFORE_COMMIT, event);
    String body =
        "{\"reason\":\"Verified corrected local origin\",\"correctedPayload\":"
            + quote(payload(event))
            + "}";
    assertThat(db.post(app, "/internal/quarantine/" + quarantine + "/replays", body, null).status())
        .isEqualTo(500);
    assertThat(db.scalar("SELECT count(*) FROM event_inbox WHERE event_id=?", event)).isZero();
    assertThat(
            db.scalar("SELECT count(*) FROM transfer_activity_projection WHERE event_id=?", event))
        .isZero();
    assertThat(db.scalar("SELECT count(*) FROM account_activity WHERE event_id=?", event)).isZero();
    assertThat(
            db.scalar(
                "SELECT count(*) FROM event_quarantine_replays WHERE quarantine_id=? AND"
                    + " status='STARTED'",
                quarantine))
        .isEqualTo(1);
    assertThat(db.post(app, "/internal/quarantine/" + quarantine + "/replays", body, null).status())
        .isEqualTo(200);
    assertProjectedOnce(transfer, event);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void controlledReplayRejectsOriginForgeryAndIdentityChangeAndEnforcesDurableAttemptBudget()
      throws Exception {
    Pair pair = fundedPair();
    UUID transfer = completed(pair);
    UUID event = eventId(transfer);
    String original = payload(event);
    var poison =
        kafka.publish(
            topic,
            transfer.toString(),
            original.replace("\"schemaVersion\": 1", "\"schemaVersion\": 999"));
    await(
        "forgery test quarantine",
        Duration.ofSeconds(15),
        () ->
            db.scalar(
                    "SELECT count(*) FROM event_quarantine WHERE source_topic=? AND"
                        + " source_offset=?",
                    topic,
                    poison.offset())
                == 1);
    long id =
        db.scalar(
            "SELECT id FROM event_quarantine WHERE source_topic=? AND source_offset=?",
            topic,
            poison.offset());
    String forgedAmount = original.replace("\"amountMinor\": 10", "\"amountMinor\": 11");
    var rejected = replay(id, forgedAmount);
    assertThat(rejected.status()).isEqualTo(200);
    assertThat(rejected.<String>json("$.status")).isEqualTo("REJECTED");
    assertThat(rejected.<String>json("$.code")).isEqualTo("EVENT_ORIGIN_MISMATCH");
    var changedIdentity =
        replay(id, original.replace(event.toString(), UUID.randomUUID().toString()));
    assertThat(changedIdentity.status()).isEqualTo(200);
    assertThat(changedIdentity.<String>json("$.status")).isEqualTo("REJECTED");
    assertThat(changedIdentity.<String>json("$.code")).isEqualTo("REPLAY_IDENTITY_MISMATCH");
    assertThat(db.scalar("SELECT count(*) FROM event_inbox WHERE event_id=?", event)).isZero();
    assertThat(
            db.scalar("SELECT count(*) FROM transfer_activity_projection WHERE event_id=?", event))
        .isZero();
    int budget = app.context().getBean(EventSettings.class).maxReplayAttempts();
    for (int attempt = 3; attempt <= budget; attempt++) {
      var result = replay(id, original);
      assertThat(result.status()).isEqualTo(200);
      assertThat(result.<String>json("$.status"))
          .isEqualTo(attempt == 3 ? "SUCCEEDED" : "DUPLICATE");
      assertProjectedOnce(transfer, event);
    }
    assertThat(replay(id, original).status()).isEqualTo(409);
    assertThat(db.scalar("SELECT replay_attempts FROM event_quarantine WHERE id=?", id))
        .isEqualTo(budget);
    assertThat(db.scalar("SELECT count(*) FROM event_quarantine_replays WHERE quarantine_id=?", id))
        .isEqualTo(budget);
    assertThat(kafka.records(topic, event, 1)).hasSize(1);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void transientDatabaseLockRollsBackEffectAndHeartbeatRebalanceDoesNotSkipLaterRecord()
      throws Exception {
    Pair pair = fundedPair();
    UUID first = completed(pair);
    UUID second = completed(pair);
    long firstOffset;
    long secondOffset;
    PgTestSupport.Application peer;
    try (Connection lockOwner = db.connect()) {
      lockOwner.setAutoCommit(false);
      execute(lockOwner, "LOCK TABLE account_activity IN ACCESS EXCLUSIVE MODE");
      publishPending();
      firstOffset = kafka.records(topic, eventId(first), 1).getFirst().offset();
      secondOffset = kafka.records(topic, eventId(second), 1).getFirst().offset();
      await(
          "actual PostgreSQL lock timeout enters consumer retry",
          Duration.ofSeconds(15),
          () -> retryCount(app) > 0);
      assertThat(
              db.scalar(
                  "SELECT count(*) FROM event_inbox WHERE transfer_id IN (?,?)", first, second))
          .isZero();
      assertThat(
              db.scalar(
                  "SELECT count(*) FROM transfer_activity_projection WHERE transfer_id IN (?,?)",
                  first,
                  second))
          .isZero();
      assertThat(kafka.committedOffset(group, topic))
          .isLessThanOrEqualTo(Math.min(firstOffset, secondOffset));
      peer = startApplication(Map.of());
      await(
          "real group joins during DB retry backoff",
          Duration.ofSeconds(20),
          () -> kafka.groupMembers(group) == 2);
      worker(app).stop();
      lockOwner.rollback();
    }
    await(
        "peer owns assignment after retry/rebalance",
        Duration.ofSeconds(20),
        () -> kafka.groupMembers(group) == 1);
    assertProjectedOnce(first, eventId(first));
    assertProjectedOnce(second, eventId(second));
    awaitCommitted(Math.max(firstOffset, secondOffset) + 1);
    assertThat(worker(peer).isRunning()).isTrue();
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void startupDnsFailureRetriesConstructionThenProcessesRealKafkaWithoutApplicationRestart()
      throws Exception {
    Pair pair = fundedPair();
    UUID transfer = completed(pair);
    UUID event = eventId(transfer);
    worker(app).stop();
    await(
        "prior consumer fully terminates",
        Duration.ofSeconds(10),
        () -> worker(app).isTerminated());
    // Kafka 4.3.1 wraps bootstrap address validation failure during consumer construction. Only
    // this exact DNS-unavailable cause is retryable; the broker and subsequent client are real.
    faults.failOnce(
        EventFaults.Boundary.CONSUMER_BEFORE_CONNECT,
        null,
        new KafkaException(
            "Failed to construct kafka consumer",
            new ConfigException("No resolvable bootstrap urls given in bootstrap.servers")));
    worker(app).start();
    await(
        "DNS construction retry observed", Duration.ofSeconds(10), () -> startupRetries(app) == 1);
    assertThat(worker(app).isRunning()).isTrue();
    publishPending();
    long offset = kafka.records(topic, event, 1).getFirst().offset();
    assertProjectedOnce(transfer, event);
    awaitCommitted(offset + 1);
    assertThat(worker(app).isRunning()).isTrue();
    assertThat(startupRetries(app)).isEqualTo(1);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void permanentStartupConfigurationFailureStopsWithoutRetryAndLeavesRecordForExplicitRecovery()
      throws Exception {
    Pair pair = fundedPair();
    UUID transfer = completed(pair);
    UUID event = eventId(transfer);
    worker(app).stop();
    await(
        "prior consumer fully terminates",
        Duration.ofSeconds(10),
        () -> worker(app).isTerminated());
    faults.failOnce(
        EventFaults.Boundary.CONSUMER_BEFORE_CONNECT,
        null,
        new ConfigException("Invalid url in bootstrap.servers: invalid-address"));
    worker(app).start();
    await(
        "permanent construction error stops worker",
        Duration.ofSeconds(10),
        () -> !worker(app).isRunning() && worker(app).isTerminated());
    assertThat(startupRetries(app)).isZero();
    publishPending();
    long offset = kafka.records(topic, event, 1).getFirst().offset();
    assertThat(status(event)).isEqualTo("PUBLISHED");
    assertThat(db.scalar("SELECT count(*) FROM event_inbox WHERE event_id=?", event)).isZero();
    assertThat(
            db.scalar("SELECT count(*) FROM transfer_activity_projection WHERE event_id=?", event))
        .isZero();
    assertThat(kafka.committedOffset(group, topic)).isLessThanOrEqualTo(offset);
    // Removing the one-shot invalid configuration fault models the operator correcting it before
    // explicitly restarting this independent worker; the HTTP application stayed available.
    worker(app).start();
    assertProjectedOnce(transfer, event);
    awaitCommitted(offset + 1);
    assertThat(startupRetries(app)).isZero();
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void f9ExpiredOwnerCannotCompleteOrFailNewOwnersClaim() throws Exception {
    Pair pair = fundedPair();
    UUID transfer = completed(pair);
    UUID event = eventId(transfer);
    var peer = startApplication(Map.of("tpp.events.consumer-enabled", false));
    var first = store(app).claim(UUID.randomUUID(), 1).getFirst();
    assertThat(first.eventId()).isEqualTo(event);
    assertThat(store(peer).claim(UUID.randomUUID(), 1)).isEmpty();
    awaitLeaseExpiry(event);
    var second = store(peer).claim(UUID.randomUUID(), 1).getFirst();
    assertThat(second.claimToken()).isNotEqualTo(first.claimToken());
    var acknowledgment = kafka.publish(topic, transfer.toString(), second.payload());
    assertThat(store(app).published(first, acknowledgment)).isFalse();
    assertThat(store(app).failed(first, "STALE_WORKER", "AMBIGUOUS", "Stale worker", false))
        .isFalse();
    assertThat(status(event)).isEqualTo("CLAIMED");
    assertThat(store(peer).published(second, acknowledgment)).isTrue();
    assertThat(status(event)).isEqualTo("PUBLISHED");
    assertProjectedOnce(transfer, event);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void f9CompetingRelayInstancesPublishEveryEventAndKeepFencedStateConsistent() throws Exception {
    Pair pair = fundedPair();
    var peer = startApplication(Map.of("tpp.events.consumer-enabled", false));
    List<UUID> transfers = new ArrayList<>();
    for (int index = 0; index < 12; index++) transfers.add(completed(pair));
    var counts =
        PgTestSupport.<Integer>concurrently(
            List.of(() -> relay(app).relayOnce(), () -> relay(peer).relayOnce()));
    assertThat(counts.stream().mapToInt(Integer::intValue).sum()).isEqualTo(12);
    assertThat(db.scalar("SELECT count(*) FROM outbox_events WHERE status<>'PUBLISHED'")).isZero();
    for (UUID transfer : transfers) {
      UUID event = eventId(transfer);
      assertThat(kafka.records(topic, event, 1)).hasSize(1);
      assertProjectedOnce(transfer, event);
    }
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void f10ShutdownDuringProcessingHandsUncommittedOffsetToPeerForSafeDeduplication()
      throws Exception {
    Pair pair = fundedPair();
    UUID transfer = completed(pair);
    UUID event = eventId(transfer);
    try (var pause = faults.pauseOnce(EventFaults.Boundary.CONSUMER_BEFORE_OFFSET_COMMIT, event)) {
      publishPending();
      pause.awaitEntered();
      long offset = kafka.records(topic, event, 1).getFirst().offset();
      assertProjectedOnce(transfer, event);
      assertThat(kafka.committedOffset(group, topic)).isLessThanOrEqualTo(offset);
      var peer = startApplication(Map.of());
      worker(app).stop();
      assertThat(worker(app).isRunning()).isFalse();
      assertThat(kafka.committedOffset(group, topic)).isLessThanOrEqualTo(offset);
      pause.close();
      await(
          "stopped consumer thread exits",
          Duration.ofSeconds(10),
          () -> worker(app).isTerminated());
      await(
          "peer group ownership after shutdown",
          Duration.ofSeconds(25),
          () -> kafka.groupMembers(group) == 1);
      awaitCommitted(offset + 1);
      await("peer detects prior commit", Duration.ofSeconds(15), () -> duplicateCount(peer) >= 1);
      assertProjectedOnce(transfer, event);
      assertLedgerAndOutboxInvariants();
    }
  }

  @Test
  void acknowledgedBatchWhoseActualStatusTransactionFailsRecoversWithoutOptimisticSuccess()
      throws Exception {
    var transfers = completed(fundedPair(), 4);
    var identities = eventIds(transfers);
    double successes = counterCount(app, "events.outbox.publications", "outcome", "success");
    double failures = counterCount(app, "events.outbox.settlement.failures");
    try (var executor = Executors.newSingleThreadExecutor();
        var pause = faults.pauseNth(EventFaults.Boundary.RELAY_BEFORE_STATUS_COMMIT, 1)) {
      var publication = executor.submit(() -> relay(app).relayOnce());
      pause.awaitEntered();
      assertThat(kafka.recordsFor(topic, identities, 4)).hasSize(4);
      assertThat(db.scalar("SELECT count(*) FROM outbox_events WHERE status='CLAIMED'"))
          .isEqualTo(4);
      try (var blocker = db.connect()) {
        blocker.setAutoCommit(false);
        execute(blocker, "LOCK TABLE outbox_events IN ACCESS EXCLUSIVE MODE");
        pause.close();
        assertThat(publication.get(10, TimeUnit.SECONDS)).isZero();
        blocker.rollback();
      }
    }
    assertThat(counterCount(app, "events.outbox.publications", "outcome", "success"))
        .isEqualTo(successes);
    assertThat(counterCount(app, "events.outbox.settlement.failures")).isEqualTo(failures + 1);
    assertThat(db.scalar("SELECT count(*) FROM outbox_events WHERE status='CLAIMED'")).isEqualTo(4);
    awaitAllClaimExpiry(identities);
    publishPending();
    for (var event : identities) assertThat(kafka.records(topic, event, 2)).hasSize(2);
    assertAllProjected(transfers);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void acknowledgedBatchCommitFailureRollsBackEveryStatusAndRecoversStableIdentities()
      throws Exception {
    var transfers = completed(fundedPair(), 3);
    var identities = eventIds(transfers);
    String targets =
        identities.stream()
            .map(identity -> "'" + identity + "'::uuid")
            .collect(java.util.stream.Collectors.joining(","));
    double successes = counterCount(app, "events.outbox.publications", "outcome", "success");
    double failures = counterCount(app, "events.outbox.settlement.failures");
    db.execute("CREATE SEQUENCE phase3_test_commit_probe START WITH 1");
    db.execute(
        """
        CREATE FUNCTION phase3_test_reject_settlement_commit() RETURNS trigger LANGUAGE plpgsql AS $$
        BEGIN
          IF (SELECT count(*) FROM outbox_events WHERE event_id IN (%s) AND status='PUBLISHED') <> 3 THEN
            RAISE EXCEPTION 'Test expected every target status update before commit' USING ERRCODE='P0001';
          END IF;
          -- Sequence advancement survives rollback and proves all three updates preceded the failure.
          PERFORM nextval('phase3_test_commit_probe');
          RAISE EXCEPTION 'Controlled deferred settlement commit failure' USING ERRCODE='23514';
        END
        $$
        """
            .formatted(targets));
    db.execute(
        """
        CREATE CONSTRAINT TRIGGER phase3_test_reject_settlement_commit
        AFTER UPDATE ON outbox_events DEFERRABLE INITIALLY DEFERRED
        FOR EACH ROW WHEN (OLD.status='CLAIMED' AND NEW.status='PUBLISHED' AND NEW.event_id IN (%s))
        EXECUTE FUNCTION phase3_test_reject_settlement_commit()
        """
            .formatted(targets));
    try {
      assertThat(
              db.scalar(
                  "SELECT CASE WHEN is_called THEN last_value ELSE 0 END FROM"
                      + " phase3_test_commit_probe"))
          .isZero();
      var original = new HashMap<UUID, OutboxStore.Inspection>();
      try (var executor = Executors.newSingleThreadExecutor();
          var pause = faults.pauseNth(EventFaults.Boundary.RELAY_BEFORE_STATUS_COMMIT, 1)) {
        var publication = executor.submit(() -> relay(app).relayOnce());
        pause.awaitEntered();
        assertThat(kafka.recordsFor(topic, identities, 3)).hasSize(3);
        for (var identity : identities) {
          var state = store(app).inspect(identity);
          assertThat(state.status()).isEqualTo("CLAIMED");
          original.put(identity, state);
        }
        pause.close();
        assertThat(publication.get(10, TimeUnit.SECONDS)).isZero();
      }
      assertThat(
              db.scalar(
                  "SELECT CASE WHEN is_called THEN last_value ELSE 0 END FROM"
                      + " phase3_test_commit_probe"))
          .isEqualTo(1);
      assertThat(counterCount(app, "events.outbox.publications", "outcome", "success"))
          .isEqualTo(successes);
      assertThat(counterCount(app, "events.outbox.settlement.failures")).isEqualTo(failures + 1);
      for (var identity : identities) {
        assertThat(store(app).inspect(identity))
            .usingRecursiveComparison()
            .ignoringFields("processedAt", "projectedAt", "latestQuarantineId")
            .isEqualTo(original.get(identity));
      }
    } finally {
      db.execute("DROP TRIGGER phase3_test_reject_settlement_commit ON outbox_events");
      db.execute("DROP FUNCTION phase3_test_reject_settlement_commit()");
      db.execute("DROP SEQUENCE phase3_test_commit_probe");
    }
    awaitAllClaimExpiry(identities);
    publishPending();
    for (var identity : identities) assertThat(kafka.records(topic, identity, 2)).hasSize(2);
    assertAllProjected(transfers);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void crashDuringRealInFlightBatchLeavesEveryClaimRecoverableAndIgnoresLateCallbacks()
      throws Exception {
    var transfers = completed(fundedPair(), 4);
    var identities = eventIds(transfers);
    var publisher = batchPublisher(4);
    var publisherFaults = publisher.context().getBean(EventTestFaults.class);
    try (var executor = Executors.newSingleThreadExecutor();
        var pause = publisherFaults.pauseNth(EventFaults.Boundary.RELAY_BEFORE_SEND, 3)) {
      var publication = executor.submit(() -> relay(publisher).relayOnce());
      pause.awaitEntered();
      assertThat(kafka.recordsFor(topic, identities, 2)).hasSize(2);
      await(
          "first two real ACK callbacks finish before the crash fixture freezes the broker",
          Duration.ofSeconds(3),
          () -> counterCount(publisher, "events.outbox.kafka.acknowledgements", "outcome", "accepted") == 2
              && inFlight(publisher) == 0);
      // A graceful broker stop can revoke metadata and make the next send fail synchronously.
      // Freeze the real broker so cached metadata remains usable and actual work stays outstanding.
      pausedBroker = true;
      kafka.pauseBroker();
      long frozenAt = System.nanoTime();
      publisherFaults.crashOnce(EventFaults.Boundary.RELAY_BEFORE_SEND, null);
      pause.close();
      assertThatThrownBy(() -> publication.get(10, TimeUnit.SECONDS))
          .hasCauseInstanceOf(EventFaults.Crash.class);
      double outstanding = inFlight(publisher);
      assertThat(outstanding).isBetween(1.0, 4.0);
      assertThat(counterCount(publisher, "events.outbox.send.attempts", "kind", "first"))
          .isEqualTo(3);
      System.out.println("ActualCrashFixture acceptedAcks=2 sends=3 postCrashInFlight=" + outstanding
          + " frozenMillis=" + Duration.ofNanos(System.nanoTime() - frozenAt).toMillis());
      assertThat(db.scalar("SELECT count(*) FROM outbox_events WHERE status='CLAIMED'"))
          .isEqualTo(4);
      kafka.unpauseBroker();
      pausedBroker = false;
      await(
          "old producer callbacks finish", Duration.ofSeconds(10), () -> inFlight(publisher) == 0);
      assertThat(db.scalar("SELECT count(*) FROM outbox_events WHERE status='CLAIMED'"))
          .isEqualTo(4);
      assertThat(counterCount(publisher, "events.outbox.publications", "outcome", "success"))
          .isZero();
    } finally {
      // Restore only this suite's broker even when a precondition/assertion fails.
      if (pausedBroker) {
        kafka.unpauseBroker();
        pausedBroker = false;
      }
    }
    awaitAllClaimExpiry(identities);
    publishPending();
    assertAllProjected(transfers);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void reverseRealAcknowledgementsSettleLiveRecordsWhileFencingOneReplacedGeneration()
      throws Exception {
    var transfers = completed(fundedPair(), 3);
    var peer = startApplication(Map.of("tpp.events.consumer-enabled", false));
    var claims = store(app).claim(UUID.randomUUID(), 3);
    assertThat(claims).hasSize(3);
    var metadata =
        kafka.publishBatch(
            claims.stream()
                .map(
                    claim ->
                        new ProducerRecord<>(topic, claim.transferId().toString(), claim.payload()))
                .toList());
    var batch = new PublicationBatch(claims, topic);
    for (var claim : claims) batch.beginSend(claim.eventId(), claim.claimToken());
    for (int index = claims.size() - 1; index >= 0; index--) {
      var claim = claims.get(index);
      batch.acknowledge(
          claim.eventId(),
          claim.claimToken(),
          PublicationBatch.KafkaPosition.from(metadata.get(index)));
    }
    var expiring = claims.getLast();
    await(
        "one original claim approaches expiry",
        Duration.ofSeconds(10),
        () ->
            db.scalar(
                    "SELECT count(*) FROM outbox_events WHERE event_id=? AND"
                        + " lease_until-clock_timestamp()<interval '500 milliseconds'",
                    expiring.eventId())
                == 1);
    var live = claims.subList(0, 2);
    assertThat(store(app).renewBatch(live))
        .containsExactlyInAnyOrderElementsOf(
            live.stream().map(OutboxStore.Claim::eventId).toList());
    awaitLeaseExpiry(expiring.eventId());
    var replacement = store(peer).claim(UUID.randomUUID(), 1).getFirst();
    assertThat(replacement.eventId()).isEqualTo(expiring.eventId());
    assertThat(replacement.claimToken()).isNotEqualTo(expiring.claimToken());
    assertThat(store(app).settle(batch.finish()))
        .containsExactlyInAnyOrderElementsOf(
            live.stream().map(OutboxStore.Claim::eventId).toList());
    for (int index = 0; index < live.size(); index++) {
      var persisted = store(app).inspect(live.get(index).eventId());
      var acknowledged = metadata.get(index);
      assertThat(persisted.kafkaTopic()).isEqualTo(acknowledged.topic());
      assertThat(persisted.kafkaPartition()).isEqualTo(acknowledged.partition());
      assertThat(persisted.kafkaOffset()).isEqualTo(acknowledged.offset());
    }
    assertThat(store(app).inspect(replacement.eventId()).claimToken())
        .isEqualTo(replacement.claimToken());
    var repeated = kafka.publish(topic, replacement.transferId().toString(), replacement.payload());
    var recovered = new PublicationBatch(List.of(replacement), topic);
    recovered.beginSend(replacement.eventId(), replacement.claimToken());
    recovered.acknowledge(
        replacement.eventId(),
        replacement.claimToken(),
        PublicationBatch.KafkaPosition.from(repeated));
    assertThat(store(peer).settle(recovered.finish())).containsExactly(replacement.eventId());
    assertThat(kafka.records(topic, replacement.eventId(), 2)).hasSize(2);
    assertAllProjected(transfers);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void expiredBatchSettlementCannotOverwriteNewOwnerPublicationEvidence() throws Exception {
    var transfers = completed(fundedPair(), 3);
    var identities = eventIds(transfers);
    var peer = startApplication(Map.of("tpp.events.consumer-enabled", false));
    try (var executor = Executors.newSingleThreadExecutor();
        var pause = faults.pauseNth(EventFaults.Boundary.RELAY_BEFORE_STATUS_COMMIT, 1)) {
      var publication = executor.submit(() -> relay(app).relayOnce());
      pause.awaitEntered();
      assertThat(kafka.recordsFor(topic, identities, 3)).hasSize(3);
      awaitAllClaimExpiry(identities);
      var replacement = store(peer).claim(UUID.randomUUID(), 1).getFirst();
      var ack = kafka.publish(topic, replacement.transferId().toString(), replacement.payload());
      var replacementBatch = new PublicationBatch(List.of(replacement), topic);
      replacementBatch.beginSend(replacement.eventId(), replacement.claimToken());
      replacementBatch.acknowledge(
          replacement.eventId(),
          replacement.claimToken(),
          PublicationBatch.KafkaPosition.from(ack));
      assertThat(store(peer).settle(replacementBatch.finish()))
          .containsExactly(replacement.eventId());
      pause.close();
      assertThat(publication.get(10, TimeUnit.SECONDS)).isZero();
      assertThat(store(app).inspect(replacement.eventId()).kafkaOffset()).isEqualTo(ack.offset());
      assertThat(counterCount(app, "events.outbox.publications", "outcome", "stale"))
          .isGreaterThanOrEqualTo(3);
    }
    publishPending();
    assertAllProjected(transfers);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void partialBrokerOutageAndDeadlineKeepActualProducerWorkBoundedAcrossTheNextBatch()
      throws Exception {
    var transfers = completed(fundedPair(), 8);
    var identities = eventIds(transfers);
    // A real process pause retains established metadata/transport while preventing broker ACKs.
    // Test-only ten-second delivery/request limits leave a wide observation window; production
    // and measured image configuration remain unchanged.
    var publisher =
        startApplication(
            Map.of(
                "tpp.events.consumer-enabled",
                false,
                "tpp.events.batch-size",
                8,
                "tpp.events.delivery-timeout-ms",
                10000,
                "tpp.events.request-timeout-ms",
                10000,
                "tpp.events.lease-ms",
                30000));
    var publisherFaults = publisher.context().getBean(EventTestFaults.class);
    long started = System.nanoTime();
    try {
      try (var executor = Executors.newSingleThreadExecutor();
          var pause = publisherFaults.pauseNth(EventFaults.Boundary.RELAY_BEFORE_SEND, 3)) {
        var publication = executor.submit(() -> relay(publisher).relayOnce());
        pause.awaitEntered();
        assertThat(kafka.recordsFor(topic, identities, 2)).hasSize(2);
        await(
            "initial Kafka callbacks finish before the broker is paused",
            Duration.ofSeconds(3),
            () ->
                counterCount(
                            publisher,
                            "events.outbox.kafka.acknowledgements",
                            "outcome",
                            "accepted")
                        == 2
                    && inFlight(publisher) == 0);
        assertThat(
                counterCount(
                    publisher, "events.outbox.kafka.acknowledgements", "outcome", "failed"))
            .isZero();
        System.out.println("ActualBatchBound prePause acceptedAcks=2 inFlight=0");
        pausedBroker = true;
        kafka.pauseBroker();
        assertThat(Duration.ofNanos(System.nanoTime() - started))
            .as("real ACK evidence and broker pause complete before the submission window")
            .isLessThan(Duration.ofSeconds(5));
        // Fresh sends at 8.5s expire near 18.5s, after the coordinator's 11.5s deadline.
        await(
            "submission resumes with three seconds remaining in the configured batch budget",
            Duration.ofSeconds(12),
            () -> System.nanoTime() - started >= TimeUnit.MILLISECONDS.toNanos(8500));
        assertThat(Duration.ofNanos(System.nanoTime() - started))
            .as("explicit setup precondition leaves at least two seconds for six actual enqueues")
            .isLessThan(Duration.ofMillis(9500));
        pause.close();
        assertThat(publication.get(15, TimeUnit.SECONDS)).isEqualTo(2);
        var first =
            Map.of(
                "inFlight",
                inFlight(publisher),
                "sendAttempts",
                counterCount(publisher, "events.outbox.send.attempts"),
                "acceptedAcks",
                counterCount(
                    publisher, "events.outbox.kafka.acknowledgements", "outcome", "accepted"),
                "failedAcks",
                counterCount(
                    publisher, "events.outbox.kafka.acknowledgements", "outcome", "failed"),
                "enqueueCompletions",
                (double) timerCount(publisher, "events.outbox.kafka.enqueue.duration"));
        System.out.println("ActualBatchBound firstDeadline " + first);
        assertThat(first.get("sendAttempts")).isEqualTo(8);
        assertThat(first.get("enqueueCompletions")).isEqualTo(8);
        assertThat(first.get("acceptedAcks")).isEqualTo(2);
        assertThat(first.get("failedAcks")).isZero();
        assertThat(first.get("inFlight")).isEqualTo(6);
        assertThat(db.scalar("SELECT count(*) FROM outbox_events WHERE status='PUBLISHED'"))
            .isEqualTo(3);
        assertThat(db.scalar("SELECT count(*) FROM outbox_events WHERE status='BLOCKED'")).isZero();
        assertThat(
                db.scalar(
                    "SELECT count(*) FROM outbox_events WHERE status='PENDING' AND"
                        + " last_error_classification='AMBIGUOUS'"))
            .isEqualTo(6);
        await(
            "remaining records become retry eligible",
            Duration.ofSeconds(2),
            () ->
                db.scalar(
                        "SELECT count(*) FROM outbox_events WHERE status='PENDING' AND"
                            + " next_attempt_at<=clock_timestamp()")
                    > 0);
        try (var nextPause = publisherFaults.pauseNth(EventFaults.Boundary.RELAY_BEFORE_SEND, 1)) {
          var next = executor.submit(() -> relay(publisher).relayOnce());
          nextPause.awaitEntered();
          long nextClaims = db.scalar("SELECT count(*) FROM outbox_events WHERE status='CLAIMED'");
          var outstanding =
              counterCount(publisher, "events.outbox.send.attempts")
                  - counterCount(publisher, "events.outbox.kafka.acknowledgements");
          System.out.println(
              "ActualBatchBound nextClaim inFlight="
                  + inFlight(publisher)
                  + " outstanding="
                  + outstanding
                  + " claimed="
                  + nextClaims);
          assertThat(inFlight(publisher)).isEqualTo(6);
          assertThat(nextClaims).isBetween(1L, 2L);
          assertThat(outstanding).isEqualTo(6);
          assertThat(relay(publisher).relayOnce()).isZero();
          nextPause.close();
          await(
              "producer bound during real failed callback drain",
              Duration.ofSeconds(20),
              () -> {
                assertThat(inFlight(publisher)).isBetween(0.0, 8.0);
                assertThat(
                        counterCount(publisher, "events.outbox.send.attempts")
                            - counterCount(publisher, "events.outbox.kafka.acknowledgements"))
                    .isLessThanOrEqualTo(8);
                return next.isDone();
              });
          assertThat(next.get(1, TimeUnit.SECONDS)).isZero();
          assertThat(inFlight(publisher)).isZero();
        }
      }
    } finally {
      if (pausedBroker) {
        kafka.unpauseBroker();
        pausedBroker = false;
      }
    }
    publishPending();
    assertAllProjected(transfers);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void shutdownWithActualOutstandingProducerWorkIsBoundedAndPreservesRetryEligibility()
      throws Exception {
    var transfers = completed(fundedPair(), 4);
    var identities = eventIds(transfers);
    var publisher =
        startApplication(
            Map.of(
                "tpp.events.consumer-enabled",
                false,
                "tpp.events.batch-size",
                4,
                "tpp.events.delivery-timeout-ms",
                5000,
                "tpp.events.request-timeout-ms",
                5000,
                "tpp.events.lease-ms",
                10000));
    var publisherFaults = publisher.context().getBean(EventTestFaults.class);
    try {
      try (var executor = Executors.newSingleThreadExecutor();
          var firstPause = publisherFaults.pauseNth(EventFaults.Boundary.RELAY_BEFORE_SEND, 3)) {
        long started = System.nanoTime();
        var publication = executor.submit(() -> relay(publisher).relayOnce());
        firstPause.awaitEntered();
        assertThat(kafka.recordsFor(topic, identities, 2)).hasSize(2);
        await(
            "first two shutdown-fixture callbacks release their actual producer slots",
            Duration.ofSeconds(3),
            () ->
                counterCount(
                            publisher,
                            "events.outbox.kafka.acknowledgements",
                            "outcome",
                            "accepted")
                        == 2
                    && inFlight(publisher) == 0);
        assertThat(
                counterCount(
                    publisher, "events.outbox.kafka.acknowledgements", "outcome", "failed"))
            .isZero();
        // Freeze the actual broker process while preserving established metadata/transport.
        // A stopped broker may invalidate metadata and fail send synchronously, leaving no
        // actual producer work for the shutdown assertion to exercise.
        pausedBroker = true;
        kafka.pauseBroker();
        assertThat(Duration.ofNanos(System.nanoTime() - started)).isLessThan(Duration.ofSeconds(5));
        try (var inFlightPause =
            publisherFaults.pauseNth(EventFaults.Boundary.RELAY_BEFORE_SEND, 1)) {
          firstPause.close();
          inFlightPause.awaitEntered();
          assertThat(Duration.ofNanos(System.nanoTime() - started))
              .isLessThan(Duration.ofSeconds(6));
          var actualWork =
              Map.of(
                  "inFlight",
                  inFlight(publisher),
                  "sendAttempts",
                  counterCount(publisher, "events.outbox.send.attempts"),
                  "acceptedAcks",
                  counterCount(
                      publisher, "events.outbox.kafka.acknowledgements", "outcome", "accepted"),
                  "failedAcks",
                  counterCount(
                      publisher, "events.outbox.kafka.acknowledgements", "outcome", "failed"),
                  "enqueueCompletions",
                  (double) timerCount(publisher, "events.outbox.kafka.enqueue.duration"));
          System.out.println("ActualShutdown beforeStop " + actualWork);
          assertThat(actualWork)
              .containsEntry("inFlight", 1.0)
              .containsEntry("sendAttempts", 3.0)
              .containsEntry("enqueueCompletions", 3.0)
              .containsEntry("acceptedAcks", 2.0)
              .containsEntry("failedAcks", 0.0);
          long stoppedAt = System.nanoTime();
          relay(publisher).stop();
          var shutdownDuration = Duration.ofNanos(System.nanoTime() - stoppedAt);
          System.out.println(
              "ActualShutdown afterStop millis="
                  + shutdownDuration.toMillis()
                  + " inFlight="
                  + inFlight(publisher)
                  + " terminated="
                  + relay(publisher).isTerminated());
          assertThat(shutdownDuration).isLessThan(Duration.ofSeconds(8));
          assertThatThrownBy(() -> publication.get(10, TimeUnit.SECONDS))
              .hasCauseInstanceOf(EventFaults.Crash.class);
          assertThat(relay(publisher).isTerminated()).isTrue();
          assertThat(inFlight(publisher)).isZero();
          assertThat(relay(publisher).relayOnce()).isZero();
          assertThat(counterCount(publisher, "events.outbox.publications", "outcome", "success"))
              .isZero();
          assertThat(db.scalar("SELECT count(*) FROM outbox_events WHERE status='CLAIMED'"))
              .isEqualTo(4);
        }
      }
    } finally {
      if (pausedBroker) {
        kafka.unpauseBroker();
        pausedBroker = false;
      }
    }
    awaitAllClaimExpiry(identities);
    publishPending();
    assertAllProjected(transfers);
    assertLedgerAndOutboxInvariants();
  }

  @Test
  void stopRecapturesAnAdmittedStartWorkerAndSameInstanceRestartPublishesRealEvent()
      throws Exception {
    Pair pair = fundedPair();
    var publisher =
        startApplication(
            Map.of("tpp.events.consumer-enabled", false, "tpp.events.relay-enabled", true));
    var lifecycle = relay(publisher);
    assertThat(lifecycle.isRunning()).isTrue();
    lifecycle.stop();
    assertThat(lifecycle.isTerminated()).isTrue();
    var stoppingThread = new java.util.concurrent.atomic.AtomicReference<Thread>();
    var lateWorkerEntered = new java.util.concurrent.CountDownLatch(1);
    var lateWorkerInterrupted = new java.util.concurrent.atomic.AtomicBoolean();
    Thread lateWorker =
        new Thread(
            () -> {
              lateWorkerEntered.countDown();
              try {
                new java.util.concurrent.CountDownLatch(1).await(30, TimeUnit.SECONDS);
              } catch (InterruptedException interrupted) {
                lateWorkerInterrupted.set(true);
                Thread.currentThread().interrupt();
              }
            },
            "test-admitted-relay-start");
    lateWorker.setDaemon(true);
    try (var executor = Executors.newSingleThreadExecutor()) {
      try {
        java.util.concurrent.Future<?> stopped;
        synchronized (lifecycle) {
          stopped =
              executor.submit(
                  () -> {
                    stoppingThread.set(Thread.currentThread());
                    lifecycle.stop();
                  });
          await(
              "stop has eagerly fenced then waits for the lifecycle monitor",
              Duration.ofSeconds(3),
              () ->
                  stoppingThread.get() != null
                      && stoppingThread.get().getState() == Thread.State.BLOCKED);
          // Test-only reflective writes model start passing its guard just before stop's CAS,
          // then installing a worker while it still owns this monitor. This is a scheduling
          // regression, not evidence of a Kafka transport fault or a new production fault hook.
          org.springframework.test.util.ReflectionTestUtils.setField(lifecycle, "stopping", false);
          org.springframework.test.util.ReflectionTestUtils.setField(lifecycle, "running", true);
          org.springframework.test.util.ReflectionTestUtils.setField(
              lifecycle, "worker", lateWorker);
          lateWorker.start();
          assertThat(lateWorkerEntered.await(3, TimeUnit.SECONDS)).isTrue();
          assertThat(lateWorker.isAlive()).isTrue();
        }
        stopped.get(10, TimeUnit.SECONDS);
        assertThat(lateWorkerInterrupted.get()).isTrue();
        assertThat(lateWorker.isAlive()).isFalse();
        assertThat(lifecycle.isRunning()).isFalse();
        assertThat(lifecycle.isTerminated()).isTrue();
      } finally {
        lateWorker.interrupt();
        lateWorker.join(3000);
        lifecycle.stop();
      }
    }
    lifecycle.start();
    assertThat(lifecycle.isRunning()).isTrue();
    UUID transfer = completed(pair);
    UUID identity = eventId(transfer);
    await(
        "same restarted relay durably publishes a new HTTP completion",
        Duration.ofSeconds(15),
        () -> store(publisher).inspect(identity).status().equals("PUBLISHED"));
    assertThat(eventId(transfer)).isEqualTo(identity);
    assertThat(kafka.records(topic, identity, 1)).hasSize(1);
    assertProjectedOnce(transfer, identity);
    awaitCommitted(kafka.records(topic, identity, 1).getFirst().offset() + 1);
    assertLedgerAndOutboxInvariants();
  }

  private PgTestSupport.Application batchPublisher(int size) {
    return startApplication(
        Map.of(
            "tpp.events.consumer-enabled",
            false,
            "tpp.events.batch-size",
            size,
            "tpp.events.delivery-timeout-ms",
            5000,
            "tpp.events.request-timeout-ms",
            1000,
            "tpp.events.lease-ms",
            10000));
  }

  private List<UUID> completed(Pair pair, int count) throws Exception {
    var transfers = new ArrayList<UUID>();
    for (int index = 0; index < count; index++) transfers.add(completed(pair));
    return List.copyOf(transfers);
  }

  private Set<UUID> eventIds(List<UUID> transfers) throws Exception {
    var identities = new java.util.HashSet<UUID>();
    for (var transfer : transfers) identities.add(eventId(transfer));
    return Set.copyOf(identities);
  }

  private void awaitAllClaimExpiry(Set<UUID> identities) throws Exception {
    for (var identity : identities)
      await(
          "durable batch claim expires",
          Duration.ofSeconds(25),
          () ->
              db.scalar(
                      "SELECT count(*) FROM outbox_events WHERE event_id=? AND status='CLAIMED' AND"
                          + " lease_until<=clock_timestamp()",
                      identity)
                  == 1);
  }

  private void assertAllProjected(List<UUID> transfers) throws Exception {
    long finalOffset = -1;
    for (var transfer : transfers) {
      var identity = eventId(transfer);
      assertProjectedOnce(transfer, identity);
      for (var record : kafka.records(topic, identity, 1))
        finalOffset = Math.max(finalOffset, record.offset());
    }
    awaitCommitted(finalOffset + 1);
  }

  private static double inFlight(PgTestSupport.Application target) {
    return target
        .context()
        .getBean(MeterRegistry.class)
        .get("events.outbox.inflight.records")
        .gauge()
        .value();
  }

  private static double counterCount(
      PgTestSupport.Application target, String name, String... tags) {
    return target.context().getBean(MeterRegistry.class).find(name).tags(tags).counters().stream()
        .mapToDouble(io.micrometer.core.instrument.Counter::count)
        .sum();
  }

  private static long timerCount(PgTestSupport.Application target, String name, String... tags) {
    return target.context().getBean(MeterRegistry.class).find(name).tags(tags).timers().stream()
        .mapToLong(io.micrometer.core.instrument.Timer::count)
        .sum();
  }

  private PgTestSupport.Application startApplication(Map<String, Object> overrides) {
    Map<String, Object> settings = new HashMap<>();
    settings.put("tpp.events.bootstrap-servers", kafka.bootstrap());
    settings.put("tpp.events.topic", topic);
    settings.put("tpp.events.consumer-group", group);
    settings.put("tpp.events.relay-enabled", false);
    settings.put("tpp.events.consumer-enabled", true);
    settings.put("tpp.events.batch-size", 20);
    settings.put("tpp.events.lease-ms", 5000);
    settings.put("tpp.events.delivery-timeout-ms", 1000);
    settings.put("tpp.events.request-timeout-ms", 500);
    settings.put("tpp.events.max-block-ms", 500);
    settings.put("tpp.events.retry-base-ms", 25);
    settings.put("tpp.events.retry-max-ms", 200);
    settings.put("tpp.events.poll-interval-ms", 25);
    settings.putAll(overrides);
    return db.start(TppApplication.class, settings, EventTestFaults.Configuration.class);
  }

  private Pair fundedPair() throws Exception {
    UUID source = account();
    UUID destination = account();
    UUID issuance = UUID.randomUUID();
    UUID funding = UUID.randomUUID();
    try (Connection connection = db.connect()) {
      connection.setAutoCommit(false);
      try (PreparedStatement statement =
          connection.prepareStatement(
              "INSERT INTO accounts(id,kind,status,unit) VALUES (?,'ISSUANCE','ACTIVE','FIC')")) {
        statement.setObject(1, issuance);
        statement.executeUpdate();
      }
      execute(connection, "INSERT INTO balances(account_id,amount) VALUES (?,0)", issuance);
      execute(
          connection,
          "INSERT INTO"
              + " transfers(id,idempotency_key,source_account_id,destination_account_id,amount,unit,status)"
              + " VALUES (?,?,?,?,1000,'FIC','PROCESSING')",
          funding,
          "fund-" + funding,
          issuance,
          source);
      execute(connection, "UPDATE balances SET amount=-1000 WHERE account_id=?", issuance);
      execute(connection, "UPDATE balances SET amount=1000 WHERE account_id=?", source);
      execute(
          connection,
          "INSERT INTO ledger_entries(transfer_id,account_id,delta) VALUES (?,?,-1000),(?,?,1000)",
          funding,
          issuance,
          funding,
          source);
      execute(
          connection,
          "UPDATE transfers SET status='COMPLETED',completed_at=now() WHERE id=?",
          funding);
      connection.commit();
    }
    publishPending();
    assertProjectedOnce(funding, eventId(funding));
    awaitCommitted(kafka.records(topic, eventId(funding), 1).getFirst().offset() + 1);
    return new Pair(source, destination);
  }

  private UUID account() throws Exception {
    var result = db.post(app, "/api/accounts", "{\"unit\":\"FIC\"}", null);
    assertThat(result.status()).isEqualTo(201);
    return result.id();
  }

  private static void execute(Connection connection, String sql, Object... values)
      throws Exception {
    try (PreparedStatement statement = connection.prepareStatement(sql)) {
      PgTestSupport.bind(statement, values);
      statement.executeUpdate();
    }
  }

  private PgTestSupport.Response submit(Pair pair, String key) throws Exception {
    return db.post(
        app, "/api/transfers", PgTestSupport.transfer(pair.source(), pair.destination(), 10), key);
  }

  private UUID completed(Pair pair) throws Exception {
    var result = submit(pair, key());
    assertThat(result.status()).isEqualTo(201);
    return result.id();
  }

  private void publishPending() throws Exception {
    await(
        "all eligible outbox events published",
        Duration.ofSeconds(20),
        () -> {
          relay(app).relayOnce();
          return db.scalar("SELECT count(*) FROM outbox_events WHERE status<>'PUBLISHED'") == 0;
        });
  }

  private void awaitLeaseExpiry(UUID event) throws Exception {
    await(
        "durable publisher lease expires",
        Duration.ofSeconds(10),
        () ->
            db.scalar(
                    "SELECT count(*) FROM outbox_events WHERE event_id=? AND"
                        + " lease_until<=clock_timestamp()",
                    event)
                == 1);
  }

  private void awaitCommitted(long offset) throws Exception {
    await(
        "Kafka offset durably committed",
        Duration.ofSeconds(25),
        () -> kafka.committedOffset(group, topic) >= offset);
  }

  private void assertProjectedOnce(UUID transfer, UUID event) throws Exception {
    await(
        "Kafka-derived transfer projection",
        Duration.ofSeconds(20),
        () ->
            db.scalar(
                    "SELECT count(*) FROM transfer_activity_projection WHERE transfer_id=?",
                    transfer)
                == 1);
    assertThat(
            db.scalar(
                "SELECT count(*) FROM event_inbox WHERE event_id=? AND transfer_id=?",
                event,
                transfer))
        .isEqualTo(1);
    assertThat(db.scalar("SELECT count(*) FROM account_activity WHERE event_id=?", event))
        .isEqualTo(2);
    assertThat(db.scalar("SELECT sum(delta_minor) FROM account_activity WHERE event_id=?", event))
        .isZero();
    assertThat(
            db.scalar(
                "SELECT count(*) FROM transfer_activity_projection p JOIN transfers t ON"
                    + " t.id=p.transfer_id WHERE p.transfer_id=? AND"
                    + " p.source_account_id=t.source_account_id AND"
                    + " p.destination_account_id=t.destination_account_id AND"
                    + " p.amount_minor=t.amount AND p.unit=t.unit AND p.occurred_at=t.completed_at",
                transfer))
        .isEqualTo(1);
  }

  private void assertLedgerAndOutboxInvariants() throws Exception {
    assertThat(
            db.scalar(
                "SELECT count(*) FROM transfers t LEFT JOIN outbox_events o ON o.transfer_id=t.id"
                    + " WHERE t.status='COMPLETED' AND o.event_id IS NULL"))
        .isZero();
    assertThat(
            db.scalar(
                "SELECT count(*) FROM outbox_events o JOIN transfers t ON t.id=o.transfer_id WHERE"
                    + " t.status<>'COMPLETED'"))
        .isZero();
    assertThat(db.scalar("SELECT count(*) FROM transfers WHERE status='PROCESSING'")).isZero();
    assertThat(
            db.scalar(
                "SELECT count(*) FROM (SELECT transfer_id FROM ledger_entries GROUP BY transfer_id"
                    + " HAVING count(*)<>2 OR sum(delta)<>0) broken"))
        .isZero();
    assertThat(
            db.scalar(
                "SELECT count(*) FROM balances b WHERE b.amount<>(SELECT COALESCE(sum(l.delta),0)"
                    + " FROM ledger_entries l WHERE l.account_id=b.account_id)"))
        .isZero();
    assertThat(
            db.scalar(
                "SELECT count(*) FROM event_inbox i LEFT JOIN transfer_activity_projection p ON"
                    + " p.event_id=i.event_id WHERE p.event_id IS NULL"))
        .isZero();
    assertThat(
            db.scalar(
                "SELECT count(*) FROM (SELECT i.event_id FROM event_inbox i LEFT JOIN"
                    + " account_activity a ON a.event_id=i.event_id GROUP BY i.event_id HAVING"
                    + " count(a.id)<>2 OR sum(a.delta_minor)<>0) broken"))
        .isZero();
    var report = db.get(app, "/internal/reconciliation");
    assertThat(report.status()).isEqualTo(200);
    assertThat(report.<Boolean>json("$.consistent")).isTrue();
  }

  private String text(String sql, Object... parameters) throws Exception {
    try (Connection connection = db.connect();
        PreparedStatement statement = connection.prepareStatement(sql)) {
      PgTestSupport.bind(statement, parameters);
      try (var rows = statement.executeQuery()) {
        if (!rows.next()) throw new AssertionError("Query returned no row: " + sql);
        return rows.getString(1);
      }
    }
  }

  private UUID eventId(UUID transfer) throws Exception {
    return UUID.fromString(
        text("SELECT event_id::text FROM outbox_events WHERE transfer_id=?", transfer));
  }

  private String payload(UUID event) throws Exception {
    return text("SELECT payload::text FROM outbox_events WHERE event_id=?", event);
  }

  private String status(UUID event) throws Exception {
    return text("SELECT status FROM outbox_events WHERE event_id=?", event);
  }

  private static OutboxRelay relay(PgTestSupport.Application target) {
    return target.context().getBean(OutboxRelay.class);
  }

  private static OutboxStore store(PgTestSupport.Application target) {
    return target.context().getBean(OutboxStore.class);
  }

  private static EventConsumerWorker worker(PgTestSupport.Application target) {
    return target.context().getBean(EventConsumerWorker.class);
  }

  private static double duplicateCount(PgTestSupport.Application target) {
    var counter =
        target
            .context()
            .getBean(MeterRegistry.class)
            .find("events.consumer.outcomes")
            .tag("outcome", "duplicate")
            .counter();
    return counter == null ? 0 : counter.count();
  }

  private static double retryCount(PgTestSupport.Application target) {
    var counter =
        target
            .context()
            .getBean(MeterRegistry.class)
            .find("events.consumer.retries")
            .tag("cause", "database")
            .counter();
    return counter == null ? 0 : counter.count();
  }

  private static double startupRetries(PgTestSupport.Application target) {
    var counter =
        target
            .context()
            .getBean(MeterRegistry.class)
            .find("events.consumer.startup.retries")
            .counter();
    return counter == null ? 0 : counter.count();
  }

  private PgTestSupport.Response replay(long id, String corrected) throws Exception {
    return db.post(
        app,
        "/internal/quarantine/" + id + "/replays",
        "{\"reason\":\"Operator verified immutable local origin\",\"correctedPayload\":"
            + quote(corrected)
            + "}",
        null);
  }

  private static String quote(String value) {
    return '"'
        + value
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\r", "\\r")
        + '"';
  }

  private static String key() {
    return "phase2-" + UUID.randomUUID();
  }

  private record Pair(UUID source, UUID destination) {}
}
