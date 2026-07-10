# 2026-07-06 - Drag-Free-v2 Unified Implementation Plan

**Status:** Reviewed, finalised, implemented, and verified complete
**Scope:** Workflow-Scripts system work only. `<metadata-root>` resolves to `00-project/`.
**Execution output directory:** `/Users/jesse/Development/Personal/Update-AI-Tools/Drag-Free-v2`
**Evidence base:** the five Drag-Free-v2 source artifacts preserved under `research-papers/`:
- `research-papers/2026-07-06-workflow-system-v2-redesign-proposal.md`
- `research-papers/2026-07-06-engineering-quality-and-lifecycle-proposal.md`
- `research-papers/workflow-scripts-survey-260706-1200-gpt55.md`
- `research-papers/workflow-token-and-roles-survey-260706-0120-gpt55.md`
- `research-papers/workflow-engineering-quality-survey-260706-0137-gpt55.md`

## Implementation Status

- [✅] Phase 0 - Reconcile And Finalize Drag-Free-v2
- [✅] Phase 1 - Machine-Readable Foundation
- [✅] Phase 2 - Core Partials, Token Reduction, And Role Contracts
- [✅] Phase 3 - Engineering Quality Lifecycle
- [✅] Phase 4 - Bookkeeping Automation
- [✅] Phase 5 - Delegation, Harnesses, And Telemetry
- [✅] Phase 6 - Directory Rationalization

---

## 1. Proposal

Drag-Free-v2 should convert Workflow-Scripts from a prose-only instruction library into a compiled, tool-supported workflow system while preserving the current markdown-first operating model.

The current system works because it has good conventions: metadata-root routing, one-file-per-entry logs, plan review/finalise/execute/confirm lifecycle, shared severity and priority rubric, and parallel review discipline. Its drag comes from the fact that those conventions are enforced by memory and repeated prose. Agents must manually route tasks, update indexes, move completed plans, reconcile duplicated rules, and infer role contracts from free-text role names.

The recommended v2 architecture keeps markdown as the source of truth, but adds:

- frontmatter contracts for routing and validation;
- generated `catalog.json`, `ROUTER.md`, README tables, and ledger indexes;
- shared `core/` partials so each rule is written once;
- a dependency-free `wf` CLI for mechanical chores;
- a canonical role registry for sub-agent contracts;
- engineering-quality standards that are referenced before build and during review;
- manifest-based delegated runs and telemetry;
- delayed directory rationalization after compatibility is proven.

The main implementation rule is: **make the system machine-checkable before moving files or rewriting content.** Directory reshaping is last because it is mostly cosmetic once routing and validation exist, and moving first would churn every in-flight plan reference.

---

## 2. Design Decisions

| Decision | Default |
|---|---|
| Plan ownership | This is Workflow-Scripts-system work, so artifacts live under `Workflow-Scripts/00-project/`. |
| Runtime dependency | Use Python standard library for `tools/wf`; no package manager, daemon, database, server, or network dependency. |
| Source format | Markdown remains the readable runtime. YAML frontmatter is the machine contract. |
| Generated artifacts | Commit generated router/catalog/indexes with `DO NOT EDIT` banners and enforce freshness with `wf build --check`. |
| Path moves | Defer physical directory rationalization until validation, generated routing, CLI compatibility, and redirect maps are stable. |
| Existing scripts | Preserve old script entrypoints as wrappers during migration. |
| Multi-model orchestration | Do not redefine the July 3 multi-model fan-out plan; host its manifest/artifact contract and launcher interfaces after that plan lands. |
| Completion marker | Preserve the intentional `- [✅]` marker. |
| Changelog | Log Workflow-Scripts changes in `00-project/changelog/`; add troubleshooting only for bugs or non-trivial issue fixes. |

---

## 3. Target Architecture

### 3.1 Source Layout During Early Phases

Early phases should not move existing workflow directories. Add new sources alongside the current tree:

```text
Workflow-Scripts/
  tools/
    wf
  core/
    metadata-root.md
    filing-and-logging.md
    parallel-agents.md
    verification-gates.md
    artifact-contract.md
    roles/
    standards/
  templates/
  catalog.json
  ROUTER.md
```

The existing numbered directories remain in place through Phase 5:

