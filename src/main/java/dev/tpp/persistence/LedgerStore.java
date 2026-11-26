package dev.tpp.persistence;

import dev.tpp.domain.ApiException;
import dev.tpp.domain.Models.*;
import dev.tpp.domain.TransferCommand;
import dev.tpp.domain.TransferStatus;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

/** Explicit SQL; callers own transactions and lock ordering. */
@Repository
public class LedgerStore {
  private final JdbcTemplate jdbc;

  public LedgerStore(JdbcTemplate jdbc) {
    this.jdbc = jdbc;
  }

  private static Instant instant(ResultSet r, String name) throws SQLException {
    var timestamp = r.getTimestamp(name);
    return timestamp == null ? null : timestamp.toInstant();
  }

  private static final RowMapper<Transfer> TRANSFER =
      (r, n) ->
          new Transfer(
              r.getObject("id", UUID.class),
              r.getObject("source_account_id", UUID.class),
              r.getObject("destination_account_id", UUID.class),
              r.getLong("amount"),
              r.getString("unit"),
              TransferStatus.valueOf(r.getString("status")),
              r.getString("rejection_code"),
              instant(r, "created_at"),
              instant(r, "completed_at"));

  public Account createAccount(String unit) {
    UUID id = UUID.randomUUID();
    Account account =
        jdbc.queryForObject(
            "INSERT INTO accounts(id,kind,status,unit) VALUES (?,'USER','ACTIVE',?) RETURNING *",
            (r, n) ->
                new Account(
                    id, r.getString("status"), r.getString("unit"), instant(r, "created_at")),
            id,
            unit);
    jdbc.update("INSERT INTO balances(account_id,amount) VALUES (?,0)", id);
    return account;
  }

  public Account account(UUID id) {
    return jdbc
        .query(
            "SELECT * FROM accounts WHERE id=? AND kind='USER'",
            (r, n) ->
                new Account(
                    id, r.getString("status"), r.getString("unit"), instant(r, "created_at")),
            id)
        .stream()
        .findFirst()
        .orElseThrow(() -> new ApiException(404, "ACCOUNT_NOT_FOUND", "Account does not exist"));
  }

  public Balance balance(UUID id) {
    return jdbc
        .query(
            "SELECT a.unit,b.amount FROM accounts a JOIN balances b ON b.account_id=a.id WHERE"
                + " a.id=? AND a.kind='USER'",
            (r, n) -> new Balance(id, r.getString("unit"), r.getLong("amount")),
            id)
        .stream()
        .findFirst()
        .orElseThrow(() -> new ApiException(404, "ACCOUNT_NOT_FOUND", "Account does not exist"));
  }

  public int reserve(UUID id, String key, TransferCommand command) {
    return jdbc.update(
        """
        INSERT INTO transfers(id,idempotency_key,source_account_id,destination_account_id,amount,unit,status)
        VALUES (?,?,?,?,?,?,'PROCESSING') ON CONFLICT (idempotency_key) DO NOTHING
        """,
        id,
        key,
        command.sourceAccountId(),
        command.destinationAccountId(),
        command.amount(),
        command.unit());
  }

  public Optional<Transfer> byKey(String key) {
    return jdbc.query("SELECT * FROM transfers WHERE idempotency_key=?", TRANSFER, key).stream()
        .findFirst();
  }

  public Transfer transfer(UUID id) {
    return jdbc.query("SELECT * FROM transfers WHERE id=?", TRANSFER, id).stream()
        .findFirst()
        .orElseThrow(() -> new ApiException(404, "TRANSFER_NOT_FOUND", "Transfer does not exist"));
  }

  public List<LockedAccount> lockAccounts(TransferCommand command) {
    // Database UUID ordering avoids Java's signed UUID comparator mismatch. Lock status and
    // balances together.
    return jdbc.query(
        """
        SELECT a.id,a.kind,a.status,a.unit,b.amount FROM accounts a JOIN balances b ON b.account_id=a.id
        WHERE a.id IN (?,?) ORDER BY a.id FOR UPDATE OF a,b
        """,
        (r, n) ->
            new LockedAccount(
                r.getObject("id", UUID.class),
                r.getString("kind"),
                r.getString("status"),
                r.getString("unit"),
                r.getLong("amount")),
        command.sourceAccountId(),
        command.destinationAccountId());
  }

  public void changeBalance(UUID accountId, long delta) {
    if (jdbc.update("UPDATE balances SET amount=amount+? WHERE account_id=?", delta, accountId)
        != 1) throw new IllegalStateException("Locked balance disappeared");
  }

  public void post(UUID transferId, UUID accountId, long delta) {
    jdbc.update(
        "INSERT INTO ledger_entries(transfer_id,account_id,delta) VALUES (?,?,?)",
        transferId,
        accountId,
        delta);
  }

  public void finish(UUID id, TransferStatus status, String rejection) {
    if (!TransferStatus.PROCESSING.canTransitionTo(status))
      throw new IllegalArgumentException("Invalid transition");
    if (jdbc.update(
            "UPDATE transfers SET status=?,rejection_code=?,completed_at=clock_timestamp() WHERE"
                + " id=? AND status='PROCESSING'",
            status.name(),
            rejection,
            id)
        != 1) throw new IllegalStateException("Transfer is already terminal");
  }

  public List<LedgerEntry> ledger(UUID accountId, long after, int limit) {
    return jdbc.query(
        "SELECT * FROM ledger_entries WHERE account_id=? AND id>? ORDER BY id LIMIT ?",
        (r, n) ->
            new LedgerEntry(
                r.getLong("id"),
                r.getObject("transfer_id", UUID.class),
                accountId,
                r.getLong("delta"),
                instant(r, "created_at")),
        accountId,
        after,
        limit);
  }
}
