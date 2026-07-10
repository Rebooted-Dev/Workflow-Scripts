---
id: research-numbered-folders-08-11-audit
version: 1.2
category: research
kind: reference
title: "Numbered Folders 08–11 Structure Audit (root vs workflows-drag-free)"
date: 2026-07-10
model: fable-5
status: complete
---

# Numbered Folders 08–11 Structure Audit

**Question investigated:** `workflows-drag-free/` has no `08-`, `09-`, `10-`, or `11-` top-level folders while the repo root has `08-API-Integration`, `10-technical-docs`, and `11-Skills`. Are files missing, or does one tree reflect a pre-v1.7 organization?

**Verdict: Nothing is missing and neither tree is stale.** The asymmetry is the *intended* Drag-Free-v2 design. Every apparent divergence is explained by three deliberate decisions recorded in the migration plans. All 146 redirect targets validate cleanly (`scripts/validation/check-moved-targets.sh`: `missing=0, self_stubbed=0, stub_mismatches=0, malformed=0`).

**Follow-up question (v1.2):** Are the files *inside* `workflows-drag-free/07-deployment/` in the correct place?  
**Short answer: mostly, but not all.** The folder is the right topic bucket for deployment work; it currently mixes reusable workflows, deployment guides, and two misfiled non-workflows (a project plan and a completed historical report). See §6.

---

## 1. The two trees have different roles

| Tree | Role |
|---|---|
| Repo root numbered dirs (`00-` … `12-`) | **Compatibility stubs** — every file is a `# Moved` tombstone pointing into `workflows-drag-free/`. Kept "for one release" so host projects that open old paths still land somewhere. |
| `workflows-drag-free/` | **The master workflow package** — the only tree with real content, per the 2026-07-10 single-master-directory reconciliation plan. |

Stub census of the root numbered dirs (files excluding `.DS_Store`):

| Root dir | Files | `# Moved` stubs |
|---|---|---|
| `00-project-setup` | 9 | 9 |
| `01-planning-and-organizing` | 7 | 7 |
| `02-code-build` | 4 | 4 |
| `03-debugging` | 3 | 3 |
| `04-documentation` | 7 | 7 |
| `05-review` | 6 | 6 |
| `06-security` | 3 | 3 |
| `07-deployment` | 11 | 11 |
| `08-API-Integration` | 53 | **53** |
| `10-technical-docs` | 14 | **14** |
| `11-Skills` | 39 | **0 (all real content — see §3)** |
| `12-SEO-GEO-checklist` | 7 | 7 |
| `00-Meta-Workflow` | 26 | 22 (4 real files, all under `00-plans-completed/` — historical plans deliberately retained) |

## 2. Where 08 and 10 went: `reference/`, not numbered folders

`08-API-Integration` and `10-technical-docs` are **reference material, not workflows**, so the v2 layout demoted them out of the numbered sequence into:

- `workflows-drag-free/reference/08-api-integration/` — 53/53 files present; file lists match the root tree exactly.
- `workflows-drag-free/reference/10-technical-docs/` — 14/14 files present; file lists match exactly.
- (`00-Meta-Workflow` reference docs similarly live under `reference/00-meta-workflow/`.)

Every root↔drag-free "content diff" for 08/10/12 is simply **stub vs. real file** — the root copy is a tombstone, the drag-free copy is the live document. There is no version drift: the real content only exists in `workflows-drag-free/`, so it cannot be "an earlier version" of anything. `MOVED.md` / `MOVED.json` / `catalog.json` (`redirects`, 146 rows) carry the full old→new map, and the validation script confirms every target exists and is non-stub.

## 3. Why `11-Skills` has no drag-free counterpart: it stays at repo root by design

`11-Skills/` (39 files: 19 skill dirs with `SKILL.md` + `agents/openai.yaml`, plus a skill-candidate scan doc) is **live product content, not a workflow**, and was explicitly scoped out of the drag-free package:

