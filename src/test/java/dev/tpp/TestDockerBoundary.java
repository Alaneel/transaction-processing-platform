package dev.tpp;

import java.io.IOException;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.LinkOption;
import java.nio.file.StandardOpenOption;
import java.nio.channels.Channels;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import org.testcontainers.dockerclient.EnvironmentAndSystemPropertyClientProviderStrategy;
import org.testcontainers.utility.TestcontainersConfiguration;

/** Fail before SDK connection/allocation when inherited configuration can select a remote daemon. */
final class TestDockerBoundary {
  private static URI pinned;
  private static final Set<String> LOCAL_STRATEGIES = Set.of(
      "org.testcontainers.dockerclient.EnvironmentAndSystemPropertyClientProviderStrategy",
      "org.testcontainers.dockerclient.UnixSocketClientProviderStrategy",
      "org.testcontainers.dockerclient.DockerDesktopClientProviderStrategy",
      "org.testcontainers.dockerclient.RootlessDockerClientProviderStrategy");

  private TestDockerBoundary() {}

  static URI requireUnix(String value) {
    try {
      URI uri = URI.create(value);
      if (!"unix".equals(uri.getScheme()) || uri.getRawAuthority() != null
          || uri.getQuery() != null || uri.getFragment() != null
          || uri.getPath() == null || !Path.of(uri.getPath()).isAbsolute())
        throw new IllegalArgumentException();
      return uri;
    } catch (IllegalArgumentException failure) {
      throw new IllegalStateException("TPP Docker fixtures require a local Unix socket; remote/ambiguous endpoint refused");
    }
  }

  private static void inspectProperties(Properties properties) {
    String tcHost = properties.getProperty("tc.host");
    if (tcHost != null && !tcHost.isBlank())
      throw new IllegalStateException("tc.host override refused before SDK connection; use local Unix DOCKER_HOST");
    String host = properties.getProperty("docker.host");
    if (host != null && !host.isBlank()) requireUnix(host);
    String strategy = properties.getProperty("docker.client.strategy");
    if (strategy != null && !strategy.isBlank() && !LOCAL_STRATEGIES.contains(strategy))
      throw new IllegalStateException("Unreviewed Docker client strategy refused before SDK connection");
    for (String key : List.of("docker.cert.path", "docker.tls.verify")) {
      String value = properties.getProperty(key);
      if (value != null && !value.isBlank() && !value.equals("0") && !value.equalsIgnoreCase("false"))
        throw new IllegalStateException("Inherited Docker TLS configuration refused before SDK connection");
    }
  }


  private static boolean checkedUserFile(Path file) throws IOException {
    if (Files.isSymbolicLink(file)) throw new IOException("Symlink Docker configuration refused");
    if (!Files.exists(file, LinkOption.NOFOLLOW_LINKS)) return false;
    if (!Files.isRegularFile(file, LinkOption.NOFOLLOW_LINKS) || Files.size(file) > 65536)
      throw new IOException("Expected bounded regular Docker configuration");
    return true;
  }

  static synchronized URI configure() {
    if (pinned != null) return pinned;
    for (String key : List.of("DOCKER_CONTEXT", "DOCKER_MACHINE_NAME", "DOCKER_CERT_PATH", "TESTCONTAINERS_HOST_OVERRIDE"))
      if (System.getenv(key) != null && !System.getenv(key).isBlank())
        throw new IllegalStateException("Inherited remote Docker context/TLS/machine configuration refused before SDK connection");
    String tls = System.getenv("DOCKER_TLS_VERIFY");
    if (tls != null && !tls.isBlank() && !tls.equals("0") && !tls.equalsIgnoreCase("false"))
      throw new IllegalStateException("Inherited Docker TLS configuration refused before SDK connection");
    String explicit = System.getenv("DOCKER_HOST");
    if (explicit != null && !explicit.isBlank()) requireUnix(explicit);
    for (String directory : System.getenv().getOrDefault("PATH", "").split(java.io.File.pathSeparator))
      if (!directory.isBlank() && Files.isExecutable(Path.of(directory, "docker-machine")))
        throw new IllegalStateException("docker-machine fallback refused; use a local-only PATH for Docker fixtures");
    inspectProperties(System.getProperties());
    Properties dockerJava = new Properties();
    Path userConfig = Path.of(System.getProperty("user.home"), ".docker-java.properties");
    try {
      checkedUserFile(Path.of(System.getProperty("user.home"), ".testcontainers.properties"));
      if (checkedUserFile(userConfig)) try (var channel = Files.newByteChannel(userConfig,
          Set.of(StandardOpenOption.READ, LinkOption.NOFOLLOW_LINKS));
          var input = Channels.newInputStream(channel)) { dockerJava.load(input); }
    } catch (IOException failure) {
      throw new IllegalStateException("Cannot inspect inherited Docker Java configuration safely", failure);
    }
    inspectProperties(dockerJava);
    var config = TestcontainersConfiguration.getInstance(); // Reads configuration; allocates no client.
    inspectProperties(config.getUserProperties());
    inspectProperties(config.getClasspathProperties());
    String strategy = config.getDockerClientStrategyClassName();
    if (strategy != null && !strategy.isBlank() && !LOCAL_STRATEGIES.contains(strategy))
      throw new IllegalStateException("Unreviewed Docker client strategy refused before SDK connection");
    String configuredHost = config.getEnvVarOrUserProperty("docker.host", null);
    if (configuredHost != null && !configuredHost.isBlank()) requireUnix(configuredHost);
    URI resolved = new EnvironmentAndSystemPropertyClientProviderStrategy().getTransportConfig().getDockerHost();
    requireUnix(resolved.toString()); // Constructing this strategy reads config only; it does not ping.
    Path socket = Path.of(resolved.getPath());
    if (!Files.exists(socket) && (explicit == null || explicit.isBlank())) {
      for (Path candidate : List.of(Path.of(System.getProperty("user.home"), ".docker/run/docker.sock"),
          Path.of(System.getProperty("user.home"), ".docker/desktop/docker.sock")))
        if (Files.exists(candidate)) { socket = candidate; break; }
    }
    try {
      socket = socket.toRealPath();
      int mode = (Integer) Files.getAttribute(socket, "unix:mode");
      if ((mode & 0170000) != 0140000) throw new IOException("Expected Unix socket");
    } catch (IOException | UnsupportedOperationException failure) {
      throw new IllegalStateException("A real local Docker Unix socket is required before SDK connection", failure);
    }
    pinned = URI.create("unix://" + socket);
    // In-memory settings only. Force the non-persisting environment strategy ahead of safe fallbacks.
    System.setProperty("docker.host", pinned.toString());
    config.getUserProperties().setProperty("docker.host", pinned.toString());
    config.getUserProperties().setProperty("docker.client.strategy",
        "org.testcontainers.dockerclient.EnvironmentAndSystemPropertyClientProviderStrategy");
    System.out.println("TestDockerBoundary transport=local-unix endpoint=" + pinned);
    return pinned;
  }

  /** Separate-process guard probes call the actual lazy image path, never a mocked Docker runner. */
  public static void main(String[] arguments) {
    if (arguments.length == 1 && arguments[0].equals("kafka")) TestImages.kafka();
    else configure();
  }
}
