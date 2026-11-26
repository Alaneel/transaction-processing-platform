package dev.tpp.events.relay;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import org.apache.kafka.common.errors.InvalidTopicException;
import org.junit.jupiter.api.Test;

class PublicationBatchTest {
  private static final String TOPIC = "batch-evidence";

  @Test
  void boundedClaimsAndFrozenResultsCannotBeMutatedOrAliasCallerLists() {
    var source = new ArrayList<>(List.of(claim()));
    var batch = new PublicationBatch(source, TOPIC);
    source.clear();
    assertThat(batch.claims()).hasSize(1);
    assertThatThrownBy(() -> batch.claims().clear())
        .isInstanceOf(UnsupportedOperationException.class);
    assertThatThrownBy(() -> batch.finish().clear())
        .isInstanceOf(UnsupportedOperationException.class);
    assertThat(batch.finish()).isSameAs(batch.cancel());
    assertThatThrownBy(
            () ->
                new PublicationBatch(
                    java.util.stream.IntStream.range(0, 101).mapToObj(ignored -> claim()).toList(),
                    TOPIC))
        .isInstanceOf(IllegalArgumentException.class);
    var duplicate = claim();
    assertThatThrownBy(() -> new PublicationBatch(List.of(duplicate, duplicate), TOPIC))
        .isInstanceOf(IllegalArgumentException.class);
  }

  @Test
  void reverseAcknowledgementsRetainTheExactClaimAndIndividualKafkaPosition() throws Exception {
    var claims = List.of(claim(), claim(), claim());
    var batch = new PublicationBatch(claims, TOPIC);
    for (var claim : claims)
      assertThat(batch.beginSend(claim.eventId(), claim.claimToken())).isTrue();
    for (int index = claims.size() - 1; index >= 0; index--) {
      var claim = claims.get(index);
      assertThat(batch.acknowledge(claim.eventId(), claim.claimToken(), position(index))).isTrue();
    }
    assertThat(batch.awaitUntil(System.nanoTime())).isTrue();
    var snapshot = batch.finish();
    for (int index = 0; index < claims.size(); index++) {
      assertThat(snapshot.get(index).claim()).isEqualTo(claims.get(index));
      assertThat(snapshot.get(index).position()).isEqualTo(position(index));
      assertThat(snapshot.get(index).acknowledged()).isTrue();
    }
  }

  @Test
  void unknownGenerationUnsubmittedAcknowledgementAndDuplicateCallbackCannotChangeOutcome() {
    var claim = claim();
    var batch = new PublicationBatch(List.of(claim), TOPIC);
    assertThat(batch.acknowledge(claim.eventId(), claim.claimToken(), position(1))).isFalse();
    assertThat(batch.beginSend(claim.eventId(), UUID.randomUUID())).isFalse();
    assertThat(batch.beginSend(UUID.randomUUID(), claim.claimToken())).isFalse();
    assertThat(batch.beginSend(claim.eventId(), claim.claimToken())).isTrue();
    assertThat(batch.beginSend(claim.eventId(), claim.claimToken())).isFalse();
    assertThat(batch.acknowledge(claim.eventId(), UUID.randomUUID(), position(9))).isFalse();
    assertThat(batch.acknowledge(claim.eventId(), claim.claimToken(), position(3))).isTrue();
    assertThat(
            batch.fail(claim.eventId(), claim.claimToken(), new InvalidTopicException("ignored")))
        .isFalse();
    assertThat(batch.acknowledge(claim.eventId(), claim.claimToken(), position(4))).isFalse();
    assertThat(batch.finish().getFirst().position()).isEqualTo(position(3));
  }

  @Test
  void deadlineDistinguishesNeverSubmittedWorkFromUncertainInFlightWorkAndIgnoresLateAck()
      throws Exception {
    var unsent = claim();
    var submitted = claim();
    var batch = new PublicationBatch(List.of(unsent, submitted), TOPIC);
    batch.beginSend(submitted.eventId(), submitted.claimToken());
    assertThat(batch.awaitUntil(System.nanoTime() - 1)).isFalse();
    var snapshot = batch.finish();
    assertThat(snapshot.getFirst().classification()).isEqualTo("TRANSIENT");
    assertThat(snapshot.getFirst().code()).isEqualTo("BATCH_NOT_SENT");
    assertThat(snapshot.getLast().classification()).isEqualTo("AMBIGUOUS");
    assertThat(snapshot.getLast().code()).isEqualTo("DELIVERY_UNCERTAIN");
    assertThat(snapshot).allMatch(result -> !result.acknowledged() && !result.permanent());
    assertThat(batch.acknowledge(submitted.eventId(), submitted.claimToken(), position(5)))
        .isFalse();
    assertThat(batch.beginSend(unsent.eventId(), unsent.claimToken())).isFalse();
    assertThat(batch.finish()).isSameAs(snapshot);
  }

