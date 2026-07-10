# Naming Conventions

Central reference for file naming conventions across all Workflow-Scripts.

## Generated Reports & Documents

When workflows generate reports or analysis documents, use this standardized naming format.

### Filename Format

```
{report-type}-YYMMDD-HHMM-{model}.md
```

### Components

| Component | Description | Examples |
|-----------|-------------|----------|
| **{report-type}** | Descriptive type of report | `code-review`, `security-audit`, `performance-analysis`, `implementation-plan` |
| **YYMMDD** | Date stamp (2-digit year, month, day) | `260404` = April 4, 2026 |
| **HHMM** | Time stamp (24-hour format, hours and minutes) | `1430` = 2:30 PM, `0920` = 9:20 AM |
| **{model}** | AI model name that generated the report | `claude`, `gpt4`, `gemini` |

### Examples

- `code-review-260404-1430-claude.md`
- `security-audit-260403-0920-gpt4.md`
- `performance-analysis-260402-1630-gemini.md`
- `implementation-plan-auth-260118-1430-claude.md`

### Report Header Template

All generated reports should include this header:

```markdown
# [Report Title]

**Date:** YYMMDD HHMM (24-hour format)  
**Model:** {AI model name}  
**Scope:** [directories/files analyzed]  
**Status:** [Draft/Complete]
```

### Metadata Root Resolution

Workflows should infer the metadata root instead of requiring the user to name output directories in every prompt:

1. If the user gives an explicit output directory, use it.
2. If the repository is Workflow-Scripts itself and contains `00-project/`, use `00-project/`.
3. Otherwise, if the repository contains `project/`, use `project/`.
4. If no metadata root exists, suggest running `../../00-setup/01-setup-project.md` before filing generated artifacts. Do not create ad hoc root-level `plans/`, `research/`, `changelog/`, or `troubleshooting/` directories as a substitute for setup.

### Storage Location

- Review, audit, research, and findings reports: `<metadata-root>/research/{report-type}-YYMMDD-HHMM-{model}.md`
- Active implementation plans: `<metadata-root>/plans/{plan-name}.md`
- Completed/filed plans: `<metadata-root>/plans-completed/<category>/{plan-name}.md`
- Changelog entries: `<metadata-root>/changelog/<type>/<YYYY-MM-DD>-<type>-<short-title>.md`
- Troubleshooting entries: `<metadata-root>/troubleshooting/<category>/<YYYY-MM-DD>-<category>-<short-title>.md`

---

## Workflow Files

### Numbered Prefixes

Used when files have a clear sequence or workflow order:
- Example: `01-plan-review.md` → `02-finalise-plan.md`
- Example: `01-execution.md` → `02-confirm-execution.md`

### Descriptive Names

Used when files are standalone or don't have a clear sequence:
- Example: `sync-documentation.md`, `bug-fix-workflow.md`

---

## Documentation Files

- Use kebab-case: `user-manual.md`, `data-models.md`
- Use descriptive names indicating content
- For split documents: `api-01-authentication.md`, `api-02-endpoints.md`

---

## Changelog & Troubleshooting

### Changelog Entries
- Format: `changelog/<type>/<YYYY-MM-DD>-<type>-<short-title>.md`
- Example: `changelog/added/2026-04-04-added-report-naming-conventions.md`

### Troubleshooting Entries
- Format: `troubleshooting/<category>/<YYYY-MM-DD>-<short-title>.md`
- Example: `troubleshooting/build/2026-04-04-fix-build-errors.md`

---

**See also:**
- Glossary: [`glossary.md`](./glossary.md) — Common workflow terminology
- Severity & Priority Rubric: [`severity-priority-rubric.md`](./severity-priority-rubric.md)