```text
00-project-setup/
01-planning-and-organizing/
02-code-build/
03-debugging/
04-documentation/
05-review/
06-security/
07-deployment/
08-API-Integration/
10-technical-docs/
11-Skills/
12-SEO-GEO-checklist/
00-Meta-Workflow/
```

### 3.2 Final Layout After Stabilization

Phase 6 may move the tree to:

```text
Workflow-Scripts/
  ROUTER.md
  README.md
  catalog.json
  core/
  workflows/
    setup/
    planning/
    build/
    debug/
    docs/
    review/
    security/
  reference/
  tools/
  templates/
  dist/
  00-project/
```

This move is acceptable only after `catalog.json` has redirect metadata, `MOVED.md` exists, and validators prove old-path references are either corrected or intentionally redirected.

---

## 4. Public Interfaces And Contracts

### 4.1 Frontmatter Contract

Every active source file gets a small YAML frontmatter block. Minimum workflow shape:

```yaml
---
id: plan-review
version: 2.0
category: planning
kind: workflow
triggers:
  - "review this plan"
  - "check plan before execution"
inputs: [plan-path]
outputs:
  - type: addendum
    location: in-place
agents:
  min: 1
  max: 4
  core: [plan-reviewer]
  triggered: [architect, test-strategist, security-scanner]
requires:
  - severity-priority-rubric
  - metadata-root
next: [finalise-plan]
prev: [research-and-plan]
harnesses: [claude, codex, opencode, droid]
---
```

Kinds:

- `workflow` - executable agent workflow.
- `reference` - guide or reference material.
- `template` - output scaffold loaded on demand.
- `policy` - shared rule or convention.
- `role` - sub-agent contract.

### 4.2 `wf` CLI Contract

`tools/wf` is a single dependency-free executable. It must support `--help`, deterministic output, and non-zero exit codes on validation/build failures.

Phase 1 commands:

```bash
tools/wf validate
tools/wf build
tools/wf build --check
tools/wf route "review this implementation plan"
```

Phase 4 commands:

```bash
tools/wf new plan drag-free-v2
tools/wf log docs "File Drag-Free-v2 unified plan"
tools/wf trouble workflow-routing drag-free-v2-routing-drift
tools/wf file-completed 00-project/plans/example.md implementation
tools/wf debt add
tools/wf debt list
tools/wf sync --status
```

Phase 5 commands:

```bash
tools/wf run plan-review -m codex/gpt-5.5 --focus feasibility
tools/wf build skills
tools/wf stats
```

### 4.3 Generated Artifacts

- `catalog.json` is the machine-readable index of all frontmatter records.
- `ROUTER.md` is the compact agent entry point.
- README/category tables are rendered views from `catalog.json`.
- Ledger indexes are rendered from entry frontmatter.
- `dist/` harness bundles are generated from workflow sources plus referenced partials.

Generated files must include a banner:

```text
<!-- Generated by tools/wf build. Do not edit by hand. -->
```

### 4.4 Core Partials

Shared rules move into `core/` and are referenced by ID:

- `core/metadata-root.md` - path resolution and artifact locations.
- `core/filing-and-logging.md` - changelog, troubleshooting, plan filing, indexes.
- `core/parallel-agents.md` - 3-6 agent cap, role loading, reconciliation.
- `core/verification-gates.md` - evidence tiers, verification requirements, acceptance proof.
- `core/artifact-contract.md` - manifest, single-writer, protected-source hash, run directory shape.

Rules must not be restated inline after extraction. Workflows can summarize intent in one sentence and link the partial.

### 4.5 Role Registry

Each role is a file under `core/roles/`:

```yaml
---
id: security-scanner
kind: role
mission: Find auth, input-handling, secrets, and dependency vulnerabilities in scoped files.
triggers: [auth code present, user input processed, secrets/config files in scope]
inputs: [file scope, focus areas]
output: findings
evidence: rubric-tiers
tools: read-only
tier: strong
verify: different-model
---
```

Initial canonical role families:

- `architect`
- `bug-hunter`
- `security-scanner`
- `performance-analyst`
- `refactoring-reviewer`
- `accessibility-reviewer`
- `compliance-reviewer`
- `dependency-researcher`
- `external-docs-researcher`
- `test-strategist`
- `implementer`
- `test-writer`
- `resilience-reviewer`
- `observability-auditor`
- `docs-writer`

Free-text role menus should be replaced with role IDs plus optional trigger conditions.

### 4.6 Engineering Standards

Add standards under `core/standards/`:

