# Reviewed local server images

The demo and real-dependency tests build these small derivatives locally. PostgreSQL stays on **17.11** and Kafka stays on **4.3.1**; entrypoints, storage formats, listener configuration, and single-node demo topology are retained. These are educational fixtures, not a production deployment template.

- `kafka.Dockerfile` keeps the immutable official JVM broker, updates 25 vulnerable-library jars on their existing supported branches, replaces its JRE with the same pinned Temurin 21.0.12.1+1 used by the application, and applies exact Alpine 3.24 package updates.
- `postgres/` contains the database/helper derivative and its own provenance and license files.
- `alpine-packages.lock` pins both reviewed Linux architectures' APK bytes. Installation verifies SHA-256 and retains Alpine's package-signature verification; no unsigned-package option is used.
- `kafka-libraries.lock` pins each replacement jar's SHA-512. `kafka-libraries.json` distinguishes publisher SHA-512 from SHA-512 calculated from a fetched HTTPS artifact that also matches the publisher's SHA-1. No cryptographic signature verification is claimed for those jars.

Original Kafka LICENSE/NOTICE files remain intact, replacement jars retain their embedded notices, and the copied Temurin JRE retains its `legal/` directory. No third-party jar or APK is checked into the repository. Upstream updates disappearing from public mirrors cause a build failure rather than a silent version substitution.

Only Linux arm64 and amd64 have reviewed pins; final local validation was on arm64. `TestImages` sends a fixed list of these public Dockerfile, lock, helper, and license inputs to the daemon, rather than the whole checkout. Its images are tagged by input-content hash. Compose uses these same Dockerfiles with narrow build contexts.

See [dependency-security](../docs/dependency-security.md) for advisory scope, actual scan results and unresolved gates. Scanner matches and a successful build do not establish vulnerability absence or production suitability.
