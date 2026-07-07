# Promote Workflow-Scripts Archive to Drag-Free-v2 Root

## Summary

Moved the immediate children of the archived Workflow-Scripts working tree into `Drag-Free-v2/`, except for the retained Workflow-Scripts metadata archive at `Drag-Free-v2/Workflow-Scripts-consolidated/working-tree-files/00-project/`.

## Details

- Promoted active Workflow-Scripts files and directories such as `README.md`, `scripts/`, `workflows/`, and numbered workflow folders to the Drag-Free-v2 root.
- Preserved `Drag-Free-v2/00-project/` as the consolidation metadata workspace.
- Updated current navigation docs to describe promoted files at `Drag-Free-v2/` and retained Workflow-Scripts metadata at `Workflow-Scripts-consolidated/working-tree-files/00-project/`.

## Validation

- Confirmed `Workflow-Scripts-consolidated/working-tree-files/` contains only the retained `00-project/` directory.
- Confirmed promoted `scripts/`, `workflows/`, and `README.md` exist at the Drag-Free-v2 root.
- `rg -n -P "Workflow-Scripts-consolidated/working-tree-files/(?!00-project)|working-tree-files/(?!00-project)" Drag-Free-v2` returned no stale current-path references.
- `./scripts/validation/check-active-markdown-links.sh` passed from `Drag-Free-v2/`.