- `code-design.md`
- `error-handling.md`
- `observability.md`
- `security-baseline.md`

These standards are referenced by both:

- planning/execution workflows as build requirements;
- review/security workflows as judging criteria.

This closes the current gap where quality is found by review after implementation rather than specified before implementation.

---

## 5. Phased Implementation Plan

### Phase 0 - Reconcile And Finalize Drag-Free-v2

**Objective:** Convert the five Drag-Free-v2 artifacts into one accepted implementation plan while preserving the source evidence.

**Changes:**

- Keep the five existing source evidence files (now under `workflows-drag-free/00-project/research/`; formerly `00-project/plans/Drag-Free-v2/research/`).
- Use this unified plan as the canonical handoff for review and implementation.
- Update `00-project/plans/TODO.md` only if the active task list should point at this unified plan instead of the earlier proposal.
- Run the existing plan-review/finalise lifecycle before code/doc implementation begins:
  - `01-planning-and-organizing/01-plan-review.md`
  - `01-planning-and-organizing/02-finalise-plan.md`

**Exit criteria:**

- One unified Drag-Free-v2 plan exists in this directory.
- The source proposals remain available and are not overwritten.
- The unified plan is reviewed before implementation.

### Phase 1 - Machine-Readable Foundation

**Objective:** Make workflows discoverable and validatable before changing behavior.

**Implementation:**

- Create `tools/wf`.
- Define a JSON-schema-like internal contract for frontmatter. Keep it implemented in stdlib Python so no dependency install is required.
- Add frontmatter to active workflow and reference files without moving them.
- Implement `tools/wf validate` checks:
  - required frontmatter fields;
  - unique `id`;
  - valid `kind`;
  - valid references in `prev`, `next`, `requires`, and role IDs;
  - local markdown links;
  - stale path names such as `02-build-code`;
  - ambiguous artifact defaults such as root `plans/`, bare `plans-completed/`, `project/build/`, and default `changelog/plans/`;
  - generated files are not hand-edited when `--check` is used.
- Implement `tools/wf build` outputs:
  - `catalog.json`;
  - `ROUTER.md`;
  - generated tables for root/category README files.
- Implement `tools/wf route "<task>"` using frontmatter triggers and category metadata.
- Add CI workflow or local validation script that runs:
  - `tools/wf validate`;
  - `tools/wf build --check`;
  - existing `scripts/validation/*.sh`;
  - `git diff --check`.

**Exit criteria:**

- `tools/wf validate` passes from the Workflow-Scripts repo root.
- `catalog.json` and `ROUTER.md` are generated and committed.
- An agent can route common tasks by reading `ROUTER.md`, not the full README.
- Known broken/stale references are either fixed or explicitly flagged.

### Phase 2 - Core Partials, Token Reduction, And Role Contracts

**Objective:** Remove duplicated instruction prose and define sub-agent outputs as contracts.

**Implementation:**

- Create `core/metadata-root.md` as the only path-resolution authority:
  - explicit output dir wins;
  - `00-project/` for Workflow-Scripts-system work;
  - `project/` for consumer projects;
  - otherwise tell the user to run/setup project metadata.
- Extract repeated rules into:
  - `core/filing-and-logging.md`;
  - `core/parallel-agents.md`;
  - `core/verification-gates.md`;
  - `core/artifact-contract.md`.
- Update workflows to reference these partials instead of restating them.
- Move long output templates and example pairs into `templates/`.
- Remove per-file "When to Use" and "Related Workflows" boilerplate once `ROUTER.md` covers routing.
- Add a duplication linter to `tools/wf validate`:
  - marker phrases from each core partial may appear in only the partial source;
  - exception list allowed only for historical/archive files.
- Create `core/roles/` and consolidate ad-hoc role names into canonical role contracts.
- Extend workflow frontmatter with:

```yaml
agents:
  min: 1
  max: 6
  core: [bug-hunter, security-scanner]
  triggered:
    - role: performance-analyst
      when: "hot path, profiling evidence, or user-reported slowness"
```

**Exit criteria:**

- Review/security/planning workflows no longer restate shared review core rules.
- Role menus are replaced by role IDs.
- Every role referenced by a workflow resolves to `core/roles/<id>.md`.
- Median workflow token count decreases, with before/after counts recorded for pilot files.

### Phase 3 - Engineering Quality Lifecycle

