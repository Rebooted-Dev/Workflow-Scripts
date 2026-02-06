# Project Initial Setup Workflow

This workflow sets up a new project (or migrates an existing project) with:
1. **Multiple Repositories (Multi-Repo)** - The project is **not** a single repo: it has the main application repository and a **local** Workflow-Scripts repository (cloned into the project directory). `AGENTS.md`, `.gitignore`, and other project docs must make this explicit so agents and contributors do not assume one repo.
2. **Troubleshooting System** - Organized troubleshooting directory structure with backup of existing logs

---

## Quick Start (Minimal Setup)

For users who want a fast setup, here are the essential steps:

```bash
# 1. Navigate to your project
cd <PROJECT_PATH>

# 2. Clone Workflow-Scripts into this local project dir (if not already done)
git clone https://github.com/Rebooted-Dev/Workflow-Scripts <WORKFLOWS_DIR>

# 3. Add workflows dir to .gitignore (required for multi-repo: main repo must not track it)
echo "" >> .gitignore
echo "# Workflow-Scripts (separate repo)" >> .gitignore
echo "<WORKFLOWS_DIR>/" >> .gitignore

# 4. Create project directories (docs, plans, plans-completed) and troubleshooting structure
mkdir -p docs plans plans-completed
mkdir -p troubleshooting/{build,runtime,data,environment,security}

# 5. Create minimal troubleshooting index
echo "# Troubleshooting Index" > troubleshooting/index.md
echo "" >> troubleshooting/index.md
echo "| Date | Category | Title | File | Status |" >> troubleshooting/index.md
echo "|------|----------|-------|------|--------|" >> troubleshooting/index.md

# 6. Verify setup
git status | grep <WORKFLOWS_DIR> || echo "✓ Workflows ignored"
ls docs plans plans-completed troubleshooting/ && echo "✓ Project and troubleshooting structure created"
```

For a comprehensive setup with AGENTS.md configuration and backups, continue with the detailed steps below.

---

## Purpose

This setup ensures:
- **Multi-repo is explicit** - Project documentation (especially `AGENTS.md`) clearly states that the project has **multiple repositories** (main repo + local Workflow-Scripts), not a single repository.
- Clear separation between main project repo and the local workflows repo (e.g. `Workflow-Scripts/`)
- Proper git configuration: main project's `.gitignore` must list the workflows directory so the main repo never tracks it
- **Troubleshooting and changelog in folder/index system** - When migrating an existing project, existing troubleshooting content is **extracted into individual files** and the index (Step 2.7); optionally, changelog can be moved to a folder system (Step 2.8). Backup alone is not enough—migration into the new structure is a defined task.
- Organized troubleshooting system that preserves existing troubleshooting data
- Consistent project structure across all projects using these workflows

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

---

## Step 1: Set Up Dual Repository Management in AGENTS.md

### 1.1 Check for Existing AGENTS.md

If `AGENTS.md` exists, review it to see if dual repo instructions are already present. If not, add the following section.

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

### 1.3 Add Repository Management Section

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
- Always update the changelog for any code change (features, fixes, refactors). Check for `CHANGELOG.md` in root or `docs/CHANGELOG.md` - create if missing. Prefer entries in the format: `- YYYY-MM-DD: Description of change`.
- Update `troubleshooting/` only for bugs/issues or non-trivial problems encountered during development.
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

### 1.4 Verify .gitignore (Required for Multi-Repo)

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

### 2.0 Ensure project directories exist (docs, plans, plans-completed)

Create standard project directories at the project root if they do not already exist. Other workflows (e.g. planning, documentation) expect these.

```bash
mkdir -p docs plans plans-completed
# Verify
for d in docs plans plans-completed; do
  test -d "$d" && echo "✓ $d exists" || echo "Created $d"
done
```

