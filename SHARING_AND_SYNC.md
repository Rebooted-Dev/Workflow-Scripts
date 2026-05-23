# Sharing and Syncing Workflows Across Projects

## Goal

Keep a single source of truth for workflow instructions while allowing each project to consume updates on its own schedule.

## Recommended Model: Multi-Repo with Local Workflows Directory

The host project has **multiple repositories**, not a single repo. The workflows directory (e.g. `Workflow-Scripts/` or `workflows/`) is a **local** clone inside the project directory and is its own git repository.

Key properties:
- **Multi-repo**: Main project repo and the workflows repo are independent; both exist under the same project directory on disk.
- The main project **must** ignore the workflows directory in `.gitignore` so `git add .` from the project root never stages workflow changes.
- Updating workflows in a project is `git pull` inside the workflows directory (e.g. `Workflow-Scripts/` or `workflows/`).
- Reusable Codex skills under `11-Skills/` are part of this workflows repo and sync with it; copy or install them into an agent's active skills directory only when that agent runtime requires a separate discovery location.
- Project docs (e.g. `AGENTS.md`) should state clearly that the project has multiple repositories so agents and contributors do not assume one repo.

### Initial Setup (Per Project)

1. Ensure the project treats this as multi-repo: add the workflows directory to the project's `.gitignore` (e.g. `Workflow-Scripts/` or `workflows/`).

2. Clone Workflow-Scripts into **this local project directory** (project root):

```bash
cd /path/to/your-project
git clone https://github.com/Rebooted-Dev/Workflow-Scripts Workflow-Scripts
# Or use a different directory name: git clone https://github.com/Rebooted-Dev/Workflow-Scripts workflows
```

### Pull Updates (Per Project)

Option A (manual):

```bash
cd /path/to/your-project/Workflow-Scripts   # or workflows
git pull --ff-only
```

Option B (helper script):

```bash
# From the project root (use your actual directory name, e.g. Workflow-Scripts or workflows):
./Workflow-Scripts/pull-workflows.sh

# Or from inside the workflows directory:
cd Workflow-Scripts && ./pull-workflows.sh
```

Notes:
- The helper script refuses to pull if the workflows repo has local uncommitted changes.
- If the workflows repo is in detached HEAD, the helper script will fetch and instruct you to switch to a branch.

### Contribute Changes Back (Maintainers)

If you are editing workflow files and want to publish those updates:

```bash
cd /path/to/your-project/Workflow-Scripts   # or workflows
git status
git add .
git commit -m "docs: clarify execution log updates"
git push
```

Helper script (commits staged changes and pushes):

```bash
cd /path/to/your-project/Workflow-Scripts
git add .
./update-workflows.sh "docs: clarify execution log updates"
```

## Alternative Model: Git Submodule (Advanced)

Use a submodule only if you want the parent project to pin an exact workflows version in its own history.

Important differences from the multi-repo (local clone) model:
- The parent repo tracks the workflows pointer (gitlink) and `.gitmodules`.
- The workflows directory must NOT be ignored by the parent repo.
- The safe default update flow respects the parent-pinned commit.

### Add as Submodule

```bash
cd /path/to/your-project
git submodule add https://github.com/Rebooted-Dev/Workflow-Scripts workflows
git commit -m "chore: add workflows submodule"
```

### Update Submodule (Safe Default)

```bash
git pull
git submodule update --init --recursive
```

### Advance to a Newer Submodule Commit (Explicit)

```bash
cd workflows
git fetch
git switch main
git pull --ff-only
cd ..
git add workflows
git commit -m "chore: bump workflows submodule"
```

Avoid using `git submodule update --remote` as the default because it advances to remote HEAD and bypasses the parent repo's pin.

## Alternatives (Generally Not Recommended)

### Symlinks

Symlinks can work locally but are not portable and are awkward with git (git tracks the symlink, not the content).

### Git Subtree / Copy-Vendoring

Subtree or copy-based vendoring can work but merges workflow history into the project, which is usually not desired for reusable tooling.
