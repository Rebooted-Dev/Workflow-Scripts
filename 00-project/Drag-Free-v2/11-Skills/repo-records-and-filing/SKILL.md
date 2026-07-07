---
name: repo-records-and-filing
description: Keep Workflow-Scripts changelog, troubleshooting, plan status, completed-plan filing, and indexes consistent. Use after code changes, workflow changes, bug fixes, non-trivial debugging, and completed plans.
---

# Repo Records And Filing

Use this skill whenever work changes repository behavior or durable workflow records.

## Rules

1. Follow the local `AGENTS.md` and `00-project/docs/agents/changelog-and-troubleshooting.md` conventions.
2. Use one file per changelog or troubleshooting entry.
3. Add newest index rows first.
4. Add troubleshooting only for bugs, incidents, non-trivial debugging, environment blockers, workarounds, or recurring operational issues.
5. File completed plans under `<metadata-root>/plans-completed/<category>/` only after verification shows the plan is actually complete.
6. For Workflow-Scripts-system changes, `<metadata-root>` is `00-project/`.
7. Reopen changed records and indexes before finishing to catch malformed tables, stale paths, and unfilled placeholders.

## Verification

- Search touched records for `TODO`, stale old paths, and missing verification commands.
- Run available link and workflow validators when Markdown routing changed.
- Document blocked checks honestly in logs instead of marking them complete.
