package dev.tpp.events;

import java.util.concurrent.ThreadLocalRandom;

public final class RetryDelay {
  private RetryDelay() {}

  /** Equal jitter stays inside the configured cap and never becomes a zero-delay storm. */
  public static long milliseconds(int attempt, long base, long cap) {
    long exponential = Math.min(cap, base * (1L << Math.min(20, Math.max(0, attempt - 1))));
    long floor = Math.max(1, exponential / 2);
    return ThreadLocalRandom.current().nextLong(floor, Math.max(floor + 1, exponential + 1));
  }
}
