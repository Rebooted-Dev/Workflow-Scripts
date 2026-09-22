# Relocate v1.72-Improvements Plans to Core-Learning
**Date:** 2026-09-22
**Type:** docs

---

## Summary
- Moved the ten-file `00-project/plans/v1.72-Improvements/` set (overview + nine finalized plans) out of the active plans directory into Core-Learning at `Tech-notes/Workflow-Scripts/proposed-plans/v1.72-Improvements/` (repo `Rebooted-Dev/Core-Learning`), as owner-requested reference material.
- The set was already implemented on this line by commit `846caef` and verified via `00-project/plans-completed/tooling/2026-09-10-workflow-scripts-instruction-remediation-plan.md`; the completion record remains in `plans-completed/`. A provenance `README.md` was added in the destination folder.
- One historical inbound reference (`plans-completed/tooling/2026-09-10-workflow-scripts-instruction-remediation-plan.md:65`) intentionally left untouched per no-migration conventions for archived records.

## Scope
- Removal of `00-project/plans/v1.72-Improvements/` from this repository; destination-side add committed in Core-Learning. No workflow behavior, no other files changed.

## Verification
- `ls Tech-notes/Workflow-Scripts/proposed-plans/v1.72-Improvements/` shows all ten plan files + README; source directory no longer exists under `00-project/plans/`.
- Repo-wide grep for `v1.72-Improvements` finds only the archived remediation plan's historical mention.
