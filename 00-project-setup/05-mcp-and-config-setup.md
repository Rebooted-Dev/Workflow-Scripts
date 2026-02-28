# MCP and Configuration Setup Task List

Checklist for configuring MCP (Model Context Protocol) servers and default model/provider in **Cursor** and **OpenCode**, including the Google Developer Knowledge (Gemini docs) MCP and GLM 5 default.

**When to use:** Setting up or fixing MCP servers in Cursor, adding OpenCode MCP/config, or switching default model to GLM 5 (or another provider) when oh-my-opencode overrides apply.

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
- [ ] From project root: `./Workflow-Scripts/pull-workflows.sh`  
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

## 2c. Nano Banana, Gmail, and YouTube MCPs (optional)

These are community/third-party MCPs. Use full path to `npx` and `PATH` in env (Cursor) or `command`/`environment` (OpenCode) if you hit `spawn npx ENOENT`.

### Nano Banana (image generation via nanana.app)

**Note:** In Google’s docs, “Nano Banana” is Gemini’s native image generation (no separate MCP). The MCP below is from [nanana.app](https://nanana.app) and exposes image gen to MCP clients.

- **NPM:** `@nanana-ai/mcp-server-nano-banana`  
- **Auth:** API token from [nanana.app](https://nanana.app) → API Access.
- [ ] **Cursor** `~/.cursor/mcp.json`: `"nano-banana": { "command": "/Users/<you>/.nvm/versions/node/v22.12.0/bin/npx", "args": ["-y", "@nanana-ai/mcp-server-nano-banana"], "env": { "NANANA_API_TOKEN": "YOUR_TOKEN", "PATH": "/Users/<you>/.nvm/versions/node/v22.12.0/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- [ ] **OpenCode** `opencode.json` under `mcp`: `"nano-banana": { "type": "local", "command": ["/Users/<you>/.nvm/versions/node/v22.12.0/bin/npx", "-y", "@nanana-ai/mcp-server-nano-banana"], "enabled": true, "environment": { "NANANA_API_TOKEN": "YOUR_TOKEN", "PATH": "/Users/<you>/.nvm/versions/node/v22.12.0/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- **Tools:** `text_to_image`, `image_to_image`.

### Gmail

- **Options:** [jasonsum/gmail-mcp-server](https://github.com/jasonsum/gmail-mcp-server) (Node), [redazzo/gmail-mcp](https://github.com/redazzo/gmail-mcp) (Python). Need Google Cloud project, Gmail API enabled, OAuth 2.0 credentials (Desktop app).
- [ ] **Cursor:** Add server per repo’s README (e.g. `npx -y gmail-mcp-server` with full npx path + PATH; set `GMAIL_CREDENTIALS` or OAuth env vars).
- [ ] **OpenCode:** Same as Cursor: `type: "local"`, `command` with full path to node/npx, `environment` for credentials and PATH.
- **Tools:** read/send/search email, drafts, labels, archive (varies by implementation).

### YouTube

- **NPM:** `zubeid-youtube-mcp-server` ([ZubeidHendricks/youtube-mcp-server](https://github.com/ZubeidHendricks/youtube-mcp-server)). **Auth:** YouTube Data API v3 key from [Google Cloud Console](https://console.cloud.google.com/apis/credentials).
- [ ] **Cursor** `~/.cursor/mcp.json`: `"youtube": { "command": "/Users/<you>/.nvm/versions/node/v22.12.0/bin/npx", "args": ["-y", "zubeid-youtube-mcp-server"], "env": { "YOUTUBE_API_KEY": "YOUR_KEY", "PATH": "/Users/<you>/.nvm/versions/node/v22.12.0/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- [ ] **OpenCode** under `mcp`: `"youtube": { "type": "local", "command": ["/Users/<you>/.nvm/versions/node/v22.12.0/bin/npx", "-y", "zubeid-youtube-mcp-server"], "enabled": true, "environment": { "YOUTUBE_API_KEY": "YOUR_KEY", "PATH": "/Users/<you>/.nvm/versions/node/v22.12.0/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- **Tools:** video/channel/playlist details, search, transcripts (with timestamped captions).

---

## 2d. Stitch, Dart, and Google Security MCPs (optional)

Same MCPs you may have in Gemini CLI; add to Cursor and OpenCode as below. Use full paths for `npx`/`dart`/`uvx` and `PATH` (or OpenCode `environment`) if you see spawn ENOENT.

### Stitch (Stitch AI – memory / knowledge hub)

**Source:** [StitchAI/stitch-ai-mcp](https://github.com/StitchAI/stitch-ai-mcp). Decentralized memory for AI agents (create_space, upload_memory, get_memory, etc.). **Auth:** `API_KEY` and `BASE_URL` (e.g. `https://api-demo.stitch-ai.co`). Run from cloned repo via `ts-node`.

- [ ] **Cursor** `~/.cursor/mcp.json`: Clone repo, then e.g. `"stitch": { "command": "/Users/<you>/.nvm/versions/node/v22.12.0/bin/npx", "args": ["ts-node", "/path/to/stitch-ai-mcp/src/server.ts"], "env": { "API_KEY": "YOUR_KEY", "BASE_URL": "https://api-demo.stitch-ai.co", "PATH": "/Users/<you>/.nvm/versions/node/v22.12.0/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`. Replace `/path/to/stitch-ai-mcp` with your clone path.
- [ ] **OpenCode** under `mcp`: `"stitch": { "type": "local", "command": ["/Users/<you>/.nvm/versions/node/v22.12.0/bin/npx", "ts-node", "/path/to/stitch-ai-mcp/src/server.ts"], "enabled": true, "environment": { "API_KEY": "YOUR_KEY", "BASE_URL": "https://api-demo.stitch-ai.co", "PATH": "/Users/<you>/.nvm/versions/node/v22.12.0/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- **Tools:** create_space, delete_space, get_all_spaces, upload_memory, get_memory, get_all_memories.

### Dart (Dart & Flutter MCP server)

**Source:** [Dart MCP server](https://dart.dev/tools/mcp-server) (official). Format, test, pub, pub.dev search, symbol/docs, analyze/fix. **Requires:** Dart SDK (e.g. `dart mcp-server` on PATH).

- [ ] **Cursor** `~/.cursor/mcp.json`: `"dart": { "command": "dart", "args": ["mcp-server"] }`. If Cursor can’t find `dart`, use full path to `dart` (e.g. from `which dart` or Flutter SDK `bin/dart`).
- [ ] **OpenCode** under `mcp`: `"dart-mcp-server": { "type": "local", "command": ["dart", "mcp-server"], "enabled": true, "environment": {} }`. Use full path to `dart` in `command` if OpenCode doesn’t see it (e.g. `["/path/to/dart-sdk/bin/dart", "mcp-server"]`).
- **Tools:** format, test, pub get/add, pub_dev_search, runtime introspection, resolve symbol/docs, analyze/fix.

### Security / Google SecOps (securityServer)

**Source:** [google/mcp-security](https://github.com/google/mcp-security). Servers for Chronicle (SecOps), GTI, SCC, SecOps SOAR. **Auth:** ADC (`gcloud auth application-default login`) or env vars (e.g. `CHRONICLE_PROJECT_ID`, `CHRONICLE_CUSTOMER_ID`, `CHRONICLE_REGION`, `VT_APIKEY`, `SOAR_URL`, `SOAR_APP_KEY`). Install with `uv tool install google-secops-mcp` (and optionally `gti-mcp`, `scc-mcp`, `secops-soar-mcp`), run with `uvx`.

- [ ] **Cursor** `~/.cursor/mcp.json` (example – SecOps only): `"secops": { "command": "/Users/<you>/.cargo/bin/uvx", "args": ["--from", "google-secops-mcp", "secops_mcp"], "env": { "CHRONICLE_PROJECT_ID": "your-project-id", "CHRONICLE_CUSTOMER_ID": "your-customer-id", "CHRONICLE_REGION": "us", "PATH": "/Users/<you>/.cargo/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`. Add `gti`, `scc-mcp`, `secops-soar` similarly per [Google MCP Security README](https://github.com/google/mcp-security); use full path to `uvx` if needed.
- [ ] **OpenCode** under `mcp`: Same pattern with `type: "local"`, `command`: full path to `uvx` plus args, `environment` for env vars and PATH.
- **Tools:** Chronicle threat detection/hunting, GTI threat intel, SCC cloud security, SOAR automation (depends on which server(s) you enable).

---

## 2e. Apple MCPs (optional)

Apple-related MCPs for documentation (Swift, SwiftUI, UIKit, etc.) and Xcode tooling. Use full path to `npx` and `PATH` in env (Cursor) or `environment` (OpenCode) if you hit spawn ENOENT.

### Apple Doc MCP (Apple Developer Documentation)

**Source:** [MightyDillah/apple-doc-mcp](https://github.com/MightyDillah/apple-doc-mcp). Smart search over Apple Developer Documentation with wildcard support (SwiftUI, UIKit, Foundation, Metal, etc.). **Auth:** None. **NPM:** `apple-doc-mcp-server@latest`.

- [ ] **Cursor** `~/.cursor/mcp.json`: `"apple-docs": { "command": "/Users/<you>/.nvm/versions/node/v22.12.0/bin/npx", "args": ["-y", "apple-doc-mcp-server@latest"], "env": { "PATH": "/Users/<you>/.nvm/versions/node/v22.12.0/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- [ ] **OpenCode** under `mcp`: `"apple-docs": { "type": "local", "command": ["/Users/<you>/.nvm/versions/node/v22.12.0/bin/npx", "-y", "apple-doc-mcp-server@latest"], "enabled": true, "environment": { "PATH": "/Users/<you>/.nvm/versions/node/v22.12.0/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- **Tools:** `discover_technologies`, `choose_technology`, `current_technology`, `search_symbols`, `get_documentation`, `get_version`.

### XcodeBuild MCP (Xcode / Swift / Simulator / Device)

**Source:** [fastmcp-me/xcodebuildmcp](https://github.com/fastmcp-me/xcodebuildmcp). Xcode project discovery, builds, Swift Package Manager, simulators, physical devices, app install/launch, logs, UI automation. **Requires:** macOS 14.5+, Xcode 16+. **NPM:** `xcodebuildmcp@latest`. Optional env: `INCREMENTAL_BUILDS_ENABLED`, `XCODEBUILDMCP_SENTRY_DISABLED`, `XCODEBUILDMCP_ENABLED_WORKFLOWS` (e.g. `simulator,device,project-discovery`).

**Important:** The CLI requires the **`mcp`** subcommand to start the MCP server. Without it, the process prints usage and exits; Cursor will show "No server info found". Always include `"mcp"` in `args` / `command`.

- [ ] **Cursor** `~/.cursor/mcp.json`: `"XcodeBuildMCP": { "command": "/Users/<you>/.nvm/versions/node/v22.12.0/bin/npx", "args": ["-y", "xcodebuildmcp@latest", "mcp"], "env": { "PATH": "/Users/<you>/.nvm/versions/node/v22.12.0/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- [ ] **OpenCode** under `mcp`: `"XcodeBuildMCP": { "type": "local", "command": ["/Users/<you>/.nvm/versions/node/v22.12.0/bin/npx", "-y", "xcodebuildmcp@latest", "mcp"], "enabled": true, "environment": { "PATH": "/Users/<you>/.nvm/versions/node/v22.12.0/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- **Tools:** Project discovery, build/clean, schemes/settings, SPM build/test/run, simulator/device list and app lifecycle, logs, screenshots, project scaffolding, doctor.

### Other Apple-related MCPs (reference)

- **Apple Dev MCP** (tmaasen): HIG + API docs in one server; npm `apple-dev-mcp-server` or `@iflow-mcp/tmaasen-apple-dev-mcp` — use full path to `node` and script if needed.
- **App Store Connect MCP**: For App Store Connect API (e.g. [joshuarileydev/app-store-connect-mcp-server](https://github.com/joshuarileydev/app-store-connect-mcp-server)); requires Apple API key/auth.

---

## 2f. Remotion MCP (optional)

**Source:** [Remotion MCP docs](https://www.remotion.dev/docs/ai/mcp) | npm: `@remotion/mcp`. Gives AI access to Remotion (React-based programmatic video) documentation so it can answer Remotion questions and suggest correct APIs. **Auth:** None (test phase). Remotion also offers **Agent Skills** (`npx remotion skills add`) for Cursor/Claude Code/Codex — install those in-project for workflow guidance.

- [ ] **Cursor** `~/.cursor/mcp.json`: `"remotion": { "command": "/Users/<you>/.nvm/versions/node/v22.12.0/bin/npx", "args": ["-y", "@remotion/mcp@latest"], "env": { "PATH": "/Users/<you>/.nvm/versions/node/v22.12.0/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- [ ] **OpenCode** under `mcp`: `"remotion": { "type": "local", "command": ["/Users/<you>/.nvm/versions/node/v22.12.0/bin/npx", "-y", "@remotion/mcp@latest"], "enabled": true, "environment": { "PATH": "/Users/<you>/.nvm/versions/node/v22.12.0/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- **Skills (optional):** In a Remotion project run `npx remotion skills add` to add Agent Skills to `.claude/skills` for Cursor/Claude Code/Codex.

---

## 2g. Mermaid (image rendering) MCP (optional)

Renders images (PNG or SVG) from Mermaid diagram definitions. Use when you want the AI to generate diagram images from Mermaid syntax.

**Source:** [peng-shawn/mermaid-mcp-server](https://github.com/peng-shawn/mermaid-mcp-server) | **NPM:** `@peng-shawn/mermaid-mcp-server`. Uses Puppeteer for headless rendering. **Auth:** None. Supports themes (default, forest, dark, neutral) and optional save to disk.

- [ ] **Cursor** `~/.cursor/mcp.json`: `"mermaid": { "command": "/Users/<you>/.nvm/versions/node/v22.12.0/bin/npx", "args": ["-y", "@peng-shawn/mermaid-mcp-server"], "env": { "PATH": "/Users/<you>/.nvm/versions/node/v22.12.0/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`. Replace `<you>` with your username (or use full path from `which npx`).
- [ ] **OpenCode** under `mcp`: `"mermaid": { "type": "local", "command": ["/Users/<you>/.nvm/versions/node/v22.12.0/bin/npx", "-y", "@peng-shawn/mermaid-mcp-server"], "enabled": true, "environment": { "PATH": "/Users/<you>/.nvm/versions/node/v22.12.0/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`.
- **Tools:** Renders Mermaid diagram definitions to PNG or SVG (returned or saved to file).

---

## 3. Cursor MCP configuration

**File:** `~/.cursor/mcp.json`

- [ ] Add Google Developer Knowledge: `url`: `https://developerknowledge.googleapis.com/mcp`, `headers`: `{ "X-Goog-Api-Key": "YOUR_API_KEY" }`. Replace with real API key.
- [ ] **Vercel** (optional): `"vercel": { "url": "https://mcp.vercel.com" }`. After restart, click “Needs login” to complete OAuth.
- [ ] If stdio servers **Error**: use **full paths** for `command` (e.g. `/Users/<you>/.nvm/versions/node/v22.12.0/bin/npx`, same for uvx).
- [ ] If **npx-based** servers still error: add **PATH** to each `env`: `"/Users/<you>/.nvm/versions/node/v22.12.0/bin:/usr/bin:/bin:/usr/sbin:/sbin"`.
- [ ] **github-mcp-server:** if Go not installed, set `"disabled": true` (or add full path to `go` when installed).
- [ ] **Plugin workaround (Context7, Firebase):** Add custom servers with full npx path + PATH in env; disable plugin MCP in UI.
  - Context7: `context7-stdio`, args `["-y", "@upstash/context7-mcp"]`.
  - Firebase: `firebase-stdio`, args `["-y", "firebase-tools@latest", "mcp"]`; run `firebase login` if needed.
- [ ] **Stitch / Dart / Security (optional):** See §2d for Stitch (memory), Dart (Flutter tooling), and Google SecOps (securityServer) — use full paths for command and PATH in env.
- [ ] **Apple (optional):** See §2e for Apple Doc MCP (docs) and XcodeBuild MCP (Xcode/Swift/simulator/device) — use full npx path + PATH.
- [ ] **Remotion (optional):** See §2f for Remotion MCP (React/video docs); use full npx path + PATH.
- [ ] **Mermaid (optional):** See §2g for Mermaid MCP (render diagram images from Mermaid definitions); use full npx path + PATH.
- [ ] Restart Cursor after changes.

---

## 4. OpenCode MCP and default model

**File:** `~/.config/opencode/opencode.json`

Apply the same MCPs as Cursor where applicable:

- [ ] **Google Developer Knowledge** under `mcp`: `"google-developer-knowledge": { "type": "remote", "url": "https://developerknowledge.googleapis.com/mcp", "enabled": true, "headers": { "X-Goog-Api-Key": "YOUR_API_KEY" } }`. Replace with real API key.
- [ ] **Vercel** (optional): `"vercel": { "type": "remote", "url": "https://mcp.vercel.com", "enabled": true }`. Run `opencode mcp auth vercel` when prompted.
- [ ] **Context7** (remote): `"context7": { "type": "remote", "url": "https://mcp.context7.com/mcp", "enabled": true }`. Optional: add `"headers": { "CONTEXT7_API_KEY": "{env:CONTEXT7_API_KEY}" }` for higher limits.
- [ ] **Firebase** (local, same PATH fix as Cursor): `"firebase-stdio": { "type": "local", "command": ["/Users/<you>/.nvm/versions/node/v22.12.0/bin/npx", "-y", "firebase-tools@latest", "mcp"], "enabled": true, "environment": { "PATH": "/Users/<you>/.nvm/versions/node/v22.12.0/bin:/usr/bin:/bin:/usr/sbin:/sbin" } }`. Run `firebase login` in terminal if needed.
- [ ] **Stitch / Dart / Security (optional):** See §2d for Stitch (clone + ts-node), Dart (`dart mcp-server`), and Google SecOps (uvx + google-secops-mcp etc.); use full paths and `environment` for PATH/credentials.
- [ ] **Apple (optional):** See §2e for Apple Doc MCP and XcodeBuild MCP; use full npx path and `environment` PATH.
- [ ] **Remotion (optional):** See §2f for Remotion MCP; use full npx path and `environment` PATH.
- [ ] **Mermaid (optional):** See §2g for Mermaid MCP (render diagram images); use full npx path and `environment` PATH.
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
- **Nano Banana / Gmail / YouTube:** See §2c. Nano Banana MCP = nanana.app (third-party image gen); Gmail/YouTube need Google Cloud + API keys/OAuth. Use full npx path + PATH in both Cursor and OpenCode.
- **Stitch / Dart / Security (securityServer):** See §2d. Stitch = StitchAI memory (clone + ts-node); Dart = official `dart mcp-server`; Security = Google MCP Security (secops/gti/scc/soar via uvx).
- **Apple MCPs:** See §2e. Apple Doc MCP = Apple Developer Documentation (Swift/SwiftUI/UIKit); XcodeBuild MCP = Xcode projects, SPM, simulators, devices. Both via npx; use full path + PATH.
- **Remotion:** See §2f. MCP = Remotion docs for AI; optional Agent Skills via `npx remotion skills add` in Remotion projects.
- **Mermaid (image rendering):** See §2g. Renders Mermaid diagram definitions to PNG or SVG via `@peng-shawn/mermaid-mcp-server`; use full npx path + PATH.
- **Cursor PATH:** GUI apps often get a minimal PATH; using full paths to `npx`/`uvx` in `mcp.json` avoids “command not found” for stdio MCPs.
