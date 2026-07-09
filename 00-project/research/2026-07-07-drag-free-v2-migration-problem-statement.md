---
date: 2026-07-07
category: research
kind: reference
status: open
branch: v2.0a
related-commit: 2f625ff
---

# Drag-Free-v2 Migration Problem Statement

## Executive Summary

Workflow-Scripts is in a **partially migrated, internally inconsistent state** on branch `v2.0a`. A Drag-Free-v2 Phase 6 directory rationalization was promoted into the live repository before the migration was complete. The result is a hybrid tree that **looks** like v2.0 but still depends on v1.7 paths for much of its content.

The most serious failure mode is not data loss — v1.7 remains intact on branch `v1.7` and `origin/v1.7` — but **redirect dead-ends**: ~114 legacy markdown files were replaced with three-line `# Moved` stubs while **92 canonical targets declared in `MOVED.json` were never created** and **16 canonical targets are themselves redirect stubs**.

Anyone browsing the repository on `v2.0a` will encounter broken links, missing workflows, and contradictory documentation that claims Phase 6 is complete.

---

## How This Was Discovered

On 2026-07-07, a manual audit was requested after it appeared that the entire v1.7 workflow system had been overwritten by v2.0. Investigation covered:

- The working tree under `/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts`
- `MOVED.json` and companion redirect surfaces (`MOVED.md`, `catalog.json` `redirects`)
- Git history and branch topology (`v1.7` vs uncommitted promotion state)
- Spot checks of old-path stubs vs new-path canonical targets

To preserve the discovered state without altering `v1.7`, all local changes were committed and pushed to a new branch:

- **Branch:** `v2.0a`
- **Commit:** `2f625ff` — `chore: checkpoint Drag-Free-v2 migration on v2.0a branch`
- **Remote:** `origin/v2.0a`

---

## Intended Architecture (Drag-Free-v2)

Drag-Free-v2 was designed to evolve Workflow-Scripts from prose-only instructions into a compiled, tool-supported system while keeping markdown as source of truth. Phase 6 ("Directory Rationalization") specified:

1. Move active workflows to `workflows/`
2. Move reusable meta policy to `core/meta/`
3. Move orchestrator tooling docs to `tools/orchestrator/`
4. Move historical/reference material to `reference/`
5. Replace old numbered directories with **compatibility stubs** for one release cycle
6. Publish machine-readable redirects in `MOVED.json` and `catalog.json`

Supporting surfaces added in v2.0:

- YAML frontmatter contracts (`version: 2.0`, `id`, `triggers`, `requires`, `agents`, `skills`)
- Generated `catalog.json`, `ROUTER.md`, and `tools/wf` CLI
- `core/roles/` registry and engineering-quality partials

Changelog entries and plans mark Phase 6 as complete (for example `00-project/changelog/changed/2026-07-06-changed-directory-rationalization.md`). **That completion claim is not supported by filesystem evidence on `v2.0a`.**

---

## Current Branch Topology

| Branch | Commit | State |
|--------|--------|-------|
| `v1.7` / `origin/v1.7` | `6cc921f` | Clean pre-migration numbered layout. Full prose workflows. No `workflows/`, `core/`, `reference/`, `MOVED.json`. |
| `v2.0a` / `origin/v2.0a` | `2f625ff` | Checkpoint of in-progress Drag-Free-v2 promotion. ~970 paths changed (+66,717 / −41,400 lines vs `v1.7`). |

**Implication:** v1.7 is recoverable and unchanged on the remote. The mess is isolated to `v2.0a`, but `v2.0a` is now the default local branch after the checkpoint commit.

---

## Quantitative Audit (`MOVED.json`, 146 redirects)

Audit method: for each `old_path -> new_path` entry in `MOVED.json`, classify the **canonical target** (`new_path`).

| Classification | Count | Meaning |
|----------------|-------|---------|
| Real content at target | **38** | Canonical file exists and is not a `# Moved` stub |
| Target is a `# Moved` stub | **16** | Redirect chain terminates at another stub (broken) |
| Target missing | **92** | `MOVED.json` points to a path that does not exist |

### Missing targets by prefix

| Prefix | Missing count |
|--------|---------------|
| `reference/` | 67 |
| `workflows/` | 25 |

### Legacy tree stubbing

Approximately **114** markdown files under the old numbered layout (`00-project-setup/`, `01-planning-and-organizing/`, `02-code-build/`, etc.) were replaced with:

