# Workflow: Confirm Execution

## Purpose

Validate that an implementation plan has actually been completed (in code and verification), and update the plan to reflect reality.

## When to Use This Workflow

**Use this workflow when:**
- You need to verify that implementation work matches what's claimed in a plan
- You want to audit task completion status in a plan document
- You need to identify discrepancies between plan and actual code
- You want to systematically check all tasks in a plan for completion

**Use [`01-execution.md`](./01-execution.md) instead when:**
- You are actively implementing code changes
- You need to execute a plan step-by-step
- You are making code changes and need verification

**This workflow will:**
- Read the plan document and extract claimed completions
- Verify code changes exist in the repository
- Check that verification criteria were met (or re-run build/checks if needed)
- Correct any misreporting in the plan; leave correct marking as-is
- Add a verification addendum documenting what was checked

**Relationship to 01:** This is an audit. If [`01-execution.md`](./01-execution.md) was followed, the plan is already marked and build/checks were run. You do not re-do those steps; you verify and add the addendum. Only run build/checks again if you are auditing without a prior execution, or to re-verify. Only change task checkboxes when you find misreporting (e.g. task marked complete but code or verification is missing).

## Inputs

- Plan document path (user-supplied).
- Repository root.

## Output

- The original plan document updated with:
  - Completed vs incomplete items marked consistently
  - A short verification addendum (what was checked and what passed/failed)
  - Misreporting called out explicitly with evidence

## Marking Convention

Use the same marking rules as in [`01-execution.md`](./01-execution.md) (phase report and finalization). In this workflow you are **auditing**: only mark or change tasks based on what you have verified. Use **✅ (green check mark) only** for completed tasks—not "x", ✓, or other symbols—so status is consistent and easy to see at a glance.

- **Completed:** `- [✅]` only if both the code change exists and verification/exit criteria were met. If the plan already has `- [✅]` and that is correct, leave it; otherwise normalize to `- [✅]`.
- **Incomplete / open:** `- [ ]` for not started, in progress, missing code or verification, or deferred; add a note for partial or deferred tasks.
- **Parent tasks:** `- [✅]` only when all sub-tasks are complete (same as 01).
- **Systematic review:** Check every task in the plan; correct any misreporting.

If the plan does not use task list syntax, add an addendum section instead of rewriting the whole plan.

## Steps

1. Read the plan end-to-end; extract the list of claimed completed tasks and their acceptance criteria.

2. Use parallel agents to verify completion against the repo. Suggested agent roles (spawn additional agents as needed):
   - Compare plan tasks to `git diff` / relevant files; confirm the code changes exist.
   - If build/checks were not already run (e.g. audit without prior 01 run), run `npm run build` and any other checks; otherwise spot-check or re-run only if you need to confirm.
   - Spot-check user-facing behavior (if applicable) and confirm key flows still work.
   - Look for gaps: missing docs/log updates, missing edge-case handling, broken imports.
   - [Spawn additional agents if you discover other verification needs, such as:
     - Test coverage validation
     - Performance impact checks
     - Security validation
     - Documentation completeness]

3. **Systematically review every task in the plan:** Go through each task (and each priority phase if the plan uses P0/P1/P2/P3). Apply the marking convention: correct any misreporting (e.g. task marked `- [✅]` but code or verification is missing → change to `- [ ]` and add a note). Leave already-correct marking as-is, using `- [✅]` for completed. Add notes for incomplete or deferred tasks.

4. Add a verification addendum to the plan containing:
   - Timestamp: `YYYY-MM-DD HH:MM`
   - Commands run (e.g., `npm run build`)
   - What was verified manually (if any)
   - Any misreporting or mismatches (with file paths / evidence)
   - Next steps (only for incomplete items)

5. **When the plan is fully verified complete:** If a completion marker is not already present, add one (e.g. `**Status:** ✅ COMPLETED` at the top or `## Implementation Status ✅`). See the Workflow-Scripts main README, "Completion Status Conventions."

6. **File the completed plan in the changelog:** Once all tasks are marked with green check marks and the plan is confirmed complete, archive it in the project changelog: move (or copy) the plan document to **`project/changelog/plans/`** with a date prefix (e.g. `yyyy-mm-dd-<plan-name>.md`), then add a new row at the **top** of **`project/changelog/index.md`** with Date, Type=`plan`, Title, File path (e.g. `project/changelog/plans/2026-03-01-my-plan.md`), and optional Notes. This keeps completed plans in the single changelog system and the index up to date.

## Related Workflows

- **[`01-execution.md`](./01-execution.md)** - Execute implementation plans (run this first, then confirm)
- **[`../01-planning/02-finalise-plan.md`](../01-planning/02-finalise-plan.md)** - Create the implementation plan being verified
- **[`../05-review-audit/01-code-review.md`](../05-review-audit/01-code-review.md)** - Review code quality after verification
- **[`../03-debug/02-bug-fix-workflow.md`](../03-debug/02-bug-fix-workflow.md)** - Fix any bugs discovered during verification
