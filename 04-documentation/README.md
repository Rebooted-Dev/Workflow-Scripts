# Documentation Workflows

This directory contains workflows for keeping documentation in sync with code.

## Workflow Index

| File | Purpose | When to Use |
|------|---------|-------------|
| [`sync-documentation.md`](./sync-documentation.md) | Review code and update docs to match | After code changes, periodic maintenance |

## Quick Start

Use the documentation sync workflow when:
- After major code changes
- When documentation seems outdated
- Before releases
- Periodic documentation maintenance

## Priority Buckets (Documentation-Specific)

| Priority | Description | Examples |
|----------|-------------|----------|
| **P0** | Incorrect docs causing wrong usage | Wrong API examples, broken setup instructions |
| **P1** | Missing docs for critical flows | No setup guide, missing architecture docs |
| **P2** | Reorganization and consolidation | Duplicate content, poor structure |
| **P3** | Diagrams and polish | Missing visuals, formatting improvements |

## Workflow Overview

The sync-documentation workflow follows these steps:

1. **Scan codebase** - Use parallel agents to understand current behavior
2. **Inventory docs** - Catalog existing documentation, tag issues P0-P3
3. **Fix in priority order** - P0 first, then P1, P2, P3
4. **Reorganize** - Create meaningful subdirectories in `docs/`
5. **Add diagrams** - Text-based diagrams (Mermaid recommended)
6. **Cross-link** - Remove redundancy, add references between related docs

## Expected `docs/` Structure

```
docs/
├── README.md           # Overview and navigation
├── setup/              # Getting started guides
├── architecture/       # System design docs
├── api/                # API reference
├── guides/             # How-to guides
└── troubleshooting/    # Common issues (user-facing)
```

> Adapt structure to your project's needs. The key is clear organization by audience and purpose.

## Related Workflows

- [Execution](../02-build-code/01-execution.md) - Often triggers doc updates
- [Code Review](../05-review-audit/01-code-review.md) - May identify doc gaps
- [Project Setup](../00-initial-setup/01-setup-project.md) - Initial documentation structure
