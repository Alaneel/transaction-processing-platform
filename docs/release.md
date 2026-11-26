# Local release preparation

The final trusted-local candidate passed the functional and measured-effect gates in [release verification](verification/release-readiness.json). [Dependency assessment](dependency-security.md) records remaining test-tool risks, unverified helper coverage and host/architecture limits. This status does not imply public visibility, a push, a GitHub release or hosted CI success. The artifact remains version 0.2.0; no release tag is created.

## Prepared and verified

- Clear overview, architecture SVG/Mermaid, evidence-backed historical benchmark graph/data, walkthrough, code map and guided demo.
- Complete detailed operations reference; historical 28 trials, negative results and 188,884-event acceptance preserved unchanged.
- Minimal compatible runtime/build dependency and native package patches, immutable base/action pins, source/checksum provenance and retained upstream notices.
- **104/104 Java checks**: original 34 unit and 60 real PostgreSQL/Kafka checks, plus ten preconnection local-Docker guards; zero failures/errors/skips. Subsequent build-only Snappy patch passed actual-plugin/static verification; unchanged backend/test assertions were not rerun solely for that tool change.
- **37 Python checks** for benchmark bookkeeping, ownership, local endpoint, safe report I/O and timing guards. One initial short scheduler-fixture failure is retained; the unchanged full rerun passed without relaxed assertions.
- Final normal and owned broker-outage/recovery demos passed on exact patched application/PostgreSQL/Kafka images. The same application survived the outage; the original event recovered with one inbox and two balanced activity rows.
- Four new final-server ABBA trials reconciled **28,065 scoped events**: 27,478 measured plus 587 completed warmup. Thirteen scheduled warmup arrivals were locally shed in the first trial. All clock, ledger, event and committed-offset checks passed. The earlier 39,751-event comparison remains separately documented with unverified complete host timing.
- Local offline image audits bind exact image IDs and database hashes. Application/Kafka packages and 134 actually loaded build-plugin jars have zero matched records; PostgreSQL's Windows-only UNKNOWN record is not affected for the exact Linux helper. Shaded Docker HTTP findings remain constrained test-tool risks; the optional startup helper has one MEDIUM match and Ryuk binary coverage is not verified.
- Guarded cleanup stopped only the owned project's containers and retained both database/broker history volumes. All 42 production files and 203 historical evidence files remain byte-identical; no original checkout, history or remote was changed.

## Before publishing

1. Match delivered executable inputs to the fingerprint in [release verification](verification/release-readiness.json). Rerun appropriate gates after a material backend/dependency change. Retain raw failures and separate older populations rather than relabeling them.
2. Review all proposed files/history for secrets, personal paths, evidence size and license obligations. Raw local logs need review before sharing; preserved historical reports may contain environment paths. Keep private originals while preparing any sanitized public export.
3. Keep a trusted local Unix Docker daemon and loopback fixture ports. Reassess vendor-shaded HTTP fixes before permitting remote/untrusted Docker, and review optional helper exposure. Validate a current intended host/runtime separately; Engine 24.0.6 is not a whole-system clean result.
4. Run the intended target architecture and hosted CI after an authorized push. Only Linux arm64 was exercised locally; multiarch build inputs and configured CI are not execution evidence.
5. Confirm repository owner/name/description/topics, contact and private vulnerability-reporting settings. **Obtain explicit owner approval before push, visibility/settings changes or publication.** These remote actions remain unapplied.

## Suggested release copy

**Title:** Transaction Processing Platform — local engineering showcase

**Description:** A Java/PostgreSQL/Kafka educational ledger with immutable double-entry history, a transactional outbox, bounded fenced publication and a durable consumer inbox. The local candidate provides reproducible demos, code navigation and retained failure/performance evidence. Its 104 Java checks and both final guarded demos passed. Four finite final-server dependency trials reconciled 28,065 scoped effects with validated clock observations. Historical optimization results and negative findings remain unchanged. The system uses fictional value and documents residual test-tool, deployment, durability and retention limits.

Suggested topics: `java`, `postgresql`, `kafka`, `transactional-outbox`, `idempotency`, `double-entry-ledger`, `distributed-systems`, `fault-injection`. They are proposals, not applied remote settings.
