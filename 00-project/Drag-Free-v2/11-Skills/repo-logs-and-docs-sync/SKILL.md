---
name: repo-logs-and-docs-sync
description: Synchronize repository changelog, troubleshooting, docs, and indexes after changes. Use after code changes, bug fixes, non-trivial debugging, policy/config updates, completed plans, docs requests, or when the user says update the logs, update docs, file a technical note, or keep changelog/troubleshooting in sync.
---

# Repo Logs And Docs Sync

Use this skill to make durable repo records match the actual work.

## Overlap Boundary

- Use this as a finisher after code or docs changes, not as the primary debugging or implementation workflow.
- For completed-plan archival, reconcile the plan against live code before moving it.
- For mixed-worktree commits after records are updated, use `dirty-worktree-safe-publish`.

## Decision Rules

- Add a changelog entry for code changes, feature additions, fixes, refactors, config changes, and completed plan work.
- Add a troubleshooting entry only for bugs, incidents, non-trivial debugging, environment blockers, workarounds, or recurring operational issues.
- Add or update docs when the user asks for a technical note, behavior changed, setup changed, or future maintainers need durable context.
- Update indexes every time an indexed directory receives a new, moved, or removed artifact.
- Archive completed plans only when the plan is actually complete or the user explicitly asks to file it as completed after verification.

## Workflow

1. Discover local conventions.
   - Read repo docs such as `project/changelog/README.md`, `docs/agents/changelog-and-troubleshooting.md`, and nearby index files when present.
   - Reuse existing type folders, date formats, filename style, and table structure.

2. Create or update entries.
   - Use one file per changelog/troubleshooting entry when that is the repo convention.
   - Include the date, concise title, problem or change summary, files touched, verification, and follow-up status.
   - Keep docs technical and durable; avoid chat-only explanations when a filed artifact was requested.

3. Update indexes.
   - Add new rows near the top when indexes are newest-first.
   - Repair stale links caused by file moves.
   - Search for old paths or feature strings after large policy or archive changes.
   - For plan completion, update the completed-plan index and any changelog `Type=plan` row to the archived path.

4. Verify record integrity.
   - Reopen touched Markdown to catch malformed tables or bad headings.
   - Run available markdown/link checks when the repo provides them or when many links changed.
   - Ensure logs reflect partial/blocker states honestly.

## Guardrails

- Do not add troubleshooting entries for routine, straightforward feature work.
- Do not claim verification passed unless the command or runtime check was actually run.
- Keep generated records scoped to the task; avoid broad documentation rewrites unless the change requires a repo-wide sweep.
