package dev.tpp.application;

import dev.tpp.domain.ApiException;
import dev.tpp.domain.Models.*;
import dev.tpp.domain.TransferCommand;
import dev.tpp.persistence.LedgerStore;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

@Service
public class AccountService {
  private final LedgerStore store;
  private final TransactionTemplate transaction;

  public AccountService(LedgerStore store, PlatformTransactionManager manager) {
    this.store = store;
    transaction = new TransactionTemplate(manager);
    transaction.setTimeout(5);
  }

  public Account create(String unit) {
    TransferCommand.validateUnit(unit);
    return transaction.execute(status -> store.createAccount(unit));
  }

  public Account account(UUID id) {
    return store.account(id);
  }

  public Balance balance(UUID id) {
    return store.balance(id);
  }

  public record LedgerPage(List<LedgerEntry> items, Long nextCursor) {
    public LedgerPage {
      items = List.copyOf(items);
    }
  }

  public LedgerPage ledger(UUID id, long after, int limit) {
    if (after < 0 || limit < 1 || limit > 100)
      throw new ApiException(
          400, "INVALID_PAGINATION", "after must be nonnegative and limit must be 1–100");
    store.account(id);
    List<LedgerEntry> entries = store.ledger(id, after, limit + 1);
    boolean more = entries.size() > limit;
    List<LedgerEntry> items = List.copyOf(entries.subList(0, Math.min(limit, entries.size())));
    return new LedgerPage(items, more ? items.getLast().id() : null);
  }
}
