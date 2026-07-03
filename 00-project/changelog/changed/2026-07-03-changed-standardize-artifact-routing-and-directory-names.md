# Standardize Artifact Routing and Directory Names
**Date:** 2026-07-03
**Type:** changed

---

## Summary
- Standardized generated review, audit, research, and findings reports on `<metadata-root>/research/`.
- Added metadata-root resolution guidance: use `00-project/` for Workflow-Scripts itself, `project/` for host projects, and suggest `00-project-setup/01-setup-project.md` when no metadata root exists.
- Preserved the `- [✅]` completed-task convention and documented why it should not be replaced with `- [x]`.
- Renamed `01-Planning & Organizing/` to `01-planning-and-organizing/`.
- Renamed `10 Technical Docs/` to `10-technical-docs/`.
- Updated active references to the renamed directories and corrected stale security/documentation/review paths.

## Scope
- Workflow documentation and directory names.
- No shared review-core refactor; that remediation remains deferred.

## Verification
- Searched for stale active references to old planning and technical-docs directory names.
- Ran the active markdown-link validator after the rename and routing updates.
