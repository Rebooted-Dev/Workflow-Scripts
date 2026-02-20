# Track Repositories and Agent-File Repo Map

## Purpose

This workflow helps you:

1. **Discover and track** all Git repositories in the current project (root repo + any nested repos, e.g. Workflow-Scripts, submodules, or other nested checkouts).
2. **Set up agent files** (AGENTS.md, CLAUDE.md, GEMINI.md) with a clear **repository map**: directory path → remote URL, purpose, and status, so AI agents and humans know which directories are which repo and how to sync them.
3. **Keep AGENTS.md, CLAUDE.md, and GEMINI.md in sync** with the repo mapping—when the repo map changes, update all three files (or the single canonical source they reference) so every agent sees the same directories and remotes.
4. **Document sync, pull, and push** procedures for each repo and when to run them.

---

## Prerequisites

- Project root is a Git repository (or you are tracking multiple repos under a workspace).
- Bash (macOS/Linux) or Git Bash (Windows).
- Git installed.

**Placeholders** (replace with your values):

- `<PROJECT_PATH>` – Full path to project root (e.g. `/Users/name/projects/my-app`).
- `<WORKFLOWS_DIR>` – Directory name for workflows if present (e.g. `Workflow-Scripts` or `workflows/`).

---

## Step 1: Discover Repositories in the Project

### 1.1 List All Git Repositories

From the project root, find every directory that contains a `.git` directory (actual repos, not submodule pointers only):

```bash
cd <PROJECT_PATH>

# List all .git directories (real repos)
find . -name .git -type d 2>/dev/null | grep -v /\.git/
```

To get **directory path** and **remote URL** for each repo:

```bash
cd <PROJECT_PATH>

find . -name .git -type d 2>/dev/null | while read -r g; do
  dir=$(dirname "$g")
  # Skip if this .git is inside another repo (nested .git in submodule is ok; we want repo root)
  if [ -f "$dir/.git" ]; then continue; fi  # submodule pointer file
  rel="${dir#./}"
  echo "--- $rel ---"
  (cd "$dir" && git remote get-url origin 2>/dev/null || echo "(no origin)")
  (cd "$dir" && git branch --show-current 2>/dev/null || echo "(detached)")
  echo ""
done
```

**Optional one-liner** to print a simple table (path, remote, branch):

```bash
cd <PROJECT_PATH>
find . -name .git -type d 2>/dev/null | while read -r g; do
  dir=$(dirname "$g")
  [ -f "$dir/.git" ] && continue
  rel="${dir#./}"
  url=$(cd "$dir" && git remote get-url origin 2>/dev/null)
  branch=$(cd "$dir" && git branch --show-current 2>/dev/null)
  printf "%-50s %-60s %s\n" "$rel" "$url" "$branch"
done
```

### 1.2 Record the Repo Map

Create a simple list for your own reference before editing agent files. Example:

| Directory        | Remote URL                                      | Branch | Purpose / notes        |
|-----------------|--------------------------------------------------|--------|------------------------|
| `.` (project root) | `https://github.com/org/main-project`         | main   | Primary application    |
| `Workflow-Scripts/` | `https://github.com/Rebooted-Dev/Workflow-Scripts` | main | Shared workflow docs   |

Use the discovery output to fill this table. You will copy this structure into AGENTS.md, CLAUDE.md, and GEMINI.md in Step 2.

---

## Step 2: Set Up Agent Files with the Repository Map

Agent files (AGENTS.md, CLAUDE.md, GEMINI.md) should each contain a **Tracked Repositories** (or **Repository Map**) section so that:

- AI agents know which directories are separate repos and their remotes.
- Everyone knows where to run `git pull` / `git push` and which repo is “primary” vs nested.

### 2.1 Section to Add

Add or update a section like this in **AGENTS.md**, **CLAUDE.md**, and **GEMINI.md**. The repo map content (or the link to the canonical doc) must be **identical across all three files** so that every agent (AGENTS, Claude, Gemini) sees the same directory → repo mapping. See §2.4 for how to keep them in sync.

**Template:**

```markdown
## Tracked Repositories

The development environment tracks the following repositories in this project:

### 1. <REPO_DISPLAY_NAME> (Primary)
- **Path**: `<ABSOLUTE_OR_RELATIVE_PATH>`
- **Purpose**: <Short description>
- **URL**: <remote URL, e.g. https://github.com/org/repo>
- **Status**: <e.g. Active development, Companion, Optional>

### 2. <REPO_DISPLAY_NAME> (Nested / Companion)
- **Path**: `<PROJECT_PATH>/<SUBDIR>/`
- **Purpose**: <Short description>
- **URL**: <remote URL>
- **Status**: <e.g. Shared across projects>
- **Note**: This directory is a separate git repository and may be ignored by the main repo (see `.gitignore`).

(Add more numbered subsections for each repo you discovered.)
```

**Slim variant:** If you use a slim root file and put long content in `docs/agents/`, you can:

- Keep a **short** “Tracked Repositories” block in AGENTS.md (and CLAUDE.md / GEMINI.md) listing only: name, path, URL, one-line purpose.
- Put the full **Repository Map** (table + sync/push/pull details) in e.g. `docs/agents/repository-map.md` and link to it:

```markdown
## Tracked Repositories

See [Repository Map](docs/agents/repository-map.md) for paths, remotes, and sync instructions.
```

### 2.2 Map Table (Optional)

In AGENTS.md or `docs/agents/repository-map.md` you can add a quick-reference table:

```markdown
| # | Name           | Directory        | Remote URL                    | Branch |
|---|----------------|------------------|-------------------------------|--------|
| 1 | Primary        | `.` (project root) | https://github.com/org/repo   | main   |
| 2 | Workflow-Scripts | Workflow-Scripts/ | https://github.com/.../Workflow-Scripts | main |
```

### 2.3 Which Files to Update

- **AGENTS.md** – Always include the repository map (or link to `docs/agents/repository-map.md`) so all agents see it.
- **CLAUDE.md** – Include the **same** repo map content or the **same** link so Claude Code has the map in context.
- **GEMINI.md** – Include the **same** repo map content or the **same** link for Gemini-focused workflows.

Run the discovery in Step 1, then paste the resulting structure into **all three files** so paths and URLs match your project. Whenever you add, remove, or change a repo in the map, update all three files so they stay in sync (see §2.4).

### 2.4 Keep AGENTS.md, CLAUDE.md, and GEMINI.md in Sync with the Repo Map

The directory → repo mapping must be consistent across AGENTS.md, CLAUDE.md, and GEMINI.md. Otherwise different agents (or the same agent reading different files) may see different repo lists or remotes.

**Rules:**

1. **Single source of truth** – Choose one of:
   - **Inline** – The full “Tracked Repositories” (and optional “Repository Management”) content lives in all three files; when you change the repo map, update the same section in AGENTS.md, CLAUDE.md, and GEMINI.md.
   - **Canonical doc** – The full map lives in one place (e.g. `docs/agents/repository-map.md` or AGENTS.md); AGENTS.md, CLAUDE.md, and GEMINI.md each contain the **same** short “Tracked Repositories” block that links to that doc. When the repo map changes, update only the canonical doc (and ensure all three still point to it).

2. **When the repo map changes** (new repo, removed repo, new remote, path or purpose change):
   - If using **inline**: update the Tracked Repositories (and Repository Management, if present) in **AGENTS.md**, **CLAUDE.md**, and **GEMINI.md** with the same content.
   - If using a **canonical doc**: update that doc only; verify AGENTS.md, CLAUDE.md, and GEMINI.md still link to it and that the link path is correct.

3. **Sync checklist** – After any change to the repo map, confirm:
   - [ ] AGENTS.md has the current repo list (or the correct link to the canonical map).
   - [ ] CLAUDE.md has the same repo list or the same link.
   - [ ] GEMINI.md has the same repo list or the same link.
   - [ ] No file references a repo that no longer exists or an outdated path/URL.

**When to refresh:** Re-run this workflow (discovery + update of agent files) whenever you add or remove a nested repo, change a remote URL, or rename a repo directory, so all three agent files stay aligned with the actual repos in the project.

---

## Step 3: Syncing, Pulling, and Pushing

Document and follow clear rules so the project stays in sync and agents know when to sync.

### 3.1 When to Sync / Pull

- **Before** installing or updating tools that depend on repo state (e.g. before changing `config.json` and regenerating scripts).
- **Before** starting work for the day or a task that touches multiple repos.
- **After** cloning or switching machines.

### 3.2 Per-Repository Commands

For **each** tracked repo, run Git commands from that repo’s directory.

**Primary repo (project root):**

```bash
cd <PROJECT_PATH>

# Check status
git status

# Pull latest (recommended before making changes)
git pull

# After making changes: commit and push
git add .
git commit -m "feat: description of changes"
git push
```

**Nested repo (e.g. Workflow-Scripts):**

```bash
cd <PROJECT_PATH>/<WORKFLOWS_DIR>

git status
git pull

# After making changes
git add .
git commit -m "docs: update workflow description"
git push
```

Repeat for every repo you listed in the agent-file map (each has its own directory).

### 3.3 If the Project Has a Sync Script

Some projects provide a **single-repo** sync helper (e.g. `scripts/utilities/sync-repo.sh`) that:

- Fetches from remote and compares local vs remote (e.g. by commit SHA).
- Optionally pulls if behind (`--auto-pull`).

**Use it for the primary repo** when documented, for example:

```bash
cd <PROJECT_PATH>
./scripts/utilities/sync-repo.sh --auto-pull
```

**Document in the repo map** that the primary repo supports this script and where it lives, so agents and users know to run it before install/update steps.

### 3.4 Syncing Workflow-Scripts Across Multiple Projects

