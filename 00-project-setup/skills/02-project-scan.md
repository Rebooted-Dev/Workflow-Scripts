# Phase 2: Project scan

Run from the **application** project root (not inside Workflow-Scripts itself). Probe **readonly first**, then use the decision table. Do not create or overwrite files in this phase.

Orchestrator: [README.md](./README.md). Fill gaps with [03-project-scaffold.md](./03-project-scaffold.md).

## When to skip

- Current directory is the Workflow-Scripts repository → stop after Phase 1.
- Scan already passed recently and nothing about agent layout / product truth changed → optional re-check only.

## Probe checklist

Run from project root (adjust if harness files use different names):

```bash
# Agent / layout
test -f PROJECT.md && echo "PROJECT.md: yes" || echo "PROJECT.md: MISSING"
test -f AGENTS.md && echo "AGENTS.md: yes" || echo "AGENTS.md: MISSING"
test -f CLAUDE.md && echo "CLAUDE.md: yes" || echo "CLAUDE.md: MISSING"
test -f GEMINI.md && echo "GEMINI.md: yes" || echo "GEMINI.md: MISSING"
test -f PRODUCT.md && echo "PRODUCT.md: yes" || echo "PRODUCT.md: MISSING"

# Directories
test -d docs/agents && echo "docs/agents: yes" || echo "docs/agents: MISSING"
test -d project/changelog && echo "project/changelog: yes" || echo "project/changelog: MISSING"
test -d project/troubleshooting && echo "project/troubleshooting: yes" || echo "project/troubleshooting: MISSING"
test -d project/plans && echo "project/plans: yes" || echo "project/plans: MISSING"
test -d project/plans-completed && echo "project/plans-completed: yes" || echo "project/plans-completed: MISSING"

# Docs agents expect
for f in changelog-and-troubleshooting issue-tracker triage-labels domain; do
  test -f "docs/agents/${f}.md" && echo "docs/agents/${f}.md: yes" || echo "docs/agents/${f}.md: MISSING"
done

# Thin harness imports + Matt Agent skills block
if [ -f CLAUDE.md ]; then
  grep -nE '^@AGENTS\.md|^@PROJECT\.md|^## Agent skills' CLAUDE.md || echo "CLAUDE.md: missing expected markers"
fi
if [ -f GEMINI.md ]; then
  grep -nE '^@AGENTS\.md|^@PROJECT\.md' GEMINI.md || echo "GEMINI.md: missing expected imports"
fi

# Remote (helps Matt setup choose GitHub vs other)
git remote -v 2>/dev/null || echo "git remote: unavailable"

# Global skills (only if Phase 1 may be incomplete)
# npx skills list -g
```

Also note (human/agent observation, not a file probe):

- Does this repo have (or plan) a **UI / design** surface? → drives Impeccable `PRODUCT.md`.
- Is this a **CLI/backend-only** repo with no visual surface planned? → skip Impeccable init until needed.

## Decision table

| Finding | Action (Phase 3) |
|---------|------------------|
| Missing `PROJECT.md`, or `AGENTS.md` still holds project facts / fat rules, or harness files lack `@AGENTS.md` / `@PROJECT.md` | Follow [../01-setup-project.md](../01-setup-project.md) **Updating an existing project…** (or full setup if brand-new). **Do not** wipe changelog/troubleshooting indexes. |
| Missing `docs/agents/changelog-and-troubleshooting.md` or `project/{changelog,troubleshooting,plans}` layout | Same: [../01-setup-project.md](../01-setup-project.md) existing-project path; create only missing folders/files. |
| Missing `docs/agents/issue-tracker.md` or `triage-labels.md` or `domain.md`, or `CLAUDE.md` has no `## Agent skills` | Run `/setup-matt-pocock-skills` (see [03-project-scaffold.md](./03-project-scaffold.md)). |
| UI/product repo and no `PRODUCT.md` | Run `/impeccable init` (interview; do not invent). Approve hooks if prompted. |
| CLI-only / no UI planned and no `PRODUCT.md` | Skip Impeccable until a visual surface is planned. |
| Phase 1 packs missing globally | Return to [01-global-install.md](./01-global-install.md) before scaffolding. |
| All relevant probes present | Report **skill context OK**; stop. |

## Report shape (for agents)

Before editing, emit a short scan report:

1. Project root path
2. Present / missing list (from probes)
3. UI planned? yes/no/unknown
4. Ordered actions to run (or “none”)

Then proceed to [03-project-scaffold.md](./03-project-scaffold.md) only for listed actions.
