# 2026-07-03 23:30

# Multi-Model Adversarial Research, Planning, and Plan Review System - Implementation Plan

**Status:** Active (finalised, ready to execute; revised 2026-07-04 to factor shared orchestration from domain workflows)
**Consolidated from:**
- Original proposal: `00-project/research/2026-06-03-multi-model-plan-review-pass-system-proposal.md`
- Inline review addendum in that file: `2026-07-03 23:27 - Plan Review (Model: claude-fable-5)` (findings P1-1...P3-2)
- 2026-07-04 design direction: reuse the same adversarial multi-model mechanism for research, planning, and plan review, with shared instructions under `00-Meta-Workflow/` and thin domain workflows under `01-planning-and-organizing/`.
- 2026-07-04 routing correction: generated drafts, prototypes, run artifacts, manifests, and pilots must be written under the active target project's metadata tree. Use `00-project/` only when the task is changing the Workflow-Scripts system itself; use `<project-root>/project/` for consumer projects.
- No `PLAN.reviews/` directory existed for the proposal; the single review was appended inline per `01-plan-review.md`, so there is no per-model review directory to archive or delete.

**Produced per:** `01-planning-and-organizing/03-plan-review-and-finalise.md` -> `02-finalise-plan.md`
**Rubric:** `00-Meta-Workflow/00-meta/severity-priority-rubric.md`
**External model snapshot:** 2026-07-04, checked against official OpenAI, Anthropic, Google Gemini API, and OpenCode model documentation. Re-verify before implementation because model availability, aliases, prices, and harness support change quickly.

## Summary

Build a well-factored adversarial multi-model workflow system in two layers:

1. **Project-local draft/prototype layer** under the active target project's metadata tree: model fan-out, role/profile configuration, artifact naming, `_manifest.json`, single-writer guards, timeout/status capture, cleanup/archive policy, generic synthesis/reconciliation conventions, and pilot outputs.
2. **Domain profiles** staged under the active target project's metadata tree: research synthesis, plan drafting/finalisation, and plan review. Each profile supplies only the domain-specific prompt roles, artifact schema, merge rules, and canonical output location.

The original plan-review use case remains the first concrete consumer, but the reusable pieces must not be trapped inside a review-only workflow. Research and planning need different schemas from review findings, but they can share the same fan-out, manifest, isolation, and cleanup mechanics.

Phasing deliberately ships conventions and manual procedures before automation: shared contract first, review and research/planning profiles second, manual pilots third, launcher fourth, promotion/integration fifth. Fan-out can be done by hand while reconciliation/synthesis rules cannot.

All new workflow documents start as drafts under `<PROJECT_META>/build/adversarial-multi-model-workflow/` and all run artifacts live under `<PROJECT_META>/build/adversarial-multi-model-workflow/runs/`. Direct writes to top-level Workflow-Scripts directories such as `00-Meta-Workflow/` or `01-planning-and-organizing/` are out of scope until a separate promotion step is explicitly accepted.

## Project artifact routing rule

`00-project-setup/01-setup-project.md` defines the standard project metadata container as `<project-root>/project/` with subdirectories such as `project/research/`, `project/build/`, `project/plans/`, `project/changelog/`, and `project/plans-completed/`.

Use `00-project/` only when the active target is the Workflow-Scripts system itself, because this repository stores its own project metadata there after the documented flattening/migration. For every other project, `<PROJECT_META>/` is that project's root-level `project/` directory, not the nested `Workflow-Scripts/00-project/` directory.

Therefore this plan uses the placeholder `<PROJECT_META>/`:

- Workflow-Scripts system work: `<PROJECT_META>/` = `/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/00-project/`.
- Consumer-project work: `<PROJECT_META>/` = `<consumer-project-root>/project/`.

All files created while executing this plan must be written under `<PROJECT_META>/` unless the plan has reached an explicit promotion task. Promotion targets may be documented as intended destinations, but the implementation and pilot phases must not create or edit files directly under top-level workflow directories.

## Decisions locked for v1 (from the proposal, review, and 2026-07-04 factoring pass)

