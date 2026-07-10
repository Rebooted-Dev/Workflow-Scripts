---
id: mcp-and-config-setup
version: 2.0
category: setup
kind: workflow
triggers: ["mcp and config setup"]
requires: [verification-gates, security-baseline]
agents: [implementer, security-scanner]
prev: []
next: []
---

# MCP and Configuration Setup Task List

Checklist for configuring MCP (Model Context Protocol) servers and default model/provider in **Cursor** and **OpenCode**, including the Google Developer Knowledge (Gemini docs) MCP and GLM 5 default.

**When to use:** Setting up or fixing MCP servers in Cursor, adding OpenCode MCP/config, or switching default model to GLM 5 (or another provider) when oh-my-opencode overrides apply.

---

## Prerequisites (do this first)

Cursor and OpenCode run MCP servers with a **minimal PATH**, so stdio servers must use **full paths** to binaries. Resolve these once and use them everywhere in this doc (replace `{NPX_PATH}`, `{UVX_PATH}`, `{DART_PATH}` in the config snippets below).

| Variable      | How to get it | Example |
|---------------|----------------|---------|
| **NPX_PATH**  | `which npx` (in a terminal where Node works) | `/Users/you/.nvm/versions/node/v22.22.0/bin/npx` or `/opt/homebrew/bin/npx` |
| **UVX_PATH**  | `which uvx` | `/Users/you/.local/bin/uvx` or `/opt/homebrew/bin/uvx` |
| **DART_PATH** | Install Dart first (see below), then `which dart` | `/opt/homebrew/bin/dart` |

**PATH for env:** Use the directory that contains the binary, e.g. for npx use `{NPX_PATH}`’s directory + `:/usr/bin:/bin:/usr/sbin:/sbin`. Example: `"/Users/you/.nvm/versions/node/v22.22.0/bin:/usr/bin:/bin:/usr/sbin:/sbin"`.

**Install Dart (required for Dart MCP):**

```bash
brew install dart-sdk
which dart   # → e.g. /opt/homebrew/bin/dart
```

Use that full path as `{DART_PATH}` in the Dart MCP config. If you skip installing Dart, omit the Dart MCP from your config (or disable it) until Dart is installed.

---

## Top 20 recommended / most used MCPs (reference)

Synthesized from directory ratings (e.g. mcp-awesome.com, Smithery usage, Firecrawl/Cursor guides, best-of-mcp-servers). Use as a checklist for “what to add next”; many are already in this doc or built into Cursor.

**Legend:** ✅ = already installed (in your Cursor and/or OpenCode config).

| # | MCP | Purpose | In this doc / notes |
|---|-----|---------|----------------------|
| 1 | **GitHub** ✅ | Repos, issues, PRs, Actions, file ops | Cursor default (or `github-mcp-server`); needs token; Go-based option may need `disabled` if no Go |
| 2 | **Context7** ✅ | Up-to-date SDK/framework docs | §3/§4 – custom context7-stdio + disable plugin |
| 3 | **Sequential Thinking** ✅ | Structured reasoning / reflection | Cursor default; use full npx path + PATH |
| 4 | **Memory** ✅ | Persistent memory across sessions | Cursor default; use full npx path + PATH |
| 5 | **Brave Search** ✅ | Web search (privacy-focused) | Cursor default; API key; full npx path + PATH |
| 6 | **Fetch** ✅ | Fetch and convert web content for LLMs | Cursor default; use full uvx path |
| 7 | **Google Developer Knowledge** ✅ | Google/Gemini dev docs | §2 |
| 8 | **Supabase** | Database, auth, storage, realtime | Remote; add URL + auth per Supabase MCP docs |
| 9 | **Postgres** | PostgreSQL queries (read-only, pooling) | Official `@modelcontextprotocol/server-postgres`; connection string in env |
| 10 | **Notion** | Pages, databases, blocks | Remote; OAuth or token per Notion MCP docs |
| 11 | **Firecrawl** | Web scraping, crawl, search, extract | `@firecrawl/mcp-server`; FIRECRAWL_API_KEY |
| 12 | **Playwright** | Browser automation, testing, scraping | Official server; npx + PATH |
| 13 | **Docker** | Containers, images, Compose | Official or community server; npx/local |
| 14 | **Slack** | Messages, threads, channels | Official/community; OAuth or token |
| 15 | **Linear** | Issues, sprints, project management | Linear MCP; API key |
| 16 | **Figma** | Design context, tokens, code from frames | Official Figma MCP (desktop or remote); token |
| 17 | **Stripe** | Payments, subscriptions, invoices | Remote; Stripe MCP; API key / OAuth |
| 18 | **Filesystem** | File operations (beyond editor) | Official `@modelcontextprotocol/server-filesystem`; allowlist paths |
| 19 | **Exa** | AI-powered web search (embeddings + search) | Exa MCP; API key; high usage on Smithery |
| 20 | **Vercel** ✅ | Deployments, logs, project management | §2b |

