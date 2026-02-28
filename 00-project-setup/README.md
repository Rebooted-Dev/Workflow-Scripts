# Initial Setup Workflows

This directory contains workflows for setting up new projects and optimizing existing workflow scripts.

## Workflow Index

| File | Purpose | When to Use |
|------|---------|-------------|
| [`01-setup-project.md`](./01-setup-project.md) | Set up new project with **multiple repositories** (multi-repo) and troubleshooting system | New projects, migrating existing projects to use these workflows |
| [`02-optimize-workflow-scripts.md`](./02-optimize-workflow-scripts.md) | Analyze, optimize, and verify workflow scripts | Periodic maintenance, after workflows accumulate, before sharing workflows |
| [`03-sync-workflow-scripts.md`](./03-sync-workflow-scripts.md) | Automate syncing Workflow-Scripts across multiple projects | When managing multiple projects, want to update all at once, or need to track sync status |
| [`04-track-repos-and-agent-map.md`](./04-track-repos-and-agent-map.md) | Discover repos in the project and set up agent files (AGENTS.md, CLAUDE.md, GEMINI.md) with a repo map and sync/push/pull instructions | New projects with multiple repos, onboarding agents, or when adding a new nested repo |
| [`05-mcp-and-config-setup.md`](./05-mcp-and-config-setup.md) | MCP and config setup: Google Developer Knowledge MCP (Cursor + OpenCode), fix Cursor stdio PATH, OpenCode default model, oh-my-opencode overrides | Setting up or fixing MCP servers, adding Gemini docs MCP, or setting default model (e.g. GLM 5) |

## Quick Decision Guide

**Are you setting up a new project or adding workflows to an existing project?**
- Yes → Use [`01-setup-project.md`](./01-setup-project.md)

**Are you reviewing/cleaning up existing workflow scripts?**
- Yes → Use [`02-optimize-workflow-scripts.md`](./02-optimize-workflow-scripts.md)

**Do you have multiple projects and want to sync Workflow-Scripts across all of them?**
- Yes → Use [`03-sync-workflow-scripts.md`](./03-sync-workflow-scripts.md)

**Do you need to list all repos in this project and document them for agents (AGENTS.md, CLAUDE.md, GEMINI.md) with sync/push/pull instructions?**
- Yes → Use [`04-track-repos-and-agent-map.md`](./04-track-repos-and-agent-map.md)

**Are you setting up MCP servers (e.g. Google Developer Knowledge), fixing Cursor MCP errors, or setting OpenCode/oh-my-opencode default model?**
- Yes → Use [`05-mcp-and-config-setup.md`](./05-mcp-and-config-setup.md)

## Workflow Summaries

### 01-setup-project.md

Sets up a project with dual repo management, `troubleshooting/` and `changelog/` directory systems, `plans/` and `plans-completed/`, slim AGENTS.md/CLAUDE.md/GEMINI.md (with `docs/agents/`), and a repo map in agent files. Includes backups of existing troubleshooting/changelog files and verification steps. Run [04-track-repos-and-agent-map.md](./04-track-repos-and-agent-map.md) after setup to populate the repo map.

### 02-optimize-workflow-scripts.md

Provides a systematic process for:
- **Eliminating redundancy** - Consolidate overlapping content
- **Resolving contradictions** - Remove conflicting instructions
- **Clarifying ambiguities** - Make instructions precise
- **Improving organization** - Better navigation and structure

Phases:
1. Analysis and Assessment
2. Strategy Development
3. Implementation
4. Verification
5. Documentation

### 03-sync-workflow-scripts.md

Automates syncing Workflow-Scripts across multiple projects:
- **Multi-Project Management** - Update all projects with one command
- **Status Checking** - See which projects are behind or ahead
- **Safety Features** - Handles uncommitted changes, detached HEAD, conflicts
- **Flexible Options** - Dry-run, verbose, status-only modes

Key features:
1. Automated git pull across all projects
2. Error handling and reporting
3. Status checking without making changes
4. Auto-discovery of projects (optional)
5. Integration with existing workflows

### 04-track-repos-and-agent-map.md

Discover and document all Git repositories in the project and configure agent files:
- **Repo discovery** – Find all `.git` directories and list path, remote URL, branch
- **Agent-file repo map** – Add a “Tracked Repositories” section to AGENTS.md, CLAUDE.md, and GEMINI.md with directory → URL, purpose, status
- **Sync / push / pull** – Document when to sync and per-repo Git commands; reference project-specific sync scripts (e.g. `sync-repo.sh`) and multi-project Workflow-Scripts sync (03)

Key steps:
1. Run discovery commands to list all repos
2. Add or update the repository map in agent files (or link to `docs/agents/repository-map.md`)
3. Document sync, pull, and push procedures for each repo
4. Optionally add a “Repository Management” section with clear per-repo instructions

### 05-mcp-and-config-setup.md

Task list for MCP and configuration setup:
- **Workflow-Scripts sync** – Pull latest workflows (e.g. `pull-workflows.sh` or `git pull` in Workflow-Scripts)
- **Google Developer Knowledge MCP** – Enable API, enable MCP, create key; add to Cursor and OpenCode
- **Cursor MCP** – Add remote MCP; fix stdio server errors with full paths to npx/uvx
- **OpenCode** – Add MCP, set default `model` (e.g. `zai-coding-plan/glm-5`), ensure Z.AI auth
- **oh-my-opencode** – Override Sisyphus and unspecified categories to desired model when plugin overrides OpenCode default
- **Verification** – Confirm tools enabled, UI shows correct model, Developer Knowledge tools respond

## Related Workflows

- [Sync Documentation](../04-documentation/02-sync-documentation.md) - Keep documentation in sync with code
- [Code Review](../05-review-audit/01-code-review.md) - Code quality review

## Notes

- **Backup before changes** – All workflows preserve existing data; setup backs up single-file CHANGELOG/TROUBLESHOOTING when present.
- **Placeholders** – In 01 and 04, replace `<PROJECT_PATH>`, `<WORKFLOWS_DIR>`, etc. with your values (see Prerequisites in each file).
- **02-optimize** – Applicable to any workflow directory. **03-sync** – Requires bash and git; customize the PROJECTS array with your paths.
