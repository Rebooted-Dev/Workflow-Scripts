# 2026-07-10 - Single Master Directory Reconciliation Plan

**Status:** ✅ COMPLETED / Executed (2026-07-10) — filed under `plans-completed/migration/`; Phase 7 skills nesting deferred by design
**Scope:** Workflow-Scripts system work only. `<metadata-root>` resolves to `00-project/`.  
**Branch (current):** `fix/v2.0a-separate-legacy-and-v2`  
**Execution workspace:** `/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts`  
**Plan home:** `workflows-drag-free/00-project/plans/` (this file)

## Implementation Status

- [✅] Phase 0 - Freeze Source of Truth and Preflight Inventory (working session treated DFV2 as frozen; master = WDF)
- [✅] Phase 1 - Salvage Unique Evidence (No Content Loss) — tarball + nested consolidated logs salvaged 2026-07-10
- [✅] Phase 2 - Deduplicate Design Plans and Pointers — design package filed under `workflows-drag-free/00-project/changelog/plans/`; ops `plans/Drag-Free-v2/` removed earlier
- [✅] Phase 3 - Update Entry Docs to Name One Master — `00-project/AGENTS.md` + `README.md` updated; further root README polish optional
- [✅] Phase 4 - Remove Second Tree (`00-project/Drag-Free-v2/`) — deleted after tarball verify 2026-07-10
- [✅] Phase 5 - Validate Redirects, Package, and Smoke Paths — `check-moved-targets.sh`, `check-active-markdown-links.sh`, `tools/wf validate` passed 2026-07-10
- [✅] Phase 6 - Bookkeeping, Changelog, and Optional Stub Policy — salvage inventory + changelog entries filed
- [ ] Phase 7 - (Optional / Later) Skills Nesting Decision

---

## 1. Proposal

Collapse the dual Drag Free surfaces into **one master workflow directory** without losing any real v2 workflow content.

| Surface today | Role | Action |
|---------------|------|--------|
| **`workflows-drag-free/`** | Healthy active v2 library (0 stubs; 146/146 `MOVED` targets real) | **Keep as sole master** — edit only here for workflows/core/reference/`wf` |
| **`00-project/Drag-Free-v2/`** | Broken hybrid promote snapshot (~131 stubs; 92 missing targets; 16 self-stubs) | **Salvage unique evidence → archive tarball → delete directory** |
| Live root numbered dirs | Compatibility stubs → `workflows-drag-free/...` | **Keep for one release** (default) or strip later |
| Live `11-Skills/`, `scripts/`, `00-project/`, root README | Product/ops surfaces (not a second workflow library) | **Keep at repo root** |

This plan does **not** re-run Phase 6 rationalization into a new layout. The numbered `workflows-drag-free/` package is already the repaired consolidation. Work is **reconciliation and deletion of the second tree**, plus docs and bookkeeping.

### Success criteria

1. Exactly **one** active Drag Free workflow package: `workflows-drag-free/`.
2. **No** live second tree at `00-project/Drag-Free-v2/`.
3. **Zero** loss of real v2 workflow, core, or reference content (all already present under the master, verified by inventory).
4. Unique non-workflow evidence from the second tree is preserved under `00-project/build/archive/` and/or a tarball.
5. Entry docs (`README`, `AGENTS`, `SHARING_AND_SYNC`, meta README) name the master explicitly.
6. `MOVED.json` integrity remains 100% (every target exists and is not a `# Moved` stub).
7. Changelog (+ troubleshooting only if something non-trivial breaks during execution) is updated.

### Non-goals

- Rewriting workflow prose or redoing frontmatter contracts.
- Merging skills into `workflows-drag-free/` (optional Phase 7 only).
- Force-pushing or rewriting `v1.7` history.
- Deleting live root numbered stubs in the same change set (optional follow-up unless user opts in during Phase 6).
- Promoting this branch to `main` / replacing `v1.7` consumption (separate decision).

---

## 2. Evidence Base

