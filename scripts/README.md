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
| [`validation/check-completion-chain-policy.sh`](./validation/check-completion-chain-policy.sh) | Completion-chain policy checks (plan-level gate ownership, gate runs for every outcome, task ticking, host-policy archive routing, deterministic discovery, navigation) |
| [`validation/check-meta-logs.sh`](./validation/check-meta-logs.sh) | Changes outside `00-project/` must add a `00-project/changelog/` entry; `fixed/` entries need a troubleshooting entry or a recorded waiver; index rows required. `--staged` (pre-commit) or `--range A..B` (CI) |
| [`validation/check-meta-logs-selftest.sh`](./validation/check-meta-logs-selftest.sh) | Self-test for `check-meta-logs.sh` against a throwaway repository |

### Pre-commit hook

Enable the meta-log check once per clone: `git config core.hooksPath scripts/hooks`. The hook runs `check-meta-logs.sh --staged` and blocks commits whose logs are missing.

### Prerequisites

The validation suite requires `bash`, `git`, and `node`. `jq`, `opencode`, and GNU `timeout`/macOS `gtimeout` are optional: relevant scripts use their documented fallbacks when those tools are unavailable.

Run the validation gates automatically on pushes and pull requests through [`.github/workflows/validation.yml`](../.github/workflows/validation.yml).

Setup and behaviour for sync: [`../00-project-setup/03-sync-workflow-scripts.md`](../00-project-setup/03-sync-workflow-scripts.md).  
Sharing model: [`../SHARING_AND_SYNC.md`](../SHARING_AND_SYNC.md).
