---
date: 2026-07-10
category: research
kind: investigation
status: complete
branch: fix/v2.0a-separate-legacy-and-v2
related-commit: 2a92d69
related:
  - 00-project/research/2026-07-07-drag-free-v2-migration-problem-statement.md
  - workflows-drag-free/00-Drag-Free-v2/2026-07-06-drag-free-v2-unified-implementation-plan.md
  - 00-project/plans-completed/review/2026-07-03-workflow-scripts-deep-review-remediation.md
---

# Drag Free Dual-Tree Comparison: `workflows-drag-free` vs `00-project/Drag-Free-v2`

## Executive Summary

There are **two distinct Drag Free artifacts** in Workflow-Scripts. They are not interchangeable copies of the same consolidation.

| Location | Role (as of 2026-07-10) | Health | Size |
|----------|-------------------------|--------|------|
| **`workflows-drag-free/`** | **Active v2 workflow library** after consolidation + redirect repair | Healthy: **0 stubs**, **146/146** `MOVED` targets resolve to real content | ~181 files, **2.5 MB** |
| **`00-project/Drag-Free-v2/`** | **Historical promotion sandbox / evidence archive** of the partial Phase 6 promote | Broken hybrid: **131 stubs**, **92 missing** targets, **16 self-stubs** | ~775 files, **11 MB** |

**Bottom line:** Continue consolidating against `workflows-drag-free/`. Treat `00-project/Drag-Free-v2/` as a frozen evidence snapshot of the failed/partial promote, not as a second active library. The live repo root numbered directories (`01-planning-and-organizing/`, etc.) are now compatibility stubs that point into `workflows-drag-free/`.

This report supersedes the open question in the 2026-07-07 problem statement ("which tree was the intended source?") with filesystem and git evidence from the post-repair branch state.

---

## 1. How These Trees Came to Exist

### 1.1 Intended design (Drag-Free-v2 plan)

From the unified implementation plan (preserved in both trees and under `00-project/plans/Drag-Free-v2/`):

- Keep markdown as source of truth; add YAML frontmatter, `catalog.json`, `ROUTER.md`, `tools/wf`.
- Defer physical directory moves until validation works (**Phase 6 last**).
- Phase 6 target layout: `workflows/`, `core/`, `reference/`, `tools/`, with legacy paths reduced to stubs + `MOVED.json`.

Plan status was marked fully complete including Phase 6. That claim was **too early** relative to filesystem reality (documented in `2026-07-07-drag-free-v2-migration-problem-statement.md`).

### 1.2 What actually happened (git timeline on this branch)

| Commit | Message | Effect |
|--------|---------|--------|
| `2f625ff` | checkpoint Drag-Free-v2 migration on `v2.0a` | Hybrid promote into live tree; incomplete targets |
| `1c1050b` | file Drag-Free-v2 migration problem statement | Documented 92 missing + 16 self-stub redirects |
| `2aa0a15` | repair drag-free v2 redirect targets | Began restoring missing canonical content |
| `15c14d2` | consolidate drag-free v2 root | Consolidation toward a single active tree |
| `ebf10c9` | move drag-free v2 evidence under consolidated root | Planning/research evidence nested under consolidated root |
| `2a92d69` | finish numbered `workflows-drag-free` layout | **Current active layout**: numbered dirs under `workflows-drag-free/` |

### 1.3 Preceding completed work (`plans-completed/`)

`00-project/plans-completed/` currently holds the 2026-07-03 deep-review remediation series (not the Phase 6 promote itself):

| File | Relevance |
|------|-----------|
| `review/2026-07-03-workflow-scripts-deep-review-260703-1337-claude.md` | Baseline audit of v1.7-era Workflow-Scripts (scripts, review policy, safety) |
| `review/2026-07-03-workflow-scripts-deep-review-follow-up-implementation-plan.md` | Shared review core, rubric-only priority, `update-workflows.sh` safety |
| `review/2026-07-03-workflow-scripts-deep-review-remediation.md` | Completed hardening on branch `v1.7` |

