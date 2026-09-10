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
- Updated changelog per the **host repository's documented changelog convention** (see host AGENTS.md or `project/changelog/README.md`)
- Troubleshooting entries only when a bug, issue, or non-trivial problem was fixed (see AGENTS.md); not for simple changes or routine refactors
- Implementation plan in `plans/` updated with task list and completion status (`- [✅]` for completed, `- [ ]` for open)
- Verification evidence: commands run, tests run, smoke/acceptance checks performed (or explicit blockers if something could not be run)
- **Phase checkboxes vs terminal completion:** This workflow may mark **phase** task checkboxes (`- [✅]`) only after applicable Verification Bar evidence passes. **Plan-level** completion marker, log reconciliation, and archive are owned solely by **[`03-mark-completed.md`](../04-documentation/03-mark-completed.md)** (see Finalization).

---

## Verification Bar (required)

A phase or plan is **not complete** because the code was written or a single build command passed. **Done** means the change works as defined by acceptance criteria and phase exit criteria.

Apply this bar for every phase and again at finalization (shared with [`README.md`](./README.md) and [`02-confirm-execution.md`](./02-confirm-execution.md)):

1. **Project verify command** — Run the project verification command from `AGENTS.md`, package scripts, Makefile, or local test docs. Prefer the project's full verify path when one exists (e.g. build + lint + typecheck). If none exists, state that explicitly. `npm run build` is only an example, not a universal bar.
2. **Automated tests when present** — If the repo has a test script or suite that covers (or should cover) this change, **run it**. Do not treat "test execution" as optional side work. For bug fixes, add a regression test when practical.
3. **Acceptance / smoke for user-facing or runtime behavior** — When the phase changes user-facing flows, APIs, IPC, providers, export/render, or other runtime behavior: smoke the affected path (dev server, CLI, or packaged path per project docs). Unit tests alone are not enough when the plan depends on real runtime behavior.
4. **Static hygiene** — TypeScript/ESLint (when configured), imports/structure, and `git diff` review for unintended changes or secrets.
5. **Skipped or blocked checks are not success** — If a required check cannot run (missing secrets, no display, env blocked), record it as **unresolved evidence** with what was blocked and residual risk. Do **not** mark the task `- [✅]` as if verification passed.
6. **Evidence** — In the phase report (and plan notes when useful), name the commands/checks run and pass/fail. Prefer concrete evidence over "verified."

---

## Preparation

- Confirm goal + acceptance criteria (user-facing behavior, performance targets, "done" definition).
- Check repo state (avoid clobbering unrelated work): `git status`.
- Identify the plan: implementation plan in `plans/` (e.g. `plans/implementation-plan-*.md` or `plans/YYYY-MM-DD-*-implementation-plan.md`).
- Break work into phases; for each phase define scope, out-of-scope, and **exit criteria that include how success will be verified** (commands, tests, and/or smoke of acceptance criteria—not only "code exists").
- Plan delegation per [`workflow-applicability.md`](../00-Meta-Workflow/00-meta/workflow-applicability.md) and [`agent-spawning-policy.md`](../00-Meta-Workflow/00-meta/agent-spawning-policy.md). Suggested agent roles when scope warrants (adapt as needed):
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
  - Exit criteria: concrete checks that must pass (map each criterion to the Verification Bar: verify command, tests, smoke, and/or static hygiene).
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
  - **Meet the Verification Bar above** before marking the phase complete. Build/lint alone is insufficient when tests or acceptance smoke apply.
  - Use parallel agents to run checks concurrently. Required agent roles when applicable:
    - Run the project verification command (build/lint/typecheck as defined by the project)
    - Run automated tests for this change when a suite/script exists; report results
    - Smoke acceptance criteria / affected user-facing or runtime flows when the phase touches them
    - Check TypeScript/ESLint errors and warnings (when configured)
    - Validate file structure and imports; review git diff for unintended changes or secrets
  - Spawn additional agents when needed (performance, security scan, docs validation, integration tests).
  - Prefer the local dev (or project-documented) command for smoke tests when the project is trusted and the change is user-facing or runtime-dependent.
  - If failures: fix, then re-run the **same** checks only after a meaningful corrective change or new hypothesis. If no evidence-backed next step remains, record the blocker and leave the task incomplete.