Read before executing. Do not re-discover from scratch.

| Artifact | Path |
|----------|------|
| Dual-tree comparison (SoT analysis) | `workflows-drag-free/00-project/research-completed/migration/2026-07-10-drag-free-v2-dual-tree-comparison.md` |
| Migration problem statement | `workflows-drag-free/00-project/research-completed/migration/2026-07-07-drag-free-v2-migration-problem-statement.md` |
| Unified v2 implementation plan (historical) | `workflows-drag-free/00-Drag-Free-v2/2026-07-06-drag-free-v2-unified-implementation-plan.md` |
| Skill layer plan (historical) | `workflows-drag-free/00-Drag-Free-v2/2026-07-06-drag-free-v2-workflow-skill-layer-plan.md` |
| Research proposals / surveys | `workflows-drag-free/00-Drag-Free-v2/research/` |
| Duplicate design package (ops) | `00-project/plans/Drag-Free-v2/` |
| Completed deep-review baseline | `00-project/plans-completed/review/` |
| Active redirects | `workflows-drag-free/MOVED.json`, `MOVED.md`, `catalog.json`, `ROUTER.md` |
| Broken archive redirects (for reference only) | `00-project/Drag-Free-v2/MOVED.json` |

### Quantitative facts (as of 2026-07-10 inventory)

| Metric | `workflows-drag-free` | `00-project/Drag-Free-v2` |
|--------|----------------------|---------------------------|
| Approx files | ~181 | ~775 |
| Size | ~2.5 MB | ~11 MB |
| `# Moved` stubs | **0** | **131** |
| `MOVED` redirects OK | **146/146** | **38/146** |
| Missing redirect targets | 0 | 92 |
| Self-stubbed targets | 0 | 16 |

### Content-loss risk assessment

| Claimed risk | Finding |
|--------------|---------|
| Workflow bodies only in DFV2 | **False** — DFV2 `workflows/*` real files are mirrored under WDF (path rewrites only) |
| Skills only in DFV2 | **False** — live `11-Skills/` is **byte-identical** (39/39) |
| Scripts only in DFV2 | **False** — live `scripts/` is **superset** (includes `validation/check-moved-targets.sh`) |
| Full API / deployment / SEO only in DFV2 | **False** — WDF is **more complete** (DFV2 promote never filled those canonical targets) |
| Unique DFV2 nested archive logs | **True** — ~37 files under nested `00-project/build/archive/workflow-scripts-consolidated-2026-07-06/` |
| DFV2 `dist/` richer | **Maybe** — 154 vs 77 generated files; prefer **regenerate** via `tools/wf build skills` over copying stale bundles |

**Conclusion:** Deleting `00-project/Drag-Free-v2/` after salvage + tarball does **not** delete the v2 library. The v2 library already lives in `workflows-drag-free/`.

---

## 3. Design Decisions

| Decision | Default | Rationale |
|----------|---------|-----------|
| Master directory | `workflows-drag-free/` | Only tree with perfect redirects and full deployment/setup/SEO/reference content |
| Second tree fate | Salvage → tarball → `rm -rf` | Stops dual-SoT confusion; git + tarball retain evidence |
| Product surfaces | Stay at **repo root** (`11-Skills/`, `scripts/`, `00-project/`, README, media, dist) | Not part of the workflow package; already live and current |
| Root numbered stubs | **Keep one release** (default) | Host projects may still open old paths; stubs already point at master |
| Design plan home | Canonical: `00-project/plans/Drag-Free-v2/` (or `plans-completed/migration/` when filed complete) | Ops meta belongs under metadata-root; WDF keeps a short pointer only |
| Evidence plan copy | **This file** stays under `workflows-drag-free/00-Drag-Free-v2/` until execution completes; then optionally mirror or file under `plans-completed/migration/` | Matches user request for plan location |
| Generated `dist/` | Regenerate from master if needed; do not treat DFV2 dist as source of truth | Avoids stale path bundles |
| Skills move under WDF | **Out of scope** unless Phase 7 approved | Larger product decision; not required for single workflow master |
| Changelog | Required under `00-project/changelog/` | Workflow-Scripts meta change |
| Troubleshooting | Only if execution hits a non-trivial failure | Not for clean salvage/delete |

