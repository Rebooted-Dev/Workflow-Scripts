# Add the host-usable check-plan linter
**Date:** 2026-09-25
**Type:** added

---

## Summary
- Added the structural `check-plan.sh` linter and fixture self-tests for tiered plans, including legacy opt-in, task-field ownership across nested lists, and indented-task cases. Shell syntax, fixture suites, non-link validators, and this plan's T2 dogfood check pass locally; Gate 2 passed after focused remediation. The active-link check remains limited to the four known Plan 01 failures; remote CI is pending an authorized push.

## Scope
- `scripts/validation/check-plan.sh`, its self-test and fixtures, and planning/build policy fixtures and self-test.
