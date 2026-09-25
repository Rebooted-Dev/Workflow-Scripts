# Completion chain ticks verified tasks for every outcome
**Date:** 2026-09-25
**Type:** fixed

---

## Summary
- Split task-level `[✅]` ticks from plan-level finalisation. `01-execution` must tick each task as its Verification Bar passes, and `02-confirm-execution` corrects ticks in both directions. `03-mark-completed` remains the sole owner of the plan completion marker and archive.
- `03-mark-completed` now runs at the end of every execute-and-confirm chain: **Full completion** mode for `Verified Complete`, and **Reconcile only** mode for `Not Eligible` (ticks verified tasks and reconciles logs/docs/TODO, with no marker or archive).
- Gate Phase 1 verifies every task, including unticked ones and numbered-list checkboxes.
- Unresolved host archive policy now blocks only the archive move.
- `check-completion-chain-policy.sh` guards against the regression.

## Scope
- `02-code-build/{01-execution,02-confirm-execution,03-execute-and-confirm,README}.md`
- `04-documentation/{03-mark-completed,README}.md`
- `11-Skills/execute-and-confirm-plan/SKILL.md`
- `scripts/validation/check-completion-chain-policy.sh`

## Related
- Troubleshooting: [../../troubleshooting/workflow/2026-09-25-workflow-verified-tasks-never-ticked.md](../../troubleshooting/workflow/2026-09-25-workflow-verified-tasks-never-ticked.md)
- Supersedes the task-tick part of [changed/2026-08-11-changed-completion-chain-terminal-gate.md](../changed/2026-08-11-changed-completion-chain-terminal-gate.md)
