# Drag-Free-v2 Consolidation Meta Guidelines

Agent instructions for work scoped to the Drag-Free-v2 Workflow-Scripts consolidation workspace and its `00-project/` meta directory.

## Execution

- Where possible, make clever and appropriate use of multiple parallel agents to orchestrate and execute tasks for better efficiency.
- Parallel agents can be used for scanning archives, reviewing documentation, testing hypotheses during debugging, and validating changes across multiple files concurrently.
- Always verify findings from parallel agents before acting on them.
- **Bugs:** add regression test when it fits.

## Repository Management

**This workspace spans multiple related repositories.** The consolidation archive lives under Update-AI-Tools; Workflow-Scripts is the source repo being consolidated.

### 1. Update-AI-Tools Repository (parent)
- **Location**: `/Users/jesse/Development/Personal/Update-AI-Tools`
- **Purpose**: Main application repo; hosts `Drag-Free-v2/` consolidation output
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

### 2. Workflow-Scripts Repository (source)
- **Location**: `Workflow-Scripts/` within the Update-AI-Tools project directory
- **Purpose**: Shared workflow instructions, templates, scripts, and `00-project/` meta for Workflow-Scripts itself
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

### 3. Workflow-Scripts-consolidated (this workspace)
- **Location**: `Drag-Free-v2/Workflow-Scripts-consolidated/` within Update-AI-Tools
- **Purpose**: Archive and consolidation workspace for Drag-Free-v2; `00-project/` holds operational records for this effort
- **Note**: Not a separate git repository. Tracked as part of Update-AI-Tools when committed.

**When working on consolidation meta** (`00-project/`):

- Changelog, plans, troubleshooting, and docs live directly under `00-project/`.
- Imported Workflow-Scripts `00-project` records now live directly under matching directories in this merged metadata root. Treat them as historical/source-system records unless the current task explicitly promotes them into active Drag-Free-v2 work.
- Promoted Workflow-Scripts files live at the `Drag-Free-v2/` root. Consolidation evidence, ignored generated skill bundles, logs, and pre-promotion patch/status snapshots remain under `Workflow-Scripts-consolidated/`.

## Change Management

- Unless instructed by the developer, do not make code changes to consumer-project application code from this workspace.
- **After changes to consolidation artifacts or `00-project/`:** Update the changelog and/or troubleshooting using `00-project/changelog/` and `00-project/troubleshooting/` (one file per entry, update the relevant index). Add a **troubleshooting** entry only when the work involved a bug, an issue that required debugging/workarounds, or a non-trivial problem; use changelog only for simple doc or workflow updates. For bug/issue/non-trivial fixes, create **both** a troubleshooting entry and a changelog entry. See **[Changelog & Troubleshooting](docs/agents/changelog-and-troubleshooting.md)**.

## Tracked Repositories

The Drag-Free-v2 consolidation environment tracks **2 repositories**:

1. **Update-AI-Tools** (Primary, repository root) — `main` branch
2. **Workflow-Scripts** (Companion, `Workflow-Scripts/`) — `main` branch

See **[Repository Map](docs/agents/repository-map.md)** for paths, remotes, and sync instructions.

## Detailed Documentation

- **[Changelog & Troubleshooting](docs/agents/changelog-and-troubleshooting.md)** — Full conventions for `changelog/`, `troubleshooting/`, and `plans-completed/`
- **[Repository Map](docs/agents/repository-map.md)** — Repo paths, remotes, and sync instructions
- **`00-project-setup/`** — Initial setup workflows (project setup, skills, MCP, repo map, migration)
- **`plans/README.md`** — Map to project directory; active plans
- **`plans/TODO.md`** — Current tasks and filing reference
