# Workflow-Scripts v1.0.0 Release Notes

> **Historical status (2026-07-19):** Archived release record for the v1.0.0 reconciliation baseline. Branch names, paths, and migration guidance below describe that release and are not current operating instructions.

Release Date: 2026-04-01
Release Branch: `main`
v1 Maintenance Branch: `v1`

## Reconciliation Summary

This release consolidates historical work from `beta` and `master` into `main` for an official v1 baseline.

- `main` before reconciliation: `a82ede8b6df8ec67788f6e9b21f423b068266305`
- `origin/beta`: `0966883742b27af640ba4d85cf4d63c7a4783dda`
- `origin/master`: `b9455f33e6a5a59e26a7ba6127d97cfaacecdc78`
- `origin/alpha` (v2 line, not merged): `2d3f59958a6b33f96f7f5b1cd7172724fe5cfe07`
- `main` after reconciliation merge: `d1effa6a53453ac526d1ff9739e045bcb6295785`

## Highlights Included in v1

- Consolidated planning and orchestration updates from historical branches.
- Expanded deployment and SEO/GEO checklist documents.
- Added API integration index docs under `08-API-Integration/`.
- Added glossary and additional meta/documentation support files.
- Added explicit conflict resolution log:
  - [`v1-reconciliation-conflict-log-2026-04-01.md`](./v1-reconciliation-conflict-log-2026-04-01.md)

## Behavioral / Structural Notes

- Directory naming now includes:
  - `01a-orchestrator/`
  - `01b-planning/`
- Legacy `02-build-code/03-execute-plan.md` is removed.
- README links were updated to match renamed directories.

## Migration Notes for Existing Users

- If your local scripts or docs reference `00-orchestrator/`, update to `01a-orchestrator/`.
- If your local scripts or docs reference `01-planning-and-organizing/`, update to `01b-planning/`.
- Re-run any internal automation that depends on old path names.
