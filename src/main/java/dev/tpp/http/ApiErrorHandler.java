package dev.tpp.http;

import dev.tpp.application.DatabaseErrors;
import dev.tpp.domain.ApiException;
import io.micrometer.core.instrument.MeterRegistry;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.HttpMediaTypeNotAcceptableException;
import org.springframework.web.HttpMediaTypeNotSupportedException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.ServletRequestBindingException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.resource.NoResourceFoundException;

@RestControllerAdvice
public class ApiErrorHandler {
  private static final Logger LOG = LoggerFactory.getLogger(ApiErrorHandler.class);
  private final MeterRegistry metrics;

  public ApiErrorHandler(MeterRegistry metrics) {
    this.metrics = metrics;
  }

  public record ErrorResponse(String code, String message, String correlationId) {}

  @ExceptionHandler(ApiException.class)
  public ResponseEntity<ErrorResponse> domain(ApiException error, HttpServletRequest request) {
    return respond(error.status(), error.code(), error.getMessage(), request);
  }

  @ExceptionHandler({
    MethodArgumentNotValidException.class,
    HttpMessageNotReadableException.class,
    ServletRequestBindingException.class,
    MethodArgumentTypeMismatchException.class,
    ConstraintViolationException.class
  })
  public ResponseEntity<ErrorResponse> invalid(Exception error, HttpServletRequest request) {
    return respond(
        400, "INVALID_REQUEST", "Request fields, headers or parameters are invalid", request);
  }

  @ExceptionHandler(NoResourceFoundException.class)
  public ResponseEntity<ErrorResponse> missing(Exception error, HttpServletRequest request) {
    return respond(404, "NOT_FOUND", "Resource does not exist", request);
  }

  @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
  public ResponseEntity<ErrorResponse> method(Exception error, HttpServletRequest request) {
    return respond(405, "METHOD_NOT_ALLOWED", "Method is not supported for this resource", request);
  }

  @ExceptionHandler(HttpMediaTypeNotSupportedException.class)
  public ResponseEntity<ErrorResponse> unsupportedMedia(
      Exception error, HttpServletRequest request) {
    return respond(
        415, "UNSUPPORTED_MEDIA_TYPE", "Request body must use application/json", request);
  }

  @ExceptionHandler(HttpMediaTypeNotAcceptableException.class)
  public ResponseEntity<ErrorResponse> unacceptableMedia(
      Exception error, HttpServletRequest request) {
    return respond(406, "NOT_ACCEPTABLE", "Response representation is application/json", request);
  }

  @ExceptionHandler(Exception.class)
  public ResponseEntity<ErrorResponse> unexpected(Exception error, HttpServletRequest request) {
    // Do not emit SQL, submitted keys, payloads or connection strings to logs/responses.
    if (DatabaseErrors.dependencyUnavailable(error)) {
      metrics.counter("database.errors", "sqlstate", DatabaseErrors.metricState(error)).increment();
      LOG.warn(
          "Dependency failure type={} sqlstate={}",
          error.getClass().getSimpleName(),
          DatabaseErrors.metricState(error));
      return respond(
          503,
          "DEPENDENCY_UNAVAILABLE",
          "Database unavailable; retry transfers with the same Idempotency-Key",
          request);
    }
    LOG.error(
        "Internal failure type={} sqlstate={}",
        error.getClass().getSimpleName(),
        DatabaseErrors.metricState(error));
    return respond(
        500,
        "INTERNAL_ERROR",
        "Request could not be completed; retry transfers with the same Idempotency-Key",
        request);
  }

  private ResponseEntity<ErrorResponse> respond(
      int status, String code, String message, HttpServletRequest request) {
    String outcome =
        status == 409
            ? "conflict"
            : status == 503
                ? "EVENT_BACKLOG_OVERLOADED".equals(code)
                        || "BACKLOG_STATUS_UNAVAILABLE".equals(code)
                    ? "overloaded"
                    : "dependency_failure"
                : status >= 500 ? "internal_error" : "invalid";
    if ("POST".equals(request.getMethod()) && "/api/transfers".equals(request.getRequestURI()))
      metrics.counter("transfer.outcomes", "outcome", outcome).increment();
    ResponseEntity.BodyBuilder response =
        ResponseEntity.status(status).contentType(MediaType.APPLICATION_JSON);
    if (status == 503) response.header("Retry-After", "1");
    return response.body(
        new ErrorResponse(code, message, (String) request.getAttribute("correlationId")));
  }
}
