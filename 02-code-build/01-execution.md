# Workflow: Execution

## Purpose

Execute implementation in phases with verification and documentation updates.

**When to use:** When the user says "execute the plan" or "proceed with this plan."

## Inputs

- Goal and acceptance criteria (user-facing behavior, performance targets, "done" definition)
- Repository root
- Implementation plan (optional, but recommended) — locate in `plans/` (e.g. `plans/implementation-plan-*.md` or `plans/YYYY-MM-DD-*-implementation-plan.md`)

## Output

- Implemented code changes
- Updated changelog (`changelog/` per AGENTS.md, or `docs/CHANGELOG.md` / `CHANGELOG.md` if the project uses a single file)
- Troubleshooting entries only when a bug, issue, or non-trivial problem was fixed (see AGENTS.md); not for simple changes or routine refactors
- Implementation plan in `plans/` updated with task list and completion status (`- [✅]` for completed, `- [ ]` for open)
- **If plan is fully completed:** File the completed plan in `project/plans-completed/<category>/` and update both `project/plans-completed/index.md` and `project/changelog/index.md` (see Filing Completed Plans below)

---

## Preparation

- Confirm goal + acceptance criteria (user-facing behavior, performance targets, "done" definition).
- Check repo state (avoid clobbering unrelated work): `git status`.
- Identify the plan: implementation plan in `plans/` (e.g. `plans/implementation-plan-*.md` or `plans/YYYY-MM-DD-*-implementation-plan.md`).
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
  - **CRITICAL: Update the implementation plan** so it reflects reality (completed vs pending vs deferred). For the single source of truth on task marking and completion conventions, follow **[`../04-documentation/03-mark-completed.md`](../04-documentation/03-mark-completed.md)**.
  - **Update logs (only for completed tasks that change or affect project code):**
    - **Changelog:** Add a dated entry for this phase's work. Prefer `changelog/` directory per AGENTS.md when the project uses it; otherwise use `docs/CHANGELOG.md` or `CHANGELOG.md`. File into appropriate type subfolder (`added/`, `changed/`, `fixed/`, `improved/`, `docs/`, `refactor/`, `config/`) and add a row at the **top** of `changelog/index.md`.
    - **Troubleshooting (only when applicable):** Add a troubleshooting entry **only** when this phase involved one of the following (see AGENTS.md and `troubleshooting/README.md` for full conventions):
      - **Add an entry when:** You fixed a **bug** (incorrect behavior or crash), resolved an **issue** that required debugging or a workaround, or solved a **non-trivial problem** (significant investigation, multiple steps, or lessons worth preserving — e.g. complex config, unexpected framework behavior, tricky debugging).
      - **Do not add an entry when:** The work was a simple code change, routine refactor, or straightforward feature addition with no real problem-solving. Changelog is enough.
      - When you do add an entry: create a file under `troubleshooting/<category>/` named `YYYY-MM-DD-<category>-<short-title>.md`, update `troubleshooting/index.md` (new row at top), and include Date, Category, Status, Symptom, Root Cause, Fix, Verification, Notes/Lessons.
  - Provide a concise summary (1-3 bullets) describing what changed and why.

## Finalization (After All Phases)

- Run a final `npm run build` to confirm the repo is shippable.
- Sanity-check for secrets/unintended files before committing (do not commit `.env*` or credentials).
- **Update the implementation plan:** Ensure task status and completion markers are consistent. **Then execute the full `03-mark-completed.md` workflow** to verify implementation, reconcile logs, and archive the plan properly. Follow **[`../04-documentation/03-mark-completed.md`](../04-documentation/03-mark-completed.md)** for the complete process.
- **If plan is fully completed, file it in `project/plans-completed/`:**
  1. Determine the appropriate category subfolder (`implementation/`, `investigation/`, `migration/`, `review/`, `tooling/`). If none fit, create a descriptive kebab-case folder (e.g., `performance-optimization/`).
  2. Move the plan from `project/plans/` or `project/build/` to `project/plans-completed/<category>/`
  3. Add a row at the **top** of `project/plans-completed/index.md` with columns: Date, Category, Title, File path, Notes
  4. Add a Type=`plan` entry at the **top** of `project/changelog/index.md` referencing the completed plan
- Optionally run [`02-confirm-execution.md`](./02-confirm-execution.md) to validate completion against the plan.

## Quick Checklist

- [ ] Goal and acceptance criteria confirmed
- [ ] Repo state checked (`git status`)
- [ ] Plan identified in `plans/`
- [ ] Each phase: implement → verify (build, lint, smoke) → update plan (`- [✅]` / `- [ ]`) and logs (changelog; troubleshooting only if bug/issue/non-trivial fix — see phase report)
- [ ] Final build passes; no secrets in diff
- [ ] Plan fully marked; completion marker added when done
- [ ] (Optional) Confirm execution run for verification addendum

## Related Workflows

- **[`02-confirm-execution.md`](./02-confirm-execution.md)** - Validate that implementation matches the plan after execution
- **[`../01-planning/02-finalise-plan.md`](../01-planning/02-finalise-plan.md)** - Create implementation plans before starting execution
- **[`../01-planning/01-plan-review.md`](../01-planning/01-plan-review.md)** - Review plans for correctness before execution
- **[`../05-review-audit/01-code-review.md`](../05-review-audit/01-code-review.md)** - Review code quality after implementation
- **[`../03-debug/02-bug-fix-workflow.md`](../03-debug/02-bug-fix-workflow.md)** - Fix bugs discovered during implementation
- **[`../04-documentation/02-sync-documentation.md`](../04-documentation/02-sync-documentation.md)** - Update documentation after code changes