- **docs/** – Long-lived documentation (user-facing or project docs).
- **plans/** – Active planning artifacts, roadmaps, PRDs.
- **plans-completed/** – Archived plans and completed planning docs (move from `plans/` when done).

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

# Check for existing troubleshooting/ directory
if [ -d "troubleshooting" ]; then
  echo "Found existing troubleshooting/ directory"
  ls -la troubleshooting/
fi

# Check for troubleshooting/TROUBLESHOOTING.md
if [ -f "troubleshooting/TROUBLESHOOTING.md" ]; then
  echo "Found troubleshooting/TROUBLESHOOTING.md - will back up"
fi
```

### 2.2 Create Troubleshooting Directory Structure

Create the directory structure if it doesn't exist:

```bash
mkdir -p troubleshooting/{build,runtime,data,environment,security}
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
    BACKUP_FILE="troubleshooting/TROUBLESHOOTING-backup-${label}-${BACKUP_DATE}.md"
    
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
  "troubleshooting/TROUBLESHOOTING.md" \
  "troubleshooting" \
  "This file was backed up during setup. Existing entries should remain in the troubleshooting directory structure."
```

### 2.4 Create Troubleshooting README.md

Create `troubleshooting/README.md` with the system documentation:

```markdown
# Troubleshooting System

This directory contains organized troubleshooting entries for issues encountered during development.

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
1. **Update the changelog** - Check for `CHANGELOG.md` in root or `docs/CHANGELOG.md`. Always update for any code change (features, fixes, refactors). Prefer entries in the format: `- YYYY-MM-DD: Description of change`. Create the file if missing.
2. **Create a troubleshooting entry** - Add entries to `troubleshooting/` only for bugs/issues or non-trivial problems.
3. **Update `troubleshooting/index.md`** - Add the new entry at the top of the table when a troubleshooting entry is created.

**Note about `docs/TROUBLESHOOTING.md`**: If this file exists, it may serve as a user-facing troubleshooting guide with common error states and solutions. It is maintained separately from the `troubleshooting/` directory system. Individual troubleshooting entries should go in the `troubleshooting/` directory, not in `docs/TROUBLESHOOTING.md`.

See `AGENTS.md` section "Changelog & Troubleshooting Updates" for full guidelines.
```

### 2.5 Create or Update Troubleshooting Index

Create `troubleshooting/index.md` if it doesn't exist, or update it if it does:

```markdown
# Troubleshooting Index

Chronological index of troubleshooting entries.  
**Newest entries are listed first.**

| Date       | Category    | Title                                                      | File                                                          | Status   |
|-----------|-------------|------------------------------------------------------------|---------------------------------------------------------------|----------|
```

**Note:** If existing entries exist, preserve them in the table. Only add new entries at the top.

### 2.6 Update AGENTS.md with Troubleshooting Instructions

Add or update the troubleshooting section in `AGENTS.md`:

```markdown
### Troubleshooting System (`troubleshooting/` directory)
- **When to create troubleshooting entries**: Document bugs, issues, or non-trivial problems that required investigation and resolution.
  - **Bugs**: Any defect that causes incorrect behavior or crashes
  - **Issues**: Problems that required debugging, investigation, or workarounds
  - **Non-trivial problems**: Issues that took significant time to resolve, involved multiple steps, or have lessons worth preserving (e.g., complex configuration issues, unexpected framework behavior, tricky debugging scenarios)
- **When NOT to create troubleshooting entries**: Simple code changes, routine refactoring, or straightforward feature additions that don't involve problem-solving
- **Location**: Use the `troubleshooting/` directory system. Do NOT create individual entries in `TROUBLESHOOTING.md` or `docs/TROUBLESHOOTING.md`.
- **Structure**: 
  - Create individual files in the appropriate category folder (`build/`, `runtime/`, `data/`, `environment/`, `security/`)
  - File naming: `<yyyy-mm-dd>-<category>-<short-title>.md`
  - Each entry must include: Date, Category, Status, Symptom, Root Cause, Fix, Verification, Notes/Lessons
- **Index maintenance**: Always update `troubleshooting/index.md` when adding a new entry (add row at the top of the table).
- **Template**: See `troubleshooting/README.md` for the entry template and full conventions.

**Note about `docs/TROUBLESHOOTING.md`**: If this file exists, it serves as a user-facing troubleshooting guide with common error states and solutions. It is maintained separately from the `troubleshooting/` directory system. Individual troubleshooting entries should go in the `troubleshooting/` directory, not in `docs/TROUBLESHOOTING.md`.

### Interpreting "Update the Logs"
When instructed to "update the logs" or "update the log files", this refers to:
1. **Changelog** - Check for `CHANGELOG.md` in root or `docs/CHANGELOG.md`. Always update for any code change (features, fixes, refactors). Prefer entries in the format: `- YYYY-MM-DD: Description of change`. Create the file if missing.
2. **Troubleshooting entries** - Add entries to `troubleshooting/` only for bugs/issues or non-trivial problems that required investigation.
3. **Both** - When a bug fix requires both a troubleshooting entry (for the problem-solving process) AND a changelog entry (for the change itself).

**Note**: This project does NOT use application logging files (`.log` files). The "logs" refer to the troubleshooting knowledge base and changelog documentation.
```

### 2.7 Migrate Troubleshooting Backup to Folder System (When Migrating)

**Purpose:** The backup created in 2.3 preserves the old monolithic file but does **not** by itself populate the new folder system. This step is the **defined task** to extract that content into individual files and the index so the folder system becomes the source of truth.

**When to do this:** When an existing project has one or more troubleshooting backups (e.g. `troubleshooting/TROUBLESHOOTING-backup-root-*.md`) and you want the new structure to contain that content. If the project is brand new with no prior TROUBLESHOOTING.md, skip this step.

**Procedure:**

1. **Choose the backup to migrate** – Typically the most recent `troubleshooting/TROUBLESHOOTING-backup-*.md` (e.g. `TROUBLESHOOTING-backup-root-YYYY-MM-DD.md`). Open it and note the structure (e.g. entries under `### Title (YYYY-MM-DD)` or `## Title`, often separated by `---`).

2. **Identify discrete entries** – Split the backup by clear boundaries. Common patterns:
   - Each entry starts with a heading like `### Build Error: ... (2026-01-12)` or `## Issue Title`.
   - Entries may be separated by horizontal rules `---`.
   - Map each heading/title to a **category** (`build`, `runtime`, `data`, `environment`, `security`) from the content or title (e.g. "Build Error" → `build`, "Admin System Page" runtime error → `runtime`).

3. **For each entry:**
   - Derive a short **slug** from the title (e.g. `multiple-missing-dependencies`).
   - Extract **date** from the heading or body (e.g. `2026-01-12`).
   - Create file: `troubleshooting/<category>/<yyyy-mm-dd>-<category>-<slug>.md`.
   - Fill the standard template (see `troubleshooting/README.md`): Title, Date, Category, Status, Symptom (Problem/Observed), Root Cause, Fix (Resolution/Steps), Verification, Notes/Lessons. Copy or adapt content from the backup entry into these sections.
   - Add a row at the **top** of the table in `troubleshooting/index.md`: Date, Category, Title (short), File path (e.g. `troubleshooting/build/2026-01-12-build-multiple-missing-dependencies.md`), Status (e.g. RESOLVED).

4. **Verify** – Ensure every meaningful entry from the backup has a corresponding file under `troubleshooting/<category>/` and a row in `troubleshooting/index.md`. Optionally remove or archive the backup only after verification.

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
# Project directories (docs, plans, plans-completed)
test -d docs && echo "✓ docs/ exists"
test -d plans && echo "✓ plans/ exists"
test -d plans-completed && echo "✓ plans-completed/ exists"

# Troubleshooting directory structure
test -d troubleshooting/build && echo "✓ troubleshooting/build/ exists"
test -d troubleshooting/runtime && echo "✓ troubleshooting/runtime/ exists"
test -d troubleshooting/data && echo "✓ troubleshooting/data/ exists"
test -d troubleshooting/environment && echo "✓ troubleshooting/environment/ exists"
test -d troubleshooting/security && echo "✓ troubleshooting/security/ exists"
test -f troubleshooting/README.md && echo "✓ troubleshooting/README.md exists"
test -f troubleshooting/index.md && echo "✓ troubleshooting/index.md exists"
```

### 3.3 Check for Backups

```bash
# List any backup files created
ls -la troubleshooting/*backup*.md 2>/dev/null && echo "✓ Backup files found"
```

### 3.4 Verify Migration (When Applicable)

If troubleshooting backup(s) exist, confirm that **migration was performed** (Step 2.7): there should be individual entry files in `troubleshooting/<category>/` and corresponding rows in `troubleshooting/index.md`. If backups exist but no migration was done, complete Step 2.7 before considering setup complete.

---

## Step 4: Migration (Troubleshooting and Changelog)

When you're **migrating an existing project**, the setup is not complete until existing content is moved into the new folder and index system. The workflow defines these migration tasks explicitly so they are executed, not deferred as "if needed."

### 4.1 Troubleshooting: Backup → Folder System and Index

- **Task:** Extract content from troubleshooting backup(s) into **individual files** and the **index** (see **Step 2.7**). Do not leave backup as the only copy of the content.
- **Steps:** Follow Step 2.7: choose backup(s), identify entries (by heading/`---`), create one file per entry in `troubleshooting/<category>/` with the standard template, and add a row per entry to `troubleshooting/index.md`.
- **When done:** Every meaningful entry from the backup has a file under `troubleshooting/<category>/` and a row in `troubleshooting/index.md`. Only then consider removing or archiving the old monolithic file (see 4.3).

### 4.2 Changelog: Optional Folder System and Migration

- **Task (optional):** If the project wants a **changelog folder system** (e.g. `changelog/` with one file per version), set it up and migrate existing `CHANGELOG.md` into it (see **Step 2.8**). If the project keeps a single `CHANGELOG.md`, no migration is required.
- **Steps:** Follow Step 2.8: create `changelog/` (or `docs/changelog/`), split existing CHANGELOG by version into per-version files, and document the convention in AGENTS.md or docs.

### 4.3 Remove Old Files (After Migration Verified)

Only after **troubleshooting** migration is complete and verified:

- You may remove root-level `TROUBLESHOOTING.md` (if backed up and content migrated).
- You may remove `troubleshooting/TROUBLESHOOTING.md` if it existed and was backed up and migrated.
- **Keep** `docs/TROUBLESHOOTING.md` if it serves as a user-facing guide; individual entries live in `troubleshooting/`, not in that file.

**Important:** Do not remove old troubleshooting files until all important entries have been extracted into the folder system and index.

---

## Complete Setup Checklist

- [ ] AGENTS.md states clearly that the project has **multiple repositories** (not a single repo)
- [ ] AGENTS.md updated with execution guidelines (parallel agents)
- [ ] AGENTS.md updated with Repository Management section (multi-repo; use "this local project directory" and relative paths; project-specific values for remotes and names)
- [ ] `.gitignore` includes the workflows directory (e.g. `Workflow-Scripts/`) so the main repo does not track it
- [ ] Project directories created if missing: `docs/`, `plans/`, `plans-completed/`
- [ ] Troubleshooting directory structure created
- [ ] Existing troubleshooting files backed up (root-level, docs/, and troubleshooting/ checked)
- [ ] `troubleshooting/README.md` created
- [ ] `troubleshooting/index.md` created or updated
- [ ] AGENTS.md updated with troubleshooting system instructions
- [ ] **Troubleshooting migration (when applicable):** Backup content extracted into **individual files** in `troubleshooting/<category>/` and rows added to `troubleshooting/index.md` (Step 2.7); do not leave migration as "if needed"
- [ ] **Changelog (optional):** If using a changelog folder system, created structure and migrated existing CHANGELOG into it (Step 2.8)
- [ ] Git configuration verified (workflows directory ignored in main repo)
- [ ] Troubleshooting structure verified
- [ ] Backup files reviewed; migration completed before removing old monolithic troubleshooting file (if applicable)

---

## For AI Agents Executing This Setup

When executing this setup workflow:

1. **Read existing files first** - Check what already exists before making changes
2. **Preserve existing data** - Always back up before modifying or moving files
3. **Update incrementally** - Don't overwrite existing AGENTS.md, add to it
4. **Verify after each step** - Check that changes were applied correctly
5. **Document what was done** - Note any backups created or files modified
6. **Replace placeholders** - Ensure all `<PROJECT_NAME>`, `<PROJECT_PATH>`, `<GIT_REMOTE>`, `<WORKFLOWS_DIR>`, `<WORKFLOWS_REMOTE>` placeholders are replaced with actual values
7. **Check multiple file locations** - Look for changelog and troubleshooting files in both root and `docs/` directories
8. **Run migration when backups exist** - If troubleshooting backup(s) exist (e.g. `troubleshooting/TROUBLESHOOTING-backup-*.md`), execute **Step 2.7** to extract entries into individual files and the index; do not leave migration as an unspecified follow-up. If the project wants a changelog folder system, execute **Step 2.8**.

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

**Error handling tips:**
- Always check if files/directories exist before operating on them
- Use `|| true` after optional commands that may fail
- Provide meaningful error messages with `echo "ERROR: description" >&2`
- Exit with non-zero status on failures: `exit 1`

**Key Safety Rules:**
- Never delete existing troubleshooting entries
- Always create backups before moving files
- Preserve existing index.md entries when updating
- Check for existing sections in AGENTS.md before adding new ones
- Check both root-level and `docs/` directory for existing files

**Execution Guidelines:**
- Use multiple parallel agents when appropriate to accelerate tasks
- Verify all findings from parallel agents before making changes
- Coordinate parallel work to avoid conflicts

---

## Troubleshooting the Setup

If something goes wrong during setup:

1. **Check backups** - All original files should be backed up in `troubleshooting/`
2. **Review git status** - Ensure the workflows directory (e.g. `Workflow-Scripts/`) is listed in `.gitignore` and is still ignored by the main repo
3. **Verify directory structure** - All category folders should exist
4. **Check file permissions** - Ensure files are readable/writable
5. **Verify file locations** - Check both root and `docs/` directories for existing files

For issues with the setup itself, create a troubleshooting entry in `troubleshooting/environment/` following the standard format.
