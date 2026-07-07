---
name: execute-and-confirm-plan
description: Execute an approved implementation plan end to end. Use when the user says Implement the plan, points to an execute-and-confirm workflow, asks to complete a named plan, or expects code changes plus verification, changelog/troubleshooting/docs updates, and accurate plan archival or status updates.
---

# Execute And Confirm Plan

Use this skill after the user has explicitly moved from planning into implementation.

## Overlap Boundary

- If there is no approved plan yet, use `workflow-plan-review-finalize` or `workflow-bug-fix-plan-and-logs` first.
- If the work is only final changelog/troubleshooting/docs cleanup, use `repo-logs-and-docs-sync`.
- If publishing is requested from a mixed worktree, finish with `dirty-worktree-safe-publish`.

## Workflow

1. Establish execution scope.
   - Read the named plan and any execute-and-confirm workflow file.
   - Identify phases, required files, verification commands, and documentation/logging obligations.
   - Check `git status --short` before edits and protect unrelated user changes.

2. Implement in plan order.
   - Keep changes scoped to the approved plan.
   - Add regression tests for bugs when practical.
   - Prefer existing repo patterns, helpers, and architecture.
   - Update the active plan as phases complete or blockers appear.

3. Verify.
   - Run the plan's specified tests/builds first.
   - Add targeted verification when the plan depends on runtime behavior not covered by tests.
   - Treat skipped or blocked verification as unresolved evidence, not success.
   - For frontend, export, provider, or live webhook behavior, verify the real rendered/runtime path when feasible, not only unit tests.

4. Reconcile plan status.
   - If complete, mark completion according to the repo workflow and move/archive the plan when appropriate.
   - If partial, update the plan with landed work, blocker evidence, remaining tasks, and next verification needed.
   - Do not archive partial work as complete.

5. Sync repo records.
   - Add changelog entries for code changes.
   - Add troubleshooting entries for bugs, non-trivial debugging, environment blockers, or workarounds.
   - Update docs when behavior, setup, policy, or operational knowledge changed.
   - Update indexes after adding or moving records.

## Completion Bar

Finish with a concise summary of changed files, verification run, documentation/logging updates, and any residual risk. If a command failed, report the command and why it matters.
