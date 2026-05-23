---
name: workflow-bug-fix-plan-and-logs
description: Follow a repo bug-fix workflow from saved evidence to plan, implementation, verification, and logs. Use when the user names a bug-fix workflow, asks to inspect project/execution or project/errors first, says study this report then implement the plan, reports a persistent regression, asks to update both logs, or asks to file a completed bug plan.
---

# Workflow Bug Fix Plan And Logs

Use this skill for bugs that need evidence-first diagnosis plus durable repo bookkeeping.

## Overlap Boundary

- If the task is only plan review without a bug or implementation request, use `workflow-plan-review-finalize`.
- If an approved plan already exists and the user says implement it, this skill can hand off to `execute-and-confirm-plan` after the bug-specific evidence pass.
- Use `repo-logs-and-docs-sync` as the final bookkeeping checklist.

## Workflow

1. Load the requested workflow and evidence.
   - Read the exact bug-fix workflow path the user named.
   - Read named artifacts first: `project/execution/*`, `project/errors/*`, `project/research/bug-reports/*`, console logs, terminal logs, prior plans, and troubleshooting entries.
   - If a path is slightly malformed, search under `Workflow-Scripts/` before treating it as missing.

2. Classify the failure.
   - Separate regression, timeout, upstream account/capability, env precedence, parser, route, rendering/state, and export failures.
   - Trace the concrete execution path instead of patching the nearest symptom.
   - Record current evidence and uncertainty before changing code.

3. File or update the bug plan when required.
   - Create a focused plan in `project/plans/` if the workflow or user asks for one.
   - Include reproduction, suspected root cause, files to inspect/change, tests, verification commands, rollback, and logging obligations.
   - Update plan trackers if the repo uses them.

4. Implement the fix.
   - Keep edits scoped to the diagnosed failure.
   - Add a regression test when practical.
   - Preserve explicit user/product semantics such as selected provider, selected mode, env precedence, or export surface.

5. Verify and reconcile.
   - Run targeted tests plus the workflow's required checks.
   - For UI/export/provider/runtime bugs, verify the real affected surface, not only helper functions.
   - Update changelog and troubleshooting for non-trivial bugs or when the user says "update both logs".
   - Archive completed plans only after live code and verification prove completion.

## Completion Bar

Report the root cause, changed files, verification run, log/plan updates, and any remaining risk. Do not call a persistent or partially verified bug fixed.
