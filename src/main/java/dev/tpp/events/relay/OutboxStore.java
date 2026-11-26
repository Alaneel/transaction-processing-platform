package dev.tpp.events.relay;

import dev.tpp.domain.ApiException;
import dev.tpp.events.EventCodec;
import dev.tpp.events.EventSettings;
import dev.tpp.events.RetryDelay;
import dev.tpp.events.TransferCompletedEvent;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Instant;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import org.apache.kafka.clients.producer.RecordMetadata;
import org.springframework.boot.sql.init.dependency.DependsOnDatabaseInitialization;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

@Repository
@DependsOnDatabaseInitialization
public class OutboxStore {
  private final JdbcTemplate jdbc;
  private final TransactionTemplate tx;
  private final EventSettings settings;
  private final EventCodec codec;

  public record Claim(
      UUID eventId,
      UUID transferId,
      String payload,
      UUID claimToken,
      int attemptCount,
      Instant createdAt,
      Instant leaseUntil,
      boolean recoveredLease) {}

  public record Stats(
      long pending,
      long claimed,
      long published,
      long blocked,
      long expiredClaims,
      double oldestPendingAgeSeconds) {
    public long backlog() {
      return pending + claimed + blocked;
    }
  }

  public record Inspection(
      UUID eventId,
      UUID transferId,
      String status,
      int attemptCount,
      Instant createdAt,
      Instant nextAttemptAt,
      UUID claimedBy,
      UUID claimToken,
      Instant leaseUntil,
      Instant publishedAt,
      String kafkaTopic,
      Integer kafkaPartition,
      Long kafkaOffset,
      String lastErrorCode,
      String lastErrorClassification,
      String lastErrorDetail,
      Instant lastErrorAt,
      Instant processedAt,
      Instant projectedAt,
      Long latestQuarantineId,
      TransferCompletedEvent payload) {}

  public OutboxStore(
      JdbcTemplate jdbc,
      PlatformTransactionManager manager,
      EventSettings settings,
      EventCodec codec) {
    this.jdbc = jdbc;
    this.settings = settings;
    this.codec = codec;
    tx = new TransactionTemplate(manager);
    tx.setTimeout(settings.dbTimeoutSeconds());
  }

  private void timeouts() {
    jdbc.queryForMap(
        "SELECT set_config('statement_timeout',?,true),set_config('lock_timeout','250ms',true)",
        (settings.dbTimeoutSeconds() * 1000) + "ms");
  }

  public List<Claim> claim(UUID owner, int limit) {
    if (limit < 1 || limit > settings.batchSize())
      throw new IllegalArgumentException("Invalid bounded claim size");
    return tx.execute(
        status -> {
          timeouts();
          return jdbc.query(
              """
              WITH ready AS (
                SELECT event_id,status AS previous_status FROM outbox_events
                WHERE (status='PENDING' AND next_attempt_at<=clock_timestamp())
                   OR (status='CLAIMED' AND lease_until<=clock_timestamp())
                ORDER BY created_at,event_id FOR UPDATE SKIP LOCKED LIMIT ?
              )
              UPDATE outbox_events o SET status='CLAIMED',claimed_by=?,claim_token=gen_random_uuid(),
                  claimed_at=clock_timestamp(),lease_until=clock_timestamp()+(? * interval '1 millisecond'),
                  attempt_count=LEAST(o.attempt_count::BIGINT+1,2147483647)
              FROM ready WHERE o.event_id=ready.event_id
              RETURNING o.*,ready.previous_status
              """,
              (r, n) ->
                  new Claim(
                      r.getObject("event_id", UUID.class),
                      r.getObject("transfer_id", UUID.class),
                      r.getString("payload"),
                      r.getObject("claim_token", UUID.class),
                      r.getInt("attempt_count"),
                      instant(r, "created_at"),
                      instant(r, "lease_until"),
                      r.getString("previous_status").equals("CLAIMED")),
              limit,
              owner,
              settings.leaseMs());
        });
  }

  public boolean renew(Claim claim) {
    return tx.execute(
        status -> {
          timeouts();
          return jdbc.update(
                  """
                  UPDATE outbox_events SET lease_until=clock_timestamp()+(? * interval '1 millisecond')
                  WHERE event_id=? AND status='CLAIMED' AND claim_token=? AND lease_until>clock_timestamp()
                  """,
                  settings.leaseMs(),
                  claim.eventId(),
                  claim.claimToken())
              == 1;
        });
  }