```markdown
# Moved

This file moved to `<canonical-path>`. See `MOVED.md` at the repository root for the full redirect map.
```

For **92** of those canonical paths, no file was created. Following a stub from the old tree often leads nowhere.

---

## What Migrated Successfully

Core lifecycle workflows under `workflows/` are largely present with v2.0 frontmatter:

| Area | Status |
|------|--------|
| `workflows/planning/` | Complete (6 workflows + README) |
| `workflows/build/` | Complete |
| `workflows/review/` | Complete (includes new `06-deep-review.md`) |
| `workflows/debugging/` | Workflows present; `README.md` missing |
| `workflows/documentation/` | Workflows present; `README.md` missing |
| `workflows/security/` | Workflows present; `README.md` missing |
| `workflows/setup/` | Partial — 4 of 8 setup workflows + README missing |
| `workflows/deployment/` | Mostly missing — only `00-deploy.md` exists |
| `workflows/seo-geo/` | Entire subtree missing (7 files) |

Examples of content that **did** migrate and expand (not byte-identical to v1.7):

- `01-planning-and-organizing/00-research-and-plan.md` (341 lines at `v1.7`) → `workflows/planning/00-research-and-plan.md` (392 lines, v2 frontmatter)
- `01-planning-and-organizing/01-plan-review.md` (111 lines) → `workflows/planning/01-plan-review.md` (141 lines)

v2 content is an **evolution/rewrite** of v1.7 prose, not a mechanical copy.

---

## What Did Not Migrate (25 missing `workflows/` targets)

```
workflows/debugging/README.md
workflows/deployment/01a-MACOS_ELECTRON_GUIDE.md
workflows/deployment/01b-electron-vite.md
workflows/deployment/02-ai-studio-to-desktop.md
workflows/deployment/07-seo-and-ai-search-phased-implementation-with-submission_1cca3e93.plan.md
workflows/deployment/08-port-relocation/README.md
workflows/deployment/08-port-relocation/browser-auto-open.md
workflows/deployment/08-port-relocation/port-management-guide.md
workflows/deployment/08a-pre-deployment-security-check.md
workflows/deployment/08b-DEPLOYMENT_OPTIMIZATION_REPORT.md
workflows/deployment/README.md
workflows/documentation/README.md
workflows/security/README.md
workflows/seo-geo/01-fully-automated-tasks.md
workflows/seo-geo/02-semi-automated-tasks.md
workflows/seo-geo/03-manual-human-tasks.md
workflows/seo-geo/04-routine-monitoring-tasks.md
workflows/seo-geo/2026-03-18-SEO-Dashboard/2026-03-18-seo-tool-integration-strategy.md
workflows/seo-geo/2026-03-18-SEO-Dashboard/2026-03-18-stack-a-mvp-poc-implementation-plan.md
workflows/seo-geo/2026-03-18-SEO-Dashboard/2026-03-18-stack-a-seo-dashboard-implementation-plan.md
workflows/setup/02-optimize-workflow-scripts.md
workflows/setup/05-mcp-and-config-setup.md
workflows/setup/06-skills-setup.md
workflows/setup/07-migrate-project-structure.md
workflows/setup/README.md
```

The corresponding **old paths are stubbed**, so the v1.7 content is no longer readable at its historical location on `v2.0a` (though it remains on `v1.7` and in git history).

---

## Broken Canonical Targets (16 self-stubbed paths)

These paths are declared as the **destination** in `MOVED.json`, but the file at the destination is itself a `# Moved` stub — a redirect chain with no terminal content:

```
core/meta/README.md
core/meta/agent-flexibility-review.md
core/meta/filename-review.md
core/meta/parallel-agents-review.md
core/meta/sync-summary-template.md
reference/meta-workflow/docs/CODE-REVIEW-WORKFLOW-SCRIPTS-2026-02-28.md
reference/meta-workflow/docs/README.md
reference/meta-workflow/docs/WORKFLOW_TO_SKILLS_MAPPING_REPORT.md
reference/meta-workflow/docs/old-reviews/README.md
reference/meta-workflow/docs/old-reviews/SCRIPT-REVIEW-REPORT.md
reference/meta-workflow/docs/old-reviews/WORKFLOWS_CRITIQUE.md
reference/meta-workflow/docs/v1-reconciliation-conflict-log-2026-04-01.md
reference/meta-workflow/plans/index.md
reference/meta-workflow/token-efficiency/fable-token-savings.md
tools/orchestrator/README.md
tools/orchestrator/orchestrator-plan-review.md
```

