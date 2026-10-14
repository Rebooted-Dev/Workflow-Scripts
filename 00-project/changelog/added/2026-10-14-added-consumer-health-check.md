# Consumer project health-check CLI

**Date:** 2026-10-14
**Type:** added

---

## Summary
- Implemented the selected consumer layout checks, per-operation confirmed repairs with backups, and opt-in H12 canary behavior.
- Added the health-check specification and linked its bounded subset from setup Step 3, retaining uncovered manual verification steps.
- The fixture selftest covers read-only and repair matrices, no-terminal behavior, backup failures, symlink-parent ignore rules, and stubbed canary calls; no live model call was needed for tests.
- NuBible-App's default run exited `0`; the consumer's before/after Git status snapshots matched exactly. H11 remains a warning for a learnings entry with no Source field; no consumer file was changed.

## Scope
- `scripts/validation/health-check.sh`
- `scripts/validation/fixtures/health-check/`
- `scripts/validation/health-check-selftest.sh`
- `00-project-setup/12-health-check.md`
- `00-project-setup/01-setup-project.md` and `README.md`

**Plan:** [consumer health-check implementation plan](../../plans-completed/implementation/2026-10-14-consumer-health-check-implementation-plan.md)
