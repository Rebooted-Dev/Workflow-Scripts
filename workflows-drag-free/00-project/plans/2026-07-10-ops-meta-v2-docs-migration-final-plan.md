# 2026-07-10 12:09 +08 — Ops Meta v2 Docs Migration Final Plan

**Status:** Active — finalised for execution; not executed  
**Repository:** `Workflow-Scripts`  
**Branch at review:** `fix/v2.0a-separate-legacy-and-v2`  
**Execution workspace:** `/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts`  
**Plan home:** `workflows-drag-free/00-project/plans/`  
**Consolidated from:** `workflows-drag-free/00-project/plans/2026-07-10-ops-meta-v2-docs-migration-plan.md`, including its inline Plan Review Addendum dated 2026-07-10 12:09 +08. No `PLAN.reviews/` directory was present.

## Summary

Move package-owned Drag-Free/v2 migration evidence from the live Workflow-Scripts ops metadata root into the WDF package metadata root, while preserving whole-repository ops history and the restore archive in place.

The final scope is deliberately narrower than the source draft:

- Move two package-owned research files.
- Move four required package-owned troubleshooting files.
- Move and repair the redirect-evidence tree.
- Rewrite only the stale current ops guidance that still presents the retired consolidation layout as current.
- Keep the consolidated review report and optional generic promotion-fallout records in live ops metadata.
- Do not change workflow content or execute the migration during this plan-review/finalisation pass.

## Ownership decision

| Metadata root | Canonical role | Decision |
|---|---|---|
| `00-project/` | Workflow-Scripts ops metadata: whole-repo history, system plans, ops changelog, troubleshooting, and restore archives | Keep ops-owned records here |
| `workflows-drag-free/00-project/` | WDF package metadata: package design, migration evidence, and package troubleshooting | Receive the scoped package evidence |
| `00-project/build/archive/` | Restore-only archive and salvage inventory | Keep unchanged in place |

The retired `00-project/Drag-Free-v2/` tree remains absent. The only restore source is `00-project/build/archive/drag-free-v2-promotion-snapshot-2026-07-10.tar.gz` plus its salvage inventory.

## Explicit scope decisions

### Move to WDF package metadata

Research:

- `00-project/research/2026-07-07-drag-free-v2-migration-problem-statement.md`
- `00-project/research/2026-07-10-drag-free-v2-dual-tree-comparison.md`

Required troubleshooting:

- `00-project/troubleshooting/build/2026-07-07-build-drag-free-v2-redirect-targets.md`
- `00-project/troubleshooting/build/2026-07-09-build-drag-free-v2-evidence-location-drift.md`
- `00-project/troubleshooting/build/2026-07-09-build-numbered-workflows-drag-free-path-drift.md`
- `00-project/troubleshooting/build/2026-07-09-build-v2-root-rename-reference-drift.md`

Repair evidence:

- `00-project/build/drag-free-v2-separation/`

### Keep in live ops metadata

Keep the following in their current live paths because their scope is whole-repository or environment-level rather than package-only:

- `00-project/research/2026-07-06-workflow-scripts-consolidated-review-report.md`
- `00-project/troubleshooting/build/2026-07-06-build-missing-tools-wf-after-promotion.md`
- `00-project/troubleshooting/build/2026-07-06-build-rationalized-planning-targets-missing.md`
- `00-project/troubleshooting/build/2026-07-06-build-missing-engineering-quality-contracts.md`
- `00-project/troubleshooting/environment/2026-07-06-environment-opencode-plan-review-external-provider-approval.md`
- All `00-project/changelog/**` entries.
- `00-project/build/archive/**`.

### Pointer policy

After each scoped move, leave a short `# Moved` pointer at the old live path. The pointer must name the repository-root-qualified WDF destination. This preserves existing historical links while making the WDF file the canonical source. Live troubleshooting index rows should remain as historical rows marked `relocated`, while the WDF troubleshooting index receives the canonical rows.

## Priority-ordered roadmap

### Phase 1 — P0: Freeze scope and preflight safely

Effort: Small. Entry condition: explicit user authorization to execute the migration; this finalisation pass does not constitute that authorization.

Tasks:

1. Record the execution decision and the exact inventory above in the working session. Do not add the consolidated review report or optional troubleshooting set to the move list.
2. From the Workflow-Scripts repository root, capture `git status --short --branch` and preserve all existing unrelated changes. Do not reset, clean, stash, or rewrite the parent `Update-AI-Tools` repository.
3. Confirm the retired tree and archive state:

   ```bash
   test ! -e 00-project/Drag-Free-v2
   test -f workflows-drag-free/MOVED.json
   test -f 00-project/build/archive/drag-free-v2-promotion-snapshot-2026-07-10.tar.gz
   test -f 00-project/build/archive/2026-07-10-drag-free-v2-salvage-inventory.md
   ```

4. For every destination, abort before any move if it exists with different content. If a destination already exists with identical content, record the matching SHA-256 and do not overwrite it.
5. Create only the required destination directories:

   ```bash
   mkdir -p workflows-drag-free/00-project/research
   mkdir -p workflows-drag-free/00-project/troubleshooting/build
   mkdir -p workflows-drag-free/00-project/build
   ```

