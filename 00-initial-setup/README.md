# Initial Setup Workflows

This directory contains workflows for setting up new projects and optimizing existing workflow scripts.

## Workflow Index

| File | Purpose | When to Use |
|------|---------|-------------|
| [`01-setup-project.md`](./01-setup-project.md) | Set up new project with dual repository management and troubleshooting system | New projects, migrating existing projects to use these workflows |
| [`02-optimize-workflow-scripts.md`](./02-optimize-workflow-scripts.md) | Analyze, optimize, and verify workflow scripts | Periodic maintenance, after workflows accumulate, before sharing workflows |
| [`03-sync-workflow-scripts.md`](./03-sync-workflow-scripts.md) | Automate syncing Workflow-Scripts across multiple projects | When managing multiple projects, want to update all at once, or need to track sync status |

## Quick Decision Guide

**Are you setting up a new project or adding workflows to an existing project?**
- Yes → Use [`01-setup-project.md`](./01-setup-project.md)

**Are you reviewing/cleaning up existing workflow scripts?**
- Yes → Use [`02-optimize-workflow-scripts.md`](./02-optimize-workflow-scripts.md)

**Do you have multiple projects and want to sync Workflow-Scripts across all of them?**
- Yes → Use [`03-sync-workflow-scripts.md`](./03-sync-workflow-scripts.md)

## Workflow Summaries

### 01-setup-project.md

Sets up a project with:
- **Dual Repository Management** - Main project repo + Workflow-Scripts as a nested repo
- **Troubleshooting System** - Organized `troubleshooting/` directory structure
- **AGENTS.md Configuration** - Instructions for AI agents to manage both repos

Key steps:
1. Configure AGENTS.md with repository management instructions
2. Set up `.gitignore` to exclude workflows directory
3. Create troubleshooting directory structure
4. Back up any existing troubleshooting files
5. Verify setup

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

## Related Workflows

- [Sync Documentation](../04-documentation/02-sync-documentation.md) - Keep documentation in sync with code
- [Code Review](../05-review-audit/01-code-review.md) - Code quality review

## Notes

- All workflows emphasize **backup before changes** - always preserve existing data
- The setup workflow uses placeholders (`<PROJECT_NAME>`, `<PROJECT_PATH>`, etc.) that should be replaced with actual values
- The optimization workflow can be applied to any workflow directory, not just this one
- The sync script requires bash and git, and should be customized with your actual project paths