**Objective:** Move engineering quality from retrospective review checklists into planning and implementation.

**Implementation:**

- Create `core/standards/code-design.md` covering:
  - module boundaries;
  - information hiding;
  - encapsulation and invariants;
  - narrow interfaces;
  - type safety;
  - memory/resource safety;
  - deterministic cleanup;
  - immutability by default;
  - dependency direction.
- Create `core/standards/error-handling.md` covering:
  - error taxonomy;
  - no silent failures;
  - fallback logging/counting;
  - retry budgets and backoff;
  - user-facing error expectations;
  - crash vs degrade decisions.
- Create `core/standards/observability.md` covering:
  - structured logging;
  - correlation/request IDs when relevant;
  - health/readiness signals;
  - startup/shutdown/config logging with secrets redacted;
  - error reporting;
  - metrics/tracing only when triggered by system needs.
- Create `core/standards/security-baseline.md` covering:
  - secrets hygiene;
  - dependency audit per ecosystem;
  - input validation at trust boundaries;
  - least-privilege defaults;
  - CI scanner expectations.
- Update execution workflows to load standards and treat them as implementation exit criteria.
- Update review/security workflows to judge against the same standards rather than separate ad-hoc lists.
- Add tiered quality sections to the plan template:
  - `Design & Interfaces`;
  - `Error-Handling Strategy`;
  - `Test Strategy`;
  - `Observability Plan`;
  - `Rollout & Rollback`.
- Add plan tier frontmatter or header:

```yaml
tier: T1 # T1 fix/small, T2 feature, T3 system/greenfield
```

- Create architecture/design workflow:
  - design brief;
  - boundary design;
  - interface/contract sketches;
  - ADRs under `<metadata-root>/decisions/`;
  - optional T2, required T3 design review.
- Create greenfield MVP workflow:
  - product brief;
  - architecture/design;
  - walking skeleton;
  - strict type/lint/test config;
  - CI;
  - observability baseline;
  - first production deployment;
  - vertical feature slices;
  - MVP gate.
- Create generic deploy workflow `07-deployment/00-deploy.md`.
- Create debt ledger contract under `<metadata-root>/debt/`.

**Exit criteria:**

- `02-code-build/01-execution.md` has concrete standards behind "code quality".
- T2/T3 plans include quality sections.
- New T3 work has design brief and ADR output.
- Generic deployment has a repeatable workflow before tech-specific guides.
- Debt can be recorded at the moment a shortcut is taken.

### Phase 4 - Bookkeeping Automation

**Objective:** Turn repeated manual filing and logging chores into atomic commands.

**Implementation:**

- Add frontmatter to changelog, troubleshooting, plans-completed, decisions, and debt entries.
- Generate indexes from entry files:
  - `00-project/changelog/index.md`;
  - `00-project/troubleshooting/index.md`;
  - `00-project/plans-completed/index.md`;
  - future `00-project/decisions/index.md`;
  - future `00-project/debt/index.md`.
- Implement:

```bash
tools/wf new plan <slug>
tools/wf log <type> "<title>"
tools/wf trouble <category> <slug>
tools/wf file-completed <plan> <category>
tools/wf debt add
tools/wf debt list
```

- `wf file-completed` must:
  - verify the source plan exists;
  - move it to `<metadata-root>/plans-completed/<category>/`;
  - create/update the completed-plan entry;
  - create changelog Type=`plan` entry;
  - update generated indexes;
  - refuse to continue if target files already exist unless `--force` is explicit.
- Wrap current sync helpers through `wf sync`:
  - `scripts/pull-workflows.sh`;
  - `scripts/update-workflows.sh`;
  - `scripts/sync-workflow-scripts.sh`.
- Keep old scripts as compatibility wrappers.

**Exit criteria:**

- Completed plan filing is one command.
- Indexes are generated, not manually edited.
- Existing script tests still pass.
- Manual fallback remains documented for agents without CLI execution.

### Phase 5 - Delegation, Harnesses, And Telemetry

**Objective:** Generalize delegated runs and generated harness bundles.

**Dependencies:**

- The July 3 multi-model plan's artifact/manifest contracts.
- The July 4 harness concept test results.

**Implementation:**

