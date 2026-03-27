# Skills Setup Task List

Checklist for configuring **Agent Skills** in **Cursor**, **Codex**, **Kilo Code CLI**, and **Gemini CLI**: where they live, how to add personal vs project skills, and how to install or create skills so the AI uses them in the right contexts.

**Principles:** Skills are packaged, reusable instructions that give agents on-demand expertise. They are built on an [open standard](https://agentskills.io/) adopted by many agent platforms. Install a skill package once; the agent loads it when the task matches. Skills fix **prompt drift** (same ask, different results), **lost workflow conventions** (quality checks, formats, decision criteria), and **instruction sprawl** (long playbooks buried in prompts). Centralize instructions in a versioned, reviewable place so the agent "actually knows how we do things here." See [Vercel: Agent skills explained (FAQ)](https://vercel.com/blog/agent-skills-explained-an-faq) for more.

**When to use:** Setting up a new machine, onboarding to a project that uses skills, adding or updating skills (personal or project), or troubleshooting “the agent didn’t use my skill.”

---

## Topic list (quick reference)

| Topic | Where in this doc |
|-------|-------------------|
| **Setup & reference** | |
| Principles, what skills solve, open standard | § Intro (above); § Skills vs MCP… |
| Skills vs MCP, tools, rules, system prompts | § Skills vs MCP… |
| Storage (Cursor, Codex, Kilo Code CLI, Gemini CLI, project) | § Storage locations |
| Top 20 recommended skills | § Top 20 recommended |
| Top 250 from skills.sh (no Azure) | § Top 250 from skills.sh |
| Recommended categories | § Recommended skill categories |
| **By use case** | |
| UI design, visual design, image gen, Nano Banana | § Skills by topic → UI design, visual design… |
| Cybersecurity, code review | § Skills by topic → Cybersecurity… |
| Deployment (Vercel, Netlify, Cloudflare, Render) | § Skills by topic → Deployment |
| **By technology / platform** | |
| AI SDK (Vercel), Agent SDK, TypeScript | § TypeScript, Vercel AI SDK, Agent SDK; § Skills by technology |
| Code review | § Skills by technology |
| Codex (agent) | § Skills by technology |
| Dart, Flutter | § Skills by technology |
| FastAPI, Go/Golang | § Skills by technology |
| Gemini, Gemini API | § Skills by technology; § This project |
| Langchain, RAG implementation | § Skills by technology |
| NotebookLM | § Skills by technology |
| Obsidian, OpenClaw, Rust, Three.js | § Skills by technology (search skills.sh) |
| Podcast, text to speech | § Skills by technology |
| QA and testing | § Skills by technology |
| React Native | § Skills by technology; § Apple / iOS development |
| SEO, GEO | § Skills by technology |
| Seedance, shadcn/ui, Stripe | § Skills by technology |
| Swift, SwiftUI | § Skills by technology; § Apple / iOS development |
| Tailwind, theme/themes | § Skills by technology |
| Tauri | § Skills by technology |
| Twitter thread creation, meme | § Skills by technology |
| Vite, npm | § Skills by technology; § This project |
| YouTube thumbnail design, YouTube API, Google Veo | § Skills by technology |
| **This project** | |
| Vite + React + Gemini + image gen | § This project: Vite + React + Gemini… |
| **Apple / iOS** | |
| Swift, SwiftUI, UIKit, Objective-C, React Native on iOS | § Apple / iOS development |
| **Tasks** | |
| Workflow-Scripts sync; Cursor, Codex, Kilo Code CLI, Gemini CLI install; create skill; verify | § 1–7 (numbered sections) |
| Workflow-Scripts tracked skills (install & tracking) | § Workflow-Scripts: tracked skills and installation |
| Managing install for Cursor, Codex, Kilo Code CLI, Gemini CLI; tracking skill changes | § Managing installation and tracking |
| Automated install and version tracking (manifest, lockfile, script) | § Automated install and version tracking |
| Further reading (Vercel FAQ, agentskills.io, skills.sh) | § Further reading |

### Maintaining this doc

When you change the skills or topics covered in this file, follow **one** of the two steps below (they are mutually exclusive for a single edit). Do not re-apply the other step for the same change—that would be redundant and can cause confusion.

1. **If a skill is added** (to any table or section in this doc):  
   Update the **Topic list** above so the new skill’s topic appears in the table and points to the right section (e.g. § Skills by technology, § Top 250 from skills.sh). Add a row if the topic is new; otherwise ensure the existing topic row still matches.  
   *Stop here.* Do not then search skills.sh for more skills unless you are separately adding a new topic.

2. **If a new topic is added**:  
   Search [skills.sh](https://skills.sh/) for that topic and identify **top-ranking skills** that match (use the leaderboard and search). Add the topic to the **Topic list** and to the **Skills by technology / platform** table (or the appropriate “Skills by topic” subsection) with the skill name(s), repo(s), and any MCP or “search skills.sh” note. The topic list is then already updated; do not re-apply step 1 for the skills you just added. Re-check skills.sh periodically (in a later pass) for new skills on that topic.

---

## Skills vs MCP, tools, rules, and system prompts

Skills, MCP servers, tools, rules, and system prompts each solve different aspects of agent configuration. They work together: skills can reference MCPs, build on system prompts, and incorporate rule-based logic.

| | **What** | **Best for** |
|---|----------|--------------|
| **Skills** | Package *complete workflows*: instructions, context, and decision-making. Tell the agent *when* to use what, how to sequence actions, and what success looks like. | Complex, multi-step processes; domain-specific tasks; repetitive workflows with contextual choices. |
| **MCP servers** | Standardized interfaces for agents to access external tools and services (APIs, DBs, file systems). | Tool integration, API access, reliable interfaces to external services. |
| **Tools** | Individual functions the agent can call (one API call, one web search, one file read). | Single-purpose operations, building blocks for larger workflows. |
| **Rules** | Constraints and logic applied consistently (security, data handling, operational boundaries). | Compliance, access controls, behavioral boundaries. |
| **System prompts** | Foundational behavior, tone, and baseline capabilities. | Core behavior and communication style across all interactions. |

**Quick distinction (Skills vs MCP):**

| | **Skills** | **MCP (Model Context Protocol)** |
|---|------------|-----------------------------------|
| **What** | Markdown instructions that teach the agent *how* to do something | Servers that expose *tools* (APIs, search, files, etc.) |
| **Format** | `SKILL.md` in a directory, with YAML frontmatter + markdown body | JSON config (`mcp.json`, etc.) pointing to stdio or remote servers |
| **Effect** | Agent gets extra context and steps; no new tools | Agent gets new callable tools (e.g. `search_documents`, `run_sql`) |

You typically set up **MCP** for capabilities (search, DB, deploy); you set up **Skills** for workflows, standards, and domain knowledge (commit style, code review, PDF handling). See [05-mcp-and-config-setup.md](05-mcp-and-config-setup.md) for MCP. Source: [Vercel – Agent skills explained (FAQ)](https://vercel.com/blog/agent-skills-explained-an-faq).

---

## Storage locations (reference)

| Tool / scope | Path | Purpose |
|--------------|------|---------|
| **Cursor (personal)** | `~/.cursor/skills/<skill-name>/` | Skills available in all your Cursor projects |
| **Cursor (project)** | `<project>/.cursor/skills/<skill-name>/` | Skills shared with everyone in the repo |
| **Codex** | `$CODEX_HOME/skills/<skill-name>/` (default `~/.codex/skills/`) | Skills available to Codex; install via skill-installer or manual copy |
| **Kilo Code CLI (user)** | `~/.kilocode/skills/<skill-name>/` (Mac/Linux) | User-level skills for Kilo Code CLI |
| **Kilo Code CLI (project)** | `<project>/.kilocode/skills/<skill-name>/` | Project skills for Kilo Code CLI (workspace-level) |
| **Gemini CLI (user)** | `~/.gemini/skills/<skill-name>/` or `~/.agents/skills/<skill-name>/` | User-level skills for Gemini CLI (all workspaces) |
| **Gemini CLI (workspace)** | `<project>/.gemini/skills/<skill-name>/` or `<project>/.agents/skills/<skill-name>/` | Workspace skills for Gemini CLI (shared via repo) |
| **Claude Code (plugins)** | Plugin-specific, e.g. `.claude/plugins/.../skills/` | Skills bundled with Claude Code plugins |

**Important:** Do **not** create or edit skills under `~/.cursor/skills-cursor/`. That directory is reserved for Cursor’s built-in skills and is managed by the app.

---

**How agents use skills:** At startup the agent loads a lightweight index (names and descriptions only). When a task matches a skill's description, it loads the full content. That keeps default context small while making detailed guidance available when it matters. Some platforms also support explicit invocation for forcing a workflow or debugging. ([Vercel FAQ](https://vercel.com/blog/agent-skills-explained-an-faq))

---

## Workflow-Scripts: tracked skills and installation

These are the skills **tracked for Workflow-Scripts** use (frontend, React, React Native, and UI/UX guidance). Tracking and installation are documented here; the former `09-skills/` folder (symlinks into `.agents/skills/`) is **no longer used** — you can remove it. Install the skills below so your agent has them when working with Workflow-Scripts or related workflows.

| Skill | Purpose | How to install |
|-------|---------|----------------|
| **vercel-react-best-practices** | React/Next.js performance, data-fetching, component patterns | Cursor: often built-in. Otherwise: `npx skills add vercel-labs/agent-skills` |
| **vercel-composition-patterns** | React composition (compound components, render props, flexible APIs) | Same repo: `npx skills add vercel-labs/agent-skills` |
| **vercel-react-native-skills** | React Native / Expo best practices (lists, animations, native modules) | Same repo: `npx skills add vercel-labs/agent-skills` |
| **web-design-guidelines** | UI, accessibility, UX audit; “review my UI”, “check accessibility” | Same repo: `npx skills add vercel-labs/agent-skills` |

**Single install (all four):** From any directory:

```bash
npx skills add vercel-labs/agent-skills
```

This installs the Vercel agent-skills package (which includes these four). If using **Cursor**, these may already be available as built-in skills; check Cursor’s skills list before installing. For **Codex**, install into `$CODEX_HOME/skills/` via the skill-installer or by copying the skill directories from the repo.

**Tracking:** To add or remove a skill from this list, edit this section and update the **Topic list** above (§ Topic list) so the row “Workflow-Scripts tracked skills” still points here.

---

## Managing installation and tracking

Skills are installed **per tool**: Cursor, Codex, Kilo Code CLI, and Gemini CLI each use their own directories and do not share a single install. This section covers how to handle installation for all of them and how to keep track of changes to individual skill files.

### Installation: Cursor, Codex, Kilo Code CLI, and Gemini CLI

- **Cursor** reads skills from:
  - Personal: `~/.cursor/skills/<skill-name>/`
  - Project: `<project>/.cursor/skills/<skill-name>/`
- **Codex** reads skills from:
  - `$CODEX_HOME/skills/<skill-name>/` (default `~/.codex/skills/`)
- **Kilo Code CLI** reads skills from:
  - User: `~/.kilocode/skills/<skill-name>/` (Mac/Linux; Windows: `\Users\<username>\.kilocode\`)
  - Project: `<project>/.kilocode/skills/<skill-name>/`
- **Gemini CLI** reads skills from:
  - User: `~/.gemini/skills/<skill-name>/` or `~/.agents/skills/<skill-name>/`
  - Workspace: `<project>/.gemini/skills/<skill-name>/` or `<project>/.agents/skills/<skill-name>/`

There is no single "install once, use everywhere" path. If you use multiple tools, install (or copy) the skill into each tool's directory.

| Goal | What to do |
|------|------------|
| **Use a skill in Cursor only** | Install (or copy) into `~/.cursor/skills/` or the project's `.cursor/skills/`. Use `npx skills add <owner/repo>` if the CLI targets Cursor, or copy the skill folder. |
| **Use a skill in Codex only** | Install into `$CODEX_HOME/skills/` via the Codex skill-installer or by copying the skill directory. |
| **Use a skill in Kilo Code CLI only** | Copy (or install) into `~/.kilocode/skills/` (user) or `<project>/.kilocode/skills/` (project). See [Kilo Code – Skills](https://kilo.ai/docs/features/skills). |
| **Use a skill in Gemini CLI only** | Run `gemini skills install <url-or-path>` or copy into `~/.gemini/skills/` (user) or `<project>/.gemini/skills/` or `<project>/.agents/skills/` (workspace). See [Gemini CLI – Agent Skills](https://geminicli.com/docs/cli/skills/). |
| **Use the same skill in multiple tools** | Install (or copy) into **each** tool's path: Cursor, Codex, Kilo Code CLI, and/or Gemini CLI as needed. Optionally use a small script that installs from one source (e.g. a repo or `npx skills add`) into all desired directories. |
| **Cursor built-in skills** | Many skills (e.g. vercel-react-best-practices) are built into Cursor; you don't need to install those for Cursor. You still need to install them in Codex, Kilo Code CLI, or Gemini CLI if you want them there. |

### Tracking changes to individual skill files

Skills are just files on disk. How you track changes depends on whether they are **yours** (custom or edited) or **third-party** (from a package or repo).

| Situation | How to track / update |
|-----------|------------------------|
| **Project/workspace skills** (e.g. `<project>/.cursor/skills/`, `.kilocode/skills/`, `.gemini/skills/`, `.agents/skills/`) | They are in the repo; use **git** (commit, diff, history). Everyone on the project gets the same skills and changes. |
| **Personal skills** (e.g. `~/.cursor/skills/`, `$CODEX_HOME/skills/`, `~/.kilocode/skills/`, `~/.gemini/skills/`) | Not versioned unless you put them in a repo (e.g. dotfiles or a private "my-skills" repo). To track changes: add that folder to git elsewhere, or keep a short changelog (e.g. in this doc or a `SKILL_CHANGELOG.md`) listing what you changed and when. |
| **Third-party skills** (installed from `npx skills add` or GitHub) | Installed copies do **not** auto-update. To get upstream changes: re-run the install (e.g. `npx skills add <owner/repo>` or Codex skill-installer). To track "which skills I care about" and where they came from: use a **manifest** (e.g. the Workflow-Scripts table in this doc or a small table listing skill name, source repo, and install path). |
| **Edited third-party skills** | If you edit an installed skill, your changes will be overwritten if you re-run the same install. Options: (1) keep your fork in a repo and install from the fork; (2) don't re-install that skill and document your overrides (e.g. in this doc or a changelog); (3) use project or personal skills (in git) that wrap or replace the third-party one. |

**Practical checklist**

- **List what you use:** Keep a table (like § Workflow-Scripts: tracked skills and installation) of skills you rely on, with source (repo or package) and which tool(s) they're installed for (Cursor, Codex, Kilo Code CLI, Gemini CLI).
- **Project conventions:** Prefer **project/workspace** skills (e.g. `.cursor/skills/`, `.kilocode/skills/`, `.gemini/skills/` or `.agents/skills/`) for team-wide workflows so changes are reviewed and tracked in the repo.
- **Updates:** Periodically re-run installs for third-party skills you care about, or subscribe to the upstream repo for release notes.
- **Your edits:** If you customize a skill, put the customized version in a location that's in version control (project or personal repo) so you can diff and revert changes.

### Automated install and version tracking

For the **curated list** (e.g. Top 20, Top 250 in this doc), you can use a **manifest + lockfile + install script** to track which skill sources you want, install them into all your coding agents in one run, and record versions for reproducibility.

| Item | Location | Purpose |
|------|----------|---------|
| **Manifest** | `Workflow-Scripts/00-project-setup/skills-manifest.yaml` (or project root) | Lists **sources** (repo + optional `path` + optional `ref`) and which **agents** to install to (Cursor, Codex, Kilo Code CLI, Gemini CLI). One entry per repo; the script discovers all skills (dirs with `SKILL.md`) in that repo. |
| **Lockfile** | Same dir as manifest: `skills-lock.yaml` | Generated by the script. Records per source: **resolved SHA**, installed skill names, and timestamp. Use for reproducibility (reinstall same versions) or audit ("what do I have?"). Can be gitignored (per-machine) or committed (team reproducibility). |
| **Install script** | `Workflow-Scripts/scripts/install-curated-skills` (or `.sh` / `.mjs`) | Reads the manifest, clones each repo at the given ref, finds all skill directories, copies each into each agent's skills folder, and writes/updates the lockfile. |

**Commands (once the script exists):**

- **Install (first time or after adding sources to manifest):**  
  Run the install script (e.g. `./Workflow-Scripts/scripts/install-curated-skills`). It installs all manifest sources into the configured agents and writes or updates the lockfile.
- **Update (refresh to latest):**  
  Run the same script again. If the manifest uses `ref: main` (or no ref), the script fetches the latest commit, overwrites installed skills in each agent directory, and updates the lockfile with new SHAs.
- **Pin versions:**  
  In the manifest, set `ref` to a tag (e.g. `v1.0.0`) or a full git SHA. Re-run the install script to apply; the lockfile records that SHA for audit.
- **Limit agents (optional):**  
  The script can support a flag (e.g. `--agents cursor,gemini`) so only those agents receive the skills; default is all four.

**Manifest format (example):**

```yaml
# skills-manifest.yaml
agents: [cursor, codex, kilocode, gemini]
sources:
  - repo: vercel-labs/agent-skills
    ref: main
  - repo: openai/skills
    path: skills/.curated
    ref: main
  - repo: anthropics/skills
    ref: main
```

**Agent paths used by the script (user-level):** Cursor: `~/.cursor/skills/<skill-name>/`; Codex: `$CODEX_HOME/skills/<skill-name>/` (default `~/.codex/skills/`); Kilo Code CLI: `~/.kilocode/skills/<skill-name>/`; Gemini CLI: `~/.gemini/skills/<skill-name>/` or `~/.agents/skills/<skill-name>/`.

When the script is implemented, this subsection will reference its exact path and any extra flags. The curated list in this doc (Top 20, Top 250) can be used to populate the manifest (one entry per unique repo; group skills by repo).

---

## Top 20 recommended / most used skills (reference)

Synthesized from Codex curated ([openai/skills](https://github.com/openai/skills)), Cursor built-in skills, Killer-Skills, and agentskill.sh. Use as a checklist for “what to add next.”

**Check the latest:** For current rankings and install counts, use **[skills.sh](https://skills.sh/)** (The Agent Skills Directory). Install skills with `npx skills add <owner/repo>`. The site supports Cursor, Codex, Claude Code, Cline, Windsurf, and others.

**Legend:** **Cursor** = Cursor built-in or common in Cursor; **Codex** = install via Codex skill-installer from openai/skills `.curated`; **Plugin** = often bundled with Claude Code / Cursor plugins; **Killer-Skills** = `npx killer-skills add <name>`; **agentskill.sh** = large catalog, install per site docs.

| # | Skill | Purpose | Source / notes |
|---|-------|---------|----------------|
| 1 | **create-skill** | Guides writing new skills (structure, description, triggers). | Cursor built-in; Codex: skill-creator in `.system` |
| 2 | **create-rule** | Guides adding Cursor rules (conventions, RULE.md, globs). | Cursor built-in |
| 3 | **vercel-deploy** | Deploy apps to Vercel (preview, production, logs). | Codex curated; Vercel plugin |
| 4 | **security-best-practices** | Language/framework security review and secure-by-default guidance. | Codex curated |
| 5 | **pdf** | PDF merge, split, extract, form fill, OCR; visual checks. | Codex curated; Killer-Skills |
| 6 | **frontend-design** | Production-grade UI (spacing, color, responsive); avoids generic AI look. | Cursor/plugin; Killer-Skills; agentskill.sh |
| 7 | **openai-docs** | Up-to-date OpenAI API/docs (Codex, Chat, Realtime, etc.) with citations. | Codex curated |
| 8 | **playwright** | Browser automation (navigation, forms, screenshots, scraping). | Codex curated |
| 9 | **imagegen** | Generate/edit images via OpenAI Image API (DALL·E). | Codex curated |
| 10 | **doc** | Create/edit .docx with formatting and layout fidelity. | Codex curated |
| 11 | **spreadsheet** | Excel/.xlsx and CSV: create, edit, formulas, formatting. | Codex curated |
| 12 | **netlify-deploy** | Deploy and manage sites on Netlify via CLI. | Codex curated |
| 13 | **cloudflare-deploy** | Deploy to Cloudflare (Workers, Pages, infra). | Codex curated |
| 14 | **render-deploy** | Deploy to Render (render.yaml, dashboard). | Codex curated |
| 15 | **security-threat-model** | Repository threat model: trust boundaries, assets, mitigations. | Codex curated |
| 16 | **security-ownership-map** | Git-based ownership / bus factor for security and CODEOWNERS. | Codex curated |
| 17 | **vercel-react-best-practices** | React/Next.js performance and data-fetching patterns. | Cursor built-in |
| 18 | **figma** | Figma design context, variables, design-to-code. | Codex curated (figma, figma-implement-design); Figma plugin |
| 19 | **vercel-react-native-skills** | React Native / Expo best practices (lists, animations, native modules). | Cursor built-in. Use for RN on iOS/Android; pair with Apple Doc + XcodeBuild MCPs for native iOS. |
| 20 | **transcribe** | Audio/video to text; optional diarization and speaker labels. | Codex curated |
| 21 | **speech** | Text-to-speech (narration, accessibility, batch). | Codex curated |

**Other often-mentioned:** gh-address-comments, gh-fix-ci (GitHub workflow); develop-web-game (Playwright + game dev); jupyter-notebook; notion-* (Notion integration); linear (Linear issues); sentry (errors); sora (video); screenshot (OS-level capture); yeet (experimental). **Discovery:** [skills.sh](https://skills.sh/) (leaderboard + installs), [openai/skills (.curated + .experimental)](https://github.com/openai/skills/tree/main/skills/.curated), [Killer-Skills](https://killer-skills.com/en/skills), [agentskill.sh](https://agentskill.sh/for/cursor), [Cursor skills docs](https://cursor.com/docs/context/skills).

### Top 250 from skills.sh (excluding Azure)

From the [skills.sh](https://skills.sh/) leaderboard by installs, with Azure-related skills filtered out. Install with `npx skills add <owner/repo>`. Re-check the site for current rankings. Ranks 179–250: fill from the current [skills.sh](https://skills.sh/) leaderboard (exclude Azure) when updating this doc.

- **Agent & automation**
  - agent-browser — `vercel-labs/agent-browser` — Browser automation
  - agent-tools — `inference-sh-9/skills` — Agent tooling
  - agent-ui — `inference-sh-9/skills` — Agent UI
  - agentation — `benjitaylor/agentation` — Agentation
  - brainstorming — `obra/superpowers` — Ideation workflows
  - browser-use — `browser-use/browser-use` — Browser automation
  - chat-ui — `inference-sh-9/skills` — Chat UI
  - dispatching-parallel-agents — `obra/superpowers` — Dispatch parallel agents
  - javascript-sdk — `inference-sh-9/skills` — JavaScript SDK
  - python-executor — `inference-sh-9/skills` — Python executor
  - python-sdk — `inference-sh-9/skills` — Python SDK
  - subagent-driven-development — `obra/superpowers` — Subagent workflows
  - tools-ui — `inference-sh-9/skills` — Tools UI
  - twitter-automation — `inference-sh-9/skills` — Twitter/X automation
  - using-superpowers — `obra/superpowers` — Use Superpowers
  - web-search — `inference-sh-9/skills` — Web search
  - widgets-ui — `inference-sh-9/skills` — Widgets UI

- **AI SDK**
  - ai-sdk — `vercel/ai` — Vercel AI SDK

- **Auth & security**
  - better-auth-best-practices — `better-auth/skills` — Auth best practices
  - create-auth-skill — `better-auth/skills` — Create auth skill
  - security-requirement-extraction — `wshobson/agents` — Security requirement extraction

- **Backend & API**
  - api-design-principles — `wshobson/agents` — API design principles
  - async-python-patterns — `wshobson/agents` — Async Python patterns
  - fastapi-templates — `wshobson/agents` — FastAPI templates
  - nestjs-best-practices — `kadajett/agent-nestjs-skills` — NestJS best practices
  - nodejs-backend-patterns — `wshobson/agents` — Node.js backend patterns

- **Code quality & review**
  - code-review-excellence — `wshobson/agents` — Code review excellence
  - finishing-a-development-branch — `obra/superpowers` — Finishing a dev branch
  - receiving-code-review — `obra/superpowers` — Receive code reviews
  - requesting-code-review — `obra/superpowers` — Request code reviews
  - systematic-debugging — `obra/superpowers` — Debugging workflows
  - verification-before-completion — `obra/superpowers` — Verify before completion

- **Content & docs**
  - doc-coauthoring — `anthropics/skills` — Doc coauthoring
  - docx — `anthropics/skills` — Word docs
  - internal-comms — `anthropics/skills` — Internal comms
  - pdf — `anthropics/skills` — PDF operations
  - pptx — `anthropics/skills` — PowerPoint
  - web-artifacts-builder — `anthropics/skills` — Web artifacts builder
  - xlsx — `anthropics/skills` — Excel / spreadsheets

- **Data & database**
  - convex — `waynesutton/convexskills` — Convex
  - postgresql-table-design — `wshobson/agents` — PostgreSQL table design
  - sql-optimization-patterns — `wshobson/agents` — SQL optimization patterns
  - supabase-postgres-best-practices — `supabase/agent-skills` — Supabase / Postgres

- **Design & UI**
  - brand-guidelines — `anthropics/skills` — Brand guidelines
  - canvas-design — `anthropics/skills` — Canvas design
  - design-md — `google-labs-code/stitch-skills` — Design MD
  - frontend-design — `anthropics/skills` — Production-grade UI
  - frontend-design — `anthropics/claude-code` — Frontend design (Claude Code)
  - interface-design — `dammyjay93/interface-design` — Interface design
  - responsive-design — `wshobson/agents` — Responsive design
  - shadcn-ui — `giuseppe-trisciuoglio/developer-kit` — shadcn/ui
  - shadcn-ui — `google-labs-code/stitch-skills` — shadcn/ui (Stitch)
  - tailwind-design-system — `wshobson/agents` — Tailwind design system
  - theme-factory — `anthropics/skills` — Theme factory
  - ui-ux-pro-max — `nextlevelbuilder/ui-ux-pro-max-skill` — UI/UX
  - web-design-guidelines — `vercel-labs/agent-skills` — UI, accessibility, UX audit
  - web-design-guidelines — `antfu/skills` — Web design guidelines (antfu)

- **DevOps & tooling**
  - docker-expert — `sickn33/antigravity-awesome-skills` — Docker expert
  - firecrawl — `firecrawl/cli` — Firecrawl
  - git-commit — `github/awesome-copilot` — Git commit
  - github-actions-templates — `wshobson/agents` — GitHub Actions templates

- **Discovery & skills creation**
  - find-skills — `vercel-labs/skills` — Discover and add skills
  - mcp-builder — `anthropics/skills` — Build MCP servers
  - skill-creator — `anthropics/skills` — Write new skills
  - skill-creator — `vercel-labs/agent-browser` — Skill creator (agent-browser)
  - template-skill — `anthropics/skills` — Template skill
  - writing-skills — `obra/superpowers` — Write skills

- **Image, video & media**
  - ai-image-generation — `inference-sh-9/skills` — Image generation
  - ai-video-generation — `inference-sh-9/skills` — Video generation
  - algorithmic-art — `anthropics/skills` — Algorithmic art
  - nano-banana — `inference-sh-9/skills` — Image gen (e.g. nanana.app)
  - nano-banana-2 — `inference-sh-9/skills` — Image gen variant
  - remotion — `google-labs-code/stitch-skills` — Remotion (Stitch)
  - remotion-best-practices — `remotion-dev/skills` — Remotion video
  - remotion-render — `inference-sh-9/skills` — Remotion rendering

- **Marketing & SEO**
  - ab-test-setup — `coreyhaines31/marketingskills` — A/B test setup
  - analytics-tracking — `coreyhaines31/marketingskills` — Analytics tracking
  - audit-website — `squirrelscan/skills` — Website audit
  - backlink-analyzer — `aaron-he-zhu/seo-geo-claude-skills` — Backlink analyzer
  - competitor-alternatives — `coreyhaines31/marketingskills` — Competitor alternatives
  - content-strategy — `coreyhaines31/marketingskills` — Content strategy
  - copy-editing — `coreyhaines31/marketingskills` — Copy editing
  - copywriting — `coreyhaines31/marketingskills` — Copywriting
  - email-sequence — `coreyhaines31/marketingskills` — Email sequence
  - form-cro — `coreyhaines31/marketingskills` — Form CRO
  - free-tool-strategy — `coreyhaines31/marketingskills` — Free tool strategy
  - launch-strategy — `coreyhaines31/marketingskills` — Launch strategy
  - marketing-ideas — `coreyhaines31/marketingskills` — Marketing ideas
  - marketing-psychology — `coreyhaines31/marketingskills` — Marketing psychology
  - onboarding-cro — `coreyhaines31/marketingskills` — Onboarding CRO
  - paid-ads — `coreyhaines31/marketingskills` — Paid ads
  - page-cro — `coreyhaines31/marketingskills` — Page CRO
  - paywall-upgrade-cro — `coreyhaines31/marketingskills` — Paywall upgrade CRO
  - popup-cro — `coreyhaines31/marketingskills` — Popup CRO
  - pricing-strategy — `coreyhaines31/marketingskills` — Pricing strategy
  - product-marketing-context — `coreyhaines31/marketingskills` — Product marketing
  - programmatic-seo — `coreyhaines31/marketingskills` — Programmatic SEO
  - referral-program — `coreyhaines31/marketingskills` — Referral program
  - schema-markup — `coreyhaines31/marketingskills` — Schema markup
  - seo-audit — `coreyhaines31/marketingskills` — SEO audit
  - seo-geo — `resciencelab/opc-skills` — SEO / GEO
  - signup-flow-cro — `coreyhaines31/marketingskills` — Signup flow CRO
  - social-content — `coreyhaines31/marketingskills` — Social content

- **Mobile & Expo**
  - building-native-ui — `expo/skills` — Native UI (Expo)
  - expo-api-routes — `expo/skills` — Expo API routes
  - expo-cicd-workflows — `expo/skills` — Expo CI/CD workflows
  - expo-dev-client — `expo/skills` — Expo dev client
  - expo-deployment — `expo/skills` — Expo deployment
  - expo-tailwind-setup — `expo/skills` — Expo Tailwind setup
  - flutter-animations — `madteacher/mad-agents-skills` — Flutter animations
  - mobile-android-design — `wshobson/agents` — Mobile Android design
  - mobile-ios-design — `wshobson/agents` — Mobile iOS design
  - native-data-fetching — `expo/skills` — Native data fetching (Expo)
  - react-native-best-practices — `callstackincubator/agent-skills` — React Native best practices
  - upgrading-expo — `expo/skills` — Upgrading Expo
  - use-dom — `expo/skills` — Use DOM (Expo)
  - vercel-react-native-skills — `vercel-labs/agent-skills` — React Native / Expo

- **Planning & workflow**
  - executing-plans — `obra/superpowers` — Plan execution
  - planning-with-files — `othmanadi/planning-with-files` — Planning with files
  - using-git-worktrees — `obra/superpowers` — Git worktrees
  - writing-plans — `obra/superpowers` — Planning

- **Platform / Baoyu / other**
  - baoyu-article-illustrator — `jimliu/baoyu-skills` — Baoyu article illustrator
  - baoyu-compress-image — `jimliu/baoyu-skills` — Baoyu compress image
  - baoyu-cover-image — `jimliu/baoyu-skills` — Baoyu cover image
  - baoyu-danger-gemini-web — `jimliu/baoyu-skills` — Baoyu Gemini web
  - baoyu-danger-x-to-markdown — `jimliu/baoyu-skills` — Baoyu X to Markdown
  - baoyu-image-gen — `jimliu/baoyu-skills` — Baoyu image gen
  - baoyu-infographic — `jimliu/baoyu-skills` — Baoyu infographic
  - baoyu-comic — `jimliu/baoyu-skills` — Baoyu comic
  - baoyu-post-to-wechat — `jimliu/baoyu-skills` — Baoyu post to WeChat
  - baoyu-post-to-x — `jimliu/baoyu-skills` — Baoyu post to X
  - baoyu-slide-deck — `jimliu/baoyu-skills` — Baoyu slide deck
  - baoyu-url-to-markdown — `jimliu/baoyu-skills` — Baoyu URL to Markdown
  - baoyu-xhs-images — `jimliu/baoyu-skills` — Baoyu XHS images
  - clawdirect — `napoleond/clawdirect` — Clawdirect
  - clawdirect-dev — `napoleond/clawdirect` — Clawdirect dev
  - enhance-prompt — `google-labs-code/stitch-skills` — Enhance prompt
  - humanizer-zh — `op7418/humanizer-zh` — Humanizer ZH
  - instaclaw — `napoleond/instaclaw` — Instaclaw
  - mastra — `mastra-ai/skills` — Mastra
  - nblm — `magicseek/nblm` — NotebookLM (magicseek)
  - release-skills — `jimliu/baoyu-skills` — Release skills
  - remembering-conversations — `obra/episodic-memory` — Remembering conversations
  - seedance2-api — `hexiaochun/seedance2-api` — Seedance2 API
  - slack-gif-creator — `anthropics/skills` — Slack GIF creator
  - stitch-loop — `google-labs-code/stitch-skills` — Stitch loop

- **Python & Go**
  - golang-pro — `jeffallan/claude-skills` — Golang pro
  - python-performance-optimization — `wshobson/agents` — Python performance

- **React / Next**
  - next-best-practices — `vercel-labs/next-skills` — Next.js
  - next-cache-components — `vercel-labs/next-skills` — Next.js cache components
  - next-upgrade — `vercel-labs/next-skills` — Next.js upgrade
  - nextjs-app-router-patterns — `wshobson/agents` — Next.js App Router patterns
  - react:components — `google-labs-code/stitch-skills` — React components
  - react-doctor — `millionco/react-doctor` — React Doctor
  - vercel-composition-patterns — `vercel-labs/agent-skills` — React composition
  - vercel-react-best-practices — `vercel-labs/agent-skills` — React/Next.js patterns

- **Swift / native**
  - swiftui-expert-skill — `avdlee/swiftui-agent-skill` — SwiftUI expert

- **Testing & QA**
  - e2e-testing-patterns — `wshobson/agents` — E2E testing patterns
  - python-testing-patterns — `wshobson/agents` — Python testing patterns
  - test-driven-development — `obra/superpowers` — TDD workflows
  - webapp-testing — `anthropics/skills` — Web app testing

- **TypeScript & patterns**
  - architecture-patterns — `wshobson/agents` — Architecture patterns
  - error-handling-patterns — `wshobson/agents` — Error handling patterns
  - prompt-engineering-patterns — `wshobson/agents` — Prompt engineering patterns
  - typescript-advanced-types — `wshobson/agents` — TypeScript advanced types

- **Vue / Vite / build**
  - antfu — `antfu/skills` — Antfu
  - nuxt — `antfu/skills` — Nuxt
  - pnpm — `antfu/skills` — pnpm
  - pinia — `antfu/skills` — Pinia
  - turborepo — `vercel/turborepo` — Turborepo
  - vue — `antfu/skills` — Vue
  - vue-best-practices — `hyf0/vue-skills` — Vue best practices
  - vue-best-practices — `antfu/skills` — Vue best practices (antfu)
  - vue-debug-guides — `hyf0/vue-skills` — Vue debug guides
  - vueuse-functions — `antfu/skills` — VueUse functions
  - vite — `antfu/skills` — Vite
  - vitepress — `antfu/skills` — VitePress
  - vitest — `antfu/skills` — Vitest

- **Ranks 179–250**  
  *(See [skills.sh](https://skills.sh/) leaderboard; exclude Azure when filling this doc.)*

---

## Recommended skill categories (reference)

Use this as a “what to add next” checklist. Exact names and paths depend on your install (Cursor vs Codex).

| Category | Purpose | Typical location / source |
|----------|---------|----------------------------|
| **Create skill** | Guide for writing new skills (structure, description, triggers) | Cursor: `create-skill`; Codex: skill-creator |
| **Create rule** | Guide for adding Cursor rules (conventions, RULE.md) | Cursor: `create-rule` |
| **Security** | Security review, threat modeling, ownership maps | Codex: security-best-practices, security-threat-model, security-ownership-map |
| **Deploy** | Vercel, Netlify, Cloudflare, Render | Codex / plugins: vercel-deploy, netlify-deploy, cloudflare-deploy, render-deploy |
| **Frontend / design** | UI guidelines, composition patterns, React best practices | Cursor: vercel-react-best-practices, vercel-composition-patterns; frontend-design (plugin) |
| **Docs & media** | PDF, docx, spreadsheet, image gen, speech, transcribe | Codex: pdf, doc, spreadsheet, imagegen, speech, transcribe |
| **Testing & automation** | Playwright, web game dev | Codex: playwright, develop-web-game |
| **Platform-specific** | React Native, Stripe, Firebase, Supabase, Figma | Cursor/Codex: vercel-react-native-skills; plugins: Stripe, Figma, etc. |
| **Apple / iOS development** | Swift, SwiftUI, UIKit, Objective-C, React Native on iOS | See § “Apple / iOS development” below. |

**Discovery:** In Cursor, built-in and personal skills appear in the skills list. For Codex, use the skill-installer skill to list and install from [openai/skills](https://github.com/openai/skills) (curated and experimental).

---

## Skills by topic (curated)

Quick reference for **UI/visual design, image generation, cybersecurity/code review, and deployment**. Use this when you want skills (and related MCPs) for a specific kind of work.

### UI design, visual design, image generation, Nano Banana

| Item | Type | Purpose | Source / config |
|------|------|---------|-----------------|
| **frontend-design** | Skill | Production-grade UI: spacing, color, responsive layout; avoids generic AI aesthetics. | Cursor/plugin; Codex curated; Killer-Skills; agentskill.sh |
| **web-design-guidelines** | Skill | Review UI for Web Interface Guidelines, accessibility, UX audit. | Cursor/Codex; use when asked to “review my UI”, “check accessibility”, “audit design”. |
| **vercel-react-best-practices** | Skill | React/Next.js performance, data-fetching, component patterns. | Cursor built-in |
| **vercel-composition-patterns** | Skill | React composition (compound components, render props, flexible APIs). | Cursor built-in |
| **figma** | Skill | Figma design context, variables, design-to-code. | Codex curated; Figma plugin |
| **imagegen** | Skill | Generate/edit images via OpenAI Image API (DALL·E); workflow and usage. | Codex curated |
| **Nano Banana (Pro)** | MCP | Image generation via [nanana.app](https://nanana.app): `text_to_image`, `image_to_image`. | MCP: [05-mcp-and-config-setup.md §2c](05-mcp-and-config-setup.md). NPM: `@nanana-ai/mcp-server-nano-banana`; needs `NANANA_API_TOKEN`. |

**Note:** Nano Banana is an **MCP** (tool), not a skill. Pair it with **imagegen** (skill) if you want the agent to know when and how to use image generation in prompts. For “Nano Banana Pro” or nanana.app plans, use the same MCP; config is in the MCP setup doc.

### Cybersecurity, secure code, code reviews

| Item | Type | Purpose | Source / config |
|------|------|---------|-----------------|
| **security-best-practices** | Skill | Language/framework security review; secure-by-default guidance. | Codex curated |
| **security-threat-model** | Skill | Repository threat model: trust boundaries, assets, abuse paths, mitigations. | Codex curated |
| **security-ownership-map** | Skill | Git-based ownership and bus factor; CODEOWNERS; sensitive-code hotspots. | Codex curated |
| **create-rule** | Skill | Add Cursor rules (conventions, RULE.md). Use for project-specific “code review” or security rules. | Cursor built-in |

Use **security-best-practices** for day-to-day secure coding; **security-threat-model** when designing or reviewing architecture; **security-ownership-map** when auditing who owns what. For formal code-review workflows, add a **custom skill** (create-skill) that describes your review checklist and when to apply it.

### Deployment

| Item | Type | Purpose | Source / config |
|------|------|---------|-----------------|
| **vercel-deploy** | Skill | Deploy to Vercel (preview, production, logs). | Codex curated; Vercel plugin |
| **netlify-deploy** | Skill | Deploy and manage sites on Netlify via CLI. | Codex curated |
| **cloudflare-deploy** | Skill | Deploy to Cloudflare (Workers, Pages, infra). | Codex curated |
| **render-deploy** | Skill | Deploy to Render (render.yaml, dashboard). | Codex curated |

MCPs for deployment (e.g. Vercel MCP for logs/projects) are in [05-mcp-and-config-setup.md](05-mcp-and-config-setup.md). Skills cover the *workflow* (how to deploy, when to use which platform); MCPs add *tools* (list deployments, fetch logs).

### Skills by technology / platform

Mapping of **specific technologies and platforms** to skills (and MCPs where relevant). Install skills via `npx skills add <owner/repo>`; search [skills.sh](https://skills.sh/) for the latest. Sources: [skills.sh](https://skills.sh/) leaderboard and [05-mcp-and-config-setup.md](05-mcp-and-config-setup.md) for MCPs.

| Topic | Skill(s) | Repo(s) | MCP / notes |
|-------|----------|---------|-------------|
| **AI SDK (Vercel)** | ai-sdk | vercel/ai | Use **Context7** MCP for current sdk.vercel.ai docs. |
| **Code review** | code-review-excellence, requesting-code-review, receiving-code-review | wshobson/agents, obra/superpowers | Optional: code-review-ai-ai-review (sickn33/antigravity-awesome-skills). |
| **Codex (agent)** | codex | ubie-inc/agent-skills | JetBrains AI / Codex integration; parallel tasks, refactoring. Search skills.sh for “codex”. |
| **Dart** | — | — | **Dart MCP** (official `dart mcp-server`) for format, test, pub, docs; see [05 §2d](05-mcp-and-config-setup.md). |
| **FastAPI** | fastapi-templates | wshobson/agents | Python async patterns; wshobson/agents also has async-python-patterns. |
| **Flutter** | flutter-animations | madteacher/mad-agents-skills | Check skills.sh for other Flutter/Dart skills. |
| **Gemini / Gemini API** | — | — | **Google Developer Knowledge** MCP for Gemini/ai.google.dev docs; see [05 §2](05-mcp-and-config-setup.md). |
| **Go / Golang** | golang-pro | jeffallan/claude-skills | Check skills.sh for more. |
| **Google Veo** | — | — | Search [skills.sh](https://skills.sh/) for “veo”; use API/docs for video generation. |
| **Langchain** | — | — | Search [skills.sh](https://skills.sh/) for “langchain” or “langchainjs”. |
| **Meme** | — | — | Search [skills.sh](https://skills.sh/) for “meme”; image-gen skills (e.g. ai-image-generation) can be repurposed. |
| **NotebookLM** | notebooklm, nblm | alfredang/skills, pleaseprompto/notebooklm-skill, magicseek/nblm | Google NotebookLM: research, slides, infographics, source-grounded Q&A; nblm for podcasts, briefings, debates. May require Google OAuth. |
| **npm** | — | — | No dedicated skill; use **Context7** MCP for Node/npm docs. |
| **Obsidian** | — | — | Search [skills.sh](https://skills.sh/) for “obsidian”; none in top list. |
| **OpenClaw** | clawdirect, instaclaw | napoleond/clawdirect, napoleond/instaclaw | Claw-related; search skills.sh for “claw” or “openclaw”. |
| **Podcast** | transcribe, speech | anthropics/skills; Codex curated | **transcribe** for audio→text, **speech** for TTS; search skills.sh for “podcast” for show-specific skills. |
| **QA and testing** | webapp-testing, qa-testing-mobile, vitest, e2e-testing-patterns, test-driven-development | anthropics/skills, vasilyu1983/ai-agents-public, antfu/skills, wshobson/agents, obra/superpowers | qa-testing-mobile: mobile iOS/Android test strategy; vitest for unit tests. |
| **RAG implementation** | — | — | Search [skills.sh](https://skills.sh/) for “RAG” or “retrieval”; Context7 for vector/embedding docs. |
| **React Native** | vercel-react-native-skills, building-native-ui, react-native-best-practices | vercel-labs/agent-skills, expo/skills, callstackincubator/agent-skills | In Top 50; pair with Apple Doc + XcodeBuild MCPs for iOS. |
| **Rust** | — | — | Search [skills.sh](https://skills.sh/) for “rust”; none in top list. |
| **Seedance** | seedance2-api | hexiaochun/seedance2-api | In Top 50 table above. |
| **SEO / GEO** | seo-audit, seo-geo, seo-geo-skills, programmatic-seo, schema-markup | coreyhaines31/marketingskills, resciencelab/opc-skills, founderjourney/claude-skills, wshobson/agents | GEO = AI search (e.g. ChatGPT, Perplexity); SEO + GEO content and audits. |
| **shadcn/ui** | shadcn-ui | giuseppe-trisciuoglio/developer-kit, google-labs-code/stitch-skills | Tailwind v4 + shadcn: ovachiever/droid-tings (tailwind-v4-shadcn). |
| **Stripe** | stripe-best-practices, upgrade-stripe, stripe-integration | stripe/ai, wshobson/agents | Payments, checkout, webhooks; stripe/ai has multiple skills. |
| **Swift / SwiftUI** | swiftui-expert-skill | avdlee/swiftui-agent-skill | **Apple Doc MCP**, **XcodeBuild MCP** for docs/build; see [05 §2e](05-mcp-and-config-setup.md). |
| **Tailwind** | tailwind-design-system | wshobson/agents | Tailwind v4 + shadcn: search “tailwind” on skills.sh. |
| **Tauri** | tauri-v2 | nodnarbnitram/claude-code-extensions | Tauri v2 desktop/mobile (Rust + webview): commands, frontend–backend IPC, permissions. |
| **Text to speech** | speech | Codex curated; anthropics/skills | Narration, accessibility, batch TTS; in Top 20. |
| **Theme / themes** | theme-factory | anthropics/skills | Theming and design tokens. |
| **Three.js** | — | — | Search [skills.sh](https://skills.sh/) for “three” or “threejs”; none in top list. |
| **Twitter thread creation** | twitter-automation | inference-sh-9/skills | In Top 50; thread and X/Twitter automation. |
| **Vite** | vite, vitest | antfu/skills | Build and test; antfu/skills has vue, pnpm, nuxt too. |
| **YouTube thumbnail design** | youtube-thumbnail, youtube-thumbnail-design | kenneth-liao/ai-launchpad-marketplace, 1nf-sh/skills | High-CTR thumbnails; specs (e.g. 1920×1080, 16:9). Search skills.sh for “youtube”. |
| **YouTube / YouTube API** | — | — | **YouTube MCP** for video/channel/transcripts; see [05 §2c](05-mcp-and-config-setup.md). |

**Quick install examples:** `npx skills add vercel/ai` (ai-sdk), `npx skills add antfu/skills` (vite, vitest), `npx skills add stripe/ai` (Stripe), `npx skills add wshobson/agents` (code-review-excellence, tailwind-design-system, fastapi-templates, stripe-integration, e2e-testing-patterns), `npx skills add resciencelab/opc-skills` (seo-geo), `npx skills add vasilyu1983/ai-agents-public` (qa-testing-mobile).

### This project: Vite + React + Gemini + image gen

For **Info-Visualizer-style** development (Vite, React, TypeScript, Express backend, Gemini/Google AI, image generation, optional Electron desktop), these MCPs and skills are especially relevant.

| Item | Type | Why it fits this project | Source / config |
|------|------|---------------------------|-----------------|
| **Google Developer Knowledge** | MCP | Gemini API, ai.google.dev, and Google dev docs. Use for API usage, models, and SDK questions. | [05 §2](05-mcp-and-config-setup.md) |
| **Context7** | MCP | Up-to-date docs for Vite, React, @ai-sdk/google, and other SDKs. Use when you need current API or migration guidance. | [05 §3–4](05-mcp-and-config-setup.md) |
| **Nano Banana** | MCP | Image generation (e.g. nanana.app). Use if the app uses or may use external image-gen APIs alongside Gemini. | [05 §2c](05-mcp-and-config-setup.md) |
| **Fetch** | MCP | Fetch and convert web content for the agent. Useful for research or link-preview features. | [05 Top 20](05-mcp-and-config-setup.md) |
| **vercel-react-best-practices** | Skill | React (including React 19) performance, data-fetching, and component patterns. Applies to the Vite + React frontend. | Cursor built-in |
| **vercel-composition-patterns** | Skill | React composition (compound components, flexible APIs). Fits component-heavy UIs (menus, panels, toggles). | Cursor built-in |
| **frontend-design** | Skill | UI quality and consistency; avoids generic AI look. Fits research/studio UIs. | Cursor/Codex |
| **imagegen** | Skill | Workflow for image generation in prompts. Use when adding or refining image-gen features. | Codex curated |
| **security-best-practices** | Skill | API keys, env vars, backend security. Important for Express proxy and Gemini/key handling. | Codex curated |
| **vercel-deploy** | Skill | If you deploy the app (e.g. Vite build to Vercel). | Codex / Vercel plugin |

**Stack summary:** Frontend (Vite, React, TS) → **vercel-react-best-practices**, **vercel-composition-patterns**, **frontend-design**. Backend (Express, Gemini proxy) → **Google Developer Knowledge** MCP, **Context7** MCP, **security-best-practices**. Image gen → **imagegen** skill, **Nano Banana** MCP (if used). Deployment → **vercel-deploy** (or other deploy skills) and optional Vercel MCP.

### TypeScript, Vercel AI SDK, Agent SDK

For **TypeScript**, **Vercel AI SDK** (@ai-sdk/google, `ai` package, `streamText` / `generateText`), and **Agent SDK** (OpenAI Agents SDK or agent-style patterns), use these MCPs and skills:

| Topic | Item | Type | Why | Source |
|-------|------|------|-----|--------|
| **TypeScript** | **Context7** | MCP | Up-to-date TypeScript and TS-related SDK docs. Use for types, config, and migration (e.g. TS 5.x, strict mode). | [05 §3–4](05-mcp-and-config-setup.md) |
| **Vercel AI SDK** | **Context7** | MCP | Current [sdk.vercel.ai](https://sdk.vercel.ai) docs: `streamText`, `generateText`, providers (@ai-sdk/google), useChat, tools, MCP client (`createMCPClient`). Use for API shape, React hooks, and backend integration. | Same |
| **Vercel AI SDK** | **Google Developer Knowledge** | MCP | Gemini-specific usage and model behavior when using @ai-sdk/google with the AI SDK. | [05 §2](05-mcp-and-config-setup.md) |
| **Agent SDK (OpenAI)** | **openai-docs** | Skill | Official OpenAI docs for Agents SDK, Assistants API, and agent patterns. Use when building or referencing OpenAI-based agents. | Codex curated |
| **Agent-style patterns** | **Context7** | MCP | Vercel AI SDK patterns for tools, multi-step flows, and MCP integration (e.g. `createMCPClient` in Node or Next.js). | [05 §3–4](05-mcp-and-config-setup.md) |

**Notes:** There is no dedicated “TypeScript MCP” or “Vercel AI SDK MCP”; **Context7** is the main way to get current docs for TypeScript and the Vercel AI SDK. For **OpenAI Agents SDK** (or other OpenAI agent APIs), use the **openai-docs** skill. The Vercel AI SDK also supports *using* MCP inside your app via `createMCPClient()` — that’s app code, not an MCP you add to Cursor; config for Cursor MCPs is in [05-mcp-and-config-setup.md](05-mcp-and-config-setup.md).

---

## Apple / iOS development: skills vs MCPs

For **Swift, SwiftUI, UIKit, Objective-C, and React Native on iOS**, some capabilities are best set up as **skills** (workflow and when to use what) and others as **MCPs** (tools the agent can call). Use both together.

### Best as skills (workflow and context)

| Item | Purpose | Where / how |
|------|---------|-------------|
| **vercel-react-native-skills** | React Native and Expo best practices: lists, animations, native modules, performance. | Cursor built-in skill. Use when working on React Native (including iOS). |
| **frontend-design** | UI/layout guidance (spacing, color, responsive). | Codex/plugins. Helps with SwiftUI/UIKit UI decisions. |
| **Custom “Apple dev” skill (optional)** | Instructs the agent to use Apple Doc MCP for API/symbol lookups and XcodeBuild (or xcode-tools) for builds/simulators when the user is working in Swift, SwiftUI, UIKit, or Objective-C. | Create via create-skill; store in `~/.cursor/skills/apple-dev/` or project `.cursor/skills/`. Include trigger terms: Swift, SwiftUI, UIKit, Objective-C, Xcode, iOS. |

Skills don’t add new tools; they tell the agent *when* and *how* to use the MCPs and frameworks above.

### Best as MCPs (tools)

| MCP | Purpose | Config |
|-----|---------|--------|
| **Apple Doc MCP** | Search Apple Developer docs and fetch symbol/documentation. | See [05-mcp-and-config-setup.md §2e](05-mcp-and-config-setup.md). NPM: `apple-doc-mcp-server@latest`. |
| **XcodeBuild MCP** | Build, run, simulators, devices, SPM, project discovery, logs. | Same doc §2e. NPM: `xcodebuildmcp@latest`; **args must include `"mcp"`**. |
| **Xcode 26.3+ native** | Apple’s built-in Xcode MCP tools via `xcrun mcpbridge`. | Optional; see 05 doc. Use if you prefer Apple’s official tools. |

MCP config (command, args, env) is in [05-mcp-and-config-setup.md](05-mcp-and-config-setup.md); this section only describes which Apple/iOS capabilities are best as skills vs MCPs.

### Summary

- **“How does this Apple API work?” / “What’s the docs for …?”** → Use **Apple Doc MCP** (and a skill that reminds the agent to use it for Swift/UIKit/SwiftUI/Obj-C).
- **“Build, run, simulators, device”** → Use **XcodeBuild MCP** or **Xcode 26.3 mcpbridge**.
- **React Native on iOS** → Use **vercel-react-native-skills** (skill) plus the MCPs above for native/Xcode tasks.

---

## 1. Workflow-Scripts sync

- [ ] Sync Workflow-Scripts from remote (e.g. `beta` branch).
- [ ] From project root: `./Workflow-Scripts/pull-workflows.sh`  
  **Or** from inside: `cd Workflow-Scripts && git pull --ff-only`.
- [ ] If this repo or Workflow-Scripts includes project skills (e.g. in `.cursor/skills/` or docs that reference skills), confirm they’re present after sync.

---

## 2. Cursor: Personal skills

**Location:** `~/.cursor/skills/`

- [ ] Ensure directory exists: `mkdir -p ~/.cursor/skills`.
- [ ] Each skill is a **directory** with a `SKILL.md` file, e.g. `~/.cursor/skills/my-workflow/SKILL.md`.
- [ ] **SKILL.md** must have YAML frontmatter with `name` and `description`; the description is used to decide when to apply the skill (include trigger terms).
- [ ] To **add** a skill: create a folder and add `SKILL.md` (and any optional `reference.md`, `examples.md`, or `scripts/`). See §5 for structure.
- [ ] To **remove** a skill: delete the skill directory under `~/.cursor/skills/`.
- [ ] Restart Cursor after adding or removing skills so the agent picks them up.

---

## 3. Cursor: Project skills

**Location:** `<project-root>/.cursor/skills/`

- [ ] If the project uses shared skills, ensure `.cursor/skills/` exists and each skill has a `SKILL.md` (same structure as personal skills).
- [ ] Project skills are versioned with the repo; everyone who clones the repo gets them.
- [ ] Prefer **project** skills for team-wide workflows (e.g. commit format, changelog, code review). Use **personal** skills for your own preferences (e.g. note-taking, personal deploy habits).
- [ ] Restart Cursor or open the project again after pulling new project skills.

---

## 4. Codex: Install and manage skills

**Location:** `$CODEX_HOME/skills/` (default `~/.codex/skills/`)

Codex has a **skill-installer** skill and optional **skill-creator**. Use the installer to add curated or experimental skills from GitHub.

- [ ] Ensure Codex is set up and `$CODEX_HOME` is set (default `~/.codex`).
- [ ] **List installable skills:** Use the skill-installer (e.g. “list installable skills” or “what skills can I install?”). Default list is from `openai/skills` `.curated`; experimental: `--path skills/.experimental`.
- [ ] **Install a skill:** Use skill-installer with the skill name, or install from another repo/path (see skill-installer docs). Scripts: `scripts/list-skills.py`, `scripts/install-skill-from-github.py`.
- [ ] **Manual install:** Copy a skill directory into `$CODEX_HOME/skills/<skill-name>/` with a valid `SKILL.md`.
- [ ] **After installing:** Restart Codex so new skills are loaded.
- [ ] **Note:** Skills under `$CODEX_HOME/skills/.system/` are preinstalled; no need to install those manually.

---

## 5. Creating a new skill (Cursor / general)

Use the **create-skill** skill in Cursor for step-by-step guidance, or follow this structure:

### 5.1 Directory layout

The only required component is `SKILL.md`. Everything else is optional and supports progressive disclosure (agent loads full content only when needed).

```
skill-name/
├── SKILL.md              # Required – main instructions + frontmatter
├── reference.md          # Optional – detailed reference (or use references/ for multiple files)
├── examples.md           # Optional – usage examples
├── scripts/              # Optional – executable helpers (deterministic, auditable steps)
├── references/           # Optional – supporting docs loaded on demand; avoid duplicating SKILL.md here
└── assets/               # Optional – templates, examples, or other artifacts
```

**Best practices:** Put long reference material in `reference.md` or `references/`; do not duplicate the same information in both `SKILL.md` and references. For long reference files, include grep search patterns in `SKILL.md` so the agent can locate the right section quickly. Use `scripts/` for steps that must run the same way every time (more token-efficient and auditable than prose). ([Vercel FAQ](https://vercel.com/blog/agent-skills-explained-an-faq))

### 5.2 SKILL.md requirements

- **Frontmatter (required):** `name` (1–64 chars, lowercase letters and numbers, single hyphens; must match directory name; regex `^[a-z0-9]+(-[a-z0-9]+)*$`), `description` (1–1024 chars, non-empty).
- **Frontmatter (optional):** `license`, `compatibility` (max 500 chars), `metadata` (key-value), `allowed-tools`. Unknown fields are ignored (forward compatible).
- **Description:** Write in **third person**; include both **what** the skill does and **when** to use it (trigger terms) so the agent can discover it.
- **Body:** Clear steps, checklists, or templates. Keep under ~500 lines; put long reference material in `reference.md`, `examples.md`, or `references/`.

### 5.3 Quality checklist

- [ ] Description is specific and includes trigger terms.
- [ ] Description is in third person (e.g. “Processes Excel files…” not “I can help you…”).
- [ ] File references from SKILL.md are at most one level deep (e.g. link to `reference.md`, not nested folders).
- [ ] No Windows-style paths (use `/` not `\`).
- [ ] Consistent terminology throughout.
- [ ] No duplicate content between `SKILL.md` and `references/` or `reference.md`.

See Cursor’s **create-skill** skill for the full workflow (discovery → design → implementation → verification).

---

## 6. Optional: Plugin and framework skills

Some tools add skills when you run a one-off command in a project:

- **Remotion:** In a Remotion project, `npx remotion skills add` can add Agent Skills (e.g. into `.claude/skills` or project-specific path) for Cursor/Claude Code/Codex.
- **Other plugins:** If you use Claude Code plugins (e.g. Vercel, Stripe, plugin-dev), they may ship skills under the plugin directory; no separate “skills setup” step beyond installing the plugin.

Check the framework or plugin docs for “skills” or “agent skills” to see if a similar step is needed.

---

## 7. Verification

- [ ] **Cursor:** Open a project; start a chat and describe a task that should trigger a skill (e.g. “help me write a commit message” for a commit-message skill). Confirm the agent’s behavior or reply reflects the skill (e.g. uses your format or checklist).
- [ ] **Cursor:** In Cursor settings or skills UI (if visible), confirm personal and project skills are listed and enabled.
- [ ] **Codex:** After installing a skill, ask Codex to do something that matches the skill’s description; confirm it applies the skill. Run `scripts/list-skills.py` and check that the new skill is listed as installed.
- [ ] **Both:** Ensure no skills are under `~/.cursor/skills-cursor/` (reserved). Personal/project skills only in `~/.cursor/skills/` and `<project>/.cursor/skills/`.
- [ ] **New skills:** When adding skills, check [skills.sh](https://skills.sh/) for the latest leaderboard and install command (`npx skills add <owner/repo>`).

---

## Reference: Config and skill paths

| Tool / scope | Path | Purpose |
|--------------|------|---------|
| Cursor personal | `~/.cursor/skills/<skill-name>/` | Your own skills, all projects |
| Cursor project | `<project>/.cursor/skills/<skill-name>/` | Repo-shared skills |
| Cursor built-in | `~/.cursor/skills-cursor/` | **Do not edit** – managed by Cursor |
| Codex | `$CODEX_HOME/skills/<skill-name>/` | Codex skills (install via skill-installer or copy) |
| Kilo Code CLI (user) | `~/.kilocode/skills/<skill-name>/` | User-level Kilo Code CLI skills |
| Kilo Code CLI (project) | `<project>/.kilocode/skills/<skill-name>/` | Project-level Kilo Code CLI skills |
| Gemini CLI (user) | `~/.gemini/skills/<skill-name>/` or `~/.agents/skills/<skill-name>/` | User-level Gemini CLI skills |
| Gemini CLI (workspace) | `<project>/.gemini/skills/<skill-name>/` or `<project>/.agents/skills/<skill-name>/` | Workspace-level Gemini CLI skills |
| Claude Code | Plugin dir, e.g. `.../skills/` | Skills bundled with plugins |

---

## Notes

- **Security:** Skills change how the agent behaves; they do not make the agent inherently trustworthy. If a skill package includes scripts, treat them like any other code: review what they do, pin versions where you can, and prefer packages designed to be auditable. ([Vercel FAQ](https://vercel.com/blog/agent-skills-explained-an-faq))
- **Skills** are markdown-based instructions that extend the agent’s behavior in specific situations; **MCP** adds tools. Use both: MCP for “what the agent can call,” skills for “how the agent should do X.”
- **Description is critical:** The agent uses the skill’s `description` to decide when to apply it. Include clear trigger phrases (e.g. “Use when the user asks for a code review”).
- **Cursor:** Full path to `npx`/scripts is rarely needed for skills (unlike MCP stdio servers); skills are just files on disk.
- **Codex:** Default install location is `~/.codex/skills`. Use the skill-installer skill to list and install from openai/skills curated or experimental lists; for private repos you may need `GITHUB_TOKEN` or `GH_TOKEN`.
- **Kilo Code CLI:** User skills: `~/.kilocode/skills/`; project: `.kilocode/skills/`. Mode-specific: `skills-{mode-slug}` (e.g. `skills-code`, `skills-architect`). See [Kilo Code – Skills](https://kilo.ai/docs/features/skills).
- **Gemini CLI:** User: `~/.gemini/skills/` or `~/.agents/skills/`; workspace: `.gemini/skills/` or `.agents/skills/`. Install with `gemini skills install <url-or-path>`; link with `gemini skills link <path>`. Precedence: workspace > user > extension. See [Gemini CLI – Agent Skills](https://geminicli.com/docs/cli/skills/).
- **Project vs personal:** Prefer project/workspace skills for team conventions (changelog, commits, review); use personal skills for individual workflow or tooling preferences.
- **Apple / iOS:** Use **skills** for workflow and context (e.g. vercel-react-native-skills, frontend-design, or a custom “use Apple Doc + XcodeBuild MCP for Swift/UIKit” skill). Use **MCPs** for the actual tools (Apple Doc MCP, XcodeBuild MCP, or Xcode 26.3+ `xcrun mcpbridge`). See the “Apple / iOS development” section above and [05-mcp-and-config-setup.md](05-mcp-and-config-setup.md).
- **By topic:** For UI/visual design, image gen (including Nano Banana), cybersecurity/code review, and deployment, see the “Skills by topic (curated)” section; it lists skills and any related MCPs (e.g. Nano Banana) with sources and config pointers.
- **Latest skills:** Check [skills.sh](https://skills.sh/) for current leaderboard, install counts, and install command (`npx skills add <owner/repo>`). The “Top 250 from skills.sh” table in this doc excludes Azure skills; re-check the site for updates. Ranks 179–250 in the table are a placeholder—fill from the current [skills.sh](https://skills.sh/) leaderboard (excluding Azure) when maintaining the doc.
- **Automated install (curated list):** For the long curated list (Top 20, Top 250), use the **manifest + lockfile + install script** scheme: one manifest lists repos (and optional path/ref), one script installs all into Cursor, Codex, Kilo Code CLI, and Gemini CLI, and a lockfile records installed SHAs. See § Automated install and version tracking.
- **Maintaining this doc:** When you add a skill → update the Topic list. When you add a new topic → search [skills.sh](https://skills.sh/) for top-ranking matching skills and add them to the Topic list and Skills by technology / platform table. See **Maintaining this doc** under the Topic list.

---

## Further reading

| Resource | Purpose |
|----------|---------|
| [Vercel: Agent skills explained (FAQ)](https://vercel.com/blog/agent-skills-explained-an-faq) | What skills are, how they compare to MCP/tools/rules, how to install and create them, best practices. |
| [Agent Skills (agentskills.io)](https://agentskills.io/) | Open standard for skills; adopted by many agent platforms. |
| [skills.sh](https://skills.sh/) | Discover and browse agent skills; leaderboard and install commands. |
| [npx skills](https://www.npmjs.com/package/skills) | CLI for the open agent skills ecosystem: `npx skills add <owner/repo>`. |
