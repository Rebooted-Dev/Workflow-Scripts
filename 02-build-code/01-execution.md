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
- Plan parallel agents for each phase. Suggested agent roles (adapt as needed):
  - Implement core functionality
  - Review for security/risk issues and side effects
  - Check for breaking changes or unintended impacts
  - Validate against acceptance criteria and test cases
  - [Spawn additional agents if the phase complexity requires it, such as:
    - Performance impact analysis
    - Documentation updates
    - Test coverage validation
    - Integration testing
    - Accessibility checks]

## For Each Phase (Implementation Loop)
- Phase definition (before coding)
  - Scope: what changes in this phase; what is out-of-scope.
  - Expected touch points: key files/areas likely to change.
  - Exit criteria: concrete checks that must pass.
- Implement
  - Make the smallest change that satisfies the phase scope.
  - Use parallel agents. Suggested agent roles (spawn additional agents as needed):
    - Implement the core change
    - Concurrently review for risks, side effects, and breaking changes
    - Check for unintended impacts on other modules or features
    - Validate code quality and adherence to project conventions
    - [Spawn additional agents if you discover other concerns during implementation, such as:
      - Performance optimizations
      - Additional test coverage
      - Documentation updates
      - Related code cleanup
      - Security hardening]
- Verify (repeat until exit criteria met)
  - Use parallel agents to run checks concurrently. Suggested agent roles (spawn additional agents as needed):
    - Run `npm run build` and check for build errors
    - Check for TypeScript/ESLint errors and warnings
    - Validate file structure and imports are correct
    - Review git diff for unintended changes or secrets
    - [Spawn additional agents if other verification needs are discovered, such as:
      - Test execution and coverage
      - Performance benchmarking
      - Security scanning
      - Documentation validation
      - Integration testing]
  - If relevant, run: `npm run dev` and perform a quick smoke test of the affected flow.
  - If failures: fix, then re-run the same checks.
- Phase report (immediately after exit criteria met)
  - **CRITICAL: Update task list using Markdown checkbox format:**
    - **Completed items:** `- [x] Task description` - Mark IMMEDIATELY after task completion and verification
    - **Pending items:** `- [ ] Task description` - For tasks not yet started or still in progress
    - **Parent tasks:** Mark parent tasks as `- [x]` only when ALL sub-tasks are complete
    - **Deferred tasks:** Leave as `- [ ]` and add a note explaining deferral (e.g., "Deferred to P3")
    - **Systematic checking:** Review ALL tasks in the plan, not just the ones you worked on in this phase
  - **Update logs (only for completed tasks that change or affect project code):**
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

## Related Workflows

- **[`02-confirm-execution.md`](./02-confirm-execution.md)** - Validate that implementation matches the plan after execution
- **[`../01-planning/02-finalise-plan.md`](../01-planning/02-finalise-plan.md)** - Create implementation plans before starting execution
- **[`../01-planning/01-plan-review.md`](../01-planning/01-plan-review.md)** - Review plans for correctness before execution
- **[`../05-review-audit/01-code-review.md`](../05-review-audit/01-code-review.md)** - Review code quality after implementation
- **[`../03-debug/02-bug-fix-workflow.md`](../03-debug/02-bug-fix-workflow.md)** - Fix bugs discovered during implementation
- **[`../04-documentation/02-sync-documentation.md`](../04-documentation/02-sync-documentation.md)** - Update documentation after code changes