  /** One bounded transaction renews only still-live generations; returned IDs are committed. */
  public Set<UUID> renewBatch(List<Claim> claims) {
    var batch = List.copyOf(claims);
    validateClaims(batch);
    if (batch.isEmpty()) return Set.of();
    var values = new ArrayList<Object>();
    values.add(settings.leaseMs());
    for (var claim : batch) {
      values.add(claim.eventId());
      values.add(claim.claimToken());
    }
    String rows =
        String.join(",", java.util.Collections.nCopies(batch.size(), "(?::uuid,?::uuid)"));
    return tx.execute(
        status -> {
          timeouts();
          return Set.copyOf(
              jdbc.query(
                  """
                  UPDATE outbox_events o SET lease_until=clock_timestamp()+(? * interval '1 millisecond')
                  FROM (VALUES %s) v(event_id,claim_token)
                  WHERE o.event_id=v.event_id AND o.claim_token=v.claim_token
                    AND o.status='CLAIMED' AND o.lease_until>clock_timestamp()
                  RETURNING o.event_id
                  """
                      .replace("%s", rows),
                  (r, n) -> r.getObject(1, UUID.class),
                  values.toArray()));
        });
  }

  private void validateClaims(List<Claim> claims) {
    if (claims.size() > settings.batchSize())
      throw new IllegalArgumentException("Invalid bounded claim size");
    var identities = new HashSet<UUID>();
    for (var claim : claims)
      if (claim == null
          || claim.eventId() == null
          || claim.claimToken() == null
          || !identities.add(claim.eventId()))
        throw new IllegalArgumentException(
            "Claims require distinct event identities and generations");
  }

  /**
   * Fences every result independently and commits the bounded status set atomically. A Kafka ACK
   * does not count as durable publication until this transaction returns successfully. A statement
   * or commit failure leaves no assumed per-row success; lease recovery may republish accepted
   * data.
   */
  public Set<UUID> settle(List<PublicationBatch.Result> results) {
    var batch = List.copyOf(results);
    validateClaims(batch.stream().map(PublicationBatch.Result::claim).toList());
    if (batch.isEmpty()) return Set.of();
    var values = new ArrayList<Object>();
    for (var result : batch) {
      var claim = result.claim();
      var position = result.position();
      if (position != null && !settings.topic().equals(position.topic()))
        throw new IllegalArgumentException(
            "Publication acknowledgement topic differs from configured topic");
      values.add(claim.eventId());
      values.add(claim.claimToken());
      values.add(result.acknowledged() ? "PUBLISHED" : result.permanent() ? "BLOCKED" : "PENDING");
      values.add(position == null ? null : position.topic());
      values.add(position == null ? null : position.partition());
      values.add(position == null ? null : position.offset());
      values.add(result.code());
      values.add(result.classification());
      values.add(result.safeDetail());
      values.add(
          RetryDelay.milliseconds(
              claim.attemptCount(), settings.retryBaseMs(), settings.retryMaxMs()));
    }
    String rows =
        String.join(
            ",",
            java.util.Collections.nCopies(
                batch.size(),
                "(?::uuid,?::uuid,?::varchar,?::varchar,?::integer,?::bigint,?::varchar,?::varchar,?::varchar,?::bigint)"));
    return tx.execute(
        status -> {
          timeouts();
          return Set.copyOf(
              jdbc.query(
                  """
                  UPDATE outbox_events o SET status=v.status,
                    published_at=CASE WHEN v.status='PUBLISHED' THEN clock_timestamp() ELSE NULL END,
                    kafka_topic=v.kafka_topic,kafka_partition=v.kafka_partition,kafka_offset=v.kafka_offset,
                    next_attempt_at=CASE WHEN v.status='PUBLISHED' THEN o.next_attempt_at
                      ELSE clock_timestamp()+(v.delay_ms * interval '1 millisecond') END,
                    last_error_code=CASE WHEN v.status='PUBLISHED' THEN o.last_error_code ELSE v.code END,
                    last_error_classification=CASE WHEN v.status='PUBLISHED' THEN o.last_error_classification ELSE v.classification END,
                    last_error_detail=CASE WHEN v.status='PUBLISHED' THEN o.last_error_detail ELSE v.detail END,
                    last_error_at=CASE WHEN v.status='PUBLISHED' THEN o.last_error_at ELSE clock_timestamp() END,
                    claimed_by=NULL,claim_token=NULL,claimed_at=NULL,lease_until=NULL
                  FROM (VALUES %s) v(event_id,claim_token,status,kafka_topic,kafka_partition,kafka_offset,code,classification,detail,delay_ms)
                  WHERE o.event_id=v.event_id AND o.claim_token=v.claim_token
                    AND o.status='CLAIMED' AND o.lease_until>clock_timestamp()
                  RETURNING o.event_id
                  """
                      .replace("%s", rows),
                  (r, n) -> r.getObject(1, UUID.class),
                  values.toArray()));
        });
  }

  public boolean published(Claim claim, RecordMetadata metadata) {
    return tx.execute(
        status -> {
          timeouts();
          return jdbc.update(
                  """
                  UPDATE outbox_events SET status='PUBLISHED',published_at=clock_timestamp(),kafka_topic=?,kafka_partition=?,kafka_offset=?,
                    claimed_by=NULL,claim_token=NULL,claimed_at=NULL,lease_until=NULL
                  WHERE event_id=? AND status='CLAIMED' AND claim_token=? AND lease_until>clock_timestamp()
                  """,
                  metadata.topic(),
                  metadata.partition(),
                  metadata.offset(),
                  claim.eventId(),
                  claim.claimToken())
              == 1;
        });
  }

