---
id: review-readme
version: 2.0
category: review
kind: reference
title: "Review & Audit Workflows"
path: workflows/review/README.md
---

# Review & Audit Workflows

Use these workflows when inspecting a repository, implementation, or data workflow for defects, risks, and follow-up work.

| Workflow | Use When | Output |
|---|---|---|
| [01 Code Review](01-code-review.md) | You need an evidence-backed code review focused on bugs, risks, and maintainability. | Code review report in `<metadata-root>/research/`. |
| [02 Code Optimization](02-code-optimization.md) | You need performance and complexity improvement opportunities. | Optimization review report. |
| [03 Code Refactoring](03-code-refactoring.md) | You need a targeted refactor plan with source-backed rationale. | Refactoring report or implementation plan. |
| [04 Website Data Refactoring](04-website-data-refactoring.md) | You need to normalize website content/data models and migration paths. | Website data refactor plan. |
| [05 Comprehensive Audit](05-comprehensive-audit.md) | You need a broad audit across code, docs, structure, and process. | Comprehensive audit report. |
| [06 Deep Review](06-deep-review.md) | You need multi-lens review plus independent verification before filing. | Deep review report with verification addendum. |

Prefer [06 Deep Review](06-deep-review.md) for high-risk or ambiguous review requests where a second pass is needed before acting on findings.
