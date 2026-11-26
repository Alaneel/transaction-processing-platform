# Dependency and image security — 14 October 2026

**Historical assessment.** The scans and performance evidence below apply to the exact October images. The November public source refresh changed Alpine package inputs after upstream stopped serving the old URLs. Refer to the [published package pins](../docker/alpine-packages.lock) and [refresh evidence](verification/public-alpine-refresh.json) for those inputs. The October scan findings do not apply to rebuilt November images.

The release candidate preserves Spring Boot 4.1.1, Kafka 4.3.1, PostgreSQL 17.11 and all 42 production source files. Targeted application, build-tool and container patches replace known affected components without changing the financial or delivery algorithms. This assessment supports a trusted local fictional-data demonstration; it is not a claim that the whole system is vulnerability-free.

| Component | Previous | Release candidate |
|---|---|---|
| Embedded Tomcat | 11.0.24 | **11.0.27** |
| Jackson core/databind BOM | 3.1.5 | **3.1.7** |
| Kafka client LZ4 codec | 1.10.2 | **1.11.4** |
| Java build/runtime | Floating image tags / host Java 21+35 | **Temurin 21.0.12.1+1**, immutable image digests |
| Actual Maven plugin realms | Vulnerable Jackson/Plexus/Commons/Snappy resolutions | Explicit compatible plugin dependencies, including **iq80 Snappy 0.5** |
| Kafka broker libraries | Older Jackson 2.21, Jetty 12.0, Log4j 2.25, LZ4 and JLine | 25 exact same-branch patched jars; broker/protocol version retained |
| Native container packages | Affected libpng/zlib and selected Kafka base packages | Exact SHA256-pinned, officially signed APK packages |
| PostgreSQL privilege helper | gosu 1.19 with older compiler/user parser | Same upstream gosu source, Go 1.26.9 and bounded moby user parser 0.4.1 |

[Container sources and checksums](../docker/README.md), [PostgreSQL provenance](../docker/postgres/provenance.json), [runtime attribution](../THIRD_PARTY_NOTICES.md) and [image audit](verification/release-image-audit.json) make the changes reviewable. Maven jar replacements retain publisher bytes and embedded notices. Publisher checksums and locally recorded strong hashes are not a claim of verified jar signatures.

## Executed coverage

The approved exact-version OSV audit completed **122/122 Maven queries with zero version matches**, covering all 63 packaged runtime jars and the actual test classpath plus four direct build tools. That earlier query does not cover every isolated build-plugin realm or shaded dependency. Subsequent audits use local Trivy databases rather than exporting a dependency graph.

The final **104/104 Java checks** comprise the original 34 unit and 60 real PostgreSQL/Kafka integration checks, plus ten local-Docker boundary tests. There were no failures, errors or skips. Dependency convergence, released dependencies and SpotBugs passed. A later build-only Snappy override passed a separate actual-plugin/static verification; unchanged financial/integration assertions were not rerun solely for that tool dependency.

The final immutable app and Kafka images have **zero matched vulnerability records** in the analyzed OS and Java packages. Both actual integration server images were independently scanned. PostgreSQL has one **UNKNOWN** Windows-only `x/sys` record, classified **not affected for the exact Linux helper**, using the primary advisory's platform scope, unchanged Unix imports and real Linux build metadata. The stripped final binary does not provide a fresh function-symbol scan. All **134 actually loaded Maven plugin jars** were inventoried from debug execution, hashed and locally analyzed with zero matches; archived superseded cache jars are retained separately.

Trivy 0.75.0 ran offline with telemetry disabled, local image transport, empty config/ignore file and no severity suppression. Its vulnerability database was updated **14 October 2026, 07:11:52 UTC**; scan timestamps, image identities, package-analysis counts and database binding are recorded in the public audit. Scanner checksum verification does not imply cryptographic verification of its release signature. Exact archive inspection finds 63 app jars; the scanner recognizes 61 Java package records. These are different counts.

