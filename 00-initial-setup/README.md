# Initial Setup Workflows

This directory contains workflows for setting up new projects and optimizing existing workflow scripts.

## Workflow Index

| File | Purpose | When to Use |
|------|---------|-------------|
| [`01-setup-project.md`](./01-setup-project.md) | Set up new project with dual repository management and troubleshooting system | New projects, migrating existing projects to use these workflows |
| [`02-optimize-workflow-scripts.md`](./02-optimize-workflow-scripts.md) | Analyze, optimize, and verify workflow scripts | Periodic maintenance, after workflows accumulate, before sharing workflows |

## Quick Decision Guide

**Are you setting up a new project or adding workflows to an existing project?**
- Yes → Use [`01-setup-project.md`](./01-setup-project.md)

**Are you reviewing/cleaning up existing workflow scripts?**
- Yes → Use [`02-optimize-workflow-scripts.md`](./02-optimize-workflow-scripts.md)

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

## Related Workflows

- [Sync Documentation](../04-documentation/sync-documentation.md) - Keep documentation in sync with code
- [Code Review](../05-review-audit/01-code-review.md) - Code quality review

## Notes

- Both workflows emphasize **backup before changes** - always preserve existing data
- The setup workflow uses placeholders (`<PROJECT_NAME>`, `<PROJECT_PATH>`, etc.) that should be replaced with actual values
- The optimization workflow can be applied to any workflow directory, not just this one
