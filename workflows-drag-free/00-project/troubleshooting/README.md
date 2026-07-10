# Troubleshooting System

This directory contains organized troubleshooting entries for issues encountered while developing or maintaining **workflows-drag-free**. It lives under `00-project/troubleshooting/`.

## Directory Structure

- `build/` - Build & test issues
- `runtime/` - Runtime / execution bugs
- `data/` - Data, catalog, content, persistence issues
- `environment/` - Local setup, shell, permissions, OS quirks
- `security/` - Security advisories & patches
- `index.md` - Chronological index of all entries

## File Naming Convention

```
<yyyy-mm-dd>-<category>-<short-title>.md
```

Examples:
- `2026-07-10-build-wf-validate-failed.md`
- `2026-07-10-environment-missing-tool.md`

## Entry Template

```markdown
# <Short Title>
**Date:** <YYYY-MM-DD>  
**Category:** <build|runtime|data|environment|security|...>  
**Status:** <RESOLVED|OPEN|WORKAROUND>

---

## Symptom
- What you observed: errors, logs, screenshots, failing commands.

## Root Cause
- What was actually wrong, in plain language.

## Fix
- Steps you took to resolve it (commands, code changes, config changes).

## Verification
- How you proved the fix worked (tests, builds, manual checks).

## Notes / Lessons
- Takeaways for "future you": patterns, gotchas, quick checks.
```

## Maintaining the Index

The `index.md` file is the single chronological index of all entries. **Newest entries are listed first.**

When adding a new entry:
1. Create the entry file in the appropriate category folder
2. Add a new row at the **top** of the table in `index.md` with: Date, Category, Title, File path, Status

## For AI Agents / Coding Assistants

When instructed to **"update the logs"** or **"update the log files"**, this refers to:
1. **Update the changelog** - Create a new entry in `changelog/<type>/<yyyy-mm-dd>-<type>-<short-title>.md` and add a row at the top of `changelog/index.md`. See `changelog/README.md` for the template. For **completed plans**, follow **`docs/agents/changelog-and-troubleshooting.md`** § **Plans completed** (`plans-completed/<category>/`) unless the user specifies `changelog/plans/`.
2. **Create a troubleshooting entry (only when applicable)** - Add an entry to `troubleshooting/` **only when** the work involved: a **bug** (incorrect behavior or crash), an **issue** that required debugging or a workaround, or a **non-trivial problem** (significant investigation, multiple steps, or lessons worth preserving). **Do not** add a troubleshooting entry for simple code changes, routine refactors, or straightforward feature additions — changelog alone is enough.
3. **Update the relevant index** - When adding a changelog entry, update `changelog/index.md`; when adding a troubleshooting entry, update `troubleshooting/index.md` (new row at top; only when you created a troubleshooting entry in step 2).
4. **File a completed plan** - When the user says **"file … as completed"**, move the plan to **`plans-completed/<category>/`**, update **`plans-completed/index.md`**, and add a Type=`plan` row to **`changelog/index.md`** (File `../plans-completed/<category>/...`). See `plans-completed/README.md` for categories.

See `AGENTS.md` and `docs/agents/changelog-and-troubleshooting.md` for full guidelines.
