# Workflow-Scripts Ops Meta Guidelines

Agent instructions for work scoped to Workflow-Scripts operational metadata under `00-project/` and related repository management.

## Execution

- Where possible, make clever and appropriate use of multiple parallel agents to orchestrate and execute tasks for better efficiency.
- Parallel agents can be used for scanning archives, reviewing documentation, testing hypotheses during debugging, and validating changes across multiple files concurrently.
- Always verify findings from parallel agents before acting on them.
- **Bugs:** add regression test when it fits.

## Repository Management

**This workspace spans multiple related repositories.** Workflow-Scripts is the nested companion; Update-AI-Tools is the parent application repo.

### 1. Update-AI-Tools Repository (parent)
- **Location**: `/Users/jesse/Development/Personal/Update-AI-Tools`
- **Purpose**: Main application repo; hosts nested companion directories such as `Workflow-Scripts/`
- **Git Remote**: `https://github.com/Rebooted-Dev/Update-AI-Tools`

**Standard Git Operations:**

```bash
# From Update-AI-Tools repository root
git status
git pull
git add .
git commit -m "feat: description of changes"
git push
```

### 2. Workflow-Scripts Repository (companion)
- **Location**: `Workflow-Scripts/` within the Update-AI-Tools project directory
- **Purpose**: Shared workflow instructions, templates, scripts, active WDF library, and ops `00-project/` meta
- **Git Remote**: `https://github.com/Rebooted-Dev/Workflow-Scripts`

**Standard Git Operations:**

```bash
# From Update-AI-Tools root, go into Workflow-Scripts
cd Workflow-Scripts

git status
git pull
git add .
git commit -m "docs: update workflow description"
git push
```

### 3. Active library vs metadata roles

| Path | Role |
|------|------|
| `workflows-drag-free/` | **Active** WDF workflow library — edit workflows, catalog, router, and skills here |
| `00-project/` | **Ops metadata** for whole-repository Workflow-Scripts history and operations |
| `workflows-drag-free/00-project/` | **Package metadata** for WDF design, migration evidence, and package logs |

**Retired consolidation path:**

- **`00-project/Drag-Free-v2/` was retired on 2026-07-10.** Do not recreate it. It is not a live workflow tree and not a current consolidation workspace.
- Frozen snapshot: `00-project/build/archive/drag-free-v2-promotion-snapshot-2026-07-10.tar.gz`
- Salvage inventory: `00-project/build/archive/2026-07-10-drag-free-v2-salvage-inventory.md`
- Drag-Free design plans that were completed live under `workflows-drag-free/00-project/changelog/plans/`.

## Change Management

- Unless instructed by the developer, do not make code changes to consumer-project application code from this workspace.
- **After changes to Workflow-Scripts ops meta (`00-project/`):** Update the changelog and/or troubleshooting using `00-project/changelog/` and `00-project/troubleshooting/` (one file per entry, update the relevant index). Add a **troubleshooting** entry only when the work involved a bug, an issue that required debugging/workarounds, or a non-trivial problem; use changelog only for simple doc or workflow updates. For bug/issue/non-trivial fixes, create **both** a troubleshooting entry and a changelog entry. See **[Changelog & Troubleshooting](docs/agents/changelog-and-troubleshooting.md)**.
- **After changes to WDF package meta:** log under `workflows-drag-free/00-project/changelog/` (and package troubleshooting when applicable).

## Tracked Repositories

The Workflow-Scripts development environment tracks **2 repositories**:

1. **Update-AI-Tools** (Primary, parent repository root) — `main` branch
2. **Workflow-Scripts** (Companion, `Workflow-Scripts/`) — `main` branch

See **[Repository Map](docs/agents/repository-map.md)** for paths, remotes, and sync instructions.

## Detailed Documentation

- **[Changelog & Troubleshooting](docs/agents/changelog-and-troubleshooting.md)** — Full conventions for `changelog/`, `troubleshooting/`, and `plans-completed/`
- **[Repository Map](docs/agents/repository-map.md)** — Repo paths, remotes, metadata roles, and sync instructions
- **`workflows-drag-free/00-setup/`** — Initial setup workflows (project setup, skills, MCP, repo map, migration)
- **`plans/README.md`** — Map to project directory; active plans
- **`plans/TODO.md`** — Current tasks and filing reference
