# pstack across harnesses

pstack is an open-source Cursor plugin created by Lauren Tan (@poteto), a Cursor engineer, React core team member, and Grok Bot contributor at SpaceXAI. It packages engineering principles, task playbooks, and on-demand skills (centered on the `/poteto-mode` router) so agents write less but higher-quality, verifiable code instead of high-volume “slop.” Skills cover investigation (`/how`, `/why`), parallel work (`/swarm`), TDD, review, and multi-model workflows. It is designed to work especially well with Cursor’s ability to mix frontier models.

“Cursor Stack” in the original post is not a separate product. It refers to running official pstack inside Cursor, which also brings Cursor Projects, Cloud Agents, and Grok Bot. The poster prefers this combination for day-to-day UX and multi-model access, while still using Claude models (via Claude Code) for planning and development when desired.

pstack-claude / pstack-codex are unofficial community ports that adapt the same skills and playbooks for Claude Code, Codex, Pi, OpenCode, Gemini, and related harnesses. The main maintained port is [michael-denyer/pstack-claude](https://github.com/michael-denyer/pstack-claude) (Claude + Codex + Pi in one repo). Alternative: `ericlitman/open-pstack`. They track the upstream Cursor plugin but can lag; tool/model mappings differ by harness. Upstream has also begun a native Codex package under `cursor/plugins` (`pstack/codex/` — PR activity); treat community vs official Codex packaging as something to re-check before installing.

## Install

- **Official pstack (Cursor):** in Cursor chat run `/add-plugin pstack`, then `/setup-pstack`. Marketplace: https://cursor.com/marketplace/cursor/pstack. Source: https://github.com/cursor/plugins/tree/main/pstack.
- **Claude Code port:** `/plugin marketplace add michael-denyer/pstack-claude` then `/plugin install pstack@pstack-claude`. Repo: https://github.com/michael-denyer/pstack-claude.
- **Codex port (same repo):** `codex plugin marketplace add michael-denyer/pstack-claude` then `codex plugin add pstack@pstack-claude` (trust hooks via `/hooks`). Skills-only fallback: symlink `plugins/pstack/skills/*` into `~/.agents/skills/`. Enable `[features] multi_agent = true` for arena/interrogate/architect fan-out.
- **Pi:** `pi install git:github.com/michael-denyer/pstack-claude` (extension supplies subagent / question / loop tools).
- **Shared skills-only (OpenCode, Gemini, Prime, etc.):** link or `npx skills add` the port’s `plugins/pstack/skills` tree into `~/.agents/skills/`.

## Benefits: official Cursor pstack vs ports

### What you keep either way

Playbooks, principles, `/poteto-mode`, `/how`, `/why`, `/interrogate`, `/arena`, `/architect`, TDD, verification, unslop/deslop — these are mostly instruction content (`SKILL.md`), not Cursor APIs. The engineering discipline transfers.

### Benefits of original (Cursor) pstack

1. **Authoritative source.** Lauren maintains it; ports sync against pins and can lag (port docs cite specific upstream SHAs / versions).
2. **True multi-vendor model routing.** Subagents can be assigned different frontier families (Fable / Sol / Grok / Opus, etc.) in one task. That is the design center of `arena`, `interrogate`, `architect`, and `how`. Cursor is the best fit for that.
3. **First-class Cursor primitives.** `/setup-pstack` → `~/.cursor/rules/pstack-models.mdc`; Task/background agents; `/loop` for long unattended runs; Cloud Agents / Projects / Grok Bot as the “Cursor Stack” UX.
4. **No translation tax.** Skills assume Cursor tools; no Platform notes or mapping files that can drift.
5. **Fearless parallelism with the intended runtime.** Parallel agents + per-role models is what “write less, verify more” was tuned against.

### Benefits of pstack-claude / Codex (and Pi) ports

1. **Same rigor outside Cursor.** If day-to-day work is Claude Code, Codex, or Pi, you get poteto-mode playbooks without copying skills by hand or leaving Cursor refs that do not resolve.
2. **Editorial port, not a dumb vendor.** michael-denyer rewrites Cursor primitives to harness equivalents (Agent tool, AskUserQuestion, model slugs, built-ins). Weaker ports only rename namespaces and leave broken Cursor refs.
3. **One skills tree, many runtimes.** Claude Code plugin + Codex plugin + Pi package + `~/.agents/skills` sharing — useful when this machine runs several harnesses (matches Workflow-Scripts “per harness” install pattern).
4. **Automatic routing where the harness allows it.** Claude/Codex SessionStart hooks (and Pi system-prompt injection) push non-trivial work into `poteto-mode` without remembering to type it — opt-out via `setup-pstack` / sheet.
5. **Harness-local setup sheets.** e.g. `~/.claude/pstack-models.md`, `~/.codex/pstack-models.md`, `~/.pi/agent/pstack-models.md` instead of Cursor-only `.mdc`.
6. **Claude-only pressure substitute.** On single-vendor Claude Code, four-way model diversity collapses; the port routes “harsher pass” to bundled `thermo-nuclear-code-quality-review` so review still has teeth without external CLIs.
7. **Optional extras.** Imports selected cursor-team-kit skills; Pi extension fills missing subagent/loop tools; skills CLI install path for agents without plugin marketplaces.

### Costs / tradeoffs of the ports

| Cost | Detail |
|------|--------|
| Lag / fork drift | Tracks upstream by pin; Cursor-only features (sticky-mode metadata, Grok Bot UI, some automations) deliberately excluded |
| Weaker multi-model panels | Claude Code cannot match Cursor’s cross-vendor fan-out; Codex needs configured diverse models + `multi_agent` |
| Mapping maintenance | `codex-tools.md` / `pi-tools.md` / substitutions must stay correct or mid-task tool names fail |
| Duplicate installs | Do not stack official Cursor pstack *and* a conflicting second Cursor copy (`backnotprop/pstack`); ports are for *other* harnesses |
| Official Codex packaging emerging | Re-check whether native `cursor/plugins` Codex package supersedes the community Codex path before standardizing |

## Decision vs `01-setup-project.md` Step 2.12

**Short answer: keep what Step 2.12 already locks. Do not treat multi-harness pstack ports as an upgrade to the curated stack.**

What you already have ([`00-project-setup/01-setup-project.md`](../../00-project-setup/01-setup-project.md) Step 2.12 + [`skills/precedence.md`](../../00-project-setup/skills/precedence.md)):

| Layer | Owner | Scope today |
|-------|--------|-------------|
| Alignment / spec / tickets | Matt Pocock | Global across harnesses via `npx skills` |
| Execution / verification | **Official Cursor pstack** | Cursor plugin + `~/.cursor/rules/pstack-models.mdc` |
| Design | Impeccable | Global where installer supports it |
| Claude/Codex pstack port | Listed as **optional** | Not required for the curated stack |

That composition is the “way to go.” Multi-harness ports do **not** replace or improve Step 2.12; they only fill a gap **if** you run poteto-mode *outside* Cursor.

### When ports are beneficial

Install michael-denyer/pstack-claude **only for a harness where you regularly execute after Pocock handoff** (implement / verify / babysit PRs in Claude Code, Codex, or Pi), and Cursor is not the session you are in.

### When ports are not worth it (default for you)

Skip ports if any of these are true:

1. **Cursor is already the execution home** — official pstack + model routing is the designed fit; ports are a weaker copy of the same methodology.
2. **Claude/Codex are mainly for planning / grilling** — Pocock (already global) is the right pack; auto-routing poteto-mode hooks on those harnesses can fight the “Pocock first, pstack after decisions” handoff.
3. **You want less maintenance** — ports lag upstream, need mapping files, and Codex packaging may move under official `cursor/plugins` soon.
4. **You expect Cursor-grade multi-model arena elsewhere** — you will not get it on Claude Code; you only get methodology parity.

### Recommendation (locked for now)

- **Stay with Step 2.12 as written:** Pocock global + official Cursor pstack + Impeccable; port remains optional, not curated.
- **Do not** add pstack-claude to `skills/01-global-install.md` unless/until you notice a real pattern: “I keep implementing in Claude Code/Codex without poteto-mode and quality drops.”
- If that pattern appears, install the port **for that harness only**, keep Cursor on official pstack, and keep the Pocock → pstack phase handoff unchanged.

Phase handoff stays: **grill/spec/tickets with Pocock → execute under pstack (Cursor official, or port only outside Cursor) → verify → optional review.**
