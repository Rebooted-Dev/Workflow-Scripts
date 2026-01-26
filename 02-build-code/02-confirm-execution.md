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
- Check that verification criteria were met
- Update the plan with accurate completion status
- Add a verification addendum documenting what was checked

## Inputs

- Plan document path (user-supplied).
- Repository root.

## Output

- The original plan document updated with:
  - Completed vs incomplete items marked consistently
  - A short verification addendum (what was checked and what passed/failed)
  - Misreporting called out explicitly with evidence

## Marking Convention

Use Markdown task list checkboxes consistently throughout the plan:

- **Completed:** `- [x] Task description` - Mark only if BOTH conditions are met:
  1. The code change exists in the repository (verified via `git diff` or file inspection)
  2. The stated verification/exit criteria were met (tests passed, build succeeded, manual verification completed)
- **Not completed / still open:** `- [ ] Task description` - For tasks that are:
  - Not yet started
  - In progress but not verified
  - Missing code changes
  - Missing verification/exit criteria completion
  - Explicitly deferred to a future phase

**Important rules:**
- **Systematic review:** Check EVERY task in the plan, not just the ones you remember working on
- **Parent tasks:** Mark parent tasks as `- [x]` only when ALL sub-tasks are complete
- **Sub-tasks:** Mark individual sub-tasks as `- [x]` when they are individually complete
- **Deferred tasks:** Leave as `- [ ]` and add a note (e.g., "Deferred to P3" or "Future enhancement")
- **Partial completion:** If a task is partially done, leave it as `- [ ]` and add a note explaining what remains

If the plan does not use task list syntax, add an addendum section instead of rewriting the whole plan.

## Steps

1. Read the plan end-to-end; extract the list of claimed completed tasks and their acceptance criteria.

2. Use parallel agents to verify completion against the repo. Suggested agent roles (spawn additional agents as needed):
   - Compare plan tasks to `git diff` / relevant files; confirm the code changes exist.
   - Validate build/tooling checks were run (or run them now): `npm run build`.
   - Spot-check user-facing behavior (if applicable) and confirm key flows still work.
   - Look for gaps: missing docs/log updates, missing edge-case handling, broken imports.
   - [Spawn additional agents if you discover other verification needs, such as:
     - Test coverage validation
     - Performance impact checks
     - Security validation
     - Documentation completeness]

3. **Systematically review every task in the plan:**
   - Go through each priority phase (P0, P1, P2, P3) in order
   - For each task and sub-task:
     - **Mark as completed (`- [x]`) only if BOTH:**
       - The code change exists (verify via `git diff`, file inspection, or code search)
       - The stated verification/exit criteria were met (tests passed, build succeeded, manual verification completed)
     - **Mark as incomplete (`- [ ]`) if:**
       - Code changes are missing
       - Verification/exit criteria were not met
       - Task is explicitly deferred
       - Only partially complete (add a note explaining what remains)
   - **For parent tasks with sub-tasks:**
     - Check if ALL sub-tasks are complete
     - Mark parent as `- [x]` only when all sub-tasks are `- [x]`
     - If any sub-task is incomplete, leave parent as `- [ ]`
   - **Add notes for incomplete tasks:** Explain what is missing or why it was deferred

4. Add a verification addendum to the plan containing:
   - Timestamp: `YYYY-MM-DD HH:MM`
   - Commands run (e.g., `npm run build`)
   - What was verified manually (if any)
   - Any misreporting or mismatches (with file paths / evidence)
   - Next steps (only for incomplete items)

## Related Workflows

- **[`01-execution.md`](./01-execution.md)** - Execute implementation plans (run this first, then confirm)
- **[`../01-planning/02-finalise-plan.md`](../01-planning/02-finalise-plan.md)** - Create the implementation plan being verified
- **[`../05-review-audit/01-code-review.md`](../05-review-audit/01-code-review.md)** - Review code quality after verification
- **[`../03-debug/02-bug-fix-workflow.md`](../03-debug/02-bug-fix-workflow.md)** - Fix any bugs discovered during verification
