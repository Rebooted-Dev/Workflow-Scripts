# Debt trigger and verified-task TODO reconciliation

**Date:** 2026-09-26
**Category:** workflow
**Status:** resolved

## Symptom

During Phase C Gate 3 review, the proposed edits to `04-documentation/03-mark-completed.md:161-166` and `01-planning-and-organizing/00-research-and-plan.md:105-107` exposed a false-completion risk: an open debt trigger could be read as closing the debt, and replacing the existing host-TODO step could drop reconciliation for verified plan tasks.

## Root Cause

The debt-transfer addition conflated a trigger for reassessment with a completion condition. It also treated the new open-debt transfer as a replacement for the pre-existing reconciliation of verified task entries, rather than preserving both responsibilities.

## Fix

- The workflow correction explicitly keeps debt open when its trigger fires; the trigger prompts reassessment and scheduling, while closure requires verified remediation or an explicit retirement decision.
- The terminal gate retains reconciliation of verified plan tasks and separately transfers open Deferred & Debt entries without duplicates.
- Gate 3 review caught the defect before commit. The correction shipped in Phase C commit `9aad15cf8ab96f16a6af6b9ea2bb795fa44e6ef1`. This follow-up documents that correction and supplies its missing fix log; it is not a new workflow-code fix.

## Verification

- Gate 3 Oracle: PASS (attempt 2).
- `bash scripts/validation/check-completion-chain-policy.sh` passed.
- The active-link checker remains nonzero for exactly four known Plan 01 references at lines 7, 95, 96, and 97 of `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md`; Plan 01 owns those repairs.

## Notes / Lessons

- A debt trigger is a reassessment point, not a task-completion event.
- Add open-debt transfer alongside existing verified-task reconciliation; do not replace the established TODO behavior.
- Matching fix record: [changelog entry](../../changelog/fixed/2026-09-26-fixed-debt-todo-reconciliation.md).
