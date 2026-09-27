# Expand pre-commit hook validators (quality plan E3)

**Date:** 2026-09-27
**Type:** changed

## Summary

Extended `scripts/hooks/pre-commit` beyond staged meta-log checks: completion-chain policy, planning/build policy, and tiered `check-plan.sh` for fully staged active plans under `00-project/plans/` that declare **Tier:** T1–T3. Unstaged edits on a staged plan file block the commit.

## Verification

- Dry-run: staged `missing-verify` fixture copy under `plans/` fails; staged `t2-pass` passes.
- `check-plan-selftest.sh` and `check-planning-build-policy-selftest.sh` pass.
- Enable per clone: `git config core.hooksPath scripts/hooks`.

**Troubleshooting:** not needed — planned hook expansion; no defect.
