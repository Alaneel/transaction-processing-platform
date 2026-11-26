# Security posture

This is an educational fictional-value system, not a service ready for public financial traffic. The 0.2.x code and local demo are the active demonstration scope; no production security support or response SLA is promised.

Compose binds its published ports to `127.0.0.1`. HTTP APIs, Actuator metrics, reconciliation, outbox requeue and quarantine replay have no authentication or authorization. The single Kafka broker uses plaintext listeners. Do not publish these interfaces to an untrusted network.

`local-owner-password` and `local-app-password` are deliberately public local-development defaults, not real credentials. Use dedicated local values through `MIGRATION_PASSWORD` and `DB_PASSWORD` if necessary. Initial role/password setup applies only to a fresh database volume. Never reuse these defaults outside the local fixture. Environment files and key material must remain untracked.

The application uses the restricted `tpp_app` database role. Migrations and controlled issuance fixtures use the privileged owner separately. [The role probe](scripts/verify-runtime-role.sql) checks selected restrictions; it is not a complete privilege audit. A database owner can bypass immutability guards and constraints.

Security-relevant limits include no tenant isolation, TLS setup, automated backup/restore, archive policy, projection rebuild after Kafka retention loss, multi-broker durability validation or database failover validation. Poison records retain bounded raw payload evidence in PostgreSQL; operator logs and replay records may contain sensitive material if the system is fed nonfixture inputs. Use fictional fixtures only.

For a suspected vulnerability, prepare a minimal sanitized report with affected revision, trigger and observed impact. Use GitHub private vulnerability reporting if the eventual repository enables it. A private disclosure channel has not yet been configured; do not put credentials or exploitable sensitive data in a public issue. [Release preparation](docs/release.md) includes configuring a real contact or private reporting before publication.
