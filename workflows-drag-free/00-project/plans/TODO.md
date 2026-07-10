# Current Tasks

Keep this file up to date as tasks involving the `00-project/` directory are completed (check off items, add changelog row or troubleshooting entry as needed).

## Reference — filing completed plans

When a plan is finished and should be archived, follow **`plans-completed/README.md`** (default) or **`changelog/plans/`** when filing under the changelog archive:

1. Move the plan file from `plans/` or `build/` to **`plans-completed/<category>/`** or **`changelog/plans/`**.
2. Update the matching index (`plans-completed/index.md` and/or **`changelog/index.md`** with Type=`plan`).
3. For changelog archive, File path is **`plans/<filename>`** relative to `changelog/`.

## Active

- [ ] Execute ops-meta v2 docs migration: `plans/2026-07-10-ops-meta-v2-docs-migration-final-plan.md` (finalised scope: two research files, four required troubleshooting files, and separation evidence → WDF meta; consolidated review report and optional promotion-fallout troubleshooting remain live ops records)
- [ ] Optional: Phase 5 smoke (`tools/wf validate` from `workflows-drag-free/`, redirect integrity) after second-tree retirement
- [ ] Optional: Phase 7 skills nesting decision (later)
- [ ] (Add current tasks here)

## Completed (2026-07-10 second-tree retirement)

- [✅] Salvage unique DFV2 nested logs → `00-project/build/archive/workflow-scripts-consolidated-2026-07-06/`
- [✅] Tarball `00-project/build/archive/drag-free-v2-promotion-snapshot-2026-07-10.tar.gz`
- [✅] Delete `00-project/Drag-Free-v2/`
- [✅] Salvage inventory + changelog bookkeeping

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