| # | Question | v1 decision | Source |
|---|---|---|---|
| 1 | Shared vs duplicated instructions | Shared fan-out, manifest, artifact, single-writer, timeout, and cleanup rules are drafted under `<PROJECT_META>/build/adversarial-multi-model-workflow/`; promotion into `00-Meta-Workflow/` is a later explicit step | 2026-07-04 factoring pass + routing correction |
| 2 | Supported profiles | v1 supports `research`, `planning`, and `review`; code review and implementation execution are out of scope | 2026-07-04 factoring pass |
| 3 | Artifact isolation | Every pass writes exactly one unique artifact under a sibling run directory; no pass edits the canonical source or target output | Proposal + `01-plan-review.md` |
| 4 | Directory naming | Use `<PROJECT_META>/build/adversarial-multi-model-workflow/runs/<run-id>/` for orchestration test artifacts; inside a consumer project, profile-specific sibling directories may be used only under that repo's `project/` container | 2026-07-04 factoring pass + routing correction |
| 5 | Filename pattern | `<base-name>.<profile>[.<role>].<short-model-name>.YYYY-MM-DD-HHMM.md`; filenames are plan/source scoped and not general `research/` reports | Review P2-2 + factoring pass |
| 6 | Manifest | Every run writes `_manifest.json` with profile, source path, launch timestamp, per-pass `{id, model, harness, role, status, exit, artifact, findings_or_claims}`, timeout, quorum, and cleanup decision | Proposal + factoring pass |
| 7 | Plan-review clustering | Deterministic, evidence-locator-only fingerprint (no title parsing) | Review P2-1 |
| 8 | Review quorum | >=2 of N completed review passes; any S0 finding always surfaces regardless of quorum | Proposal + review |
| 9 | Review severity math | Mode; no mode -> take the higher band and record the spread; spread >=2 bands -> human adjudication | Review P2-3, P3-1 |
| 10 | Reconciler/synthesizer identity | The orchestrating session acts as synthesizer/reconciler; it must not be one of the pass models when cross-vendor diversity was the goal | Review "missing steps" |
| 11 | Canonical outputs | Research -> `<PROJECT_META>/research/...`; planning -> `<PROJECT_META>/plans/...`; review -> a consolidated addendum or reviewed-plan copy under `<PROJECT_META>/build/...` during pilots, with direct source-plan edits deferred until promotion | Proposal + factoring pass + routing correction |
| 12 | Evidence tiers | Adopt CONFIRMED / PLAUSIBLE per-finding or per-claim field, authority: `deep-review-plans/2026-07-03-deep-review-00-overview.md` | Review P2-4 |
| 13 | Run directory fate | Keep run directory until canonical output is accepted, then delete or archive per `plans-completed`/artifact conventions; record decision in `_synthesis.md` or `_reconciliation.md` and `_manifest.json` | Review "missing steps" + factoring pass |
| 14 | Plan-path resolution | Reuse the deep-review resolution order: `project/` -> `00-project/` -> repo-root fallback | Review P2-5 |
| 15 | Worked example | The proposal's multi-speaker-podcast example is historical/external-repo only (file and commit `116cd56` are absent from both tracked repos); pilots use artifacts that exist in this workspace | Review P1-3 |

## Target workflow architecture

### Project-local staging layer

Create these draft workflow specs first:

```text
<PROJECT_META>/build/adversarial-multi-model-workflow/draft-workflows/
  multi-agent-artifact-contract.md
  multi-agent-manifest-contract.md
  multi-agent-fanout.md
  multi-agent-synthesis.md
  multi-agent-cleanup-policy.md
```

Intended promotion targets after pilots are accepted:

```text
00-Meta-Workflow/00-meta/
  multi-agent-artifact-contract.md
  multi-agent-manifest-contract.md
  multi-agent-cleanup-policy.md

00-Meta-Workflow/00-orchestrator/
  multi-agent-fanout.md
  multi-agent-synthesis.md
  fan-out-adversarial.sh
```

These promotion targets are documentation targets only during this plan. Do not create or edit them until a later promotion task explicitly moves validated drafts out of `<PROJECT_META>/`.

The shared draft layer owns:

- Role/model run matrix parsing.
- Launching passes by harness (`codex-subagent`, `opencode-run`, `manual`, later `api-batch`).
- Unique artifact path generation.
- `_manifest.json` creation and updates.
- Timeout and non-zero exit recording.
- Source hash guards for files that must not be edited by passes.
- Run directory cleanup/archive policy.
- Generic synthesis/reconciliation lifecycle: validate artifacts, cluster claims/findings, resolve or surface conflicts, write one canonical output, write one audit trail.

### Domain profile layer

Create thin profile drafts under the project metadata tree:

