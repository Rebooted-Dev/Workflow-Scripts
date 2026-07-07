# Changelog System

This directory contains organized changelog entries (one file per change) and completed plan documents. **Newest entries are listed first** in `index.md`. One index covers both change entries and archived plans (Type=plan).

## Directory Structure (by type)

- `added/` - New features, capabilities
- `changed/` - Changes in existing behavior or API
- `fixed/` - Bug fixes
- `improved/` - Improvements (performance, UX, DX)
- `docs/` - Documentation-only changes
- `refactor/` - Code refactoring
- `config/` - Configuration, tooling, environment
- `plans/` - Completed/archived full plan documents (date-prefixed filenames); add row to index with Type=plan
- `index.md` - Chronological index of all entries (columns: Date | Type | Title | File | Notes). Types include the above plus `plan`.

## File Naming Convention

Each entry uses this pattern:

```
<yyyy-mm-dd>-<type>-<short-title>.md
```

Examples:
- `2026-07-06-config-00-project-meta-setup.md`
- `2026-07-06-docs-consolidation-archive-index.md`

## Entry Template

Each entry should include:

```markdown
# <Short Title>
**Date:** <YYYY-MM-DD>
**Type:** <added|changed|fixed|improved|docs|refactor|config>

---

## Summary
- One or two sentences describing the change.

## Scope (optional)
- Component, area, or ticket reference if relevant.
```

## Maintaining the Index

The `index.md` file is the single chronological index. **Newest entries are listed first.**

When adding a new entry:
1. Create the entry file in the appropriate type folder
2. Add a new row at the **top** of the table in `index.md` with: Date, Type, Title, File