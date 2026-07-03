# Deployment

Workflow-Scripts has **no cloud deployment process**. Distribution and updates are git-based.

## Prerequisites

- Git installed on host machine
- SSH or HTTPS access to `https://github.com/Rebooted-Dev/Workflow-Scripts`
- Host project `.gitignore` listing the workflows directory

## Distribution Models

### Recommended: Multi-repo local clone

1. Clone Workflow-Scripts inside host project:

```bash
cd /path/to/host-project
git clone https://github.com/Rebooted-Dev/Workflow-Scripts Workflow-Scripts
```

2. Add to host `.gitignore`:

```
Workflow-Scripts/
```

3. Document multi-repo setup in host `AGENTS.md`.

See [SHARING_AND_SYNC.md](../../../SHARING_AND_SYNC.md) for full details.

### Alternative: Git submodule (advanced)

Pins exact workflow version in parent history. See SHARING_AND_SYNC § "Git Submodule".

## Per-Project Update (Consumers)

```bash
# Option A: helper script
./Workflow-Scripts/scripts/pull-workflows.sh

# Option B: manual
cd Workflow-Scripts && git pull --ff-only
```

Safety: script blocks on uncommitted changes and detached HEAD.

## Maintainer Publish

```bash
cd Workflow-Scripts
git add <files-to-publish>   # stage only intended changes
./scripts/update-workflows.sh "docs: your change description"
```

The script commits **staged changes only** and rejects unstaged tracked files or untracked files. Or use manual `git commit` + `git push`.

## Multi-Project Sync

For maintainers with multiple host projects, use the shipped script at `scripts/sync-workflow-scripts.sh`. Configure via any of:

1. `PROJECTS[]` array in the script
2. `--auto` flag (auto-discover under `WORKFLOW_SYNC_BASE_DIR`)
3. `WORKFLOW_SYNC_PROJECTS` env var (colon-separated paths)
4. `WORKFLOW_SYNC_BASE_DIR` env var

```bash
./scripts/sync-workflow-scripts.sh --status    # check state
./scripts/sync-workflow-scripts.sh --dry-run   # preview
./scripts/sync-workflow-scripts.sh --auto      # discover and pull all
```

Set `NON_INTERACTIVE=true` for CI/non-interactive auto-clone when Workflow-Scripts is missing.

Guide: `00-project-setup/03-sync-workflow-scripts.md`

## Branches

| Branch | Role |
|--------|------|
| `main` | Primary integration branch |
| `v1.5`, `v1.6`, `v1.7` | Versioned release lines |

Override with `WORKFLOWS_BRANCH` env var in sync scripts.

## CI/CD

No CI pipeline ships with Workflow-Scripts. Recommended local checks before publish:

```bash
./scripts/validation/check-active-markdown-links.sh
./scripts/validation/check-orchestrator-review.sh
./scripts/validation/check-sync-workflow-scripts.sh
./scripts/validation/check-update-workflows.sh
./scripts/validation/check-review-workflow-policy.sh
```

## Consumer Deployment Guides (Reference Library)

These guides ship with Workflow-Scripts for host projects — not for deploying Workflow-Scripts itself:

| Guide | Path |
|-------|------|
| Deployment index | `07-deployment/README.md` |
| Electron (macOS) | `07-deployment/01a-MACOS_ELECTRON_GUIDE.md` |
| Electron + Vite | `07-deployment/01b-electron-vite.md` |
| Port management | `07-deployment/08-port-relocation/` |
| Pre-deploy security | `07-deployment/08a-pre-deployment-security-check.md` |
| Firebase setup | `08-API-Integration/10-firebase-setup.md` |
| Nginx | `08-API-Integration/11-nginx.md` |
| Next.js/React updates | `08-API-Integration/09-nextjs-react-update.md` |

## Rollback

```bash
cd Workflow-Scripts
git log --oneline -5
git checkout <previous-commit-or-tag>
```

For consumers, pin to a tag (e.g. `v1.0.0`) if needed.

## Monitoring and Logging

Not applicable — no runtime service. Change history lives in `00-project/changelog/index.md`.