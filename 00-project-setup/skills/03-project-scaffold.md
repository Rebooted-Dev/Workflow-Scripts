# Phase 3: Project scaffold

Fill **only** the gaps from [02-project-scan.md](./02-project-scan.md). Prefer chat skills over hand-copying. Never overwrite `project/changelog/index.md` or `project/troubleshooting/index.md` with empty templates. Never invent `PRODUCT.md` content—run the Impeccable interview.

Orchestrator: [README.md](./README.md). Precedence: [precedence.md](./precedence.md).

## Ordered actions

Run only what the scan requested, in this order:

1. **Base agent layout** — [../01-setup-project.md](../01-setup-project.md)  
   - New project: full setup.  
   - Existing: section **Updating an existing project that already uses this system**.  
   - Preserve indexes; create missing dirs only.

2. **Matt Pocock per-repo config** — in Agent chat:

```text
/setup-matt-pocock-skills
```

   **Org defaults** (use unless the user overrides):

   - Issue tracker: **GitHub** (`gh`)
   - Triage labels: **default** set (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`)
   - Domain docs: **single-context** layout (`docs/agents/domain.md`; glossary/ADR created lazily)

3. **Impeccable product truth** — only if UI/design applies and `PRODUCT.md` is missing:

```text
/impeccable init
```

   Approve hooks if prompted. Skip for pure CLI/backend until a visual surface is planned. Reminder: [stubs/product-md-reminder.md](./stubs/product-md-reminder.md).

4. **Verify** — [README.md](./README.md) Phase 3 checklist.

## Markdown file map

| Path | Purpose | Create via |
|------|---------|------------|
| `PROJECT.md` | Repos, layout, constraints | 01-setup-project |
| `AGENTS.md` | Shared agent rules + links | 01-setup-project |
| `CLAUDE.md` / `GEMINI.md` | `@AGENTS.md` `@PROJECT.md` + harness-only | 01-setup-project; Matt adds `## Agent skills` on CLAUDE |
| `docs/agents/changelog-and-troubleshooting.md` | Log / plans-completed conventions | 01-setup-project |
| `docs/agents/issue-tracker.md` | Where tickets live | `/setup-matt-pocock-skills` |
| `docs/agents/triage-labels.md` | Label vocabulary | `/setup-matt-pocock-skills` |
| `docs/agents/domain.md` | Glossary/ADR consumption rules | `/setup-matt-pocock-skills` |
| `PRODUCT.md` | Durable product truth for design | `/impeccable init` |

### Lazy (do not scaffold empty)

- `GLOSSARY.md`
- `docs/adr/`

Create these when `/domain-modeling` (or equivalent) needs them.

## Stub fallback

If `/setup-matt-pocock-skills` cannot run (offline / skill missing), you may paste [stubs/claude-agent-skills-block.md](./stubs/claude-agent-skills-block.md) into `CLAUDE.md` and write minimal `docs/agents/*` by following the Matt skill seed files under `~/.agents/skills/setup-matt-pocock-skills/` (or re-install Phase 1 first). Prefer fixing the skill install over maintaining hand-copied seeds.

## Explicit non-goals

- Do not duplicate the Top-N / Top-250 catalog from [../06-skills-setup.md](../06-skills-setup.md)
- Do not enable Superpowers, Emil, or marketplace shadcn
- Do not delete or empty existing changelog/troubleshooting entries
