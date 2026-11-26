package dev.tpp.http;

import dev.tpp.application.TransferSettings;
import dev.tpp.domain.ApiException;
import dev.tpp.domain.TransferCommand;
import dev.tpp.domain.TransferStatus;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Objects;
import java.util.UUID;
import org.springframework.http.CacheControl;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

/** A bounded point inspection of the authoritative postings, independent of event delivery. */
@RestController
public class TransferLedgerProofController {
  private static final String FIND_PROOF =
      """
      SELECT t.id, t.status, t.source_account_id, t.destination_account_id, t.amount, t.unit,
             l.id AS entry_id, l.account_id, l.delta
      FROM transfers t
      LEFT JOIN LATERAL (
        SELECT id, account_id, delta FROM ledger_entries
        WHERE transfer_id = t.id ORDER BY account_id LIMIT 3
      ) l ON true
      WHERE t.id = ? AND t.status IN ('COMPLETED', 'REJECTED')
      ORDER BY l.account_id
      """;

  private final JdbcTemplate jdbc;
  private final TransactionTemplate read;

  public TransferLedgerProofController(
      JdbcTemplate jdbc, PlatformTransactionManager manager, TransferSettings settings) {
    this.jdbc = jdbc;
    read = new TransactionTemplate(manager);
    read.setReadOnly(true);
    read.setTimeout(settings.transactionTimeoutSeconds());
  }

  public enum ProofState {
    BALANCED_PAIR,
    NO_POSTINGS,
    INCONSISTENT
  }

  public record Posting(String entryId, UUID accountId, long delta) {}

  public record LedgerProof(
      UUID transferId,
      TransferStatus transferStatus,
      UUID sourceAccountId,
      UUID destinationAccountId,
      long amount,
      String unit,
      ProofState proofState,
      List<Posting> postings) {
    public LedgerProof {
      postings = List.copyOf(postings);
    }
  }

  private record ProofRow(
      UUID transferId,
      TransferStatus transferStatus,
      UUID sourceAccountId,
      UUID destinationAccountId,
      long amount,
      String unit,
      Posting posting) {}

  @GetMapping(
      value = "/internal/transfers/{id}/ledger-proof",
      produces = MediaType.APPLICATION_JSON_VALUE)
  public ResponseEntity<LedgerProof> inspect(@PathVariable UUID id) {
    var proof =
        read.execute(
            transaction -> {
              // One SELECT sees one PostgreSQL snapshot. The existing unique index on
              // (transfer_id, account_id) supports the ordered, capped point probe.
              var rows = jdbc.query(FIND_PROOF, (row, index) -> mapRow(row), id);
              if (rows.isEmpty()) {
                throw new ApiException(404, "TRANSFER_NOT_FOUND", "Transfer does not exist");
              }
              var transfer = rows.getFirst();
              var postings =
                  rows.stream().map(ProofRow::posting).filter(Objects::nonNull).toList();
              return new LedgerProof(
                  transfer.transferId(),
                  transfer.transferStatus(),
                  transfer.sourceAccountId(),
                  transfer.destinationAccountId(),
                  transfer.amount(),
                  transfer.unit(),
                  proofState(transfer, postings),
                  postings);
            });
    return ResponseEntity.ok().cacheControl(CacheControl.noStore()).body(proof);
  }

  private static ProofRow mapRow(ResultSet row) throws SQLException {
    String entryId = row.getString("entry_id");
    var posting =
        entryId == null
            ? null
            : new Posting(
                entryId, row.getObject("account_id", UUID.class), row.getLong("delta"));
    return new ProofRow(
        row.getObject("id", UUID.class),
        TransferStatus.valueOf(row.getString("status")),
        row.getObject("source_account_id", UUID.class),
        row.getObject("destination_account_id", UUID.class),
        row.getLong("amount"),
        row.getString("unit"),
        posting);
  }

  private static ProofState proofState(ProofRow transfer, List<Posting> postings) {
    if (transfer.transferStatus() == TransferStatus.REJECTED) {
      return postings.isEmpty() ? ProofState.NO_POSTINGS : ProofState.INCONSISTENT;
    }
    // The sample is capped at three, not an export of a potentially corrupt journal.
    // Seeing a third posting is enough to reject an exact two-posting proof.
    if (postings.size() != 2
        || transfer.amount() < 1
        || transfer.amount() > TransferCommand.MAX_AMOUNT
        || !"FIC".equals(transfer.unit())
        || transfer.sourceAccountId().equals(transfer.destinationAccountId())) {
      return ProofState.INCONSISTENT;
    }
    boolean source = false;
    boolean destination = false;
    for (var posting : postings) {
      if (transfer.sourceAccountId().equals(posting.accountId())
          && posting.delta() == -transfer.amount()) {
        source = true;
      } else if (transfer.destinationAccountId().equals(posting.accountId())
          && posting.delta() == transfer.amount()) {
        destination = true;
      } else {
        return ProofState.INCONSISTENT;
      }
    }
    return source && destination ? ProofState.BALANCED_PAIR : ProofState.INCONSISTENT;
  }
}
