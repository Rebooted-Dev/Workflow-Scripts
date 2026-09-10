# Document umbrella-workspace symlink consumption pattern

**Date:** 2026-09-10
**Type:** docs

---

## Summary

- Amended `SHARING_AND_SYNC.md` "Symlinks" section with a **sanctioned umbrella-workspace exception**: nested apps under a workspace that exposes this repository via a shared link root (e.g. `Shared-Links/Workflow-Scripts`) may consume the single master through gitignored relative symlinks instead of per-project clones.
- Documented the pattern's properties: one live copy per workspace, immediate updates, gitignore entry must omit the trailing slash (`Workflow-Scripts/` matches directories only and does **not** ignore a symlink), git operations only in the master checkout, and re-clone on standalone extraction.
- First consumer: the Image-Generation-Apps workspace (Info-Visualizer + prompt-formatter replaced stale `v1.7` clones — which predated the 2026-08-11 terminal-gate fix and caused agents to skip `04-documentation/03-mark-completed.md` — with symlinks to this master on `v1.72`).

## Scope

- `SHARING_AND_SYNC.md` only. No workflow content changed.

## Verification

- Pattern validated empirically before adoption: scratch-repo `git check-ignore` test proved the trailing-slash exclusion gap; consumer apps' vitest/tsconfig exclude paths verified through the symlink; master pushed to `origin/v1.72` (`5971665`) before any clone deletion.

## Related

- Consumer plan: Image-Generation-Apps workspace `project/plans/2026-09-10-workflow-scripts-master-copy-consolidation-plan.md`
