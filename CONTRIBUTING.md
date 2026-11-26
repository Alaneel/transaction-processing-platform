# Contributing

This educational project values explicit transaction boundaries, retained failure evidence and reproducible measurements. Begin with the [code map](docs/code-map.md) and [architecture](docs/architecture.md).

Use Java 21 and a working Docker daemon. Before proposing a behavior change, run:

```sh
./mvnw -B -ntp clean verify
python3 scripts/test_event_benchmark.py
python3 scripts/test_demo.py
python3 scripts/render-showcase.py --check
```

The integration suite intentionally requires real PostgreSQL/Kafka; missing dependencies are not a passing result. For a presentation-only change, validate links, generated-asset provenance and the affected script without adding tests that merely repeat static content. Run the [local demo](docs/demo.md) when changing its workflow.

Preserve durable idempotency for completed and rejected results, immutable balanced ledger history, commit-time checks, bounded producer work, claim fencing, and the inbox-before-offset boundary. Do not make projected activity authoritative for balances. Add a meaningful failure regression when changing these mechanisms; update the relevant ADR when the design changes.

Describe the concrete trigger, resulting behavior and observed verification in the contribution. Benchmark claims must include raw files, workload, source/image identity, environment, observation boundaries and negative results. Keep current measurements separate from historical snapshots. Never commit local credentials, environment files, unsanitized recordings or customer data. See [security](SECURITY.md) and [release preparation](docs/release.md).
