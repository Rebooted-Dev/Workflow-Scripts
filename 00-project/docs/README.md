# Workflow-Scripts Documentation

**Status:** ✅ COMPLETED

Central navigation for Workflow-Scripts — a reusable workflow instruction library for AI-assisted development, maintained as its own git repository and cloned into host projects.

## Start Here

| Audience | Start with |
|----------|------------|
| **Host project developers** | [User Manual](./user-manual.md) — clone, pull updates, pick workflows |
| **Workflow-Scripts maintainers** | [Deployment & Sync](./deployment/README.md) — publish changes, multi-project sync |
| **AI agents** | [Agent conventions](./agents/changelog-and-troubleshooting.md) + `00-project/AGENTS.md` |
| **New to the repo layout** | [File Map](./architecture/file-map.md) |

## For Users

- [User Manual](./user-manual.md) — when to use each workflow, typical sequences, skills vs full workflows
- [Tutorials](./tutorials/getting-started.md) — step-by-step first-run guide
- Root [README.md](../../README.md) — category index and quick-start table
- [SHARING_AND_SYNC.md](../../SHARING_AND_SYNC.md) — multi-repo clone model

## For Developers

- [Systems Architecture](./architecture/systems-architecture.md) — multi-repo model, workflow lifecycle, orchestrator
- [Code Architecture](./architecture/code-architecture.md) — scripts, validation, embedded TypeScript package
- [File Map](./architecture/file-map.md) — annotated directory tree
- [Modules](./code/modules.md) — scripts, orchestrator, skills, `@ai-sdk/image-generation`
- [API / Interfaces](./api/README.md) — CLI scripts, orchestrator, library exports (no HTTP API)
- [Testing](./testing/README.md) — validation scripts and package unit tests

## For Maintainers

- [Deployment & Sync](./deployment/README.md) — pull, push, multi-project sync
- [Changelog system](../changelog/README.md) — one file per change under `00-project/changelog/`
- [Troubleshooting system](../troubleshooting/README.md) — bug/issue knowledge base
- [Agent conventions](./agents/changelog-and-troubleshooting.md) — "update the logs" rules
- [Repository Map](./agents/repository-map.md) — paths, remote, branches

## Reference Libraries (in repo root)

These are consumer-oriented guides bundled with Workflow-Scripts, not meta docs for `00-project/`:

| Directory | Purpose |
|-----------|---------|
| `07-deployment/` | Electron, Firebase, port management, pre-deploy checklists |
| `08-API-Integration/` | Genkit, AI SDK, Higgsfield MCP, service provider reference |
| `10 Technical Docs/Gemini/` | Offline Gemini API reference |
| `12-SEO-GEO-checklist/` | SEO/GEO automation and monitoring tasks |
| `11-Skills/` | Codex skill bundles wrapping recurring workflows |

## Glossary

See [00-Meta-Workflow/00-meta/glossary.md](../../00-Meta-Workflow/00-meta/glossary.md) for P0–P3, S0–S3, multi-repo, and task-marking conventions.