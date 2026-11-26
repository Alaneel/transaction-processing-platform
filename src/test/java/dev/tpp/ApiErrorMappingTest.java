package dev.tpp;

import static org.assertj.core.api.Assertions.assertThat;

import dev.tpp.domain.ApiException;
import dev.tpp.http.ApiErrorHandler;
import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import java.sql.SQLException;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;

class ApiErrorMappingTest {
  @Test
  void explicitDomainErrorPreservesCodeStatusAndCorrelation() {
    var registry = new SimpleMeterRegistry();
    try {
      var request = new MockHttpServletRequest("POST", "/api/transfers");
      request.setAttribute("correlationId", "test-correlation");
      var response =
          new ApiErrorHandler(registry)
              .domain(new ApiException(409, "IDEMPOTENCY_CONFLICT", "Already used"), request);
      assertThat(response.getStatusCode().value()).isEqualTo(409);
      assertThat(response.getBody().code()).isEqualTo("IDEMPOTENCY_CONFLICT");
      assertThat(response.getBody().correlationId()).isEqualTo("test-correlation");
      assertThat(registry.get("transfer.outcomes").tag("outcome", "conflict").counter().count())
          .isEqualTo(1);
    } finally {
      registry.close();
    }
  }

  @Test
  void infrastructureFailuresReturnRetryableServiceResponseWithoutSensitiveDetails() {
    var registry = new SimpleMeterRegistry();
    try {
      var request = new MockHttpServletRequest("POST", "/api/transfers");
      request.setAttribute("correlationId", "test-correlation");
      var failure =
          new RuntimeException(new SQLException("secret SQL and connection string", "08006"));
      var response = new ApiErrorHandler(registry).unexpected(failure, request);
      assertThat(response.getStatusCode().value()).isEqualTo(503);
      assertThat(response.getHeaders().getFirst("Retry-After")).isEqualTo("1");
      assertThat(response.getBody().code()).isEqualTo("DEPENDENCY_UNAVAILABLE");
      assertThat(response.getBody().message()).doesNotContain("secret", "connection string");
    } finally {
      registry.close();
    }
  }

  @Test
  void unexpectedProgrammingFailureDoesNotClaimSuccessfulOrRejectedTransfer() {
    var registry = new SimpleMeterRegistry();
    try {
      var request = new MockHttpServletRequest("POST", "/api/transfers");
      var response =
          new ApiErrorHandler(registry)
              .unexpected(new IllegalStateException("private implementation details"), request);
      assertThat(response.getStatusCode().value()).isEqualTo(500);
      assertThat(response.getBody().code()).isEqualTo("INTERNAL_ERROR");
      assertThat(response.getBody().message()).doesNotContain("private implementation details");
    } finally {
      registry.close();
    }
  }
}