- The 2026-07-10 reconciliation plan classifies `11-Skills/`, `scripts/`, `00-project/`, README, `media/`, `dist/` as **"product/ops surfaces (not a second workflow library)" → "Keep at repo root."**
- The unified implementation plan (Phase 5) makes `11-Skills/*/SKILL.md` the **quality baseline** for `tools/wf build skills`, which generates Claude/Codex/OpenCode/Droid bundles into `dist/skills/`, with the instruction: *"do not delete `11-Skills/` until generated output is reviewed and accepted."*
- The dual-tree comparison (2026-07-10) verified live `11-Skills/` is byte-identical (39/39) with the now-retired DFV2 snapshot — it was never at risk.

So `11-Skills` absent from `workflows-drag-free/` is correct: it is the *source of truth* awaiting eventual replacement by generated bundles after parity review, not a missed migration.

## 4. Why there is no `09-` in either tree

`09-` was retired long before Drag-Free-v2, in two historical reorganizations:

- Commit `12d9569`: `09-skills` content was integrated into `06-skills-setup` (now `00-setup/06-skills-setup.md`) and its symlinks removed.
- Commit `7d020b4` ("reorganize API guides and add Gemini technical references"): remaining 09/10/11-numbered *guides* were folded into `08-API-Integration` as files — which is why `08-API-Integration/` contains `09-nextjs-react-update.md`, `10-firebase-setup.md`, and `11-nginx.md`. Those in-folder file numbers are a fossil of the old top-level numbering and are a likely source of the confusion; they too are mirrored intact at `workflows-drag-free/reference/08-api-integration/`.

## 5. Findings summary

| Concern | Finding |
|---|---|
| Files missing from 08/10? | **No.** 53/53 and 14/14 mirrored under `reference/`; root copies are stubs. |
| Files missing from 11? | **No.** `11-Skills/` deliberately lives at repo root only (product surface). |
| 09 lost? | **No.** Retired pre-v1.7; content folded into `06-skills-setup` and `08-API-Integration`. |
| Drag-free reflects pre-v1.7 layout? | **No — the opposite.** Drag-free *is* the v2 master layout; the root numbered dirs are the legacy shape, retained as redirect stubs for one release. |
| Redirect integrity | 146/146 targets exist, non-stub, validated by `check-moved-targets.sh`. |
| Are `07-deployment/` files in the correct place? | **Mostly.** Right topic bucket; two files misfiled (project plan + historical report). Numbering gaps are fossil, not loss. README has broken outbound links. See §6. |

---

## 6. `07-deployment/` — are the files in the correct place?

### Placement rule used

| Artifact type | Correct home |
|---|---|
| Reusable workflow ("run this process") | Numbered workflow folder (`07-deployment/`) |
| Long-lived how-to / platform / migration guide | `07-deployment/` **or** `reference/` (both OK if linked from the decision tree) |
| Active plan / todos (project state) | `00-project/plans/` |
| Completed one-off report / archive | `00-project/research-completed/`, changelog archive, or `reference/` history |
| SEO/GEO checklists | `12-seo-geo/` (README already points there) |

By that standard: `07-deployment/` is the right home for deployment **workflows and guides**. It is **not** the right home for project plan state or completed historical reports.

### Short answer

**Mostly no — not all of them are correctly placed.**

The folder is the right **topic bucket** for deployment work, but it currently mixes three kinds of things:

1. **Reusable deployment workflows** → correct here  
2. **Deployment-related reference guides** → acceptable here (or could live under `reference/`)  
3. **Project history / project plan state** → **wrong place**

The folder is not "missing files" and is not randomly broken. Two files are clearly misfiled; several others are only "right enough" because of 1:1 historical migration, not clean design. Fossil numbering (gaps 03–06, `08` prefix trio) is cosmetic residue, not evidence of loss.

### How the folder got this shape

