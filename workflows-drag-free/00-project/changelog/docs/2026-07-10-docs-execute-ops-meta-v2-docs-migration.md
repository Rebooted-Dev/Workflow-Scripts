# Execute ops-meta v2 docs migration

**Date:** 2026-07-10  
**Type:** docs  
**Status:** executed

## Summary

Executed the final ops-meta v2 documentation migration plan. Package-owned Drag-Free/v2 migration evidence now lives under WDF package metadata; whole-repository ops history and the restore archive remain in live ops metadata.

## Moved (canonical under WDF)

Research:

- `workflows-drag-free/00-project/research-completed/migration/2026-07-07-drag-free-v2-migration-problem-statement.md`
- `workflows-drag-free/00-project/research-completed/migration/2026-07-10-drag-free-v2-dual-tree-comparison.md`

Required troubleshooting:

- `workflows-drag-free/00-project/troubleshooting/build/2026-07-07-build-drag-free-v2-redirect-targets.md`
- `workflows-drag-free/00-project/troubleshooting/build/2026-07-09-build-drag-free-v2-evidence-location-drift.md`
- `workflows-drag-free/00-project/troubleshooting/build/2026-07-09-build-numbered-workflows-drag-free-path-drift.md`
- `workflows-drag-free/00-project/troubleshooting/build/2026-07-09-build-v2-root-rename-reference-drift.md`

Repair evidence:

- `workflows-drag-free/00-project/build/drag-free-v2-separation/`

Live ops paths for the six documents above are `# Moved` pointer stubs. Live troubleshooting index rows remain historical and are marked `relocated`.

## Kept in live ops metadata

- Consolidated review report and optional generic promotion-fallout troubleshooting
- All `00-project/changelog/**` entries
- `00-project/build/archive/**` restore snapshot and salvage inventory

## Guidance

Rewrote current ops guidance (`00-project/docs/agents/repository-map.md`, `00-project/AGENTS.md`, `00-project/plans-completed/README.md`) so the active library is `workflows-drag-free/` and the retired `Drag-Free-v2/` path is archive-only. Updated the repair utility root discovery and README topology wording without re-running the utility over the live tree.

## Plan

- Final plan (executed, filed): `workflows-drag-free/00-project/plans-completed/migration/2026-07-10-ops-meta-v2-docs-migration-final-plan.md`
- Source draft / review trail: `workflows-drag-free/00-project/plans-completed/migration/2026-07-10-ops-meta-v2-docs-migration-plan.md`
- Changelogs for this work: only under `workflows-drag-free/00-project/changelog/` (transition: all active work is on WDF)
