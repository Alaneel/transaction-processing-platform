package dev.tpp.domain;

public enum TransferStatus {
  PROCESSING,
  COMPLETED,
  REJECTED;

  public boolean canTransitionTo(TransferStatus next) {
    return this == PROCESSING && (next == COMPLETED || next == REJECTED);
  }
}
