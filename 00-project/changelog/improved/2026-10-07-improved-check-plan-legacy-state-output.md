# Explicit state output for legacy plans in check-plan

**Date:** 2026-10-07

**Type:** improved

---

## Summary

- `check-plan.sh --state` now prints `OK (LEGACY, state)` when a plan without a `**Tier:**` header passes state mode, so legacy (untiered) plans report the same explicit passing state as tiered plans (`OK (<tier>, state)`) instead of exiting silently after the legacy warning.
- No change to validation outcomes: exit codes and the structural lint for legacy plans are unchanged.

## Files

- `scripts/validation/check-plan.sh` — emit the OK state line in the `LEGACY` branch when `--state` is active.