Those plans established **quality baselines** that Drag-Free-v2 then tried to encode as machine contracts (`core/meta/review-workflow-core.md`, roles, standards, skill layer). They do **not** authorize treating the partial Phase 6 promote as finished.

`plans-completed/README.md` now frames that folder as the archive for **Drag-Free-v2 consolidation** completed plans. Migration/remediation plans after 2026-07-07 are not yet filed there; the problem statement and this comparison live under `research/`.

---

## 2. Inventory Snapshot (2026-07-10)

### 2.1 `workflows-drag-free/` (active)

```text
workflows-drag-free/
  00-Drag-Free-v2/          # Plans + research evidence for the v2 design
  00-core/                  # meta, roles, standards, debt-ledger
  00-setup/                 # Full setup suite (9 files)
  01-planning/ … 07-deployment/
  12-seo-geo/
  reference/
    00-meta-workflow/
    08-api-integration/     # Full API integration tree (real content)
    10-technical-docs/      # Full Gemini docs (real content)
  tools/                    # orchestrator + wf CLI (WF_ROOT-aware)
  catalog.json, ROUTER.md, MOVED.json, MOVED.md
```

**Not present here:** `11-Skills/`, root `scripts/`, `dist/`, project `README.md`, nested operational `00-project/`, hero media.

### 2.2 `00-project/Drag-Free-v2/` (archive / evidence)

```text
00-project/Drag-Free-v2/
  # Dual / hybrid layout
  00-Meta-Workflow/         # mostly stubs
  00-project-setup/ … 12-SEO-GEO-checklist/   # mostly stubs
  08-API-Integration/       # stubs (targets never created)
  11-Skills/                # real skill baselines
  workflows/                # partial canonical (planning/build/review ok; deploy/seo/setup incomplete)
  core/                     # mixed: roles/standards real; several meta self-stubs
  reference/                # mostly stubs / empty targets
  00-project/               # full nested operational meta (~334 files)
  dist/, scripts/, tools/, templates/, media/
  README.md, SHARING_AND_SYNC.md, catalog.json, MOVED.*
```

Its own `README.md` banner (2026-07-07) says it is **promotion evidence only** and that the active topology is repo-root `workflows/`, `core/`, etc. **That banner is stale:** on the current branch those root paths no longer exist; the active library is `workflows-drag-free/`.

### 2.3 Live repository root (compatibility shell)

| Area | State |
|------|--------|
| Numbered workflow dirs (`00-project-setup` … `12-SEO-GEO-checklist`, `08-API-Integration`, `10-technical-docs`) | Almost entirely **`# Moved` stubs** → `workflows-drag-free/...` |
| `00-Meta-Workflow/` | Mostly stubs; **4 real files** remain under `00-plans-completed/` (not in `MOVED`) |
| `11-Skills/` | **Still live, real content** (not stubbed; not inside `workflows-drag-free`) |
| `00-project/` | Live operational meta (changelog, plans, research, troubleshooting) |
| Root `workflows/`, `core/`, `MOVED.json`, `catalog.json`, `tools/wf` | **Absent** (moved into / replaced by `workflows-drag-free/`) |

---

## 3. Structural Comparison

### 3.1 Layout philosophy

| Concern | `workflows-drag-free` | `00-project/Drag-Free-v2` |
|---------|----------------------|---------------------------|
| Workflow home | Numbered dirs at package root (`01-planning/`, `02-build/`, …) | Dual: legacy numbered (stubs) **plus** `workflows/<category>/` |
| Core partials | `00-core/` | `core/` (and stubbed `00-Meta-Workflow/00-meta/`) |
| Reference material | `reference/00-meta-workflow`, `08-api-integration`, `10-technical-docs` | Intended `reference/meta-workflow`, `api-integration`, `technical-docs` (largely missing) |
| Redirect prefixes | Targets use `workflows-drag-free/...` | Targets use package-relative `workflows/`, `core/`, `reference/` |
| Package vs monorepo | Self-contained workflow package | Full Workflow-Scripts repo snapshot (skills, scripts, nested `00-project`, dist) |