### Target end-state layout

```text
Workflow-Scripts/
├── workflows-drag-free/                 # ★ ONLY master workflow library
│   ├── 00-core/
│   ├── 00-setup/ … 07-deployment/
│   ├── 12-seo-geo/
│   ├── reference/
│   ├── tools/                           # wf (WF_ROOT-aware) + orchestrator
│   ├── catalog.json
│   ├── ROUTER.md
│   ├── MOVED.json
│   ├── MOVED.md
│   └── 00-Drag-Free-v2/
│       ├── README.md                    # pointer to plans + research after dedupe
│       ├── 2026-07-10-single-master-directory-reconciliation-plan.md  # this plan
│       ├── (historical plans retained or pointed)
│       └── research/                    # design surveys (or pointer)
├── 11-Skills/                           # product-level skills
├── scripts/                             # sync / validation
├── 00-project/                          # operational meta
│   ├── plans/Drag-Free-v2/              # design plan archive (deduped)
│   ├── research/                        # comparison + problem statement
│   ├── build/archive/
│   │   ├── workflow-scripts-consolidated-2026-07-06/   # salvaged if missing
│   │   └── drag-free-v2-promotion-snapshot-YYYY-MM-DD.tar.gz
│   ├── changelog/
│   └── plans-completed/
├── README.md
├── SHARING_AND_SYNC.md
├── dist/                                # generated; optional regenerate
├── media/
├── templates/
└── [optional] legacy numbered dirs      # stubs → workflows-drag-free/…

# ABSENT after Phase 4:
# 00-project/Drag-Free-v2/
```

---

## 4. Phased Implementation Plan

### Phase 0 — Freeze Source of Truth and Preflight Inventory

**Priority:** P0  
**Goal:** Prevent further dual-tree edits; capture baseline measurements.

#### Tasks

- [ ] **0.1** Declare freeze in the working session: no new content under `00-project/Drag-Free-v2/`; all workflow edits go to `workflows-drag-free/` only.
- [ ] **0.2** Confirm current branch and clean enough working tree for intentional changes only.
  ```bash
  cd /Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts
  git branch --show-current
  git status -sb
  ```
- [ ] **0.3** Re-run a short integrity preflight (record counts in the execution log or confirm step):
  - WDF: stub count == 0; `MOVED` targets all exist and non-stub.
  - DFV2: still present (to be removed later).
  - Live `11-Skills/` still present with real content.
- [ ] **0.4** List unique nested archive paths still only under DFV2 (expected: `00-project/Drag-Free-v2/00-project/build/archive/workflow-scripts-consolidated-2026-07-06/`).
- [ ] **0.5** Confirm master has full critical categories before any delete:
  - `workflows-drag-free/00-setup/` (9 files)
  - `workflows-drag-free/07-deployment/` (full suite, not only `00-deploy.md`)
  - `workflows-drag-free/12-seo-geo/`
  - `workflows-drag-free/reference/08-api-integration/`
  - `workflows-drag-free/00-core/meta/agent-flexibility-review.md` (must be real content, not stub)

#### Exit criteria

- Freeze agreed; preflight shows WDF healthy and DFV2 still deletable-only after salvage.
- No workflow content unique to DFV2 found (or any surprise unique files are added to Phase 1 salvage list).

---

### Phase 1 — Salvage Unique Evidence (No Content Loss)

**Priority:** P0  
**Goal:** Preserve anything not already on live `00-project/` or regenerable from master.

#### Tasks

- [ ] **1.1** Create archive directory if missing:
  ```bash
  mkdir -p 00-project/build/archive
  ```
