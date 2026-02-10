# Project Initial Setup Workflow

This workflow sets up a new project (or migrates an existing project) with:
1. **Dual Repository Management** - Instructions for managing the main project repository and Workflow-Scripts as separate repos
2. **Troubleshooting System** - Organized troubleshooting directory structure with backup of existing logs
3. **Changelog System** - Same pattern as troubleshooting: `changelog/` directory with type folders, one file per entry, index (newest first); backup of existing single-file CHANGELOG if present
4. **Plans Directories** - `plans/` and `plans-completed/` at project root; completed items moved with `yyyy-mm-dd-` prefix and listed in `plans-completed/index.md` for easy navigation
5. **Slim AGENTS Architecture (standard)** - Root `AGENTS.md` with essentials only and links to detailed docs in `docs/agents/`; `docs/` and `docs/agents/` created for every project
6. **Slim CLAUDE.md and GEMINI.md** - Same slim pattern for Claude/Cursor and Gemini: essentials + "Detailed Documentation" linking to `docs/agents/` (standard: create at project root as part of setup; create if missing, do not overwrite existing)
7. **Track Repos and Agent Map** - Discover all Git repos in the project and populate AGENTS.md, CLAUDE.md, and GEMINI.md with a repository map and sync/push/pull instructions (see [04-track-repos-and-agent-map.md](./04-track-repos-and-agent-map.md))

---

## Quick Start (Minimal Setup)

For users who want a fast setup, here are the essential steps. Replace placeholders: `<PROJECT_PATH>`, `<WORKFLOWS_DIR>` (e.g. `Workflow-Scripts` or `workflows/`). See Prerequisites for the full list.

```bash
# 1. Navigate to your project
cd <PROJECT_PATH>

# 2. Clone workflows (if not already done)
git clone https://github.com/Rebooted-Dev/Workflow-Scripts <WORKFLOWS_DIR>

# 3. Add workflows to .gitignore
echo "<WORKFLOWS_DIR>/" >> .gitignore

# 4. Create troubleshooting structure
mkdir -p troubleshooting/{build,runtime,data,environment,security}

# 5. Create changelog structure (same pattern: directory + index)
mkdir -p changelog/{added,changed,fixed,improved,docs,refactor,config}
echo "# Changelog Index" > changelog/index.md
echo "" >> changelog/index.md
echo "| Date | Type | Title | File |" >> changelog/index.md
echo "|------|------|-------|------|" >> changelog/index.md

# 6. Create plans directories and plans-completed index (if they don't exist)
mkdir -p plans plans-completed
echo "# Plans-Completed Index" > plans-completed/index.md
echo "" >> plans-completed/index.md
echo "| Date       | Title / Description | File or Directory |" >> plans-completed/index.md
echo "|------------|---------------------|-------------------|" >> plans-completed/index.md

# 7. Create docs and docs/agents (if they don't exist)
mkdir -p docs docs/agents

# 8. Create minimal troubleshooting index
echo "# Troubleshooting Index" > troubleshooting/index.md
echo "" >> troubleshooting/index.md
echo "| Date | Category | Title | File | Status |" >> troubleshooting/index.md
echo "|------|----------|-------|------|--------|" >> troubleshooting/index.md

# 9. Verify setup
git status | grep <WORKFLOWS_DIR> || echo "✓ Workflows ignored"
ls troubleshooting/ && echo "✓ Troubleshooting structure created"
ls changelog/ && echo "✓ Changelog structure created"
ls -d plans plans-completed 2>/dev/null && test -f plans-completed/index.md && echo "✓ Plans directories and plans-completed index created"
ls -d docs docs/agents 2>/dev/null && echo "✓ docs/ and docs/agents/ created"

# 10. Run track-repos workflow (discover repos, update AGENTS.md/CLAUDE.md/GEMINI.md with repo map and sync instructions)
# Follow: Workflow-Scripts/00-project-setup/04-track-repos-and-agent-map.md
```

For a comprehensive setup with AGENTS.md configuration and backups, continue with the detailed steps below.

---

## Purpose