**Other often-mentioned:** Browserbase (cloud browser), Sentry (errors), Cloudflare (infra), Tavily (search), Puppeteer (browser), MongoDB (DB). **Discovery:** [mcp-awesome.com](https://mcp-awesome.com), [Smithery](https://smithery.ai), [best-of-mcp-servers](https://github.com/tolkonepiu/best-of-mcp-servers), [modelcontextprotocol.io/examples](https://modelcontextprotocol.io/examples).

---

## 1. Workflow-Scripts sync

- [ ] Sync Workflow-Scripts from remote (e.g. `beta` branch).
- [ ] From project root: `./Workflow-Scripts/scripts/pull-workflows.sh`
  **Or** from inside: `cd Workflow-Scripts && git pull --ff-only`.
- [ ] Confirm new workflows/skills if present.

---

## 2. Google Developer Knowledge (Gemini docs) MCP

**Docs:** [Connect to the Developer Knowledge MCP server](https://developers.google.com/knowledge/mcp) | [API](https://developers.google.com/knowledge/api)

- [ ] Enable Developer Knowledge API in a Google Cloud project: [Console](https://console.cloud.google.com/start/api?id=developerknowledge.googleapis.com).
- [ ] Enable MCP server:  
  `gcloud beta services mcp enable developerknowledge.googleapis.com --project=PROJECT_ID`
- [ ] Create an API key (Credentials → restrict to Developer Knowledge API if desired).
- [ ] Add MCP to **Cursor** and/or **OpenCode** (see sections 3 and 4).

---

## 2b. Vercel MCP (optional)

**Docs:** [Use Vercel's MCP server](https://vercel.com/docs/agent-resources/vercel-mcp) | [Vercel MCP overview](https://vercel.com/docs/mcp)

Vercel’s official remote MCP server gives AI tools access to your Vercel projects (deployments, logs, docs). It uses **OAuth**; no API key in config.

- [ ] **Cursor:** In `~/.cursor/mcp.json` add: `"vercel": { "url": "https://mcp.vercel.com" }`. Restart; in Tools & MCP click “Needs login” and complete OAuth.
- [ ] **OpenCode:** In `~/.config/opencode/opencode.json` under `mcp` add: `"vercel": { "type": "remote", "url": "https://mcp.vercel.com", "enabled": true }`. Run `opencode mcp auth vercel` when prompted to complete OAuth.
- [ ] **Project-specific URL** (optional, both): Use `https://mcp.vercel.com/<team-slug>/<project-slug>` (from `vercel projects ls` or dashboard Settings → General).
- [ ] **One-line install (all agents):** `npx add-mcp https://mcp.vercel.com` (detects Cursor, OpenCode, Claude Code, etc. and configures each).

**Tools:** Deployment logs, manage projects/deployments, search Vercel docs.

---

## 2c. Nano Banana, Gmail, and YouTube MCPs (required / default)

**Install by default** for Cursor and OpenCode. Use **{NPX_PATH}** and **{UVX_PATH}** from Prerequisites; set **PATH** in each server's `env` / `environment` to the binary's directory plus `:/usr/bin:/bin:/usr/sbin:/sbin`.

### Nano Banana (image generation via nanana.app)

**Note:** In Google’s docs, “Nano Banana” is Gemini’s native image generation (no separate MCP). The MCP below is from [nanana.app](https://nanana.app) and exposes image gen to MCP clients.

- **NPM:** `@nanana-ai/mcp-server-nano-banana`  
- **Auth:** API token from [nanana.app](https://nanana.app) → API Access.
- [ ] **Cursor** `~/.cursor/mcp.json`: `"nano-banana": { "command": "{NPX_PATH}", "args": ["-y", "@nanana-ai/mcp-server-nano-banana"], "env": { "NANANA_API_TOKEN": "YOUR_TOKEN", "PATH": "<NPX_DIR>:/usr/bin:/bin:/usr/sbin:/sbin" } }` (replace placeholders from Prerequisites).
- [ ] **OpenCode** under `mcp`: `"nano-banana": { "type": "local", "command": ["{NPX_PATH}", "-y", "@nanana-ai/mcp-server-nano-banana"], "enabled": true, "environment": { "NANANA_API_TOKEN": "YOUR_TOKEN", "PATH": "<NPX_DIR>:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- **Tools:** `text_to_image`, `image_to_image`.

### Gmail

- **Options:** [google-workspace-mcp-advanced](https://pypi.org/project/google-workspace-mcp-advanced/) (PyPI, uvx — includes Gmail + Drive, Calendar, etc.); [jasonsum/gmail-mcp-server](https://github.com/jasonsum/gmail-mcp-server) (clone + `uv run`). Set `USER_GOOGLE_EMAIL`, `GOOGLE_OAUTH_CLIENT_ID`, `GOOGLE_OAUTH_CLIENT_SECRET`; run with `uvx google-workspace-mcp-advanced --transport stdio`.
- [ ] **Cursor:** `"gmail": { "command": "<full-path>/uvx", "args": ["google-workspace-mcp-advanced", "--transport", "stdio"], "env": { "USER_GOOGLE_EMAIL": "...", "GOOGLE_OAUTH_CLIENT_ID": "...", "GOOGLE_OAUTH_CLIENT_SECRET": "...", "PATH": "..." } }`.
- [ ] **OpenCode:** Same: `type: "local"`, `command`: full path to uvx + args, `environment` for OAuth env vars and PATH.
- **Tools:** read/send/search email, drafts, labels, archive (varies by implementation).

### YouTube

- **Use this package (avoids known SDK bug):** `@iflow-mcp/youtube-mcp-server`. Do **not** use `zubeid-youtube-mcp-server` — it has a [known bug](https://github.com/ZubeidHendricks/youtube-mcp-server/issues/20) until fixed on npm. **Auth:** YouTube Data API v3 key from [Google Cloud Console](https://console.cloud.google.com/apis/credentials).
- [ ] **Cursor** `~/.cursor/mcp.json`: `"youtube": { "command": "{NPX_PATH}", "args": ["-y", "@iflow-mcp/youtube-mcp-server"], "env": { "YOUTUBE_API_KEY": "YOUR_KEY", "PATH": "<NPX_DIR>:/usr/bin:/bin:/usr/sbin:/sbin" } }` (replace `{NPX_PATH}` and `<NPX_DIR>` from Prerequisites).
- [ ] **OpenCode** under `mcp`: `"youtube": { "type": "local", "command": ["{NPX_PATH}", "-y", "@iflow-mcp/youtube-mcp-server"], "enabled": true, "environment": { "YOUTUBE_API_KEY": "YOUR_KEY", "PATH": "<NPX_DIR>:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- **Tools:** video/channel/playlist details, search, transcripts (with timestamped captions).

---

## 2d. Stitch (optional), Dart, and Google Security MCPs (required)

**Dart** and **Google Security (SecOps)** are required / default. **Stitch** remains optional. Add to Cursor and OpenCode as below. Use full paths for `npx`/`dart`/`uvx` and `PATH` (or OpenCode `environment`) if you see spawn ENOENT.

### Stitch (Stitch AI – memory / knowledge hub)

**Source:** [StitchAI/stitch-ai-mcp](https://github.com/StitchAI/stitch-ai-mcp). Decentralized memory for AI agents (create_space, upload_memory, get_memory, etc.). **Auth:** `API_KEY` and `BASE_URL` (e.g. `https://api-demo.stitch-ai.co`). Run from cloned repo via `ts-node`.

- [ ] **Cursor** `~/.cursor/mcp.json`: Clone repo, then e.g. `"stitch": { "command": "/Users/<you>/.nvm/versions/node/v22.12.0/bin/npx", "args": ["ts-node", "/path/to/stitch-ai-mcp/src/server.ts"], "env": { "API_KEY": "YOUR_KEY", "BASE_URL": "https://api-demo.stitch-ai.co", "PATH": "/Users/<you>/.nvm/versions/node/v22.12.0/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`. Replace `/path/to/stitch-ai-mcp` with your clone path.
- [ ] **OpenCode** under `mcp`: `"stitch": { "type": "local", "command": ["/Users/<you>/.nvm/versions/node/v22.12.0/bin/npx", "ts-node", "/path/to/stitch-ai-mcp/src/server.ts"], "enabled": true, "environment": { "API_KEY": "YOUR_KEY", "BASE_URL": "https://api-demo.stitch-ai.co", "PATH": "/Users/<you>/.nvm/versions/node/v22.12.0/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- **Tools:** create_space, delete_space, get_all_spaces, upload_memory, get_memory, get_all_memories.

### Dart (Dart & Flutter MCP server)

**Source:** [Dart MCP server](https://dart.dev/tools/mcp-server) (official). Format, test, pub, pub.dev search, symbol/docs, analyze/fix.

**Requires:** Dart SDK installed first (see Prerequisites: `brew install dart-sdk` then `which dart`). **Always use the full path** to `dart` in config — Cursor/OpenCode do not see your shell PATH. Use **{DART_PATH}** from Prerequisites (e.g. `/opt/homebrew/bin/dart`).

- [ ] **Cursor** `~/.cursor/mcp.json`: `"dart": { "command": "{DART_PATH}", "args": ["mcp-server"], "env": { "PATH": "<DART_DIR>:/usr/bin:/bin:/usr/sbin:/sbin" } }` (replace with your dart path and its directory).
- [ ] **OpenCode** under `mcp`: `"dart": { "type": "local", "command": ["{DART_PATH}", "mcp-server"], "enabled": true, "environment": { "PATH": "<DART_DIR>:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- **Tools:** format, test, pub get/add, pub_dev_search, runtime introspection, resolve symbol/docs, analyze/fix.

### Security / Google SecOps (securityServer)

**Source:** [google/mcp-security](https://github.com/google/mcp-security). Servers for Chronicle (SecOps), GTI, SCC, SecOps SOAR. **Auth:** ADC (`gcloud auth application-default login`) or env vars (e.g. `CHRONICLE_PROJECT_ID`, `CHRONICLE_CUSTOMER_ID`, `CHRONICLE_REGION`, `VT_APIKEY`, `SOAR_URL`, `SOAR_APP_KEY`). Install with `uv tool install google-secops-mcp` (and optionally `gti-mcp`, `scc-mcp`, `secops-soar-mcp`), run with `uvx`.

- [ ] **Cursor** `~/.cursor/mcp.json` (example – SecOps only): `"secops": { "command": "/Users/<you>/.cargo/bin/uvx", "args": ["--from", "google-secops-mcp", "secops_mcp"], "env": { "CHRONICLE_PROJECT_ID": "your-project-id", "CHRONICLE_CUSTOMER_ID": "your-customer-id", "CHRONICLE_REGION": "us", "PATH": "/Users/<you>/.cargo/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`. Add `gti`, `scc-mcp`, `secops-soar` similarly per [Google MCP Security README](https://github.com/google/mcp-security); use full path to `uvx` if needed.
- [ ] **OpenCode** under `mcp`: Same pattern with `type: "local"`, `command`: full path to `uvx` plus args, `environment` for env vars and PATH.
- **Tools:** Chronicle threat detection/hunting, GTI threat intel, SCC cloud security, SOAR automation (depends on which server(s) you enable).

---

## 2e. Apple MCPs (required / default)

Apple-related MCPs for documentation (Swift, SwiftUI, UIKit, etc.) and Xcode tooling. **Install by default** for Cursor and OpenCode. Use **{NPX_PATH}** and `<NPX_DIR>` from Prerequisites.

### Apple Doc MCP (Apple Developer Documentation)

**Source:** [MightyDillah/apple-doc-mcp](https://github.com/MightyDillah/apple-doc-mcp). Smart search over Apple Developer Documentation with wildcard support (SwiftUI, UIKit, Foundation, Metal, etc.). **Auth:** None. **NPM:** `apple-doc-mcp-server`. Resolve and review a concrete version before adding it to persistent MCP config; avoid implicit `@latest` for tools that will receive credentials.

- [ ] **Cursor** `~/.cursor/mcp.json`: `"apple-docs": { "command": "{NPX_PATH}", "args": ["-y", "apple-doc-mcp-server@<reviewed-version>"], "env": { "PATH": "<NPX_DIR>:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- [ ] **OpenCode** under `mcp`: `"apple-docs": { "type": "local", "command": ["{NPX_PATH}", "-y", "apple-doc-mcp-server@<reviewed-version>"], "enabled": true, "environment": { "PATH": "<NPX_DIR>:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- **Tools:** `discover_technologies`, `choose_technology`, `current_technology`, `search_symbols`, `get_documentation`, `get_version`.

### XcodeBuild MCP (Xcode / Swift / Simulator / Device)

**Source:** [XcodeBuildMCP](https://github.com/getsentry/XcodeBuildMCP). Xcode project discovery, builds, Swift Package Manager, simulators, physical devices, app install/launch, logs, UI automation. **Requires:** macOS 14.5+, Xcode 16+.

**Use pinned version to avoid Sentry dependency errors:** `xcodebuildmcp@1.15.1` (do **not** use `@latest` — v2.x has a [known @sentry/core resolution bug](https://github.com/getsentry/XcodeBuildMCP/issues)). Include `XCODEBUILDMCP_SENTRY_DISABLED`: `"true"` if you later switch to `@latest`. The CLI requires the **`mcp`** subcommand in `args` / `command`.

- [ ] **Cursor** `~/.cursor/mcp.json`: `"XcodeBuildMCP": { "command": "{NPX_PATH}", "args": ["-y", "xcodebuildmcp@1.15.1", "mcp"], "env": { "XCODEBUILDMCP_SENTRY_DISABLED": "true", "PATH": "<NPX_DIR>:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- [ ] **OpenCode** under `mcp`: `"XcodeBuildMCP": { "type": "local", "command": ["{NPX_PATH}", "-y", "xcodebuildmcp@1.15.1", "mcp"], "enabled": true, "environment": { "XCODEBUILDMCP_SENTRY_DISABLED": "true", "PATH": "<NPX_DIR>:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- **Tools:** Project discovery, build/clean, schemes/settings, SPM build/test/run, simulator/device list and app lifecycle, logs, screenshots, project scaffolding, doctor.

### Other Apple-related MCPs (reference)

- **Apple Dev MCP** (tmaasen): HIG + API docs in one server; npm `apple-dev-mcp-server` or `@iflow-mcp/tmaasen-apple-dev-mcp` — use full path to `node` and script if needed.
- **App Store Connect MCP**: For App Store Connect API (e.g. [joshuarileydev/app-store-connect-mcp-server](https://github.com/joshuarileydev/app-store-connect-mcp-server)); requires Apple API key/auth.

---

## 2f. Remotion MCP (default)

**Source:** [Remotion MCP docs](https://www.remotion.dev/docs/ai/mcp) | npm: `@remotion/mcp`. **Installed by default.** Gives AI access to Remotion (React-based programmatic video) documentation so it can answer Remotion questions and suggest correct APIs. **Auth:** None (test phase). Remotion also offers **Agent Skills** (`npx remotion skills add`) for Cursor/Claude Code/Codex — install those in-project for workflow guidance.

- [ ] **Cursor** `~/.cursor/mcp.json`: `"remotion": { "command": "{NPX_PATH}", "args": ["-y", "@remotion/mcp@<reviewed-version>"], "env": { "PATH": "<NPX_DIR>:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- [ ] **OpenCode** under `mcp`: `"remotion": { "type": "local", "command": ["{NPX_PATH}", "-y", "@remotion/mcp@<reviewed-version>"], "enabled": true, "environment": { "PATH": "<NPX_DIR>:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- **Skills (optional):** In a Remotion project run `npx remotion skills add` to add Agent Skills to `.claude/skills` for Cursor/Claude Code/Codex.

---

## 2g. Mermaid (image rendering) MCP (default)

**Installed by default.** Renders images (PNG or SVG) from Mermaid diagram definitions. Use when you want the AI to generate diagram images from Mermaid syntax.

**Source:** [peng-shawn/mermaid-mcp-server](https://github.com/peng-shawn/mermaid-mcp-server) | **NPM:** `@peng-shawn/mermaid-mcp-server`. Uses Puppeteer for headless rendering. **Auth:** None. Supports themes (default, forest, dark, neutral) and optional save to disk.

- [ ] **Cursor** `~/.cursor/mcp.json`: `"mermaid": { "command": "{NPX_PATH}", "args": ["-y", "@peng-shawn/mermaid-mcp-server"], "env": { "PATH": "<NPX_DIR>:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- [ ] **OpenCode** under `mcp`: `"mermaid": { "type": "local", "command": ["{NPX_PATH}", "-y", "@peng-shawn/mermaid-mcp-server"], "enabled": true, "environment": { "PATH": "<NPX_DIR>:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- **Tools:** Renders Mermaid diagram definitions to PNG or SVG (returned or saved to file).

---

## 3. Cursor MCP configuration

**File:** `~/.cursor/mcp.json`

**Rule:** Use full paths from Prerequisites for all stdio servers; set PATH in each server's `env` to the binary's directory + `:/usr/bin:/bin:/usr/sbin:/sbin`.

- [ ] Add Google Developer Knowledge: `url`: `https://developerknowledge.googleapis.com/mcp`, `headers`: `{ "X-Goog-Api-Key": "YOUR_API_KEY" }`. Replace with real API key.
- [ ] **Vercel** (optional): `"vercel": { "url": "https://mcp.vercel.com" }`. After restart, click “Needs login” to complete OAuth.
- [ ] **Context7, Firebase:** Use `{NPX_PATH}` and PATH in env; disable the built-in plugin MCP in UI. For credentialed servers, pin a reviewed version before storing the config. Firebase example: args `["-y", "firebase-tools@<reviewed-version>", "mcp"]`; run `firebase login` if needed.
- [ ] **Nano Banana / Gmail / YouTube:** See §2c. **YouTube:** use `@iflow-mcp/youtube-mcp-server` (not `zubeid-youtube-mcp-server`).
- [ ] **Dart:** See §2d. Install Dart first (Prerequisites); use `{DART_PATH}` (full path), never `"command": "dart"`.
- [ ] **Security:** See §2d; use `{UVX_PATH}` and PATH.
- [ ] **Apple / XcodeBuild:** See §2e. **XcodeBuild:** use `xcodebuildmcp@1.15.1` (not `@latest`) and `XCODEBUILDMCP_SENTRY_DISABLED`: `"true"`.
- [ ] **Remotion / Mermaid:** See §2f and §2g; use `{NPX_PATH}` and PATH.
- [ ] **github-mcp-server:** if Go not installed, set `"disabled": true`.
- [ ] Restart Cursor after changes.

---

## 4. OpenCode MCP and default model

**File:** `~/.config/opencode/opencode.json`

Apply the same MCPs as Cursor where applicable:

- [ ] **Google Developer Knowledge** under `mcp`: `"google-developer-knowledge": { "type": "remote", "url": "https://developerknowledge.googleapis.com/mcp", "enabled": true, "headers": { "X-Goog-Api-Key": "YOUR_API_KEY" } }`. Replace with real API key.
- [ ] **Vercel** (optional): `"vercel": { "type": "remote", "url": "https://mcp.vercel.com", "enabled": true }`. Run `opencode mcp auth vercel` when prompted.
- [ ] **Context7** (remote): `"context7": { "type": "remote", "url": "https://mcp.context7.com/mcp", "enabled": true }`. Optional: add `"headers": { "CONTEXT7_API_KEY": "{env:CONTEXT7_API_KEY}" }` for higher limits.
- [ ] **Firebase** (local): Use `{NPX_PATH}` and PATH in `environment`; run `firebase login` if needed.
- [ ] **Nano Banana / Gmail / YouTube:** See §2c; use `{NPX_PATH}` or `{UVX_PATH}` and PATH. **YouTube:** `@iflow-mcp/youtube-mcp-server`.
- [ ] **Dart:** See §2d; use `{DART_PATH}` (full path) and PATH. Install Dart first (Prerequisites).
- [ ] **Security:** See §2d; use `{UVX_PATH}` and `environment` for credentials and PATH.
- [ ] **Apple / XcodeBuild:** See §2e; use `{NPX_PATH}` and PATH. **XcodeBuild:** `xcodebuildmcp@1.15.1` and `XCODEBUILDMCP_SENTRY_DISABLED`: `"true"`.
- [ ] **Remotion / Mermaid:** See §2f and §2g; use `{NPX_PATH}` and PATH.
- [ ] Set default model: top-level `"model": "zai-coding-plan/glm-5"` (or `google/antigravity-gemini-3-flash`). Ensure Z.AI auth: `opencode auth login`. If GLM 5 missing: `opencode models --refresh`.

---

## 5. oh-my-opencode overrides (default model in UI)

**File:** `~/.config/opencode/oh-my-opencode.json`

If the OpenCode UI still shows a different model (e.g. Claude) after setting `model` in `opencode.json`, oh-my-opencode is overriding it.

- [ ] Open `oh-my-opencode.json`.
- [ ] Set the **Sisyphus (Ultraworker)** agent to desired model, e.g. GLM 5:
  - `agents.sisyphus.model`: `"zai-coding-plan/glm-5"`
- [ ] Optionally set default/unspecified categories to the same model:
  - `categories.unspecified-low.model`: `"zai-coding-plan/glm-5"`
  - `categories.unspecified-high.model`: `"zai-coding-plan/glm-5"`
- [ ] Restart OpenCode or start a new session.

---

## 6. Verification

- [ ] **Cursor:** In Tools & MCP, confirm `google-developer-knowledge` “3 tools enabled”; no Error for fixed stdio servers; `context7-stdio` and `firebase-stdio` enabled, plugin context7/firebase OFF; Vercel shows tools after OAuth or “Needs login”.
- [ ] **OpenCode:** Confirm `opencode mcp list` or UI shows google-developer-knowledge, vercel (after auth), context7, firebase-stdio; default model (e.g. GLM 5) in UI.
- [ ] **Both:** Ask something that uses Google docs (e.g. “How do I list Cloud Storage buckets?”) and confirm `search_documents` / `get_document` tool use.

---

## Troubleshooting

If you followed Prerequisites and the package versions in this doc (YouTube: `@iflow-mcp/youtube-mcp-server`, XcodeBuild: `xcodebuildmcp@1.15.1`, Dart: full path after `brew install dart-sdk`), most errors are avoided. If you still see issues:

- **spawn ENOENT / command not found:** You did not use full paths. Resolve `{NPX_PATH}`, `{UVX_PATH}`, `{DART_PATH}` (see Prerequisites) and use them in `command`; add PATH in `env`/`environment` with the binary's directory.
- **YouTube:** `Cannot find module ... @modelcontextprotocol/sdk/dist/cjs` → switch to `@iflow-mcp/youtube-mcp-server` (see §2c). Clear npx cache (`rm -rf ~/.npm-cache/_npx`) if needed.
- **XcodeBuild:** `Cannot find package ... @sentry/core` → use `xcodebuildmcp@1.15.1` (not `@latest`) and set `XCODEBUILDMCP_SENTRY_DISABLED`: `"true"`. Clear npx cache if needed.
- **Dart:** `spawn dart ENOENT` → install Dart (`brew install dart-sdk`), then use the full path from `which dart` as `command` (e.g. `/opt/homebrew/bin/dart`). Omit or disable the Dart MCP until Dart is installed.

---

## Reference: Config locations

| Tool / plugin | Config file | Purpose |
|---------------|-------------|---------|
| Cursor | `~/.cursor/mcp.json` | MCP servers (stdio + remote). |
| OpenCode | `~/.config/opencode/opencode.json` | MCP, default `model`, providers. |
| oh-my-opencode | `~/.config/opencode/oh-my-opencode.json` | Per-agent and per-category model overrides (overrides OpenCode default). |

---

## Notes

- **Developer Knowledge MCP** exposes tools: `search_documents`, `get_document`, `batch_get_documents` (Google dev docs, including ai.google.dev/Gemini).
- **GLM 5** requires Z.AI Coding Plan (or Z.AI) auth; model id in OpenCode/models.dev: `zai-coding-plan/glm-5`.
- **Plugin MCPs (Context7, Firebase):** Plugins that run `npx -y <package>` often hit `spawn npx ENOENT`. Add custom servers (`context7-stdio`, `firebase-stdio`) in `mcp.json` with full npx path and `PATH` in env, then disable the plugin MCP in the UI.
- **Vercel MCP:** Official remote at `https://mcp.vercel.com`; OAuth only. Cursor: `url` in mcp.json; OpenCode: `type: "remote"`, then `opencode mcp auth vercel`. Project-specific: `https://mcp.vercel.com/<team-slug>/<project-slug>`.
- **Context7 / Firebase:** Cursor: custom stdio servers (full npx path + PATH); disable plugin MCPs. OpenCode: Context7 remote `https://mcp.context7.com/mcp`; Firebase local with full npx path and PATH in `environment`.
- **Prerequisites:** Resolve `{NPX_PATH}`, `{UVX_PATH}`, `{DART_PATH}` (see Prerequisites) and use them in all stdio server configs; set PATH in `env`/`environment` to the binary's directory + `:/usr/bin:/bin:/usr/sbin:/sbin`.
- **Nano Banana / Gmail / YouTube:** See §2c. Use `{NPX_PATH}` or `{UVX_PATH}` and PATH. **YouTube:** use `@iflow-mcp/youtube-mcp-server` (not `zubeid-youtube-mcp-server`).
- **Dart:** See §2d. Install Dart first (`brew install dart-sdk`); always use full path `{DART_PATH}` in config. **Security:** use `{UVX_PATH}` and PATH.
- **Apple MCPs:** See §2e. **XcodeBuild:** use `xcodebuildmcp@1.15.1` (not `@latest`) and `XCODEBUILDMCP_SENTRY_DISABLED`: `"true"` to avoid Sentry errors.
- **Remotion (default):** See §2f. MCP = Remotion docs for AI; optional Agent Skills via `npx remotion skills add` in Remotion projects.
- **Mermaid (default):** See §2g. Renders Mermaid diagram definitions to PNG or SVG via `@peng-shawn/mermaid-mcp-server`; use full npx path + PATH.
- **Cursor PATH:** GUI apps often get a minimal PATH; using full paths to `npx`/`uvx` in `mcp.json` avoids “command not found” for stdio MCPs.
