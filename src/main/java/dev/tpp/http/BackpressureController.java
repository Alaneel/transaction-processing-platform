package dev.tpp.http;

import dev.tpp.application.BacklogAdmission;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class BackpressureController {
  private final BacklogAdmission admission;

  public BackpressureController(BacklogAdmission admission) {
    this.admission = admission;
  }

  @GetMapping(value = "/internal/backpressure", produces = MediaType.APPLICATION_JSON_VALUE)
  public BacklogAdmission.Status status() {
    return admission.status();
  }
}
