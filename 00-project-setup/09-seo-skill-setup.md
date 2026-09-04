# Workflow: Install and Set Up SEO Skill (iannuttall/seo)

**Status:** Active workflow — promoted 2026-09-04 from candidate `Core-Knowledge/Tech-notes/Workflow-Scripts/workflow-ideas-candidates/2026-09-04-seo-skill-setup.md` after a verified end-to-end run.  
**Upstream:** [github.com/iannuttall/seo](https://github.com/iannuttall/seo) · docs [seoskill.dev](https://seoskill.dev) · npm `seo`  
**Verified on:** this machine (Jesse's Mac) 2026-09-04 — Node v22.23.1, all five agents wired, GSC layer live.

## Purpose

Repeatable install of the `seo` CLI + packaged agent **skill** + optional **MCP** server into local agents (Cursor, Claude Code, Codex, OpenCode, pi CLI, Claude Desktop), followed by guided first-party setup (Google / Search Console / optional analytics) and verification.

This is an install + agent-wiring workflow. Site code changes from SEO findings are a separate, explicitly scoped task after a report has real evidence (use the `02-code-build` family for that).

## Prerequisites

| Item | Requirement |
| --- | --- |
| Node | **22.19+** (npm `seo` engines; this machine runs v22.23.1 ✅) |
| Google (optional at first) | Search Console property access for first-party query/page data |
| Research providers (optional) | DataForSEO / Semrush / Ahrefs — only when external SERP/keyword evidence is needed |

URL-only technical reports work with no Google sign-in at all.

## Decision: Skill vs MCP vs CLI

Three layers of one product — the **CLI** executes, the **skill** routes agents (discover → describe → run), the **MCP** exposes the same report catalog to MCP clients.

Default per agent (verified layouts on this machine):

| Agent | Default stack | Skill location | MCP wiring |
| --- | --- | --- | --- |
| Cursor | CLI + skill + MCP | `~/.cursor/skills/` (universal hub consumer) | `seo mcp install --cursor` → `~/.cursor/mcp.json` |
| Claude Code | CLI + skill + MCP | `~/.claude/skills/` (symlink into `~/.agents/skills/`) | `seo mcp install --claude-code` → `~/.claude.json` `mcpServers` |
| Codex | CLI + skill + MCP | `~/.codex/skills/` (universal hub consumer) | `seo mcp install --codex` → `~/.codex/config.toml` `[mcp_servers.seo]` |
| OpenCode | CLI + skill + MCP (manual) | `~/.config/opencode/skills/` (universal hub consumer) | manual `opencode.json` `"mcp"` entry — no installer flag |
| pi CLI | CLI + skill only | `~/.pi/agent/skills/` (own copy) | **none** — pi ships without built-in MCP by design |
| Claude Desktop | MCP only | n/a | `seo mcp install --claude-desktop` |

If MCP is unwanted, the skill still drives any agent via shell: `seo reports list -- describe -- run` (always `describe` a report before its first run in a session).

## Install Path A: Guided (recommended first time)

```sh
npm i -g seo     # installs to /Users/jesse/.local/bin/seo on this machine
seo start        # browser OAuth → Search Console property → optional analytics → project profile
```

**Verified OAuth note (2026-09-04):** the shared Google app works fine — read-only GSC+GA scopes, no BYO client needed. `seo auth login` alone also completes the Google layer non-interactively from the agent side once the owner finishes the browser step.

## Install Path B: Skill into agents

```sh
# All five agents at once (skills CLI symlinks via the ~/.agents/skills/ hub;
# Codex/Cursor/OpenCode are routed as universal hub consumers, Claude Code symlinked, pi copied):
npx -y skills add iannuttall/seo -g --skill seo \
  --agent claude-code --agent codex --agent cursor --agent pi --agent opencode

# Or CLI-aligned (keeps the packaged skill matched to the installed CLI version):
seo skill install
```

The skill is a **copied/symlinked file** — it does not auto-update with upstream. Refresh by re-running either command; review local edits before overwriting.

## Install Path C: MCP

```sh
seo mcp install --cursor --claude-code --codex   # back up each config first (see below)
```

Installer flags: `--cursor`, `--claude-code`, `--codex`, `--claude-desktop`, `--all`. There is **no** `--opencode` flag. The installer resolves real node/package paths itself (e.g. Codex's entry uses `~/.hermes/node/bin/node` + `~/.local/lib/node_modules/seo/dist/cli.js`).

OpenCode manual entry — use the **absolute** binary path (OpenCode MCP entries run with a restricted `PATH`):

```json
"mcp": {
  "seo": {
    "type": "local",
    "command": ["/Users/jesse/.local/bin/seo", "mcp", "serve"],
    "enabled": true
  }
}
```

Config backup conventions on this machine: `~/.cursor/mcp.json.backup-<date>`, `~/.claude.json.bak-<date>`, `~/.codex/config.toml.bak-<date>`, `opencode.json.bak-<date>`.

## Verification Checklist

Run in order; pass criteria in brackets:

```sh
seo doctor            # [no blocking auth/config failures for the chosen path]
seo skill list        # [packaged seo skill listed]
seo help
seo sites             # [GSC property visible after auth]
seo report --url https://YOUR-CANONICAL-HOST   # [one report completes with findings or explicit could-not-check]
seo reports list --json && seo reports describe <id> --json   # [catalog smoke]
```

Per-agent spot checks: `SKILL.md` present in each agent's skill dir (or the `~/.agents/skills/seo` hub for universal consumers); `seo` entry present in each MCP config; pi loads the skill via `/skill:seo`.

## Agent Contract (what the skill teaches)

1. Discover report ids (`seo reports list`).
2. **Describe** one report before first use (schema, read order, `doNotClaim` limits).
3. Run compact first; narrow follow-ups only if needed.
4. Keep **observations** separate from **heuristics** and **proposed actions**.
5. Inspect date ranges, row caps, partial states, caveats.
6. Propose limited fixes plus a verification step.
7. **Never** promise traffic, ranking, indexation, or AI-citation outcomes.

Known operational limits (verified): GSC comparison windows ≤120 days for the performance overview; `index-coverage` needs a `crawlReportId` (crawl with `saveReport: true`); managed documents (`llms.txt`, robots, sitemap) edge-cache for 5 min.

## Related

- Candidate/evidence record: `Core-Knowledge/Tech-notes/Workflow-Scripts/workflow-ideas-candidates/2026-09-04-seo-skill-setup.md`
- Example end-to-end run: `Hyper-Pasta-Dev/project/research/2026-09-04-seo-skill-baseline-assessment-site-v2.md` (+ `seo-evidence/2026-09-04/`)
- Skills generally: [`06-skills-setup.md`](./06-skills-setup.md) · MCP config: [`05-mcp-and-config-setup.md`](./05-mcp-and-config-setup.md)
