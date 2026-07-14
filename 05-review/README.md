# Review & Audit Workflows

This directory contains workflows for reviewing code quality, performance, and maintainability.

## Workflow Index

| File | Purpose | When to Use |
|------|---------|-------------|
| [`00-dependencies.md`](./00-dependencies.md) | Dependency inventory, version research, security review, and upgrade planning | Before dependency upgrades or on a maintenance cadence |
| [`01-code-review.md`](./01-code-review.md) | General code review for defects and risks | Before merging, periodic audits |
| [`02-code-optimization.md`](./02-code-optimization.md) | Performance-focused analysis | When performance issues suspected |
| [`03-code-refactoring.md`](./03-code-refactoring.md) | Code quality and technical debt | When code is hard to maintain |
| [`04-website-data-refactoring.md`](./04-website-data-refactoring.md) | Website content/data organization | When data is scattered or untyped |
| [`05-comprehensive-audit.md`](./05-comprehensive-audit.md) | Orchestrated full audit using all applicable review workflows | When you need one deduplicated, evidence-backed assessment |

## Quick Decision Guide

```
What are you looking for?
         │
         ├── Dependency versions, supply-chain risk, or upgrade sequencing
         │   └── Use 00-dependencies.md
         │
         ├── Bugs, defects, security risks
         │   └── Use 01-code-review.md
         │
         ├── Performance bottlenecks, resource usage
         │   └── Use 02-code-optimization.md
         │
         ├── Code quality, maintainability, tech debt
         │   └── Use 03-code-refactoring.md
         │
         ├── Scattered/untyped website content, data organization
         │   └── Use 04-website-data-refactoring.md
         │
         └── Full repository audit and improvement strategy
             └── Use 05-comprehensive-audit.md
```

## Workflow Relationships

| Workflow | Focus | Typical Severity | When to Run |
|----------|-------|------------------|-------------|
| **00-dependencies** | Packages, repositories, hosted services, and upgrade risk | S0-S3, P0-P3 | Before upgrades, releases, or on a maintenance cadence |
| **01-code-review** | Bugs, risks, defects | S0-S2, P0-P2 | Before merge, regular audits |
| **02-code-optimization** | Performance | S1-S2, P1-P2 | Performance issues, scaling |
| **03-code-refactoring** | Maintainability | S2-S3, P2-P3 | Tech debt, before new features |
| **04-website-data-refactoring** | Data organization | S2-S3, P2-P3 | Content scattered, CMS prep |
| **05-comprehensive-audit** | Full repo health | S0-S3, P0-P3 | Deep audit, roadmap planning |

## Shared Elements

All workflows use:
- **Severity scoring**: S0 (Critical) → S3 (Low)
- **Priority scoring**: P0 (Blocker) → P3 (Backlog)
- **Parallel agents**: follow `../00-Meta-Workflow/00-meta/agent-spawning-policy.md`
- **Output format**: Report saved to `<metadata-root>/research/` with findings ordered by priority

See [`../00-Meta-Workflow/00-meta/severity-priority-rubric.md`](../00-Meta-Workflow/00-meta/severity-priority-rubric.md) for the full scoring rubric.

## Running Multiple Reviews

You can run multiple workflows on the same codebase:

1. **Comprehensive audit**: Use 05-comprehensive-audit; it performs shared discovery, bounded parallel domain reviews, reconciliation, and one consolidated report
2. **Pre-release**: Run 01-code-review (required), 00-dependencies when dependencies changed, and 02-optimization when applicable
3. **Tech debt sprint**: Run 03-code-refactoring first, then plan implementation
4. **Content cleanup**: Run 04-website-data-refactoring before CMS integration

When running multiple reviews:
- Findings may overlap (e.g., a performance issue that's also a bug)
- Consolidate findings into a single implementation plan
- Deduplicate before prioritizing

## Output Location

All workflows save reports to `<metadata-root>/research/` using the metadata-root and naming convention defined in [`../00-Meta-Workflow/00-meta/naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md). In host projects this is normally `project/research/`; in Workflow-Scripts itself this is `00-project/research/`. If no metadata root exists, run `00-project-setup/01-setup-project.md` before filing reports.

- `<metadata-root>/research/code-review-YYMMDD-HHMM-{model}.md`
- `<metadata-root>/research/dependency-review-YYMMDD-HHMM-{model}.md`
- `<metadata-root>/research/dependency-update-research-YYMMDD-HHMM-{model}.md`
- `<metadata-root>/research/dependency-security-review-YYMMDD-HHMM-{model}.md`
- `<metadata-root>/research/code-optimization-YYMMDD-HHMM-{model}.md`
- `<metadata-root>/research/code-refactoring-YYMMDD-HHMM-{model}.md`
- `<metadata-root>/research/website-data-refactoring-YYMMDD-HHMM-{model}.md`
- `<metadata-root>/research/comprehensive-audit-YYMMDD-HHMM-{model}.md`

## Related Workflows

- [Plan Review](../01-planning-and-organizing/01-plan-review.md) - Review implementation plans
- [Security Review](../06-security/01-security-review.md) - Security-focused audit
- [Execution](../02-code-build/01-execution.md) - Implement fixes from review findings
- [Sync Documentation](../04-documentation/02-sync-documentation.md) - Update docs after data refactoring
