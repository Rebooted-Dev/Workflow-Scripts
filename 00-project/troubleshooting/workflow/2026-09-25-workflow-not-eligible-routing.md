# Not Eligible outcome bypassed reconciliation

**Date:** 2026-09-25
**Category:** workflow
**Status:** resolved

## Symptom
- `02-code-build/04-review-finalise-commit-execute.md` named `Not Eligible` but directed the plan to remain active without running the terminal gate, contrary to the completion-chain contract.
- The E2 pre-fix scan identified the file with `WOULD FAIL 02-code-build/04-review-finalise-commit-execute.md`.

## Root Cause
- Two outcome descriptions in the review/finalise workflow had not been updated when the gate became mandatory for both outcomes. The `Not Eligible` path omitted **Reconcile only** mode.

## Fix
- Routed `Not Eligible` through the gate in **Reconcile only** mode and added a per-file E2 guard requiring `Reconcile only` wherever a 02-code-build file names `Not Eligible`.

## Verification
- Parent reports `bash scripts/validation/check-completion-chain-policy.sh` passed after the fix.

## Notes / Lessons
- A correct shared handoff is not enough when a downstream workflow restates the outcome; guard the positive routing invariant at every active code-build file.
