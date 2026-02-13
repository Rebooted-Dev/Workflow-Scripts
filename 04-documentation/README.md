# Documentation Workflows

This directory contains workflows for keeping documentation in sync with code.

## Workflow Index

| File | Purpose | When to Use |
|------|---------|-------------|
| [`00-doc-templates.md`](./00-doc-templates.md) | Templates for consistent docs sections | Before generating/updating docs, for consistent structure |
| [`01-create-docs.md`](./01-create-docs.md) | Generate comprehensive documentation from scratch | New projects, major documentation overhaul, initial documentation |
| [`02-sync-documentation.md`](./02-sync-documentation.md) | Review code and update docs to match | After code changes, periodic maintenance |
| [`03-mark-completed.md`](./03-mark-completed.md) | Verify reported completed tasks in code; mark verified with ✅; flag false reporting; reconcile changelog/troubleshooting/docs | When plans claim tasks are done and you need to confirm implementation and reconcile logs |
| [`09-optional.md`](./09-optional.md) | Optional doc additions checklist + templates | When you want to recommend high-leverage extra docs without overdoing it |
| [`ascii-art-prompts.md`](./ascii-art-prompts.md) | Standardized prompts for generating ASCII art diagrams | When adding visual diagrams to documentation (referenced by main workflows) |

## Quick Start

Use the **generate comprehensive documentation** workflow when:
- Starting a new project and need initial documentation
- Performing a major documentation overhaul
- Documentation is missing or severely incomplete
- Need comprehensive coverage of all project aspects

Use the **sync documentation** workflow when:
- After major code changes
- When documentation seems outdated
- Before releases
- Periodic documentation maintenance

Use the **mark completed and verify** workflow when:
- A plan or report claims tasks are complete and you need to confirm they were actually implemented
- Before closing a milestone or marking a plan finished
- Reconciling plans with changelog, troubleshooting, and docs (flag false reporting; display issues in descending order of importance/urgency)

## Priority Buckets (Documentation-Specific)

| Priority | Description | Examples |
|----------|-------------|----------|
| **P0** | Incorrect docs causing wrong usage | Wrong API examples, broken setup instructions |
| **P1** | Missing docs for critical flows | No setup guide, missing architecture docs |
| **P2** | Reorganization and consolidation | Duplicate content, poor structure |
| **P3** | Diagrams and polish | Missing visuals, formatting improvements |

## Workflow Overview

### Generate Comprehensive Documentation (`01-create-docs.md`)

This workflow generates complete documentation from scratch (in priority order), covering:

1. **Discovery and Analysis** - Scan codebase with parallel agents to understand all aspects
2. **Core Documentation (P0)** - README.md, user manual
3. **Technical Documentation (P1)** - Architecture, APIs, data models, deployment
4. **Detailed Technical Docs (P2)** - Code modules, class design, testing system
5. **Enhanced Documentation (P3)** - UI/UX specs, code examples, tutorials
6. **Organization** - Structure into subdirectories, cross-reference, add diagrams

### Sync Documentation (`02-sync-documentation.md`)

This workflow updates existing documentation to match code:

1. **Scan codebase** - Use parallel agents to understand current behavior
2. **Inventory docs** - Catalog existing documentation, tag issues P0-P3
3. **Fix in priority order** - P0 first, then P1, P2, P3
4. **Reorganize** - Create meaningful subdirectories in `docs/`
5. **Add diagrams** - Text-based diagrams (ASCII art using `./ascii-art-prompts.md`, or Mermaid for complex diagrams)
6. **Cross-link** - Remove redundancy, add references between related docs

### Mark Completed and Verify (`03-mark-completed.md`)

This workflow verifies that reported completed tasks were actually implemented:

1. **Identify sources** - Locate plan/report files that declare completed tasks
2. **Verify in code** - Use parallel agents to read cited files and confirm implementation (P0→P3)
3. **Mark vs flag** - Mark verified completions with ✅; flag false completion / incomplete / not implemented / docs not updated
4. **Reconcile** - Update changelog, troubleshooting, and related docs to match verified state
5. **Report** - Display all flagged issues in **descending order of importance or urgency**

## Expected `docs/` Structure

The comprehensive documentation workflow generates this structure:

```
docs/
├── README.md                    # Main documentation index
├── user-manual.md               # Or user-manual/ directory
├── architecture/
│   ├── README.md
│   ├── systems-architecture.md
│   ├── code-architecture.md
│   └── file-map.md
├── api/
│   ├── README.md
│   └── [individual-api-docs].md
├── data/
│   ├── README.md
│   └── data-models.md
├── code/
│   ├── README.md
│   ├── modules.md
│   └── classes.md
├── deployment/
│   ├── README.md
│   └── [deployment-guides].md
├── testing/
│   ├── README.md
│   └── [testing-docs].md
├── design/
│   ├── README.md
│   └── ui-ux-specifications.md
├── src-examples/                # Code examples
│   └── [code-example-files]
└── tutorials/                   # Step-by-step tutorials
    └── [tutorial-files]
```

> Adapt structure to your project's needs. The key is clear organization by audience and purpose.

## Related Workflows

- [Execution](../02-build-code/01-execution.md) - Often triggers doc updates
- [Code Review](../05-review-audit/01-code-review.md) - May identify doc gaps
- [Project Setup](../00-project-setup/01-setup-project.md) - Initial documentation structure
