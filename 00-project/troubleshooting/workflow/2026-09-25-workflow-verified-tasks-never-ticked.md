# Verified plan tasks never ticked after execution

**Date:** 2026-09-25
**Category:** workflow
**Status:** resolved

## Symptom
After running `02-code-build/03-execute-and-confirm.md` or `04-review-finalise-commit-execute.md`, plan tasks stayed `[ ]` even when the implementation and tests were verified. Changelog, TODO, and docs were not reconciled either. Seen in Flash-UI-Idea-Generator's `project/plans/2026-09-23-prompt-quality-p0-p1-implementation.md`. The checkpoint commit `0c69a19` had all 15 tasks `[ ]`, and five verified tasks were ticked only after `03-mark-completed.md` was run by hand.

## Root Cause
Commit `ea76fb5` (2026-08-11) made `03-mark-completed.md` the sole owner of "terminal `✅` task marks". That tied task-level ticks to plan-level finalisation, which caused four independent failures:
1. `01-execution.md` said it only "may" tick phase boxes, while the gate said it was the "only" place ticks happen. Agents deferred ticking.
2. `02-confirm-execution.md` was downgrade-only ("Only change task checkboxes when you find misreporting"; "must not add ✅").
3. `03-execute-and-confirm.md` ran the gate only on `Verified Complete` and said "a `Not Eligible` plan must not" invoke it. Most real plans end `Not Eligible` (one blocked smoke or paid eval), so the gate never ran.
4. The gate's Phase 1 only verified *claimed* completions, so unticked tasks were never examined even when it did run.

A host-side trap made it worse: an unresolved or contradictory archive policy made the gate report `Not Eligible / policy unresolved` for the whole plan. Flash-UI had exactly that contradiction (`docs/agents/changelog-and-troubleshooting.md` said `project/changelog/plans/`; `project/plans/README.md` said `project/plans-completed/<type>/`).

## Fix
- Split authority: task ticks are applied as tasks verify (`01` must tick per phase; `02` corrects in both directions). The gate still solely owns the plan completion marker and archive.
- The gate now always runs at the end of the chain: **Full completion** mode for `Verified Complete`, and **Reconcile only** mode for `Not Eligible` (ticks verified tasks and reconciles logs, with no marker or archive).
- Gate Phase 1 now verifies every task, ticked or not, in bulleted or numbered lists.
- Unresolved archive policy now blocks only the move, not ticks, the marker, or log reconciliation.
- Added regression checks to `scripts/validation/check-completion-chain-policy.sh`.
- The Flash-UI host README was aligned to `project/changelog/plans/`.

## Verification
- `bash scripts/validation/check-completion-chain-policy.sh` → OK on the fixed tree.
- Negative check: the updated validator run against a `git archive HEAD` copy of the pre-fix docs fails with `03-execute-and-confirm.md lacks the Reconcile only gate mode for Not Eligible plans`.
- `check-active-markdown-links.sh` failures are pre-existing and unrelated (`00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md`).

## Notes / Lessons
- Keep per-item status (task ticks) separate from aggregate gates (plan completion). A single owner for both turns any blocked item into "nothing gets marked".
- "Must not" for one outcome and "may" for the other lets an agent pass every step while doing nothing. Prefer unconditional steps with outcome-dependent modes.
