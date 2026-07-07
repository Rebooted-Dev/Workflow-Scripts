---
date: "2026-07-03"
title: "Shared review workflow core"
type: "changed"
notes: "- Added `00-Meta-Workflow/00-meta/review-workflow-core.md` as the shared contract for active review workflows. - Updated code review, optimization, refactoring, and security review"
---
# Shared review workflow core
**Date:** 2026-07-03
**Type:** changed

---

## Summary
- Added `00-Meta-Workflow/00-meta/review-workflow-core.md` as the shared contract for active review workflows.
- Updated code review, optimization, refactoring, and security review workflows to reference the shared core.
- Removed local normative priority-band lists so priority assignment is governed by the shared impact x likelihood rubric.
- Added a measured-baseline TODO before any future serial-fetch optimization.

## Scope
- `00-Meta-Workflow/00-meta/review-workflow-core.md`
- `05-review/01-code-review.md`
- `05-review/02-code-optimization.md`
- `05-review/03-code-refactoring.md`
- `06-security/01-security-review.md`
- `scripts/validation/check-review-workflow-policy.sh`
- `00-project/plans/TODO.md`
