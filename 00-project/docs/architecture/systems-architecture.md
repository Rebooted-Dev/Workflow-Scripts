# Systems Architecture

## Context and Goals

Workflow-Scripts provides **repeatable, priority-ordered development processes** for AI agents and human contributors. It is designed to be:

1. **Cloned into host projects** as a nested git repository (multi-repo model)
2. **Pulled independently** so workflow updates do not require main-app releases
3. **Self-documenting** via Markdown workflows, rubrics, and meta docs under `00-project/`

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     Host Project (e.g. Update-AI-Tools)          │
│  ┌──────────────────────┐    ┌──────────────────────────────┐   │
│  │ Main app repository  │    │ Workflow-Scripts/ (nested)   │   │
│  │ (tracked by host)    │    │ (separate git repo, gitignored)│  │
│  └──────────────────────┘    └──────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

The host `.gitignore` excludes `Workflow-Scripts/` so `git add .` from the host root never stages workflow files.

## Components and Boundaries

| Component | Location | Responsibility |
|-----------|----------|----------------|
| Workflow categories | `00-*` … `12-*` | Instruction documents for planning, build, debug, docs, review, security, deployment, API integration |
| Meta workflow | `00-Meta-Workflow/` | Orchestrator, rubrics, naming conventions, generated reports |
| Project setup | `00-project-setup/` | Bootstrap consumer projects, sync, MCP, skills |
| Skills | `11-Skills/` | Thin Codex skill triggers over deep workflows |
| Shell scripts | `scripts/` | Pull, push, multi-project sync, validation |
| Meta workspace | `00-project/` | Changelog, troubleshooting, plans, docs for Workflow-Scripts itself |
| Reference libraries | `07-deployment/`, `08-API-Integration/`, `10-technical-docs/`, `12-SEO-GEO-checklist/` | Consumer-oriented guides (not Workflow-Scripts runtime) |

## Key Workflows

### Instruction lifecycle

```
Goal → Research & Plan → Plan Review → Finalise → Execution → Confirm → Review → Documentation
```

Each phase references the shared [severity-priority rubric](../../../00-Meta-Workflow/00-meta/severity-priority-rubric.md) (P0–P3, S0–S3).

### Orchestrator delegation

```
Orchestrator agent
    │
    ▼
orchestrator-review.sh  ──▶  OpenCode (non-interactive, alternate model)
    │
    ▼
Captured review output  ──▶  <plan-dir>/<plan-name>.reviews/  (orchestrator)
Review/audit reports    ──▶  <metadata-root>/research/
Implementation plans    ──▶  <metadata-root>/plans/
```

### Change logging (Workflow-Scripts meta)

```
Code/doc change  ──▶  00-project/changelog/<type>/<date>-<type>-<title>.md
                 ──▶  00-project/changelog/index.md (new row at top)

Bug fix          ──▶  00-project/troubleshooting/<category>/...
                 ──▶  + changelog entry
```

## External Dependencies

| Dependency | Used by | Notes |
|------------|---------|-------|
| Git | All sync scripts | ff-only pull, dirty-tree guards |
| OpenCode CLI | `orchestrator-review.sh` | Optional; for delegated reviews |
| Node.js | `check-active-markdown-links.sh`, `@ai-sdk/image-generation` | Validation and embedded package |
| Consumer build tools | Execution workflows | npm/build assumed in host projects, not this repo |

## Deployment Topology (High-Level)

Workflow-Scripts has **no cloud deployment**. Distribution is:

1. GitHub: `https://github.com/Rebooted-Dev/Workflow-Scripts`
2. Per-host clone under `Workflow-Scripts/` or `workflows/`
3. Optional multi-project sync via `scripts/sync-workflow-scripts.sh`

See [Deployment documentation](../deployment/README.md) for runbooks.

## Notes / Open Questions

- Root `CHANGELOG.md` was removed after migration to `00-project/changelog/` (2026-07-03).
- Dual plan indexes (`00-Meta-Workflow/00-plans*` vs `00-project/plans*`) — optional consolidation tracked in `00-project/plans/TODO.md`.
- Some bundled reference-library READMEs still reference removed `09-11 Misc/` paths; files live under `08-API-Integration/`.
- Deep review remediation (2026-07-03) added `agent-spawning-policy.md`, three validation scripts, and standardized `<metadata-root>/research/` routing for review outputs.