# Current Tasks

Keep this file up to date as tasks involving the `00-project/` directory are completed (check off items, add changelog row or troubleshooting entry as needed).

## Reference — filing completed plans

When a plan is finished and should be archived, follow **`plans-completed/README.md`** (default) or **`changelog/plans/`** when filing under the changelog archive:

1. Move the plan file from `plans/` or `build/` to **`plans-completed/<category>/`** or **`changelog/plans/`**.
2. Update the matching index (`plans-completed/index.md` and/or **`changelog/index.md`** with Type=`plan`).
3. For changelog archive, File path is **`plans/<filename>`** relative to `changelog/`.

## Active

- [ ] Optional: Phase 7 skills nesting decision (later — deferred by single-master plan)
- [ ] (Add current tasks here)

## Completed (2026-07-10 workflow contract and CLI remediation)

- [✅] Eliminate all 24 `wf validate` false-positive warnings; file plan under `../plans-completed/remediation/` and inventory under `../research-completed/investigation/`
- [✅] Execute and verify workflow contract and CLI remediation; filed under `../plans-completed/remediation/`
- [✅] File both source reviews under `../research-completed/review/` with research changelog rows

## Completed (2026-07-10 research filing)

- [✅] File all v2.0a research → `../research-completed/` (migration + investigation)

## Completed (2026-07-10 ops-meta v2 docs migration)

- [✅] Execute ops-meta v2 docs migration: filed at `../plans-completed/migration/2026-07-10-ops-meta-v2-docs-migration-final-plan.md` (WDF meta; changelog under `../changelog/` only)
- [✅] File source draft audit trail → `../plans-completed/migration/2026-07-10-ops-meta-v2-docs-migration-plan.md`
  - Moved (required): two research files, four path-drift build TS, separation-repair evidence → WDF package meta
  - Moved (optional follow-on): legacy-meta + phase3 research; four promotion/`tools/wf` TS (missing tools/wf, rationalized planning, engineering quality contracts, wf-run timeout)
  - Still live ops (by design): consolidated review report; adversarial TS (4); environment/git TS; root ops changelog history; `00-project/build/archive/**`

## Completed (2026-07-10 second-tree retirement)

- [✅] Salvage unique DFV2 nested logs → `00-project/build/archive/workflow-scripts-consolidated-2026-07-06/`
- [✅] Tarball `00-project/build/archive/drag-free-v2-promotion-snapshot-2026-07-10.tar.gz`
- [✅] Delete `00-project/Drag-Free-v2/`
- [✅] Salvage inventory + changelog bookkeeping
- [✅] Phase 5 validation (`check-moved-targets.sh`, `check-active-markdown-links.sh`, `tools/wf validate`) — passed 2026-07-10
- [✅] File single-master plan → `../plans-completed/migration/2026-07-10-single-master-directory-reconciliation-plan.md`

## Completed (filed 2026-07-10)

- [✅] Initial `00-project/` meta setup for workflows-drag-free
- [✅] Import Drag-Free-v2 plan package from live ops meta
- [✅] File implemented Drag-Free-v2 plans/research into `changelog/plans/` + Type=`plan` index rows

### Filed under `changelog/plans/`

| Document | Status when filed |
|----------|-------------------|
| `2026-07-06-drag-free-v2-unified-implementation-plan.md` | Phases 0–6 complete |
| `2026-07-06-drag-free-v2-workflow-skill-layer-plan.md` | Completed |
| `2026-07-06-workflow-system-v2-redesign-proposal.md` (+ `.reviews/`) | Implemented via unified plan |
| `2026-07-06-engineering-quality-and-lifecycle-proposal.md` | Implemented via Phase 3 |
| Four surveys (date-prefixed) | Baseline / re-run evidence |