### 3.2 Path scheme (same logical workflow, different coordinates)

Example: research-and-plan

| Surface | Path |
|---------|------|
| Live stub | `01-planning-and-organizing/00-research-and-plan.md` → points to WDF |
| Active content | `workflows-drag-free/01-planning/00-research-and-plan.md` |
| Archive dual (legacy) | `00-project/Drag-Free-v2/01-planning-and-organizing/00-research-and-plan.md` (stub) |
| Archive dual (canonical) | `00-project/Drag-Free-v2/workflows/planning/00-research-and-plan.md` (real, 392 lines) |

`MOVED.md` generators even differ by name:

- WDF: *"generated by the Drag-Free-v2 **directory consolidation**"*
- DFV2: *"generated by the Drag-Free-v2 **Phase 6 directory rationalization**"*

---

## 4. Content Fidelity Analysis

### 4.1 Stub / integrity metrics

| Metric | `workflows-drag-free` | `00-project/Drag-Free-v2` |
|--------|----------------------|---------------------------|
| Total files (approx) | 177 content files | 774 |
| `# Moved` stubs | **0** | **131** |
| `MOVED.json` entries | 146 | 146 |
| Redirects → real content | **146 (100%)** | **38 (26%)** |
| Redirects → missing | 0 | **92 (63%)** |
| Redirects → self-stub | 0 | **16 (11%)** |

WDF is the only tree where the redirect contract is true.

### 4.2 Lifecycle workflow bodies

Comparing WDF numbered categories to DFV2 `workflows/*`:

| Area | Same substance? | Notes |
|------|-----------------|-------|
| Planning | Yes | Diffs are **relative path rewrites** (`../02-build/` vs `../build/`, `00-core` vs `core`) |
| Build | Yes | Same path-rewrite pattern |
| Debugging | Yes | WDF **adds** `README.md` |
| Documentation | Yes | WDF **adds** `README.md` |
| Review | Mostly yes | WDF slightly longer on architecture/deep-review/comprehensive-audit (link path + small edits) |
| Security | Yes | WDF **adds** `README.md` |
| Setup | WDF **superset** | DFV2 `workflows/setup` has only 4 files; WDF has full 9 including optimize/mcp/skills/migrate + README |
| Deployment | WDF **superset** | DFV2 has only `00-deploy.md`; WDF has full Electron/port/SEO deployment set |
| SEO/GEO | WDF **only** | DFV2 `workflows/seo-geo/` **missing entirely**; legacy dir is stubs |

### 4.3 Core / meta / roles / standards

| Subtree | Relationship |
|---------|----------------|
| `roles/*` (9 files) | **Byte-identical** between WDF `00-core/roles` and DFV2 `core/roles` |
| `standards/*` | Nearly identical; WDF `security-baseline.md` is 2 lines longer |
| `debt-ledger.md` | Identical |
| `meta/*` | **WDF restored real content** for files that are self-stubs in DFV2 (`README`, `agent-flexibility-review`, `filename-review`, `parallel-agents-review`, `sync-summary-template`) |
| Shared good meta | `glossary`, `naming-conventions`, `review-workflow-core`, `severity-priority-rubric`, `agent-spawning-policy` present in both as real content |

This directly matches the 2026-07-07 finding that Phase 6 stubbed some **canonical** paths.

### 4.4 Reference / API / technical docs