- [ ] **1.2** Copy unique nested consolidated logs if not already on live tree:
  ```bash
  SRC="00-project/Drag-Free-v2/00-project/build/archive/workflow-scripts-consolidated-2026-07-06"
  DEST="00-project/build/archive/workflow-scripts-consolidated-2026-07-06"
  if [ -d "$SRC" ] && [ ! -d "$DEST" ]; then
    cp -R "$SRC" "$DEST"
  fi
  ```
- [ ] **1.3** Create a full frozen tarball of the second tree **before** delete:
  ```bash
  tar -czf "00-project/build/archive/drag-free-v2-promotion-snapshot-$(date +%Y-%m-%d).tar.gz" \
    00-project/Drag-Free-v2
  ```
- [ ] **1.4** Verify tarball non-empty and lists expected top-level members:
  ```bash
  tar -tzf 00-project/build/archive/drag-free-v2-promotion-snapshot-*.tar.gz | head
  ls -lh 00-project/build/archive/drag-free-v2-promotion-snapshot-*.tar.gz
  ```
- [ ] **1.5** (Optional) If generated skill bundles matter immediately, prefer regenerating from master rather than copying DFV2 `dist/`:
  ```bash
  cd workflows-drag-free && ./tools/wf build skills
  # or project-documented equivalent build path
  ```
  Only rsync DFV2 `dist/` if regeneration is blocked **and** the user accepts stale path risk.
- [ ] **1.6** Write a one-file salvage inventory under:
  `00-project/build/archive/2026-07-10-drag-free-v2-salvage-inventory.md`  
  Contents: what was copied, tarball name/size, what was deliberately not copied (stubs, hybrid `workflows/`, duplicate skills).

#### Exit criteria

- Unique logs present under live `00-project/build/archive/`.
- Tarball exists and is non-trivial in size (~multi-MB).
- Salvage inventory filed.

#### Risk controls

- **Do not delete DFV2 in this phase.**
- Prefer `cp` / `tar` over moves until verification passes.

---

### Phase 2 — Deduplicate Design Plans and Pointers

**Priority:** P1  
**Goal:** One design archive; no three-way plan triplication after reconciliation.

#### Current triplication

1. `workflows-drag-free/00-Drag-Free-v2/` (unified plan, skill-layer plan, research/)
2. `00-project/plans/Drag-Free-v2/` (same design package under ops meta)
3. Nested inside `00-project/Drag-Free-v2/00-project/...` (goes away with Phase 4)

#### Tasks

- [ ] **2.1** Treat **`00-project/plans/Drag-Free-v2/`** as the long-term design archive under metadata-root (or prepare to move completed items to `00-project/plans-completed/migration/` after this plan executes).
- [ ] **2.2** Ensure `00-project/plans/Drag-Free-v2/` includes (or links to) this reconciliation plan once finalised — either copy this file there **or** add a one-line index README pointing at the WDF path. Prefer **pointer-from-ops → WDF plan during execution**, then file completed plan under `plans-completed/migration/` at close.
- [ ] **2.3** Add or update `workflows-drag-free/00-Drag-Free-v2/README.md` with:
  - Master statement: active library is parent `workflows-drag-free/`
  - Links to this reconciliation plan
  - Links to historical unified plan + skill-layer plan
  - Link to `00-project/research/2026-07-10-drag-free-v2-dual-tree-comparison.md`
  - Explicit note: `00-project/Drag-Free-v2/` is retired after Phase 4
- [ ] **2.4** Do **not** delete historical research under `workflows-drag-free/00-Drag-Free-v2/research/` in this plan (keep as colocated design evidence). Optional later: move research-only files under `00-project/research/` if token/nav cost is high.
- [ ] **2.5** If ops and WDF copies of the 2026-07-06 plans diverge, keep the newer content and note the choice in salvage inventory or changelog.

#### Exit criteria

- Clear README pointer model: one master library, one design evidence folder, no ambiguity that DFV2 path is active.
- This plan remains discoverable from both WDF evidence folder and ops plans index.

---

### Phase 3 — Update Entry Docs to Name One Master