```text
<PROJECT_META>/build/adversarial-multi-model-workflow/profile-drafts/
  04-adversarial-research.md           # new profile
  05-adversarial-planning.md           # new profile
  06-adversarial-plan-review.md        # new profile or promoted replacement for review section
```

Existing workflow files such as `01-planning-and-organizing/00-research-and-plan.md`, `01-plan-review.md`, `02-finalise-plan.md`, and `03-plan-review-and-finalise.md` are reference inputs in this plan, not write targets.

Each domain profile owns only:

- Input contract and canonical output path.
- Profile-specific roles.
- Profile-specific artifact schema.
- Profile-specific merge rules.
- Profile-specific acceptance criteria.

## Domain profiles

### Profile A - Adversarial research

**Use when:** the team needs repo-grounded or external-source research before deciding what to build.

**Canonical output:** `<PROJECT_META>/research/<yyyy-mm-dd>-<topic>.md`.

**Run directory:** `<PROJECT_META>/build/adversarial-multi-model-workflow/runs/<run-id>/research/`.

**Roles:**

- `source-finder`: collect primary sources, local docs, prior plans, and repo evidence.
- `implementation-patterns`: find existing code patterns and integration boundaries.
- `skeptic`: look for false assumptions, missing constraints, and stale sources.
- `cost-risk`: evaluate cost, operational risk, dependency risk, and data/privacy issues.
- `synthesizer`: orchestrating session only; writes canonical research report and `_synthesis.md`.

**Per-pass schema:**

| Field | Required | Purpose |
|---|---|---|
| `id` | yes | Pass-local claim id |
| `claim` | yes | One sentence assertion |
| `source` | yes | URL, local file path, command output, or repo evidence |
| `evidence_tier` | yes | CONFIRMED or PLAUSIBLE |
| `source_type` | yes | `primary` \| `secondary` \| `local` \| `inference` |
| `confidence` | yes | high \| medium \| low |
| `implication` | yes | Why the claim matters to the decision |
| `open_question` | optional | What still needs checking |

**Merge rules:**

- Primary/local evidence beats secondary summaries.
- Conflicting factual claims are verified, not voted.
- Stale or unverifiable sources remain in `_synthesis.md` but do not drive recommendations.
- The canonical research report must separate facts, plausible inferences, recommendations, and open questions.

### Profile B - Adversarial planning

**Use when:** research exists, the desired outcome is clear enough to draft an implementation plan, and the risk warrants multiple planning passes.

**Canonical output:** `<PROJECT_META>/plans/<yyyy-mm-dd>-<topic>-implementation-plan.md`.

**Run directory:** `<PROJECT_META>/build/adversarial-multi-model-workflow/runs/<run-id>/planning/`.

**Roles:**

- `plan-author`: draft the smallest viable phased plan.
- `dependency-order`: test sequencing, prerequisites, and rollback paths.
- `scope-control`: remove speculative work and push non-blocking improvements to P3.
- `verification`: define acceptance checks, regression tests, and observable exit criteria.
- `risk-review`: identify security, migration, data, and operational risks.
- `synthesizer`: orchestrating session only; writes canonical implementation plan and `_synthesis.md`.

**Per-pass schema:**

| Field | Required | Purpose |
|---|---|---|
| `id` | yes | Pass-local recommendation id |
| `recommendation` | yes | Concrete planning recommendation |
| `priority` | yes | P0-P3 |
| `rationale` | yes | Evidence-backed reason |
| `dependency` | optional | Required predecessor or blocker |
| `risk` | optional | Failure mode if ignored |
| `verification` | yes | How completion will be proven |
| `scope_decision` | optional | include \| defer \| reject |

**Merge rules:**

- Dependencies and blockers are verified against the repo/workflow state.
- P0/P1 items require direct evidence; speculative items default to P3 or are dropped.
- Contradictory scope recommendations are surfaced in `_synthesis.md`; the canonical plan chooses one default and records rejected alternatives briefly.
- The final plan follows priority order and uses existing `02-finalise-plan.md` acceptance criteria.

### Profile C - Adversarial plan review

**Use when:** an implementation plan already exists and should be reviewed before execution.

**Canonical output:** during pilots, a reviewed-plan copy or consolidated addendum under `<PROJECT_META>/build/adversarial-multi-model-workflow/runs/<run-id>/review/`; after promotion, the established review workflow may append to `PLAN.md` or produce a next-version plan through `02-finalise-plan.md`. `_reconciliation.md` is the audit trail.

