# Workflow-Scripts Consolidated Evidence Archive

This directory retains the `Workflow-Scripts-consolidated/` logs, patches, and status snapshots after live Workflow-Scripts promotion and audit validation completed on 2026-07-06.

## Contents

- `logs/` - phase transcripts, archive remediation logs, validation transcripts, token reports, and run statistics.
- `workflow-scripts-tracked-changes.patch` - tracked modifications/deletions captured from the source Workflow-Scripts repo before restoration.
- `workflow-scripts-staged-changes.patch` - staged patch capture from the source repo.
- `workflow-scripts-untracked-files.txt` - untracked file inventory from the source repo.
- `workflow-scripts-copied-current-files.txt` - files copied into the Drag-Free-v2 promoted tree.
- `workflow-scripts-status-before-restore.txt` - source repo status snapshot before restoration.

## Current Status

The live Workflow-Scripts repo and `Drag-Free-v2/` snapshot now validate with zero `tools/wf validate` warnings. This archive is retained for audit history only and is not an active workflow source.
