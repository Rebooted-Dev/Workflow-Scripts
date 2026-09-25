# Route Not Eligible plans through reconciliation
**Date:** 2026-09-25
**Type:** fixed

---

## Summary
- Corrected `02-code-build/04-review-finalise-commit-execute.md` so the terminal gate runs for `Not Eligible` plans in **Reconcile only** mode; the plan remains active without a completion marker or archive.
- Added the E2 positive invariant to `check-completion-chain-policy.sh`: every 02-code-build file naming `Not Eligible` must also name `Reconcile only`.

## Verification
- Pre-fix E2 scan printed `WOULD FAIL 02-code-build/04-review-finalise-commit-execute.md`.
- Parent's post-fix `bash scripts/validation/check-completion-chain-policy.sh` passed.

## Related
- Troubleshooting: [Not Eligible routing](../../troubleshooting/workflow/2026-09-25-workflow-not-eligible-routing.md)
