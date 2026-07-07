---
date: 2026-07-06
type: changed
title: Clarify artifact defaults
status: complete
---

# Clarify Artifact Defaults

## Summary

Clarified active-plan and completed-plan artifact routing so setup and planning workflows no longer imply multiple default locations.

## Details

- Made `project/plans/` the default active-plan location in planning workflows.
- Documented `project/build/` as a build-artifact location or active-plan override only when the project plan map explicitly chooses it.
- Clarified that `project/changelog/plans/` is an explicit alternate archive, not the default completed-plan target.
- Kept `project/plans-completed/<category>/` as the default completed-plan filing destination.

## Validation

- `tools/wf validate` passed with zero warnings in `Workflow-Scripts/`.
- `bash scripts/validation/check-wf-cli.sh` passed in `Workflow-Scripts/`.
- `bash scripts/validation/check-active-markdown-links.sh` passed in `Workflow-Scripts/`.
