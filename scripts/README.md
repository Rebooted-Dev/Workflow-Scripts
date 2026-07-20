# Workflow-Scripts — Shell Scripts

Executable helpers for syncing and maintaining this repository.

## Repository maintenance

| Script | Purpose |
|--------|---------|
| [`pull-workflows.sh`](./pull-workflows.sh) | `git pull --ff-only` in this repo (from a nested clone inside a host project) |
| [`update-workflows.sh`](./update-workflows.sh) | Commit staged changes and push (maintainers only) |
| [`sync-workflow-scripts.sh`](./sync-workflow-scripts.sh) | Pull Workflow-Scripts across multiple host projects |

### Typical usage

From a **host project root** (e.g. Podcast Studio):

```bash
./Workflow-Scripts/scripts/pull-workflows.sh
```

From **this repo** (maintainer):

```bash
./scripts/update-workflows.sh "docs: describe your change"
./scripts/sync-workflow-scripts.sh --status
```

## Validation

| Script | Purpose |
|--------|---------|
| [`validation/check-active-markdown-links.sh`](./validation/check-active-markdown-links.sh) | Active Markdown link checks |
| [`validation/check-orchestrator-review.sh`](./validation/check-orchestrator-review.sh) | Orchestrator review checks |
| [`validation/check-review-workflow-policy.sh`](./validation/check-review-workflow-policy.sh) | Shared review-workflow policy checks |
| [`validation/check-sync-workflow-scripts.sh`](./validation/check-sync-workflow-scripts.sh) | Sync helper behavior checks |
| [`validation/check-update-workflows.sh`](./validation/check-update-workflows.sh) | Update helper dirty-tree and staged-commit checks |

### Prerequisites

The validation suite requires `bash`, `git`, and `node`. `jq`, `opencode`, and GNU `timeout`/macOS `gtimeout` are optional: relevant scripts use their documented fallbacks when those tools are unavailable.

Run the same five gates automatically on pushes and pull requests through [`.github/workflows/validation.yml`](../.github/workflows/validation.yml).

Setup and behaviour for sync: [`../00-project-setup/03-sync-workflow-scripts.md`](../00-project-setup/03-sync-workflow-scripts.md).  
Sharing model: [`../SHARING_AND_SYNC.md`](../SHARING_AND_SYNC.md).