  @Test
  void invalidAcknowledgementsCannotBecomePublishedAndKnownPermanentErrorsRemainDistinct() {
    var wrongTopic = claim();
    var permanent = claim();
    var batch = new PublicationBatch(List.of(wrongTopic, permanent), TOPIC);
    batch.beginSend(wrongTopic.eventId(), wrongTopic.claimToken());
    assertThat(
            batch.acknowledge(
                wrongTopic.eventId(),
                wrongTopic.claimToken(),
                new PublicationBatch.KafkaPosition("other-topic", 0, 8)))
        .isTrue();
    assertThat(
            batch.fail(
                permanent.eventId(),
                permanent.claimToken(),
                new java.util.concurrent.CompletionException(
                    new InvalidTopicException("unsafe raw detail"))))
        .isTrue();
    var snapshot = batch.finish();
    assertThat(snapshot.getFirst().code()).isEqualTo("INVALID_KAFKA_ACK");
    assertThat(snapshot.getFirst().classification()).isEqualTo("AMBIGUOUS");
    assertThat(snapshot.getLast().classification()).isEqualTo("PERMANENT");
    assertThat(snapshot.getLast().permanent()).isTrue();
    assertThat(snapshot.getLast().safeDetail()).isEqualTo("InvalidTopicException");
    assertThat(snapshot).noneMatch(PublicationBatch.Result::acknowledged);
    assertThatThrownBy(() -> new PublicationBatch.KafkaPosition(TOPIC, -1, 0))
        .isInstanceOf(IllegalArgumentException.class);
    assertThatThrownBy(() -> new PublicationBatch.KafkaPosition(TOPIC, 0, -1))
        .isInstanceOf(IllegalArgumentException.class);
  }

  @Test
  void synchronousFailureWinsOverLaterCallbackAndEvidenceStaysBounded() {
    var claim = claim();
    var batch = new PublicationBatch(List.of(claim), TOPIC);
    batch.beginSend(claim.eventId(), claim.claimToken());
    assertThat(
            batch.fail(
                claim.eventId(),
                claim.claimToken(),
                "DELIVERY_UNCERTAIN",
                "AMBIGUOUS",
                "x".repeat(1000),
                false))
        .isTrue();
    assertThat(batch.acknowledge(claim.eventId(), claim.claimToken(), position(2))).isFalse();
    var result = batch.finish().getFirst();
    assertThat(result.safeDetail()).hasSize(256);
    assertThat(result.acknowledged()).isFalse();
  }

  @Test
  void cancellationRacingCallbackFreezesExactlyOneOutcomeAndCannotBeReopened() throws Exception {
    try (var executor = Executors.newFixedThreadPool(2)) {
      for (int iteration = 0; iteration < 50; iteration++) {
        var claim = claim();
        var batch = new PublicationBatch(List.of(claim), TOPIC);
        batch.beginSend(claim.eventId(), claim.claimToken());
        var start = new CountDownLatch(1);
        var ready = new CountDownLatch(2);
        var callback =
            executor.submit(
                () -> {
                  ready.countDown();
                  assertThat(start.await(5, TimeUnit.SECONDS)).isTrue();
                  return batch.acknowledge(claim.eventId(), claim.claimToken(), position(1));
                });
        var cancel =
            executor.submit(
                () -> {
                  ready.countDown();
                  assertThat(start.await(5, TimeUnit.SECONDS)).isTrue();
                  return batch.cancel();
                });
        assertThat(ready.await(5, TimeUnit.SECONDS)).isTrue();
        start.countDown();
        var snapshot = cancel.get(5, TimeUnit.SECONDS);
        assertThat(snapshot).hasSize(1);
        assertThat(snapshot.getFirst().acknowledged()).isEqualTo(callback.get(5, TimeUnit.SECONDS));
        assertThat(batch.finish()).isSameAs(snapshot);
        assertThat(batch.acknowledge(claim.eventId(), claim.claimToken(), position(2))).isFalse();
      }
    }
  }

  @Test
  void callbackWakesAnInterruptibleMonotonicWaitWithoutRequiringAProducerThread() throws Exception {
    var claim = claim();
    var batch = new PublicationBatch(List.of(claim), TOPIC);
    batch.beginSend(claim.eventId(), claim.claimToken());
    try (var executor = Executors.newSingleThreadExecutor()) {
      var waiting = new CountDownLatch(1);
      var result =
          executor.submit(
              () -> {
                waiting.countDown();
                return batch.awaitUntil(System.nanoTime() + TimeUnit.SECONDS.toNanos(5));
              });
      assertThat(waiting.await(5, TimeUnit.SECONDS)).isTrue();
      batch.acknowledge(claim.eventId(), claim.claimToken(), position(1));
      assertThat(result.get(5, TimeUnit.SECONDS)).isTrue();
    }
    var unfinished = new PublicationBatch(List.of(claim()), TOPIC);
    var interrupted = new java.util.concurrent.atomic.AtomicReference<Throwable>();
    var entering = new CountDownLatch(1);
    Thread waiter =
        new Thread(
            () -> {
              entering.countDown();
              try {
                unfinished.awaitUntil(System.nanoTime() + TimeUnit.SECONDS.toNanos(5));
              } catch (Throwable failure) {
                interrupted.set(failure);
              }
            });
    waiter.start();
    assertThat(entering.await(5, TimeUnit.SECONDS)).isTrue();
    waiter.interrupt();
    waiter.join(5000);
    assertThat(waiter.isAlive()).isFalse();
    assertThat(interrupted.get()).isInstanceOf(InterruptedException.class);
  }

  private static OutboxStore.Claim claim() {
    return new OutboxStore.Claim(
        UUID.randomUUID(),
        UUID.randomUUID(),
        "{}",
        UUID.randomUUID(),
        1,
        Instant.EPOCH,
        Instant.EPOCH.plusSeconds(10),
        false);
  }

  private static PublicationBatch.KafkaPosition position(int offset) {
    return new PublicationBatch.KafkaPosition(TOPIC, offset % 3, offset);
  }
}
