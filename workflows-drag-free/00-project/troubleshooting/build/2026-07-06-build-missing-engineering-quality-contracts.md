---
date: 2026-07-06
category: build
title: Missing engineering quality contracts
status: resolved
---

# Missing Engineering Quality Contracts

## Issue

Active workflows referenced shared engineering-quality requirements such as `code-design`, `error-handling`, `observability`, and `security-baseline`, but the corresponding `core/standards/` files were absent. The moved-path catalog also pointed at active greenfield and deployment workflow paths that were missing.

## Impact

The workflow prose had forward references without durable contracts on disk, so builders and reviewers could not load the shared standards the frontmatter required.

## Resolution

Resolved on 2026-07-06 by adding the missing standards, debt-ledger contract, walking-skeleton checklist, active greenfield workflow, and active generic deploy workflow.

## Validation

- `tools/wf validate`
- `tools/wf build --check`
- `tools/wf build skills --check`
