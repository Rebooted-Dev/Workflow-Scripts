---
name: workflow-plan-review-finalize
description: Review, correct, and finalize repository implementation plans. Use when the user asks to use plan-review/finalise-plan/research-and-plan workflows, verify a plan against the live codebase, decide whether a plan is still relevant, append findings to a plan, create or update a dated active plan under project/plans, or update plan trackers.
---

# Workflow Plan Review Finalize

Use this skill to turn research, a draft, a stale plan, or a review-stage plan into an evidence-backed active or final plan.

## Overlap Boundary

- For bug reports that must proceed through diagnosis, fix, verification, and both logs, use `workflow-bug-fix-plan-and-logs`.
- For implementing an already approved plan, use `execute-and-confirm-plan`.
- For bookkeeping after implementation, use `repo-logs-and-docs-sync`.
- For broad code-review findings that need a remediation plan, use `filed-code-review-to-remediation`.

## Workflow

1. Resolve the requested workflow path.
   - Prefer the exact file the user named.
   - If the path drifted, search under `Workflow-Scripts/` for the nearest matching workflow.
   - Read the workflow before changing the plan.

2. Inspect the target plan and repo state.
   - Read the named plan and any referenced research or review files.
   - Verify key implementation claims against live source files, tests, scripts, configs, and current docs.
   - Do not trust `final`, `complete`, or checklist language until it is confirmed by code and verification evidence.

3. Append review findings when the workflow expects it.
   - Add a dated addendum to the source plan or review artifact.
   - Separate confirmed facts from risks, stale assumptions, and open questions.
   - Include an explicit relevance assessment: still needed, partially obsolete, obsolete, or ready to execute.

4. Create or update the plan artifact.
   - Create a separate dated plan in `project/plans/` unless the user or workflow says otherwise.
   - If the user asks to update a named plan in place, edit that plan and add dated findings or a revision section.
   - Keep the source plan as audit trail.
   - Prioritize phases by severity and dependency order.
   - Include success criteria, verification commands, rollback or mitigation notes, and docs/logging requirements.

5. Update trackers.
   - Update `project/plans/README.md` and `project/plans/TODO.md` together when they exist.
   - Remove or retarget stale active-plan rows.
   - Search for stale links to moved or superseded files before finishing.

## Guardrails

- Keep this pass planning-focused unless the user explicitly authorizes implementation.
- Do not overwrite source plans when the workflow expects a separate final artifact.
- Treat deterministic tests/builds and live runtime QA as separate acceptance gates.
- If only part of a plan is still valid, narrow the final plan instead of carrying stale scope forward.
