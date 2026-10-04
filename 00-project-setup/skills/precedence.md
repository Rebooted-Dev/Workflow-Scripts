# Skills stack precedence

Living inventory of the curated engineering + design agent skills: what we keep, what we install, what we disable, and how packs compose without fighting.

Install commands and fresh-machine steps live in [01-global-install.md](./01-global-install.md). Per-repo context: [02-project-scan.md](./02-project-scan.md) → [03-project-scaffold.md](./03-project-scaffold.md).

## Precedence (locked)

1. **Impeccable** owns design. On conflict with other design/taste packs, Impeccable (and its DESIGN.md) wins.
2. **Official shadcn** (`shadcn-ui/ui`) owns shadcn/ui workflow. Cursor marketplace shadcn plugin stays disabled.
3. **Matt Pocock** owns alignment / spec / tickets. **pstack** owns execution / verification after handoff. Both stay installed.
4. Installs are **global** for Claude Code, Codex, Cursor, Pi, and Grok where the installer supports them.

## Engineering packs

### Matt Pocock — Skills for Real Engineers

- Repo: [github.com/mattpocock/skills](https://github.com/mattpocock/skills)
- Role: Alignment before code — grilling, domain docs, specs, tickets, triage.
- Flagship: `grill-me`, `grill-with-docs`, `to-spec`, `to-tickets`, `tdd`, `domain-modeling`, `ask-matt`.
- Install path: **skills.sh / `npx skills`** global copies (typically under `~/.agents/skills`, with Claude symlinks). Do **not** also install the Claude marketplace plugin or every skill will duplicate.
- Config (per **application** repo, when using the engineering chain):

```text
/setup-matt-pocock-skills
```

Sets issue tracker, triage labels, and domain doc layout that the other skills consume. See [03-project-scaffold.md](./03-project-scaffold.md).

### pstack (Lauren Tan / poteto)

- Upstream: Cursor plugin via `/add-plugin pstack` ([cursor/plugins `pstack`](https://github.com/cursor/plugins/tree/main/pstack))
- Claude/Codex port (optional): [michael-denyer/pstack-claude](https://github.com/michael-denyer/pstack-claude)
- Role: Execution discipline after decisions are settled — `/poteto-mode`, principles, parallel agents, verification, unslop.
- Do **not** also install `backnotprop/pstack` on top of the Cursor plugin.
- Config (once per machine / when models change):

```text
/setup-pstack
```

Writes `~/.cursor/rules/pstack-models.mdc` for per-role model routing.

### Pocock + pstack handoff (no conflict)

The packs compose by **phase**, not as two always-on defaults.

| Phase | Owner | Invoke | Avoid |
| --- | --- | --- | --- |
| Ambiguity / decisions | Pocock | `/grill-me`, `/grill-with-docs`, `/ask-matt` | `/poteto-mode` before decisions settle |
| Spec + tickets | Pocock | `/to-spec`, `/to-tickets`, `/wayfinder` | Parallel competing plan docs |
| Implementation | pstack | `/poteto-mode` (or `how` / `architect` / `arena` / `swarm`) | Pocock `/implement` as a second driver on the same task |
| Verification | pstack | blast-radius, prove-it-works, verification principles | Skipping proof because a spec exists |
| Review | pstack `unslop` / `interrogate`, or Pocock `/code-review` | Running both full reviews unless you want a second pass |
| TDD | Pocock `/tdd` on his path; pstack TDD principle inside poteto-mode | Superpowers (third methodology) |

Handoff: **grill/spec/tickets with Pocock → execute under pstack without re-litigating settled decisions → verify with pstack → optional review.**

### Superpowers

- Status: **Disabled as default** (may exist in Cursor plugin cache). Would clash with Pocock + pstack as a third methodology. Leave unused.

## Design / UI packs

### Impeccable (priority)

- Repo: [github.com/pbakaus/impeccable](https://github.com/pbakaus/impeccable)
- Role: Product-specific, anti-generic design system / redesign craft.
- Prefer the Impeccable installer over bare `npx skills add pbakaus/impeccable`.
- Per project with UI/design work: `/impeccable init` → `PRODUCT.md` (interview; do not invent). Approve hooks if prompted.

### Anthropic frontend-design

- Role: Light direction / anti-generic prompt. **Impeccable wins** on conflict.
- Often present as Claude plugin `frontend-design@claude-code-plugins`. Elsewhere: `npx skills add anthropics/skills --skill frontend-design -g`

### Vercel web-design-guidelines + react-best-practices

- Repo: [github.com/vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills)
- Role: Pre-ship a11y/consistency review; React/Next patterns while coding.
- No extra per-repo setup beyond having the skills installed.

### brand-guidelines / theme-factory (Anthropic)

- Explicit-only. Do not always-on when Impeccable is active. Impeccable DESIGN.md is source of truth for active redesigns.

### Disabled (clash with Impeccable)

Do **not** install:

- [emilkowalski/skills](https://github.com/emilkowalski/skills) (`emil-design-eng`, motion pack)
- [jakubkrehel/make-interfaces-feel-better](https://github.com/jakubkrehel/make-interfaces-feel-better)
- `ui-ux-pro-max`
- `12-principles-of-animation`

If any of these appear later, remove them so Impeccable stays the sole deep design pack.

## Components / QA / discovery

### Official shadcn (precedence)

- Source: [shadcn-ui/ui](https://www.skills.sh/shadcn-ui/ui/shadcn)
- Cursor marketplace shadcn plugin stays **disabled** (plugin id `6948` may remain in cache; **enabled** lists must not include it). Cache ≠ enabled.
- After disable/enable changes: start a **new** Agent session so MCP/slash caches refresh.

### React Doctor

- Source: [millionco/react-doctor](https://github.com/millionco/react-doctor)
- Role: Tool-backed React health / design scan after edits.
- Prefer `npx react-doctor@latest install` (global). Fallback: skills.sh `millionco/react-doctor`.
- Use after React changes: `npx react-doctor@latest --verbose --scope changed` (or `/doctor` triage). Complements Vercel React skills; does not replace them.
- Avoid accepting project-local CI/hook writes into non-React repos unless intentionally wanted.

### find-skills

- Source: [vercel-labs/skills](https://github.com/vercel-labs/skills)
- Role: Global meta-discovery of other skills.

## Deferred

| Pack | Why deferred |
| --- | --- |
| Microsoft Playwright CLI | Lean browser automation later; prefer over agent-browser; not in this pass |
| `fixing-accessibility` | Overlaps Vercel `web-design-guidelines` |
| coreyhaines31/marketingskills | Landing-page / SEO-CRO when needed |
| vercel-labs/agent-browser | Skip while Playwright CLI is the chosen lean path |

## Multi-CLI paths

| Tool | Typical global skills path |
| --- | --- |
| Claude Code | `~/.claude/skills/` |
| Codex | `~/.agents/skills/` |
| Cursor | `~/.cursor/skills/` |
| Pi | `~/.pi/agent/skills/` |
| Grok Build | `~/.grok/skills/` |

After global installs: reload each CLI. Run `/impeccable init` (and approve hooks) per harness as needed for design work. Grok may need `/hooks-trust`.

## Clash cheat sheet

| Conflict | Resolution |
| --- | --- |
| Impeccable vs Emil / Jakub / ui-ux-pro-max | Impeccable only; others disabled |
| Impeccable vs frontend-design / brand / theme | Impeccable wins when redesigning; others explicit/light |
| Cursor shadcn vs official shadcn | Official only |
| Pocock vs pstack | Phase handoff (above); Pocock plans, pstack builds |
| Pocock plugin vs skills.sh copy | One install path only |
| Pocock + pstack vs Superpowers | Superpowers off |
| Vercel React patterns vs React Doctor | Patterns while coding; Doctor after edits |
| web-design-guidelines vs fixing-accessibility | Keep Vercel; defer a11y skill |
