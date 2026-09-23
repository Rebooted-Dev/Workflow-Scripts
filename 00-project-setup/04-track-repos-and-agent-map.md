# Track Repositories and Update PROJECT.md

## Purpose

This workflow helps you:

1. **Discover and track** all Git repositories in the current project (root repo + any nested repos, e.g. Workflow-Scripts, submodules, or other nested checkouts).
2. **Write the repository map to `PROJECT.md`** — under the agent-file scheme in [01-setup-project.md §1](./01-setup-project.md#step-1-set-up-the-agent-files-agentsmd-projectmd-harness-files), the repo map lives **only** in `PROJECT.md`'s `## Repositories` section, not duplicated into `AGENTS.md`, `CLAUDE.md`, or `GEMINI.md`.
3. **Verify** `AGENTS.md` still points to `PROJECT.md` and `CLAUDE.md`/`GEMINI.md` still import it.
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

Create a simple list for your own reference before editing `PROJECT.md`. Example:

| Directory        | Remote URL                                      | Branch | Purpose / notes        |
|-----------------|--------------------------------------------------|--------|------------------------|
| `.` (project root) | `https://github.com/org/main-project`         | main   | Primary application    |
| `Workflow-Scripts/` | `https://github.com/Rebooted-Dev/Workflow-Scripts` | main | Shared workflow docs   |

Use the discovery output to fill this table. You will use it to populate `PROJECT.md`'s Repositories section in Step 2.

---

## Step 2: Write the Repository Map to PROJECT.md

**Discovery is the only permitted source for repo maps.** Run Step 1 before editing `PROJECT.md`. Do not copy stale paths from another project.

The repo map lives **only** in `PROJECT.md`'s `## Repositories` section — a table (Path | Repository | Remote | Purpose) plus the three standing bullets about multi-repo behavior. Format and full template: [01-setup-project.md §1.4](./01-setup-project.md#14-create-projectmd-project-facts-and-repositories).

### 2.1 Update PROJECT.md

Open `PROJECT.md` at the project root and update the `## Repositories` section (template in [01-setup-project.md §1.4](./01-setup-project.md#14-create-projectmd-project-facts-and-repositories)) with the discovered repos. Add one row per repo found in Step 1. Do not invent rows for repos discovery didn't find.

**Optional — long per-repo detail:** if a repo needs more than the table can hold (extended notes, a project-specific sync script, per-repo branch policy), put that detail in `docs/agents/repository-map.md` and link it from this section in `PROJECT.md`. The table stays the source of truth for path → remote → purpose either way.

### 2.2 Verify AGENTS.md, CLAUDE.md, and GEMINI.md Are Still Correct

This workflow does not write a repo map into any of these files. It only verifies the pointers set up by [01-setup-project.md §1](./01-setup-project.md#step-1-set-up-the-agent-files-agentsmd-projectmd-harness-files) are intact:

- **AGENTS.md** — confirm it contains the "Read `PROJECT.md` before starting work" pointer. It should **not** contain a repo map, a "Tracked Repositories" section, or a "Repository Management" section. If it does (e.g. from an older version of this workflow), delete that block — don't leave a competing copy alongside the one in `PROJECT.md`.
- **CLAUDE.md / GEMINI.md** — confirm each still imports `@AGENTS.md` and `@PROJECT.md`. They should not restate the repo map or repository management instructions; delete any that snuck in.

Whenever the repo map changes, you only ever edit `PROJECT.md`. There is nothing else to keep "in sync."

---

## Step 3: Syncing, Pulling, and Pushing

Document and follow clear rules so the project stays in sync and agents know when to sync.

### 3.1 When to Sync / Pull

- **Before** installing or updating tools that depend on repo state (e.g. before changing `config.json` and regenerating scripts).
- **Before** starting work for the day or a task that touches multiple repos.
- **After** cloning or switching machines.

### 3.2 Per-Repository Commands

For **each** tracked repo, run Git commands from that repo's directory.

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

Repeat for every repo you listed in `PROJECT.md`'s Repositories table (each has its own directory).

### 3.3 If the Project Has a Sync Script

Some projects provide a **single-repo** sync helper (e.g. `scripts/utilities/sync-repo.sh`) that:

- Fetches from remote and compares local vs remote (e.g. by commit SHA).
- Optionally pulls if behind (`--auto-pull`).

**Use it for the primary repo** when documented, for example:

```bash
cd <PROJECT_PATH>
./scripts/utilities/sync-repo.sh --auto-pull
```

**Note the script in `PROJECT.md`'s Repositories section** (or in `docs/agents/repository-map.md` if you use that optional doc) so agents and users know to run it before install/update steps.

### 3.4 Syncing Workflow-Scripts Across Multiple Projects

If you use the same Workflow-Scripts repo in **multiple projects**, use the multi-project sync workflow instead of pulling in each project by hand:

- See [`03-sync-workflow-scripts.md`](./03-sync-workflow-scripts.md) for a script that finds all projects and runs `git pull` in each project's `<WORKFLOWS_DIR>`.

### 3.5 Push and Pull Best Practices

- **Pull before work** – Reduces merge conflicts and keeps you on latest.
- **Push after meaningful changes** – So other machines and collaborators see updates.
- **One repo per directory** – Always `cd` to the repo directory before `git pull` or `git push`; don't assume one command updates all repos.
- **Main vs nested** – Pushing from project root does **not** push nested repos; push each repo from its own directory.

---

## Step 4: Quick Reference for Agents and Humans

After completing this workflow, you should have:

1. **Discovery** – A list of all Git repos under the project (path, remote, branch).
2. **PROJECT.md** – The `## Repositories` table updated with every discovered repo: Path, Repository, Remote, Purpose, plus the three standing bullets. This is the single canonical copy.
3. **Verified pointers** – `AGENTS.md` still has the "Read `PROJECT.md`" line; `CLAUDE.md`/`GEMINI.md` still import `@AGENTS.md` and `@PROJECT.md`; none of the three restate the repo map.
4. **Sync/push/pull** – Documented when to sync, and per-repo commands (and any project-specific sync script for the primary repo).

---

## Troubleshooting

### Discovery finds no repos

- Ensure you run `find` from the project root and that at least the root has a `.git` directory.
- If the root is not a Git repo, treat the project as a workspace and run discovery from the parent directory that contains multiple repo roots.

### Wrong remote or branch in the map

- Re-run the discovery commands (Step 1) and fix the paths/URLs in `PROJECT.md`'s Repositories table.

### PROJECT.md is out of date with the actual repos

- Re-run discovery (Step 1), then update `PROJECT.md`'s Repositories table to match. There's no second copy to reconcile — if `AGENTS.md`, `CLAUDE.md`, or `GEMINI.md` still contain their own repo list, that's leftover from before this workflow moved to the single-source scheme; delete it (see 2.2).

### Push/pull from wrong directory

- Always `cd` to the repo's path before running `git push` or `git pull`. `PROJECT.md`'s Repositories table is the source of truth for "which directory is which repo."

### Nested repo ignored by main repo

- This is expected for directories like Workflow-Scripts that are in `.gitignore`. Document it in `PROJECT.md`'s Repositories section so agents don't try to commit the nested repo from the main repo root.

---

## For AI Agents Executing This Workflow

1. **Discover first** – Run the `find` + `git remote get-url` / `git branch --show-current` commands from the project root and collect the list of directories and their remotes/branches.
2. **Update PROJECT.md only** – Write the discovered repos into `PROJECT.md`'s `## Repositories` table (path, repository, remote, purpose) plus the three standing bullets. Use the project's actual paths and remote URLs; do not leave placeholders like `<PROJECT_PATH>` unless the user has not provided them.
3. **Verify, don't duplicate** – Check that `AGENTS.md` has the "Read `PROJECT.md`" pointer and that `CLAUDE.md`/`GEMINI.md` import `@AGENTS.md` and `@PROJECT.md`. Delete any repo map or "Tracked Repositories"/"Repository Management" section you find inline in those files instead of updating it in place.
4. **Document sync/push/pull** – Include the when-to-sync rules and the per-repo commands (and any project-specific sync script) in Step 3, referenced from `PROJECT.md` if useful.
5. **Do not invent repos** – Only list repositories that the discovery step actually found; do not add placeholder "Repo 2" entries without corresponding directories.
