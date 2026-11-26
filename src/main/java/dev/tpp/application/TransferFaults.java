package dev.tpp.application;

/**
 * Injectable test seam. The default has no state; there are no HTTP or configuration fault
 * switches.
 */
@FunctionalInterface
public interface TransferFaults {
  enum Boundary {
    BEFORE_TRANSACTION,
    AFTER_FIRST_POSTING,
    BEFORE_COMMIT,
    AFTER_COMMIT,
    BEFORE_REPLAY
  }

  void at(Boundary boundary);
}
