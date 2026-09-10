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

3. Verify (match `02-code-build` Verification Bar).
   - Run the plan's specified tests/builds first; prefer the project verify path from `AGENTS.md`, package scripts, Makefile, or test docs over a single generic build.
   - When a test suite/script exists for the change, run it. For bug fixes, add a regression test when practical.
   - Add targeted smoke when the plan depends on user-facing or runtime behavior not covered by tests (frontend, export/render, provider, IPC, live webhook, CLI).
   - Treat skipped or blocked verification as unresolved evidence, not success—do not mark tasks complete as if checks passed.
   - Name commands/smoke run and pass/fail in the summary (and plan addendum when using confirm workflows).

4. Reconcile plan status with the terminal gate.
   - If fully verified complete (all applicable Verification Bar items passed, evidence present, no blocker): run the terminal gate `04-documentation/03-mark-completed.md`. It is the **only** workflow that applies terminal `✅` marks, the completion marker, and archive routing (resolved from the host repository's policy). Do **not** finalize or archive outside the gate.
   - If partial, blocked, skipped, failed, or under-evidenced: leave the plan **active** (`Not Eligible`), record landed work/blocker evidence/next verification, and apply **no** completion marker and **no** archive.
   - "When appropriate" never means skipping the terminal gate for a `Verified Complete` plan.

5. Sync repo records.
   - Add changelog entries for code changes.
   - Add troubleshooting entries for bugs, non-trivial debugging, environment blockers, or workarounds.
   - Update docs when behavior, setup, policy, or operational knowledge changed.
   - Update indexes after adding or moving records.

## Completion Bar

Finish with a concise summary of changed files, verification run (verify command, tests, smoke), documentation/logging updates, and any residual risk. If a command failed or was blocked, report it and why it matters. Build-only green is not enough when tests or acceptance smoke apply.