**Priority:** P0  
**Goal:** Humans and agents stop treating DFV2 or root `workflows/` as active.

#### Files to update (minimum set)

| File | Required change |
|------|-----------------|
| Root `README.md` | State workflow library path = `workflows-drag-free/`; remove or correct any “active = root `workflows/` / `core/`” language; note legacy stubs |
| `SHARING_AND_SYNC.md` | Consumer sync guidance points at master package paths |
| `00-project/README.md` | Consolidation workspace language: DFV2 path retired; master is `workflows-drag-free/` |
| `00-project/AGENTS.md` | Agent map: edit workflows under `workflows-drag-free/`; do not extend `00-project/Drag-Free-v2/` |
| `00-project/Drag-Free-v2/README.md` | **Only if file still exists pre-delete:** banner “archived / pending removal”; after Phase 4 this file is gone |

#### Tasks

- [ ] **3.1** Grep for stale path claims and fix high-traffic entry docs:
  ```bash
  rg -n "00-project/Drag-Free-v2|active v2\.0a topology|repository-root \`workflows/\`|Drag-Free-v2/\` root" \
    README.md SHARING_AND_SYNC.md 00-project/README.md 00-project/AGENTS.md \
    workflows-drag-free -g '*.md' | head -80
  ```
- [ ] **3.2** Patch root README overview / structure section to show master package + root product surfaces.
- [ ] **3.3** Patch `SHARING_AND_SYNC.md` for host projects: preferred consume path is `workflows-drag-free/` (with stub fallback during compatibility window).
- [ ] **3.4** Patch `00-project/AGENTS.md` and `00-project/README.md` consolidation framing.
- [ ] **3.5** Skim `proj-organisation.md` and `workflows-drag-free/ROUTER.md` for contradictory maps; fix only if they claim DFV2 or missing root `workflows/` as active.

#### Exit criteria

- Grep for “active topology is the repository-root `workflows/`” returns no current guidance docs (archive tarball may still contain it).
- New agent reading root README can find the master in under 30 seconds.

---

### Phase 4 — Remove Second Tree

**Priority:** P0  
**Goal:** Delete `00-project/Drag-Free-v2/` after Phase 1–3 gates pass.

#### Preconditions (all must be true)

- [ ] Phase 1 tarball exists and is verified
- [ ] Phase 1 unique logs salvaged (or documented N/A if already present)
- [ ] Phase 0 preflight showed no unique real workflow files only in DFV2
- [ ] User has not requested a hold on deletion
- [ ] Working tree changes for docs/salvage are intentional and reviewable

#### Tasks

- [ ] **4.1** Final listing before delete:
  ```bash
  du -sh 00-project/Drag-Free-v2
  ls 00-project/Drag-Free-v2 | head
  ```
- [ ] **4.2** Remove the directory:
  ```bash
  rm -rf 00-project/Drag-Free-v2
  ```
- [ ] **4.3** Confirm absence:
  ```bash
  test ! -e 00-project/Drag-Free-v2 && echo "DFV2 removed"
  ```
- [ ] **4.4** Confirm master still intact:
  ```bash
  test -f workflows-drag-free/MOVED.json
  test -f workflows-drag-free/01-planning/00-research-and-plan.md
  test -d workflows-drag-free/07-deployment
  ```

#### Exit criteria

- `00-project/Drag-Free-v2/` does not exist.
- `workflows-drag-free/` unchanged in substance (except any intentional pointer/README edits from Phase 2).
- Tarball still readable.

#### Rollback

```bash
# From repo root, if tarball name is known:
tar -xzf 00-project/build/archive/drag-free-v2-promotion-snapshot-YYYY-MM-DD.tar.gz
# or recover from git history before the delete commit
```

---

### Phase 5 — Validate Redirects, Package, and Smoke Paths

**Priority:** P0  
**Goal:** Prove the single master still works after deletion.

#### Tasks

