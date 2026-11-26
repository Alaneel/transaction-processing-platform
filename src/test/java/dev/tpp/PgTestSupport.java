package dev.tpp;

import com.jayway.jsonpath.JsonPath;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.Callable;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.context.ConfigurableApplicationContext;
import org.testcontainers.postgresql.PostgreSQLContainer;

/** Real PostgreSQL and real HTTP; a missing database is a test failure, never a skipped test. */
final class PgTestSupport implements AutoCloseable {
  private final PostgreSQLContainer container;
  private final String adminUrl;
  private final String username;
  private final String password;
  private final String database = "tpp_test_" + UUID.randomUUID().toString().replace("-", "");
  private final List<ConfigurableApplicationContext> applications = new ArrayList<>();
  private final HttpClient client =
      HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(10)).build();
  final String url;

  /** Separate logical databases can share a suite-owned container without sharing test state. */
  PgTestSupport(String adminUrl, String username, String password) throws SQLException {
    this.container = null;
    this.adminUrl = adminUrl;
    this.username = username;
    this.password = password;
    try (Connection connection = DriverManager.getConnection(adminUrl, username, password);
        Statement statement = connection.createStatement()) {
      statement.execute("CREATE DATABASE " + database);
    }
    int query = adminUrl.indexOf('?');
    String base = query < 0 ? adminUrl : adminUrl.substring(0, query);
    url = base.substring(0, base.lastIndexOf('/') + 1) + database
        + (query < 0 ? "" : adminUrl.substring(query));
  }

  PgTestSupport() throws SQLException {
    String explicitUrl = System.getenv("TPP_TEST_DB_URL");
    if (explicitUrl == null || explicitUrl.isBlank()) {
      container =
          new PostgreSQLContainer(TestImages.postgres()).withImagePullPolicy(image -> false)
              .withDatabaseName("tpp_tests")
              .withUsername("tpp")
              .withPassword("tpp");
      container.start();
      adminUrl = container.getJdbcUrl();
      username = container.getUsername();
      password = container.getPassword();
    } else {
      container = null;
      adminUrl = explicitUrl;
      username = System.getenv().getOrDefault("TPP_TEST_DB_USER", "tpp");
      password = System.getenv().getOrDefault("TPP_TEST_DB_PASSWORD", "tpp");
    }
    try (Connection connection = DriverManager.getConnection(adminUrl, username, password);
        Statement statement = connection.createStatement()) {
      statement.execute("CREATE DATABASE " + database);
    }
    int query = adminUrl.indexOf('?');
    String base = query < 0 ? adminUrl : adminUrl.substring(0, query);
    url =
        base.substring(0, base.lastIndexOf('/') + 1)
            + database
            + (query < 0 ? "" : adminUrl.substring(query));
  }

  Application start(Class<?> source, Map<String, Object> overrides, Class<?>... extraSources) {
    var properties = new java.util.HashMap<String, Object>();
    properties.put("server.port", "0");
    properties.put("spring.datasource.url", url);
    properties.put("spring.datasource.username", username);
    properties.put("spring.datasource.password", password);
    properties.put("spring.flyway.user", username);
    properties.put("spring.flyway.password", password);
    properties.put("spring.datasource.hikari.maximum-pool-size", "16");
    properties.put("spring.datasource.hikari.connection-timeout", "2000");
    properties.put("spring.flyway.default-schema", "public");
    properties.put("spring.flyway.schemas", "public");
    properties.put("spring.main.banner-mode", "off");
    properties.put("logging.level.root", "WARN");
    properties.putAll(overrides);
    String[] arguments =
        properties.entrySet().stream()
            .map(entry -> "--" + entry.getKey() + "=" + entry.getValue())
            .toArray(String[]::new);
    ConfigurableApplicationContext context =
        new SpringApplicationBuilder(source).sources(extraSources).run(arguments);
    applications.add(context);
    int port = context.getEnvironment().getRequiredProperty("local.server.port", Integer.class);
    return new Application(context, "http://127.0.0.1:" + port);
  }

  Connection connect() throws SQLException {
    return DriverManager.getConnection(url, username, password);
  }

  void execute(String sql, Object... parameters) throws SQLException {
    try (Connection connection = connect();
        PreparedStatement statement = connection.prepareStatement(sql)) {
      bind(statement, parameters);
      statement.execute();
    }
  }

  long scalar(String sql, Object... parameters) throws SQLException {
    try (Connection connection = connect();
        PreparedStatement statement = connection.prepareStatement(sql)) {
      bind(statement, parameters);
      try (ResultSet result = statement.executeQuery()) {
        if (!result.next()) throw new AssertionError("Query returned no rows: " + sql);
        return result.getLong(1);
      }
    }
  }

  static void bind(PreparedStatement statement, Object... parameters) throws SQLException {
    for (int index = 0; index < parameters.length; index++)
      statement.setObject(index + 1, parameters[index]);
  }

  Response get(Application app, String path) throws Exception {
    return request(app, "GET", path, null, null);
  }

  Response post(Application app, String path, String body, String key) throws Exception {
    return request(app, "POST", path, body, key);
  }

  Response request(Application app, String method, String path, String body, String key)
      throws Exception {
    var builder =
        HttpRequest.newBuilder(URI.create(app.baseUrl + path))
            .timeout(Duration.ofSeconds(30))
            .header("Content-Type", "application/json");
    if (key != null) builder.header("Idempotency-Key", key);
    builder.method(
        method,
        body == null
            ? HttpRequest.BodyPublishers.noBody()
            : HttpRequest.BodyPublishers.ofString(body));
    HttpResponse<String> response =
        client.send(builder.build(), HttpResponse.BodyHandlers.ofString());
    return new Response(response.statusCode(), response.body(), response.headers());
  }

  static String transfer(UUID source, UUID destination, long amount) {
    return "{\"sourceAccountId\":\""
        + source
        + "\",\"destinationAccountId\":\""
        + destination
        + "\",\"amount\":"
        + amount
        + ",\"unit\":\"FIC\"}";
  }

  static <T> List<T> concurrently(List<Callable<T>> tasks) throws Exception {
    CountDownLatch ready = new CountDownLatch(tasks.size());
    CountDownLatch release = new CountDownLatch(1);
    try (var executor = Executors.newFixedThreadPool(tasks.size())) {
      var futures =
          tasks.stream()
              .map(
                  task ->
                      executor.submit(
                          () -> {
                            ready.countDown();
                            if (!release.await(10, TimeUnit.SECONDS))
                              throw new AssertionError("Concurrency barrier timed out");
                            return task.call();
                          }))
              .toList();
      if (!ready.await(10, TimeUnit.SECONDS))
        throw new AssertionError("Workers never reached barrier");
      release.countDown();
      var results = new ArrayList<T>();
      for (var future : futures) results.add(future.get(60, TimeUnit.SECONDS));
      return results;
    } finally {
      release.countDown();
    }
  }

  @Override
  public void close() throws SQLException {
    for (var application : applications) application.close();
    try (Connection connection = DriverManager.getConnection(adminUrl, username, password);
        Statement statement = connection.createStatement()) {
      statement.execute("DROP DATABASE " + database + " WITH (FORCE)");
    } finally {
      if (container != null) container.stop();
    }
  }

  record Application(ConfigurableApplicationContext context, String baseUrl)
      implements AutoCloseable {
    @Override
    public void close() {
      context.close();
    }
  }

  record Response(int status, String body, java.net.http.HttpHeaders headers) {
    <T> T json(String path) {
      return JsonPath.read(body, path);
    }

    UUID id() {
      return UUID.fromString(json("$.id"));
    }
  }
}