- Promote the accepted manifest/artifact contract into `core/artifact-contract.md`.
- Implement `tools/wf run` for single-model launches first.
- Preserve single-writer discipline:
  - orchestrator is sole writer of `_manifest.json`;
  - each pass writes one assigned artifact;
  - protected source hash is captured before and after;
  - git-clean checks detect unexpected writes;
  - blocked/unavailable harnesses are recorded honestly.
- Map role registry hints into launcher behavior:
  - `tier` selects model class where available;
  - `verify: different-model` schedules verification;
  - role IDs are recorded in `_manifest.json`.
- Port `orchestrator-review.sh` behavior into `wf run plan-review`.
- Keep `orchestrator-review.sh` as a wrapper until parity is verified.
- Implement `tools/wf build skills`:
  - use current `11-Skills/*/SKILL.md` content as the condensation quality baseline;
  - generate Claude, Codex, OpenCode, and Droid-compatible bundles under `dist/`;
  - do not delete `11-Skills/` until generated output is reviewed and accepted.
- Implement `tools/wf stats` over run manifests:
  - runs per workflow;
  - status by harness/model;
  - duration;
  - role IDs;
  - confirmed-vs-noise findings when verification data exists.

**Exit criteria:**

- `wf run plan-review` reproduces current orchestrator behavior.
- Every delegated run emits a conforming manifest.
- Generated skill bundles match or improve current `11-Skills` operational content.
- `wf stats` can answer which workflows/roles/models are actually useful.

### Phase 6 - Directory Rationalization

**Objective:** Move to a cleaner layout only after the system can validate and redirect references.

**Implementation:**

- Move workflow categories into `workflows/<area>/`.
- Move reference guides into `reference/`.
- Merge `00-Meta-Workflow/00-meta` into `core/`.
- Move tooling into `tools/`.
- Keep `00-project/` unchanged.
- Generate:
  - `MOVED.md`;
  - old-path to new-path table in `catalog.json`;
  - compatibility notes in `README.md` and `SHARING_AND_SYNC.md`.
- Keep old-path wrappers or redirect stubs for one release cycle.
- Run full validation and stale-path checks after every move batch.

**Exit criteria:**

- New layout is live.
- Old paths are either redirected or fail with clear guidance.
- One release cycle passes with no stale-path validation failures.

---

## 6. Test And Verification Plan

### Existing Validators

Run from the Workflow-Scripts repo root:

```bash
scripts/validation/check-active-markdown-links.sh
scripts/validation/check-orchestrator-review.sh
scripts/validation/check-review-workflow-policy.sh
scripts/validation/check-sync-workflow-scripts.sh
scripts/validation/check-update-workflows.sh
git diff --check
```

### New Validator

Add `scripts/validation/check-wf-cli.sh` with temp fixtures for:

- frontmatter parsing;
- duplicate workflow IDs;
- invalid kind values;
- local link checks;
- stale path detection;
- generated router/catalog freshness;
- generated index correctness;
- `file-completed` atomic behavior;
- role ID validation;
- debt/ADR entry indexing.

### Pilot Conversions

Convert and validate one file from each family before broad rollout:

- planning: `01-planning-and-organizing/00-research-and-plan.md`;
- build: `02-code-build/01-execution.md`;
- debugging: `03-debugging/02-bug-fix-workflow.md`;
- documentation: `04-documentation/03-mark-completed.md`;
- review: `05-review/01-code-review.md`;
- security: `06-security/01-security-review.md`.

### Acceptance Scenarios

1. **Routing:** `tools/wf route "review this plan"` returns the plan-review workflow and its next/finalise relationship.
2. **Validation:** a fixture with `../02-build-code/` fails stale-path validation.
3. **Generated freshness:** editing `ROUTER.md` by hand causes `tools/wf build --check` to fail.
4. **Role contract:** a workflow references `security-scanner`; validation confirms `core/roles/security-scanner.md` exists.
5. **Filing:** `tools/wf file-completed` moves a fixture plan and regenerates indexes.
6. **Debt:** `tools/wf debt add` creates a debt entry that appears in the generated debt index.
7. **Delegation:** a two-pass `wf run` fixture writes a manifest and prevents pass-level manifest writes.
8. **Directory migration:** after Phase 6, old-path references are either redirected or reported by validation.

---

## 2026-07-06 13:08 - Execute And Confirm Addendum (Model: GPT-5)

### What Was Executed