- [ ] **5.1** Redirect integrity (master):
  ```bash
  python3 - <<'PY'
  import json
  from pathlib import Path
  root = Path("workflows-drag-free")
  redirs = json.loads((root / "MOVED.json").read_text())
  # MOVED may be flat dict old->new
  items = redirs.items() if isinstance(redirs, dict) else []
  bad = []
  for old, new in items:
      # targets are repo-relative workflows-drag-free/...
      p = Path(new)
      if not p.exists():
          bad.append(("missing", new)); continue
      text = p.read_text(errors="replace").strip()
      if text.startswith("# Moved") or ("This file moved to" in text and len(text) < 500):
          bad.append(("stub", new))
  print(f"checked={len(list(json.loads((root/'MOVED.json').read_text()).items()))} bad={len(bad)}")
  for row in bad[:20]:
      print(row)
  raise SystemExit(1 if bad else 0)
  PY
  ```
- [ ] **5.2** Live root stub smoke (if stubs kept): open 3–5 legacy stubs and confirm targets exist under master, e.g.:
  - `01-planning-and-organizing/00-research-and-plan.md`
  - `07-deployment/00-deploy.md`
  - `00-project-setup/01-setup-project.md`
  - `08-API-Integration/README.md` (if stubbed)
- [ ] **5.3** Run package validation if available:
  ```bash
  cd workflows-drag-free && ./tools/wf validate
  # and/or
  ./tools/wf build --check
  ```
- [ ] **5.4** Run repo validators that still apply:
  ```bash
  # examples — use what exists on branch
  ./scripts/validation/check-moved-targets.sh   # if present
  ./scripts/validation/check-active-markdown-links.sh
  ```
- [ ] **5.5** Skills still loadable: confirm `11-Skills/*/SKILL.md` exist (count ≥ expected baseline).
- [ ] **5.6** Spot-read one large WDF deployment file and one meta file to ensure they are not stubs.

#### Exit criteria

- Redirect check exit 0.
- `wf validate` / build-check clean or only pre-existing known issues documented in debt/changelog.
- No broken “only path was DFV2” for skills/scripts/workflows.

---

### Phase 6 — Bookkeeping, Changelog, and Optional Stub Policy

**Priority:** P1  
**Goal:** Record the reconciliation; decide stub retention.

#### Tasks

- [ ] **6.1** Changelog entry under `00-project/changelog/`:
  - Type: `changed` or `config` (recommend `changed` for single-master reconciliation)
  - Name: `2026-07-10-changed-single-master-workflows-drag-free-reconciliation.md` (adjust date if execution day differs)
  - Index row at top of `00-project/changelog/index.md`
- [ ] **6.2** Troubleshooting entry **only if** execution hit a non-trivial issue (failed salvage, accidental content gap, redirect regression). Category likely `build/` or `git/`.
- [ ] **6.3** Update `00-project/plans/TODO.md` if it still lists DFV2 promotion as open/active incorrectly.
- [ ] **6.4** When this plan is fully executed and verified, **file as completed**:
  1. Copy or move to `00-project/plans-completed/migration/2026-07-10-single-master-directory-reconciliation-plan.md` (keep date prefix)
  2. Update `00-project/plans-completed/index.md` (newest first)
  3. Add Type=`plan` row to `00-project/changelog/index.md`
  4. Leave a short pointer in `workflows-drag-free/00-Drag-Free-v2/README.md`
- [ ] **6.5** **Stub policy decision (choose one):**

  | Option | When | Action |
  |--------|------|--------|
  | **A (default)** | Host projects may still use old paths | Keep root numbered stubs for one release; document sunset |
  | **B** | User wants maximum simplicity now | Delete pure stub trees after confirming no external docs require them; keep `11-Skills/`, `00-project/`, scripts, README |

  Record the chosen option in the changelog notes.

- [ ] **6.6** (If Option A) Add a one-line “stub sunset” note to root README: remove stubs after consumers migrate to `workflows-drag-free/` paths.

#### Exit criteria

