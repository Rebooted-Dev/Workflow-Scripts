# workflows-drag-free Meta Guidelines

Agent instructions for work scoped to **workflows-drag-free** and its `00-project/` meta directory.

## Execution

- Where possible, make clever and appropriate use of multiple parallel agents to orchestrate and execute tasks for better efficiency.
- Parallel agents can be used for scanning workflows, reviewing documentation, testing hypotheses during debugging, and validating changes across multiple files concurrently.
- Always verify findings from parallel agents before acting on them.
- **Bugs:** add regression test when it fits.

## Repository Management

**This workspace spans multiple related repositories.** The drag-free workflow tree lives inside Workflow-Scripts; Update-AI-Tools is the parent project directory on disk.

### 1. Workflow-Scripts Repository (primary for this tree)
- **Location**: `Workflow-Scripts/` within the Update-AI-Tools project directory  
  (`/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts`)
- **Purpose**: Shared workflow instructions, templates, scripts; hosts `workflows-drag-free/` and this `00-project/` meta
- **Git Remote**: `https://github.com/Rebooted-Dev/Workflow-Scripts`

**Standard Git Operations:**

```bash
cd /Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts

git status
git pull
git add workflows-drag-free/
git commit -m "docs: update workflow description"
git push
```

### 2. Update-AI-Tools Repository (parent)
- **Location**: `/Users/jesse/Development/Personal/Update-AI-Tools`
- **Purpose**: Main application repo; may host related Drag-Free-v2 archives
- **Git Remote**: `https://github.com/Rebooted-Dev/Update-AI-Tools`
- **Note**: `Workflow-Scripts/` is typically ignored by the parent repo so the main app never tracks workflow files.

**When working on workflows-drag-free meta** (`00-project/`):

- Changelog, plans, troubleshooting, and docs live **directly under** `00-project/` (flattened layout).
- Do not nest a second `project/` wrapper under this directory.
- Prefer paths relative to `00-project/` in indexes and agent docs.

**Completed plans filing rule:** When a plan is completed or when asked to "file" it as completed, **move** it from `plans/` or `build/` to **`plans-completed/<category>/`**, update **`plans-completed/index.md`**, and add a row at the top of **`changelog/index.md`** with Type=plan and File `../plans-completed/<category>/<filename>`. If the user explicitly asks for **`changelog/plans/`**, use File `plans/...` instead. See `docs/agents/changelog-and-troubleshooting.md` (§ Plans completed).

## Change Management

- Unless instructed by the developer, do not make code changes to consumer-project application code from this workspace.
- **After changes to workflows-drag-free or `00-project/`:** Update the changelog and/or troubleshooting using `changelog/` and `troubleshooting/` (one file per entry, update the relevant index). Add a **troubleshooting** entry only when the work involved a bug, an issue that required debugging/workarounds, or a non-trivial problem; use changelog only for simple doc or workflow updates. For bug/issue/non-trivial fixes, create **both** a troubleshooting entry and a changelog entry. See **[Changelog & Troubleshooting](docs/agents/changelog-and-troubleshooting.md)**.

## Tracked Repositories

This environment tracks **2 repositories**:

1. **Workflow-Scripts** (Primary for this tree, `Workflow-Scripts/`) — hosts `workflows-drag-free/`
2. **Update-AI-Tools** (Parent, repository root) — main application repo

See **[Repository Map](docs/agents/repository-map.md)** for paths, remotes, and sync instructions.

## Detailed Documentation

- **[Changelog & Troubleshooting](docs/agents/changelog-and-troubleshooting.md)** — Full conventions for `changelog/`, `troubleshooting/`, and `plans-completed/`
- **[Repository Map](docs/agents/repository-map.md)** — Repo paths, remotes, and sync instructions
- **[Project Structure](docs/agents/project-structure.md)** — Tree layout
- **[Development Workflow](docs/agents/development-workflow.md)** — How to work in this tree
- **[Coding Standards](docs/agents/coding-standards.md)**
- **[Testing Strategy](docs/agents/testing-strategy.md)**
- **[Commit & PR Workflow](docs/agents/commit-workflow.md)**
- **[Documentation Workflow](docs/agents/documentation-workflow.md)**
- **[Security Guidelines](docs/agents/security-guidelines.md)**
- **`../00-setup/`** — Initial setup workflows (project setup, skills, MCP, repo map, migration)
- **`plans/README.md`** — Map to project directory; active plans
- **`plans/TODO.md`** — Current tasks and filing reference
