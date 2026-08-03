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
- Apply the same **Verification Bar** as execution: project verify, tests when present, acceptance/smoke when user-facing or runtime-dependent
- Check that verification criteria were met (or re-run checks when evidence is missing, stale, or unconvincing)
- Correct any misreporting in the plan; leave correct marking as-is
- Add a verification addendum documenting what was checked

**Relationship to 01:** This is an audit of claims vs reality. If [`01-execution.md`](./01-execution.md) was followed, the plan is already marked and checks were run—but you still **confirm** that code exists **and** that applicable Verification Bar items passed (or re-run them when evidence is absent, contradictory, or only "build green"). You do not blindly re-implement; you validate. Only change task checkboxes when you find misreporting (e.g. task marked complete but code, tests, or acceptance checks are missing/failed).

## Inputs

- Plan document path (user-supplied).
- Repository root.

## Output

- The original plan document updated with:
  - Completed vs incomplete items marked consistently
  - A short verification addendum (what was checked and what passed/failed)
  - Misreporting called out explicitly with evidence

## Verification Bar (required for audit)

Use the same bar as **[`01-execution.md`](./01-execution.md)** (and [`README.md`](./README.md)). A task is **not** verified complete solely because code exists in the tree.

| Claim can stand only if… | Incomplete / misreported if… |
|--------------------------|------------------------------|
| Code change exists **and** matches the task | Code missing, partial, or wrong files |
| Project verify command passed (when one exists) | Only claimed; build/lint/typecheck not run or failed |
| Automated tests for the change ran when a suite/script exists | Tests skipped without a documented blocker, or failed |
| User-facing / runtime acceptance criteria smoked when applicable | Only unit tests or static review for a runtime-dependent change |
| Docs/logs updated when required by the plan or project conventions | Changelog/troubleshooting/docs obligations missing |

**Skipped or blocked checks are not success.** Record residual risk; keep `- [ ]` until fixed or the user accepts the blocker.

## Marking Convention

Use the single source of truth for marking and completion conventions: **[`../04-documentation/03-mark-completed.md`](../04-documentation/03-mark-completed.md)**.

In this workflow you are **auditing**: only mark or change tasks based on what you have verified. Use **✅ (green check mark) only** for completed tasks—not "x", ✓, or other symbols—so status is consistent and easy to see at a glance.

- **Completed:** `- [✅]` only if the code change exists **and** applicable Verification Bar items / exit criteria were met. If the plan already has `- [✅]` and that is correct, leave it; otherwise normalize to `- [✅]`.
- **Incomplete / open:** `- [ ]` for not started, in progress, missing code, missing or failed verification, or deferred; add a note for partial or deferred tasks.
- **Parent tasks:** `- [✅]` only when all sub-tasks are complete (same as 01).
- **Systematic review:** Check every task in the plan; correct any misreporting.

If the plan does not use task list syntax, add an addendum section instead of rewriting the whole plan.

## Steps

1. Read the plan end-to-end; extract the list of claimed completed tasks and their acceptance criteria / exit criteria.

2. Use parallel agents to verify completion against the repo. Agent roles (spawn additional agents as needed):
   - Compare plan tasks to `git diff` / relevant files; confirm the code changes exist and match intent.
   - **Re-run or confirm** the project verification command from `AGENTS.md`, package scripts, Makefile, or local test docs when prior evidence is missing, stale, or only partial. If none exists, state that explicitly. `npm run build` is only an example.
   - **Run automated tests** when a suite/script exists for the change; do not treat tests as optional during confirm.
   - **Spot-check user-facing or runtime behavior** when the plan's acceptance criteria depend on it (dev server, CLI, IPC, provider path, export/render, etc.)—not only static review.
   - Look for gaps: missing docs/log updates, missing edge-case handling, broken imports, false "complete" marks without verification evidence.
   - [Spawn additional agents if you discover other verification needs, such as:
     - Test coverage gaps
     - Performance impact checks
     - Security validation
     - Documentation completeness]

3. **Systematically review every task in the plan:** Go through each task (and each priority phase if the plan uses P0/P1/P2/P3). Apply the marking convention: correct any misreporting (e.g. task marked `- [✅]` but code or verification is missing → change to `- [ ]` and add a note). Leave already-correct marking as-is, using `- [✅]` for completed. Add notes for incomplete or deferred tasks.

4. Add a verification addendum to the plan containing:
   - Timestamp: `YYYY-MM-DD HH:MM`
   - Commands run (project verify, test suite, and any other checks—with pass/fail)
   - What was smoke-tested or verified manually against acceptance criteria (if any)
   - Any misreporting or mismatches (with file paths / evidence)
   - Blocked or skipped checks and residual risk (if any)
   - Next steps (only for incomplete items)

5. **When the plan is fully verified complete:** If a completion marker is not already present, add one (e.g. `**Status:** ✅ COMPLETED` at the top or `## Implementation Status ✅`). See the Workflow-Scripts main README, "Completion Status Conventions." Do **not** add a completion marker while required Verification Bar items are blocked or failed.

6. **Mark completed + archive consistently:** **Then execute the full `03-mark-completed.md` workflow** to:
  - Verify implementation with parallel agents
  - Reconcile changelog, troubleshooting, and documentation
  - Mark tasks with ✅ consistently
  - Archive the plan into `project/changelog/plans/` and update `project/changelog/index.md` (Type=`plan`).
  Follow **[`../04-documentation/03-mark-completed.md`](../04-documentation/03-mark-completed.md)** for the complete process.

## Related Workflows

- **[`01-execution.md`](./01-execution.md)** - Execute implementation plans (run this first, then confirm)
- **[`../01-planning-and-organizing/02-finalise-plan.md`](../01-planning-and-organizing/02-finalise-plan.md)** - Create the implementation plan being verified
- **[`../05-review/01-code-review.md`](../05-review/01-code-review.md)** - Review code quality after verification
- **[`../03-debugging/02-bug-fix-workflow.md`](../03-debugging/02-bug-fix-workflow.md)** - Fix any bugs discovered during verification