The fresh image analyzer does not recognize embedded `tomcat-embed-core`, `tomcat-embed-el` or `tomcat-embed-websocket` GAVs. Their actual **11.0.27 jar hashes** in the [runtime inventory](verification/release-final-runtime-inventories.json), the earlier exact-coordinate OSV audit and [primary fixed-version boundaries](https://tomcat.apache.org/security-11.html) support closure of the three original Tomcat advisory rows; the fresh zero-match image result is **not a new scan of these three GAVs**.

## Residual test-tool risks

`docker-java-transport-zerodep` 3.7.1, still the retrieved upstream version, shades affected HttpCore/HttpClient classes. They are absent from the application archive. A normal Maven override cannot replace shaded bytes.

| Record | Scanner severity / fixed upstream | Assessment of the actual Docker client |
|---|---|---|
| [CVE-2026-54399](https://www.cve.org/CVERecord?id=CVE-2026-54399) | HIGH; HttpCore 5.4.3 | HTTP/1 response parsing is present. A malicious local daemon remains a risk; remote transport is refused before SDK allocation. |
| [CVE-2026-54428](https://www.cve.org/CVERecord?id=CVE-2026-54428) | HIGH; HttpCore 5.4.3 | HTTP/2 HPACK classes are bundled, but the inspected transport uses the classic HTTP/1 API. This is bounded path inspection, not whole-JVM reachability proof. |
| [CVE-2026-64607](https://www.cve.org/CVERecord?id=CVE-2026-64607) | MEDIUM; HttpClient 5.6.3 | Classic response handling is used; invalid content encoding can leak a connection. The same trusted-local boundary applies. |

The tests now reject TCP/SSH endpoints, remote environment/system/home overrides, custom providers and unsafe config files **before connecting**, then pin a canonical local Unix socket. Ten separate-process guard cases verify refusal, including zero observed connections to a fake remote listener. Explicit external PostgreSQL test URLs remain a separate opt-in path. Source and actual shaded bytecode show `executeOpen` on classic requests and `UnixSocket.get` for the selected endpoint. These findings are **mitigated with residual local-daemon trust**, not erased or declared universally unreachable. Reassess when the vendor releases fixed shaded bytes, and before allowing remote or untrusted Docker infrastructure. [Apache's security guidance](https://hc.apache.org/security.html) describes the client trust boundary.

The pinned optional Alpine startup-check image has one zlib **MEDIUM** match; it was not observed being started in the final Java run and is not a deployed service. Its affected gzip-write path was not verified. It remains a known version match; non-observation does not close future helper exposure. Ryuk's exact immutable helper image was inspected/scanned, but the scanner produced **no package-analysis results**: its binary vulnerability coverage is **not verified**, rather than a zero-vulnerability claim. Ryuk ran and cleaned the owned integration fixtures.

## Boundaries and next action

Limited source review found no configured Tomcat FORM/DIGEST authentication or Jackson default typing/object-identity/Path/XMLGregorianCalendar request contract; compatible patches were applied regardless. Primary records include [Tomcat 11 security](https://tomcat.apache.org/security-11.html), [LZ4 native extraction](https://github.com/yawkat/lz4-java/security/advisories/GHSA-mcr4-qmvw-px4g), [bounded user parser](https://github.com/moby/sys/security/advisories/GHSA-mjcv-p78q-w5fw) and [Windows-only Go record](https://pkg.go.dev/vuln/GO-2026-5024). Absence of a configured feature is not a universal exploit proof.

Only Linux arm64 execution is validated. The legacy Docker Engine 24.0.6, host OS, unrelated services, alternate architectures and hosted CI are outside the clean-image result. Continue using loopback-only ports and a trusted local daemon; review a current isolated host/runtime before external deployment. [Security posture](../SECURITY.md), [functional evidence](verification/release-readiness.json) and [release gates](release.md) retain these limits and the requirement for explicit publication approval.
