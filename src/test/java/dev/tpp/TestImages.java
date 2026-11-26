package dev.tpp;

import java.io.IOException;
import java.nio.channels.Channels;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HexFormat;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Set;
import org.testcontainers.DockerClientFactory;
import org.testcontainers.images.builder.ImageFromDockerfile;
import org.testcontainers.images.builder.Transferable;
import org.testcontainers.utility.DockerImageName;

/** Builds reviewed server derivatives from an explicit public-file context, never the checkout. */
final class TestImages {
  private TestImages() {}

  static DockerImageName postgres() { return Postgres.IMAGE; }
  static DockerImageName kafka() { return Kafka.IMAGE; }

  private static final class Kafka {
    private static final DockerImageName IMAGE = build("kafka", Path.of("docker"), "kafka.Dockerfile",
        List.of("alpine-packages.lock", "install-alpine-patches.sh", "kafka-libraries.lock",
            "update-kafka-libraries.sh"), "apache/kafka");
  }

  private static final class Postgres {
    private static final DockerImageName IMAGE = build("postgres", Path.of("docker/postgres"), "Dockerfile",
        List.of("gosu/go.mod", "gosu/go.sum", "gosu/main.go", "gosu/setup-user.go", "gosu/version.go",
            "gosu/security_test.go", "user-fixture/user_test.go", "user-fixture/provenance.json",
            "licenses/gosu-LICENSE", "licenses/user-LICENSE", "licenses/sys-LICENSE", "licenses/sys-PATENTS"),
        "postgres");
  }

  private static DockerImageName build(String server, Path root, String dockerfile,
      List<String> inputs, String compatibility) {
    TestDockerBoundary.configure();
    try {
      var files = new LinkedHashMap<String, byte[]>();
      files.put("Dockerfile", checkedBytes(root.resolve(dockerfile)));
      for (String input : inputs) files.put(input, checkedBytes(root.resolve(input)));
      MessageDigest hash = MessageDigest.getInstance("SHA-256");
      files.forEach((name, bytes) -> {
        hash.update(name.getBytes(StandardCharsets.UTF_8));
        hash.update((byte) 0);
        hash.update(bytes);
        hash.update((byte) 0);
      });
      String fingerprint = HexFormat.of().formatHex(hash.digest());
      String tag = "tpp-test-" + server + ":" + fingerprint.substring(0, 24);
      var image = new ImageFromDockerfile(tag, false);
      files.forEach((name, bytes) -> image.withFileFromTransferable(name, Transferable.of(bytes)));
      // The SDK uses the classic daemon build API. Explicit architecture also works with BuildKit.
      String architecture = DockerClientFactory.instance().client().infoCmd().exec().getArchitecture();
      String target = switch (architecture) {
        case "aarch64", "arm64" -> "arm64";
        case "x86_64", "amd64" -> "amd64";
        default -> throw new IllegalStateException("No reviewed package pins for " + architecture);
      };
      image.withBuildArg("TARGETARCH", target);
      String resolved = image.get();
      String id = DockerClientFactory.instance().client().inspectImageCmd(resolved).exec().getId();
      System.out.println("TestImages server=" + server + " contextSha256=" + fingerprint
          + " imageId=" + id + " contextFiles=" + files.keySet());
      return DockerImageName.parse(resolved).asCompatibleSubstituteFor(compatibility);
    } catch (IOException | NoSuchAlgorithmException failure) {
      throw new IllegalStateException("Cannot read the explicit " + server + " test image inputs", failure);
    }
  }

  private static byte[] checkedBytes(Path file) throws IOException {
    for (Path ancestor = file; ancestor != null; ancestor = ancestor.getParent())
      if (Files.isSymbolicLink(ancestor)) throw new IOException("Symlink image input: " + file);
    if (!Files.isRegularFile(file, LinkOption.NOFOLLOW_LINKS))
      throw new IOException("Missing regular image input: " + file);
    try (var channel = Files.newByteChannel(file,
        Set.of(StandardOpenOption.READ, LinkOption.NOFOLLOW_LINKS));
        var input = Channels.newInputStream(channel)) {
      if (channel.size() > 1024 * 1024) throw new IOException("Unexpectedly large image input: " + file);
      return input.readAllBytes();
    }
  }
}
