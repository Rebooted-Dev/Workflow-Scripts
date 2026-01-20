# Review & Audit Workflows

This directory contains workflows for reviewing code quality, performance, and maintainability.

## Workflow Index

| File | Purpose | When to Use |
|------|---------|-------------|
| [`01-code-review.md`](./01-code-review.md) | General code review for defects and risks | Before merging, periodic audits |
| [`02-code-optimization.md`](./02-code-optimization.md) | Performance-focused analysis | When performance issues suspected |
| [`03-code-refactoring.md`](./03-code-refactoring.md) | Code quality and technical debt | When code is hard to maintain |

## Quick Decision Guide

```
What are you looking for?
         │
         ├── Bugs, defects, security risks
         │   └── Use 01-code-review.md
         │
         ├── Performance bottlenecks, resource usage
         │   └── Use 02-code-optimization.md
         │
         └── Code quality, maintainability, tech debt
             └── Use 03-code-refactoring.md
```

## Workflow Relationships

| Workflow | Focus | Typical Severity | When to Run |
|----------|-------|------------------|-------------|
| **01-code-review** | Bugs, risks, defects | S0-S2, P0-P2 | Before merge, regular audits |
| **02-code-optimization** | Performance | S1-S2, P1-P2 | Performance issues, scaling |
| **03-code-refactoring** | Maintainability | S2-S3, P2-P3 | Tech debt, before new features |

## Shared Elements

All three workflows use:
- **Severity scoring**: S0 (Critical) → S3 (Low)
- **Priority scoring**: P0 (Blocker) → P3 (Backlog)
- **Parallel agents**: 3-5 agents scanning different aspects
- **Output format**: Report saved to `plans/` with findings ordered by priority

See [`../00-meta/severity-priority-rubric.md`](../00-meta/severity-priority-rubric.md) for the full scoring rubric.

## Running Multiple Reviews

You can run multiple workflows on the same codebase:

1. **Comprehensive audit**: Run all three sequentially
2. **Pre-release**: Run 01-code-review (required) + 02-optimization (if applicable)
3. **Tech debt sprint**: Run 03-code-refactoring first, then plan implementation

When running multiple reviews:
- Findings may overlap (e.g., a performance issue that's also a bug)
- Consolidate findings into a single implementation plan
- Deduplicate before prioritizing

## Output Location

All workflows save reports to `plans/` (project root):
- `plans/code-review-YYYY-MM-DD-HH-MM.md`
- `plans/code-optimization-YYYY-MM-DD-HH-MM.md`
- `plans/code-refactoring-YYYY-MM-DD-HH-MM.md`

## Related Workflows

- [Plan Review](../01-planning/01-plan-review.md) - Review implementation plans
- [Security Review](../06-security/01-security-review.md) - Security-focused audit
- [Execution](../02-build-code/01-execution.md) - Implement fixes from review findings
