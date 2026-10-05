# Plans always have checkboxes, and tick state is checked by command
**Date:** 2026-10-05
**Type:** fixed

---

## Summary
- Added a **Marking Contract** to `plan-template.md`: every task, sub-task, and Success Criteria item is a checkbox; `[✅]` is the only tick; a box left `[ ]` after execution starts carries an `Open:` reason (`pending`, `blocked`, `deferred`, or `retired`).
- `check-plan.sh` now rejects `[x]`, `[X]`, and `[✓]` in tiered plans and gains two flags: `--require-tier` (a plan without a Tier header fails) and `--state` (a silently open task or criterion fails).
- Planning workflows must run `--require-tier` on the saved plan. Execution, confirmation, the combined workflows, the terminal gate, and the execution skill must run `--state` before reporting.
- Success Criteria are now ticked by execution and reconciled by confirmation and the gate.
- A plan without checkboxes (prose steps, YAML `todos:`) is converted before it is executed or archived. `02-confirm-execution` no longer substitutes an addendum.
- Removed two statements of the pre-2026-09-25 rule (`glossary.md`, `README.md`).
- The setup template's `AGENTS.md` block has an always-on **Plans** rule, and "file … as completed" starts with a reconcile step.
- `check-completion-chain-policy.sh` section 9 guards all of the above. The pre-commit hook runs `--state` on tiered plans staged under `00-project/plans-completed/`.

**Behaviour change:** an existing tiered plan that uses `[x]` now fails `check-plan.sh` until each tick is verified and changed to `[✅]` or reset to `[ ]`.

## Scope
- `00-Meta-Workflow/00-meta/{plan-template,glossary,naming-conventions}.md`, `README.md`
- `01-planning-and-organizing/{00-research-and-plan,01-plan-review,02-finalise-plan,03-plan-review-and-finalise}.md`
- `02-code-build/{01-execution,02-confirm-execution,03-execute-and-confirm,04-review-finalise-commit-execute,README}.md`
- `04-documentation/03-mark-completed.md`
- `03-debugging/02-bug-fix-workflow.md`, `06-security/02-security-fix.md`, `05-review/05-comprehensive-audit.md`
- `11-Skills/{execute-and-confirm-plan,workflow-plan-review-finalize}/SKILL.md`
- `00-project-setup/01-setup-project.md`, `00-project/plans-completed/README.md`
- `scripts/validation/{check-plan.sh,check-plan-selftest.sh,check-completion-chain-policy.sh}`, nine new fixtures, `scripts/hooks/pre-commit`
- Plan: [`../../plans/2026-10-05-plan-checkbox-and-tick-consistency-implementation-plan.md`](../../plans/2026-10-05-plan-checkbox-and-tick-consistency-implementation-plan.md)
- Troubleshooting: [`../../troubleshooting/workflow/2026-10-05-workflow-plans-without-checkboxes-or-ticks.md`](../../troubleshooting/workflow/2026-10-05-workflow-plans-without-checkboxes-or-ticks.md)
- Host side: Update-AI-Tools `AGENTS.md` and `docs/agents/changelog-and-troubleshooting.md`, logged in that repository.
- Uncommitted at the time of writing (base `2cd0a55`, branch `v1.82`).
