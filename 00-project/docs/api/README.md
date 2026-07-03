# API / Interfaces

## What Interfaces Exist

Workflow-Scripts has **no external HTTP API**. Public interfaces are:

1. **Shell script CLIs** — sync and validation
2. **Orchestrator CLI** — delegated OpenCode reviews
3. **Markdown workflows** — agent-executable instruction interfaces
4. **Codex skills** — thin triggers in `11-Skills/`
5. **`@ai-sdk/image-generation`** — TypeScript library for multi-provider image generation

## Shell Scripts

### `scripts/pull-workflows.sh`

Pull latest workflows in a nested clone.

```bash
./Workflow-Scripts/scripts/pull-workflows.sh
```

Behavior: refuses pull on dirty tree or detached HEAD; uses `git pull --ff-only`.

### `scripts/update-workflows.sh`

Maintainer helper — commits staged changes and pushes.

```bash
cd Workflow-Scripts
git add <files-to-publish>   # stage only what you intend to commit
./scripts/update-workflows.sh "docs: describe your change"
```

The script commits **staged changes only** and rejects unstaged tracked files or untracked files.

### `scripts/sync-workflow-scripts.sh`

Multi-project batch sync.

| Flag | Effect |
|------|--------|
| `--status` | Show sync state per configured project |
| `--dry-run` | Preview without pulling |
| `--verbose` | Detailed per-project output |
| `--auto` | Auto-discover host projects under `WORKFLOW_SYNC_BASE_DIR` |

Environment: `WORKFLOW_SYNC_BASE_DIR`, `WORKFLOW_SYNC_PROJECTS` (colon-separated paths), `WORKFLOW_SYNC_MAX_DEPTH`, `WORKFLOWS_BRANCH`, `NON_INTERACTIVE=true` (auto-clone when Workflow-Scripts missing).

Configure via `PROJECTS[]` in the script, `--auto`, or the env vars above.

## Orchestrator

### `orchestrator-review.sh`

```bash
./00-Meta-Workflow/00-orchestrator/orchestrator-review.sh <plan.md> [-m <model>] [options]
```

Launches non-interactive OpenCode for plan review. Requires OpenCode CLI installed. Default output: `<plan-dir>/<plan-name>.reviews/<timestamp>-<focus>-review.md`. See [00-Meta-Workflow/00-orchestrator/README.md](../../../00-Meta-Workflow/00-orchestrator/README.md).

## Workflow Interfaces

Each workflow Markdown file defines:

| Section | Content |
|---------|---------|
| Purpose | When to use |
| Inputs | Required context (paths, goals) |
| Steps | Phased execution with parallel agent guidance |
| Outputs | Report paths, changelog updates |
| Acceptance criteria | Completion checks |

Output reports follow `{type}-YYMMDD-HHMM-{model}.md` per [naming-conventions.md](../../../00-Meta-Workflow/00-meta/naming-conventions.md). **Plans** → `<metadata-root>/plans/`; **review/audit/research reports** → `<metadata-root>/research/`.

## `@ai-sdk/image-generation`

Embedded package at `08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/`.

| Module | Responsibility |
|--------|----------------|
| `src/index.ts` | Public exports |
| `src/core/generator.ts` | Image generation orchestration |
| `src/core/registry.ts` | Provider registry |
| `src/providers/*` | OpenAI, Google, xAI, Fal adapters |
| `src/config/` | Provider configuration |

Run tests: `npm test` from package directory (vitest).

## Reference Index

| Topic | Location |
|-------|----------|
| AI SDK integration guide | `08-API-Integration/02-AI-SDK/ai-sdk-integration-v2.md` |
| Service providers | `08-API-Integration/02-AI-SDK/service-providers/` |
| Genkit guide | `08-API-Integration/01-genkit/genkit-integration-guide.md` |
| Higgsfield MCP | `08-API-Integration/03-higgsfield-mcp/` |
| Gemini API reference | `10-technical-docs/Gemini/` |

## Authentication and Authorization

Not applicable at the Workflow-Scripts repo level. Consumer API keys are documented in `08-API-Integration/` provider guides — never commit secrets.

## Errors

Shell scripts exit non-zero on failure with stderr messages. Orchestrator writes status JSON on failure. Image-generation package throws typed errors per provider — see package `tests/unit/`.