# Implementation vs Original Design Goals — workflows-drag-free Deep Review

**Date:** 2026-07-10 14:05 +08
**Model:** Fable 5 (claude-fable-5)
**Type:** research / plan-vs-implementation review
**Scope:** `Workflow-Scripts/workflows-drag-free/` package, reviewed against its design plans (archived under `00-project/changelog/plans/`), executed migration plans (`00-project/plans-completed/migration/`), and the changelog index.
**Branch at review:** `fix/v2.0a-separate-legacy-and-v2` (HEAD `6035a8d`)

---

## 1. Verdict

**The original design goals are substantially achieved — roughly 90% of the unified plan's §8 success criteria are met and live-verified today.** All six implementation phases of the 2026-07-06 unified plan executed with verification addenda; the three 2026-07-10 migration plans (single-master reconciliation, ops-meta docs migration draft + final) executed to their Definitions of Done; and every validator I ran fresh during this review passes.

There are **five deviations** from the original design, of which **one is a live regression** worth fixing (dangling `requires:` references with no validator coverage), two are accepted scope reductions, one is a deliberate architectural evolution, and one is an explicitly deferred phase.

---

## 2. Evidence Base

| Artifact | Location |
|---|---|
| Unified implementation plan (canonical design, Phases 0–6 + §8 success criteria) | `changelog/plans/2026-07-06-drag-free-v2-unified-implementation-plan.md` |
| Workflow skill layer plan | `changelog/plans/2026-07-06-drag-free-v2-workflow-skill-layer-plan.md` |
| Redesign proposal + quality/lifecycle proposal + 3 surveys | `changelog/plans/` (5 files) |
| Single master directory reconciliation plan (executed) | `plans-completed/migration/2026-07-10-single-master-directory-reconciliation-plan.md` |
| Ops meta v2 docs migration final plan (executed) + source draft | `plans-completed/migration/` |
| Changelog index (32 rows, 2026-07-10 era) | `changelog/index.md` |
| Migration research (dual-tree comparison, problem statement) | `research-completed/migration/` |

## 3. Live Verification Performed (2026-07-10)

All commands run fresh from the Workflow-Scripts repo root / package root during this review — not taken on faith from plan addenda:

| Check | Result |
|---|---|
| `tools/wf validate` | ✅ 50 frontmatter records, 0 warnings, exit 0 |
| `tools/wf build --check` | ✅ generated files fresh |
| `tools/wf route "review this plan"` | ✅ resolves plan-review with agents/roles |
| `tools/wf --help` | ✅ all planned commands present: validate, build, route, log, trouble, new, file-completed, debt, run, stats (+ init/prune helpers) |
| `catalog.json` redirects (repo-root-relative) | ✅ 146/146 targets exist, 0 `# Moved` stubs |
| `scripts/validation/check-moved-targets.sh` | ✅ PASS |
| `scripts/validation/check-active-markdown-links.sh` | ✅ PASS |
| `scripts/validation/check-wf-cli.sh` | ✅ PASS |
| `check-orchestrator-review.sh`, `check-review-workflow-policy.sh`, `check-sync-workflow-scripts.sh`, `check-update-workflows.sh`, `check-workflow-skills.sh` | ✅ all PASS |
| `00-project/Drag-Free-v2/` (second tree) | ✅ absent, as planned |
| Salvage tarball + inventory | ✅ `00-project/build/archive/drag-free-v2-promotion-snapshot-2026-07-10.tar.gz` + salvage inventory + consolidated logs present |
| Phase-2 token evidence | ✅ preserved live under `00-project/build/archive/workflow-scripts-consolidated-2026-07-06/logs/` (stats JSONs + reduction report) |
| `dist/skills/` bundles | ✅ claude / codex / opencode / droid + manifest.json present |
| `11-Skills/` at repo root | ✅ 19 skills incl. all 4 planned workflow-layer skills |

## 4. Goal-by-Goal Scorecard (Unified Plan §8 Success Criteria)

