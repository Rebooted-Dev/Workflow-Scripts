---
id: execution
version: 2.0
category: build
kind: workflow
triggers:
  - "execute the plan"
  - "proceed with this plan"
inputs: [plan-path]
outputs: [implemented-code, changelog-entry]
requires: [metadata-root, filing-and-logging, parallel-agents, verification-gates, code-design, error-handling, observability, security-baseline]
agents: [implementer, test-writer, security-scanner, docs-writer]
prev: [finalise-plan]
next: [confirm-execution]
skills:
  primary: execute-and-confirm-plan
  required:
    - workflow-intake-and-routing
    - engineering-quality-gates
    - repo-records-and-filing
  conditional:
    - skill: delegated-agent-orchestration
      when: "implementation, review, or verification is split across helper agents"
---

# Workflow: Execution

## Skill Hooks

- Use primary skill `execute-and-confirm-plan` to execute approved plans and keep task status truthful.
- Load required skills `workflow-intake-and-routing`, `engineering-quality-gates`, and `repo-records-and-filing` before changing code or records.
- Load conditional skill `delegated-agent-orchestration` when helper agents are used for implementation, review, tests, or docs.

## Purpose

Execute implementation in phases with verification and documentation updates.

**When to use:** When the user says "execute the plan" or "proceed with this plan."

Implementation quality is judged against `../../00-core/standards/code-design.md`, `../../00-core/standards/error-handling.md`, `../../00-core/standards/observability.md`, and `../../00-core/standards/security-baseline.md` when those concerns are in scope.

## Inputs

- Goal and acceptance criteria (user-facing behavior, performance targets, "done" definition)
- Repository root
- Implementation plan (optional, but recommended) — locate in `<metadata-root>/plans/` (e.g. `<metadata-root>/plans/YYYY-MM-DD-*-implementation-plan.md`)

## Output

- Implemented code changes
- Updated changelog (`changelog/` per AGENTS.md, or `docs/CHANGELOG.md` / `CHANGELOG.md` if the project uses a single file)
- Troubleshooting entries only when a bug, issue, or non-trivial problem was fixed (see AGENTS.md); not for simple changes or routine refactors
- Implementation plan in `<metadata-root>/plans/` updated with task list and completion status (`- [✅]` for completed, `- [ ]` for open)
- **If plan is fully completed:** File the completed plan in `<metadata-root>/plans-completed/<category>/` and update both `<metadata-root>/plans-completed/index.md` and `<metadata-root>/changelog/index.md` (see Filing Completed Plans below)

---

## Preparation

- Confirm goal + acceptance criteria (user-facing behavior, performance targets, "done" definition).
- Check repo state (avoid clobbering unrelated work): `git status`.
- Identify the plan: implementation plan in `<metadata-root>/plans/` (e.g. `<metadata-root>/plans/YYYY-MM-DD-*-implementation-plan.md`).
- Load any design brief, ADRs, and open debt entries for touched areas. Use `../../00-core/debt-ledger.md` for debt entry shape and paydown rules.
- Break work into phases; for each phase define scope, out-of-scope, and exit criteria.
- Plan role usage for each phase from the frontmatter roles (`implementer`, `test-writer`, `security-scanner`, `docs-writer`) and `../../00-core/parallel-agents.md`.

## For Each Phase (Implementation Loop)
- Phase definition (before coding)
  - Scope: what changes in this phase; what is out-of-scope.
  - Expected touch points: key files/areas likely to change.
  - Exit criteria: concrete checks that must pass.
- Implement
  - Make the smallest change that satisfies the phase scope.
  - Use frontmatter role IDs and `../../00-core/parallel-agents.md` for implementation, risk review, testing, and documentation support.
- Verify (repeat until exit criteria met)
  - Run the project verification command from `AGENTS.md`, package scripts, Makefile, or local test docs; if none exists, state that explicitly. `npm run build` is only an example.
  - Check lint/type/import structure, secrets/unintended diff, and acceptance criteria using `../../00-core/verification-gates.md`.
  - If relevant and the project is trusted, run the local dev command from project docs and perform a quick smoke test of the affected flow.
  - If failures: fix, then re-run the same checks.
- Phase report (immediately after exit criteria met)
  - **CRITICAL: Update the implementation plan** so it reflects reality (completed vs pending vs deferred). For the single source of truth on task marking and completion conventions, follow **[`../04-documentation/03-mark-completed.md`](../04-documentation/03-mark-completed.md)**.
  - Record deliberate shortcuts, known gaps, deprecations, or accepted scope cuts in `<metadata-root>/debt/` using `../../00-core/debt-ledger.md` or `tools/wf debt add`.
  - **Update logs** using `../../00-core/metadata-root.md` and `../../00-core/filing-and-logging.md`.
  - Provide a concise summary (1-3 bullets) describing what changed and why.

## Finalization (After All Phases)

- Run the final project verification command from `AGENTS.md`, package scripts, Makefile, or local test docs to confirm the repo is shippable; if none exists, state that explicitly.
- Sanity-check for secrets/unintended files before committing (do not commit `.env*` or credentials).
- **Update the implementation plan:** Ensure task status and completion markers are consistent. **Then execute the full `03-mark-completed.md` workflow** to verify implementation, reconcile logs, and archive the plan properly. Follow **[`../04-documentation/03-mark-completed.md`](../04-documentation/03-mark-completed.md)** for the complete process.
- **If plan is fully completed, file it** using `../../00-core/filing-and-logging.md`.
- Optionally run [`02-confirm-execution.md`](./02-confirm-execution.md) to validate completion against the plan.

## Quick Checklist

- [ ] Goal and acceptance criteria confirmed
- [ ] Repo state checked (`git status`)
- [ ] Plan identified in `plans/`
- [ ] Each phase: implement → verify with the project-specific build/lint/test/smoke command → update plan (`- [✅]` / `- [ ]`) and logs (changelog; troubleshooting only if bug/issue/non-trivial fix — see phase report)
- [ ] Final build passes; no secrets in diff
- [ ] Plan fully marked; completion marker added when done
- [ ] (Optional) Confirm execution run for verification addendum

## Related Workflows

- **[`02-confirm-execution.md`](./02-confirm-execution.md)** - Validate that implementation matches the plan after execution
- **[`../01-planning/02-finalise-plan.md`](../01-planning/02-finalise-plan.md)** - Create implementation plans before starting execution
- **[`../01-planning/01-plan-review.md`](../01-planning/01-plan-review.md)** - Review plans for correctness before execution
- **[`../05-review/01-code-review.md`](../05-review/01-code-review.md)** - Review code quality after implementation
- **[`../03-debugging/02-bug-fix-workflow.md`](../03-debugging/02-bug-fix-workflow.md)** - Fix bugs discovered during implementation
- **[`../04-documentation/02-sync-documentation.md`](../04-documentation/02-sync-documentation.md)** - Update documentation after code changes