| Material | WDF | DFV2 |
|----------|-----|------|
| `08-API-Integration` body (Genkit, AI SDK, Higgsfield, Firebase, nginx, …) | Full under `reference/08-api-integration/` | Legacy tree **stubbed**; `reference/api-integration/` **never populated** |
| Gemini technical docs | Full under `reference/10-technical-docs/` | Mostly stubs; three Image Generation files were historically left unmigrated in other trees |
| Meta-workflow docs | Full under `reference/00-meta-workflow/` | Canonical targets largely self-stubbed |

Roughly **28 of 53** API-integration files still hash-match between WDF reference and DFV2 legacy paths (binary/code assets and some docs); the **25 md stubs** are where DFV2 lost readable content at both ends of the redirect.

### 4.5 `tools/wf` divergence (meaningful, not cosmetic)

WDF `tools/wf` was extended so the package can live as a subdirectory:

- Auto-detect `cwd.name == "workflows-drag-free"` or `./workflows-drag-free` as `WF_ROOT`
- `metadata_root()` can resolve to the **parent** repo's `00-project` when running inside the nested package
- Additional path handling for the numbered layout

DFV2 `tools/wf` is the earlier package-root-oriented CLI (~570 lines vs WDF ~598).

### 4.6 Exclusive content in DFV2 (not in WDF)

These are why DFV2 is larger and still somewhat useful as an archive:

| Exclusive area | Approx | Value |
|----------------|--------|-------|
| Nested `00-project/` | 334 files / ~3.6 MB | Snapshot of consolidation-era logs, plans, build evidence; heavily overlaps live `00-project/` (~297 common paths) |
| `dist/skills/` | 154 files | Generated skill bundles |
| `11-Skills/` | 39 files | Hand-authored skill baselines (also still live at repo root `11-Skills/`) |
| `scripts/` | 14 files | Sync/update/validation scripts (live copies also exist at repo root) |
| Root `README.md`, `SHARING_AND_SYNC.md` | large | Full product docs for Workflow-Scripts as a whole |
| `media/` | hero banner | Branding asset |

**Important:** Skills, scripts, and live operational meta were **not** fully folded into `workflows-drag-free/`. Consolidation so far moved the **workflow library**, not the entire product surface.

### 4.7 Exclusive / superior content in WDF

| Superior area | Why it matters |
|---------------|----------------|
| Full deployment suite | DFV2 promote never copied Electron/port guides into `workflows/deployment/` |
| Full setup suite | 5 of 9 setup docs missing from DFV2 canonical `workflows/setup/` |
| Full SEO/GEO | Entire category missing from DFV2 `workflows/` |
| Restored meta docs | Self-stubs fixed |
| Full API + Gemini reference | Targets exist with content |
| Perfect `MOVED` integrity | Safe redirect contract |
| Planning evidence under `00-Drag-Free-v2/` | Design plans colocated with library (also duplicated under live `00-project/plans/Drag-Free-v2/`) |

---

## 5. Relationship to Live Root and Prior Research

### 5.1 Current consumer path

```text
User / agent opens old path
  e.g. 01-planning-and-organizing/00-research-and-plan.md
        ↓ stub
workflows-drag-free/01-planning/00-research-and-plan.md
        ↓ may reference
workflows-drag-free/00-core/...
workflows-drag-free/02-build/...
```

Skills still load from **repo-root** `11-Skills/`. Operational records still go to **repo-root** `00-project/` (and WDF `wf` already knows how to find that metadata root).

### 5.2 How this updates the 2026-07-07 problem statement

| 2026-07-07 open issue | Status on 2026-07-10 |
|-----------------------|----------------------|
| Incomplete promote (92 missing targets) | **Repaired inside `workflows-drag-free/`** (0 missing); still true **inside DFV2 archive** |
| Self-stubbed `core/meta` | **Fixed in WDF**; still broken in DFV2 archive |
| Which tree is SoT for promote? | **`workflows-drag-free/` is SoT for workflow content**; DFV2 is evidence |
| Live root hybrid confusion | Live root is now a **stub shell + skills + 00-project + scripts**, not a second incomplete `workflows/` tree |
| Do not treat `v2.0a` as complete | Still valid at product level: skills packaging, README entrypoints, and DFV2 archive cleanup remain |