| # | Success criterion | Status | Evidence |
|---|---|---|---|
| 1 | `ROUTER.md` compact agent entry point | ✅ Met | Generated table, 15 workflows, one row each; DO-NOT-EDIT banner |
| 2 | `catalog.json` covers active workflow/reference/template/policy files | ✅ Met (evolved) | 50 records: 15 workflow, 9 reference, 9 role, 5 standard, 12 legacy/ledger; plus 146 redirects |
| 3 | `wf validate` green in local validation | ✅ Met | Exit 0, 0 warnings; `check-wf-cli.sh` fixture suite passes |
| 4 | Path conventions resolve through `core/metadata-root.md` | ⚠️ Partial | `<metadata-root>` convention is enforced in prose (`00-core/meta/*`, skills), but the dedicated partial file no longer exists — see Deviation D1 |
| 5 | Token footprint drops materially, measured | ⚠️ Partial | Measured 30.5% median reduction on pilots (evidence preserved); below the survey's 40–55% aspiration but material |
| 6 | Each shared rule in one source file | ✅ Largely met | Duplication linter in validate; shared rules live in `00-core/meta/` + skills; the 5 named partials were dissolved into these (D1) |
| 7 | Every referenced role resolves to `core/roles/` | ✅ Met | 9 roles in `00-core/roles/`; `wf validate` resolves `agents:` role refs; route output returns role IDs |
| 8 | Standards referenced by planning/execution and review/security | ✅ Met | `00-core/standards/{code-design,error-handling,observability,security-baseline}.md`; wired via `requires:` and `engineering-quality-gates` skill |
| 9 | T2/T3 plans include quality sections | ✅ Met | Plan skeleton carries Design & Interfaces / Error-Handling / Test Strategy / Observability / Rollout sections (Phase 3 addendum; visible in executed 2026-07-10 plans) |
| 10 | Completed-plan filing is one command | ✅ Met | `wf file-completed` implemented with fixtures; filing discipline visibly followed (plans-completed + index + changelog Type=plan rows) |
| 11 | Delegated runs emit manifests | ✅ Met | `wf run` emits `_manifest.json` (workflow ID, roles, hashes, git status); `wf stats runs` summarizes; fixture-covered |
| 12 | Generated harness bundles can replace `11-Skills` after parity review | ✅ Met (coexisting) | `dist/skills/` for 4 harnesses generated and freshness-checked; `11-Skills/` retained as source baseline per skill-layer plan |
| 13 | Consumers keep working through Phases 1–5 | ✅ Met | Root numbered stubs kept one release (Option A recorded); 146/146 redirects valid; sync validators pass |

**Skill-layer plan goals:** ✅ achieved — `skills:` frontmatter contract present in workflows (verified in `01-planning/01-plan-review.md`), generated "Skill Hooks" sections near the top of workflows, all four planned skills exist (`workflow-intake-and-routing`, `engineering-quality-gates`, `repo-records-and-filing`, `delegated-agent-orchestration`), `check-workflow-skills.sh` passes, and `11-Skills/` was preserved rather than replaced.

**Single-master reconciliation plan:** ✅ achieved — all 12 Definition-of-Done items check out live: DFV2 tree absent, WDF sole master with perfect redirects, tarball + salvage inventory + unique consolidated logs preserved, entry docs updated, stub policy A recorded, changelog + plan filed. Phase 7 (skills nesting) deferred by design.

**Ops-meta docs migration final plan:** ✅ achieved — package-owned research (problem statement, dual-tree comparison) and troubleshooting now live under WDF package meta (`research-completed/migration/`, `troubleshooting/build/`); ops archive stays in live `00-project/build/archive/`; changelog rows filed under WDF only.

## 5. Deviations From the Original Design

### D1 — Core partials dissolved; dangling `requires:` IDs; validator regression ⚠️ *(the one worth fixing)*

The unified plan specified five core partials (`core/metadata-root.md`, `filing-and-logging.md`, `parallel-agents.md`, `verification-gates.md`, `artifact-contract.md`) and a Phase 1 validator rule that `requires:` references must resolve. Today:

- **None of the five partial files exist** anywhere under `workflows-drag-free/`. Their content was absorbed into `00-core/meta/*` docs (e.g. `review-workflow-core.md`, `agent-spawning-policy.md`, `severity-priority-rubric.md`) and the four workflow-layer skills during the skill-layer work and the numbered-package consolidation.
- **Workflow frontmatter still references them.** 7 `requires:` IDs resolve to nothing in `catalog.json`: `metadata-root`, `filing-and-logging`, `parallel-agents`, `verification-gates`, `agent-spawning-policy`, `review-workflow-core`, `severity-priority-rubric`. (The last three exist as files under `00-core/meta/` but are not catalogued under those IDs.)
- **The current `tools/wf` no longer validates `requires:` resolution** (no such check in the source), so `wf validate` reports 0 warnings despite the dangling refs. This silently regresses the Phase 1 exit criterion "valid references in `prev`, `next`, `requires`, and role IDs".