**Note:** Some other `core/meta/` files (for example `glossary.md`, `naming-conventions.md`, `severity-priority-rubric.md`) **do** contain real content. The migration is inconsistent even within `core/meta/`.

This contradicts the 2026-07-06 research decision in `00-project/research/2026-07-06-legacy-meta-workflow-migration-decision.md`, which states that every `00-Meta-Workflow/` row has an existing canonical target with content.

---

## Reference / API Integration Gap (67 missing `reference/` targets)

The entire `08-API-Integration/` tree was stubbed at legacy paths, but the corresponding `reference/api-integration/` targets were largely never created. This includes:

- Genkit integration guides
- AI SDK integration and service-provider references
- Higgsfield MCP docs
- Firebase, nginx, Next.js/React update guides
- Backup archives under `reference/api-integration/backups/`

`10-technical-docs/Gemini/` was mostly stubbed, but **three files were left unmigrated and unstubbed**:

```
10-technical-docs/Gemini/Image Generation/image-understanding.md
10-technical-docs/Gemini/Image Generation/media-resolution.md
10-technical-docs/Gemini/Image Generation/nano-banana.md
```

Additionally, `00-Meta-Workflow/00-plans-completed/` (4 plan files + index) were **not** stubbed and remain at legacy paths — they are absent from `MOVED.json`.

---

## Duplicate and Overlapping Trees

`v2.0a` contains multiple representations of the same migration work:

| Location | Role |
|----------|------|
| Live root (`workflows/`, `core/`, `reference/`, `tools/`) | Intended canonical v2 layout (incomplete) |
| Old numbered dirs | Compatibility stubs (mostly) |
| `workflows-drag-free/00-Drag-Free-v2/` | Planning artifacts, research papers, unified implementation plan |
| `00-project/Drag-Free-v2/` | Second copy of promoted tree with its own stubs and v2 files |

This duplication increases navigation cost and makes it unclear which tree is authoritative during remediation.

---

## Documentation vs Reality Gaps

Several changelog and plan entries describe work as complete when the filesystem on `v2.0a` does not support those claims:

| Claimed | Observed on `v2.0a` |
|---------|---------------------|
| Phase 6 directory rationalization complete | 63% of `MOVED.json` targets missing or self-stubbed |
| Every `00-Meta-Workflow/` row has canonical content | 16 canonical targets are stubs |
| Drag-Free-v2 promoted to live Workflow-Scripts | Promotion was partial; deployment/reference/setup gaps remain |
| `tools/wf validate` clean | Prior changelog notes validation passed in intermediate states; current tree still has broken redirects |

Root `README.md` on `v2.0a` correctly describes the migration model (stubs + `MOVED.md`), but consumers following old paths or README tables that still reference numbered directories will hit dead ends.

---

## User-Visible Symptoms

1. **Broken workflow discovery** — `ROUTER.md` and `catalog.json` reference `workflows/deployment/`, `workflows/setup/`, and `workflows/seo-geo/` paths that do not exist.
2. **Silent content loss at old paths** — A user opening `07-deployment/01a-MACOS_ELECTRON_GUIDE.md` sees a stub; the promised `workflows/deployment/01a-MACOS_ELECTRON_GUIDE.md` does not exist.
3. **Inconsistent meta policy** — Some rubric/meta files work at `core/meta/`; others redirect to themselves.
4. **Branch confusion** — `v1.7` is the last known-good layout; `v2.0a` looks like the future but is not safe to treat as complete.
5. **Sync risk for host projects** — Projects synced to `v2.0a` inherit broken stubs; projects pinned to `v1.7` remain unaffected.

---

## Root Cause Analysis (Working Hypothesis)

1. **Promotion order inverted** — Compatibility stubs were written at legacy paths before all canonical targets were populated (or before content was verified at targets).
2. **Multi-stage promotion without atomic commit** — Work spanned Drag-Free-v2 sandbox → live tree → checkpoint branch, with intermediate changelog entries filed as complete.
3. **Incomplete copy scope** — Core planning/build/review workflows were prioritized; deployment, setup, API integration, and SEO/GEO were stubbed but not copied.
4. **Canonical path overwrite error** — Some files were stubbed at their own canonical destination (`core/meta/README.md` → `core/meta/README.md`), suggesting a bulk stub script ran against both old and new paths without exclusion rules.
5. **Duplicate artifact trees** — `00-project/Drag-Free-v2/` and `workflows-drag-free/00-Drag-Free-v2/` preserve overlapping snapshots, obscuring which copy was intended as source-of-truth for the live promotion.

