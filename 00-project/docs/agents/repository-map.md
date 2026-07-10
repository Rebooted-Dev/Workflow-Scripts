# Repository Map (Workflow-Scripts Ops Meta)

## Tracked Repositories

| # | Name | Directory | Remote URL | Branch |
|---|------|-----------|------------|--------|
| 1 | Update-AI-Tools | `/Users/jesse/Development/Personal/Update-AI-Tools` | `https://github.com/Rebooted-Dev/Update-AI-Tools` | `main` |
| 2 | Workflow-Scripts | `Workflow-Scripts/` (within Update-AI-Tools) | `https://github.com/Rebooted-Dev/Workflow-Scripts` | `main` |

## Purpose

- **Update-AI-Tools (root)** — Parent application repository. Workflow-Scripts is nested as a companion repo; it is not a second workflow library home.
- **Workflow-Scripts (companion)** — Shared workflow instructions, validation scripts, and operational metadata for the workflow system.

## Active library and metadata roles

| Path (from Workflow-Scripts root) | Role |
|-----------------------------------|------|
| `workflows-drag-free/` | **Active WDF workflow library** (`catalog.json`, `ROUTER.md`, `MOVED.json`, numbered domains, `tools/wf`) |
| `00-project/` | **Workflow-Scripts ops metadata** — whole-repo history, system plans, ops changelog, troubleshooting, and restore archives |
| `workflows-drag-free/00-project/` | **WDF package metadata** — package design, migration evidence, and package troubleshooting |
| `00-project/build/archive/` | **Restore-only archive** — promotion snapshot tarball and salvage inventory |

### Retired path (historical / archive-only)

- `00-project/Drag-Free-v2/` is **retired** and must not be recreated.
- It is **not** a current consolidation home and is **not** a second live library.
- Restore source: `00-project/build/archive/drag-free-v2-promotion-snapshot-2026-07-10.tar.gz`
- Salvage inventory: `00-project/build/archive/2026-07-10-drag-free-v2-salvage-inventory.md`

Do not present Update-AI-Tools `Drag-Free-v2/00-project/` as the live home for Workflow-Scripts ops or WDF package metadata.

## Sync instructions

```bash
# Update-AI-Tools — from parent repository root
git pull
git status
# Commit only parent-repo paths; never commit nested Workflow-Scripts changes here

# Workflow-Scripts — from companion repo
cd Workflow-Scripts
git pull
git status
git add .
git commit -m "docs: your message"
git push
```

## Meta workspace paths (Workflow-Scripts)

When working on whole-repository ops records, use paths under `00-project/`:

| Area | Path (from Workflow-Scripts root) |
|------|-----------------------------------|
| Changelog | `00-project/changelog/` |
| Troubleshooting | `00-project/troubleshooting/` |
| Active plans | `00-project/plans/` |
| Research (ops-owned) | `00-project/research/` |
| Completed plans | `00-project/plans-completed/` |
| Documentation | `00-project/docs/` |
| Restore archive | `00-project/build/archive/` |

When working on **package-owned** WDF migration evidence, use paths under `workflows-drag-free/00-project/`:

| Area | Path (from Workflow-Scripts root) |
|------|-----------------------------------|
| Package research | `workflows-drag-free/00-project/research/` |
| Package troubleshooting | `workflows-drag-free/00-project/troubleshooting/` |
| Package plans | `workflows-drag-free/00-project/plans/` |
| Separation repair evidence | `workflows-drag-free/00-project/build/drag-free-v2-separation/` |
| Package changelog | `workflows-drag-free/00-project/changelog/` |