Exit criteria:

- Scope and optional-item decision are recorded.
- Pre-existing dirty files are listed and excluded from the work.
- All source files exist and all destinations pass the no-clobber check.

Rollback: stop before the first `git mv` if any inventory or collision check fails.

### Phase 2 — P0: Move package research and required troubleshooting

Effort: Medium. Dependency: Phase 1 must pass.

Tasks:

1. Use `git mv` for the two research files into `workflows-drag-free/00-project/research/`.
2. Use `git mv` for the four required build troubleshooting files into `workflows-drag-free/00-project/troubleshooting/build/`.
3. Create `# Moved` pointer stubs at each original live path. Do not rewrite historical bodies merely to remove old-path mentions.
4. Update the dual-tree comparison’s metadata/related-path references to the WDF canonical paths where they are current navigation links. Preserve historical path mentions inside the analysis as historical evidence.
5. Update `00-project/troubleshooting/index.md` rows for the four moved entries with a `relocated` note and the WDF destination; do not erase ops history.
6. Add the four canonical rows to `workflows-drag-free/00-project/troubleshooting/index.md`, newest first.

Exit criteria:

- The two research files and four troubleshooting files are readable at WDF paths.
- Each old path is a valid pointer stub with the correct destination.
- Both troubleshooting indexes distinguish historical live-ops location from canonical WDF location.
- SHA-256 checks confirm no content loss in the moved files.

Failure handling: do not edit indexes until all moves and pointer creation succeed; if a move fails, restore only the paths changed in this phase from the recorded preflight state.

### Phase 3 — P1: Move and make repair evidence trackable and coherent

Effort: Medium. Dependency: Phase 1; may run after Phase 2.

Tasks:

1. Move `00-project/build/drag-free-v2-separation/` to `workflows-drag-free/00-project/build/drag-free-v2-separation/` without changing the CSV or evidence contents.
2. Add a narrow root `.gitignore` exception so this WDF evidence is tracked despite the generic `build/` rule:

   ```gitignore
   !workflows-drag-free/00-project/build/
   !workflows-drag-free/00-project/build/drag-free-v2-separation/
   !workflows-drag-free/00-project/build/drag-free-v2-separation/**
   ```

3. Update `remediate_moved_targets.py` to discover the Workflow-Scripts Git root explicitly rather than relying on a fixed `parents[3]` depth. Keep its output directory at the moved WDF path.
4. Update the utility’s generated README text so it states:
   - `workflows-drag-free/` is the active library;
   - `00-project/Drag-Free-v2/` is retired and must not be recreated;
   - the restore source is `00-project/build/archive/drag-free-v2-promotion-snapshot-2026-07-10.tar.gz`.
5. Do not rerun the utility over the live tree as part of the migration; it is evidence-producing and can rewrite the audit README/CSV. Perform a non-destructive syntax/import/root-resolution smoke check instead.

Exit criteria:

- The evidence tree is present only at the WDF metadata path.
- `git check-ignore` no longer reports the moved evidence as ignored.
- `README.md`, the utility, and the CSV agree with the current active/retired topology.
- No archive or salvage file moved.

### Phase 4 — P1: Correct current ops guidance without rewriting workflow content

Effort: Medium. Dependency: Phases 2–3 establish canonical paths.

Mandatory edits:

1. Rewrite `00-project/docs/agents/repository-map.md` to describe:
   - `workflows-drag-free/` as the active WDF library;
   - `00-project/` as Workflow-Scripts ops metadata;
   - `workflows-drag-free/00-project/` as package metadata;
   - `00-project/build/archive/` as the restore location;
   - the retired `Drag-Free-v2/` path as historical/archive-only, not a current consolidation home.
2. Update `00-project/AGENTS.md` so its scope and repository-management language no longer presents the retired `Drag-Free-v2/` consolidation workspace as live. Retain the archive pointer and nested-repository instructions.
3. Generalise `00-project/plans-completed/README.md` from Drag-Free-only framing to Workflow-Scripts completed-plan framing, while retaining the migration category.

Targeted checks, not automatic rewrites:

- Inspect `00-project/README.md`; retain its already-correct active-library/archive wording unless a current false claim is found.
- Inspect root `README.md` and `SHARING_AND_SYNC.md`; change only a current false path claim, not historical migration notes or workflow prose.
- Leave historical research, changelog, and completed-plan bodies unchanged unless they contain a current navigation link that must point to the canonical WDF location.

Exit criteria:

- Current guidance names one active library and two explicit metadata roles.
- Targeted searches find no current claim that `00-project/Drag-Free-v2/` or Update-AI-Tools `Drag-Free-v2/00-project/` is the live home.
- Historical references remain clearly historical.

### Phase 5 — P1: Bookkeeping, trackers, and plan discoverability

Effort: Small. Dependency: canonical paths and current guidance are settled.

Tasks:

1. Keep the source draft and its review addendum as the audit trail. Make the final plan in this file the single active execution target.
2. Update `workflows-drag-free/00-project/plans/TODO.md` so its active migration row points to this final plan and explicitly records that the consolidated review report and four optional troubleshooting entries remain deferred in live ops metadata.
3. Update `workflows-drag-free/00-project/plans/README.md` with the active final-plan/source-review relationship if needed for discoverability.
4. Add a WDF changelog entry under `workflows-drag-free/00-project/changelog/docs/` describing the finalised scope and the fact that execution is still pending. Add its newest-first row to `workflows-drag-free/00-project/changelog/index.md`.
5. Retain the existing initial plan-filing changelog entry as historical filing evidence; do not duplicate it as a second execution event.
6. Maintain indexes directly according to the local metadata convention. Do not claim that `tools/wf build` regenerates changelog indexes; its freshness gate covers `catalog.json`, `ROUTER.md`, and skill bundles.

Exit criteria:

- A new agent can reach the final plan, source review addendum, canonical research, troubleshooting, and evidence paths from WDF metadata.
- The TODO, plans README, changelog entry, and indexes agree that the migration is active but unexecuted.
- No troubleshooting entry is added for this planning/documentation pass; the existing troubleshooting records are being relocated, not newly repaired.

### Phase 6 — P1: Verification and handoff

Effort: Medium. Dependency: Phases 1–5.

Run from `/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts`:

```bash
test ! -e 00-project/Drag-Free-v2
test -f workflows-drag-free/MOVED.json
test -f workflows-drag-free/00-project/research/2026-07-07-drag-free-v2-migration-problem-statement.md
test -f workflows-drag-free/00-project/research/2026-07-10-drag-free-v2-dual-tree-comparison.md
test -f workflows-drag-free/00-project/troubleshooting/build/2026-07-07-build-drag-free-v2-redirect-targets.md
test -f workflows-drag-free/00-project/build/drag-free-v2-separation/README.md
test -f 00-project/build/archive/drag-free-v2-promotion-snapshot-2026-07-10.tar.gz

bash scripts/validation/check-moved-targets.sh
bash scripts/validation/check-active-markdown-links.sh
bash scripts/validation/check-workflow-skills.sh
workflows-drag-free/tools/wf validate
workflows-drag-free/tools/wf build --check
workflows-drag-free/tools/wf build skills --check
git diff --check
git status --short --branch
```

Also perform these migration-specific checks:

- Compare recorded source/destination SHA-256 values for all seven moved documents and the three evidence files.
- Verify each live pointer’s first line is `# Moved` and its target matches the canonical WDF path.
- Verify live troubleshooting rows are marked relocated and WDF rows are present newest first.
- Verify `git check-ignore -v` does not match the WDF separation-evidence files.
- Search only current guidance files for stale current-home claims; allow historical mentions in research, changelog, and archived-plan text.
- Run `python3 -m py_compile workflows-drag-free/00-project/build/drag-free-v2-separation/remediate_moved_targets.py` and a non-writing import/root-resolution assertion.

Handoff:

- Leave this plan active and unexecuted until the migration has actually passed all gates.
- Do not move this plan to `plans-completed/migration/` during review or finalisation.
- Commit only if separately authorised after the verification output is reviewed; commit from the nested `Workflow-Scripts` repository, never the parent repo.

## Risks, quality gates, and rollback

| Risk | Control |
|---|---|
| Wrong evidence crosses the metadata boundary | Fixed move list; whole-repo review and generic promotion fallout remain in live ops |
| Content loss or destination clobber | Preflight hashes; abort on differing destination; `git mv`; post-move hash comparison |
| Old links become unusable | Mandatory pointer stubs plus relocated index notes |
| Evidence disappears under `build/` ignore rules | Narrow `.gitignore` exception and `git status`/`git check-ignore` verification |
| Utility reintroduces stale topology | Update root discovery and generated README wording before moving it |
| Dirty worktree changes are absorbed | Path-scoped edits, preflight status capture, no reset/clean/stash |
| Secrets enter durable records | No provider calls or secret changes; inspect only touched/generated text and do not copy credentials into plans or logs |

Rollback is phase-boundary based: before each index or guidance rewrite, confirm the preceding file moves and hashes; if a gate fails, restore only the paths changed by the current phase from Git or the recorded preflight state, leave unrelated dirty files untouched, and do not mark the plan complete.

## Definition of done

- [ ] Phases 1–5 executed with all required tasks complete.
- [ ] Two research files, four required troubleshooting files, and separation evidence are canonical under WDF metadata.
- [ ] Mandatory pointer stubs and both troubleshooting index states are correct.
- [ ] Consolidated review report, optional troubleshooting records, ops changelog, and archive remain in live ops metadata.
- [ ] Current guidance no longer presents the retired consolidation tree as live.
- [ ] Repair utility and generated README agree with the current topology.
- [ ] All deterministic validation commands and migration-specific assertions pass.
- [ ] Only after real execution verification: update status to Executed and file under `plans-completed/migration/` using the repository’s completed-plan workflow.
