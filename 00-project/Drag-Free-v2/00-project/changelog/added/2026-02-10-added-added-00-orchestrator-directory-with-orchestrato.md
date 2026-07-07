---
date: "2026-02-10"
title: "Added `00-orchestrator/` directory with orchestrator workflows"
type: "added"
notes: "- Added `00-orchestrator/` directory with orchestrator workflows — enables launching non-interactive OpenCode processes to delegate plan reviews (and other workflows) to different "
---
# Added `00-orchestrator/` directory with orchestrator workflows
**Date:** 2026-02-10
**Type:** added

---

## Summary
- Added `00-orchestrator/` directory with orchestrator workflows — enables launching non-interactive OpenCode processes to delegate plan reviews (and other workflows) to different models. Includes: `orchestrator-plan-review.md` — complete workflow documentation for delegated reviews `orchestrator-review.sh` — production-ready shell script with configurable model, focus areas, timeouts, and output management `README.md` — comprehensive guide with use cases, architecture, and best practices Supports parallel multi-model reviews, CI/CD integration, and structured output capture

## Scope
- Migrated from root `CHANGELOG.md` (legacy monolithic changelog).
