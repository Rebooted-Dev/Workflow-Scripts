# Project Initial Setup Workflow

This workflow sets up a new project (or migrates an existing project) with:
1. **Dual Repository Management** - Instructions for managing Info-Visualizer and Workflow-Scripts as separate repos
2. **Troubleshooting System** - Organized troubleshooting directory structure with backup of existing logs

---

## Purpose

This setup ensures:
- Clear separation between main project repo and workflows repo
- Proper git configuration to manage both independently
- Organized troubleshooting system that preserves existing troubleshooting data
- Consistent project structure across all projects using these workflows

---

## Prerequisites

- Git repository initialized
- Access to both repositories:
  - Main project repository (e.g., Info-Visualizer)
  - Workflow-Scripts repository (cloned into `workflows/` directory)

---

## Step 1: Set Up Dual Repository Management in AGENTS.md

### 1.1 Check for Existing AGENTS.md

If `AGENTS.md` exists, review it to see if dual repo instructions are already present. If not, add the following section.

### 1.2 Add Execution Guidelines Section

Add or update the execution guidelines section in `AGENTS.md`:

```markdown
### Execution
- Where possible, make clever and appropriate use of multiple parallel agents to orchestrate and execute tasks for better efficiency.
- Parallel agents can be used for:
  - Scanning codebases across different directories simultaneously
  - Reviewing different aspects of code (security, performance, style) in parallel
  - Testing multiple hypotheses during debugging
  - Validating changes across multiple files concurrently
- Always verify findings from parallel agents before acting on them
```

### 1.3 Add Repository Management Section

Add this section to `AGENTS.md` (or update existing section):

```markdown
## Repository Management

This project uses two separate repositories that should be managed independently:

### 1. Info-Visualizer Repository (This Repository)
- **Location**: `/Users/jesse/Development/Personal/Info-Visualizer`
- **Purpose**: Main application code, components, services, documentation
- **Git Remote**: `https://github.com/Rebooted-Dev/Info-Visualizer`

**Standard Git Operations:**
```bash
# Navigate to Info-Visualizer
cd /Users/jesse/Development/Personal/Info-Visualizer

# Check status
git status

# Pull latest changes
git pull

# Commit and push changes
git add .
git commit -m "feat: description of changes"
git push
```

### 2. Workflow-Scripts Repository (Nested in workflows/ directory)
- **Location**: `/Users/jesse/Development/Personal/Info-Visualizer/workflows/`
- **Purpose**: Reusable workflow instructions for development tasks (planning, review, development, debug, documentation)
- **Git Remote**: `https://github.com/Rebooted-Dev/Workflow-Scripts`
- **Note**: The `workflows/` directory is a separate git repository and is ignored by the main Info-Visualizer repo (see `.gitignore`)

**Standard Git Operations:**
```bash
# Navigate to workflows directory (nested in Info-Visualizer)
cd /Users/jesse/Development/Personal/Info-Visualizer/workflows

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
- Changes to Info-Visualizer do NOT automatically sync to Workflow-Scripts
- Changes to Workflow-Scripts do NOT automatically sync to Info-Visualizer
- Each repository has its own git history and version control

**When Working on Info-Visualizer (Main Repo):**
- Work from the root directory: `/Users/jesse/Development/Personal/Info-Visualizer`
- Focus on application code, components, services
- Update project-specific documentation in `docs/`
- Always update `CHANGELOG.md` for any code change (features, fixes, refactors). Create `CHANGELOG.md` if it does not exist.
- Update `troubleshooting/` only for bugs/issues or non-trivial problems encountered during development.
- The `workflows/` directory is **ignored** by git (in `.gitignore`), so it won't be included in commits
- Standard operations: `git add .`, `git commit`, `git push` - workflows will NOT be included

**When Working on Workflow-Scripts (Nested Repo):**
- Navigate to the workflows directory: `cd workflows/`
- Focus on workflow instructions and templates
- Update workflow documentation in `README.md` and `SHARING_AND_SYNC.md`
- These workflows are shared across multiple projects
- Changes here affect all projects that use these workflows
- Standard operations: `git add .`, `git commit`, `git push` - only workflows will be pushed

**Important Git Behavior:**
- The `workflows/` directory is listed in `.gitignore`, so it's completely ignored by the main repo
- When you run `git status`, `git add .`, or `git commit` from the Info-Visualizer root, workflows/ will NOT be included
- To push workflow changes, you MUST `cd workflows/` first, then run git commands there
- The workflows directory has its own `.git` folder and is a completely separate repository

**Best Practices:**
- Always commit Info-Visualizer changes from the root directory
- Always commit Workflow-Scripts changes from the `workflows/` directory
- Use clear commit messages indicating which repository you're working in
- Pull latest changes from both repos before starting work
- Keep workflow improvements in the workflows directory, not in the main repo
```