### 5.3 Triplication of design plans

The same Drag-Free design package currently appears in three places:

1. `workflows-drag-free/00-Drag-Free-v2/` (unified plan, skill-layer plan, research/)
2. `00-project/plans/Drag-Free-v2/` (same set under live operational plans)
3. Nested history inside `00-project/Drag-Free-v2/00-project/...` (older nesting)

Only one of these should remain the long-term canonical **design archive** (recommend: live `00-project/plans/` or `plans-completed/` after filing; keep a short pointer from WDF).

---

## 6. Side-by-Side Directory Map

| Logical area | Active (`workflows-drag-free`) | Archive (`00-project/Drag-Free-v2`) | Live root |
|--------------|--------------------------------|-------------------------------------|-----------|
| Setup workflows | `00-setup/` (complete) | `workflows/setup/` (partial) + stubbed `00-project-setup/` | stubs → WDF |
| Planning | `01-planning/` | `workflows/planning/` + stubbed `01-…` | stubs → WDF |
| Build | `02-build/` | `workflows/build/` + stubs | stubs → WDF |
| Debug | `03-debugging/` | `workflows/debugging/` + stubs | stubs → WDF |
| Docs | `04-documentation/` | `workflows/documentation/` + stubs | stubs → WDF |
| Review | `05-review/` (+ deep-review) | `workflows/review/` + stubs | stubs → WDF |
| Security | `06-security/` | `workflows/security/` + stubs | stubs → WDF |
| Deployment | `07-deployment/` (complete) | mostly missing under `workflows/deployment/` | stubs → WDF |
| SEO/GEO | `12-seo-geo/` | missing under `workflows/`; legacy stubs | stubs → WDF |
| Core meta/roles | `00-core/` | `core/` (partially stubbed meta) | none at root |
| API reference | `reference/08-api-integration/` | stubbed only | stubs → WDF |
| Skills | **not in WDF** | `11-Skills/` | **live `11-Skills/`** |
| Scripts / validation | orchestrator only under WDF | full `scripts/` | **live `scripts/`** |
| Operational meta | via parent `00-project/` | nested full `00-project/` | **live `00-project/`** |
| Router / catalog / MOVED | present in WDF | present but inconsistent with FS | **not at root** |

---

## 7. Risks If the Wrong Tree Is Used

| Mistake | Consequence |
|---------|-------------|
| Agent follows DFV2 `MOVED.json` / stubs | Dead ends (missing targets / self-stubs); false "file moved" loops |
| Treat DFV2 README "active topology" banner as truth | Looks for root `workflows/` that no longer exists on this branch |
| Edit DFV2 thinking it is the consolidation target | Diverges from WDF; wasted work; dual SoT |
| Delete DFV2 immediately without sampling exclusive nested build logs | Loss of archive evidence (mostly recoverable from git, but nested-only files exist) |
| Assume WDF is a full product drop-in for the whole repo | Skills, scripts, README, SHARING_AND_SYNC still live outside WDF |

---

## 8. Recommendations

### 8.1 Authoritative roles (declare explicitly)

1. **`workflows-drag-free/`** — **canonical active workflow library** (content + redirects + router/catalog + `wf`).
2. **Repo-root `11-Skills/`, `scripts/`, `00-project/`** — still canonical for skills, tooling, and operational records.
3. **`00-project/Drag-Free-v2/`** — **read-only archive** of the partial promote + consolidation sandbox. Do not extend it.

### 8.2 Near-term cleanup (when ready)

