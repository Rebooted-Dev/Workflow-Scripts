# Drag-Free-v2 salvage inventory (2026-07-10)

**Action:** Retire `00-project/Drag-Free-v2/` after consolidation into `workflows-drag-free/`.  
**Branch context:** Workflow-Scripts worktree (active package = `workflows-drag-free/`).

## Pre-delete snapshot

| Item | Value |
|------|--------|
| Source path | `00-project/Drag-Free-v2/` |
| Approx size | ~11 MB / ~774 files |
| Health | Broken hybrid (~133 `# Moved` stubs; partial promote evidence) |
| Active library (not deleted) | `workflows-drag-free/` (~2.7 MB, 0 stubs) |

## Salvaged (copied to live meta)

| Source | Destination | Notes |
|--------|-------------|--------|
| `00-project/Drag-Free-v2/00-project/build/archive/workflow-scripts-consolidated-2026-07-06/` | `00-project/build/archive/workflow-scripts-consolidated-2026-07-06/` | ~2.7 MB, 35 files — unique nested consolidated logs not previously under live `00-project/build/archive/` |

## Frozen tarball

| Path | Size | Members |
|------|------|---------|
| `00-project/build/archive/drag-free-v2-promotion-snapshot-2026-07-10.tar.gz` | ~4.9 MB | 1133 |

Restore example:

```bash
cd /path/to/Workflow-Scripts
tar -tzf 00-project/build/archive/drag-free-v2-promotion-snapshot-2026-07-10.tar.gz | head
# tar -xzf 00-project/build/archive/drag-free-v2-promotion-snapshot-2026-07-10.tar.gz
```

## Deliberately not copied as live trees

| Content | Reason |
|---------|--------|
| Hybrid legacy stubs (`01-…`–`12-…` under DFV2) | Broken / superseded by `workflows-drag-free/` |
| DFV2 nested `workflows/`, incomplete `MOVED` targets | Superseded by healthy `workflows-drag-free/` |
| DFV2 `11-Skills/`, `scripts/`, root product files | Live copies remain at Workflow-Scripts root |
| DFV2 `dist/skills/` | Regenerable via `workflows-drag-free` / `tools/wf build skills` if needed |
| Full nested DFV2 `00-project/` meta | Historical sandbox; design plans already filed under `workflows-drag-free/00-project/changelog/plans/`; live ops meta is `00-project/` |

## Post-delete verification

- [x] `test ! -e 00-project/Drag-Free-v2`
- [x] `workflows-drag-free/MOVED.json` present
- [x] `workflows-drag-free/01-planning/00-research-and-plan.md` present
- [x] `workflows-drag-free/07-deployment` present
- [x] Salvaged logs directory present
- [x] Tarball present and multi-MB

## Related records

- Dual-tree comparison: `00-project/research/2026-07-10-drag-free-v2-dual-tree-comparison.md`
- Reconciliation plan: `workflows-drag-free/00-project/plans/2026-07-10-single-master-directory-reconciliation-plan.md`
- Filed design package: `workflows-drag-free/00-project/changelog/plans/`
