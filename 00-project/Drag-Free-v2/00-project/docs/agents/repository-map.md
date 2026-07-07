# Repository Map (Drag-Free-v2 Consolidation)

## Tracked Repositories

| # | Name | Directory | Remote URL | Branch |
|---|------|-----------|------------|--------|
| 1 | Update-AI-Tools | `/Users/jesse/Development/Personal/Update-AI-Tools` | `https://github.com/Rebooted-Dev/Update-AI-Tools` | `main` |
| 2 | Workflow-Scripts | `Workflow-Scripts/` (within Update-AI-Tools) | `https://github.com/Rebooted-Dev/Workflow-Scripts` | `main` |

## Purpose

- **Update-AI-Tools (root)** — Main application repository; hosts `Drag-Free-v2/` consolidation output, promoted Workflow-Scripts files, and consolidation metadata.
- **Workflow-Scripts (companion)** — Source workflow repository being consolidated; has its own `00-project/` meta for Workflow-Scripts system work.

`Drag-Free-v2/00-project/` is **not** a separate git repository. It is a subdirectory within Update-AI-Tools.

## Sync instructions

```bash
# Update-AI-Tools — from repository root
git pull
git status
git add Drag-Free-v2/
git commit -m "docs: consolidation update"
git push

# Workflow-Scripts — from companion repo
cd Workflow-Scripts
git pull
git status
git add .
git commit -m "docs: your message"
git push
```

## Meta workspace paths

When working on Drag-Free-v2 consolidation records, use paths under `Drag-Free-v2/00-project/`:

| Area | Path (from Update-AI-Tools root) |
|------|----------------------------------|
| Changelog | `Drag-Free-v2/00-project/changelog/` |
| Troubleshooting | `Drag-Free-v2/00-project/troubleshooting/` |
| Active plans | `Drag-Free-v2/00-project/plans/` |
| Research | `Drag-Free-v2/00-project/research/` |
| Completed plans | `Drag-Free-v2/00-project/plans-completed/` |
| Documentation | `Drag-Free-v2/00-project/docs/` |
| Promoted Workflow-Scripts files | `Drag-Free-v2/` |
| Imported Workflow-Scripts metadata | `Drag-Free-v2/00-project/` |
| Execution logs | `Drag-Free-v2/Workflow-Scripts-consolidated/logs/` |
