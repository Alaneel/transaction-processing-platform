package dev.tpp.events;

public class EventValidationException extends RuntimeException {
  private final String code;

  public EventValidationException(String code, String message) {
    super(message);
    this.code = code;
  }

  public String code() {
    return code;
  }
}
