# Release and verification

## v0.2.4

Recent transfers discovers committed and rejected decisions between the two fictional demo accounts. Inspect a result without entering an ID, follow pending publication and projection for up to 60 seconds, and download observations without a recovery key, account IDs or local endpoint. The bounded browser follow loop is read-only.

The V4 migration adds the partial index for the terminal-history query, with no financial-row rewrite. Local verification retained the existing database and reconciled real broker recovery. [Quick start](../README.md#run-the-demo) · [History acceptance](verification/recent-transfers.json) · [Delivery follow acceptance](verification/delivery-follow.json)

## v0.2.3

Transfer Lab can show the signed immutable postings for a single transfer ID and move a private receipt to another browser session. Import only saves the original intent. Explicit recovery reuses its key and payload against the same local URL and retained database. Delivery and the financial postings are read independently, so missing or delayed event state does not erase the ledger evidence.

The browser verifier closes the original session after a real post-commit response loss, imports without submitting from a fresh session, and checks the original postings again after an HTTP 200 replay. [Quick start](../README.md#run-the-demo) · [Portable receipt acceptance](verification/portable-receipt.json) · [Ledger proof acceptance](verification/ledger-proof.json)

## v0.2.2

Transfer Lab brings transfer submission, receipt recovery and transfer-ID delivery lookup together in a browser. After startup, the full walkthrough uses buttons, including an opt-in loss of the response to a real committed transfer. Reload the page and recover the original result with the saved receipt. Delivery lookup shows recorded publication and committed activity independently of the financial decision.

The release adds a real Chrome check to CI, alongside the existing Java, Python, broker-outage and CLI checks. [Quick start](../README.md#run-the-demo) · [Browser walkthrough](demo.md#try-the-browser-demo) · [Local acceptance](verification/browser-demo.json)

## v0.2.1

The receipt-based CLI saves the endpoint, idempotency key and transfer payload before its first request. `resume` reuses that intent after a lost response. `status` reads the financial decision, publication and projection by transfer ID. The release workflow exercises both against real PostgreSQL and Kafka. [Quick start](../README.md#run-the-demo) · [Delivery states](operations.md#transfer-delivery-progress)

## v0.2.0

[`v0.2.0`](https://github.com/Alaneel/transaction-processing-platform/releases/tag/v0.2.0) was publicly released on 26 November 2026 from commit `67c91da9c8a1c72cc19921290ce80105aebe03f1`. The [Linux amd64 hosted run](https://github.com/Alaneel/transaction-processing-platform/actions/runs/45825298166) passed all 104 tests, static and dependency checks, the image build, and normal and broker-outage demos. The same source passed local rebuilt Linux arm64 demos. [Public release evidence](verification/public-release-2026-11-26.json) records the exact version, both retained failed attempts and anonymous verification of the final public tag.

## October preparation record

**Historical preparation and public source.** The October results below apply to their recorded local candidate. Before the first public release, a clean GitHub runner exposed two issues: cold image construction consumed the migration test's own time budget, and upstream removed exact Alpine APK URLs. The public build separates fixture setup from the test deadline and [refreshes signed, checksum-pinned APKs](verification/public-alpine-refresh.json) for both architectures. The upstream archive can replace APK revisions again, and content hashes do not retain upstream files. Refresh and verify the lock if a new cold build reports an unavailable APK.

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