- Changelog (+ optional troubleshooting) updated.
- Plan either still active with all phases checked or filed under `plans-completed/migration/`.
- Stub policy explicit.

---

### Phase 7 — (Optional / Later) Skills Nesting Decision

**Priority:** P3  
**Goal:** Only if the user wants the product skill library under the master package.

#### Options

| Option | Pros | Cons |
|--------|------|------|
| **Keep `11-Skills/` at root** (recommended default) | No churn; skill layer plan already assumes `11-Skills/` | Two top-level concepts (package + skills) |
| **Move to `workflows-drag-free/11-Skills/`** | Single package for sync to host projects | Update all skill references, `wf` skill build paths, validators, host sync scripts |

#### Tasks (only if Option “move” chosen)

- [ ] **7.1** Design path map and update `tools/wf` skill discovery.
- [ ] **7.2** Move skills; add root stub or redirect for one release.
- [ ] **7.3** Update skill-layer plan notes and validators.
- [ ] **7.4** Rebuild `dist/` and validate.

**Default for this reconciliation:** skip Phase 7.

---

## 5. Task Priority Summary

| Priority | Phase | Work |
|----------|-------|------|
| **P0** | 0, 1, 3, 4, 5 | Freeze, salvage, docs, delete DFV2, validate |
| **P1** | 2, 6 | Plan dedupe, changelog, completed-plan filing, stub policy |
| **P3** | 7 | Optional skills nesting |

---

## 6. Risks and Mitigations

| Risk | Severity | Mitigation |
|------|----------|------------|
| Accidental delete of unique evidence | High | Phase 1 tarball + salvage inventory **before** Phase 4; never reverse order |
| User still navigates DFV2 path after delete | Medium | Phase 3 docs; README banner; grep cleanup |
| Host projects break on path changes | Medium | Keep root stubs (Option A); only change active content location (already WDF) |
| Stale `dist/` after DFV2 removal | Low | Regenerate via `wf build skills`; dist is generated |
| Dual plan copies confuse “which plan is active” | Medium | Phase 2 README pointers; file this plan completed when done |
| Over-eager stub deletion (Option B) | Medium | Default Option A; require explicit user choice for B |
| Agents edit wrong tree during execution | High | Phase 0 freeze; AGENTS.md update in Phase 3 before or immediately after delete |

---

## 7. Verification Checklist (Definition of Done)

Copy this into the confirm-execution report when closing the plan.

- [✅] `test ! -e 00-project/Drag-Free-v2`
- [✅] `workflows-drag-free/` present with `MOVED.json`, `ROUTER.md`, `catalog.json`, `tools/wf`
- [✅] All `MOVED.json` targets exist and are non-stub (script exit 0)
- [✅] Critical WDF categories present: setup (9), deployment (full), seo-geo, reference/api, core/meta real content
- [✅] Tarball under `00-project/build/archive/drag-free-v2-promotion-snapshot-*.tar.gz`
- [✅] Unique consolidated logs under live `00-project/build/archive/` (or documented already present)
- [✅] Salvage inventory markdown filed
- [✅] Root README + AGENTS + SHARING_AND_SYNC name `workflows-drag-free/` as master
- [✅] `11-Skills/` and `scripts/` still at repo root and functional
- [✅] Changelog entry (+ plan filing if completed)
- [✅] Stub policy recorded (A — keep root numbered stubs one release)
- [✅] `./tools/wf validate` (or documented equivalent) run from master package

---

## 8. Suggested Execution Commands (Ordered)

