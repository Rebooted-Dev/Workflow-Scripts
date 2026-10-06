# Workflow: Execution

## Purpose

Execute implementation in phases with verification and documentation updates.

**When to use:** When the user says "execute the plan" or "proceed with this plan."

## Inputs

- Goal and acceptance criteria (user-facing behavior, performance targets, "done" definition)
- Repository root
- Implementation plan (optional, but recommended) — locate under `<metadata-root>/plans/`; resolve the owning repository's metadata root and filename convention via [`naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md#metadata-root-resolution). Use `<metadata-root>/build/` only when host policy explicitly permits it.

## Output

- Implemented code changes
- Updated changelog per the **host repository's documented changelog convention** (see host AGENTS.md or `project/changelog/README.md`)
- Troubleshooting entries only when a bug, issue, or non-trivial problem was fixed (see AGENTS.md); not for simple changes or routine refactors
- Implementation plan under `<metadata-root>/plans/` updated with task list and completion status (`- [✅]` for completed, `- [ ]` plus an `Open:` reason for open, per the [Marking Contract](../00-Meta-Workflow/00-meta/plan-template.md#marking-contract)); resolve its location via [`naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md#metadata-root-resolution)
- Verification evidence: commands run, tests run, smoke/acceptance checks performed (or explicit blockers if something could not be run)
- **Task ticks vs plan completion:** This workflow **must** tick each task (`- [✅]` or `1. [✅]`) as soon as its verification passes. For plans declaring a Tier, use the task's `Verify:` line plus the applicable Verification Bar; for legacy plans without a Tier, use their existing acceptance or exit criteria plus that same Verification Bar. Do not leave verified tasks for a later step to tick. The same applies to `## Success Criteria` items: tick each one when its evidence exists. Anything left `[ ]` gets an `Open:` reason, and `check-plan.sh --state` must pass before each phase report. The **plan-level** completion marker and archive are owned solely by **[`03-mark-completed.md`](../04-documentation/03-mark-completed.md)** (see Finalization).

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
- Identify the plan under `<metadata-root>/plans/`; resolve the metadata root and any host-specific filename convention via [`naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md#metadata-root-resolution). Use `<metadata-root>/build/` only when host policy explicitly permits it.
- Use the shared [`plan-template.md`](../00-Meta-Workflow/00-meta/plan-template.md) contract for the declared tier, Change Surface, and each task's `Files:` and `Verify:` lines.
- For a tiered plan, load the Design and Decision sections required by its declared tier, its Change Surface, and the shared [engineering standards §1–§5](../00-Meta-Workflow/00-meta/engineering-standards.md) before implementation. Treat those tier-required plan sections and applicable standards as build requirements; T1 does not acquire extra Design/Decision sections. Legacy plans keep their existing acceptance/exit criteria plus the Verification Bar and are not retroactively required to add tiered sections.
- Validate the plan from the host repository with `bash <workflow-scripts>/scripts/validation/check-plan.sh --require-tier <plan>` before implementation (path per [`naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md#workflow-scripts-checkout)). Fix reported lines first; a `[x]` tick is an unverified claim, so verify it and make it `[✅]` or reset it to `[ ]`.
- **If the plan has no checkbox task list or no Tier header** (prose steps, or YAML `todos:` from another tool), convert it before implementing, per the [Marking Contract](../00-Meta-Workflow/00-meta/plan-template.md#marking-contract): add a `## Tasks` list with one checkbox per step and the `**Tier:**` header, leave the original text in place, then re-run the lint. Do not execute a plan that has nothing to tick.
- **If the plan has no `## Artifact lifecycle` inventory or terminal filing pair** (older plans), add a proportional inventory and the gate-owned filing pair before implementing — per the [Artifact Lifecycle and Terminal Filing](../00-Meta-Workflow/00-meta/plan-template.md#artifact-lifecycle-and-terminal-filing) contract — using what can be verified from the plan's own outputs (research document, reviews archive, superseded source). Do not upgrade the tier or rewrite history for filing.
- Break work into phases; for each phase define scope, out-of-scope, and **exit criteria that include how success will be verified** (commands, tests, and/or smoke of acceptance criteria—not only "code exists").
- Size any delegation using [`workflow-applicability.md`](../00-Meta-Workflow/00-meta/workflow-applicability.md). When the scope warrants focused roles, options include implementation, security/risk review, breaking-change analysis, and acceptance/test validation; select only what the phase needs and assign non-overlapping ownership. The orchestrator is the only writer of the plan file: sub-agents return verification evidence, and the orchestrator ticks the boxes.

## For Each Phase (Implementation Loop)
- Phase definition (before coding)
  - Scope: what changes in this phase; what is out-of-scope.
  - Expected touch points: key files/areas likely to change.
  - Exit criteria: concrete checks that must pass (map each criterion to the Verification Bar: verify command, tests, smoke, and/or static hygiene).
- Implement
  - Make the smallest change that satisfies the phase scope.
  - Before adding a helper, type, constant, validation, or other behavior, search for an existing implementation or source of truth to reuse; record the search and its result in the phase report per [engineering standards §2](../00-Meta-Workflow/00-meta/engineering-standards.md).
  - After the change, re-run each search in the plan's Change Surface and classify the results. Update the plan when the surface changed; unexplained stale hits leave the affected task incomplete.
  - Record shortcuts or workarounds in the plan's **Deferred & Debt** section with their location, trigger, and severity; do not leave them only in the phase report.
- Review after implementation (before verification)
  - Review the completed change for risks, side effects, breaking changes, unintended impacts, and project conventions; do not make this a pre-implementation gate.
  - Judge boundaries/abstraction, reuse, and error/fallback handling against [engineering standards §1–§3](../00-Meta-Workflow/00-meta/engineering-standards.md) rather than inventing local quality rules.
  - Size any delegated review using [`workflow-applicability.md`](../00-Meta-Workflow/00-meta/workflow-applicability.md). Relevant lenses may include security, performance, test coverage, documentation, integration, and accessibility; use only those that fit the scope.
- Verify (repeat until exit criteria met)
  - **Meet the Verification Bar above** before marking the phase complete. Build/lint alone is insufficient when tests or acceptance smoke apply.
  - Run every applicable check in the Verification Bar. Delegate independent checks only when useful, sized per [`workflow-applicability.md`](../00-Meta-Workflow/00-meta/workflow-applicability.md); possible roles include project verification, automated tests, acceptance/smoke, and static hygiene.
  - Prefer the local dev (or project-documented) command for smoke tests when the project is trusted and the change is user-facing or runtime-dependent.
  - If failures: fix, then re-run the **same** checks only after a meaningful corrective change or new hypothesis. If no evidence-backed next step remains, record the blocker and leave the task incomplete.
- Phase report (immediately after exit criteria met)
  - **CRITICAL: Update the implementation plan** so it reflects reality (completed vs pending vs deferred). For the single source of truth on task marking and completion conventions, follow **[`../04-documentation/03-mark-completed.md`](../04-documentation/03-mark-completed.md)**.
   - **Tick every task whose applicable verification passed in this phase: change `[ ]` to `[✅]` in the plan file now**, before starting the next phase. For a tier-declaring plan, require its task's `Verify:` evidence; for a legacy plan, use its existing acceptance or exit criteria. Both require the applicable Verification Bar. A blocked check leaves only the affected task `[ ]`; it does not stop verified sibling tasks from being ticked. The gate-owned terminal filing task and its paired criterion are the exception: they stay `[ ]` with `Open: pending` — only the gate ticks them, after it verifies the filing ([Artifact Lifecycle and Terminal Filing](../00-Meta-Workflow/00-meta/plan-template.md#artifact-lifecycle-and-terminal-filing)).
   - **Tick criteria too:** tick each `## Success Criteria` item whose evidence now exists — except the paired filing criterion, which stays pending for the gate.
  - **Give every box left `[ ]` an `Open:` reason** (`pending`, `blocked`, `deferred`, or `retired`). For phases not yet started, one `Open: pending` line under the phase heading covers the phase ([Marking Contract](../00-Meta-Workflow/00-meta/plan-template.md#marking-contract)).
  - **Run `bash <workflow-scripts>/scripts/validation/check-plan.sh --state <plan>`** and fix every reported line before writing the phase summary. A reported line is either a missed tick or a missing reason; decide which from the evidence.
  - Include brief verification evidence in the phase summary (commands/tests/smoke + result).
  - Record the phase checkpoint and rollback reference per [engineering standards §5](../00-Meta-Workflow/00-meta/engineering-standards.md): use the verified-phase commit SHA when commits are authorized; otherwise record a `git stash create` reference or diff hash.
  - **Update logs (only for completed tasks that change or affect project code):**
    - **Which repository:** log in the metadata root of the repository that **owns the changed files** ([Metadata Root Resolution](../00-Meta-Workflow/00-meta/naming-conventions.md#metadata-root-resolution)). Workflow-Scripts changes go to its `00-project/`, even from a host-project session; there, a workflow defect counts as a bug.
    - **Changelog:** Add a dated entry for this phase's work per the host repository's documented changelog convention (see host AGENTS.md or `project/changelog/README.md`).
    - **Troubleshooting (only when applicable):** Add a troubleshooting entry **only** when this phase involved one of the following (see AGENTS.md and `troubleshooting/README.md` for full conventions):
      - **Add an entry when:** You fixed a **bug** (incorrect behavior or crash), resolved an **issue** that required debugging or a workaround, or solved a **non-trivial problem** (significant investigation, multiple steps, or lessons worth preserving — e.g. complex config, unexpected framework behavior, tricky debugging).
      - **Do not add an entry when:** The work was a simple code change, routine refactor, or straightforward feature addition with no real problem-solving. Changelog is enough.
      - When you do add an entry: create a file under `<metadata-root>/troubleshooting/<category>/` named `YYYY-MM-DD-<category>-<short-title>.md`, update `troubleshooting/index.md` (new row at top), and include Date, Category, Status, Symptom, Root Cause, Fix, Verification, Notes/Lessons.
  - Provide a concise summary (1-3 bullets) describing what changed and why, plus verification outcome.

## Finalization (After All Phases)

- Re-run the Verification Bar for the whole change set: project verify command, automated tests when present, and acceptance/smoke for user-facing or runtime behavior. Confirm the repo is shippable against the plan's acceptance criteria; if no verify/test command exists, state that explicitly.
- Sanity-check for secrets/unintended files before committing (do not commit `.env*` or credentials).
- **Terminal gate (always):** Run [`03-mark-completed.md`](../04-documentation/03-mark-completed.md) at the end of every execution. Use **Full completion** mode when the whole plan is verified complete (it adds the plan-level marker and files the completed **package** — the plan plus the task-exclusive artifacts in its `## Artifact lifecycle` inventory); otherwise use **Reconcile only** mode (it ticks verified tasks and reconciles logs; the plan stays active). Hand the gate the updated inventory together with the verification evidence; execution itself moves no artifacts and never ticks the filing pair.
- Optionally run [`02-confirm-execution.md`](./02-confirm-execution.md) to audit completion against the plan **before** the gate (recommended when using this workflow alone without [`03-execute-and-confirm.md`](./03-execute-and-confirm.md)). Confirmation may downgrade false claims and append evidence; it does not finalize or archive.

## Quick Checklist

- [ ] Goal and acceptance criteria confirmed
- [ ] Repo state checked (`git status`)
- [ ] Plan identified under `<metadata-root>/plans/` (or host-permitted `<metadata-root>/build/`), resolved via [`naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md#metadata-root-resolution)
- [ ] Each phase: implement → task `Verify:` (tier-declaring plan) or existing acceptance/exit criteria (legacy plan), plus the **Verification Bar** → update plan (`- [✅]` / `- [ ]`) and logs (changelog; troubleshooting only if bug/issue/non-trivial fix — see phase report)
- [ ] Phase exit criteria include how success is verified; skipped checks recorded as blockers, not success
- [ ] Final Verification Bar passes for the full change set; no secrets in diff
- [ ] Every verified task and criterion ticked `[✅]` in the plan file; every other box has an `Open:` reason; `check-plan.sh --state` passes; gate [`03-mark-completed.md`](../04-documentation/03-mark-completed.md) run (Full completion or Reconcile only); completion marker/archive only via the gate
- [ ] (Optional) Confirm execution run for verification addendum

## Related Workflows

- **[`02-confirm-execution.md`](./02-confirm-execution.md)** - Validate that implementation matches the plan after execution
- **[`../01-planning-and-organizing/02-finalise-plan.md`](../01-planning-and-organizing/02-finalise-plan.md)** - Create implementation plans before starting execution
- **[`../01-planning-and-organizing/01-plan-review.md`](../01-planning-and-organizing/01-plan-review.md)** - Review plans for correctness before execution
- **[`../05-review/01-code-review.md`](../05-review/01-code-review.md)** - Review code quality after implementation
- **[`../03-debugging/02-bug-fix-workflow.md`](../03-debugging/02-bug-fix-workflow.md)** - Fix bugs discovered during implementation
- **[`../04-documentation/02-sync-documentation.md`](../04-documentation/02-sync-documentation.md)** - Update documentation after code changes
