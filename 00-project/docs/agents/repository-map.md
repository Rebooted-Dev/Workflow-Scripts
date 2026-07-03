# Repository Map (Workflow-Scripts)

## Tracked Repositories

| # | Name | Directory | Remote URL | Branch |
|---|------|-----------|------------|--------|
| 1 | Workflow-Scripts | `.` (repository root) | `https://github.com/Rebooted-Dev/Workflow-Scripts` | `main` / `v1.6` |

## Purpose

- **Workflow-Scripts (root)** — Shared workflow instructions, templates, scripts, and `00-project/` meta for this repository.

`00-project/` is **not** a separate git repository. It is a tracked subdirectory within Workflow-Scripts.

## Sync instructions

```bash
# From Workflow-Scripts repository root
git pull
git status
git add .
git commit -m "docs: your message"
git push
```

## Meta workspace paths

When working on Workflow-Scripts project records, use paths under `00-project/`:

| Area | Path |
|------|------|
| Changelog | `00-project/changelog/` |
| Troubleshooting | `00-project/troubleshooting/` |
| Active plans | `00-project/plans/` |
| Completed plans | `00-project/plans-completed/` |
| Documentation | `00-project/docs/` |
| KIV / research / build | `00-project/KIV/`, `00-project/research/`, `00-project/build/` |