*Functional impact is low* — the skill layer (`skills:` frontmatter, which IS validated by `check-workflow-skills.sh`) now carries the load the partials were designed for. But the frontmatter contract is lying, and the machine-checkability principle ("make the system machine-checkable") is violated for this one field.

**Recommendation:** either (a) re-point `requires:` at the real successors (skill IDs / `00-core/meta` doc IDs, adding frontmatter to those meta docs so they enter the catalog) and restore `requires:`-resolution checking in `wf validate`, or (b) drop the `requires:` field from the contract and frontmatter entirely. Option (a) preserves the original design intent.

### D2 — Role registry: 9 roles vs 15 planned families *(accepted scope reduction)*

Shipped: `architecture-reviewer`, `bug-hunter`, `dependency-reviewer`, `docs-writer`, `implementer`, `performance-reviewer`, `security-scanner`, `test-strategist`, `test-writer` (three renamed from the planned `architect`/`performance-analyst`/`dependency-researcher`). Not created: `accessibility-reviewer`, `compliance-reviewer`, `external-docs-researcher`, `resilience-reviewer`, `observability-auditor`. All roles actually referenced by workflows resolve, so this is a consolidation, not a break. Add the missing five only when a workflow needs them.

### D3 — Token reduction 30.5% vs 40–55% survey target *(partial)*

Measured and honestly recorded (token-and-roles survey notes it explicitly as "below 40%/55% target; some workflows retain free-text spawn menus"). Material improvement; aspiration not fully reached. Evidence preserved under `00-project/build/archive/workflow-scripts-consolidated-2026-07-06/logs/`.

### D4 — Final layout differs from planned Phase 6 layout *(deliberate evolution)*

The plan's target was `workflows/<area>/` + `core/` + `reference/` at the Workflow-Scripts root. The shipped end-state is a **self-contained numbered package** `workflows-drag-free/` (`00-core/`, `00-setup/` … `07-deployment/`, `12-seo-geo/`, `reference/`, `tools/`, own `00-project/` metadata root). This evolved through the v2.0a promotion failure (documented in three `troubleshooting/build/` path-drift entries) and was ratified by the single-master reconciliation plan. The plan's *actual acceptance test* for Phase 6 — old paths redirected or failing with clear guidance, validated — passes: 146/146 redirects, 0 stubs. Catalog shrank 110 → 50 records accordingly (the package excludes root product surfaces like `11-Skills/`).

### D5 — Phase 7 skills nesting deferred *(by design)*

`11-Skills/` stays at repo root per the reconciliation plan's recommended default. Recorded as open/optional; not a gap.

## 6. Minor Observations (no action required)

1. **12 catalog records with no `kind`** — legacy SEO-dashboard plans, one deployment plan snapshot, and troubleshooting ledger entries. Harmless, but tagging them (`kind: reference` or excluding ledger entries from `records`) would clean the catalog.
2. **`fable-like.md` sits untyped in `01-planning/`** — appears in catalog as `planning-fable-like` (reference); fine, just noting it postdates the plan.
3. **Changelog discipline is exemplary** — 32 indexed rows for the 2026-07-10 era alone, every plan filed with Type=plan rows, research filed to `research-completed/` with index rows. The Phase 4 bookkeeping goal didn't just ship as tooling; it visibly changed behavior.

## 7. Bottom Line

The system the plans set out to build — markdown source of truth + frontmatter contracts + generated catalog/router/indexes + dependency-free `wf` CLI + role registry + engineering standards + skill layer + manifest-emitting delegated runs + a single validated master package with perfect redirects — **exists, is green under its own validators, and is being used as designed** (the 2026-07-10 migration plans were themselves planned, reviewed, executed, verified, and filed using the v2 lifecycle, which is the strongest possible evidence the design works).

The one genuine defect to carry forward: **D1 — restore `requires:` integrity (re-point or remove) and its validator check.** Suggested filing: a `debt` entry via `tools/wf debt add`, or a small P2 fix plan.
