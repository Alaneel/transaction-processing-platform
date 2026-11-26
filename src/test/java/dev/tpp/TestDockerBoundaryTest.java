package dev.tpp;

import static org.junit.jupiter.api.Assertions.*;

import java.net.ServerSocket;
import java.net.SocketTimeoutException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

/** Actual separate-process image entry path must reject inherited remote settings before connect. */
class TestDockerBoundaryTest {
  @TempDir Path temporary;

  private String reject(Map<String, String> overrides, List<String> systemProperties) throws Exception {
    Path home = temporary.resolve("home");
    Files.createDirectories(home);
    var command = new ArrayList<String>(List.of(Path.of(System.getProperty("java.home"), "bin/java").toString(),
        "-Duser.home=" + home));
    command.addAll(systemProperties);
    command.addAll(List.of("-cp", System.getProperty("surefire.test.class.path", System.getProperty("java.class.path")),
        "dev.tpp.TestDockerBoundary", "kafka"));
    var builder = new ProcessBuilder(command).redirectErrorStream(true);
    for (String name : List.of("DOCKER_HOST", "DOCKER_CONTEXT", "DOCKER_TLS_VERIFY", "DOCKER_CERT_PATH",
        "DOCKER_MACHINE_NAME", "JAVA_TOOL_OPTIONS", "_JAVA_OPTIONS", "JDK_JAVA_OPTIONS")) builder.environment().remove(name);
    builder.environment().put("PATH", "/usr/bin:/bin:/usr/sbin:/sbin");
    builder.environment().putAll(overrides);
    var process = builder.start();
    boolean finished = process.waitFor(10, TimeUnit.SECONDS);
    if (!finished) process.destroyForcibly();
    assertTrue(finished, "guard must fail promptly without SDK probing/fallback");
    String output = new String(process.getInputStream().readAllBytes(), java.nio.charset.StandardCharsets.UTF_8);
    assertNotEquals(0, process.exitValue(), output);
    assertTrue(output.contains("refused") || output.contains("require a local Unix socket"), output);
    assertFalse(output.contains("TestImages server="), "no image may be built before refusal");
    return output;
  }

  @Test void tcpEnvironmentCannotConnectEvenToLoopback() throws Exception {
    try (var listener = new ServerSocket(0)) {
      listener.setSoTimeout(200);
      reject(Map.of("DOCKER_HOST", "tcp://127.0.0.1:" + listener.getLocalPort()), List.of());
      assertThrows(SocketTimeoutException.class, listener::accept, "zero network connections before refusal");
    }
  }

  @Test void sshHttpsAndUnixAuthorityEndpointsAreRejected() throws Exception {
    for (String endpoint : List.of("ssh://example.invalid", "https://example.invalid", "unix://example.invalid/run/docker.sock"))
      reject(Map.of("DOCKER_HOST", endpoint), List.of());
  }

  @Test void remoteSystemPropertyIsRejectedBeforeSdkAllocation() throws Exception {
    reject(Map.of(), List.of("-Ddocker.host=tcp://example.invalid:2375"));
  }

  @Test void remoteTestcontainersHomePropertyIsRejected() throws Exception {
    Path home = temporary.resolve("home"); Files.createDirectories(home);
    for (String key : List.of("docker.host", "tc.host")) {
      Files.writeString(home.resolve(".testcontainers.properties"), key + "=tcp://example.invalid:2375\n");
      reject(Map.of(), List.of());
    }
  }

  @Test void remoteDockerJavaHomePropertyIsRejected() throws Exception {
    Path home = temporary.resolve("home"); Files.createDirectories(home);
    Files.writeString(home.resolve(".docker-java.properties"), "docker.host=tcp://example.invalid:2375\n");
    reject(Map.of(), List.of());
  }

  @Test void inheritedContextTlsAndMachineAreRejected() throws Exception {
    for (var env : List.of(Map.of("DOCKER_CONTEXT", "foreign"), Map.of("DOCKER_TLS_VERIFY", "1"),
        Map.of("DOCKER_CERT_PATH", "/foreign"), Map.of("DOCKER_MACHINE_NAME", "foreign"),
        Map.of("TESTCONTAINERS_HOST_OVERRIDE", "foreign"))) reject(env, List.of());
  }

  @Test void unreviewedProviderStrategyIsRejected() throws Exception {
    Path home = temporary.resolve("home"); Files.createDirectories(home);
    Files.writeString(home.resolve(".testcontainers.properties"), "docker.client.strategy=untrusted.RemoteStrategy\n");
    reject(Map.of(), List.of());
  }


  @Test void installedDockerMachineFallbackIsRejected() throws Exception {
    Path bin = temporary.resolve("bin"); Files.createDirectories(bin);
    Path executable = bin.resolve("docker-machine"); Files.writeString(executable, "#!/bin/sh\nexit 99\n");
    assertTrue(executable.toFile().setExecutable(true, true));
    reject(Map.of("PATH", bin.toString()), List.of());
  }

  @Test void symlinkHomeConfigurationIsRejectedWithoutReadingItsTarget() throws Exception {
    Path home = temporary.resolve("home"); Files.createDirectories(home);
    Path target = temporary.resolve("outside"); Files.writeString(target, "sentinel-only-for-guard-test");
    Files.createSymbolicLink(home.resolve(".docker-java.properties"), target);
    reject(Map.of(), List.of());
    assertEquals("sentinel-only-for-guard-test", Files.readString(target));
  }

  @Test void unixEndpointSyntaxIsStrictAndRelativePathsFail() {
    assertEquals("/var/run/docker.sock", TestDockerBoundary.requireUnix("unix:///var/run/docker.sock").getPath());
    for (String endpoint : List.of("unix:relative", "unix:///socket?remote=yes", "unix:///socket#remote", "tcp://127.0.0.1:2375"))
      assertThrows(IllegalStateException.class, () -> TestDockerBoundary.requireUnix(endpoint));
  }
}