### 1.4 Verify .gitignore

Ensure `.gitignore` includes `workflows/`:

```bash
# Check if workflows/ is in .gitignore
grep -q "^workflows/$" .gitignore || echo "workflows/" >> .gitignore
```

---

## Step 2: Set Up Troubleshooting System

### 2.1 Check for Existing Troubleshooting Files

Before setting up, check for existing troubleshooting data:

```bash
# Check for root-level TROUBLESHOOTING.md
if [ -f "TROUBLESHOOTING.md" ]; then
  echo "Found root-level TROUBLESHOOTING.md - will back up"
fi

# Check for existing troubleshooting/ directory
if [ -d "troubleshooting" ]; then
  echo "Found existing troubleshooting/ directory"
  ls -la troubleshooting/
fi
```

### 2.2 Create Troubleshooting Directory Structure

Create the directory structure if it doesn't exist:

```bash
mkdir -p troubleshooting/{build,runtime,data,environment,security}
```

### 2.3 Backup Existing Troubleshooting Files

**If root-level TROUBLESHOOTING.md exists:**

```bash
# Create backup in troubleshooting directory
if [ -f "TROUBLESHOOTING.md" ]; then
  BACKUP_DATE=$(date +%Y-%m-%d)
  BACKUP_FILE="troubleshooting/TROUBLESHOOTING-backup-${BACKUP_DATE}.md"
  
  # Copy with header explaining it's a backup
  {
    echo "# Backup of Root-Level TROUBLESHOOTING.md"
    echo ""
    echo "**Backup Date:** ${BACKUP_DATE}"
    echo "**Original Location:** \`TROUBLESHOOTING.md\` (root level)"
    echo "**Note:** This file was backed up during initial setup. Original troubleshooting entries should be migrated to the new organized structure."
    echo ""
    echo "---"
    echo ""
    cat TROUBLESHOOTING.md
  } > "${BACKUP_FILE}"
  
  echo "✓ Backed up TROUBLESHOOTING.md to ${BACKUP_FILE}"
fi
```

**If troubleshooting/TROUBLESHOOTING.md exists:**

```bash
# Backup existing troubleshooting/TROUBLESHOOTING.md if it exists
if [ -f "troubleshooting/TROUBLESHOOTING.md" ]; then
  BACKUP_DATE=$(date +%Y-%m-%d)
  BACKUP_FILE="troubleshooting/TROUBLESHOOTING-backup-${BACKUP_DATE}.md"
  
  {
    echo "# Backup of troubleshooting/TROUBLESHOOTING.md"
    echo ""
    echo "**Backup Date:** ${BACKUP_DATE}"
    echo "**Original Location:** \`troubleshooting/TROUBLESHOOTING.md\`"
    echo "**Note:** This file was backed up during setup. Existing entries should remain in the troubleshooting directory structure."
    echo ""
    echo "---"
    echo ""
    cat troubleshooting/TROUBLESHOOTING.md
  } > "${BACKUP_FILE}"
  
  echo "✓ Backed up troubleshooting/TROUBLESHOOTING.md to ${BACKUP_FILE}"
fi
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
1. **Update `CHANGELOG.md`** for any code change (features, fixes, refactors). Create the file if missing.
2. **Create a troubleshooting entry** in the appropriate category folder only for bugs/issues or non-trivial problems.
3. **Update `troubleshooting/index.md`** to add the new entry at the top of the table when a troubleshooting entry is created.

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
| 2026-01-19 | environment | Workflow Scripts Git Ignore                                | `environment/2026-01-19-environment-workflow-scripts-git-ignore.md` | RESOLVED |
| 2026-01-18 | runtime     | Image Generation Stuck                                      | `runtime/2026-01-18-runtime-image-generation-stuck.md`       | RESOLVED |
| 2026-01-18 | environment | Gemini API Key Not Configured                              | `environment/2026-01-18-environment-gemini-api-key-not-configured.md` | RESOLVED |
```

**Note:** If existing entries exist, preserve them in the table. Only add new entries at the top.

### 2.6 Update AGENTS.md with Troubleshooting Instructions