`workflows-drag-free/07-deployment/` was migrated **1:1 from the root folder with every legacy filename preserved verbatim** (all 11 MOVED.md rows are straight `07-deployment/X → workflows-drag-free/07-deployment/X` copies). That preservation is what makes the folder look disorganized — the numbering is a fossil of at least two earlier reorganizations, not a current scheme.

### Per-file placement call

| File | Kind (actual) | Catalog | Correct place? | Notes |
|---|---|---|---|---|
| `00-deploy.md` | v2 workflow (`kind: workflow`, `category: deployment`, prev/next) | ✅ workflow/deployment | **Yes** | Canonical deploy workflow; `00-` = entry point. |
| `01b-electron-vite.md` | v2 workflow | ✅ workflow/deployment | **Yes** | Reusable deploy/migration workflow; pairs with 01a. |
| `08a-pre-deployment-security-check.md` | v2 workflow (`prev: confirm-execution`, `next: deploy`) | ✅ workflow/deployment | **Yes (content)** | Correct domain and chain. Prefix `08a` is fossil numbering, not wrong location. Logically sits *between* deploy gates, not at position 8. |
| `README.md` | Folder index / decision tree | — | **Yes** | Location fine; outbound links need fixing (see defects). |
| `01a-MACOS_ELECTRON_GUIDE.md` | Reference guide (no frontmatter) | ❌ none | **Acceptable** | Deployment-target guide; pairs with `01b`. Not a formal workflow, belongs with desktop deploy docs. |
| `02-ai-studio-to-desktop.md` | ~2253-line migration reference (no frontmatter; doc says "2100+") | ❌ none | **Borderline / acceptable** | Deployment-scoped and linked from the decision tree. Could live under `reference/`; keeping it here is reasonable. |
| `08-port-relocation/` (3 files) | Dev-tooling guides (ports, browser auto-open) | ❌ none | **Borderline** | Dev-server tooling, not production deploy. Related enough that README includes it; purists would put it under `reference/` or tooling. **Not wrong enough to force a move.** Fossil `08-` prefix. |
| `07-seo-…_1cca3e93.plan.md` | **Project plan** (`.plan.md`, live `todos:`, UUID-hash suffix) | ⚠️ record exists, `kind: None`, `category: None` | **No** | Per-project planning state, not a reusable workflow. Belongs under `00-project/plans/` (or `12-seo-geo/` only if generalized into a reusable workflow). The `07-` prefix is coincidental and collides with the parent folder number. |
| `08b-DEPLOYMENT_OPTIMIZATION_REPORT.md` | **Historical report** (2026-01-18, status COMPLETED) | ❌ none | **No** | One-time completed optimization report. Archive material — `reference/` history or `00-project` research/changelog archive — not a live deploy procedure. |

**Summary groups:**

| Placement | Files |
|---|---|
| **Correct in `07`** | `00-deploy`, `01a`, `01b`, `08a`, `README` |
| **OK in `07`** | `02-ai-studio-to-desktop`, `08-port-relocation/` |
| **Not correct in `07`** | SEO `.plan.md`, `08b` optimization report |

### Why the numbering looks broken (and what it actually encodes)

- **Gaps 03–06 are deletions, not losses.** `08b-DEPLOYMENT_OPTIMIZATION_REPORT.md` itself documents the 2026-01-18 optimization that cut the folder's file count by 27% — the removed files vacated slots 03–06, and survivors kept their old numbers.
- **The `08` trio (`08-port-relocation/`, `08a`, `08b`) are three unrelated things** sharing a prefix: a dev-tooling subfolder, a workflow, and an archived report. The prefix is positional residue from the pre-optimization layout.
- **This in-folder `07`/`08` numbering is a second, independent numbering plane** from the top-level `07-deployment`/`08-API-Integration` folders — the same fossil-numbering pattern as `08-API-Integration/09-*.md` noted in §4, and a compounding source of the original 08–11 confusion.
- **Do not renumber the whole folder just for placement correctness** — numbering is cosmetic fossil; moving the two misfiled files is the real placement fix.

