# ADR 003: Local runtime and reproducible benchmarks

Status: accepted

## Decision

Use one Java 21 application and PostgreSQL 17.11 in Docker Compose. Build with the official Maven Wrapper 3.3.4 and Maven 3.9.16, whose downloaded archive is checked against the pinned SHA-256 checksum. The checksum was independently checked against Apache's published SHA-512 checksum. The runtime image uses the Java 21 JRE and an unprivileged operating-system user. Both published ports bind to loopback.

PostgreSQL's local `tpp` owner runs migrations and controlled fixture SQL. A separate `tpp_app` role receives the limited grants defined by Flyway for application operations. Database initialization creates this role once for a fresh volume; changing password environment variables does not rotate an existing role's password. Compose waits for database health before application startup, and application readiness includes database health. GitHub Actions builds and verifies on Java 21 with real PostgreSQL tests and builds the runtime image; actions are pinned to immutable commits.

Use a small Python standard-library HTTP benchmark with independent account pairs and a shared-source comparison. Fresh fixture accounts use a distinct UUID namespace. Funding creates ordinary balanced issuance transfers using owner SQL, without resetting existing balances or exposing a mint endpoint. Save workload counts, nearest-rank latency percentiles, actuator metric deltas, pool gauges, periodic PostgreSQL lock snapshots, and reconciliation evidence.

## Rationale

Compose provides a reproducible local dependency without introducing a monitoring platform or orchestration layer. Separating migration and runtime credentials makes the intended database privilege boundary inspectable. A checksum-pinned wrapper removes dependence on a developer's installed Maven version. An unprivileged application container reduces unnecessary local runtime privilege.

A closed-loop benchmark is small enough to inspect and reproduce while exercising the real HTTP and database path. Separate datasets make account contention explicit. SQL fixtures preserve ledger semantics and leave previous runs intact. Reconciliation around each measured workload makes correctness evidence part of the report.

## Consequences

The Compose passwords are development defaults; owner access can bypass the intended application threat model. Database roles are initialized only for a fresh volume. Base container tags pin a major/minor PostgreSQL release and Java major, but their image digests are not pinned, so an OS image rebuild can change the exact runtime image. No deployment is implied.

The benchmark is closed-loop and reports achieved throughput. It cannot characterize unlimited offered load, production infrastructure, or client arrival distributions. PostgreSQL snapshots can miss short lock waits, and actuator counters are process-wide. Hardware/Docker allocation and configuration changes must be recorded in environment notes. Actual benchmark reports provide measured evidence; no result is assumed by this decision. See [benchmark methodology](../benchmark-methodology.md) for commands and measurement definitions.
