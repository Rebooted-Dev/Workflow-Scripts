# Workflow: Execution

## Purpose

Execute implementation in phases with verification and documentation updates.

## Inputs

- Goal and acceptance criteria (user-facing behavior, performance targets, "done" definition)
- Repository root
- Implementation plan (optional, but recommended)

## Output

- Implemented code changes
- Updated changelog (`docs/CHANGELOG.md` or `CHANGELOG.md`)
- Troubleshooting entries (if bugs were fixed)
- Task list with completion status

---

## Preparation

- Confirm goal + acceptance criteria (user-facing behavior, performance targets, "done" definition).
- Check repo state (avoid clobbering unrelated work): `git status`.
- Break work into phases; for each phase define scope, out-of-scope, and exit criteria.
- Plan parallel agents explicitly for each phase:
  - Agent 1: Implement core functionality
  - Agent 2: Review for security/risk issues and side effects
  - Agent 3: Check for breaking changes or unintended impacts
  - Agent 4: Validate against acceptance criteria and test cases

## For Each Phase (Implementation Loop)
- Phase definition (before coding)
  - Scope: what changes in this phase; what is out-of-scope.
  - Expected touch points: key files/areas likely to change.
  - Exit criteria: concrete checks that must pass.
- Implement
  - Make the smallest change that satisfies the phase scope.
  - Use parallel agents to:
    - Agent 1: Implement the core change
    - Agent 2: Concurrently review for risks, side effects, and breaking changes
    - Agent 3: Check for unintended impacts on other modules or features
    - Agent 4: Validate code quality and adherence to project conventions
- Verify (repeat until exit criteria met)
  - Use parallel agents to run checks concurrently:
    - Agent 1: Run `npm run build` and check for build errors
    - Agent 2: Check for TypeScript/ESLint errors and warnings
    - Agent 3: Validate file structure and imports are correct
    - Agent 4: Review git diff for unintended changes or secrets
  - If relevant, run: `npm run dev` and perform a quick smoke test of the affected flow.
  - If failures: fix, then re-run the same checks.
- Phase report (immediately after exit criteria met)
  - **CRITICAL: Update task list using Markdown checkbox format:**
    - **Completed items:** `- [x] Task description` - Mark IMMEDIATELY after task completion and verification
    - **Pending items:** `- [ ] Task description` - For tasks not yet started or still in progress
    - **Parent tasks:** Mark parent tasks as `- [x]` only when ALL sub-tasks are complete
    - **Deferred tasks:** Leave as `- [ ]` and add a note explaining deferral (e.g., "Deferred to P3")
    - **Systematic checking:** Review ALL tasks in the plan, not just the ones you worked on in this phase
  - Update the changelog with a dated entry: `- YYYY-MM-DD: ...`.
    - Preferred location: `docs/CHANGELOG.md`
    - Fallback location: `CHANGELOG.md`
  - If a bug was fixed, add a troubleshooting entry:
    - Create a new file under `troubleshooting/<category>/` named `YYYY-MM-DD-<category>-<short-title>.md`
    - Update `troubleshooting/index.md` (add the new entry at the top)
    - Include: Date, Category, Status, Symptom, Root Cause, Fix, Verification, Notes/Lessons
  - Provide a concise summary (1-3 bullets) describing what changed and why.

## Finalization (After All Phases)

- Run a final `npm run build` to confirm the repo is shippable.
- Sanity-check for secrets/unintended files before committing (do not commit `.env*` or credentials).
- Optionally run [`02-confirm-execution.md`](./02-confirm-execution.md) to validate completion against the plan.
