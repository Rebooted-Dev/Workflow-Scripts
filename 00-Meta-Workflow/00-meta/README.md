# Meta Directory

This directory contains templates, rubrics, and analysis documents about the workflow system itself.

## File Index

| File | Type | Status | Purpose |
|------|------|--------|---------|
| [`severity-priority-rubric.md`](./severity-priority-rubric.md) | Reference | **Active** | Shared rubric for S0-S3 severity and P0-P3 priority scoring |
| [`glossary.md`](./glossary.md) | Reference | **Active** | Common terminology and conventions used across workflows |
| [`sync-summary-template.md`](./sync-summary-template.md) | Template | **Active** | Template for documentation sync summary reports |
| [`agent-flexibility-review.md`](./agent-flexibility-review.md) | Analysis | **Active** | Guidelines for flexible agent spawning patterns |
| [`filename-review.md`](./filename-review.md) | Analysis | Historical | Review of filename conventions (completed 2026-01) |
| [`parallel-agents-review.md`](./parallel-agents-review.md) | Analysis | Historical | Analysis of parallel agent usage across workflows |

## Quick Reference

### Active Files (Use These)

- **`severity-priority-rubric.md`** - Reference this when scoring issues in any workflow. Defines:
  - Severity levels: S0 (Critical) → S3 (Low)
  - Priority levels: P0 (Blocker) → P3 (Backlog)
  - Mapping rules and evidence requirements

- **`glossary.md`** - Quick reference for workflow terminology. Covers:
  - Priority and severity level definitions
  - Workflow category purposes
  - Task marking conventions
  - Common placeholders and their meanings
  - Severity levels: S0 (Critical) → S3 (Low)
  - Priority levels: P0 (Blocker) → P3 (Backlog)
  - Mapping rules and evidence requirements

- **`sync-summary-template.md`** - Use when creating documentation sync reports

- **`agent-flexibility-review.md`** - Reference when designing workflows with parallel agents. Provides:
  - Guidelines for flexible agent spawning (not fixed numbers)
  - Decision criteria for when to spawn additional agents
  - Patterns for agent role assignment

### Historical Files (For Reference Only)

- **`filename-review.md`** - Documents past filename standardization decisions. Some checklist items may be outdated.
- **`parallel-agents-review.md`** - Documents analysis of parallel agent patterns. Recommendations may have already been implemented.

## Boundary: `00-meta/` vs `00-docs/`

| Directory | Content | Examples |
|-----------|---------|----------|
| **`00-meta/`** (this directory) | Reusable templates, rubrics, and **design documents about the workflow system** | Severity rubric, glossary, sync template, agent flexibility guidelines |
| **`00-docs/`** | **Generated reports and archived reviews** produced by running workflows | Code review reports, mapping reports, conflict logs |

**Rule of thumb:** If it's a reusable template or a design reference → `00-meta/`. If it's a one-time generated report or archived review → `00-docs/`.

## Related Workflows

- All review workflows reference `severity-priority-rubric.md`
- Documentation sync uses `sync-summary-template.md`

## Notes

- Historical files are preserved for audit trail and context
- Active files should be kept current when workflows change
- Consider adding "Last Updated: YYYY-MM-DD" to files when modifying them
