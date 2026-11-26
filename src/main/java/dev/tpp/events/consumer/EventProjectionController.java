package dev.tpp.events.consumer;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.util.List;
import java.util.UUID;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class EventProjectionController {
  private final ProjectionService projections;
  private final QuarantineService quarantine;

  public EventProjectionController(ProjectionService projections, QuarantineService quarantine) {
    this.projections = projections;
    this.quarantine = quarantine;
  }

  @GetMapping(value = "/api/accounts/{id}/activity", produces = MediaType.APPLICATION_JSON_VALUE)
  public ProjectionService.ActivityPage activity(
      @PathVariable UUID id,
      @RequestParam(defaultValue = "0") long after,
      @RequestParam(defaultValue = "50") int limit) {
    return projections.activity(id, after, limit);
  }

  @GetMapping(
      value = {"/internal/events/reconciliation", "/internal/events/reconciliation/status"},
      produces = MediaType.APPLICATION_JSON_VALUE)
  public ProjectionService.Report reconcile() {
    return projections.reconcile();
  }

  @GetMapping(value = "/internal/quarantine", produces = MediaType.APPLICATION_JSON_VALUE)
  public List<QuarantineService.QuarantineItem> list(
      @RequestParam(defaultValue = "0") long after, @RequestParam(defaultValue = "50") int limit) {
    return quarantine.list(after, limit);
  }

  @GetMapping(value = "/internal/quarantine/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
  public QuarantineService.QuarantineItem inspect(@PathVariable long id) {
    return quarantine.get(id);
  }

  @GetMapping(
      value = "/internal/quarantine/{id}/replays",
      produces = MediaType.APPLICATION_JSON_VALUE)
  public List<QuarantineService.ReplayAudit> replays(@PathVariable long id) {
    return quarantine.replays(id);
  }

  public record ReplayRequest(@NotBlank @Size(max = 500) String reason, String correctedPayload) {}

  @PostMapping(
      value = "/internal/quarantine/{id}/replays",
      produces = MediaType.APPLICATION_JSON_VALUE)
  public QuarantineService.ReplayResult replay(
      @PathVariable long id, @Valid @RequestBody ReplayRequest request) {
    return quarantine.replay(id, request.reason(), request.correctedPayload());
  }
}
