# 2026-07-06 - Drag-Free-v2 Workflow Skill Layer Plan

**Status:** Completed in archive remediation on 2026-07-06
**Scope:** Workflow-Scripts system work only. `<metadata-root>` resolves to `00-project/`.
**Reference:** `2026-07-06-drag-free-v2-unified-implementation-plan.md`

---

## Summary

Add a first-class skill layer to `Workflow-Scripts` so workflows automatically point agents to the right operational skill, quality standard, role contract, and bookkeeping behavior.

This extends the Drag-Free-v2 architecture without creating a second source of truth: workflows remain canonical, `11-Skills/` stays as the hand-authored baseline during migration, and `tools/wf build skills` later generates cross-harness skill bundles from workflow frontmatter and shared `core/` sources.

## Key Changes

- Add a workflow `skills:` frontmatter contract to active workflow files:

```yaml
skills:
  primary: workflow-plan-review-finalize
  required:
    - workflow-intake-and-routing
    - repo-records-and-filing
  conditional:
    - skill: delegated-agent-orchestration
      when: "parallel agents, multi-model review, or role fan-out is used"
    - skill: engineering-quality-gates
      when: "implementation, review, security, architecture, or T2/T3 planning"
```

- Update `tools/wf validate` to verify that every referenced skill resolves to `11-Skills/<skill>/SKILL.md`, has valid frontmatter, has matching `agents/openai.yaml`, and does not reference stale workflow paths.
- Update workflow instructions to include a compact generated **Skill Hooks** section near the top:
  - use the primary skill for this workflow;
  - load required skills before action;
  - load conditional skills only when their condition is true.
- Preserve current `11-Skills/*` as source-quality baselines until generated bundles are reviewed and accepted; do not delete or replace them in the initial implementation.

## Skill Files To Add Or Refactor

### `11-Skills/workflow-intake-and-routing/SKILL.md`

Purpose: resolve user intent to repo root, metadata root, workflow file, plan/report paths, and required next workflow.

Used by: all major workflows through `skills.required`.

Must enforce:

- exact path first, path-drift search second;
- `<metadata-root>` routing;
- Workflow-Scripts-system work to `00-project/`;
- consumer-project work to root-level `project/`.

### `11-Skills/engineering-quality-gates/SKILL.md`

Purpose: apply `core/standards/code-design.md`, `error-handling.md`, `observability.md`, and `security-baseline.md` before implementation and during review.

Used by: `00-research-and-plan`, `01-plan-review`, `01-execution`, `02-confirm-execution`, code review, refactoring review, security review, greenfield/design workflows.

Must enforce:

- T1/T2/T3 plan tier behavior;
- quality sections in T2/T3 plans;
- symmetrical "build to this, review against this" standards.

### `11-Skills/repo-records-and-filing/SKILL.md`

Refactor or replace current `repo-logs-and-docs-sync` if overlap is high.

Purpose: changelog, troubleshooting, plan status, completed-plan filing, index updates, stale-link checks.

Used by: execution, confirm, mark-completed, bug-fix, documentation, and any workflow that mutates repo records.

Must enforce:

- one-file-per-entry logs;
- newest index rows first;
- troubleshooting only for bugs and non-trivial issues;
- completed plans under `<metadata-root>/plans-completed/<category>/`.

### `11-Skills/delegated-agent-orchestration/SKILL.md`

Refactor current `multi-agent-plan-orchestration`.

Purpose: single-writer orchestration, role registry loading, isolated helper outputs, manifest/protected-source-hash discipline.

Used by: plan review, research, code review, security review, comprehensive audit, future `wf run`.

Must enforce:

- 3-6 helper cap by default;
- role IDs from `core/roles/`;
- honest blocked/unavailable harness reporting.

### `11-Skills/workflow-skill-maintainer/SKILL.md`

Purpose: create, update, validate, and parity-check Workflow-Scripts skills.

Used by: Drag-Free-v2 skill work, future `wf build skills` implementation, review of generated Codex/Claude/OpenCode/Droid bundles.

Must enforce:

- concise skill bodies;
- valid `name` and `description`;
- matching `agents/openai.yaml`;
- no duplicated long workflow prose;
- no extra README-style clutter.

### Existing Task Skills

Keep existing task skills, but map them into the new contract:

- `workflow-plan-review-finalize`
- `execute-and-confirm-plan`
- `workflow-bug-fix-plan-and-logs`
- `filed-code-review-to-remediation`
- `dirty-worktree-safe-publish`
- domain-specific audit/debug skills where still useful.

## Implementation Plan

### Phase 1 - Inventory And Map Current Workflows

**Archive remediation status:** Completed for the pilot workflows. The active workflow-to-skill contract is now represented in `workflows/planning/`, `workflows/build/`, `workflows/debugging/`, `workflows/review/`, and `workflows/security/`.

- Build a table in the Drag-Free-v2 plan set listing each active workflow, primary skill, required skills, conditional skills, standards, and role families.
- Start with pilot workflows:
  - research and plan;
  - plan review;
  - execution;
  - confirm execution;
  - bug fix;
  - code review;
  - security review.

### Phase 2 - Add The New Skill Contract