- Phase 0 was reconciled and finalised:
  - the unified plan now points to the preserved `research-papers/` evidence paths;
  - source proposals and surveys remain available under `workflows-drag-free/00-project/research/` (relocated 2026-07-10 from `00-project/plans/Drag-Free-v2/`);
  - the requested generated-output run log was created at `/Users/jesse/Development/Personal/Update-AI-Tools/Drag-Free-v2/2026-07-06-execute-and-confirm-log.md`.
- Phase 1 machine-readable foundation was completed:
  - added `tools/wf`;
  - added v2 frontmatter to 110 active workflow/reference/template/policy files;
  - generated `catalog.json`, `ROUTER.md`, and README/category tables;
  - added `scripts/validation/check-wf-cli.sh` with temp fixture coverage for parsing, duplicate IDs, invalid kinds, stale references, broken local links, route matching, and generated freshness;
  - fixed `scripts/validation/check-active-markdown-links.sh` so local markdown links with `:line` suffixes validate correctly.
- Workflow-Scripts bookkeeping was updated:
  - `00-project/changelog/added/2026-07-06-added-wf-cli-foundation.md`;
  - `00-project/troubleshooting/validation/2026-07-06-validation-markdown-line-links.md`;
  - changelog and troubleshooting indexes updated.

### Commands Run

- `tools/wf validate`
- `tools/wf build`
- `tools/wf build --check`
- `tools/wf route "review this plan"`
- `tools/wf init-frontmatter --check`
- `tools/wf prune-skipped-frontmatter --check`
- `scripts/validation/check-wf-cli.sh`
- `scripts/validation/check-active-markdown-links.sh`
- `scripts/validation/check-orchestrator-review.sh`
- `scripts/validation/check-review-workflow-policy.sh`
- `scripts/validation/check-sync-workflow-scripts.sh`
- `scripts/validation/check-update-workflows.sh`
- `git diff --check`

### Verification Result

- Phase 0 is verified complete.
- Phase 1 is verified complete against its current exit criteria:
  - `tools/wf validate` passes from the Workflow-Scripts repo root and validates 110 frontmatter records.
  - `catalog.json`, `ROUTER.md`, and generated README/category tables are fresh under `tools/wf build --check`.
  - `tools/wf route "review this plan"` returns the plan-review workflow.
  - Known stale path, ambiguous artifact default, and broken local-link findings are explicitly flagged in `/Users/jesse/Development/Personal/Update-AI-Tools/Drag-Free-v2/2026-07-06-wf-validate-phase1.txt` for follow-up cleanup before strict full-library enforcement.

### Next Steps

1. Start Phase 2 core partial extraction.
2. Use `/Users/jesse/Development/Personal/Update-AI-Tools/Drag-Free-v2/2026-07-06-wf-validate-phase1.txt` as the cleanup queue for stale/default-path issues while extracting shared rules.
3. Promote flagged path/link warnings to hard failures after Phase 2 reduces duplicated prose and path references.

---

## 2026-07-06 13:18 - Phase 2 Start Addendum (Model: GPT-5)

### What Was Executed

- Added shared core partials:
  - `core/metadata-root.md`
  - `core/filing-and-logging.md`
  - `core/parallel-agents.md`
  - `core/verification-gates.md`
  - `core/artifact-contract.md`
- Added canonical role contracts under `core/roles/` for the initial role family.
- Wired role and partial references into key workflows:
  - `01-planning-and-organizing/01-plan-review.md`
  - `02-code-build/01-execution.md`
  - `05-review/01-code-review.md`
  - `06-security/01-security-review.md`
- Extended `tools/wf validate` to fail unresolved `agents` role references.
- Captured current Phase 2 validation warnings at `/Users/jesse/Development/Personal/Update-AI-Tools/Drag-Free-v2/2026-07-06-wf-validate-phase2-start.txt`.

### Verification Result

- Phase 2 is now complete after the follow-up conversion recorded below.
- Role references in the wired workflows resolve through `core/roles/<id>.md`.
- `catalog.json`, `ROUTER.md`, and generated README/category tables include the new core and role records.

### 2026-07-06 13:24 Follow-Up

