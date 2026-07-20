# Repository Map (Workflow-Scripts)

## Tracked Repositories

| # | Name | Directory | Remote URL | Active branch |
|---|------|-----------|------------|---------------|
| 1 | Workflow-Scripts | `.` (repository root) | `https://github.com/Rebooted-Dev/Workflow-Scripts` | `v1.8` |

## Purpose

- **Workflow-Scripts (root)** — Shared workflow instructions, templates, scripts, and `00-project/` meta for this repository.

`00-project/` is **not** a separate git repository. It is a tracked subdirectory within Workflow-Scripts.

## Branch matrix and disposition

Observed on 2026-07-19 before remediation commits. Commit IDs are evidence of the observed state, not permanent branch pins.

| Branch | Observed state | Disposition |
|--------|----------------|-------------|
| `v1.8` / `origin/v1.8` | Local and remote at `3b42700` | Active remediation line and the only implementation target for this run. |
| `v1.7` / `origin/v1.7` | Local and remote at `3b42700` | Frozen prior-stable line; do not fold v1.8 remediation into it. |
| `main` / `origin/main` | Local `1e06571`, 27 commits behind remote `26e5a9b` | Stale locally. After v1.8 is fully remediated and verified, fast-forward the maintained v1.x result to `main`; do not rewrite history. |
| `v1.5` / `origin/v1.5` | Local `a6aa8f6`, one commit behind remote `1b7b7af` | Historical maintenance line; frozen and outside this remediation. |
| `v1.6` / `origin/v1.6` | Local `370560f`, four commits behind remote `cba598b` | Historical maintenance line; frozen and outside this remediation. |
| `beta` | Local `5f521e4`; configured upstream `origin/beta` is gone | Stale local historical branch. Retain for now; no deletion is authorized by this plan. |
| `origin/1.0-deprecated` | Remote-only at `6325bde` | Deprecated historical reference; retain, with no deletion in this plan. |
| `origin/v2-alpha` | Remote-only at `2d3f599` | Legacy v2 prerelease reference; outside the v1.8 remediation and retained. |
| `origin/v2.0a` | Remote-only at `1c1050b` | Legacy v2 prerelease reference; outside the v1.8 remediation and retained. |
| `origin/v2.0` | Remote-only at `b2a5ad6` | Out of scope and may be abandoned. No merge, deletion, or history rewrite is part of this plan. |

No branch was deleted and no history was rewritten while recording this matrix.

## Remediation outcome

On 2026-07-20, the verified `v1.8` head `23f43bf` was published and `main` was fast-forwarded to the same commit. `v1.7` and the historical/v2 branches above were left unchanged.

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
| Research reports | `00-project/research/` |
| Completed plans | `00-project/plans-completed/` |
| Documentation | `00-project/docs/` |
| KIV / build archive | `00-project/KIV/`, `00-project/build/archive/` |
