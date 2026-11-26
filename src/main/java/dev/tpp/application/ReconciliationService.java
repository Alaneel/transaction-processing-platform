package dev.tpp.application;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.support.TransactionTemplate;

@Service
public class ReconciliationService {
  private final JdbcTemplate jdbc;
  private final TransactionTemplate snapshot;

  public ReconciliationService(JdbcTemplate jdbc, PlatformTransactionManager manager) {
    this.jdbc = jdbc;
    snapshot = new TransactionTemplate(manager);
    snapshot.setIsolationLevel(TransactionDefinition.ISOLATION_REPEATABLE_READ);
    snapshot.setReadOnly(true);
    snapshot.setTimeout(10);
  }

  public record Mismatch(UUID accountId, BigDecimal materialized, BigDecimal ledger) {}

  public record Report(
      boolean consistent,
      List<Mismatch> balanceMismatches,
      List<UUID> invalidTransfers,
      BigDecimal totalLedgerDelta,
      BigDecimal totalMaterializedBalance) {
    public Report {
      balanceMismatches = List.copyOf(balanceMismatches);
      invalidTransfers = List.copyOf(invalidTransfers);
    }
  }

  public Report reconcile() {
    return snapshot.execute(
        status -> {
          List<Mismatch> balances =
              jdbc.query(
                  """
                  SELECT a.id,b.amount,coalesce(sum(l.delta),0) AS ledger FROM accounts a
                  LEFT JOIN balances b ON b.account_id=a.id LEFT JOIN ledger_entries l ON l.account_id=a.id
                  GROUP BY a.id,b.amount HAVING b.amount IS NULL OR b.amount<>coalesce(sum(l.delta),0)
                  OR (a.kind='USER' AND b.amount<0)
                  """,
                  (r, n) ->
                      new Mismatch(
                          r.getObject("id", UUID.class),
                          r.getBigDecimal("amount"),
                          r.getBigDecimal("ledger")));
          List<UUID> transfers =
              jdbc.query(
                  """
                  SELECT t.id FROM transfers t LEFT JOIN ledger_entries l ON l.transfer_id=t.id
                  GROUP BY t.id HAVING t.status='PROCESSING'
                  OR (t.status='REJECTED' AND count(l.id)<>0)
                  OR (t.status='COMPLETED' AND (count(l.id)<>2 OR coalesce(sum(l.delta),0)<>0
                    OR count(l.id) FILTER(WHERE l.account_id=t.source_account_id AND l.delta=-t.amount)<>1
                    OR count(l.id) FILTER(WHERE l.account_id=t.destination_account_id AND l.delta=t.amount)<>1))
                  """,
                  (r, n) -> r.getObject("id", UUID.class));
          BigDecimal totalLedger =
              jdbc.queryForObject(
                  "SELECT coalesce(sum(delta),0) FROM ledger_entries", BigDecimal.class);
          BigDecimal totalBalance =
              jdbc.queryForObject("SELECT coalesce(sum(amount),0) FROM balances", BigDecimal.class);
          return new Report(
              balances.isEmpty()
                  && transfers.isEmpty()
                  && totalLedger.signum() == 0
                  && totalBalance.signum() == 0,
              List.copyOf(balances),
              List.copyOf(transfers),
              totalLedger,
              totalBalance);
        });
  }
}
