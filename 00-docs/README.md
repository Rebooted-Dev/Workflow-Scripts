# Docs Directory

Generated reports, archived reviews, and analysis documents produced by workflow runs.

## What Goes Here

**`00-docs/`** contains **generated output** — reports, reviews, and analysis documents produced by running workflow scripts. These are artifacts of workflow execution, not instructions.

| File | Description |
|------|-------------|
| [`CODE-REVIEW-WORKFLOW-SCRIPTS-2026-02-28.md`](./CODE-REVIEW-WORKFLOW-SCRIPTS-2026-02-28.md) | Code review of Workflow-Scripts (2026-02-28) |
| [`WORKFLOW_TO_SKILLS_MAPPING_REPORT.md`](./WORKFLOW_TO_SKILLS_MAPPING_REPORT.md) | Mapping analysis of workflows to skills |
| [`v1-reconciliation-conflict-log-2026-04-01.md`](./v1-reconciliation-conflict-log-2026-04-01.md) | v1 reconciliation conflict log |
| [`old-reviews/`](./old-reviews/) | Archived historical reviews |

## Boundary: `00-docs/` vs `00-meta/`

| Directory | Content | Examples |
|-----------|---------|----------|
| **`00-meta/`** | Templates, rubrics, and **design documents about the workflow system** | Severity rubric, glossary, sync template, agent flexibility guidelines |
| **`00-docs/`** | **Generated reports and archived reviews** produced by running workflows | Code review reports, mapping reports, conflict logs |

**Rule of thumb:** If it's a reusable template or a design reference → `00-meta/`. If it's a one-time generated report or archived review → `00-docs/`.

## Related Directories

- **[`../00-meta/`](../00-meta/)** — Templates, rubrics, and workflow design documents
- **[`../00-plans/`](../00-plans/)** — Active plans for Workflow-Scripts repo work
- **[`../00-plans-completed/`](../00-plans-completed/)** — Archived completed plans