- Phase report (immediately after exit criteria met)
  - **CRITICAL: Update the implementation plan** so it reflects reality (completed vs pending vs deferred). For the single source of truth on task marking and completion conventions, follow **[`../04-documentation/03-mark-completed.md`](../04-documentation/03-mark-completed.md)**.
  - **Do not mark `- [✅]` unless Verification Bar items that apply to this phase passed** (or the user explicitly accepts residual risk for a documented blocker).
  - Include brief verification evidence in the phase summary (commands/tests/smoke + result).
  - **Update logs (only for completed tasks that change or affect project code):**
    - **Changelog:** Add a dated entry for this phase's work per the host repository's documented changelog convention (see host AGENTS.md or `project/changelog/README.md`).
    - **Troubleshooting (only when applicable):** Add a troubleshooting entry **only** when this phase involved one of the following (see AGENTS.md and `troubleshooting/README.md` for full conventions):
      - **Add an entry when:** You fixed a **bug** (incorrect behavior or crash), resolved an **issue** that required debugging or a workaround, or solved a **non-trivial problem** (significant investigation, multiple steps, or lessons worth preserving — e.g. complex config, unexpected framework behavior, tricky debugging).
      - **Do not add an entry when:** The work was a simple code change, routine refactor, or straightforward feature addition with no real problem-solving. Changelog is enough.
      - When you do add an entry: create a file under `troubleshooting/<category>/` named `YYYY-MM-DD-<category>-<short-title>.md`, update `troubleshooting/index.md` (new row at top), and include Date, Category, Status, Symptom, Root Cause, Fix, Verification, Notes/Lessons.
  - Provide a concise summary (1-3 bullets) describing what changed and why, plus verification outcome.

## Finalization (After All Phases)

- Re-run the Verification Bar for the whole change set: project verify command, automated tests when present, and acceptance/smoke for user-facing or runtime behavior. Confirm the repo is shippable against the plan's acceptance criteria; if no verify/test command exists, state that explicitly.
- Sanity-check for secrets/unintended files before committing (do not commit `.env*` or credentials).
- **Terminal completion:** Run the mandatory terminal gate [`03-mark-completed.md`](../04-documentation/03-mark-completed.md) when the whole plan is verified complete (sole owner of plan-level marker and archive).
- Optionally run [`02-confirm-execution.md`](./02-confirm-execution.md) to audit completion against the plan **before** the gate (recommended when using this workflow alone without [`03-execute-and-confirm.md`](./03-execute-and-confirm.md)). Confirmation may downgrade false claims and append evidence; it does not finalize or archive.

## Quick Checklist

- [ ] Goal and acceptance criteria confirmed
- [ ] Repo state checked (`git status`)
- [ ] Plan identified in `plans/`
- [ ] Each phase: implement → **Verification Bar** (verify command + tests when present + smoke when user-facing/runtime) → update plan (`- [✅]` / `- [ ]`) and logs (changelog; troubleshooting only if bug/issue/non-trivial fix — see phase report)
- [ ] Phase exit criteria include how success is verified; skipped checks recorded as blockers, not success
- [ ] Final Verification Bar passes for the full change set; no secrets in diff
- [ ] Plan fully marked per the terminal gate; completion marker/archive only via [`03-mark-completed.md`](../04-documentation/03-mark-completed.md)
- [ ] (Optional) Confirm execution run for verification addendum

## Related Workflows

- **[`02-confirm-execution.md`](./02-confirm-execution.md)** - Validate that implementation matches the plan after execution
- **[`../01-planning-and-organizing/02-finalise-plan.md`](../01-planning-and-organizing/02-finalise-plan.md)** - Create implementation plans before starting execution
- **[`../01-planning-and-organizing/01-plan-review.md`](../01-planning-and-organizing/01-plan-review.md)** - Review plans for correctness before execution
- **[`../05-review/01-code-review.md`](../05-review/01-code-review.md)** - Review code quality after implementation
- **[`../03-debugging/02-bug-fix-workflow.md`](../03-debugging/02-bug-fix-workflow.md)** - Fix bugs discovered during implementation
- **[`../04-documentation/02-sync-documentation.md`](../04-documentation/02-sync-documentation.md)** - Update documentation after code changes