**Run directory:** `<PROJECT_META>/build/adversarial-multi-model-workflow/runs/<run-id>/review/`. `PLAN.reviews/` remains a backward-compatible consumer-project convention only when the reviewed plan itself lives under that project's `project/` container and the orchestrator has explicit permission to create the sibling directory there.

**Roles:**

- `general`: correctness, feasibility, completeness.
- `security`: trust boundaries, credentials, data exposure, unsafe command paths.
- `scope`: over-engineering, phase creep, smaller MVP alternatives.
- `test-strategy`: missing regression/acceptance checks.
- `migration-order`: ordering, rollback, and compatibility issues.
- `reconciler`: orchestrating session only; writes canonical addendum and `_reconciliation.md`.

**Per-finding schema:**

| Field | Required | Purpose |
|---|---|---|
| `id` | yes | Pass-local finding id |
| `title` | yes | One-line claim |
| `severity` | yes | S0-S3 |
| `priority` | yes | P0-P3 |
| `evidence` | yes | `file:line`, command result, or commit; findings without evidence are dropped and logged |
| `claim_type` | yes | `fact` \| `risk` \| `opinion` |
| `evidence_tier` | yes | CONFIRMED or PLAUSIBLE |
| `fix` | yes | Concrete correction |
| `fingerprint` | derived | Normalized evidence locator only |

**Merge rules:**

- Schema-validate each artifact first; drop and log malformed findings.
- Cluster by deterministic evidence fingerprint.
- Consensus = mode; no mode -> higher severity/priority band with spread recorded.
- Singletons are kept and tagged `single-source`.
- Fact conflicts are verified against the live repo; risk/opinion conflicts are surfaced for human judgment.
- Order surviving findings P0->P3, S0->S3 within priority.

## Recommended model and harness roster (snapshot: 2026-07-04)

This roster is a default starting point, not a permanent contract. Before building the launcher, re-check local credentials, `opencode run --help`, provider aliases, model availability, and costs.

### Harnesses

| Harness | Best use | Invocation shape | Notes |
|---|---|---|---|
| `codex-subagent` | Fast local repo scanning and same-vendor parallel read-only passes | In-session subagents launched by the orchestrator | Best fallback when OpenCode non-interactive model access is unavailable; weaker cross-vendor diversity if every pass uses the same base model family. |
| `opencode-run` | Cross-vendor fan-out with process isolation | `opencode run -m <provider/model> --title <run-title> -f <source-file> --format json "<positional prompt>"` | Use provider/model IDs. OpenCode documents `provider_id/model_id` and `-m` loading, plus variants for reasoning budgets. |
| `codex` | Codex CLI non-interactive or local orchestration pass | Exact CLI form verified by the harness-test plan before automation | Use for OpenAI/Codex-native runs when available outside this chat session. |
| `claude` | Claude CLI or Claude Code pass where available | Exact CLI form verified by the harness-test plan before automation | Use for Anthropic-native runs without routing through OpenCode. |
| `droid` | Droid agent harness where available | Exact CLI form verified by the harness-test plan before automation | Treated as an external harness until local command shape and model flags are verified. |
| `manual` | Pilot runs and models not exposed through CLI | Human/orchestrator launches a pass and files the artifact | Required for Phase 3 if automation is not ready. |
| `api-batch` | Later high-volume or scheduled runs | Provider SDK / batch API | Deferred until manual + OpenCode pilots prove the schema. |

### Research and planning default

Use stronger synthesis and long-context models because the job is to gather evidence, compare alternatives, and produce a coherent plan.

| Slot | Role | Recommended model | Harness | Why |
|---|---|---|---|---|
| A | source-finder / plan-author | `anthropic/claude-fable-5` or `anthropic/claude-opus-4-8` | `opencode-run` or `manual` | Strong long-running agent/planning pass; use Fable only where access is available, otherwise Opus. |
| B | implementation-patterns / dependency-order | `openai/gpt-5.5` | `opencode-run` or Codex-hosted equivalent | Strong coding/professional reasoning; good adversarial contrast with Claude. |
| C | skeptic / scope-control | `google/gemini-3.1-pro` when preview is acceptable, otherwise `google/gemini-3.5-flash` | `opencode-run` | Different model family; useful for challenging assumptions and broad context. |
| D | verification / cost-risk | `anthropic/claude-sonnet-5` or `openai/gpt-5.4-mini` | `opencode-run` or `codex-subagent` | Cheaper pass for acceptance criteria, cost/risk, and completeness checks. |
| Reconciler | synthesizer | Orchestrating Codex session, preferably not one of A-D | local session | Keeps canonical write path single and auditable. |