---

## Impact Assessment

| Severity | Area | Impact |
|----------|------|--------|
| **High** | Deployment workflows | Host projects cannot follow deployment guides on `v2.0a` without checking out `v1.7` or git history |
| **High** | API integration reference | Entire `08-API-Integration/` knowledge base unreachable at new paths |
| **High** | Redirect integrity | `MOVED.json` / `catalog.json` assert mappings that are false for 108 of 146 entries (missing + self-stub) |
| **Medium** | Setup / SEO workflows | Onboarding and SEO checklists partially unavailable |
| **Medium** | Meta/orchestrator docs | Policy and orchestrator guidance broken for 16 paths |
| **Low** | Git history | v1.7 content recoverable from `v1.7` branch and `git show v1.7:<path>` |

---

## Recovery and Remediation Options

### Option A — Repair forward on `v2.0a` (recommended direction)

1. **Inventory** — Treat `MOVED.json` as the contract; classify every row as `ok | copy-needed | stub-at-target | unmapped`.
2. **Restore content** — For `copy-needed`, copy body from `v1.7` (or git `HEAD` of source path) into canonical target; apply v2 frontmatter where required.
3. **Fix self-stubs** — Replace 16 canonical stubs with real content from `v1.7` / `00-Meta-Workflow/`.
4. **Validate** — Add CI check: every `redirects` value must exist and must not start with `# Moved`.
5. **Dedupe** — Archive or delete `00-project/Drag-Free-v2/` once live tree is verified.
6. **Re-run** — `tools/wf build` and `tools/wf validate` until redirects and links are clean.

### Option B — Roll back live layout, replan promotion

1. Reset `v2.0a` file layout to `v1.7` content structure.
2. Keep v2 machinery (`tools/wf`, `catalog.json` generation) on a feature branch until migration script can run atomically: **copy first, stub second, validate third, commit once**.

### Option C — Maintain dual branches until remediation completes

- **`v1.7`** — production/consumption branch for host projects.
- **`v2.0a`** — remediation branch only; do not sync to host projects until redirect audit passes.

---

## Recommended Immediate Actions

1. **Do not merge `v2.0a` to `main` or replace `v1.7`** until redirect audit passes.
2. **File a remediation implementation plan** under `00-project/plans/` with explicit phases matching Option A.
3. **Add a `check-moved-redirects.sh` validator** (or extend `tools/wf validate`) — fail on missing targets and self-stubs.
4. **Update misleading changelog entries** that mark Phase 6 complete without qualification.
5. **Document branch guidance** in `README.md` and `SHARING_AND_SYNC.md`: use `v1.7` for stable consumption until `v2.0a` remediation closes.

---

## Open Questions

1. Was `00-project/Drag-Free-v2/` or `workflows-drag-free/00-Drag-Free-v2/` the intended source tree for the live promotion?
2. Should unmigrated `10-technical-docs/Gemini/Image Generation/` files move to `reference/technical-docs/` or stay at legacy paths?
3. Should `00-Meta-Workflow/00-plans-completed/` be added to `MOVED.json` or left as a legacy-only enclave?
4. Is the v2 frontmatter rewrite required for reference/deployment docs, or is a path-only move acceptable for those categories?
5. When remediation completes, should the branch be renamed (`v2.0`) or tagged from `v2.0a`?

---

## Evidence References

| Artifact | Path |
|----------|------|
| Redirect map | `MOVED.json`, `MOVED.md` |
| Machine catalog | `catalog.json` (`redirects` table) |
| Checkpoint commit | `2f625ff` on `v2.0a` |
| Last known-good layout | `6cc921f` on `v1.7` |
| Phase 6 changelog | `00-project/changelog/changed/2026-07-06-changed-directory-rationalization.md` |
| Promotion changelog | `00-project/changelog/config/2026-07-06-config-promote-drag-free-v2-to-live-workflow-scripts.md` |
| Meta migration decision | `00-project/research/2026-07-06-legacy-meta-workflow-migration-decision.md` |
| Unified implementation plan | `workflows-drag-free/00-Drag-Free-v2/2026-07-06-drag-free-v2-unified-implementation-plan.md` |

---

## Status

**Open** — Problem statement filed 2026-07-07 after `v2.0a` checkpoint. Remediation plan not yet filed. Consumption guidance: prefer `v1.7` until this problem statement is resolved and superseded by a remediation completion record.
