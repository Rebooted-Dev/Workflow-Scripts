# Data Models

## Persistence Approach

Workflow-Scripts has **no database or persistent datastore**. All state is file-based:

| Data type | Storage | Format |
|-----------|---------|--------|
| Workflow instructions | Category directories | Markdown |
| Changelog entries | `00-project/changelog/<type>/` | Markdown (one file per change) |
| Changelog index | `00-project/changelog/index.md` | Markdown table |
| Troubleshooting entries | `00-project/troubleshooting/<category>/` | Markdown |
| Active plans | `00-project/plans/` | Markdown |
| Completed plans | `00-project/plans-completed/<category>/` | Markdown |
| Review/audit/research reports | `<metadata-root>/research/` (`project/research/` or `00-project/research/`) | Markdown (dated filenames) |
| Implementation plans | `<metadata-root>/plans/` | Markdown |
| Generated workflow reports (legacy) | `00-Meta-Workflow/00-docs/` | Markdown |
| Skills | `11-Skills/<name>/SKILL.md` | Markdown + YAML stub |

## Changelog Entry Schema

```markdown
# <Short Title>
**Date:** YYYY-MM-DD
**Type:** added|changed|fixed|improved|docs|refactor|config

## Summary
- One or two sentences.

## Scope (optional)
- Component or area reference.
```

Filename: `<yyyy-mm-dd>-<type>-<short-title>.md`

## Troubleshooting Entry Schema

```markdown
# <Short Title>
**Date:** YYYY-MM-DD
**Category:** build|runtime|data|environment|security
**Status:** RESOLVED|OPEN|WORKAROUND

## Symptom / Root Cause / Fix / Verification / Notes
```

## Report Filename Schema

Per [naming-conventions.md](../../../00-Meta-Workflow/00-meta/naming-conventions.md):

```
{report-type}-YYMMDD-HHMM-{model}.md
```

Storage:
- Review/audit/research reports → `<metadata-root>/research/`
- Active plans → `<metadata-root>/plans/`
- Completed plans → `<metadata-root>/plans-completed/<category>/`

## Entity Relationships

```
Workflow change
    ├── changelog entry (always)
    └── troubleshooting entry (bugs/non-trivial fixes only)

Completed plan
    ├── plans-completed/<category>/<dated-plan>.md
    ├── plans-completed/index.md row
    └── changelog/index.md row (Type=plan)
```

## Validation Rules

- Changelog: one file per change; index row required
- Troubleshooting: category folder must match issue domain
- Plans: `yyyy-mm-dd-` prefix required when filing as completed
- No secrets in any persisted file