package dev.tpp.http;

import dev.tpp.application.AccountService;
import dev.tpp.application.ReconciliationService;
import dev.tpp.application.TransferService;
import dev.tpp.domain.Models.*;
import dev.tpp.domain.TransferCommand;
import dev.tpp.domain.TransferStatus;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import java.net.URI;
import java.util.UUID;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(produces = MediaType.APPLICATION_JSON_VALUE)
public class ApiController {
  private final AccountService accounts;
  private final TransferService transfers;
  private final ReconciliationService reconciliation;

  public ApiController(
      AccountService accounts, TransferService transfers, ReconciliationService reconciliation) {
    this.accounts = accounts;
    this.transfers = transfers;
    this.reconciliation = reconciliation;
  }

  public record CreateAccount(@NotBlank @Pattern(regexp = "FIC") String unit) {}

  public record CreateTransfer(
      @NotNull UUID sourceAccountId,
      @NotNull UUID destinationAccountId,
      @NotNull @Min(1) @Max(TransferCommand.MAX_AMOUNT) Long amount,
      @NotBlank @Pattern(regexp = "FIC") String unit) {}

  @PostMapping("/api/accounts")
  public ResponseEntity<Account> createAccount(@Valid @RequestBody CreateAccount request) {
    Account account = accounts.create(request.unit());
    return ResponseEntity.created(URI.create("/api/accounts/" + account.id())).body(account);
  }

  @GetMapping("/api/accounts/{id}")
  public Account account(@PathVariable UUID id) {
    return accounts.account(id);
  }

  @GetMapping("/api/accounts/{id}/balance")
  public Balance balance(@PathVariable UUID id) {
    return accounts.balance(id);
  }

  @GetMapping("/api/accounts/{id}/ledger")
  public AccountService.LedgerPage ledger(
      @PathVariable UUID id,
      @RequestParam(defaultValue = "0") long after,
      @RequestParam(defaultValue = "50") int limit) {
    return accounts.ledger(id, after, limit);
  }

  @PostMapping("/api/transfers")
  public ResponseEntity<Transfer> transfer(
      @RequestHeader("Idempotency-Key") String key, @Valid @RequestBody CreateTransfer request) {
    Submission result =
        transfers.submit(
            key,
            new TransferCommand(
                request.sourceAccountId(),
                request.destinationAccountId(),
                request.amount(),
                request.unit()));
    int status =
        result.transfer().status() == TransferStatus.REJECTED ? 422 : result.replay() ? 200 : 201;
    return ResponseEntity.status(status)
        .location(URI.create("/api/transfers/" + result.transfer().id()))
        .header("Idempotency-Replayed", Boolean.toString(result.replay()))
        .body(result.transfer());
  }

  @GetMapping("/api/transfers/{id}")
  public Transfer transfer(@PathVariable UUID id) {
    return transfers.get(id);
  }

  @GetMapping("/internal/reconciliation")
  public ReconciliationService.Report reconcile() {
    return reconciliation.reconcile();
  }
}
