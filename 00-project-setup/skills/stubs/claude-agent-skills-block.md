# CLAUDE.md — Agent skills block (stub)

Paste under harness-specific content in `CLAUDE.md` only if `/setup-matt-pocock-skills` cannot run. Prefer running the skill so `docs/agents/issue-tracker.md`, `triage-labels.md`, and `domain.md` are written correctly.

Replace `<OWNER/REPO>` with the GitHub `owner/repo` for this project (from `git remote -v`).

```markdown
## Agent skills

### Issue tracker

GitHub Issues on `<OWNER/REPO>` via `gh`. See `docs/agents/issue-tracker.md`.

### Triage labels

Defaults: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context layout. See `docs/agents/domain.md`.
```

After pasting, still create the three `docs/agents/` files (from Matt skill seeds or a later successful `/setup-matt-pocock-skills` run). Thin `CLAUDE.md` should keep `@AGENTS.md` and `@PROJECT.md` imports above this block.
