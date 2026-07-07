---
date: "2026-05-31"
title: "Repaired active workflow links for renamed directories, rewrote the deploymen..."
type: "fixed"
notes: "- Repaired active workflow links for renamed directories, rewrote the deployment index to current guide locations, made `sync-workflow-scripts.sh` and its setup guide branch-aware "
---
# Repaired active workflow links for renamed directories, rewrote the deploymen...
**Date:** 2026-05-31
**Type:** fixed

---

## Summary
- Repaired active workflow links for renamed directories, rewrote the deployment index to current guide locations, made `sync-workflow-scripts.sh` and its setup guide branch-aware with `WORKFLOWS_BRANCH` override support, replaced unsafe `.env` troubleshooting examples with redacted/trusted-file guidance, added active Markdown link validation, documented reviewed-version MCP package guidance, and remediated the nested image-generation package to pass audit/test/type/build checks.

## Scope
- Migrated from root `CHANGELOG.md` (legacy monolithic changelog).
