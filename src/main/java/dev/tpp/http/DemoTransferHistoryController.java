package dev.tpp.http;

import dev.tpp.application.DatabaseErrors;
import dev.tpp.application.TransferSettings;
import dev.tpp.domain.ApiException;
import dev.tpp.domain.TransferStatus;
import java.nio.ByteBuffer;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.DateTimeException;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Objects;
import java.util.UUID;
import org.springframework.dao.DataAccessException;
import org.springframework.http.CacheControl;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/** A bounded discovery page for the two fixed fictional demo accounts. */
@RestController
public class DemoTransferHistoryController {
  private static final UUID ALICE = UUID.fromString("00000000-0000-0000-0000-000000000002");
  private static final UUID BOB = UUID.fromString("00000000-0000-0000-0000-000000000003");
  private static final int CURSOR_BYTES = 29;
  private static final String DIRECTION_WHERE =
      """
      SELECT id AS transfer_id, status AS transfer_status, source_account_id,
             destination_account_id, amount, unit, completed_at AS decided_at, rejection_code
      FROM transfers
      WHERE source_account_id = ? AND destination_account_id = ?
        AND status IN ('COMPLETED', 'REJECTED')
      """;
  private static final String DIRECTION_ORDER =
      """
      ORDER BY completed_at DESC, id DESC
      LIMIT ?
      """;
  private static final String FIRST_DIRECTION = DIRECTION_WHERE + DIRECTION_ORDER;
  private static final String BEFORE_DIRECTION =
      DIRECTION_WHERE + "  AND (completed_at, id) < (?, ?)\n" + DIRECTION_ORDER;
  private static final String PAGE_START = "SELECT * FROM ((";
  private static final String PAGE_UNION = ") UNION ALL (";
  private static final String PAGE_END =
      ")) AS demo_history ORDER BY decided_at DESC, transfer_id DESC LIMIT ?";
  private static final String FIRST_PAGE =
      PAGE_START + FIRST_DIRECTION + PAGE_UNION + FIRST_DIRECTION + PAGE_END;
  private static final String BEFORE_PAGE =
      PAGE_START + BEFORE_DIRECTION + PAGE_UNION + BEFORE_DIRECTION + PAGE_END;

  private final JdbcTemplate jdbc;
  private final TransactionTemplate read;

  public DemoTransferHistoryController(
      JdbcTemplate jdbc, PlatformTransactionManager manager, TransferSettings settings) {
    this.jdbc = jdbc;
    read = new TransactionTemplate(manager);
    read.setReadOnly(true);
    read.setTimeout(settings.transactionTimeoutSeconds());
  }

  public record HistoryItem(
      UUID transferId,
      TransferStatus transferStatus,
      UUID sourceAccountId,
      UUID destinationAccountId,
      long amount,
      String unit,
      Instant decidedAt,
      String rejectionCode) {}

  public record History(List<HistoryItem> items, String nextBefore) {
    public History {
      items = List.copyOf(items);
    }
  }

  private record Before(Instant decidedAt, UUID transferId) {}

  @GetMapping(value = "/internal/demo/transfers", produces = MediaType.APPLICATION_JSON_VALUE)
  public ResponseEntity<History> inspect(
      @RequestParam(defaultValue = "6") int limit, @RequestParam(required = false) String before) {
    if (limit < 1 || limit > 20) {
      throw new ApiException(400, "INVALID_REQUEST", "limit must be between 1 and 20");
    }
    var cursor = before == null ? null : decode(before);
    History page;
    try {
      page = Objects.requireNonNull(read.execute(transaction -> findPage(limit, cursor)));
    } catch (DataAccessException error) {
      // A canonical token can still encode a timestamp outside PostgreSQL's range.
      // Keep that cursor error distinct from dependency/timeout failures.
      if (cursor != null && "22008".equals(DatabaseErrors.sqlState(error))) {
        throw invalidCursor();
      }
      throw error;
    }
    return ResponseEntity.ok().cacheControl(CacheControl.noStore()).body(page);
  }

  private History findPage(int limit, Before cursor) {
    // Both fixed directions use the V4 index and stop after limit+1. UNION ALL
    // combines at most 42 rows before the same bounded final sort/limit.
    String query = cursor == null ? FIRST_PAGE : BEFORE_PAGE;
    var arguments = new ArrayList<Object>();
    addDirection(arguments, ALICE, BOB, cursor, limit + 1);
    addDirection(arguments, BOB, ALICE, cursor, limit + 1);
    arguments.add(limit + 1);
    var rows = jdbc.query(query, (row, index) -> mapRow(row), arguments.toArray());
    var items = rows.size() > limit ? rows.subList(0, limit) : rows;
    String next = rows.size() > limit ? encode(items.getLast()) : null;
    return new History(items, next);
  }

  private static void addDirection(
      List<Object> arguments, UUID source, UUID destination, Before cursor, int fetch) {
    arguments.add(source);
    arguments.add(destination);
    if (cursor != null) {
      arguments.add(OffsetDateTime.ofInstant(cursor.decidedAt(), ZoneOffset.UTC));
      arguments.add(cursor.transferId());
    }
    arguments.add(fetch);
  }

  private static HistoryItem mapRow(ResultSet row) throws SQLException {
    return new HistoryItem(
        row.getObject("transfer_id", UUID.class),
        TransferStatus.valueOf(row.getString("transfer_status")),
        row.getObject("source_account_id", UUID.class),
        row.getObject("destination_account_id", UUID.class),
        row.getLong("amount"),
        row.getString("unit"),
        row.getTimestamp("decided_at").toInstant(),
        row.getString("rejection_code"));
  }

  private static String encode(HistoryItem item) {
    var bytes = ByteBuffer.allocate(CURSOR_BYTES);
    bytes.put((byte) 1).putLong(item.decidedAt().getEpochSecond()).putInt(item.decidedAt().getNano());
    bytes.putLong(item.transferId().getMostSignificantBits());
    bytes.putLong(item.transferId().getLeastSignificantBits());
    return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes.array());
  }

  private static Before decode(String value) {
    if (!value.matches("[A-Za-z0-9_-]{39}")) throw invalidCursor();
    try {
      byte[] decoded = Base64.getUrlDecoder().decode(value);
      if (decoded.length != CURSOR_BYTES
          || !Base64.getUrlEncoder().withoutPadding().encodeToString(decoded).equals(value)) {
        throw invalidCursor();
      }
      var bytes = ByteBuffer.wrap(decoded);
      if (bytes.get() != 1) throw invalidCursor();
      long seconds = bytes.getLong();
      int nanos = bytes.getInt();
      if (nanos < 0 || nanos >= 1_000_000_000 || nanos % 1000 != 0) throw invalidCursor();
      var instant = Instant.ofEpochSecond(seconds, nanos);
      // Reject Java calendar overflow before binding the cursor to PostgreSQL.
      OffsetDateTime.ofInstant(instant, ZoneOffset.UTC);
      return new Before(instant, new UUID(bytes.getLong(), bytes.getLong()));
    } catch (IllegalArgumentException | DateTimeException error) {
      throw invalidCursor();
    }
  }

  private static ApiException invalidCursor() {
    return new ApiException(400, "INVALID_REQUEST", "before cursor is invalid");
  }
}