**Archive remediation status:** Completed with `skills.primary`, `skills.required`, and `skills.conditional` frontmatter on the pilot workflows, plus `scripts/validation/check-workflow-skills.sh` because the archive does not contain `tools/wf`.

- Extend the Drag-Free-v2 frontmatter schema with `skills.primary`, `skills.required`, and `skills.conditional`.
- Add validation for:
  - unknown skill IDs;
  - missing `SKILL.md`;
  - missing or stale `agents/openai.yaml`;
  - duplicate trigger descriptions;
  - skill names that do not match folder names.
- Keep validation in `tools/wf` using Python standard library only.

### Phase 3 - Create Or Refactor Core Skill Files

**Archive remediation status:** Completed. Added `workflow-intake-and-routing`, `engineering-quality-gates`, `repo-records-and-filing`, `delegated-agent-orchestration`, and `workflow-skill-maintainer` under `11-Skills/` with matching `agents/openai.yaml`.

- Add the five new/refactored skills under `11-Skills/`.
- Keep each `SKILL.md` concise and imperative.
- Put detailed policy in `core/` partials and reference those from skills instead of duplicating prose.
- Generate or refresh `agents/openai.yaml` for each skill.

### Phase 4 - Wire Workflows To Skills

**Archive remediation status:** Completed for research/plan, plan review, execute, confirm, execute-and-confirm, bug fix, code review, and security review.

- Add `skills:` frontmatter to the pilot workflow set.
- Insert generated or manually matching **Skill Hooks** sections near the top of each pilot workflow.
- Replace ad-hoc "remember to use..." prose with references to primary, required, and conditional skills.
- Do not physically move workflow directories in this pass.

### Phase 5 - Add Generated Routing Surfaces

**Archive remediation status:** Partially blocked. The archive lacks `tools/wf`, so generated `catalog.json`, `ROUTER.md`, and `tools/wf route` behavior could not be regenerated. Expected route output for `execute this approved plan` is documented in `logs/2026-07-06-archive-tools-wf-route-execute-approved-plan.txt`.

- Update `tools/wf build` to include skill mappings in `catalog.json` and `ROUTER.md`.
- Add README tables showing workflow-to-skill mappings.
- Add `tools/wf route "<task>"` output that includes:
  - workflow path;
  - primary skill;
  - required skills;
  - conditional skill hints;
  - next workflow.

### Phase 6 - Prepare For Generated Bundles

**Archive remediation status:** Blocked on missing `tools/wf build skills` source. Hand-authored `11-Skills/` sources were completed and validated with the archive fallback validator.

- Define `tools/wf build skills` output shape, but keep generation behind parity checks:

```text
dist/codex/skills/<id>/SKILL.md
dist/codex/skills/<id>/agents/openai.yaml
dist/claude/skills/<id>/SKILL.md
```

- Leave OpenCode and Droid targets as future outputs unless the accepted harness contract requires them in the same phase.
- Compare generated Codex bundles against `11-Skills/*` before accepting deletion or retirement of hand-authored sources.

### Phase 7 - Log The Implementation

**Archive remediation status:** Completed with `00-project/changelog/added/2026-07-06-added-workflow-skill-layer-archive-remediation.md`, index updates, and refreshed validation logs.

- Because this changes Workflow-Scripts behavior, add a changelog entry under `00-project/changelog/`.
- Add troubleshooting only if implementation uncovers a validator, generation, or routing bug that required real debugging.

## Test Plan

Run existing validators from the nested repo root:

```bash
scripts/validation/check-active-markdown-links.sh
scripts/validation/check-orchestrator-review.sh
scripts/validation/check-review-workflow-policy.sh
scripts/validation/check-sync-workflow-scripts.sh
scripts/validation/check-update-workflows.sh
git diff --check
```

Add `scripts/validation/check-workflow-skills.sh` or fold checks into `check-wf-cli.sh`.

Acceptance scenarios:

- A workflow referencing a missing skill fails validation.
- A skill folder whose name differs from frontmatter `name` fails validation.
- `tools/wf route "execute this approved plan"` returns `02-code-build/03-execute-and-confirm.md`, `execute-and-confirm-plan`, `workflow-intake-and-routing`, `engineering-quality-gates`, and `repo-records-and-filing`.
- `tools/wf route "review this codebase"` returns the code-review workflow plus review, quality, and orchestration skill hooks.
- Generated `catalog.json` and `ROUTER.md` include skill mappings and fail freshness checks when edited by hand.
- Pilot workflows remain usable by reading only their Skill Hooks plus referenced skills and core partials.
- Generated Codex skill bundle output is diff-reviewed against current `11-Skills` baselines before any hand-authored skill is retired.

## Assumptions

- This is Workflow-Scripts-system work, so implementation artifacts and logs resolve to `00-project/`.
- `11-Skills/` remains the editable skill source during the first pass; `dist/` generated bundles become authoritative only after parity review.
- Workflow Markdown remains canonical; skill files are operational condensations and routing aids, not competing workflow specs.
- No UI changes are involved.
- Physical directory rationalization stays deferred until the broader Drag-Free-v2 validation/build/router work is stable.