Recommended run sizes:

- **Quick:** A + B, then orchestrator synthesis.
- **Standard:** A + B + C, then orchestrator synthesis.
- **High-impact:** A + B + C + D, then orchestrator synthesis.

### Plan-review default

Use diversity plus role pressure. Reviews benefit from one strong general pass, one different-family general pass, and role-specialized passes that hunt for specific failure modes.

| Slot | Role | Recommended model | Harness | Why |
|---|---|---|---|---|
| A | general | `anthropic/claude-opus-4-8` or `anthropic/claude-sonnet-5` | `opencode-run` or `manual` | Strong plan/code review behavior; Sonnet is the lower-cost default. |
| B | general | `openai/gpt-5.5` | `opencode-run` or Codex-hosted equivalent | Independent reasoning family for disagreement detection. |
| C | general or skeptic | `google/gemini-3.5-flash` stable, or `google/gemini-3.1-pro` preview for deeper reasoning | `opencode-run` | Third-family coverage; use stable model for routine reviews and preview for high-impact plans. |
| D | security | `anthropic/claude-sonnet-5` or `openai/gpt-5.4-mini` | `opencode-run` or `codex-subagent` | Cost-controlled specialized scan. |
| E | scope/test-strategy | `openai/gpt-5.4-mini` or `anthropic/claude-haiku-4-5` | `opencode-run` or `codex-subagent` | Cheap pressure pass for over-engineering and missing tests. |
| Reconciler | reconciler | Orchestrating Codex session, preferably not one of A-E | local session | Only writer to `PLAN.md`; verifies facts instead of voting on them. |

Recommended run sizes:

- **Quick:** A + B.
- **Standard:** A + B + C.
- **High-impact:** A + B + C + D + E.

## Roadmap (priority-ordered; phase numbering follows priority)

### Phase 1 - Shared meta contracts (P1)

**Scope/objective:** Define the common mechanism once under draft workflow docs so research, planning, and review can reuse it without copied instructions.

**Deliverables:**

- `<PROJECT_META>/build/adversarial-multi-model-workflow/draft-workflows/multi-agent-artifact-contract.md`
- `<PROJECT_META>/build/adversarial-multi-model-workflow/draft-workflows/multi-agent-manifest-contract.md`
- `<PROJECT_META>/build/adversarial-multi-model-workflow/draft-workflows/multi-agent-cleanup-policy.md`

**Key tasks (ordered):**

1. **(Small)** Define the generic artifact filename pattern: `<base-name>.<profile>[.<role>].<short-model-name>.YYYY-MM-DD-HHMM.md`.
2. **(Medium)** Define profile-specific run subdirectories under `<PROJECT_META>/build/adversarial-multi-model-workflow/runs/<run-id>/`; document `PLAN.reviews/` only as a backward-compatible consumer-project convention.
3. **(Medium)** Define `_manifest.json`: source path, profile, launch timestamp, per-pass `{id, model, harness, role, status, exit, artifact, claims_or_findings}`, `synthesized_at`/`reconciled_at`, quorum, cleanup decision, and default 30-minute pass timeout.
4. **(Small)** Define source hash guards: passes may write only their assigned artifact; protected source/canonical files are hashed before launch and checked after `wait`.
5. **(Medium)** Define the cleanup policy: keep run directory until canonical output is accepted; then delete or archive and record the decision in `_manifest.json` plus `_synthesis.md`/`_reconciliation.md`.
6. **(Small)** State the plan/source-path resolution order (decision 14) instead of hardcoding `project/plans/`.

**Dependencies:** none.
**Risks:** generic contract becomes too abstract -> mitigate by testing with all three profiles before promotion.
**Verification / exit criteria:** draft contract docs exist; a hand-written sample manifest for each profile validates by checklist; existing review naming conflict is documented for Phase 5 update.

### Phase 2 - Domain profile specs (P1)

**Scope/objective:** Create profile-specific draft workflows that call the shared meta contracts instead of duplicating orchestration rules.

**Deliverables:**

