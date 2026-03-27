# Project Initial Setup Workflow

This workflow sets up a new project, migrates a project from an older structure, or **updates an existing project that already uses this system** (see [Updating an existing project that already uses this system](#updating-an-existing-project-that-already-uses-this-system)). It provides:
1. **Dual Repository Management (Multi-Repo)** - The project has the main application repository and a **local** Workflow-Scripts repository (cloned into the project directory). Instructions for managing both; `AGENTS.md`, `.gitignore`, and other project docs should make this explicit so agents and contributors do not assume one repo.
2. **Troubleshooting System** - `project/troubleshooting/` with category folders and index; backup of existing logs
3. **Changelog System** - Single `project/changelog/` directory: type folders (added, changed, fixed, etc.) plus `plans/` subdir for completed plan docs; one index for all (change entries and Type=plan); backup of existing single-file CHANGELOG if present
4. **Project & Plans** - `project/` container for the working areas and logs: `project/KIV/`, `project/research/`, `project/build/`, `project/plans/`, `project/changelog/`, and `project/troubleshooting/`. **Active plans** (and the plans map/TODO) live in `project/plans/`; **completed plans** live in `project/changelog/plans/` (date-prefixed and indexed in `project/changelog/index.md` with Type=plan). This matches the standard structure used by Info-Visualizer and should be treated as canonical for new projects.
5. **Slim AGENTS Architecture (standard)** - Root `AGENTS.md` with essentials only and links to detailed docs in `docs/agents/`; `docs/` and `docs/agents/` created for every project
6. **Slim CLAUDE.md and GEMINI.md** - Same slim pattern for Claude/Cursor and Gemini: essentials + "Detailed Documentation" linking to `docs/agents/` (standard: create at project root as part of setup; create if missing, do not overwrite existing)
7. **Track Repos and Agent Map** - Discover all Git repos in the project and populate AGENTS.md, CLAUDE.md, and GEMINI.md with a repository map and sync/push/pull instructions (see [04-track-repos-and-agent-map.md](./04-track-repos-and-agent-map.md))

---

## Quick Start (Minimal Setup)

For users who want a fast setup, here are the essential steps. Replace placeholders: `<PROJECT_PATH>`, `<WORKFLOWS_DIR>` (e.g. `Workflow-Scripts` or `workflows/`). See Prerequisites for the full list.

```bash
# 1. Navigate to your project
cd <PROJECT_PATH>

# 2. Clone Workflow-Scripts into this local project dir (if not already done)
git clone https://github.com/Rebooted-Dev/Workflow-Scripts <WORKFLOWS_DIR>

# 3. Add workflows dir to .gitignore (required for multi-repo: main repo must not track it)
echo "" >> .gitignore
echo "# Workflow-Scripts (separate repo)" >> .gitignore
echo "<WORKFLOWS_DIR>/" >> .gitignore

# 4. Create project/ container and subdirs (KIV, research, build, changelog, troubleshooting)
mkdir -p project/{KIV,research,build}
mkdir -p project/changelog/{added,changed,fixed,improved,docs,refactor,config,plans-completed}
echo "# Changelog Index" > project/changelog/index.md
echo "" >> project/changelog/index.md
echo "| Date | Type | Title | File | Notes |" >> project/changelog/index.md
echo "|------|------|-------|------|-------|" >> project/changelog/index.md
mkdir -p project/troubleshooting/{build,runtime,data,environment,security}
echo "# Troubleshooting Index" > project/troubleshooting/index.md
echo "" >> project/troubleshooting/index.md
echo "| Date | Category | Title | File | Status |" >> project/troubleshooting/index.md
echo "|------|----------|-------|------|--------|" >> project/troubleshooting/index.md

# 5. Create project/plans/ with README (map to project dir) and TODO (current tasks)
mkdir -p project/plans
# Create minimal plans/README.md and plans/TODO.md (see full content in Step 2.8)

# 6. Create docs and docs/agents (if they don't exist)
mkdir -p docs docs/agents

# 7. Verify setup
git status | grep <WORKFLOWS_DIR> || echo "✓ Workflows ignored"
ls project/ && echo "✓ project/ structure created"
ls project/changelog/ && echo "✓ project/changelog/ (type folders + plans-completed) and index created"
ls project/troubleshooting/ && echo "✓ project/troubleshooting/ created"
test -d project/plans && echo "✓ project/plans/ exists (add README.md and TODO.md per Step 2.8)"
ls -d docs docs/agents 2>/dev/null && echo "✓ docs/ and docs/agents/ created"

# 8. Run track-repos workflow (discover repos, update AGENTS.md/CLAUDE.md/GEMINI.md with repo map and sync instructions)
# Follow: Workflow-Scripts/00-project-setup/04-track-repos-and-agent-map.md
```

For a comprehensive setup with AGENTS.md configuration and backups, continue with the detailed steps below.

---

## Purpose

This setup ensures:
- **Multi-repo is explicit** - Project documentation (especially `AGENTS.md`) clearly states that the project has **multiple repositories** (main repo + local Workflow-Scripts), not a single repository.
- **Consistent date format** – All dated file and directory names use **YYYY-MM-DD** (ISO date with hyphens) in `project/changelog/`, `project/troubleshooting/`, and when archiving plans to `project/changelog/plans/`. Examples: `project/changelog/added/2026-01-18-added-feature-x.md`, `project/troubleshooting/build/2026-01-18-build-error.md`, `project/changelog/plans/2026-01-18-implementation-plan.md`. This keeps naming consistent and sortable across the project.
- Clear separation between main project repo and the local workflows repo (e.g. `Workflow-Scripts/`)
- Proper git configuration: main project's `.gitignore` must list the workflows directory so the main repo never tracks it
- **Troubleshooting and changelog in project/** - `project/changelog/` holds both change entries (type folders) and completed plans (`changelog/plans/`); one index. `project/troubleshooting/` has category folders and index. When migrating, existing content is **extracted into individual files** and indexes (Step 2.7, Step 4). Backup alone is not enough—migration into the new structure is a defined task.
- Organized **troubleshooting** system under `project/troubleshooting/` (category folders + index) that preserves existing troubleshooting data
- Organized **changelog** system under `project/changelog/` (type folders + `plans/` subdir, single index) so changes and completed plans are in one place
- Consistent project structure across all projects using these workflows
- **docs/** directory at project root (created if missing) and **docs/agents/** for agent-facing detailed documentation
- Slim root AGENTS.md: essentials only in the root file (Execution, Repository Management, slim Change Management), with a "Detailed Documentation" section linking to `docs/agents/`. Changelog & Troubleshooting conventions live in `docs/agents/changelog-and-troubleshooting.md`; other long sections (Project Structure, Build/Coding/Testing, etc.) are relocated to topical files in `docs/agents/` (Steps 2.6, 2.9.3)
- Slim **CLAUDE.md** and **GEMINI.md** at project root (standard: create as part of setup; same pattern: essentials + links to `docs/agents/`), for Claude/Cursor and Gemini assistants; for repo management and changelog/troubleshooting they reference AGENTS.md
- **Tracked Repositories map** in agent files (AGENTS.md, CLAUDE.md, GEMINI.md) listing each repo’s path, remote URL, purpose, and sync/push/pull instructions (Step 2.11; see [04-track-repos-and-agent-map.md](./04-track-repos-and-agent-map.md))

### Variant: Centralized `project/` meta directory

Some projects prefer to keep all project meta directories under a single `project/` folder at the repository root (example: **The Sermonator**). In that layout:

- `docs/` → `project/docs/`
- `docs/agents/` → `project/docs/agents/`
- `changelog/` → `project/changelog/`
- `troubleshooting/` → `project/troubleshooting/`
- `plans/` → `project/plans/`
- `plans-completed/` → `project/plans-completed/`

When you see paths like `docs/`, `changelog/`, `troubleshooting/`, `plans/`, or `plans-completed/` in this workflow, apply them **either** at the repository root **or** under `project/` depending on your chosen structure.  
If you use the `project/` pattern, make sure:

- `AGENTS.md`, `CLAUDE.md`, and `GEMINI.md` refer to `project/docs/agents/…`, `project/changelog/…`, `project/troubleshooting/…`, `project/plans/`, and `project/plans-completed/`.
- Index files (`changelog/index.md`, `troubleshooting/index.md`, `plans-completed/index.md`) store paths that include the `project/` prefix (e.g. `project/changelog/docs/2026-03-13-docs-legacy-changelog-migration.md`).
- `project/plans-completed/` is treated as an **index of completed plans and reports**, while `project/changelog/` remains the **canonical record of code and configuration changes**; when archiving a plan that resulted in changes, ensure there is at least one corresponding changelog entry.

---

## Prerequisites

- Git repository initialized
- Access to both repositories:
  - Main project repository (your project)
  - Workflow-Scripts repository (cloned into `<WORKFLOWS_DIR>/` directory)

**Note**: When executing this workflow, replace placeholder values with your actual project details:
- `<PROJECT_NAME>` - Your project name (e.g., "My-App")
- `<PROJECT_PATH>` - Full path to your project (e.g., "/Users/name/projects/my-app")
- `<GIT_REMOTE>` - Your project's git remote URL
- `<WORKFLOWS_DIR>` - Directory name for workflows (commonly `workflows/` or `Workflow-Scripts/`)
- `<WORKFLOWS_REMOTE>` - Git remote for Workflow-Scripts (default: `https://github.com/Rebooted-Dev/Workflow-Scripts`, or your fork)

---

## Updating an existing project that already uses this system

**Use this when:** Your project already has `project/changelog/`, `project/troubleshooting/`, `plans/` (README + TODO), `AGENTS.md`, and (optionally) `docs/agents/`, and you want to bring it in line with the **latest** workflow (e.g. after Workflow-Scripts or conventions were updated — new when-to-update-troubleshooting rules, Change Management wording, or structure).

**Goal:** Refresh convention text and instructions in the right files **without** re-running full initial setup, overwriting existing index data, or re-backing up files unnecessarily.

### What to update

1. **Pull the latest Workflow-Scripts** (so you have the current version of this doc):
   - `cd <WORKFLOWS_DIR> && git pull`

2. **Refresh convention and instruction content** by re-applying only the relevant parts of this workflow:
   - **AGENTS.md** – If the workflow’s Repository Management or Change Management (changelog/troubleshooting) text has changed, update those sections in your `AGENTS.md` to match the templates in **Step 1.4** (Repository Management) and **Step 2.6.2** (slim Change Management). Keep your project-specific values (paths, remotes, project name).
   - **project/troubleshooting/README.md** – Replace the “For AI Agents / Coding Assistants” and “Maintaining the Index” parts with the current content from **Step 2.4** (Create Troubleshooting README.md) so “update the logs” and when-to-add-troubleshooting rules stay in sync.
   - **docs/agents/changelog-and-troubleshooting.md** – If present, replace its content with the full conventions block from **Step 2.6.1** so Changelog, Troubleshooting, and “Interpreting Update the Logs” match the latest workflow. Include the **Completed plans – filing rule** (§ Completed plans) in that doc.
   - **CLAUDE.md / GEMINI.md** – Only if the workflow’s slim template (Step 2.10) changed; merge in any new wording (e.g. Docs/Changelog/troubleshooting references). Do not overwrite project-specific content.

3. **Add any new structure only if missing** (do not replace existing):
   - Missing `project/` or subdirs → create with `mkdir -p project/{KIV,research,build}` and `mkdir -p project/changelog/{added,changed,fixed,improved,docs,refactor,config,plans}` and `mkdir -p project/troubleshooting/{build,runtime,data,environment,security}`.
   - Missing `plans/README.md` or `plans/TODO.md` → add per Step 2.8.
   - Missing `docs/` or `docs/agents/` → create with `mkdir -p docs docs/agents`.

4. **Optionally refresh repo map and sync instructions:** If you added/removed repos or changed remotes, run [04-track-repos-and-agent-map.md](./04-track-repos-and-agent-map.md) (see Step 2.11).

5. **Verify:** Run the checks in **Step 3** (Verification) that apply to the files you changed (e.g. directory structure, agent files present). Do **not** re-run backup or migration steps (Step 2.3, 2.7.3, Step 4) unless you are actually migrating from an old structure.

### What not to do

- **Do not** overwrite `project/changelog/index.md` or `project/troubleshooting/index.md` with empty or template tables — preserve existing rows.
- **Do not** re-back up `CHANGELOG.md` or `TROUBLESHOOTING.md` unless you are doing a first-time migration from single-file logs.
- **Do not** delete or rename existing project/changelog or project/troubleshooting files or directories as part of an “update”; only add or edit convention/instruction content.

### Checklist marking convention

For consistent checklist marking (✅ vs `[ ]`), completion markers, and archiving completed plans, follow the single source of truth:

- **[`../04-documentation/03-mark-completed.md`](../04-documentation/03-mark-completed.md)**

### Quick update checklist (existing project)

- [ ] Pull latest Workflow-Scripts
- [ ] AGENTS.md: Repository Management and Change Management sections match Step 1.4 and Step 2.6.2 (keep project-specific values)
- [ ] project/troubleshooting/README.md: “For AI Agents” and when-to-update-troubleshooting match Step 2.4
- [ ] docs/agents/changelog-and-troubleshooting.md: content matches Step 2.6.1 including **Completed plans – filing rule** (if you use this file)
- [ ] CLAUDE.md / GEMINI.md: updated only if template changed (Step 2.10)
- [ ] Missing category/type folders created; repo map refreshed if needed (Step 2.11)
- [ ] Verification (Step 3) run for changed areas; indexes and existing data preserved

---

## Step 0: Verify Prerequisites

Before proceeding, verify the environment is ready:

```bash
# Navigate to project root
cd <PROJECT_PATH>

# Verify git is initialized
if [ ! -d ".git" ]; then
  echo "ERROR: Not a git repository. Run 'git init' first."
  exit 1
fi
echo "✓ Git repository initialized"

# Verify .gitignore exists (create if missing)
if [ ! -f ".gitignore" ]; then
  touch .gitignore
  echo "✓ Created .gitignore"
else
  echo "✓ .gitignore exists"
fi

# Verify workflows directory exists
if [ ! -d "<WORKFLOWS_DIR>" ]; then
  echo "WARNING: Workflows directory not found at <WORKFLOWS_DIR>/"
  echo "  Clone with: git clone <WORKFLOWS_REMOTE> <WORKFLOWS_DIR>"
else
  echo "✓ Workflows directory exists"
  # Verify it's a git repo
  if [ -d "<WORKFLOWS_DIR>/.git" ]; then
    echo "✓ Workflows is a separate git repository"
  else
    echo "WARNING: Workflows directory is not a git repository"
  fi
fi
```

If any checks fail, resolve them before continuing.

### Placeholder Validation

Before executing any commands with placeholders, verify all placeholders have been replaced with actual values:

```bash
# Check for unreplaced placeholders in this workflow file
grep -n '<PROJECT_NAME>\|<PROJECT_PATH>\|<WORKFLOWS_DIR>\|<GIT_REMOTE>\|<WORKFLOWS_REMOTE>' "<WORKFLOWS_DIR>/00-project-setup/01-setup-project.md" 2>/dev/null

# If the grep returns results, you have unreplaced placeholders
if [ $? -eq 0 ]; then
  echo "⚠ WARNING: Unreplaced placeholders detected above."
  echo "  Replace all <...> placeholders with your actual values before continuing."
  echo "  Common placeholders:"
  echo "    <PROJECT_NAME>  → Your project name (e.g., 'my-app')"
  echo "    <PROJECT_PATH>  → Full path to project (e.g., '/Users/name/projects/my-app')"
  echo "    <WORKFLOWS_DIR> → Workflows directory name (e.g., 'Workflow-Scripts')"
  echo "    <GIT_REMOTE>    → Your project's git remote URL"
  echo "    <WORKFLOWS_REMOTE> → Workflows repo URL (e.g., 'https://github.com/Rebooted-Dev/Workflow-Scripts')"
else
  echo "✓ No unreplaced placeholders found"
fi
```

**Do not proceed** until all placeholders are replaced. Running commands with unreplaced placeholders will cause errors.

---

## Step 1: Set Up Dual Repository Management in AGENTS.md

### 1.1 Check for Existing AGENTS.md

If `AGENTS.md` exists, review it to see if dual repo instructions are already present. If not, add the following section.

**Slim architecture (standard):** Root AGENTS.md should stay slim: essentials only (Execution 1.2, Repository Management 1.3), plus a slim Change Management section and a "Detailed Documentation" section linking to `docs/agents/`. Step 2.6 puts Changelog & Troubleshooting conventions in `docs/agents/changelog-and-troubleshooting.md` and only a short pointer in AGENTS.md; Step 2.9 creates `docs/` and `docs/agents/` and Step 2.9.3 instructs relocating other long sections into topical files in `docs/agents/`.

### 1.2 Add Execution Guidelines Section

Add or update the execution guidelines section in `AGENTS.md`:

```markdown
## Execution
- Where possible, make clever and appropriate use of multiple parallel agents to orchestrate and execute tasks for better efficiency.
- Parallel agents can be used for:
  - Scanning codebases across different directories simultaneously
  - Reviewing different aspects of code (security, performance, style) in parallel
  - Testing multiple hypotheses during debugging
  - Validating changes across multiple files concurrently
- Always verify findings from parallel agents before acting on them
```

### 1.3 Add bugs/regression-test instruction to agent files

So that coding agents (Codex, Cursor, Claude, etc.) add regression tests when fixing bugs, insert the following into the project's agent files:

- **AGENTS.md** – Add this line (e.g. under Execution, Testing Guidelines, or a short "Bugs" section):  
  `- **Bugs:** add regression test when it fits.`
- **CLAUDE.md / GEMINI.md** (optional) – If the project uses these, add the same line so Claude/Cursor and Gemini follow it.

**Exact line to insert:**  
`- **Bugs:** add regression test when it fits.`

When creating or updating AGENTS.md (Steps 1.2, 2.6.2, 2.9.3), include this instruction. When creating CLAUDE.md and GEMINI.md (Step 2.10), add it there as well if those files exist.

### 1.4 Add Repository Management Section

Add this section to `AGENTS.md` (or update existing section). **Critical:** This project has **multiple repositories**, not a single repo. Agents must not assume one repository. **Replace placeholders with your project's actual values.** Prefer "this local project directory" (project root) and relative paths so instructions stay valid on any machine.

```markdown
## Repository Management

**This project has multiple repositories** (multi-repo setup), not a single repository. The main application repo and the local Workflow-Scripts repo are independent; both live under the same project directory on disk.

### 1. <PROJECT_NAME> Repository (This Repository)
- **Location**: This local project directory (the repository root where you are working)
- **Purpose**: Main application code, components, services, documentation
- **Git Remote**: `<GIT_REMOTE>`

**Standard Git Operations:**
```bash
# From project root (this local directory)
git status
git pull
git add .
git commit -m "feat: description of changes"
git push
```

### 2. Workflow-Scripts Repository (local, in <WORKFLOWS_DIR>/)
- **Location**: `<WORKFLOWS_DIR>/` within this local project directory. To add: from project root run `git clone <WORKFLOWS_REMOTE> <WORKFLOWS_DIR>`.
- **Purpose**: Reusable workflow instructions for development tasks (planning, review, development, debug, documentation)
- **Git Remote**: `<WORKFLOWS_REMOTE>`
- **Note**: `<WORKFLOWS_DIR>/` is a separate git repository. The main project must ignore it in `.gitignore` so the main repo never tracks workflow files.

**Standard Git Operations:**
```bash
# From project root, go into workflows directory
cd <WORKFLOWS_DIR>

git status
git pull
git add .
git commit -m "docs: update workflow description"
git push
```

### Managing Both Repositories

**Important**: These repositories are **independent** and should be managed separately:
- Changes to the main project do NOT automatically sync to Workflow-Scripts
- Changes to Workflow-Scripts do NOT automatically sync to the main project
- Each repository has its own git history and version control

**When Working on Main Project (Main Repo):**
- Work from the project root (this local directory).
- Focus on application code, components, services
- Update project-specific documentation in `docs/` (if it exists)
- Always update the changelog for any code change (features, fixes, refactors): create an entry in `project/changelog/<type>/<yyyy-mm-dd>-<type>-<short-title>.md` and add a row at the top of `project/changelog/index.md`. See `project/changelog/README.md` for the template.
- **Completed plans filing rule:** When a plan is completed or when asked to "file" a plan in the changelog, move it from `project/plans/` or `project/build/` to `project/changelog/plans/` (use a `yyyy-mm-dd-` prefix if the name does not already have one), then add a row at the top of `project/changelog/index.md` with Type=plan, Date, Title, and File (e.g. `plans/2026-03-08-my-plan/`). See `docs/agents/changelog-and-troubleshooting.md` (§ Completed plans).
- Update `project/troubleshooting/` only when the work involved a bug, an issue that required debugging/workarounds, or a non-trivial problem worth documenting. Do not add troubleshooting entries for simple code changes, routine refactors, or straightforward feature additions — changelog only for those. See AGENTS.md "Changelog & Troubleshooting Updates."
- The `<WORKFLOWS_DIR>/` directory is **ignored** by the main repo (in `.gitignore`), so it won't be included in main-repo commits.
- Standard operations: `git add .`, `git commit`, `git push` - workflows will NOT be included

**When Working on Workflow-Scripts (local repo):**
- Navigate to the workflows directory: `cd <WORKFLOWS_DIR>/`
- Focus on workflow instructions and templates
- Update workflow documentation in `README.md` and `SHARING_AND_SYNC.md`
- These workflows are shared across multiple projects
- Changes here affect all projects that use these workflows
- Standard operations: `git add .`, `git commit`, `git push` - only workflows will be pushed

**Important Git Behavior:**
- The main project's `.gitignore` must list `<WORKFLOWS_DIR>/` so the workflows directory is never part of the main repo.
- From project root, `git status` / `git add .` / `git commit` do not include `<WORKFLOWS_DIR>/`.
- To push workflow changes, run git commands from inside `<WORKFLOWS_DIR>/` (it has its own `.git`).

**Best Practices:**
- Always commit main project changes from the project root
- Always commit Workflow-Scripts changes from the `<WORKFLOWS_DIR>/` directory
- Use clear commit messages indicating which repository you're working in
- Pull latest changes from both repos before starting work
- Keep workflow improvements in the workflows directory, not in the main repo
```

### 1.5 Verify .gitignore

The main project must **ignore** the workflows directory so the project correctly operates as **multiple repositories**. Ensure `.gitignore` includes the workflows directory:

```bash
# Replace <WORKFLOWS_DIR> with your actual directory name (e.g., "Workflow-Scripts" or "workflows")
# Check if workflows directory is in .gitignore; add with a comment if missing
grep -q "^<WORKFLOWS_DIR>/$" .gitignore || {
  echo "" >> .gitignore
  echo "# Workflow-Scripts (separate repo, managed independently)" >> .gitignore
  echo "<WORKFLOWS_DIR>/" >> .gitignore
}
```

---

## Step 2: Set Up Troubleshooting System

### 2.0 Ensure project directories exist (project/, project/plans/)

Create standard project directories at the project root if they do not already exist. Other workflows (e.g. planning, documentation) expect these.

```bash
mkdir -p project/{KIV,research,build}
mkdir -p project/changelog/{added,changed,fixed,improved,docs,refactor,config,plans}
mkdir -p project/troubleshooting/{build,runtime,data,environment,security}
mkdir -p docs project/plans
# Verify
test -d project && echo "✓ project/ exists"
test -d project/changelog && test -d project/changelog/plans && echo "✓ project/changelog/ (with plans subdir) exists"
test -d project/troubleshooting && echo "✓ project/troubleshooting/ exists"
test -d docs && echo "✓ docs/ exists"
test -d project/plans && echo "✓ project/plans/ exists"
```

- **project/** – Container for KIV, research, build, changelog (type folders + plans subdir, one index), and troubleshooting (category folders + index).
- **project/plans/** – README (map to project dir) and TODO.md (current tasks). **Active plan documents live here** (e.g. `project/plans/yyyy-mm-dd-plan-name.md`). Completed plans are **moved** from `project/plans/` to `project/changelog/plans/` with a row in `project/changelog/index.md` (Type=plan).
- **docs/** – Long-lived documentation (user-facing or project docs).

### 2.1 Check for Existing Troubleshooting Files

Before setting up, check for existing troubleshooting data in multiple possible locations:

```bash
# Check for root-level TROUBLESHOOTING.md
if [ -f "TROUBLESHOOTING.md" ]; then
  echo "Found root-level TROUBLESHOOTING.md - will back up"
fi

# Check for docs/TROUBLESHOOTING.md
if [ -f "docs/TROUBLESHOOTING.md" ]; then
  echo "Found docs/TROUBLESHOOTING.md - will back up"
fi

# Check for existing project/troubleshooting/ directory
if [ -d "project/troubleshooting" ]; then
  echo "Found existing project/troubleshooting/ directory"
  ls -la project/troubleshooting/
fi

# Check for project/troubleshooting/TROUBLESHOOTING.md
if [ -f "project/troubleshooting/TROUBLESHOOTING.md" ]; then
  echo "Found project/troubleshooting/TROUBLESHOOTING.md - will back up"
fi
```

### 2.2 Create Troubleshooting Directory Structure

Create the directory structure under `project/` if it doesn't exist:

```bash
mkdir -p project/troubleshooting/{build,runtime,data,environment,security}
```

### 2.3 Backup Existing Troubleshooting Files

Use the following reusable function to back up any existing troubleshooting files:

```bash
# Reusable backup function
backup_troubleshooting_file() {
  local src="$1"
  local label="$2"
  local note="$3"
  
  if [ -f "$src" ]; then
    BACKUP_DATE=$(date +%Y-%m-%d)
    BACKUP_FILE="project/troubleshooting/TROUBLESHOOTING-backup-${label}-${BACKUP_DATE}.md"
    
    {
      echo "# Backup of ${src}"
      echo ""
      echo "**Backup Date:** ${BACKUP_DATE}"
      echo "**Original Location:** \`${src}\`"
      echo "**Note:** ${note}"
      echo ""
      echo "---"
      echo ""
      cat "$src"
    } > "${BACKUP_FILE}"
    
    echo "✓ Backed up ${src} to ${BACKUP_FILE}"
  fi
}

# Back up all potential troubleshooting files
backup_troubleshooting_file \
  "TROUBLESHOOTING.md" \
  "root" \
  "This file was backed up during initial setup. Original troubleshooting entries should be migrated to the new organized structure."

backup_troubleshooting_file \
  "docs/TROUBLESHOOTING.md" \
  "docs" \
  "This file was backed up during setup. If this file serves as a user-facing troubleshooting guide, it should be maintained separately. Individual troubleshooting entries should go in the troubleshooting/ directory structure."

backup_troubleshooting_file \
  "project/troubleshooting/TROUBLESHOOTING.md" \
  "project-troubleshooting" \
  "This file was backed up during setup. Existing entries should remain in the project/troubleshooting directory structure."
```

### 2.4 Create Troubleshooting README.md

Create `project/troubleshooting/README.md` with the system documentation:

```markdown
# Troubleshooting System

This directory contains organized troubleshooting entries for issues encountered during development. It lives under `project/troubleshooting/`.

## Directory Structure

- `build/` - Build & test issues
- `runtime/` - In-browser/runtime UI or logic bugs
- `data/` - Data, prompts, migrations, persistence issues
- `environment/` - Local setup, Node, .env, permissions, OS quirks
- `security/` - Security advisories & patches
- `index.md` - Chronological index of all entries

## File Naming Convention

Each troubleshooting entry uses this pattern:

```
<yyyy-mm-dd>-<category>-<short-title>.md
```

Examples:
- `2026-01-19-build-css-unexpected-brace.md`
- `2026-01-18-runtime-image-generation-stuck.md`
- `2026-01-18-environment-gemini-api-key-not-configured.md`

## Entry Template

Each entry should include:

```markdown
# <Short Title>
**Date:** <YYYY-MM-DD>  
**Category:** <build|runtime|data|environment|security|...>  
**Status:** <RESOLVED|OPEN|WORKAROUND>

---

## Symptom
- What you observed: errors, logs, screenshots, failing commands.

## Root Cause
- What was actually wrong, in plain language.

## Fix
- Steps you took to resolve it (commands, code changes, config changes).

## Verification
- How you proved the fix worked (tests, builds, manual checks).

## Notes / Lessons
- Takeaways for "future you": patterns, gotchas, quick checks.
```

## Maintaining the Index

The `index.md` file is the single chronological index of all entries. **Newest entries are listed first.**

When adding a new entry:
1. Create the entry file in the appropriate category folder
2. Add a new row at the **top** of the table in `index.md` with: Date, Category, Title, File path, Status

## For AI Agents / Coding Assistants

When instructed to **"update the logs"** or **"update the log files"**, this refers to:
1. **Update the changelog** - Create a new entry in `project/changelog/<type>/<yyyy-mm-dd>-<type>-<short-title>.md` and add a row at the top of `project/changelog/index.md`. See `project/changelog/README.md` for the template. (Completed plans go in `project/changelog/plans/` with Type=plan in the same index.)
2. **Create a troubleshooting entry (only when applicable)** - Add an entry to `project/troubleshooting/` **only when** the work involved: a **bug** (incorrect behavior or crash), an **issue** that required debugging or a workaround, or a **non-trivial problem** (significant investigation, multiple steps, or lessons worth preserving). **Do not** add a troubleshooting entry for simple code changes, routine refactors, or straightforward feature additions — changelog alone is enough.
3. **Update the relevant index** - When adding a changelog entry, update `project/changelog/index.md`; when adding a troubleshooting entry, update `project/troubleshooting/index.md` (new row at top; only when you created a troubleshooting entry in step 2).

**Note about `docs/TROUBLESHOOTING.md`**: If this file exists, it may serve as a user-facing troubleshooting guide with common error states and solutions. It is maintained separately from the `project/troubleshooting/` directory system. Individual troubleshooting entries should go in `project/troubleshooting/`, not in `docs/TROUBLESHOOTING.md`.

See `AGENTS.md` section "Changelog & Troubleshooting Updates" for full guidelines.
```

### 2.5 Create or Update Troubleshooting Index

Create `project/troubleshooting/index.md` if it doesn't exist, or update it if it does:

```markdown
# Troubleshooting Index

Chronological index of troubleshooting entries.  
**Newest entries are listed first.**

| Date       | Category    | Title                                                      | File                                                          | Status   |
|-----------|-------------|------------------------------------------------------------|---------------------------------------------------------------|----------|
```

**Note:** If existing entries exist, preserve them in the table. Only add new entries at the top.

### 2.6 Set Up Changelog & Troubleshooting (in docs/agents, keep AGENTS.md slim)

**Goal:** Keep AGENTS.md slim. Put the full Changelog/Troubleshooting/Plans conventions in `docs/agents/` and reference them from the root file.

#### 2.6.1 Create docs/agents/changelog-and-troubleshooting.md

Ensure `docs/agents/` exists (Step 2.9.1 creates it; if executing steps out of order, run `mkdir -p docs/agents`). Create or update `docs/agents/changelog-and-troubleshooting.md` with the full conventions:

```markdown
# Changelog & Troubleshooting (Agent Conventions)

Full conventions for the `project/changelog/` and `project/troubleshooting/` directory systems, "update the logs" behavior, and plans (README + TODO). Changelog merges change entries and completed plans (one index).

---

## Changelog System (`project/changelog/` directory)
- **When to create changelog entries**: For any code change (features, fixes, refactors, docs, config). One file per change. Also use for **completed plans**: move plan doc to `project/changelog/plans/` with date prefix and add a row to the same index with Type=plan.
- **Location**: Use the `project/changelog/` directory. Do NOT use a single `CHANGELOG.md` file at root or in `docs/`.
- **Structure**:
  - Type folders: `added/`, `changed/`, `fixed/`, `improved/`, `docs/`, `refactor/`, `config/` for short change entries.
  - **`plans/`** subdir for completed/archived full plan documents (date-prefixed filenames).
  - **Single index**: `project/changelog/index.md` — columns Date | Type | Title | File | Notes. Types include the above plus `plan` for archived plans.
  - File naming for changes: `<yyyy-mm-dd>-<type>-<short-title>.md`; for plans: `yyyy-mm-dd-<plan-name>.md` in `project/changelog/plans/`.
- **Index maintenance**: Always update `project/changelog/index.md` when adding a change entry or archiving a plan (add row at the top of the table).
- **Template**: See `project/changelog/README.md` for the entry template and full conventions.

## Troubleshooting System (`project/troubleshooting/` directory)
- **When to create troubleshooting entries**: Document bugs, issues, or non-trivial problems that required investigation and resolution.
  - **Bugs**: Any defect that causes incorrect behavior or crashes
  - **Issues**: Problems that required debugging, investigation, or workarounds
  - **Non-trivial problems**: Issues that took significant time to resolve, involved multiple steps, or have lessons worth preserving (e.g., complex configuration issues, unexpected framework behavior, tricky debugging scenarios)
- **When NOT to create troubleshooting entries**: Simple code changes, routine refactoring, or straightforward feature additions that don't involve problem-solving. Changelog only for those.
- **Location**: Use the `project/troubleshooting/` directory. Do NOT create individual entries in `TROUBLESHOOTING.md` or `docs/TROUBLESHOOTING.md`.
- **Structure**:
  - Create individual files in the appropriate category folder (`build/`, `runtime/`, `data/`, `environment/`, `security/`)
  - File naming: `<yyyy-mm-dd>-<category>-<short-title>.md`
  - Each entry must include: Date, Category, Status, Symptom, Root Cause, Fix, Verification, Notes/Lessons
- **Index maintenance**: Always update `project/troubleshooting/index.md` when adding a new entry (add row at the top of the table).
- **Template**: See `project/troubleshooting/README.md` for the entry template and full conventions.

**Note about `docs/TROUBLESHOOTING.md`**: If this file exists, it serves as a user-facing troubleshooting guide with common error states and solutions. It is maintained separately from the `project/troubleshooting/` directory system. Individual troubleshooting entries should go in `project/troubleshooting/`, not in `docs/TROUBLESHOOTING.md`.

## Interpreting "Update the Logs"
When instructed to "update the logs" or "update the log files", this refers to:
1. **Changelog** – Create a new entry in `project/changelog/<type>/<yyyy-mm-dd>-<type>-<short-title>.md` and add a row at the top of `project/changelog/index.md`. Use the appropriate type folder (added, changed, fixed, improved, docs, refactor, config). For a **completed plan**, move the plan to `project/changelog/plans/` with date prefix and add a row with Type=plan. See `project/changelog/README.md` for the template.
2. **Troubleshooting entries** – Add entries to `project/troubleshooting/` **only when** the work involved fixing a bug, resolving an issue that required debugging/workarounds, or solving a non-trivial problem (investigation, multiple steps, or lessons worth preserving). **Do not** add troubleshooting entries for simple code changes, routine refactors, or straightforward feature additions — use the changelog only for those.
3. **Both** – When a bug/issue/non-trivial fix requires both a troubleshooting entry (for the problem-solving process) **and** a changelog entry (for the change itself).

**Note**: This project does NOT use application logging files (`.log` files). The "logs" refer to the `project/changelog/` directory and the troubleshooting knowledge base in `project/troubleshooting/`.

## Completed plans – filing rule (operating rule)

**When** a plan is completed, or the user asks to "file" or "move to changelog" a plan:

1. **Move** the plan (file or directory) from `project/plans/` or `project/build/` to `project/changelog/plans/`.
2. **Naming**: If the plan name does not already start with `yyyy-mm-dd-`, prepend the date (e.g. `2026-03-08-my-plan`). Directories keep their name; single files become `yyyy-mm-dd-<name>.md` in `project/changelog/plans/`.
3. **Index**: Add a new row at the **top** of `project/changelog/index.md` with:
   - **Date**: YYYY-MM-DD
   - **Type**: `plan`
   - **Title**: Short descriptive title (e.g. "LM Studio integration plan")
   - **File**: Path relative to `project/changelog/`, e.g. `plans/2026-03-08-my-plan/` for a directory or `plans/2026-03-08-my-plan.md` for a single file.

Optional: add a **docs** changelog entry recording that the plan was moved (e.g. "Plan X moved to changelog/plans") and add a docs row to the same index.

See `project/changelog/plans/README.md` for naming and index conventions (if that file exists in the project).

---

## Documentation, Plans & Project Directories
- **Changelog**: `project/changelog/` — one index for change entries and completed plans (type folders + `plans/` subdir). Always update `project/changelog/index.md` (new row at top).
- **Troubleshooting**: `project/troubleshooting/` — one file per issue in category folders; always update `project/troubleshooting/index.md` (new row at top).
- **Docs**: `docs/` holds project documentation; `docs/agents/` holds agent-facing detailed guides. Root AGENTS.md stays slim and links to `docs/agents/`.
- **Plans**: `project/plans/README.md` is a map to the project dir (KIV, research, build, changelog, troubleshooting). `project/plans/TODO.md` holds current tasks and is kept up to date. Active plan documents live in `project/plans/` or `project/build/`. **Completed plans must be filed in `project/changelog/plans/`** with date prefix and a row in `project/changelog/index.md` (Type=plan) — see § Completed plans – filing rule above.
```

#### 2.6.2 Update AGENTS.md with a slim Change Management section only

In `AGENTS.md`, add or update the **Change Management** section so it stays **slim**: state the mandatory rule and link to the detailed doc. Do **not** paste the full Changelog/Troubleshooting block into AGENTS.md.

**In AGENTS.md use only:**

```markdown
## Change Management
- Unless instructed by the developer, do not make code changes to the user interface.
- **After code changes or when debugging:** Update the changelog and/or troubleshooting using the `project/changelog/` and `project/troubleshooting/` directory systems (one file per entry, update the relevant index). Add a **troubleshooting** entry only when the work involved a bug, an issue that required debugging/workarounds, or a non-trivial problem; do not add troubleshooting entries for simple code changes, routine refactors, or straightforward feature additions (changelog only for those). For bug/issue/non-trivial fixes, create **both** a troubleshooting entry and a changelog entry. For full conventions and "update the logs" behavior, see **[Changelog & Troubleshooting](docs/agents/changelog-and-troubleshooting.md)**.
```

Ensure AGENTS.md has a **Detailed Documentation** section (or add it in Step 2.9.3) that includes a link to `docs/agents/changelog-and-troubleshooting.md`.

### 2.7 Migrate Troubleshooting Backup to Folder System (When Migrating)

**Purpose:** The backup created in 2.3 preserves the old monolithic file but does **not** by itself populate the new folder system. This step is the **defined task** to extract that content into individual files and the index so the folder system becomes the source of truth.

**When to do this:** When an existing project has one or more troubleshooting backups (e.g. `project/troubleshooting/TROUBLESHOOTING-backup-root-*.md`) and you want the new structure to contain that content. If the project is brand new with no prior TROUBLESHOOTING.md, skip this step.

**Procedure:**

1. **Choose the backup to migrate** – Typically the most recent `project/troubleshooting/TROUBLESHOOTING-backup-*.md` (e.g. `TROUBLESHOOTING-backup-root-YYYY-MM-DD.md`). Open it and note the structure (e.g. entries under `### Title (YYYY-MM-DD)` or `## Title`, often separated by `---`).

2. **Identify discrete entries** – Split the backup by clear boundaries. Common patterns:
   - Each entry starts with a heading like `### Build Error: ... (2026-01-12)` or `## Issue Title`.
   - Entries may be separated by horizontal rules `---`.
   - Map each heading/title to a **category** (`build`, `runtime`, `data`, `environment`, `security`) from the content or title (e.g. "Build Error" → `build`, "Admin System Page" runtime error → `runtime`).

3. **For each entry:**
   - Derive a short **slug** from the title (e.g. `multiple-missing-dependencies`).
   - Extract **date** from the heading or body (e.g. `2026-01-12`).
   - Create file: `project/troubleshooting/<category>/<yyyy-mm-dd>-<category>-<slug>.md`.
   - Fill the standard template (see `project/troubleshooting/README.md`): Title, Date, Category, Status, Symptom (Problem/Observed), Root Cause, Fix (Resolution/Steps), Verification, Notes/Lessons. Copy or adapt content from the backup entry into these sections.
   - Add a row at the **top** of the table in `project/troubleshooting/index.md`: Date, Category, Title (short), File path (e.g. `project/troubleshooting/build/2026-01-12-build-multiple-missing-dependencies.md`), Status (e.g. RESOLVED).

4. **Verify** – Ensure every meaningful entry from the backup has a corresponding file under `project/troubleshooting/<category>/` and a row in `project/troubleshooting/index.md`. Optionally remove or archive the backup only after verification.

**For AI agents:** Treat this as a required migration task when the project has existing troubleshooting content. Parse the backup, create one file per entry, and update the index; do not leave migration as an unspecified “if needed” follow-up.

### 2.8 Optional: Changelog Folder System and Migration

**Purpose:** Many projects keep a single `CHANGELOG.md` (or `docs/CHANGELOG.md`). This step is **optional** and only needed if the project wants a **folder-based changelog** (e.g. one file per version or per release) with an index or a main changelog that links to them.

**When to do this:** When the project explicitly wants changelog content in a folder structure (e.g. `changelog/` or `docs/changelog/`) instead of or in addition to a single `CHANGELOG.md`. If the project is fine with one file, skip this step.

**Procedure (if using a changelog folder):**

1. **Create structure** – e.g. `changelog/` at project root or `docs/changelog/`. Decide convention: one file per version (e.g. `changelog/0.3.17.md`) or per date (e.g. `changelog/2026-02-06.md`). Optionally add `changelog/README.md` describing the layout and link from the main `CHANGELOG.md` or docs.

2. **Migrate existing CHANGELOG.md** – If `CHANGELOG.md` (or `docs/CHANGELOG.md`) exists:
   - Parse it by version/section (e.g. `## [0.3.17] - 2026-02-06`).
   - For each version/release, create one file in `changelog/` (e.g. `changelog/0.3.17.md` or `changelog/2026-02-06-v0.3.17.md`) containing that version’s content.
   - Update the main `CHANGELOG.md` to either (a) list versions with links to the per-version files, or (b) remain the single source of truth and use the folder only for archival/extra detail—document the chosen convention in AGENTS.md or docs.

3. **Document in AGENTS.md** – If you adopt a folder-based changelog, add or update the “Update the logs” / changelog instructions so agents know to add new entries to the folder (e.g. create `changelog/<version>.md`) and/or update the main CHANGELOG and index as agreed.

**Why the default setup does not include this:** The workflow’s default is a single changelog file (`CHANGELOG.md` or `docs/CHANGELOG.md`) because that’s the most common pattern. Changelog folder system and migration are optional and only required when the project decides to use that structure.

---

## Step 2.7: Set Up Changelog System

The changelog lives under **`project/changelog/`**: **type subdirectories** for change entries, a **`plans/`** subdir for completed plan documents, and a **single index** (newest first). Types include added, changed, fixed, improved, docs, refactor, config, and **plan** (for archived plans). This keeps all changes and completed plans in one place.

### 2.7.1 Check for Existing Changelog Files

Before setting up, check for existing changelog data:

```bash
# Check for root-level CHANGELOG.md
if [ -f "CHANGELOG.md" ]; then
  echo "Found root-level CHANGELOG.md - will back up"
fi

# Check for docs/CHANGELOG.md
if [ -f "docs/CHANGELOG.md" ]; then
  echo "Found docs/CHANGELOG.md - will back up"
fi

# Check for existing project/changelog/ or root changelog/ directory
if [ -d "project/changelog" ]; then
  echo "Found existing project/changelog/ directory"
  ls -la project/changelog/
fi
if [ -d "changelog" ]; then
  echo "Found existing root changelog/ directory (will migrate to project/changelog/)"
fi
```

### 2.7.2 Create Changelog Directory Structure

Create the directory structure under `project/`. Types align with typical changelog sections and Conventional Commits; include `plans/` for completed plan docs:

```bash
mkdir -p project/changelog/{added,changed,fixed,improved,docs,refactor,config,plans}
```

- **added/** – New features, capabilities
- **changed/** – Changes in existing behavior or API
- **fixed/** – Bug fixes
- **improved/** – Improvements (performance, UX, DX) that aren't strictly "added" or "fixed"
- **docs/** – Documentation-only changes
- **refactor/** – Code refactoring, no behavior change
- **config/** – Configuration, tooling, or environment changes

### 2.7.3 Backup Existing CHANGELOG Files

Back up any existing single-file changelog before migrating:

```bash
backup_changelog_file() {
  local src="$1"
  local label="$2"
  local note="$3"

  if [ -f "$src" ]; then
    BACKUP_DATE=$(date +%Y-%m-%d)
    mkdir -p project/changelog
    BACKUP_FILE="project/changelog/CHANGELOG-backup-${label}-${BACKUP_DATE}.md"

    {
      echo "# Backup of ${src}"
      echo ""
      echo "**Backup Date:** ${BACKUP_DATE}"
      echo "**Original Location:** \`${src}\`"
      echo "**Note:** ${note}"
      echo ""
      echo "---"
      echo ""
      cat "$src"
    } > "${BACKUP_FILE}"

    echo "✓ Backed up ${src} to ${BACKUP_FILE}"
  fi
}

backup_changelog_file \
  "CHANGELOG.md" \
  "root" \
  "Single-file changelog backed up during setup. Migrate entries to project/changelog/<type>/<yyyy-mm-dd>-<type>-<short-title>.md and add rows to project/changelog/index.md."

backup_changelog_file \
  "docs/CHANGELOG.md" \
  "docs" \
  "Single-file changelog backed up during setup. Migrate entries to project/changelog/ directory structure."
```

### 2.7.4 Create Changelog README.md

Create `project/changelog/README.md` with the system documentation:

```markdown
# Changelog System

This directory contains organized changelog entries (one file per change) and completed plan documents. **Newest entries are listed first** in `index.md`. One index covers both change entries and archived plans (Type=plan).

## Directory Structure (by type)

- `added/` - New features, capabilities
- `changed/` - Changes in existing behavior or API
- `fixed/` - Bug fixes
- `improved/` - Improvements (performance, UX, DX)
- `docs/` - Documentation-only changes
- `refactor/` - Code refactoring
- `config/` - Configuration, tooling, environment
- `plans/` - Completed/archived full plan documents (date-prefixed filenames); add row to index with Type=plan
- `index.md` - Chronological index of all entries (columns: Date | Type | Title | File | Notes). Types include the above plus `plan`.

## File Naming Convention

Each entry uses this pattern:

\`\`\`
<yyyy-mm-dd>-<type>-<short-title>.md
\`\`\`

Examples:
- `2026-02-01-added-claude-gemini-slim-files.md`
- `2026-01-22-fixed-intro-window-dragging.md`
- `2026-01-18-docs-readme-dev-all.md`

## Entry Template

Each entry should include:

\`\`\`markdown
# <Short Title>
**Date:** <YYYY-MM-DD>
**Type:** <added|changed|fixed|improved|docs|refactor|config>

---

## Summary
- One or two sentences describing the change.

## Scope (optional)
- Component, area, or ticket reference if relevant.
\`\`\`

## Maintaining the Index

The `index.md` file is the single chronological index. **Newest entries are listed first.**

When adding a new entry:
1. Create the entry file in the appropriate type folder
2. Add a new row at the **top** of the table in `index.md` with: Date, Type, Title, File
```

### 2.7.5 Create or Update Changelog Index

Create `project/changelog/index.md` if it doesn't exist:

```markdown
# Changelog Index

Chronological index of changelog entries and completed plans.  
**Newest entries are listed first.** Type can be added, changed, fixed, improved, docs, refactor, config, or plan.

| Date       | Type    | Title | File | Notes |
|-----------|---------|-------|------|-------|
```

**Note:** If migrating from a single-file CHANGELOG or from plans-completed, preserve existing entries in the table (newest at top). Only add new entries at the top. For completed plans, use Type=plan and File pointing to `project/changelog/plans/yyyy-mm-dd-<name>.md`.

### 2.7.6 AGENTS.md and the Changelog System

Do **not** add a long changelog section to AGENTS.md. Keep the root file slim: ensure AGENTS.md has only the **slim Change Management** section and a link to `docs/agents/changelog-and-troubleshooting.md` (see Step 2.6.2). The full "Interpreting Update the Logs" and changelog conventions live in that doc.

---

## Step 2.8: Set Up project/plans/ (README and TODO) and Project Dirs

Ensure `project/` and its subdirs exist (Step 2.0, 2.7); then create **`project/plans/README.md`** (map to project dir) and **`project/plans/TODO.md`** (current tasks). Active plan documents live in `project/build/`. Completed plans are archived to **`project/changelog/plans-completed/`** with a date prefix and a row in **`project/changelog/index.md`** (Type=plan).

### 2.8.1 Ensure project/ and changelog structure exist

From Step 2.0 and 2.7, `project/` should have KIV, research, build, changelog (type folders + plans-completed subdir + single index), and troubleshooting. If not already done, run those steps.

### 2.8.2 Create project/plans/README.md

Create `project/plans/README.md` (if it doesn't exist) with a short map of the project directory:

```markdown
# Plans – Map to Project Directory

This directory holds the **map** to the project structure and is the place for **active plan documents**. Completed plans are archived under `project/changelog/plans/`, not here.

## Project directory map

- **project/KIV/** – Keep in view / backlog
- **project/research/** – Research and discovery artifacts
- **project/build/** – Build artifacts (optional; active plans can live here or in this directory)
- **project/plans/** – **Active plan documents** (this directory). Put implementation plans, proposals, and in-progress plan docs here (e.g. `project/plans/yyyy-mm-dd-plan-name.md`). Also holds `README.md` (this file) and `TODO.md` (current task list).
- **project/changelog/** – Change entries (type folders) and **completed plans only** (`changelog/plans/`). One index: `project/changelog/index.md` (Type includes `plan` for archived plans)
- **project/troubleshooting/** – Troubleshooting entries by category and index

## Where to put things

- **Active plan or report** → **`project/plans/`** (this directory), e.g. `project/plans/2026-03-07-my-implementation-plan.md`. Or add a task to `project/plans/TODO.md`. Do **not** put active plans in `project/changelog/plans/` — that is only for completed/archived plans.
- **Change entry** → `project/changelog/<type>/` + row in `project/changelog/index.md`
- **Completed plan** → When a plan is done, **move** it from `project/plans/` to `project/changelog/plans/` with date prefix (e.g. `yyyy-mm-dd-<name>.md`), and add a row at the top of `project/changelog/index.md` with Type=plan.
- **Troubleshooting entry** → `project/troubleshooting/<category>/` + row in `project/troubleshooting/index.md`

## Current tasks

See **project/plans/TODO.md** for the current task list. Keep it updated as tasks involving the project dir are completed.
```

### 2.8.3 Create project/plans/TODO.md

Create `project/plans/TODO.md` (if it doesn't exist) with a template for current tasks:

```markdown
# Current Tasks

Keep this file up to date as tasks involving the project directory are completed (check off items, add changelog row or troubleshooting entry as needed).

## Active

- [ ] (Add current tasks here)
```

### 2.8.4 Archiving a completed plan (completed plans filing rule)

When a plan is confirmed completed, or the user asks to "file" or "move to changelog" a plan (e.g. after running 02-confirm-execution or 03-execute-and-confirm):

1. **Move** (do not leave a duplicate copy) the plan document out of `project/plans/` or `project/build/` into **`project/changelog/plans-completed/`**. Use a date prefix if the name does not already have one: `yyyy-mm-dd-<plan-name>.md` (single file) or keep the directory name (e.g. `2026-03-08-my-plan/`). After this move, the original plan file should no longer appear under `project/plans/`.
2. Add a new row at the **top** of **`project/changelog/index.md`** with: Date (YYYY-MM-DD), Type=`plan`, Title, File path relative to `project/changelog/` (e.g. `plans-completed/2026-03-08-my-plan/` or `plans-completed/2026-03-01-my-plan.md`), and optional Notes.

Agent files (AGENTS.md, docs/agents/changelog-and-troubleshooting.md, CLAUDE.md, GEMINI.md) must instruct agents to follow this rule; see Step 1.4, Step 2.6.1, and Step 2.10.

---

## Step 2.9: Set Up docs and Slim AGENTS Structure (Standard)

Create `docs/` and `docs/agents/` at the project root if they don't already exist. Every project uses this structure so that root AGENTS.md can stay slim and point to detailed documentation in `docs/agents/`.

### 2.9.1 Create docs and docs/agents

```bash
# From project root
cd <PROJECT_PATH>

# Create docs directory only if it doesn't exist
if [ ! -d "docs" ]; then
  mkdir -p docs
  echo "✓ Created docs/"
else
  echo "✓ docs/ already exists"
fi

# Create docs/agents for agent-facing detailed documentation
if [ ! -d "docs/agents" ]; then
  mkdir -p docs/agents
  echo "✓ Created docs/agents/"
else
  echo "✓ docs/agents/ already exists"
fi
```

### 2.9.2 Slim AGENTS architecture (standard)

- **Root AGENTS.md** – Keep only essentials in the root file: Execution (Step 1.2), Repository Management (Step 1.3), a slim Change Management section (Step 2.6.2), and a **"Detailed Documentation"** section with links to `docs/agents/*`. Do **not** put long Changelog/Troubleshooting/Plans prose or full Project Structure/Build/Coding/Testing/Commit/Config sections in the root file — those belong in `docs/agents/`.
- **docs/agents/** – Holds detailed guides. The setup workflow creates at least `changelog-and-troubleshooting.md` (Step 2.6.1). As a standard task, create other topical files (Step 2.9.3) by relocating content from AGENTS.md so the root file stays slim.

### 2.9.3 Create topical files in docs/agents and keep AGENTS.md slim (standard task)

**Standard task:** Separate long sections out of AGENTS.md into smaller topical files under `docs/agents/`, so the root file stays slim. Perform this step as part of every setup.

1. **If AGENTS.md contains long sections** such as "Project Structure & Module Organization", "Build, Test, and Development Commands", "Coding Style & Naming Conventions", "Testing Guidelines", "Commit & Pull Request Guidelines", or "Configuration & Secrets":
   - Create corresponding files in `docs/agents/` with that content. Suggested mapping:
     - **Project Structure & Module Organization** → `docs/agents/project-structure.md`
     - **Build, Test, and Development Commands** → `docs/agents/development-workflow.md` (or a dedicated `build-and-test.md` if preferred)
     - **Coding Style & Naming Conventions** → `docs/agents/coding-standards.md`
     - **Testing Guidelines** → `docs/agents/testing-strategy.md` (or include in `development-workflow.md`)
     - **Commit & Pull Request Guidelines** → `docs/agents/commit-workflow.md` (or include in `development-workflow.md`)
     - **Configuration & Secrets** → `docs/agents/development-workflow.md` or `docs/agents/security-guidelines.md`
   - Projects may combine topics into fewer files (e.g. one `development-workflow.md` covering build, test, commit, and config) to reduce the number of docs/agents files.
   - After creating the topical file(s), **remove** those long sections from AGENTS.md and replace them with a single **"Detailed Documentation"** section that lists links to each created file and to `docs/agents/changelog-and-troubleshooting.md`.

2. **Ensure AGENTS.md ends with a "Detailed Documentation" section** that includes:
   - Link to [Changelog & Troubleshooting](docs/agents/changelog-and-troubleshooting.md) (created in Step 2.6.1).
   - Links to any other `docs/agents/*.md` files created (e.g. project-structure.md, development-workflow.md, coding-standards.md). Create placeholder files with minimal content if the project does not yet have detailed docs, so the links resolve.

3. **If AGENTS.md is already slim** (only Execution, Repository Management, slim Change Management, and a short "Detailed Documentation" list): create any docs/agents files that are linked but missing (e.g. stub or placeholder content), so that "Detailed Documentation" links do not break.

**Summary:** As a standard task, the workflow must **relocate** detailed content from AGENTS.md into `docs/agents/` and keep AGENTS.md to essentials + links. It must not add the full Changelog/Troubleshooting/Plans or full Project Structure/Build/Coding sections into the root file.

---

## Step 2.10: Set Up Slim CLAUDE.md and GEMINI.md (Standard)

**Standard task:** Create slim **CLAUDE.md** and **GEMINI.md** at the project root as part of setup. Create each file if it does not already exist (do not overwrite existing). These files follow the same slim pattern as AGENTS.md: essentials only, plus a "Detailed Documentation" section linking to `docs/agents/`. They are used by Claude/Cursor and Gemini assistants; for repository management, changelog, and troubleshooting they reference AGENTS.md.

### 2.10.1 Create CLAUDE.md (standard; create if missing)

Create `CLAUDE.md` as part of standard setup. If the file does not exist, create it with the content below; if it exists, do not overwrite. **Replace `<PROJECT_NAME>` and `<PROJECT_DESCRIPTION>` with your project's values.**

```markdown
# Repository Guidelines (Claude / Cursor)

<PROJECT_NAME>: <PROJECT_DESCRIPTION>

## Core Principles

- Follow the project's architectural principles (prompt externalization, API encapsulation, configuration-driven, parallel execution where appropriate).
- See AGENTS.md for Execution, Repository Management, Changelog & Troubleshooting.

## Essential Standards

- **Coding**: 2 spaces, single quotes, semicolons; PascalCase components, camelCase functions/variables; types in `types.ts`, constants in `constants.ts`.
- **Commits**: Conventional Commits (`feat:`, `fix:`, `docs:`, etc.).
- **Docs**: Update changelog (`project/changelog/` directory) and troubleshooting (`project/troubleshooting/`) when applicable (see AGENTS.md).
- **Plans**: See `project/plans/README.md` (map to project dir) and `project/plans/TODO.md` (current tasks). Active plans in `project/plans/` or `project/build/`. **Completed plans filing rule:** When a plan is completed or the user asks to file it, move it to `project/changelog/plans/` (date-prefix if needed) and add a row at the top of `project/changelog/index.md` (Type=plan). See [Changelog & Troubleshooting](docs/agents/changelog-and-troubleshooting.md) § Completed plans – filing rule.

## Quick Reference

- **Build**: `npm run dev` (development), `npm run build` (production).
- **Project structure**: See [Project Structure](docs/agents/project-structure.md).
- **Changelog, troubleshooting, docs, plans**: See AGENTS.md (project/changelog/ and project/troubleshooting/; plans/README and TODO).

## Detailed Documentation

For comprehensive information, see:

- [Project Structure & Organization](docs/agents/project-structure.md)
- [Development Workflow](docs/agents/development-workflow.md)
- [Coding Standards](docs/agents/coding-standards.md)
- [Testing Strategy](docs/agents/testing-strategy.md)
- [Commit & PR Workflow](docs/agents/commit-workflow.md)
- [Documentation Workflow](docs/agents/documentation-workflow.md)
- [Security Guidelines](docs/agents/security-guidelines.md)

For repository management, changelog, troubleshooting, and plans (README + TODO), see **AGENTS.md**.
```

### 2.10.2 Create GEMINI.md (standard; create if missing)

Create `GEMINI.md` as part of standard setup. If the file does not exist, create it with the content below; if it exists, do not overwrite. **Replace `<PROJECT_NAME>` and `<PROJECT_DESCRIPTION>` with your project's values.**

```markdown
# Repository Guidelines (Gemini)

<PROJECT_NAME>: <PROJECT_DESCRIPTION>

## Core Principles

- Follow the project's architectural principles (prompt externalization, API encapsulation, configuration-driven, parallel execution where appropriate).
- See AGENTS.md for Execution, Repository Management, Changelog & Troubleshooting.

## Essential Standards

- **Coding**: 2 spaces, single quotes, semicolons; PascalCase components, camelCase functions/variables; types in `types.ts`, constants in `constants.ts`.
- **Commits**: Conventional Commits (`feat:`, `fix:`, `docs:`, etc.).
- **Docs**: Update changelog (`project/changelog/` directory) and troubleshooting (`project/troubleshooting/`) when applicable (see AGENTS.md).
- **Plans**: See `project/plans/README.md` (map to project dir) and `project/plans/TODO.md` (current tasks). Active plans in `project/plans/` or `project/build/`. **Completed plans filing rule:** When a plan is completed or the user asks to file it, move it to `project/changelog/plans/` (date-prefix if needed) and add a row at the top of `project/changelog/index.md` (Type=plan). See [Changelog & Troubleshooting](docs/agents/changelog-and-troubleshooting.md) § Completed plans – filing rule.

## Quick Reference

- **Build**: `npm run dev` (development), `npm run build` (production).
- **Project structure**: See [Project Structure](docs/agents/project-structure.md).
- **Changelog, troubleshooting, docs, plans**: See AGENTS.md (project/changelog/ and project/troubleshooting/; plans/README and TODO).

## Detailed Documentation

For comprehensive information, see:

- [Project Structure & Organization](docs/agents/project-structure.md)
- [Development Workflow](docs/agents/development-workflow.md)
- [Coding Standards](docs/agents/coding-standards.md)
- [Testing Strategy](docs/agents/testing-strategy.md)
- [Commit & PR Workflow](docs/agents/commit-workflow.md)
- [Documentation Workflow](docs/agents/documentation-workflow.md)
- [Security Guidelines](docs/agents/security-guidelines.md)

For repository management, changelog, troubleshooting, and plans (README + TODO), see **AGENTS.md**.
```

### 2.10.3 Bash: Create CLAUDE.md and GEMINI.md (standard step; create if missing)

**Standard task:** Perform this step for every project. Create `CLAUDE.md` and `GEMINI.md` if they do not exist; do not overwrite existing files.

```bash
# From project root
cd <PROJECT_PATH>

# Replace placeholders for your project
PROJECT_NAME="<PROJECT_NAME>"
PROJECT_DESC="<PROJECT_DESCRIPTION>"

# Standard: ensure CLAUDE.md exists (create if missing)
if [ ! -f "CLAUDE.md" ]; then
  # (Write the CLAUDE.md content above, with PROJECT_NAME and PROJECT_DESC substituted)
  echo "✓ Created CLAUDE.md (slim template)"
else
  echo "✓ CLAUDE.md already exists (not overwritten)"
fi

# Standard: ensure GEMINI.md exists (create if missing)
if [ ! -f "GEMINI.md" ]; then
  # (Write the GEMINI.md content above, with PROJECT_NAME and PROJECT_DESC substituted)
  echo "✓ Created GEMINI.md (slim template)"
else
  echo "✓ GEMINI.md already exists (not overwritten)"
fi
```

**Note:** When executing this workflow, perform this step as part of standard setup. Write the full markdown content (with placeholders replaced) to `CLAUDE.md` and `GEMINI.md` when the files do not exist. Do not overwrite existing CLAUDE.md or GEMINI.md.

---

## Step 2.11: Execute Track Repos and Agent Map Workflow

After setting up or updating the project (including AGENTS.md, CLAUDE.md, and GEMINI.md), **activate and execute** the Track Repos and Agent Map workflow so that:

1. All Git repositories in the project are discovered and listed.
2. AGENTS.md, CLAUDE.md, and GEMINI.md (and optionally `docs/agents/repository-map.md`) are updated with a **Tracked Repositories** section: directory path → remote URL, purpose, status.
3. Sync, pull, and push instructions are documented for each repo and for the project as a whole.

**Action:** Follow and complete every step in [04-track-repos-and-agent-map.md](./04-track-repos-and-agent-map.md):

- **Step 1** – Run the discovery commands from the project root; record the repo map (path, remote, branch for each repo).
- **Step 2** – Add or update the “Tracked Repositories” (and optional table) in AGENTS.md, CLAUDE.md, and GEMINI.md (or link to `docs/agents/repository-map.md`).
- **Step 3** – Document when to sync and the per-repo pull/push commands (and any project-specific sync script).
- **Step 4** – Optionally add or update the “Repository Management” section in the agent files with clear per-repo instructions.

When **setting up a new project**, run this after Step 2.10 (so the slim agent files exist). When **updating an existing project** (e.g. adding a new nested repo or changing remotes), run this workflow again to refresh the repo map and sync instructions.

---

## Step 3: Verification

After setup, verify everything is correct:

### 3.1 Verify Git Configuration

```bash
# From project root - workflows should be ignored
cd <PROJECT_PATH>
git status | grep <WORKFLOWS_DIR> || echo "✓ <WORKFLOWS_DIR>/ is properly ignored"

# From workflows directory - should be separate repo
cd <WORKFLOWS_DIR>
git remote -v && echo "✓ workflows is separate repo"
```

### 3.2 Verify Project and Troubleshooting Structure

```bash
# Project container and subdirs
test -d project && echo "✓ project/ exists"
test -d project/KIV && test -d project/research && test -d project/build && echo "✓ project/ subdirs (KIV, research, build) exist"

# Troubleshooting under project/
test -d project/troubleshooting/build && echo "✓ project/troubleshooting/build/ exists"
test -d project/troubleshooting/runtime && echo "✓ project/troubleshooting/runtime/ exists"
test -d project/troubleshooting/data && echo "✓ project/troubleshooting/data/ exists"
test -d project/troubleshooting/environment && echo "✓ project/troubleshooting/environment/ exists"
test -d project/troubleshooting/security && echo "✓ project/troubleshooting/security/ exists"
test -f project/troubleshooting/README.md && echo "✓ project/troubleshooting/README.md exists"
test -f project/troubleshooting/index.md && echo "✓ project/troubleshooting/index.md exists"
```

### 3.3 Verify Changelog Structure

```bash
# Check project/changelog (type folders + plans subdir + single index)
test -d project/changelog/added && echo "✓ project/changelog/added/ exists"
test -d project/changelog/changed && echo "✓ project/changelog/changed/ exists"
test -d project/changelog/fixed && echo "✓ project/changelog/fixed/ exists"
test -d project/changelog/improved && echo "✓ project/changelog/improved/ exists"
test -d project/changelog/docs && echo "✓ project/changelog/docs/ exists"
test -d project/changelog/refactor && echo "✓ project/changelog/refactor/ exists"
test -d project/changelog/config && echo "✓ project/changelog/config/ exists"
test -d project/changelog/plans && echo "✓ project/changelog/plans/ exists"
test -f project/changelog/README.md && echo "✓ project/changelog/README.md exists"
test -f project/changelog/index.md && echo "✓ project/changelog/index.md exists"
```

### 3.4 Verify project/plans/ (README and TODO)

```bash
# Check project/plans/ with README (map) and TODO (current tasks)
test -d project/plans && echo "✓ project/plans/ exists"
test -f project/plans/README.md && echo "✓ project/plans/README.md exists"
test -f project/plans/TODO.md && echo "✓ project/plans/TODO.md exists"
```

### 3.5 Verify docs and docs/agents

```bash
# Check docs directories exist at project root
test -d docs && echo "✓ docs/ exists"
test -d docs/agents && echo "✓ docs/agents/ exists"
```

### 3.6 Verify slim CLAUDE.md and GEMINI.md

```bash
# Standard verification: slim agent files must exist (created in Step 2.10)
test -f CLAUDE.md && echo "✓ CLAUDE.md exists"
test -f GEMINI.md && echo "✓ GEMINI.md exists"
```

### 3.7 Verify Tracked Repositories Map (Step 2.11)

After executing [04-track-repos-and-agent-map.md](./04-track-repos-and-agent-map.md), confirm the repo map is present:

```bash
# Agent files should contain a "Tracked Repositories" (or "Repository Map") section
grep -l "Tracked Repositories\|Repository Map" AGENTS.md CLAUDE.md GEMINI.md 2>/dev/null && echo "✓ Repo map present in agent files"
# Or, if using docs/agents/repository-map.md:
test -f docs/agents/repository-map.md && echo "✓ docs/agents/repository-map.md exists"
```

### 3.8 Check for Backups

```bash
# List any backup files created
ls -la project/troubleshooting/*backup*.md 2>/dev/null && echo "✓ Troubleshooting backup files found"
ls -la project/changelog/CHANGELOG-backup*.md 2>/dev/null && echo "✓ Changelog backup files found"
```

### 3.9 Verify Migration (When Applicable)

If troubleshooting backup(s) exist, confirm that **migration was performed** (Step 2.7): there should be individual entry files in `project/troubleshooting/<category>/` and corresponding rows in `project/troubleshooting/index.md`. If backups exist but no migration was done, complete Step 2.7 before considering setup complete.

---

## Slim AGENTS Architecture (Standard)

Summary of the standard slim setup. Details are in the referenced steps.

- **AGENTS.md (root)** – Only: Execution (1.2), Repository Management (1.3), slim Change Management (2.6.2), and "Detailed Documentation" links to `docs/agents/*`. No long Changelog/Troubleshooting/Project Structure blocks in root.
- **Changelog & troubleshooting** – Full conventions in `docs/agents/changelog-and-troubleshooting.md` (2.6.1); AGENTS.md has a short Change Management section + link (2.6.2). Changelog directory: 2.7.
- **docs/agents/** – Created in 2.9; long AGENTS.md sections relocated here via 2.9.3. At minimum: `changelog-and-troubleshooting.md`.
- **CLAUDE.md / GEMINI.md** – Slim at root, create if missing (2.10); reference AGENTS.md for repo, changelog, troubleshooting, plans.
- **Tracked Repositories** – Run [04-track-repos-and-agent-map.md](./04-track-repos-and-agent-map.md) (Step 2.11) after setup and when adding/removing repos.
- **Completed plans filing rule** – When a plan is completed or the user asks to file it, move from `project/plans/` or `project/build/` to `project/changelog/plans/` (date prefix if needed); add a row at the top of `project/changelog/index.md` (Type=plan). Agent files (AGENTS.md, docs/agents/changelog-and-troubleshooting.md, CLAUDE.md, GEMINI.md) must include this rule. See Step 1.4, Step 2.6.1, Step 2.8.4, Step 2.10.

**Populating docs/agents/:** The workflow creates at least `changelog-and-troubleshooting.md`. Step 2.9.3 adds other topical files by relocating content from AGENTS.md. To adopt a full refactor plan:

1. Put the proposal in `project/plans/` (as an active plan document) or add to `project/plans/TODO.md`.
2. Run `05-review-audit/01-code-review.md` on the plan; address P0/P1 findings.
3. Run `01-planning/01-plan-review.md` and `02-finalise-plan.md`; implement, retaining only a slim AGENTS.md (Execution, Repository Management, slim Change Management, and "Detailed Documentation" links to `docs/agents/`) and using the project's troubleshooting system (`project/troubleshooting/` directory and index).
4. When the plan is confirmed completed, file it in `project/changelog/plans/` with date prefix and add a row to `project/changelog/index.md` (Type=plan).


---

## Step 4: Migration Notes (If Applicable)

If you're migrating an existing project that already has files or directories in root `changelog/`, `troubleshooting/`, `plans-completed/`, or you are adopting the new `project/` structure, follow the steps below. Use the **same date format everywhere**: **YYYY-MM-DD** (e.g. `2026-01-18`) in file and directory names.

### 4.1 General migration order

1. **Back up** – Copy or commit current state before renaming or moving anything.
2. **Rename/move** – Apply the conventions (e.g. `yyyy-mm-dd-` prefix, correct type/category folders).
3. **Update indexes** – Ensure `project/changelog/index.md` and `project/troubleshooting/index.md` have correct paths in their tables.
4. **Scan for references** – Find any links or references to old paths (see Step 4.4).
5. **Fix links** – Update markdown links, relative paths, and index table cells to point to the new paths.
6. **Verify** – Run the link/reference check again and open key docs to confirm nothing is broken.

### 4.2 Migrating single-file or ad-hoc logs

**Troubleshooting (single-file or scattered):**
1. **Review backup files** – Check `project/troubleshooting/TROUBLESHOOTING-backup-*.md` for any entries that need to be migrated.
2. **Migrate entries** – Create one file per issue in the correct category folder under `project/troubleshooting/` with naming `<yyyy-mm-dd>-<category>-<short-title>.md` (e.g. `2026-01-18-build-css-error.md`). Use the date from the entry or the backup date.
3. **Update index** – Add a row at the top of `project/troubleshooting/index.md` for each new file (Date, Category, Title, File path, Status).
4. **Remove old files** – Only after migration and link check (Step 4.4); keep `docs/TROUBLESHOOTING.md` if it is a user-facing guide.

**Changelog (single-file) and plans-completed:**
1. **Review backup files** – Check `project/changelog/CHANGELOG-backup-*.md` for entries from the old CHANGELOG.
2. **Migrate changelog entries** – Create one file per change in `project/changelog/<type>/<yyyy-mm-dd>-<type>-<short-title>.md` and add rows to `project/changelog/index.md` (newest first).
3. **Migrate plans-completed** – If the project had a `plans-completed/` directory, move each plan doc to `project/changelog/plans/` with date prefix (e.g. `yyyy-mm-dd-<name>.md`) and add a row to `project/changelog/index.md` with Type=plan, Title, File path.
4. **Remove old file** – Only after migration and link check; then you can remove root `CHANGELOG.md` or `docs/CHANGELOG.md` if backed up.

### 4.3 Migrating existing directory structures

**Existing root `changelog/` or `troubleshooting/` (migrating into project/):**

- If the project has root-level `changelog/` or `troubleshooting/`, move their contents into `project/changelog/` and `project/troubleshooting/` (create type/category folders as needed). Update index paths to the new locations.
- If files use another date format (e.g. `20260118` or `18-01-2026`), rename to **YYYY-MM-DD** at the start: `2026-01-18-<rest-of-name>.md`.
- After moving, update **project/changelog/index.md** and **project/troubleshooting/index.md** so every row points to the new path. Then run the reference scan (Step 4.4) and fix any links.

**Existing `plans-completed/` (merge into project/changelog):**

- **Files**: Move each file to `project/changelog/plans/` with date prefix (e.g. `implementation-plan.md` to `project/changelog/plans/2026-01-18-implementation-plan.md`). Use the completion/archive date if known; otherwise use today's date.
- **Index**: Add one row per plan at the top of **project/changelog/index.md** with Date, Type=plan, Title, File path (to `project/changelog/plans/yyyy-mm-dd-<name>.md`). Newest first.
- Then run the reference scan (Step 4.4) and fix any references to the old `plans-completed/` paths.

**Archiving a plan from `project/build/` or `plans/`:**

- When a plan is confirmed completed, move it to `project/changelog/plans/` with `yyyy-mm-dd-` prefix and add a row to `project/changelog/index.md` (Type=plan). See Step 2.8.4.

### 4.4 Verifying links and references after reorganisation

After any renames or moves, scan for broken links and references so nothing points to old paths.

**Where references may appear:**

- Markdown links in `docs/`, `plans/`, `project/`, root `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, and any other `.md` files.
- Table cells in `project/changelog/index.md` and `project/troubleshooting/index.md` (the "File" or "File or Directory" columns).
- Plain text paths or filenames in prose (e.g. "see `plans/old-name.md`").

**Scan for references to old paths or filenames:**

```bash
# From project root. Replace OLD_PATH or OLD_FILENAME with the path or name you renamed/moved.
# Example: OLD_PATH="implementation-plan-2026-01-18-17-14.md" or "macos v.2.7"

# Search markdown and text for old filename or path (exclude .git and node_modules)
grep -r "OLD_PATH\|OLD_FILENAME" --include="*.md" --include="*.txt" . \
  --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=dist -n

# If you moved a directory, also search for the directory name
grep -r "old-dir-name" --include="*.md" . --exclude-dir=.git --exclude-dir=node_modules -n
```

**Check index files:**

- Open `project/changelog/index.md` and `project/troubleshooting/index.md` and ensure every "File" or "File or Directory" cell points to an existing path (new name/location). Fix any rows that still use old paths.

**Check markdown links resolve (standard after reorganisation):**

- Run a markdown link checker (e.g. `markdown-link-check`, `lychee`) on `docs/`, `plans/`, `project/`, and root `.md` files after reorganisation to catch broken `[text](path)` links. If no tool is available, manually spot-check key documents that reference changelog, troubleshooting, or plans.

**After fixing:**

- Re-run the grep search for the old path/filename; there should be no remaining references (or only intentional ones, e.g. in a migration note). Then commit the reorganisation and index/link updates together.

**Important:** Only remove old files (e.g. single-file CHANGELOG or TROUBLESHOOTING) after verifying all important information has been migrated and links/references have been updated.

## Step 4 (summary): Migration (Troubleshooting, Changelog, and Plans)

When you're **migrating an existing project**, the setup is not complete until existing content is moved into the new folder and index system. Execute these explicitly; do not defer as "if needed."

- **Troubleshooting:** Extract backup(s) into **individual files** under `project/troubleshooting/` and the **index** (Step 2.7). Do not leave backup as the only copy.
- **Changelog:** Use `project/changelog/` (type folders + plans subdir, one index). Migrate existing `CHANGELOG.md` entries and any `plans-completed/` content into it (Step 2.7, 4.2, 4.3).
- **Remove old files** only after migration is verified; keep `docs/TROUBLESHOOTING.md` if it is a user-facing guide.

If you also adopt the centralized `project/` meta directory, follow the additional steps in [Step 4.5](#45-migrating-to-a-centralized-project-meta-directory) to move `docs/`, `changelog/`, `troubleshooting/`, `plans/`, and `plans-completed/` under `project/` and update all paths accordingly.

---

## Complete Setup Checklist

When checking off completed items below, use **`- [✅]`** (green check mark); leave incomplete as **`- [ ]`** (see [Checklist marking convention](#checklist-marking-convention) above).

- [ ] AGENTS.md states clearly that the project has **multiple repositories** (not a single repo)
- [ ] AGENTS.md updated with execution guidelines (parallel agents)
- [ ] AGENTS.md (and optionally CLAUDE.md, GEMINI.md) include: **Bugs: add regression test when it fits.**
- [ ] AGENTS.md updated with dual repository management section and **completed plans filing rule** (with project-specific values)
- [ ] `.gitignore` includes the workflows directory (e.g. `Workflow-Scripts/` or `workflows/` — replace `<WORKFLOWS_DIR>` in Step 1.4)
- [ ] project/troubleshooting directory structure created
- [ ] Existing troubleshooting files backed up (root-level, docs/, and project/troubleshooting/ checked)
- [ ] `project/troubleshooting/README.md` created
- [ ] `project/troubleshooting/index.md` created or updated
- [ ] docs/agents/changelog-and-troubleshooting.md created with full Changelog/Troubleshooting/Plans conventions and **Completed plans – filing rule** (Step 2.6.1)
- [ ] AGENTS.md updated with slim Change Management section only (link to docs/agents/changelog-and-troubleshooting.md); full block not in root (Step 2.6.2)
- [ ] project/changelog directory structure created (type folders + plans subdir; single index)
- [ ] Existing CHANGELOG.md backed up to project/changelog/ (root and docs/ checked) if present
- [ ] `project/changelog/README.md` and `project/changelog/index.md` created
- [ ] `project/plans/` created with `project/plans/README.md` (map to project dir) and `project/plans/TODO.md` (current tasks)
- [ ] AGENTS.md includes "Detailed Documentation" section linking to docs/agents/ (changelog-and-troubleshooting and any other topical files)
- [ ] `docs/` and `docs/agents/` created at project root (if they didn't exist)
- [ ] AGENTS.md follows slim architecture (essentials + links to docs/agents/ + Execution, Repository Management, Changelog & Troubleshooting); no long Changelog/Troubleshooting/Project Structure/Build/Coding blocks in root (Steps 2.6.2, 2.9.3)
- [ ] CLAUDE.md and GEMINI.md created at project root (slim template, create if missing; include completed plans filing rule in Plans line)
- [ ] **Troubleshooting migration (when applicable):** Backup content extracted into **individual files** in `project/troubleshooting/<category>/` and rows added to `project/troubleshooting/index.md` (Step 2.7); do not leave migration as "if needed"
- [ ] **Changelog (and plans-completed):** project/changelog/ created; existing CHANGELOG and plans-completed content migrated into it (Step 2.7, 4.2, 4.3)
- [ ] Git configuration verified (workflows directory ignored in main repo)
- [ ] project/ and project/troubleshooting structure verified
- [ ] project/changelog structure verified (type folders + plans/ + single index)
- [ ] project/plans/README.md and project/plans/TODO.md verified
- [ ] docs/ and docs/agents/ verified
- [ ] CLAUDE.md and GEMINI.md verified (if created)
- [ ] Backup files reviewed; migration completed before removing old monolithic troubleshooting file (if applicable)
- [ ] If migrated: index files updated with new paths; link/reference scan run and broken links fixed (Step 4.4)

---

## For AI Agents Executing This Setup

**Execution:** Read existing files first; preserve data (back up before moving/editing); replace all placeholders (`<PROJECT_NAME>`, `<PROJECT_PATH>`, `<GIT_REMOTE>`, `<WORKFLOWS_DIR>`, `<WORKFLOWS_REMOTE>`); verify after each step. Use parallel agents when appropriate; verify findings before making changes.

**Slim architecture (mandatory):** Changelog/Troubleshooting/Plans full text lives in `docs/agents/changelog-and-troubleshooting.md` (2.6.1). In AGENTS.md use only a slim Change Management section and a link to that doc (2.6.2). Move long sections (Project Structure, Build/Test, Coding, etc.) into `docs/agents/` and replace with a "Detailed Documentation" link list (2.9.3). Do not paste the full changelog/troubleshooting block or long prose into root AGENTS.md. Create CLAUDE.md and GEMINI.md if missing; do not overwrite existing.

**Safety:** Back up before migrating (e.g. CHANGELOG.md, TROUBLESHOOTING.md in root or `docs/`). Preserve existing index entries when updating `project/changelog/index.md` and `project/troubleshooting/index.md` (new row at top when adding). After any renames/moves in project/changelog or project/troubleshooting, run the link/reference scan (Step 4.4).

### Bash Script Best Practices

When executing bash commands from this workflow:

```bash
# Add error handling at the start of scripts
set -e          # Exit immediately if a command fails
set -u          # Treat unset variables as errors
set -o pipefail # Catch errors in pipelines

# Optional: Add error trap for debugging
trap 'echo "Error on line $LINENO. Exit code: $?"' ERR
```

**Error handling tips:** Check files/directories exist before operating; use `|| true` after optional commands; use `echo "ERROR: description" >&2` and `exit 1` on failure.

---

## Troubleshooting the Setup

If something goes wrong during setup:

1. **Check backups** - All original files should be backed up in `project/troubleshooting/` or `project/changelog/` as appropriate
2. **Review git status** - Ensure the workflows directory is still in `.gitignore`
3. **Verify directory structure** - project/, project/changelog (type folders + plans/), and project/troubleshooting (category folders) should exist
4. **Check file permissions** - Ensure files are readable/writable
5. **Verify file locations** - Check both root and `docs/` directories for existing files

For issues with the setup itself, create a troubleshooting entry in `project/troubleshooting/environment/` following the standard format.
