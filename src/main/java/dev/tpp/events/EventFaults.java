package dev.tpp.events;

import java.util.UUID;

/**
 * Injectable bounded crash seams for tests, never configurable over HTTP or production settings.
 */
@FunctionalInterface
public interface EventFaults {
  enum Boundary {
    RELAY_AFTER_CLAIM,
    RELAY_BEFORE_SEND,
    RELAY_AFTER_KAFKA_ACK,
    RELAY_BEFORE_STATUS_COMMIT,
    CONSUMER_BEFORE_CONNECT,
    CONSUMER_BEFORE_COMMIT,
    CONSUMER_AFTER_COMMIT,
    CONSUMER_BEFORE_OFFSET_COMMIT,
    REPLAY_BEFORE_COMMIT
  }

  void at(Boundary boundary, UUID eventId);

  final class Crash extends RuntimeException {
    public Crash(String message) {
      super(message);
    }
  }
}