  public boolean failed(
      Claim claim, String code, String classification, String safeDetail, boolean permanent) {
    long delay =
        RetryDelay.milliseconds(
            claim.attemptCount(), settings.retryBaseMs(), settings.retryMaxMs());
    return tx.execute(
        status -> {
          timeouts();
          return jdbc.update(
                  """
                  UPDATE outbox_events SET status=?,next_attempt_at=clock_timestamp()+(? * interval '1 millisecond'),
                    last_error_code=?,last_error_classification=?,last_error_detail=?,last_error_at=clock_timestamp(),
                    claimed_by=NULL,claim_token=NULL,claimed_at=NULL,lease_until=NULL
                  WHERE event_id=? AND status='CLAIMED' AND claim_token=? AND lease_until>clock_timestamp()
                  """,
                  permanent ? "BLOCKED" : "PENDING",
                  delay,
                  code,
                  classification,
                  safeDetail,
                  claim.eventId(),
                  claim.claimToken())
              == 1;
        });
  }

  public void requeue(UUID id, String reason) {
    if (reason == null || reason.isBlank() || reason.length() > 256)
      throw new ApiException(400, "INVALID_REASON", "A reason of 1–256 characters is required");
    tx.executeWithoutResult(
        status -> {
          timeouts();
          var prior =
              jdbc.queryForList(
                  "SELECT status FROM outbox_events WHERE event_id=? FOR UPDATE", String.class, id);
          if (prior.isEmpty())
            throw new ApiException(404, "EVENT_NOT_FOUND", "Outbox event does not exist");
          if (!prior.getFirst().equals("BLOCKED"))
            throw new ApiException(
                409, "EVENT_NOT_BLOCKED", "Only a blocked event can be requeued");
          jdbc.update(
              "INSERT INTO outbox_requeue_audit(event_id,reason) VALUES (?,?)", id, reason.trim());
          jdbc.update(
              "UPDATE outbox_events SET status='PENDING',next_attempt_at=clock_timestamp() WHERE"
                  + " event_id=?",
              id);
        });
  }

  public Stats stats() {
    return tx.execute(
        status -> {
          timeouts();
          return jdbc.queryForObject(
              """
              SELECT count(*) FILTER(WHERE status='PENDING') AS pending,
                count(*) FILTER(WHERE status='CLAIMED') AS claimed,
                count(*) FILTER(WHERE status='PUBLISHED') AS published,
                count(*) FILTER(WHERE status='BLOCKED') AS blocked,
                count(*) FILTER(WHERE status='CLAIMED' AND lease_until<=clock_timestamp()) AS expired,
                coalesce(greatest(0,extract(epoch FROM clock_timestamp()-min(created_at) FILTER(WHERE status<>'PUBLISHED'))),0) AS age
              FROM outbox_events
              """,
              (r, n) ->
                  new Stats(
                      r.getLong("pending"),
                      r.getLong("claimed"),
                      r.getLong("published"),
                      r.getLong("blocked"),
                      r.getLong("expired"),
                      r.getDouble("age")));
        });
  }

  public Inspection inspect(UUID id) {
    return tx.execute(
        status -> {
          timeouts();
          var rows =
              jdbc.query(
                  """
                  SELECT o.*,i.processed_at,p.projected_at,
                    (SELECT max(q.id) FROM event_quarantine q WHERE q.event_id=o.event_id) AS quarantine_id
                  FROM outbox_events o LEFT JOIN event_inbox i ON i.event_id=o.event_id
                  LEFT JOIN transfer_activity_projection p ON p.event_id=o.event_id WHERE o.event_id=?
                  """,
                  (r, n) ->
                      new Inspection(
                          r.getObject("event_id", UUID.class),
                          r.getObject("transfer_id", UUID.class),
                          r.getString("status"),
                          r.getInt("attempt_count"),
                          instant(r, "created_at"),
                          instant(r, "next_attempt_at"),
                          r.getObject("claimed_by", UUID.class),
                          r.getObject("claim_token", UUID.class),
                          instant(r, "lease_until"),
                          instant(r, "published_at"),
                          r.getString("kafka_topic"),
                          r.getObject("kafka_partition", Integer.class),
                          r.getObject("kafka_offset", Long.class),
                          r.getString("last_error_code"),
                          r.getString("last_error_classification"),
                          r.getString("last_error_detail"),
                          instant(r, "last_error_at"),
                          instant(r, "processed_at"),
                          instant(r, "projected_at"),
                          r.getObject("quarantine_id", Long.class),
                          codec.decode(r.getString("payload"))),
                  id);
          if (rows.isEmpty())
            throw new ApiException(404, "EVENT_NOT_FOUND", "Outbox event does not exist");
          return rows.getFirst();
        });
  }

  private static Instant instant(ResultSet r, String name) throws SQLException {
    var value = r.getTimestamp(name);
    return value == null ? null : value.toInstant();
  }
}
