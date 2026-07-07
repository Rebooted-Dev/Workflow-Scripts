---
id: walking-skeleton-checklist
kind: template
status: active
---

# Walking Skeleton Checklist

Use this checklist for T3 greenfield work before the first feature slice.

## Product Boundary

- [ ] MVP user and problem are named.
- [ ] Three to five MVP capabilities are listed.
- [ ] Non-goals are recorded as scope cuts or backlog items.
- [ ] Stack choice is recorded as an ADR when it is hard to reverse.

## Repository Baseline

- [ ] Repository initialized with ignore rules for secrets, local env, build output, and OS metadata.
- [ ] Package/build tool is documented.
- [ ] Strict type or compile settings are enabled where the ecosystem supports them.
- [ ] Formatter and linter run from one documented command.
- [ ] Test harness contains at least one real test that exercises application code.

## CI And Release Path

- [ ] CI runs lint/type/build/test or the closest project equivalents.
- [ ] A near-empty app deploys to the intended target environment.
- [ ] A merged change can reach that environment through the documented path.
- [ ] Rollback command or procedure is written down.

## Observability And Security

- [ ] Startup, shutdown, and error signals meet `../core/standards/observability.md`.
- [ ] One safe intentional failure has been triggered and observed.
- [ ] Secrets are loaded from the target environment, not source files.
- [ ] Dependency audit or lockfile review is documented for the ecosystem.

## Exit Criteria

- [ ] A trivial visible/API behavior change can be made, tested, merged, deployed, observed, and rolled back.
- [ ] Any shortcuts taken during skeleton setup are filed in `<metadata-root>/debt/`.