1. **Banner fix** on `00-project/Drag-Free-v2/README.md`: point active consumers to `workflows-drag-free/`, not root `workflows/`.
2. **Deduplicate design plans**: keep one copy under `00-project/plans/` or `plans-completed/`; leave a short pointer in `workflows-drag-free/00-Drag-Free-v2/README.md`.
3. **Archive DFV2** under something like `00-project/build/archive/drag-free-v2-promotion-snapshot-2026-07/` **or** delete after confirming no unique unrecovered files (prefer `git` retention + a small evidence note).
4. **File a completed remediation plan** under `plans-completed/migration/` summarizing: problem statement → redirect repair → numbered WDF layout.
5. Decide whether **skills** eventually move under `workflows-drag-free/` or stay root-level; document in ROUTER/README either way.
6. Add a validator: every live-root stub target must exist and must not be a stub (extend WDF `MOVED` check to root stubs).

### 8.3 Do not do

- Do not re-promote DFV2’s hybrid dual layout over WDF.
- Do not merge DFV2 into main as "the" v2 tree.
- Do not stub `11-Skills` until a destination package is chosen and populated.

---

## 9. Evidence Appendix

### 9.1 Sample content comparison (`00-research-and-plan.md`)

- Line counts equal (392).
- Diffs limited to relative links, e.g.:
  - DFV2: `../../core/meta/severity-priority-rubric.md`
  - WDF: `../00-core/meta/severity-priority-rubric.md`
  - DFV2: `../build/01-execution.md`
  - WDF: `../02-build/01-execution.md`

### 9.2 Redirect sample

| Old path | WDF new path | DFV2 new path |
|----------|--------------|---------------|
| `01-planning-and-organizing/00-research-and-plan.md` | `workflows-drag-free/01-planning/00-research-and-plan.md` | `workflows/planning/00-research-and-plan.md` |
| `08-API-Integration/README.md` | `workflows-drag-free/reference/08-api-integration/README.md` | `reference/api-integration/README.md` (missing in DFV2 FS) |
| `00-Meta-Workflow/00-meta/agent-flexibility-review.md` | `workflows-drag-free/00-core/meta/...` (real, 475 lines) | `core/meta/...` (self-stub in DFV2) |

### 9.3 Key source artifacts consulted

| Artifact | Path |
|----------|------|
| Prior problem statement | `00-project/research/2026-07-07-drag-free-v2-migration-problem-statement.md` |
| Unified plan (WDF copy) | `workflows-drag-free/00-Drag-Free-v2/2026-07-06-drag-free-v2-unified-implementation-plan.md` |
| Unified plan (ops plans) | `00-project/plans/Drag-Free-v2/2026-07-06-drag-free-v2-unified-implementation-plan.md` |
| Skill layer plan | `workflows-drag-free/00-Drag-Free-v2/2026-07-06-drag-free-v2-workflow-skill-layer-plan.md` |
| Completed deep-review plans | `00-project/plans-completed/review/*` |
| WDF redirects | `workflows-drag-free/MOVED.json`, `MOVED.md`, `catalog.json`, `ROUTER.md` |
| DFV2 redirects | `00-project/Drag-Free-v2/MOVED.json`, `MOVED.md` |
| Live TODO / consolidation status | `00-project/plans/TODO.md` |
| DFV2 nested AGENTS framing | `00-project/AGENTS.md`, `00-project/README.md` |

### 9.4 Measurement method

Filesystem inventory and pairwise hashing performed 2026-07-10 on branch `fix/v2.0a-separate-legacy-and-v2` at commit `2a92d69`. Stub detection: markdown whose body starts with `# Moved` or is a short "This file moved to …" note.

---

## 10. Status

**Complete (investigation).**  

- **Active consolidation target:** `workflows-drag-free/`  
- **Archive only:** `00-project/Drag-Free-v2/`  
- **Follow-up work remaining:** archive/delete decision for DFV2, plan filing into `plans-completed/migration/`, skills placement decision, stale banner/README updates, optional root-stub validator.

This document does not change code; it records the comparison requested for consolidation decision-making.