If you use the same Workflow-Scripts repo in **multiple projects**, use the multi-project sync workflow instead of pulling in each project by hand:

- See [`03-sync-workflow-scripts.md`](./03-sync-workflow-scripts.md) for a script that finds all projects and runs `git pull` in each project’s `<WORKFLOWS_DIR>`.

### 3.5 Push and Pull Best Practices

- **Pull before work** – Reduces merge conflicts and keeps you on latest.
- **Push after meaningful changes** – So other machines and collaborators see updates.
- **One repo per directory** – Always `cd` to the repo directory before `git pull` or `git push`; don’t assume one command updates all repos.
- **Main vs nested** – Pushing from project root does **not** push nested repos; push each repo from its own directory.

---

## Step 4: Add “Repository Management” to Agent Files (Optional but Recommended)

In addition to the **Tracked Repositories** map, add a **Repository Management** section that spells out:

- That the project has multiple repos and they are independent.
- Where to run Git commands for the main repo vs nested repos.
- That the workflows directory (if present) is ignored by the main repo and has its own Git history.

Example (customize paths and names):

```markdown
## Repository Management

This project uses multiple repositories that must be managed independently.

### Primary Repo (Project Root)
- **Location**: `<PROJECT_PATH>`
- **Git Remote**: <URL>
- Run `git status`, `git pull`, `git add`, `git commit`, `git push` from `<PROJECT_PATH>`.

### Workflow-Scripts (Nested)
- **Location**: `<PROJECT_PATH>/<WORKFLOWS_DIR>/`
- **Git Remote**: <URL>
- Run all Git commands from `<PROJECT_PATH>/<WORKFLOWS_DIR>/`. The main repo’s `.gitignore` excludes this directory.
```

You can reuse the same structure you added in Step 2 (Tracked Repositories) and expand it with the exact commands from Step 3.

---

## Step 5: Quick Reference for Agents and Humans

After completing this workflow, you should have:

1. **Discovery** – A list of all Git repos under the project (path, remote, branch).
2. **Agent files** – AGENTS.md, CLAUDE.md, and GEMINI.md each contain (or link to) the **same** **Tracked Repositories** map: directory → URL, purpose, status. All three files are kept in sync with the repo mapping (§2.4).
3. **Sync/push/pull** – Documented when to sync, and per-repo commands (and any project-specific sync script for the primary repo).
4. **Repository Management** – A short section in agent files explaining multiple repos and where to run Git.

---

## Troubleshooting

### Discovery finds no repos

- Ensure you run `find` from the project root and that at least the root has a `.git` directory.
- If the root is not a Git repo, treat the project as a workspace and run discovery from the parent directory that contains multiple repo roots.

### Wrong remote or branch in the map

- Re-run the discovery commands (Step 1) and fix the paths/URLs in **all three** agent files (AGENTS.md, CLAUDE.md, GEMINI.md)—or in the single canonical doc if you use that pattern—so they stay in sync.
- If a repo uses a different remote name (e.g. `upstream`), use `git remote get-url upstream` (or the appropriate name) in the discovery script and document it in the map.

### Agent files (AGENTS.md, CLAUDE.md, GEMINI.md) out of sync with repo map

- If one file lists different repos or URLs than another, re-run discovery (Step 1), then update **all three** files with the same Tracked Repositories content (or the same link to `docs/agents/repository-map.md`). Use the sync checklist in §2.4.

### Push/pull from wrong directory

- Always `cd` to the repo’s path before running `git push` or `git pull`. The map in the agent files is the source of truth for “which directory is which repo.”

### Nested repo ignored by main repo

- This is expected for directories like Workflow-Scripts that are in `.gitignore`. Document it in the repo map and in Repository Management so agents don’t try to commit the nested repo from the main repo root.

---

## For AI Agents Executing This Workflow

1. **Discover first** – Run the `find` + `git remote get-url` / `git branch --show-current` commands from the project root and collect the list of directories and their remotes/branches.
2. **Update agent files** – Add or update the “Tracked Repositories” (and optionally “Repository Management”) section using the discovered list. Use the project’s actual paths and remote URLs; do not leave placeholders like `<PROJECT_PATH>` unless the user has not provided them.
3. **Keep all three in sync** – Apply the **same** repo map content (or the **same** link to the canonical map) to **AGENTS.md**, **CLAUDE.md**, and **GEMINI.md**. When you change the repo map in one file, update the other two so the directory → repo mapping is identical everywhere. See §2.4.
4. **Document sync/push/pull** – Include the when-to-sync rules and the per-repo commands (and any project-specific sync script) in the same section or in the linked doc.
5. **One source of truth** – Either put the full map in all three files (and keep them identical when editing) or put it in one canonical doc (e.g. `docs/agents/repository-map.md`) and have all three agent files link to it with the same link.
6. **Do not invent repos** – Only list repositories that the discovery step actually found; do not add placeholder “Repo 2” entries without corresponding directories.
