# Workflow: Confirm Execution

## Purpose

Validate that an implementation plan has actually been completed (in code and verification), and update the plan to reflect reality.

## Inputs

- Plan document path (user-supplied).
- Repository root.

## Output

- The original plan document updated with:
  - Completed vs incomplete items marked consistently
  - A short verification addendum (what was checked and what passed/failed)
  - Misreporting called out explicitly with evidence

## Marking Convention

Use Markdown task list checkboxes:

- Completed: `- [x] Task description`
- Not completed / still open: `- [ ] Task description`

If the plan does not use task list syntax, add an addendum section instead of rewriting the whole plan.

## Steps

1. Read the plan end-to-end; extract the list of claimed completed tasks and their acceptance criteria.

2. Use parallel agents to verify completion against the repo:
   - Agent 1: Compare plan tasks to `git diff` / relevant files; confirm the code changes exist.
   - Agent 2: Validate build/tooling checks were run (or run them now): `npm run build`.
   - Agent 3: Spot-check user-facing behavior (if applicable) and confirm key flows still work.
   - Agent 4: Look for gaps: missing docs/log updates, missing edge-case handling, broken imports.

3. For each task in the plan:
   - Mark it completed only if:
     - the code change exists, AND
     - the stated verification/exit criteria were met (tests/build/manual verification).
   - If it is not completed, leave it unchecked and add a short note explaining what is missing.

4. Add a verification addendum to the plan containing:
   - Timestamp: `YYYY-MM-DD HH:MM`
   - Commands run (e.g., `npm run build`)
   - What was verified manually (if any)
   - Any misreporting or mismatches (with file paths / evidence)
   - Next steps (only for incomplete items)