This setup ensures:
- **Consistent date format** – All dated file and directory names use **YYYY-MM-DD** (ISO date with hyphens) in `changelog/`, `troubleshooting/`, and `plans-completed/`. Examples: `changelog/added/2026-01-18-added-feature-x.md`, `troubleshooting/build/2026-01-18-build-error.md`, `plans-completed/2026-01-18-implementation-plan.md`. This keeps naming consistent and sortable across the project.
- Clear separation between main project repo and workflows repo
- Proper git configuration to manage both independently
- Organized **troubleshooting** system (directory + index, same pattern as changelog) that preserves existing troubleshooting data
- Organized **changelog** system (directory + index, same pattern as troubleshooting) so the changelog does not grow into a single large file
- Consistent project structure across all projects using these workflows
- **docs/** directory at project root (created if missing) and **docs/agents/** for agent-facing detailed documentation
- Slim root AGENTS.md: essentials only in the root file (Execution, Repository Management, slim Change Management), with a "Detailed Documentation" section linking to `docs/agents/`. Changelog & Troubleshooting conventions live in `docs/agents/changelog-and-troubleshooting.md`; other long sections (Project Structure, Build/Coding/Testing, etc.) are relocated to topical files in `docs/agents/` (Steps 2.6, 2.9.3)
- Slim **CLAUDE.md** and **GEMINI.md** at project root (standard: create as part of setup; same pattern: essentials + links to `docs/agents/`), for Claude/Cursor and Gemini assistants; for repo management and changelog/troubleshooting they reference AGENTS.md
- **Tracked Repositories map** in agent files (AGENTS.md, CLAUDE.md, GEMINI.md) listing each repo’s path, remote URL, purpose, and sync/push/pull instructions (Step 2.11; see [04-track-repos-and-agent-map.md](./04-track-repos-and-agent-map.md))

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

### 1.3 Add Repository Management Section

Add this section to `AGENTS.md` (or update existing section). **Replace placeholders with your project's actual values:**

```markdown
## Repository Management

This project uses two separate repositories that should be managed independently:

### 1. <PROJECT_NAME> Repository (This Repository)
- **Location**: `<PROJECT_PATH>`
- **Purpose**: Main application code, components, services, documentation
- **Git Remote**: `<GIT_REMOTE>`

**Standard Git Operations:**
```bash
# Navigate to project root
cd <PROJECT_PATH>

# Check status
git status

# Pull latest changes
git pull

# Commit and push changes
git add .
git commit -m "feat: description of changes"
git push
```

### 2. Workflow-Scripts Repository (Nested in <WORKFLOWS_DIR>/ directory)
- **Location**: `<PROJECT_PATH>/<WORKFLOWS_DIR>/`
- **Purpose**: Reusable workflow instructions for development tasks (planning, review, development, debug, documentation)
- **Git Remote**: `<WORKFLOWS_REMOTE>`
- **Note**: The `<WORKFLOWS_DIR>/` directory is a separate git repository and is ignored by the main project repo (see `.gitignore`)

**Standard Git Operations:**
```bash
# Navigate to workflows directory (nested in project root)
cd <PROJECT_PATH>/<WORKFLOWS_DIR>

# Check status
git status

# Pull latest changes
git pull

# Commit and push changes
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
- Work from the root directory: `<PROJECT_PATH>`
- Focus on application code, components, services
- Update project-specific documentation in `docs/` (if it exists)
- Always update the changelog for any code change (features, fixes, refactors): create an entry in `changelog/<type>/<yyyy-mm-dd>-<type>-<short-title>.md` and add a row at the top of `changelog/index.md`. See `changelog/README.md` for the template.
- Update `troubleshooting/` only for bugs/issues or non-trivial problems encountered during development.
- The `<WORKFLOWS_DIR>/` directory is **ignored** by git (in `.gitignore`), so it won't be included in commits
- Standard operations: `git add .`, `git commit`, `git push` - workflows will NOT be included

**When Working on Workflow-Scripts (Nested Repo):**
- Navigate to the workflows directory: `cd <WORKFLOWS_DIR>/`
- Focus on workflow instructions and templates
- Update workflow documentation in `README.md` and `SHARING_AND_SYNC.md`
- These workflows are shared across multiple projects
- Changes here affect all projects that use these workflows
- Standard operations: `git add .`, `git commit`, `git push` - only workflows will be pushed

**Important Git Behavior:**
- The `<WORKFLOWS_DIR>/` directory is listed in `.gitignore`, so it's completely ignored by the main repo
- When you run `git status`, `git add .`, or `git commit` from the project root, `<WORKFLOWS_DIR>/` will NOT be included
- To push workflow changes, you MUST `cd <WORKFLOWS_DIR>/` first, then run git commands there
- The workflows directory has its own `.git` folder and is a completely separate repository

**Best Practices:**
- Always commit main project changes from the root directory
- Always commit Workflow-Scripts changes from the `<WORKFLOWS_DIR>/` directory
- Use clear commit messages indicating which repository you're working in
- Pull latest changes from both repos before starting work
- Keep workflow improvements in the workflows directory, not in the main repo
```

### 1.4 Verify .gitignore

Ensure `.gitignore` includes your workflows directory:

```bash
# Replace <WORKFLOWS_DIR> with your actual directory name (e.g., "workflows" or "Workflow-Scripts")
# Check if workflows directory is in .gitignore
grep -q "^<WORKFLOWS_DIR>/$" .gitignore || echo "<WORKFLOWS_DIR>/" >> .gitignore
```

---

## Step 2: Set Up Troubleshooting System

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
1. **Update the changelog** - Create a new entry in `changelog/<type>/<yyyy-mm-dd>-<type>-<short-title>.md` and add a row at the top of `changelog/index.md`. See `changelog/README.md` for the template.
2. **Create a troubleshooting entry** - Add entries to `troubleshooting/` only for bugs/issues or non-trivial problems.
3. **Update the relevant index** - When adding a changelog entry, update `changelog/index.md`; when adding a troubleshooting entry, update `troubleshooting/index.md` (new row at top).

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

### 2.6 Set Up Changelog & Troubleshooting (in docs/agents, keep AGENTS.md slim)

**Goal:** Keep AGENTS.md slim. Put the full Changelog/Troubleshooting/Plans conventions in `docs/agents/` and reference them from the root file.

#### 2.6.1 Create docs/agents/changelog-and-troubleshooting.md

Ensure `docs/agents/` exists (Step 2.9.1 creates it; if executing steps out of order, run `mkdir -p docs/agents`). Create or update `docs/agents/changelog-and-troubleshooting.md` with the full conventions:

```markdown
# Changelog & Troubleshooting (Agent Conventions)

Full conventions for the `changelog/` and `troubleshooting/` directory systems, "update the logs" behavior, and plans-completed usage.

---

## Changelog System (`changelog/` directory)
- **When to create changelog entries**: For any code change (features, fixes, refactors, docs, config). One file per change.
- **Location**: Use the `changelog/` directory system. Do NOT use a single `CHANGELOG.md` file at root or in `docs/`.
- **Structure**:
  - Create individual files in the appropriate type folder: `added/`, `changed/`, `fixed/`, `improved/`, `docs/`, `refactor/`, `config/`
  - File naming: `<yyyy-mm-dd>-<type>-<short-title>.md`
  - Each entry must include: Date, Type, Summary (and optional Scope)
- **Index maintenance**: Always update `changelog/index.md` when adding a new entry (add row at the top of the table).
- **Template**: See `changelog/README.md` for the entry template and full conventions.

## Troubleshooting System (`troubleshooting/` directory)
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

## Interpreting "Update the Logs"
When instructed to "update the logs" or "update the log files", this refers to:
1. **Changelog** – Create a new entry in `changelog/<type>/<yyyy-mm-dd>-<type>-<short-title>.md` and add a row at the top of `changelog/index.md`. Use the appropriate type folder (added, changed, fixed, improved, docs, refactor, config). See `changelog/README.md` for the template.
2. **Troubleshooting entries** – Add entries to `troubleshooting/` only for bugs/issues or non-trivial problems that required investigation.
3. **Both** – When a bug fix requires both a troubleshooting entry (for the problem-solving process) AND a changelog entry (for the change itself).

**Note**: This project does NOT use application logging files (`.log` files). The "logs" refer to the `changelog/` directory and the troubleshooting knowledge base in `troubleshooting/`.

## Documentation, Plans & Plans-Completed
- **Changelog**: `changelog/` at project root — one file per change in type folders; always update `changelog/index.md` (new row at top).
- **Troubleshooting**: `troubleshooting/` at project root — one file per issue in category folders; always update `troubleshooting/index.md` (new row at top).
- **Docs**: `docs/` holds project documentation; `docs/agents/` holds agent-facing detailed guides. Root AGENTS.md stays slim and links to `docs/agents/`.
- **Plans**: `plans/` holds active plans, implementation plans, and review reports. Use dated filenames.
- **Plans-completed**: `plans-completed/` holds completed or archived plans. When moving from `plans/` to `plans-completed/`, **rename** with a `yyyy-mm-dd-` prefix and **update `plans-completed/index.md`** (add a row at the top). See `plans-completed/README.md` for full conventions.
```

#### 2.6.2 Update AGENTS.md with a slim Change Management section only

In `AGENTS.md`, add or update the **Change Management** section so it stays **slim**: state the mandatory rule and link to the detailed doc. Do **not** paste the full Changelog/Troubleshooting block into AGENTS.md.

**In AGENTS.md use only:**

```markdown
## Change Management
- Unless instructed by the developer, do not make code changes to the user interface.
- **MANDATORY**: After ANY code changes or when debugging issues, update the changelog and/or troubleshooting: use the `changelog/` and `troubleshooting/` directory systems (one file per entry, update the relevant index). For full conventions and "update the logs" behavior, see **[Changelog & Troubleshooting](docs/agents/changelog-and-troubleshooting.md)**.
```

Ensure AGENTS.md has a **Detailed Documentation** section (or add it in Step 2.9.3) that includes a link to `docs/agents/changelog-and-troubleshooting.md`.

---

## Step 2.7: Set Up Changelog System

The changelog follows the same pattern as the troubleshooting system: a **directory** at project root (`changelog/`) with **category subdirectories**, **one file per entry**, and an **index** (newest first). This keeps the changelog from growing into a single large file.

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

# Check for existing changelog/ directory
if [ -d "changelog" ]; then
  echo "Found existing changelog/ directory"
  ls -la changelog/
fi
```

### 2.7.2 Create Changelog Directory Structure

Create the directory structure. Types align with typical changelog sections and Conventional Commits:

```bash
mkdir -p changelog/{added,changed,fixed,improved,docs,refactor,config}
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
    BACKUP_FILE="changelog/CHANGELOG-backup-${label}-${BACKUP_DATE}.md"

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
  "Single-file changelog backed up during setup. Migrate entries to changelog/<type>/<yyyy-mm-dd>-<type>-<short-title>.md and add rows to changelog/index.md."

backup_changelog_file \
  "docs/CHANGELOG.md" \
  "docs" \
  "Single-file changelog backed up during setup. Migrate entries to changelog/ directory structure."
```

### 2.7.4 Create Changelog README.md

Create `changelog/README.md` with the system documentation:

```markdown
# Changelog System

This directory contains organized changelog entries, one file per change. **Newest entries are listed first** in `index.md`.

## Directory Structure (by type)

- `added/` - New features, capabilities
- `changed/` - Changes in existing behavior or API
- `fixed/` - Bug fixes
- `improved/` - Improvements (performance, UX, DX)
- `docs/` - Documentation-only changes
- `refactor/` - Code refactoring
- `config/` - Configuration, tooling, environment
- `index.md` - Chronological index of all entries

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

Create `changelog/index.md` if it doesn't exist:

```markdown
# Changelog Index

Chronological index of changelog entries.  
**Newest entries are listed first.**

| Date       | Type    | Title | File |
|-----------|---------|-------|------|
```

**Note:** If migrating from a single-file CHANGELOG, preserve existing entries in the table (newest at top). Only add new entries at the top.

### 2.7.6 AGENTS.md and the Changelog System

Do **not** add a long changelog section to AGENTS.md. Keep the root file slim: ensure AGENTS.md has only the **slim Change Management** section and a link to `docs/agents/changelog-and-troubleshooting.md` (see Step 2.6.2). The full "Interpreting Update the Logs" and changelog conventions live in that doc.

---

## Step 2.8: Set Up Plans Directories

Create `plans/` and `plans-completed/` at the project root if they don't already exist. These directories are used by the planning and review workflows (e.g. `01-plan-review.md`, `01-code-review.md`) to store active plans, review reports, and completed or archived plans.

### 2.8.1 Create plans and plans-completed

```bash
# From project root
cd <PROJECT_PATH>

# Create plans directories only if they don't exist
if [ ! -d "plans" ]; then
  mkdir -p plans
  echo "✓ Created plans/"
else
  echo "✓ plans/ already exists"
fi

if [ ! -d "plans-completed" ]; then
  mkdir -p plans-completed
  echo "✓ Created plans-completed/"
else
  echo "✓ plans-completed/ already exists"
fi
```

### 2.8.2 Create plans-completed/index.md and README.md

Create an index and README in `plans-completed/` so agents and humans can find completed work easily.

**Create `plans-completed/index.md`** (if it doesn't exist):

```markdown
# Plans-Completed Index

Chronological index of completed or archived plans. **Newest entries are listed first.**

| Date       | Title / Description | File or Directory |
|------------|---------------------|-------------------|
```

**Create `plans-completed/README.md`** (if it doesn't exist) with the following content:

```markdown
# Plans-Completed

This directory holds completed or archived plans moved from `plans/` after implementation or closure.

## Naming convention when moving here

When moving a file or directory from `plans/` to `plans-completed/`:

1. **Prepend a date stamp** in the form `yyyy-mm-dd-` (ISO date) to the name (e.g. `2026-01-18-implementation-plan-2026-01-18-17-14.md` or `2026-01-18-macos v.2.7/`). This matches the date format used in `changelog/` and `troubleshooting/`.
2. If the item already has a leading date, keep it or normalize to `yyyy-mm-dd-` at the start for consistency.
3. **Update `plans-completed/index.md`**: add a new row at the **top** of the table with: Date (YYYY-MM-DD), Title/Description, and the path to the file or directory.

## Index maintenance

- **Newest first**: Always add new rows at the top of the table in `index.md`.
- One row per completed plan (file or directory). For directories, link to the directory path (e.g. `2026-01-18-macos v.2.7/`).

## For AI agents

- When archiving a plan: move it to `plans-completed/`, rename with `yyyy-mm-dd-` prefix (same date format as changelog and troubleshooting), then update `plans-completed/index.md`.
- Use this index to find records of past work when answering questions about what was done or when something was completed.
```

```bash
# From project root - create index and README only if missing
cd <PROJECT_PATH>

if [ ! -f "plans-completed/index.md" ]; then
  # (Write the index.md content above)
  echo "✓ Created plans-completed/index.md"
else
  echo "✓ plans-completed/index.md already exists"
fi

if [ ! -f "plans-completed/README.md" ]; then
  # (Write the README.md content above)
  echo "✓ Created plans-completed/README.md"
else
  echo "✓ plans-completed/README.md already exists"
fi
```

### 2.8.3 Naming when moving to plans-completed

When moving a plan (file or directory) from `plans/` to `plans-completed/`:

- **Files**: Rename to `yyyy-mm-dd-<original-name>` (e.g. `implementation-plan-2026-01-18-17-14.md` → `2026-01-18-implementation-plan-2026-01-18-17-14.md`). Use the completion/archive date in **YYYY-MM-DD** form (same as changelog and troubleshooting).
- **Directories**: Rename to `yyyy-mm-dd-<original-dir-name>` (e.g. `macos v.2.7` → `2026-01-18-macos v.2.7`).
- **Index**: Add a row at the top of `plans-completed/index.md` with Date (YYYY-MM-DD), Title/Description, and File or Directory path.

### 2.8.4 Usage summary

- **`plans/`** – Active plans, implementation plans, and review reports (e.g. code review reports, plan reviews). Use dated filenames (e.g. `code-review-agents-proposal-2026-02-01.md`, `implementation-plan-2026-01-18.md`).
- **`plans-completed/`** – Completed or archived plans moved here after implementation or closure. **Rename with `yyyy-mm-dd-` prefix** when moving; **always update `plans-completed/index.md`** (new row at top). Preserves history and makes it easy to find records of work done.

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
- **Docs**: Update changelog (`changelog/` directory) and troubleshooting when applicable (see AGENTS.md).
- **Plans**: Active plans live in `plans/`; completed/archived plans in `plans-completed/` (with `yyyy-mm-dd-` prefix and index). See AGENTS.md.

## Quick Reference

- **Build**: `npm run dev` (development), `npm run build` (production).
- **Project structure**: See [Project Structure](docs/agents/project-structure.md).
- **Changelog, troubleshooting, docs, plans**: See AGENTS.md (changelog/ and troubleshooting/ directories and indexes; docs/ and docs/agents/; plans/ and plans-completed/ with index).

## Detailed Documentation

For comprehensive information, see:

- [Project Structure & Organization](docs/agents/project-structure.md)
- [Development Workflow](docs/agents/development-workflow.md)
- [Coding Standards](docs/agents/coding-standards.md)
- [Testing Strategy](docs/agents/testing-strategy.md)
- [Commit & PR Workflow](docs/agents/commit-workflow.md)
- [Documentation Workflow](docs/agents/documentation-workflow.md)
- [Security Guidelines](docs/agents/security-guidelines.md)

For repository management, changelog, troubleshooting, and plans (plans-completed index), see **AGENTS.md**.
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
- **Docs**: Update changelog (`changelog/` directory) and troubleshooting when applicable (see AGENTS.md).
- **Plans**: Active plans live in `plans/`; completed/archived plans in `plans-completed/` (with `yyyy-mm-dd-` prefix and index). See AGENTS.md.

## Quick Reference

- **Build**: `npm run dev` (development), `npm run build` (production).
- **Project structure**: See [Project Structure](docs/agents/project-structure.md).
- **Changelog, troubleshooting, docs, plans**: See AGENTS.md (changelog/ and troubleshooting/ directories and indexes; docs/ and docs/agents/; plans/ and plans-completed/ with index).

## Detailed Documentation

For comprehensive information, see:

- [Project Structure & Organization](docs/agents/project-structure.md)
- [Development Workflow](docs/agents/development-workflow.md)
- [Coding Standards](docs/agents/coding-standards.md)
- [Testing Strategy](docs/agents/testing-strategy.md)
- [Commit & PR Workflow](docs/agents/commit-workflow.md)
- [Documentation Workflow](docs/agents/documentation-workflow.md)
- [Security Guidelines](docs/agents/security-guidelines.md)

For repository management, changelog, troubleshooting, and plans (plans-completed index), see **AGENTS.md**.
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

### 3.2 Verify Troubleshooting Structure

```bash
# Check directory structure
test -d troubleshooting/build && echo "✓ build/ exists"
test -d troubleshooting/runtime && echo "✓ runtime/ exists"
test -d troubleshooting/data && echo "✓ data/ exists"
test -d troubleshooting/environment && echo "✓ environment/ exists"
test -d troubleshooting/security && echo "✓ security/ exists"
test -f troubleshooting/README.md && echo "✓ README.md exists"
test -f troubleshooting/index.md && echo "✓ index.md exists"
```

### 3.3 Verify Changelog Structure

```bash
# Check changelog directory structure
test -d changelog/added && echo "✓ changelog/added/ exists"
test -d changelog/changed && echo "✓ changelog/changed/ exists"
test -d changelog/fixed && echo "✓ changelog/fixed/ exists"
test -d changelog/improved && echo "✓ changelog/improved/ exists"
test -d changelog/docs && echo "✓ changelog/docs/ exists"
test -d changelog/refactor && echo "✓ changelog/refactor/ exists"
test -d changelog/config && echo "✓ changelog/config/ exists"
test -f changelog/README.md && echo "✓ changelog/README.md exists"
test -f changelog/index.md && echo "✓ changelog/index.md exists"
```

### 3.4 Verify Plans Directories

```bash
# Check plans directories exist at project root
test -d plans && echo "✓ plans/ exists"
test -d plans-completed && echo "✓ plans-completed/ exists"
test -f plans-completed/index.md && echo "✓ plans-completed/index.md exists"
test -f plans-completed/README.md && echo "✓ plans-completed/README.md exists"
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
ls -la troubleshooting/*backup*.md 2>/dev/null && echo "✓ Troubleshooting backup files found"
ls -la changelog/CHANGELOG-backup*.md 2>/dev/null && echo "✓ Changelog backup files found"
```

---

## Slim AGENTS Architecture (Standard)

Summary of the standard slim setup. Details are in the referenced steps.

- **AGENTS.md (root)** – Only: Execution (1.2), Repository Management (1.3), slim Change Management (2.6.2), and "Detailed Documentation" links to `docs/agents/*`. No long Changelog/Troubleshooting/Project Structure blocks in root.
- **Changelog & troubleshooting** – Full conventions in `docs/agents/changelog-and-troubleshooting.md` (2.6.1); AGENTS.md has a short Change Management section + link (2.6.2). Changelog directory: 2.7.
- **docs/agents/** – Created in 2.9; long AGENTS.md sections relocated here via 2.9.3. At minimum: `changelog-and-troubleshooting.md`.
- **CLAUDE.md / GEMINI.md** – Slim at root, create if missing (2.10); reference AGENTS.md for repo, changelog, troubleshooting, plans.
- **Tracked Repositories** – Run [04-track-repos-and-agent-map.md](./04-track-repos-and-agent-map.md) (Step 2.11) after setup and when adding/removing repos.
- **Plans-completed** – Move with `yyyy-mm-dd-` prefix; update `plans-completed/index.md` (2.8, `plans-completed/README.md`).

**Populating docs/agents/:** The workflow creates at least `changelog-and-troubleshooting.md`. Step 2.9.3 adds other topical files by relocating content from AGENTS.md. To adopt a full refactor plan:

1. Put the proposal in `plans/` (e.g. `plans/AGENTS_PROPOSAL.md`).
2. Run `05-review-audit/01-code-review.md` on the plan; address P0/P1 findings.
3. Run `01-planning/01-plan-review.md` and `02-finalise-plan.md`; implement, retaining only a slim AGENTS.md (Execution, Repository Management, slim Change Management, and "Detailed Documentation" links to `docs/agents/`) and using the project's troubleshooting system (`troubleshooting/` directory and index).
4. Move the completed plan to `plans-completed/` with a `yyyy-mm-dd-` prefix and add a row to `plans-completed/index.md`.


---

## Step 4: Migration Notes (If Applicable)

If you're migrating an existing project that already has files or directories in `changelog/`, `troubleshooting/`, `plans/`, or `plans-completed/`, follow the steps below. Use the **same date format everywhere**: **YYYY-MM-DD** (e.g. `2026-01-18`) in file and directory names.

### 4.1 General migration order

1. **Back up** – Copy or commit current state before renaming or moving anything.
2. **Rename/move** – Apply the conventions (e.g. `yyyy-mm-dd-` prefix, correct type/category folders).
3. **Update indexes** – Ensure `changelog/index.md`, `troubleshooting/index.md`, and `plans-completed/index.md` have correct paths in their tables.
4. **Scan for references** – Find any links or references to old paths (see Step 4.4).
5. **Fix links** – Update markdown links, relative paths, and index table cells to point to the new paths.
6. **Verify** – Run the link/reference check again and open key docs to confirm nothing is broken.

### 4.2 Migrating single-file or ad-hoc logs

**Troubleshooting (single-file or scattered):**
1. **Review backup files** – Check `troubleshooting/TROUBLESHOOTING-backup-*.md` for any entries that need to be migrated.
2. **Migrate entries** – Create one file per issue in the correct category folder with naming `<yyyy-mm-dd>-<category>-<short-title>.md` (e.g. `2026-01-18-build-css-error.md`). Use the date from the entry or the backup date.
3. **Update index** – Add a row at the top of `troubleshooting/index.md` for each new file (Date, Category, Title, File path, Status).
4. **Remove old files** – Only after migration and link check (Step 4.4); keep `docs/TROUBLESHOOTING.md` if it is a user-facing guide.

**Changelog (single-file):**
1. **Review backup files** – Check `changelog/CHANGELOG-backup-*.md` for entries from the old CHANGELOG.
2. **Migrate entries** – Create one file per change in `changelog/<type>/<yyyy-mm-dd>-<type>-<short-title>.md` and add rows to `changelog/index.md` (newest first).
3. **Remove old file** – Only after migration and link check; then you can remove root `CHANGELOG.md` or `docs/CHANGELOG.md` if backed up.

### 4.3 Migrating existing directory structures

**Existing `changelog/` or `troubleshooting/` with different naming:**

- If files use another date format (e.g. `20260118` or `18-01-2026`), rename to **YYYY-MM-DD** at the start: `2026-01-18-<rest-of-name>.md`.
- If files are in the wrong folder (e.g. all in one folder), move them into the correct type/category subfolder and keep the `<yyyy-mm-dd>-<type>-<short-title>.md` pattern.
- After renaming or moving, update the corresponding **index.md** so every row points to the new path. Then run the reference scan (Step 4.4) and fix any links.

**Existing `plans-completed/` without date prefix (or with old format):**

- **Files**: Rename to `yyyy-mm-dd-<current-name>` (e.g. `implementation-plan.md` → `2026-01-18-implementation-plan.md`). Use the completion/archive date if known; otherwise use today’s date or a chosen convention.
- **Directories**: Rename to `yyyy-mm-dd-<current-dir-name>` (e.g. `macos v.2.7` → `2026-01-18-macos v.2.7`).
- **Index**: Create or update `plans-completed/index.md` with one row per file or directory (Date, Title/Description, File or Directory). Newest first. Ensure the "File or Directory" column uses the **new** path.
- Then run the reference scan (Step 4.4) and fix any references to the old names.

**Existing `plans/` when moving to `plans-completed/`:**

- When you first move items from `plans/` to `plans-completed/`, rename with `yyyy-mm-dd-` prefix (completion date) and add a row to `plans-completed/index.md`. No need to rename files that stay in `plans/`.

### 4.4 Verifying links and references after reorganisation

After any renames or moves, scan for broken links and references so nothing points to old paths.

**Where references may appear:**

- Markdown links in `docs/`, `plans/`, `plans-completed/`, root `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, and any other `.md` files.
- Table cells in `changelog/index.md`, `troubleshooting/index.md`, and `plans-completed/index.md` (the "File" or "File or Directory" columns).
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

- Open `changelog/index.md`, `troubleshooting/index.md`, and `plans-completed/index.md` and ensure every "File" or "File or Directory" cell points to an existing path (new name/location). Fix any rows that still use old paths.

**Check markdown links resolve (standard after reorganisation):**

- Run a markdown link checker (e.g. `markdown-link-check`, `lychee`) on `docs/`, `plans/`, `plans-completed/`, and root `.md` files after reorganisation to catch broken `[text](path)` links. If no tool is available, manually spot-check key documents that reference changelog, troubleshooting, or plans.

**After fixing:**

- Re-run the grep search for the old path/filename; there should be no remaining references (or only intentional ones, e.g. in a migration note). Then commit the reorganisation and index/link updates together.

**Important:** Only remove old files (e.g. single-file CHANGELOG or TROUBLESHOOTING) after verifying all important information has been migrated and links/references have been updated.

---

## Complete Setup Checklist

- [ ] AGENTS.md updated with execution guidelines (parallel agents)
- [ ] AGENTS.md updated with dual repository management section (with project-specific values)
- [ ] `.gitignore` includes the workflows directory (e.g. `Workflow-Scripts/` or `workflows/` — replace `<WORKFLOWS_DIR>` in Step 1.4)
- [ ] Troubleshooting directory structure created
- [ ] Existing troubleshooting files backed up (root-level, docs/, and troubleshooting/ checked)
- [ ] `troubleshooting/README.md` created
- [ ] `troubleshooting/index.md` created or updated
- [ ] docs/agents/changelog-and-troubleshooting.md created with full Changelog/Troubleshooting/Plans conventions (Step 2.6.1)
- [ ] AGENTS.md updated with slim Change Management section only (link to docs/agents/changelog-and-troubleshooting.md); full block not in root (Step 2.6.2)
- [ ] Changelog directory structure created (`changelog/{added,changed,fixed,improved,docs,refactor,config}`)
- [ ] Existing CHANGELOG.md backed up (root and docs/ checked) if present
- [ ] `changelog/README.md` and `changelog/index.md` created
- [ ] `plans/` and `plans-completed/` created at project root (if they didn't exist)
- [ ] `plans-completed/index.md` and `plans-completed/README.md` created (naming: yyyy-mm-dd- prefix when moving; index maintained)
- [ ] AGENTS.md includes "Detailed Documentation" section linking to docs/agents/ (changelog-and-troubleshooting and any other topical files)
- [ ] `docs/` and `docs/agents/` created at project root (if they didn't exist)
- [ ] AGENTS.md follows slim architecture: essentials + links to docs/agents/ only; no long Changelog/Troubleshooting/Project Structure/Build/Coding blocks in root (Steps 2.6.2, 2.9.3)
- [ ] CLAUDE.md and GEMINI.md created at project root (standard; slim template, create if missing)
- [ ] Git configuration verified (workflows ignored in main repo)
- [ ] Troubleshooting structure verified
- [ ] Changelog structure verified
- [ ] Plans directories verified
- [ ] docs/ and docs/agents/ verified
- [ ] CLAUDE.md and GEMINI.md verified (standard verification)
- [ ] Backup files reviewed (if applicable)
- [ ] If migrated: index files updated with new paths; link/reference scan run and broken links fixed (Step 4.4)

---

## For AI Agents Executing This Setup

**Execution:** Read existing files first; preserve data (back up before moving/editing); replace all placeholders (`<PROJECT_NAME>`, `<PROJECT_PATH>`, `<GIT_REMOTE>`, `<WORKFLOWS_DIR>`, `<WORKFLOWS_REMOTE>`); verify after each step. Use parallel agents when appropriate; verify findings before making changes.

**Slim architecture (mandatory):** Changelog/Troubleshooting/Plans full text lives in `docs/agents/changelog-and-troubleshooting.md` (2.6.1). In AGENTS.md use only a slim Change Management section and a link to that doc (2.6.2). Move long sections (Project Structure, Build/Test, Coding, etc.) into `docs/agents/` and replace with a "Detailed Documentation" link list (2.9.3). Do not paste the full changelog/troubleshooting block or long prose into root AGENTS.md. Create CLAUDE.md and GEMINI.md if missing; do not overwrite existing.

**Safety:** Back up before migrating (e.g. CHANGELOG.md, TROUBLESHOOTING.md in root or `docs/`). Preserve existing index entries when updating `changelog/index.md`, `troubleshooting/index.md`, and `plans-completed/index.md` (new row at top when adding). After any renames/moves in changelog, troubleshooting, or plans-completed, run the link/reference scan (Step 4.4).

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

1. **Check backups** - All original files should be backed up in `troubleshooting/`
2. **Review git status** - Ensure the workflows directory is still in `.gitignore`
3. **Verify directory structure** - All category folders should exist
4. **Check file permissions** - Ensure files are readable/writable
5. **Verify file locations** - Check both root and `docs/` directories for existing files

For issues with the setup itself, create a troubleshooting entry in `troubleshooting/environment/` following the standard format.