```bash
cd /Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts

# --- Phase 0: preflight (manual review of outputs) ---
git branch --show-current
git status -sb
find workflows-drag-free -name '*.md' | wc -l
test -d 00-project/Drag-Free-v2 && du -sh 00-project/Drag-Free-v2

# --- Phase 1: salvage ---
mkdir -p 00-project/build/archive
SRC="00-project/Drag-Free-v2/00-project/build/archive/workflow-scripts-consolidated-2026-07-06"
DEST="00-project/build/archive/workflow-scripts-consolidated-2026-07-06"
[ -d "$SRC" ] && [ ! -d "$DEST" ] && cp -R "$SRC" "$DEST"
tar -czf "00-project/build/archive/drag-free-v2-promotion-snapshot-$(date +%Y-%m-%d).tar.gz" \
  00-project/Drag-Free-v2
ls -lh 00-project/build/archive/drag-free-v2-promotion-snapshot-*.tar.gz

# --- Phase 2–3: docs/pointers (edit in editor / agent) ---
# workflows-drag-free/00-Drag-Free-v2/README.md
# README.md, SHARING_AND_SYNC.md, 00-project/README.md, 00-project/AGENTS.md

# --- Phase 4: delete (ONLY after tarball verified) ---
# rm -rf 00-project/Drag-Free-v2

# --- Phase 5: validate ---
# python redirect check (see Phase 5.1)
# cd workflows-drag-free && ./tools/wf validate

# --- Phase 6: changelog + plans-completed filing ---
```

---

## 9. Roles and Agent Guidance

| Role | Use |
|------|-----|
| Implementer | Execute phases in order; no DFV2 edits after freeze |
| Docs-writer | Phase 2–3 entry docs and README pointer |
| Test-strategist / verification | Phase 5 scripts and smoke paths |
| Security-scanner | Not primary; still avoid committing secrets if any appear in archives |

Parallel agents are optional for Phase 3 grep/doc patches. Phases 1 and 4 should be **serial** (salvage → verify → delete).

---

## 10. Related Follow-Ups (Out of Scope but Tracked)

1. File a short `plans-completed/migration/` record for the earlier redirect repair (`2aa0a15`) if not already completed-plan formalized.
2. Sunset root numbered stubs after host projects migrate (Phase 6 Option B later).
3. Consider regenerating root `README` structure tables from `workflows-drag-free/catalog.json` / `wf build`.
4. Resolve any remaining open items in `00-project/research/2026-07-07-drag-free-v2-migration-problem-statement.md` by marking them resolved when this plan completes (add a “Resolved by” note or superseding research entry).
5. Branch strategy: keep consuming `v1.7` for production hosts until this reconciliation is on the intended consumption branch and validated.

---

## 11. Changelog / Filing Notes for Executors

When executing:

1. Update implementation checkboxes in **this file** as phases complete (`- [✅]` is intentional project marker).
2. Create `00-project/changelog/...` entry for the reconciliation.
3. On full completion, file under `00-project/plans-completed/migration/` and index + changelog Type=`plan`.
4. Do **not** add troubleshooting for a clean delete; do add if redirects regress or unique files were nearly lost.

---

## 12. Open Questions (Resolve During Review / Finalise)

| # | Question | Default if user silent |
|---|----------|------------------------|
| 1 | Stub policy A (keep one release) vs B (delete stubs now)? | **A** |
| 2 | Keep full research under WDF `00-Drag-Free-v2/research/` or move to `00-project/research/`? | **Keep under WDF** |
| 3 | Copy this plan into `00-project/plans/` now or only on completion filing? | **Pointer now; full file under plans-completed on done** |
| 4 | Regenerate `dist/` in the same PR as delete? | **Only if `wf build skills` is cheap and clean** |
| 5 | Execute on current branch vs new branch from it? | **Current branch** `fix/v2.0a-separate-legacy-and-v2` |

---

## 13. Status and Next Workflow

**Status:** Draft plan filed 2026-07-10.

**Recommended next steps:**

1. Run **plan review** (`workflows-drag-free/01-planning/01-plan-review.md`) on this document.
2. **Finalise** with any answers to §12 open questions.
3. **Execute and confirm** (`02-build/03-execute-and-confirm.md` or execution + confirm pair).
4. File completed plan under `00-project/plans-completed/migration/`.

**Do not execute Phase 4 (delete) until Phases 0–1 are verified and the user has approved finalise.**
