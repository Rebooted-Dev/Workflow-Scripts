# Workflow-Scripts Meta Guidelines

Agent instructions for work scoped to the Workflow-Scripts repository and its `00-project/` meta directory.

## Execution

- Where possible, make clever and appropriate use of multiple parallel agents to orchestrate and execute tasks for better efficiency.
- Parallel agents can be used for scanning workflows, reviewing documentation, testing hypotheses during debugging, and validating changes across multiple files concurrently.
- Always verify findings from parallel agents before acting on them.
- **Bugs:** add regression test when it fits.

## Repository Management

**This is a single repository.** Workflow-Scripts is one git repo; `00-project/` is a tracked subdirectory within it, not a separate repository.

- **Location**: `/Workflow-Scripts/` (repository root)
- **Purpose**: Reusable workflow instructions, templates, and Workflow-Scripts project meta under `00-project/`
- **Git Remote**: `https://github.com/Rebooted-Dev/Workflow-Scripts`

**Standard Git Operations:**

```bash
# From Workflow-Scripts repository root
git status
git pull
git add .
git commit -m "docs: description of changes"
git push
```

**When working on Workflow-Scripts meta** (`00-project/`):

- Changelog, plans, troubleshooting, and docs live directly under `00-project/`.
- Workflow instruction files remain in their topical directories at repo root (e.g. `00-project-setup/`, `04-documentation/`).

## Change Management

- Unless instructed by the developer, do not make code changes to consumer-project application code from this repo.
- **After changes to Workflow-Scripts or `00-project/`:** Update the changelog and/or troubleshooting using `00-project/changelog/` and `00-project/troubleshooting/` (one file per entry, update the relevant index). Add a **troubleshooting** entry only when the work involved a bug, an issue that required debugging/workarounds, or a non-trivial problem; use changelog only for simple doc or workflow updates. For bug/issue/non-trivial fixes, create **both** a troubleshooting entry and a changelog entry. See **[Changelog & Troubleshooting](docs/agents/changelog-and-troubleshooting.md)**.

## Tracked Repositories

The Workflow-Scripts development environment tracks **1 repository**:

1. **Workflow-Scripts** (Primary, repository root) — `main` / `v1.6` branch

See **[Repository Map](docs/agents/repository-map.md)** for paths, remotes, and sync instructions.

## Detailed Documentation

- **[Changelog & Troubleshooting](docs/agents/changelog-and-troubleshooting.md)** — Full conventions for `changelog/`, `troubleshooting/`, and `plans-completed/`
- **[Repository Map](docs/agents/repository-map.md)** — Repo path, remote, and sync instructions
- **`plans/README.md`** — Map to project directory; active plans
- **`plans/TODO.md`** — Current tasks and filing reference