- Replaced remaining free-text role menus in the main planning/build/review/security surfaces with frontmatter role IDs plus references to `core/parallel-agents.md`.
- Added `tools/wf stats tokens` for deterministic token measurement.
- Added core-phrase duplication linting to `tools/wf validate`.
- Extended `scripts/validation/check-wf-cli.sh` with role-reference and duplicate-core-phrase fixtures.
- Recorded token evidence:
  - `/Users/jesse/Development/Personal/Update-AI-Tools/Drag-Free-v2/2026-07-06-phase2-token-stats.json`
  - `/Users/jesse/Development/Personal/Update-AI-Tools/Drag-Free-v2/2026-07-06-phase2-token-stats-after.json`
  - `/Users/jesse/Development/Personal/Update-AI-Tools/Drag-Free-v2/2026-07-06-phase2-token-reduction-report.md`
  - `/Users/jesse/Development/Personal/Update-AI-Tools/Drag-Free-v2/2026-07-06-phase2-token-stats-expanded-after.json`
- Median body-token reduction across the initial pilot files is 30.5%.
- Final validation output is captured at `/Users/jesse/Development/Personal/Update-AI-Tools/Drag-Free-v2/2026-07-06-wf-validate-phase2-final.txt`.

---

## 2026-07-06 13:24 - Phase 3 Completion Addendum (Model: GPT-5)

### What Was Executed

- Added standards:
  - `core/standards/code-design.md`
  - `core/standards/error-handling.md`
  - `core/standards/observability.md`
  - `core/standards/security-baseline.md`
- Updated execution, code review, and security review workflows to reference those standards.
- Added T2/T3 quality sections to the research-and-plan skeleton and finalise-plan requirements:
  - `Design & Interfaces`
  - `Error-Handling Strategy`
  - `Test Strategy`
  - `Observability Plan`
  - `Rollout & Rollback`
- Added lifecycle workflows/contracts:
  - `01-planning-and-organizing/04-architecture-design.md`
  - `00-project-setup/08-greenfield-mvp.md`
  - `07-deployment/00-deploy.md`
  - `core/debt-ledger.md`
- Captured validation at `/Users/jesse/Development/Personal/Update-AI-Tools/Drag-Free-v2/2026-07-06-wf-validate-phase3-start.txt`.

### Verification Result

- `02-code-build/01-execution.md` now has concrete standards behind implementation quality.
- T2/T3 plans now include quality sections in the plan skeleton/finalisation workflow.
- T3 work has an architecture-design workflow with design brief and ADR output.
- Generic deployment has a repeatable workflow before tech-specific guides.
- Debt can be recorded through `core/debt-ledger.md`.
- `tools/wf route` resolves architecture design, generic deploy, and greenfield MVP workflows.

---

## 2026-07-06 13:55 - Phase 4 Completion Addendum (Model: GPT-5)

### What Was Executed

- Added metadata frontmatter to changelog, troubleshooting, and completed-plan entries.
- Made `tools/wf build` generate:
  - `00-project/changelog/index.md`
  - `00-project/troubleshooting/index.md`
  - `00-project/plans-completed/index.md`
  - `00-project/decisions/index.md`
  - `00-project/debt/index.md`
- Added bookkeeping commands:
  - `tools/wf new plan <slug>`
  - `tools/wf log <type> "<title>"`
  - `tools/wf trouble <category> <slug>`
  - `tools/wf file-completed <plan> <category>`
  - `tools/wf debt add`
  - `tools/wf debt list`
- Added `tools/wf sync pull|update|sync` as the CLI front door for the existing sync helpers.
- Updated `core/filing-and-logging.md` and `core/debt-ledger.md` with CLI-first usage and manual fallback.
- Expanded `scripts/validation/check-wf-cli.sh` with fixture coverage for the new bookkeeping commands.

### Verification Result

- `scripts/validation/check-wf-cli.sh` passes.
- `tools/wf build --check` passes.
- A real Phase 4 changelog entry was created with `tools/wf log added "Bookkeeping automation"`.

---

## 2026-07-06 14:10 - Phase 5 Completion Addendum (Model: GPT-5)

### What Was Executed

- Extended `tools/wf run plan-review` to delegate to `00-Meta-Workflow/00-orchestrator/orchestrator-review.sh`.
- Added `_manifest.json` emission with workflow ID, role IDs, model/focus, exit status, protected-source hashes, duration, output/status paths, and git status before/after.
- Added `tools/wf build skills` to generate Claude, Codex, OpenCode, and Droid-compatible bundles under `dist/skills/` from the current `11-Skills/*/SKILL.md` baseline.
- Added `tools/wf stats runs` to summarize run manifests by status, workflow, and role.
- Updated `core/artifact-contract.md` with the `wf run` manifest-writer contract.
- Expanded `scripts/validation/check-wf-cli.sh` with fixture coverage for run manifests, run stats, and skill bundle freshness.

