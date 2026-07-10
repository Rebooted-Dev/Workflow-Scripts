# Repository Map (workflows-drag-free)

## Tracked Repositories

| # | Name | Directory | Remote URL | Branch |
|---|------|-----------|------------|--------|
| 1 | Update-AI-Tools | `/Users/jesse/Development/Personal/Update-AI-Tools` | `https://github.com/Rebooted-Dev/Update-AI-Tools` | `main` |
| 2 | Workflow-Scripts | `Workflow-Scripts/` (within Update-AI-Tools) | `https://github.com/Rebooted-Dev/Workflow-Scripts` | branch as checked out |

## Purpose

- **Update-AI-Tools (parent)** — Main application repository; may host related consolidation archives under `Drag-Free-v2/`.
- **Workflow-Scripts (primary for this meta)** — Shared workflow repository. **workflows-drag-free** and this `00-project/` meta live inside it.

`workflows-drag-free/00-project/` is **not** a separate git repository. It is a subdirectory of Workflow-Scripts.

## Sync instructions

```bash
# Workflow-Scripts — where workflows-drag-free lives
cd /Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts
git status
git pull
git add workflows-drag-free/00-project/
git commit -m "docs: update workflows-drag-free project meta"
git push

# Update-AI-Tools — parent application repo (if needed)
cd /Users/jesse/Development/Personal/Update-AI-Tools
git pull
# Workflow-Scripts/ is typically ignored by the parent repo
```

## Meta workspace paths

When working on workflows-drag-free operational records, use paths under `Workflow-Scripts/workflows-drag-free/00-project/`:

| Area | Path (from Workflow-Scripts root) |
|------|-----------------------------------|
| Changelog | `workflows-drag-free/00-project/changelog/` |
| Troubleshooting | `workflows-drag-free/00-project/troubleshooting/` |
| Active plans | `workflows-drag-free/00-project/plans/` |
| Research | `workflows-drag-free/00-project/research/` |
| Completed plans | `workflows-drag-free/00-project/plans-completed/` |
| Documentation | `workflows-drag-free/00-project/docs/` |
| Workflow tree | `workflows-drag-free/` |
| Setup workflows | `workflows-drag-free/00-setup/` |
| Live Workflow-Scripts meta | `00-project/` (sibling tree, not this meta) |