### Defects found (README link rot + catalog)

The `07-deployment/README.md` decision tree and guide sections contain **seven broken link occurrences** in two styles (three target files):

1. `../09-11 Misc/10-firebase-setup.md`, `../09-11 Misc/11-nginx.md`, `../09-11 Misc/09-nextjs-react-update.md` — the folder `09-11 Misc` does not exist anywhere in the repo (pre-consolidation name from commit `7d020b4`).
2. `../../reference/api-integration/…` (four occurrences; Firebase linked twice) — wrong on two counts: `../../` escapes `workflows-drag-free/`, and the folder is `08-api-integration`, not `api-integration`. Correct form: `../reference/08-api-integration/…`.

Catalog coverage is partial: only 3 of the folder's ~10 content files have proper `workflow/deployment` records; the plan file has a degenerate record (`kind: None`); the guides, port-relocation docs, and report have none.

### Recommended dispositions (smallest change that rationalizes the folder)

**P0 — fix links (location already correct):**

1. Fix README broken links to `../reference/08-api-integration/{09-nextjs-react-update,10-firebase-setup,11-nginx}.md`.

**P1 — move the two misfiled files:**

2. Move `07-seo-…_1cca3e93.plan.md` → `00-project/plans/` (project state). Only promote/generalize into `12-seo-geo/` if it becomes a reusable workflow rather than plan state.
3. Move `08b-DEPLOYMENT_OPTIMIZATION_REPORT.md` → `reference/` or `00-project` research/changelog archive (history).
4. Leave redirect rows in `MOVED.md` / `catalog.json` and regenerate or patch catalog so the SEO plan is not a `kind: None` deployment record.

**P2 — optional later (do not do piecemeal):**

5. Optionally renumber survivors to close gaps (`00, 01a, 01b, 02, 03-port-relocation/, 04-pre-deployment-security-check`) and give remaining guides catalog records. Treat as a **new small remediation**, not unfinished Phase 6 — Phase 6 Directory Rationalization is already marked complete for the master-tree moves; residual fossil numbering in `07` is post–Phase 6 cleanup.

**Leave in place:** real deploy workflows and desktop guides (`00-deploy`, `01a`, `01b`, `08a`, README); `02` and `08-port-relocation/` may stay.

---

## 7. Optional follow-ups (no action required for 08–11)

1. When the one-release stub grace period ends, strip the root numbered stub dirs (except `11-Skills/`) per the reconciliation plan's "Root numbered stubs: keep one release (default) or strip later."
2. Consider renaming `09-*.md`, `10-*.md`, `11-*.md` files inside `reference/08-api-integration/` to remove the fossil numbering that invites exactly this confusion — only with a full inbound-link pass.
3. `11-Skills/` retirement is gated on `tools/wf build skills` output passing parity review — track that in the Phase 5 checklist, not here.
4. Do **not** move `11-Skills/` into drag-free; do **not** treat drag-free as a stale pre-v1.7 tree.

---

*Method: full directory listings of both trees; per-folder `# Moved` stub census; `find`-based file-list diffs and `diff -rq` content diffs for 08/10/12; `MOVED.md`/`catalog.json` redirect cross-check; `check-moved-targets.sh` run; git history trace for `09-*` (`12d9569`, `7d020b4`) and migration plans (`2026-07-06-drag-free-v2-unified-implementation-plan.md`, `2026-07-10-single-master-directory-reconciliation-plan.md`, `2026-07-10-drag-free-v2-dual-tree-comparison.md`). §6 (v1.1): per-file inspection of `07-deployment/` frontmatter, README link resolution against the filesystem, and `catalog.json` record cross-check. §6 (v1.2): placement rule table, explicit correct-place verdicts per file, and disposition priority (P0–P2) after independent review.*