### Verification Result

- `scripts/validation/check-wf-cli.sh` passes.
- `tools/wf build skills --check` passes.
- A smoke `tools/wf run plan-review` using the real orchestrator path and fake `opencode` produced `00-project/build/phase5-smoke/_manifest.json`.
- `tools/wf stats runs 00-project/build/phase5-smoke` output was captured at `/Users/jesse/Development/Personal/Update-AI-Tools/Drag-Free-v2/2026-07-06-wf-stats-runs-phase5.json`.

---

## 2026-07-06 14:35 - Phase 6 Completion Addendum (Model: GPT-5)

### What Was Executed

- Moved active workflow categories into `workflows/<area>/`.
- Moved API, technical, and meta reference material into `reference/`.
- Moved meta policy/reference material into `core/meta/`.
- Moved orchestrator tooling into `tools/orchestrator/`.
- Kept `00-project/` unchanged.
- Added `MOVED.md` and `MOVED.json`.
- Added redirect metadata to `catalog.json`.
- Left old markdown paths as redirect stubs for the compatibility window.
- Updated README and sharing/sync docs with migration guidance.
- Updated validator paths and `wf run plan-review` delegation to the moved orchestrator.
- Regenerated catalog, router, README tables, metadata indexes, and skill bundles.

### Verification Result

- `scripts/validation/check-wf-cli.sh` passes.
- `scripts/validation/check-active-markdown-links.sh` passes.
- `scripts/validation/check-orchestrator-review.sh` passes.
- `scripts/validation/check-review-workflow-policy.sh` passes.
- `scripts/validation/check-sync-workflow-scripts.sh` passes.
- `scripts/validation/check-update-workflows.sh` passes.
- `tools/wf build --check` passes.
- `tools/wf build skills --check` passes.
- `git diff --check` passes.
- Key routes resolve to new paths:
  - `review this plan` -> `workflows/planning/01-plan-review.md`
  - `architecture design` -> `workflows/planning/04-architecture-design.md`
  - `deploy this project` -> `workflows/deployment/00-deploy.md`
  - `greenfield mvp` -> `workflows/setup/08-greenfield-mvp.md`

---

## 7. Risks And Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Tooling makes markdown feel less simple | Medium | CLI remains optional; markdown remains complete enough for manual use. |
| Generated files get edited by hand | Low | `wf build --check` fails stale generated output. |
| Directory moves break current plans | High | Moves are delayed until Phase 6 with redirect maps and compatibility shims. |
| Standards become long style guides | Medium | Keep standard bodies short; put language-specific details in appendices. |
| Role registry is too rigid | Low | Allow one-off roles only when mission, output, evidence, and tool scope are stated inline. |
| `wf` becomes a maintenance burden | Medium | Single stdlib Python file, explicit fixtures, existing validation style. |
| Harness automation is unreliable | Medium | Start with single-model launcher, record blocked/unavailable honestly, keep manual fallback. |
| Multi-model plan scope collision | High | Drag-Free-v2 hosts the accepted contract; it does not redefine the July 3 orchestration semantics. |

---

## 8. Success Criteria

- `ROUTER.md` is compact enough to be the normal agent entry point.
- `catalog.json` covers all active workflow/reference/template/policy files.
- `tools/wf validate` is green in CI or the repo-local validation script.
- All active workflow path conventions resolve through `core/metadata-root.md`.
- Review/security/planning workflow token footprint drops materially, with measured before/after counts.
- Each shared rule exists in one source file.
- Every role referenced by a workflow resolves to `core/roles/`.
- Engineering standards are referenced by planning/execution and review/security workflows.
- T2/T3 plans include quality sections.
- Completed-plan filing can be completed with one command.
- Delegated runs emit manifests.
- Generated harness bundles can replace `11-Skills` hand copies after parity review.
- Existing consumers keep working through Phases 1-5 with no action beyond pulling Workflow-Scripts updates.

---

## 9. Immediate Next Steps

1. Start Phase 2 core partial extraction while preserving current workflow paths.
2. Keep the five Drag-Free-v2 source artifacts as evidence; do not overwrite them during implementation.
3. Keep generated artifacts fresh with `tools/wf build --check` after frontmatter or README changes.
