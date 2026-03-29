# User Manual

## Who This Is For

This manual is for developers and teams who want to use Workflow-Scripts to standardize their AI-assisted development process. You do not need to understand the internal code — just how to set up and run workflows.

## What You Can Do

- Set up structured workflows for planning, building, reviewing, debugging, and documenting code
- Use consistent priority scoring (P0-P3) across all tasks
- Automate plan reviews with the orchestrator
- Sync workflows across multiple projects
- Keep documentation in sync with code changes

## Quick Start

### 1. Clone into Your Project

```bash
cd /path/to/your-project
git clone https://github.com/Rebooted-Dev/Workflow-Scripts Workflow-Scripts
```

### 2. Ignore in Your Main Repo

Add to your project's `.gitignore`:

```gitignore
Workflow-Scripts/
```

### 3. Read the Master Index

Open `Workflow-Scripts/README.md` — it contains:
- A decision table for choosing the right workflow
- Detailed descriptions of all workflows
- Best practices and conventions

### 4. Start Your First Workflow

For new work, start here:

```
Workflow-Scripts/01-planning/00-research-and-plan.md
```

This workflow guides you through research and plan creation.

## Common Workflows

### Adding a New Feature

```
1. Planning     → 01-planning/00-research-and-plan.md
2. Plan Review  → 01-planning/01-plan-review.md
3. Refine Plan  → 01-planning/02-finalise-plan.md
4. Implement    → 02-build-code/01-execution.md
5. Code Review  → 05-review-audit/01-code-review.md
6. Docs         → 04-documentation/02-sync-documentation.md
```

### Fixing a Bug

```
1. Debug        → 03-debug/02-bug-fix-workflow.md
2. Code Review  → 05-review-audit/01-code-review.md
3. Docs (if needed) → 04-documentation/02-sync-documentation.md
```

### Security Audit

```
1. Security Review → 06-security/01-security-review.md
2. Security Fix    → 06-security/02-security-fix.md (for P0/S0 issues)
3. Code Review     → 05-review-audit/01-code-review.md
```

### Performance Optimization

```
1. Optimization Review → 05-review-audit/02-code-optimization.md
2. Planning            → 01-planning/02-finalise-plan.md
3. Implementation      → 02-build-code/01-execution.md
4. Refactoring Review  → 05-review-audit/03-code-refactoring.md
```

## Keeping Workflows Updated

### Pull Updates (Recommended)

```bash
./Workflow-Scripts/pull-workflows.sh
```

Or manually:

```bash
cd Workflow-Scripts
git pull --ff-only
```

### Sync Across Multiple Projects

```bash
./Workflow-Scripts/sync-workflow-scripts.sh --auto
```

See [Helper Scripts](../helper-scripts/README.md) for all script options.

## Priority System

All workflows use a consistent priority system:

| Priority | Meaning | When to Fix |
|----------|---------|-------------|
| **P0** | Blocker | Before merge |
| **P1** | Urgent | Before release |
| **P2** | Soon | Next sprint |
| **P3** | Backlog | Track and defer |

Severity is scored separately (S0 Critical → S3 Low). See `00-meta/severity-priority-rubric.md` for the full rubric.

## Project Outputs

Workflows produce outputs in your project's directory:

| Output | Location | Purpose |
|--------|----------|---------|
| Plans | `plans/` | Implementation plans and review reports |
| Changelog | `project/changelog/` or `docs/CHANGELOG.md` | Change history |
| Troubleshooting | `project/troubleshooting/` | Bug investigations and fixes |
| Documentation | `docs/` | Project documentation |

## Troubleshooting

### Workflow file not found
Ensure you cloned Workflow-Scripts into your project root and the path is correct.

### Git pull fails in Workflow-Scripts
The repo may have local changes. Run `cd Workflow-Scripts && git stash` to stash them, then pull again.

### Sync script says "PROJECTS array is empty"
Edit `sync-workflow-scripts.sh` and update the PROJECTS array with your project paths, or use `--auto`.

## FAQ

**Q: Do I need to commit Workflow-Scripts to my project repo?**
A: No. Workflow-Scripts is a separate git repository. Add it to `.gitignore`.

**Q: Can I customize workflows for my project?**
A: Yes. Fork the repository or modify locally. Use `update-workflows.sh` to push changes back if you are a maintainer.

**Q: Which workflow should I start with?**
A: For new work: `01-planning/00-research-and-plan.md`. For bug fixes: `03-debug/02-bug-fix-workflow.md`. For code review: `05-review-audit/01-code-review.md`.

**Q: How do I keep workflows in sync across projects?**
A: Use `sync-workflow-scripts.sh --auto` or set up the PROJECTS array in the script.
