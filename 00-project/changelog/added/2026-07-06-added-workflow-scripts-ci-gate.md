---
date: 2026-07-06
type: added
title: Workflow-Scripts CI gate
status: complete
---

# Workflow-Scripts CI Gate

## Summary

Added a GitHub Actions workflow for the live Workflow-Scripts promotion.

## Details

- Added `.github/workflows/workflow-scripts-ci.yml`.
- The workflow runs `tools/wf validate`, `tools/wf build --check`, `tools/wf build skills --check`, repository validation scripts, shellcheck, `git diff --check`, and `git diff --exit-code`.
- Fixed shellcheck findings in validation scripts and sync helpers so the CI gate is clean locally.

## Validation

- `find scripts tools 00-Meta-Workflow -name '*.sh' -print0 | xargs -0 shellcheck` passed.
- All repository validation scripts passed in `Workflow-Scripts/`.
- `git diff --check` passed in `Workflow-Scripts/`.
