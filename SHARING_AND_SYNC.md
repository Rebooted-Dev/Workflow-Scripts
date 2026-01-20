# Sharing and Syncing Workflows Across Projects

## Goal

Keep a single source of truth for workflow instructions while allowing each project to consume updates on its own schedule.

## Recommended Model: Nested Repository (Independent From Parent Repo)

In this model, `workflows/` is its own git repository cloned into each project.

Key properties:
- The main project repo and `workflows/` repo are managed independently.
- The main project typically ignores `workflows/` (via `.gitignore`) so `git add .` from the project root never stages workflow changes.
- Updating workflows in a project is just `git pull` inside `workflows/`.

### Initial Setup (Per Project)

1. Ensure the project ignores the nested repo:
   - Add `workflows/` to the project's `.gitignore`.

2. Clone Workflow-Scripts into the project:

```bash
cd /path/to/your-project
git clone https://github.com/Rebooted-Dev/Workflow-Scripts workflows
```

### Pull Updates (Per Project)

Option A (manual):

```bash
cd /path/to/your-project/workflows
git pull --ff-only
```

Option B (helper script):

```bash
# From the project root:
./workflows/pull-workflows.sh

# Or from inside the workflows directory:
./pull-workflows.sh
```

Notes:
- The helper script refuses to pull if the workflows repo has local uncommitted changes.
- If the workflows repo is in detached HEAD, the helper script will fetch and instruct you to switch to a branch.

### Contribute Changes Back (Maintainers)

If you are editing workflow files and want to publish those updates:

```bash
cd /path/to/your-project/workflows
git status
git add .
git commit -m "docs: clarify execution log updates"
git push
```

Helper script (commits staged changes and pushes):

```bash
cd /path/to/your-project/workflows
git add .
./update-workflows.sh "docs: clarify execution log updates"
```

## Alternative Model: Git Submodule (Advanced)

Use a submodule only if you want the parent project to pin an exact workflows version in its own history.

Important differences from the nested repo model:
- The parent repo tracks the workflows pointer (gitlink) and `.gitmodules`.
- `workflows/` must NOT be ignored by the parent repo.
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
