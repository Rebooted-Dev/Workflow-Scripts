---
id: confirm-execution
version: 2.0
category: build
kind: workflow
triggers:
  - "confirm execution"
  - "verify this implementation plan"
inputs: [plan-path]
outputs: [verification-addendum]
requires: [metadata-root, parallel-agents, verification-gates, filing-and-logging]
agents: [bug-hunter, test-strategist, docs-writer, security-scanner]
prev: [execution]
next: [mark-completed]
skills:
  primary: execute-and-confirm-plan
  required:
    - workflow-intake-and-routing
    - engineering-quality-gates
    - repo-records-and-filing
  conditional:
    - skill: delegated-agent-orchestration
      when: "audit verification uses helper agents or role fan-out"
---

# Workflow: Confirm Execution

## Skill Hooks

- Use primary skill `execute-and-confirm-plan` to verify implementation claims against code and checks.
- Load required skills `workflow-intake-and-routing`, `engineering-quality-gates`, and `repo-records-and-filing` before changing plan status or logs.
- Load conditional skill `delegated-agent-orchestration` when helper agents audit code, tests, docs, or security coverage.

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

Use the single source of truth for marking and completion conventions: **[`../04-documentation/03-mark-completed.md`](../04-documentation/03-mark-completed.md)**.

In this workflow you are **auditing**: only mark or change tasks based on what you have verified. Use **✅ (green check mark) only** for completed tasks—not "x", ✓, or other symbols—so status is consistent and easy to see at a glance.

- **Completed:** `- [✅]` only if both the code change exists and verification/exit criteria were met. If the plan already has `- [✅]` and that is correct, leave it; otherwise normalize to `- [✅]`.
- **Incomplete / open:** `- [ ]` for not started, in progress, missing code or verification, or deferred; add a note for partial or deferred tasks.
- **Parent tasks:** `- [✅]` only when all sub-tasks are complete (same as 01).
- **Systematic review:** Check every task in the plan; correct any misreporting.

If the plan does not use task list syntax, add an addendum section instead of rewriting the whole plan.

## Steps

1. Read the plan end-to-end; extract the list of claimed completed tasks and their acceptance criteria.

2. Use the frontmatter role IDs, `../00-core/parallel-agents.md`, and `../00-core/verification-gates.md` to compare plan tasks to files, rerun required checks when needed, spot-check user-facing behavior, and find docs/log/security/test gaps.

3. **Systematically review every task in the plan:** Go through each task (and each priority phase if the plan uses P0/P1/P2/P3). Apply the marking convention: correct any misreporting (e.g. task marked `- [✅]` but code or verification is missing → change to `- [ ]` and add a note). Leave already-correct marking as-is, using `- [✅]` for completed. Add notes for incomplete or deferred tasks.

4. Add a verification addendum to the plan containing:
   - Timestamp: `YYYY-MM-DD HH:MM`
   - Commands run (for example, the project-specific build/test command)
   - What was verified manually (if any)
   - Any misreporting or mismatches (with file paths / evidence)
   - Next steps (only for incomplete items)

5. **When the plan is fully verified complete:** If a completion marker is not already present, add one (e.g. `**Status:** ✅ COMPLETED` at the top or `## Implementation Status ✅`). See the Workflow-Scripts main README, "Completion Status Conventions."

6. **Mark completed + archive consistently:** **Then execute the full `03-mark-completed.md` workflow** to:
  - Verify implementation with parallel agents
  - Reconcile changelog, troubleshooting, and documentation
  - Mark tasks with ✅ consistently
  - Archive the plan into `<metadata-root>/plans-completed/` and update `<metadata-root>/changelog/index.md` (Type=`plan`).
  Follow **[`../04-documentation/03-mark-completed.md`](../04-documentation/03-mark-completed.md)** for the complete process.

## Related Workflows

- **[`01-execution.md`](./01-execution.md)** - Execute implementation plans (run this first, then confirm)
- **[`../01-planning/02-finalise-plan.md`](../01-planning/02-finalise-plan.md)** - Create the implementation plan being verified
- **[`../05-review/01-code-review.md`](../05-review/01-code-review.md)** - Review code quality after verification
- **[`../03-debugging/02-bug-fix-workflow.md`](../03-debugging/02-bug-fix-workflow.md)** - Fix any bugs discovered during verification