Add or update the troubleshooting section in `AGENTS.md`:

```markdown
### Troubleshooting System (`troubleshooting/` directory)
- **When to update**: Document all bug fixes, issues, or non-trivial problems encountered during development.
- **Location**: Use the `troubleshooting/` directory system (NOT `TROUBLESHOOTING.md`).
- **Structure**: 
  - Create individual files in the appropriate category folder (`build/`, `runtime/`, `data/`, `environment/`, `security/`)
  - File naming: `<yyyy-mm-dd>-<category>-<short-title>.md`
  - Each entry must include: Date, Category, Status, Symptom, Root Cause, Fix, Verification, Notes/Lessons
- **Index maintenance**: Always update `troubleshooting/index.md` when adding a new entry (add row at the top of the table).
- **Template**: See `troubleshooting/README.md` for the entry template and full conventions.

### Interpreting "Update the Logs"
When instructed to "update the logs" or "update the log files", this refers to:
1. **CHANGELOG.md** - Always update for any code change (features, fixes, refactors). Create the file if missing.
2. **Troubleshooting entries** - Add entries to `troubleshooting/` only for bugs/issues or non-trivial problems.
3. **Both** - When a bug fix requires both a troubleshooting entry AND a changelog entry.

**Note**: This project does NOT use application logging files (`.log` files). The "logs" refer to the troubleshooting knowledge base and changelog documentation.
```

---

## Step 3: Verification

After setup, verify everything is correct:

### 3.1 Verify Git Configuration

```bash
# From project root - workflows should be ignored
cd /path/to/project
git status | grep workflows || echo "✓ workflows/ is properly ignored"

# From workflows directory - should be separate repo
cd workflows
git remote -v | grep Workflow-Scripts && echo "✓ workflows is separate repo"
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

### 3.3 Check for Backups

```bash
# List any backup files created
ls -la troubleshooting/*backup*.md 2>/dev/null && echo "✓ Backup files found"
```

---

## Step 4: Migration Notes (If Applicable)

If you're migrating an existing project:

1. **Review backup files** - Check `troubleshooting/TROUBLESHOOTING-backup-*.md` for any entries that need to be migrated
2. **Migrate entries** - Create new organized entries from old troubleshooting data if needed
3. **Update index** - Ensure all migrated entries are in `troubleshooting/index.md`
4. **Remove old files** - Once migration is complete and verified, you can remove:
   - Root-level `TROUBLESHOOTING.md` (if it exists and has been backed up)
   - `troubleshooting/TROUBLESHOOTING.md` (if it exists and has been backed up)

**Important:** Only remove old files after verifying all important information has been migrated to the new structure.

---

## Complete Setup Checklist

- [ ] AGENTS.md updated with execution guidelines (parallel agents)
- [ ] AGENTS.md updated with dual repository management section
- [ ] `.gitignore` includes `workflows/`
- [ ] Troubleshooting directory structure created
- [ ] Existing troubleshooting files backed up (if any)
- [ ] `troubleshooting/README.md` created
- [ ] `troubleshooting/index.md` created or updated
- [ ] AGENTS.md updated with troubleshooting system instructions
- [ ] Git configuration verified (workflows ignored in main repo)
- [ ] Troubleshooting structure verified
- [ ] Backup files reviewed (if applicable)

---

## For AI Agents Executing This Setup

When executing this setup workflow:

1. **Read existing files first** - Check what already exists before making changes
2. **Preserve existing data** - Always back up before modifying or moving files
3. **Update incrementally** - Don't overwrite existing AGENTS.md, add to it
4. **Verify after each step** - Check that changes were applied correctly
5. **Document what was done** - Note any backups created or files modified

**Key Safety Rules:**
- Never delete existing troubleshooting entries
- Always create backups before moving files
- Preserve existing index.md entries when updating
- Check for existing sections in AGENTS.md before adding new ones

**Execution Guidelines:**
- Use multiple parallel agents when appropriate to accelerate tasks
- Verify all findings from parallel agents before making changes
- Coordinate parallel work to avoid conflicts

---

## Troubleshooting the Setup

If something goes wrong during setup:

1. **Check backups** - All original files should be backed up in `troubleshooting/`
2. **Review git status** - Ensure workflows/ is still ignored
3. **Verify directory structure** - All category folders should exist
4. **Check file permissions** - Ensure files are readable/writable

For issues with the setup itself, create a troubleshooting entry in `troubleshooting/environment/` following the standard format.
