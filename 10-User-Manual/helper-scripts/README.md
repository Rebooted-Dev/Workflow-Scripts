# Helper Scripts Reference

## Overview

Workflow-Scripts includes three Bash shell scripts for repository management. All scripts use `set -euo pipefail` for safe execution.

## Scripts

### pull-workflows.sh

Pull the latest Workflow-Scripts updates into a single project.

**Location:** `Workflow-Scripts/pull-workflows.sh`

**Usage:**
```bash
# From project root
./Workflow-Scripts/pull-workflows.sh

# Or from inside Workflow-Scripts
cd Workflow-Scripts && ./pull-workflows.sh
```

**Behavior:**
- Refuses to pull if the repo has uncommitted changes
- Uses `--ff-only` to prevent merge commits
- If in detached HEAD state, fetches without switching and instructs you to switch branches
- Safe for daily use — will not lose work

**Exit codes:**
- `0` — Success
- `1` — Error (not a git repo, uncommitted changes)

---

### sync-workflow-scripts.sh

Sync Workflow-Scripts across multiple projects.

**Location:** `Workflow-Scripts/sync-workflow-scripts.sh`

**Usage:**
```bash
# Sync all configured projects
./Workflow-Scripts/sync-workflow-scripts.sh

# Check status without syncing
./Workflow-Scripts/sync-workflow-scripts.sh --status

# Preview changes without applying
./Workflow-Scripts/sync-workflow-scripts.sh --dry-run

# Detailed output
./Workflow-Scripts/sync-workflow-scripts.sh --verbose

# Auto-discover projects
./Workflow-Scripts/sync-workflow-scripts.sh --auto

# Combine flags
./Workflow-Scripts/sync-workflow-scripts.sh --auto --dry-run --verbose
```

**Configuration (required before first use):**

Option 1 — Edit the PROJECTS array in the script:
```bash
PROJECTS=(
  "/path/to/Project1"
  "/path/to/Project2"
)
```

Option 2 — Use `--auto` flag with `WORKFLOW_SYNC_BASE_DIR`:
```bash
export WORKFLOW_SYNC_BASE_DIR="/path/to/projects"
./Workflow-Scripts/sync-workflow-scripts.sh --auto
```

Option 3 — Set `NON_INTERACTIVE=true` for CI/automated use:
```bash
NON_INTERACTIVE=true ./Workflow-Scripts/sync-workflow-scripts.sh --auto
```

**Environment variables:**
| Variable | Default | Description |
|----------|---------|-------------|
| `WORKFLOW_SYNC_BASE_DIR` | `/Volumes/Skynet/...` | Base directory for auto-discovery |
| `NON_INTERACTIVE` | `false` | Auto-clone when Workflow-Scripts missing (no prompt) |

**Behavior per project:**
1. Checks if project directory exists
2. Checks if Workflow-Scripts directory exists (offers to clone if missing)
3. Stashes uncommitted changes if present
4. Switches to `main` branch if in detached HEAD
5. Fetches from origin
6. Pulls with `--ff-only` if behind remote

**Status indicators:**
- `✓` — Up to date
- `⚠` — Behind remote (pulled)
- `→` — Ahead of remote (local commits)
- `✗` — Diverged (manual merge needed) or failed
- `⊘` — Missing or not found

---

### update-workflows.sh

Commit staged changes and push to the Workflow-Scripts remote. For maintainers only.

**Location:** `Workflow-Scripts/update-workflows.sh`

**Usage:**
```bash
# Stage changes first
cd Workflow-Scripts
git add .

# Commit and push
./update-workflows.sh "docs: clarify workflow instructions"
```

**Behavior:**
- Requires a commit message as the first argument
- Refuses to run if there are unstaged changes
- Refuses to run if there are no staged changes
- Commits staged changes with the provided message
- Pushes to the remote

**This script does NOT touch the parent project repo** — it only operates on the Workflow-Scripts repository.

**Exit codes:**
- `0` — Success
- `1` — Error (not a git repo, no message, unstaged changes, no staged changes)

## See Also

- [User Manual](../user-manual/README.md) — Quick start and common workflows
- [Project Integration](../developer-guide/project-integration.md) — How to integrate Workflow-Scripts into your project
- [SHARING_AND_SYNC](../../SHARING_AND_SYNC.md) — Multi-project sharing guide