- `<PROJECT_META>/build/adversarial-multi-model-workflow/profile-drafts/adversarial-research-profile.md`
- `<PROJECT_META>/build/adversarial-multi-model-workflow/profile-drafts/adversarial-planning-profile.md`
- `<PROJECT_META>/build/adversarial-multi-model-workflow/profile-drafts/adversarial-plan-review-profile.md`
- `<PROJECT_META>/build/adversarial-multi-model-workflow/draft-workflows/multi-agent-synthesis.md`

**Key tasks (ordered):**

1. **(Medium)** Write the research profile: roles, claim schema, source-confidence rules, canonical research report output, and `_synthesis.md` audit format.
2. **(Medium)** Write the planning profile: roles, recommendation schema, priority/dependency rules, canonical implementation plan output, and `_synthesis.md` audit format.
3. **(Medium)** Write the review profile: per-finding schema, deterministic fingerprint, quorum rules, severity/priority math, fact verification, conflict surfacing, and `_reconciliation.md`.
4. **(Small)** Add the synthesizer/reconciler identity rule and evidence spot-check requirement for all S0/S1, `fact` findings, and high-impact research claims.
5. **(Small)** Include the 2026-07-04 model/harness roster as a refreshable appendix in the profile docs, not as a hidden launcher default.

**Dependencies:** Phase 1.
**Risks:** profile rules drift from existing `01-plan-review.md` and `02-finalise-plan.md` -> mitigate by cross-linking those docs as source-of-truth for scoring/finalisation.
**Verification / exit criteria:** dry-run against synthetic artifacts for each profile produces expected `_synthesis.md` or `_reconciliation.md`.

### Phase 3 - Manual pilots (P1)

**Scope/objective:** Battle-test the contracts and profiles by hand before building automation.

**Key tasks (ordered):**

1. **(Small)** Select one live research topic, one planning task, and one high-impact pre-execution plan from this workspace.
2. **(Medium)** Manually launch 2-3 independent research passes, each writing only its assigned artifact under `<PROJECT_META>/build/adversarial-multi-model-workflow/runs/<run-id>/research/`; synthesize a canonical research report in `<PROJECT_META>/research/`.
3. **(Medium)** Manually launch 2-3 independent planning passes, each writing only its assigned artifact under `<PROJECT_META>/build/adversarial-multi-model-workflow/runs/<run-id>/planning/`; synthesize a canonical implementation plan in `<PROJECT_META>/plans/`.
4. **(Medium)** Manually launch 2-3 independent review passes, each writing only its assigned artifact under `<PROJECT_META>/build/adversarial-multi-model-workflow/runs/<run-id>/review/`; reconcile into a reviewed-plan copy or review addendum artifact in the same run directory.
5. **(Small)** Record lessons (schema gaps, prompt-compliance failures, model availability, clustering misses, cleanup decisions) as a dated addendum to this plan.

**Dependencies:** Phases 1-2.
**Risks:** passes drift from schemas -> validation checklist drops malformed entries and records drop rate; cost -> cap each pilot at N<=3.
**Verification / exit criteria:** each pilot has one accepted canonical output; protected source hash unchanged by passes; at least one singleton and one conflict/near-conflict observed across the three pilots; lessons filed.

### Phase 4 - Shared fan-out launcher (P2)

**Scope/objective:** Automate what Phase 3 did by hand with one profile-aware launcher staged under `<PROJECT_META>/build/adversarial-multi-model-workflow/`.

**Deliverable:** `<PROJECT_META>/build/adversarial-multi-model-workflow/prototypes/fan-out-adversarial.sh`. Promotion target `00-Meta-Workflow/00-orchestrator/fan-out-adversarial.sh` is recorded only as an intended destination for a later promotion plan.

**Key tasks (ordered):**

1. **(Small)** Keep the verified OpenCode CLI correction: for `opencode run`, prompt is positional; useful flags are `--format json`, `--title`, `--variant`, and `-f/--file`.
2. **(Medium)** Write a profile-aware config format with `profile`, `source`, `protected_paths`, `runs[]`, `model`, `harness`, `role`, `variant`, and `artifact`.
3. **(Medium)** Implement launch loop: generate artifact paths, build per-pass prompt from profile templates, launch supported harnesses, capture PIDs, record event logs, update `_manifest.json`, enforce timeout, and `wait`.
4. **(Small)** Fork delegation prompts from existing orchestrator docs so passes write only their assigned artifacts and are explicitly forbidden from editing canonical files.
5. **(Small)** Add post-run hash guard for protected files.
6. **(Small)** `shellcheck` clean; handle non-zero exits/timeouts by recording pass status and proceeding under profile-specific quorum/degraded-run rules.

