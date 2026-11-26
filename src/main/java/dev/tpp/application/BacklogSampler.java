package dev.tpp.application;

import java.util.Objects;
import org.springframework.jdbc.core.ConnectionCallback;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

/** One time-bounded statement samples publication and consumption pressure together. */
@Repository
public class BacklogSampler {
  private final JdbcTemplate jdbc;
  private final BackpressureSettings settings;

  public BacklogSampler(JdbcTemplate jdbc, BackpressureSettings settings) {
    this.jdbc = jdbc;
    this.settings = settings;
  }

  public record Pressure(
      long unpublished,
      double oldestUnpublishedAgeSeconds,
      long publishedUnprocessed,
      double oldestPublishedUnprocessedAgeSeconds) {
    public Pressure {
      if (unpublished < 0
          || publishedUnprocessed < 0
          || !Double.isFinite(oldestUnpublishedAgeSeconds)
          || oldestUnpublishedAgeSeconds < 0
          || !Double.isFinite(oldestPublishedUnprocessedAgeSeconds)
          || oldestPublishedUnprocessedAgeSeconds < 0)
        throw new IllegalArgumentException("Invalid backlog sample");
    }
  }

  public Pressure sample() {
    return Objects.requireNonNull(
        jdbc.execute(
            (ConnectionCallback<Pressure>)
                connection -> {
                  try (var statement =
                      connection.prepareStatement(
                          """
                          SELECT count(*) FILTER(WHERE o.status<>'PUBLISHED') AS unpublished,
                            coalesce(greatest(0,extract(epoch FROM clock_timestamp()-min(o.created_at)
                              FILTER(WHERE o.status<>'PUBLISHED'))),0)::double precision AS unpublished_age,
                            count(*) FILTER(WHERE o.status='PUBLISHED' AND i.event_id IS NULL) AS published_unprocessed,
                            coalesce(greatest(0,extract(epoch FROM clock_timestamp()-min(o.created_at)
                              FILTER(WHERE o.status='PUBLISHED' AND i.event_id IS NULL))),0)::double precision AS published_age
                          FROM outbox_events o LEFT JOIN event_inbox i ON i.event_id=o.event_id
                          """)) {
                    statement.setQueryTimeout(settings.queryTimeoutSeconds());
                    try (var rows = statement.executeQuery()) {
                      if (!rows.next())
                        throw new IllegalStateException("Backlog query returned no row");
                      return new Pressure(
                          rows.getLong("unpublished"),
                          rows.getDouble("unpublished_age"),
                          rows.getLong("published_unprocessed"),
                          rows.getDouble("published_age"));
                    }
                  }
                }));
  }
}
