# Troubleshooting System

This directory contains organized troubleshooting entries for issues encountered during Drag-Free-v2 consolidation work. It lives under `00-project/troubleshooting/`.

## Directory Structure

- `build/` - Build & test issues
- `runtime/` - In-browser/runtime UI or logic bugs
- `data/` - Data, prompts, migrations, persistence issues
- `environment/` - Local setup, Node, .env, permissions, OS quirks
- `security/` - Security advisories & patches
- `git/` - Git, worktree, and repository sync issues
- `index.md` - Chronological index of all entries

## File Naming Convention

Each troubleshooting entry uses this pattern:

```
<yyyy-mm-dd>-<category>-<short-title>.md
```

Examples:
- `2026-07-06-git-consolidation-archive-dirty-tree.md`
- `2026-07-06-environment-wf-validate-broken-links.md`

## Entry Template

Each entry should include:

```markdown
# <Short Title>
**Date:** <YYYY-MM-DD>
**Category:** <build|runtime|data|environment|security|git|...>
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
1. **Update the changelog** - Create a new entry in `changelog/<type>/<yyyy-mm-dd>-<type>-<short-title>.md` and add a row at the top of `changelog/index.md`. See `changelog/README.md`. For **completed plans**, follow **`docs/agents/changelog-and-troubleshooting.md`** § **Plans completed** (`plans-completed/<category>/`) unless the user specifies `changelog/plans/`.
2. **Create a troubleshooting entry (only when applicable)** - Add an entry to `troubleshooting/` **only when** the work involved a bug, an issue that required debugging or a workaround, or a non-trivial problem. **Do not** add troubleshooting entries for simple doc or workflow updates — changelog only for those.
3. **Update the relevant index** - When adding a changelog entry, update `changelog/index.md`; when adding a troubleshooting entry, update `troubleshooting/index.md`.
4. **File a completed plan** - When the user says **"file … as completed"**, move the plan to **`plans-completed/<category>/`**, update **`plans-completed/index.md`**, and add a Type=`plan` row to **`changelog/index.md`** (File `../plans-completed/<category>/...`). See `plans-completed/README.md`.

See `00-project/AGENTS.md` Change Management for full guidelines.