**Dependencies:** Phase 3 pilot lessons.
**Risks:** OpenCode non-interactive limitations -> keep in-session `codex-subagent` and manual fan-out documented as fallback harnesses.
**Verification / exit criteria:** `shellcheck` passes; 2-pass live run for research and review produces schema-valid artifacts + complete manifest; protected-file guard fails a deliberately misbehaving pass in a test run.

### Phase 5 - Promotion plan, integration, and deferred extensions (P3)

**Scope/objective:** Produce a separate promotion plan after pilot data proves which drafts should move out of `<PROJECT_META>/`. This phase does not directly edit top-level Workflow-Scripts workflow directories.

**Key tasks:**

1. **(Small)** Write `<PROJECT_META>/plans/<yyyy-mm-dd>-adversarial-workflow-promotion-implementation-plan.md` listing the exact files to promote, their source draft paths, destination workflow paths, and validation evidence.
2. **(Small)** In that later promotion plan, move shared docs to `00-Meta-Workflow/00-meta/` and `00-Meta-Workflow/00-orchestrator/` only after approval.
3. **(Small)** In that later promotion plan, move profile docs to numbered `01-planning-and-organizing/` workflows and update `01-planning-and-organizing/README.md`.
4. **(Small)** In that later promotion plan, cross-link from `00-research-and-plan.md`, `01-plan-review.md`, `02-finalise-plan.md`, and `03-plan-review-and-finalise.md` without duplicating shared orchestration rules.
5. **(Small)** In that later promotion plan, update `11-Skills/multi-agent-plan-orchestration` / `workflow-plan-review-finalize` or create a new skill that routes to the shared meta layer.
6. **(Medium, deferred)** Role-specialized prompt addenda libraries for research, planning, review, security, scope, test-strategy, and migration-order.
7. **(Large, deferred)** Embedding-based clustering for review findings only if pilot data shows deterministic fingerprints splitting semantically-identical findings at a meaningful rate.
8. **(Deferred)** CI gating on review exit codes; cross-plan aggregation.

**Dependencies:** Phases 3-4 complete and lessons incorporated.
**Exit criteria:** promotion plan filed in `<PROJECT_META>/plans/`; pilot evidence linked; no direct top-level workflow-directory edits made by this plan; `TODO.md` rows updated only when verified.

## Out of scope

- Code review and implementation execution profiles.
- Automated CI gating on review exit codes (deferred to Phase 5.7 decision point).
- Cross-plan / portfolio-level aggregation.
- Using this system on small/low-risk or mid-execution plans unless the user explicitly accepts the overhead.
- Treating the model roster as permanently current; model aliases must be refreshed before launcher defaults are committed.
- Writing generated draft/prototype/run artifacts directly under top-level Workflow-Scripts directories before an explicit promotion plan.

## References

- `00-project/research/2026-06-03-multi-model-plan-review-pass-system-proposal.md` (+ 2026-07-03 review addendum - source of all P-numbered findings cited above)
- `01-planning-and-organizing/00-research-and-plan.md`, `01-plan-review.md`, `02-finalise-plan.md`, `03-plan-review-and-finalise.md`
- `00-Meta-Workflow/00-orchestrator/orchestrator-plan-review.md`, `orchestrator-review.sh`
- `00-project/research/opencode-parameters.md` (extracted `opencode --help`, v1.17.13 - CLI surface for the Phase 4 launcher)
- `00-Meta-Workflow/00-meta/severity-priority-rubric.md`, `naming-conventions.md`
- `00-project/plans/deep-review-plans/2026-07-03-deep-review-00-overview.md` (evidence-tier authority)
- `11-Skills/multi-agent-plan-orchestration/SKILL.md`, `11-Skills/workflow-plan-review-finalize/SKILL.md`
- OpenAI Models docs, checked 2026-07-04: `https://platform.openai.com/docs/models`
- Anthropic Claude Models overview, checked 2026-07-04: `https://docs.anthropic.com/en/docs/about-claude/models/overview`
- Google Gemini API Models docs, checked 2026-07-04: `https://ai.google.dev/gemini-api/docs/models`
- OpenCode Models docs, checked 2026-07-04: `https://opencode.ai/docs/models/`
