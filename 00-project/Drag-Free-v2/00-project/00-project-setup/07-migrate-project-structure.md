# Migrate Existing Project to Standard Structure

This workflow helps you transition an existing project to the standardized `project/` directory structure defined in [01-setup-project.md](./01-setup-project.md). It handles migration from various starting states, including monolithic files and unorganized directories.

---

## When to Use This Workflow

- Your project has changelog/troubleshooting as single files or root-level directories
- Your plans are scattered in various locations without proper indexing
- You want to consolidate project metadata under a single `project/` directory
- You need to adopt the multi-repo structure with Workflow-Scripts

---

## Prerequisites

Before starting:

1. **Review the target structure** in [01-setup-project.md](./01-setup-project.md) — this workflow references it heavily
2. **Backup your repository** — migration involves moving files and restructuring
3. **Identify your current state** — assess what you have:
   - Root-level `CHANGELOG.md` or `changelog/` directory?
   - Root-level `TROUBLESHOOTING.md` or `troubleshooting/` directory?
   - `plans/` or `plans-completed/` directories? Where are they located?
   - Existing `docs/` directory? Should it move under `project/` or stay at root?

---

## Migration Overview

The migration follows this general pattern:

```
Before                          After
─────────────────────────────────────────────────────────────
CHANGELOG.md                    project/changelog/CHANGELOG-backup-*.md
TROUBLESHOOTING.md              project/troubleshooting/TROUBLESHOOTING-backup-*.md
changelog/                      project/changelog/ (type folders + index)
troubleshooting/                project/troubleshooting/ (category folders + index)
plans/                          project/plans/ (with README + TODO)
plans-completed/                project/plans-completed/ (category folders + index)
docs/                           project/docs/ OR stay at root (your choice)
└── agents/                     └── agents/changelog-and-troubleshooting.md
```

---

## Step 1: Set Up Multi-Repo Structure

First, ensure the dual-repository management is in place:

### 1.1 Add Workflow-Scripts (if not present)

```bash
# From project root
git clone https://github.com/Rebooted-Dev/Workflow-Scripts Workflow-Scripts
```

### 1.2 Update .gitignore

```bash
# Ensure Workflow-Scripts is ignored
echo "" >> .gitignore
echo "# Workflow-Scripts (separate repo)" >> .gitignore
echo "Workflow-Scripts/" >> .gitignore
echo "workflows/" >> .gitignore  # If you use this naming
```

### 1.3 Create or Update AGENTS.md

Follow [01-setup-project.md Step 1](./01-setup-project.md#step-1-set-up-dual-repository-management-in-agentsmd):

- Add Execution section
- Add Repository Management section (critical for multi-repo)
- Add slim Change Management section linking to `project/docs/agents/`

**Key**: Update all paths to use `project/` prefix for changelog, troubleshooting, and docs.

---

## Step 2: Create Target Directory Structure

Create the full `project/` structure that will house your migrated content:

```bash
# Core project directories
mkdir -p project/{KIV,research,build,plans}

# Changelog with type folders and plans subdir
mkdir -p project/changelog/{added,changed,fixed,improved,docs,refactor,config,plans}

# Troubleshooting with category folders
mkdir -p project/troubleshooting/{build,runtime,data,environment,security}

# Plans-completed with category folders
mkdir -p project/plans-completed/{implementation,investigation,migration,review,tooling}

# Documentation (optional: use project/docs/ or keep docs/ at root)
mkdir -p project/docs/agents
```

---

## Step 3: Migrate Changelog

### 3.1 Assess Your Current State

Determine which applies to your project:

| State | Action |
|-------|--------|
| `CHANGELOG.md` at root | Back up, then extract entries to individual files |
| `changelog/` at root with loose files | Move to `project/changelog/`, organize by type |
| `changelog/` already organized | Move to `project/changelog/` |
| `docs/CHANGELOG.md` | Back up, then migrate entries |
| No existing changelog | Start fresh with new structure |

### 3.2 Back Up Monolithic Files

If you have `CHANGELOG.md` or `docs/CHANGELOG.md`:

```bash
BACKUP_DATE=$(date +%Y-%m-%d)

# Back up root-level CHANGELOG.md
if [ -f "CHANGELOG.md" ]; then
  cp CHANGELOG.md "project/changelog/CHANGELOG-backup-root-${BACKUP_DATE}.md"
  echo "Backed up CHANGELOG.md"
fi

# Back up docs/CHANGELOG.md
if [ -f "docs/CHANGELOG.md" ]; then
  cp docs/CHANGELOG.md "project/changelog/CHANGELOG-backup-docs-${BACKUP_DATE}.md"
  echo "Backed up docs/CHANGELOG.md"
fi
```

### 3.3 Migrate Existing changelog/ Directory

If you have a root-level `changelog/` directory:

```bash
# Option A: Simple move (if already organized by type)
cp -R changelog/* project/changelog/ 2>/dev/null || true

# Option B: Manual organization (if files are mixed)
# Review each file and move to appropriate type folder:
# - New features → project/changelog/added/
# - Bug fixes → project/changelog/fixed/
# - Improvements → project/changelog/improved/
# - Documentation → project/changelog/docs/
# - Config/tooling → project/changelog/config/
# - Refactoring → project/changelog/refactor/
# - Behavior changes → project/changelog/changed/
```

### 3.4 Create Changelog Index

Create or update `project/changelog/index.md`:

```markdown
# Changelog Index

Chronological index of changelog entries and completed plans.
**Newest entries are listed first.**

| Date | Type | Title | File | Notes |
|------|------|-------|------|-------|
```

**If migrating existing entries**: Add rows for all existing changelog entries to the index, **newest first**.

### 3.5 Create Changelog README

Create `project/changelog/README.md` with the template from [01-setup-project.md Step 2.7.4](./01-setup-project.md#274-create-changelog-readmemd).

---

## Step 4: Migrate Troubleshooting

### 4.1 Assess Your Current State

| State | Action |
|-------|--------|
| `TROUBLESHOOTING.md` at root | Back up, then extract entries to individual files |
| `troubleshooting/` at root with loose files | Move to `project/troubleshooting/`, organize by category |
| `troubleshooting/` already organized | Move to `project/troubleshooting/` |
| `docs/TROUBLESHOOTING.md` | Keep as user-facing guide; create entries in `project/troubleshooting/` |
| No existing troubleshooting | Start fresh |

### 4.2 Back Up Monolithic Files

```bash
BACKUP_DATE=$(date +%Y-%m-%d)

# Back up root-level TROUBLESHOOTING.md
if [ -f "TROUBLESHOOTING.md" ]; then
  cp TROUBLESHOOTING.md "project/troubleshooting/TROUBLESHOOTING-backup-root-${BACKUP_DATE}.md"
  echo "Backed up TROUBLESHOOTING.md"
fi

# Back up docs/TROUBLESHOOTING.md (if not keeping as user guide)
if [ -f "docs/TROUBLESHOOTING.md" ]; then
  cp docs/TROUBLESHOOTING.md "project/troubleshooting/TROUBLESHOOTING-backup-docs-${BACKUP_DATE}.md"
  echo "Backed up docs/TROUBLESHOOTING.md"
fi
```

### 4.3 Migrate Existing troubleshooting/ Directory

```bash
# Option A: Simple move (if already organized by category)
cp -R troubleshooting/* project/troubleshooting/ 2>/dev/null || true

# Option B: Manual organization (if files are mixed)
# Review each file and categorize:
# - Build/test issues → project/troubleshooting/build/
# - Runtime/UI bugs → project/troubleshooting/runtime/
# - Data/persistence → project/troubleshooting/data/
# - Environment/setup → project/troubleshooting/environment/
# - Security issues → project/troubleshooting/security/
```

### 4.4 Create Troubleshooting Index and README

Follow [01-setup-project.md Step 2.4 and 2.5](./01-setup-project.md#step-2-set-up-troubleshooting-system) to create:

- `project/troubleshooting/README.md` — system documentation
- `project/troubleshooting/index.md` — chronological index

---

## Step 5: Migrate Plans

### 5.1 Assess Your Current State

Plans can exist in various states:

| Location | Typical State |
|----------|--------------|
| `plans/` at root | Mix of active and completed plans |
| `plans-completed/` at root | Unorganized or flat structure |
| `project/plans/` already | May need README/TODO added |
| Scattered in various dirs | Needs consolidation |

### 5.2 Migrate plans/ Directory

```bash
# Create active plans directory if not exists
mkdir -p project/plans

# Move existing plans
cp -R plans/* project/plans/ 2>/dev/null || true

# Remove old directory (after verifying copy)
# rm -rf plans
```

### 5.3 Create Plans Structure

Create the required files:

1. **`project/plans/README.md`** — Map to project directory
2. **`project/plans/TODO.md`** — Current tasks with filing reference

Use templates from [01-setup-project.md Step 2.8](./01-setup-project.md#step-28-set-up-projectplans-readme-and-todo-and-project-dirs).

### 5.4 Migrate plans-completed/ Directory

```bash
# Option A: Simple move (if already categorized)
cp -R plans-completed/* project/plans-completed/ 2>/dev/null || true

# Option B: Manual categorization
# Move each completed plan to appropriate category:
# - Implementation plans → project/plans-completed/implementation/
# - Research/investigations → project/plans-completed/investigation/
# - Migration plans → project/plans-completed/migration/
# - Reviews/audits → project/plans-completed/review/
# - Tooling/setup → project/plans-completed/tooling/
```

### 5.5 Create Plans-Completed Structure

Create:

1. **`project/plans-completed/README.md`** — Category definitions and filing rules
2. **`project/plans-completed/index.md`** — Chronological index

Use templates from [01-setup-project.md Step 2.8.4](./01-setup-project.md#284-archiving-a-completed-plan-file-as-completed--default).

---

## Step 6: Migrate or Consolidate Documentation

### 6.1 Decide on docs/ Location

Two valid approaches:

| Approach | When to Use |
|----------|-------------|
| `project/docs/` | Centralized structure (all project metadata in `project/`)
| `docs/` at root | Docs are prominent/separate from project metadata |

### 6.2 If Moving to project/docs/

```bash
# Move docs under project/
cp -R docs/* project/docs/ 2>/dev/null || true

# Create agents subdirectory if not exists
mkdir -p project/docs/agents
```

### 6.3 Create Agent Documentation

Essential file: `project/docs/agents/changelog-and-troubleshooting.md`

Use the full conventions template from [01-setup-project.md Step 2.6.1](./01-setup-project.md#261-create-docsagentschangelog-and-troubleshootingmd).

**Critical**: This file must use `project/` paths in all references.

---

## Step 7: Update Agent Files

### 7.1 Update AGENTS.md

Ensure all paths are updated to use `project/` prefix:

| Old Path | New Path |
|----------|----------|
| `changelog/` | `project/changelog/` |
| `troubleshooting/` | `project/troubleshooting/` |
| `docs/` | `project/docs/` |
| `plans/` | `project/plans/` |
| `plans-completed/` | `project/plans-completed/` |

### 7.2 Update CLAUDE.md and GEMINI.md (if present)

Apply the same path updates.

### 7.3 Verify Branch Information

Ensure tracked repository branches are accurate:

```markdown
## Tracked Repositories

1. **Your-Project** (Primary, `.` root) - `main` branch
2. **Workflow-Scripts** (Companion, `Workflow-Scripts/`) - `main` branch
```

---

## Step 8: Clean Up Old Structure

### 8.1 Verify Migration

Before removing old directories, verify:

```bash
# Check that project/ structure is complete
ls project/
ls project/changelog/
ls project/troubleshooting/
ls project/plans/
ls project/plans-completed/
ls project/docs/agents/

# Check that indexes exist
test -f project/changelog/index.md && echo "✓ Changelog index"
test -f project/troubleshooting/index.md && echo "✓ Troubleshooting index"
test -f project/plans-completed/index.md && echo "✓ Plans-completed index"
```

### 8.2 Remove Old Directories

**Only after verifying the migration**:

```bash
# Remove old root-level directories
rm -rf changelog troubleshooting plans plans-completed

# Optionally remove old docs/ if moved to project/docs/
# rm -rf docs
```

### 8.3 Remove Old Files

```bash
# Remove backed-up monolithic files (already copied to project/)
rm -f CHANGELOG.md TROUBLESHOOTING.md

# Remove backed-up docs files (if migrated)
# rm -f docs/CHANGELOG.md docs/TROUBLESHOOTING.md
```

---

## Step 9: Verification

### 9.1 Directory Structure Check

```bash
# From project root

echo "=== Project Structure ==="
ls -la project/

echo "=== Changelog ==="
ls project/changelog/

echo "=== Troubleshooting ==="
ls project/troubleshooting/

echo "=== Plans ==="
ls project/plans/

echo "=== Plans Completed ==="
ls project/plans-completed/

echo "=== Documentation ==="
ls project/docs/
ls project/docs/agents/
```

### 9.2 Git Status Check

```bash
git status
```

You should see:
- New `project/` directory with all contents
- Deleted old root-level directories (if removed)
- Modified `AGENTS.md`, `CLAUDE.md`, `GEMINI.md` (if updated)
- Modified `.gitignore` (if updated)

### 9.3 Test Links

Verify that links in agent files work:

```bash
# Check that referenced files exist
test -f project/docs/agents/changelog-and-troubleshooting.md
test -f project/changelog/README.md
test -f project/troubleshooting/README.md
test -f project/plans/README.md
test -f project/plans/TODO.md
test -f project/plans-completed/README.md
echo "✓ All documentation files present"
```

---

## Flexible Migration Scenarios

### Scenario A: Minimal Migration (Keep It Simple)

If you have a simple project with just a `CHANGELOG.md`:

```bash
# Quick migration for simple projects
mkdir -p project/changelog/{added,changed,fixed,improved,docs,refactor,config,plans}
cp CHANGELOG.md "project/changelog/CHANGELOG-backup-$(date +%Y-%m-%d).md"
echo "# Changelog Index" > project/changelog/index.md
echo "" >> project/changelog/index.md
echo "| Date | Type | Title | File | Notes |" >> project/changelog/index.md
echo "|------|------|-------|------|-------|" >> project/changelog/index.md
rm CHANGELOG.md
```

Then manually add entries to `project/changelog/index.md` as needed.

### Scenario B: Gradual Migration (Don't Move Everything at Once)

If you want to migrate gradually:

1. **Phase 1**: Create `project/` structure, keep old directories
2. **Phase 2**: Update AGENTS.md to reference new paths
3. **Phase 3**: Start using new structure for new entries
4. **Phase 4**: Migrate existing entries over time
5. **Phase 5**: Remove old directories when confident

### Scenario C: Hybrid Approach (Some at Root, Some in project/)

If you prefer keeping some items at root:

- Keep `docs/` at root (user-facing documentation)
- Move `changelog/` and `troubleshooting/` to `project/`
- Update AGENTS.md to reference correct paths for each

**Note**: The workflow assumes centralized `project/` structure. Hybrid approaches require careful documentation in AGENTS.md.

### Scenario D: Existing Index Data

If your existing `changelog/index.md` or `troubleshooting/index.md` has data:

1. Copy the index file to `project/changelog/index.md` (or troubleshooting)
2. Update all File paths in the index to use `project/` prefix
3. Example: `fixed/2026-01-01-bug.md` → `project/changelog/fixed/2026-01-01-bug.md`

---

## Post-Migration

### Commit Your Changes

```bash
git add .
git status  # Review what will be committed
git commit -m "refactor: migrate to standardized project structure

- Consolidate changelog, troubleshooting, plans under project/
- Add dual-repo management documentation
- Update AGENTS.md, CLAUDE.md, GEMINI.md with new paths
- Add README and TODO files for project organization"
```

### Next Steps

1. **Start using the new structure** — create entries in `project/changelog/` and `project/troubleshooting/`
2. **File completed plans** to `project/plans-completed/<category>/`
3. **Update indexes** whenever adding new entries
4. **Reference [01-setup-project.md](./01-setup-project.md)** for ongoing conventions

---

## Troubleshooting Migration Issues

### Issue: "I missed some files during migration"

```bash
# Search for missed changelog/troubleshooting files
find . -name "CHANGELOG*" -not -path "./project/*" -not -path "./.git/*"
find . -name "TROUBLESHOOTING*" -not -path "./project/*" -not -path "./.git/*"
find . -name "*plan*.md" -not -path "./project/*" -not -path "./.git/*" -not -path "./Workflow-Scripts/*"
```

### Issue: "My indexes have broken links"

Update the File column in all index.md files to use correct relative paths:

```markdown
# Before
| 2026-01-01 | Fixed | Bug fix | [Link](fixed/2026-01-01-bug.md) | |

# After
| 2026-01-01 | Fixed | Bug fix | [Link](project/changelog/fixed/2026-01-01-bug.md) | |
```

### Issue: "I want to undo the migration"

If you stashed your changes before migrating:

```bash
git stash pop
```

If you committed the migration:

```bash
git revert HEAD  # Creates a new commit that undoes the migration
```

---

## See Also

- **[01-setup-project.md](./01-setup-project.md)** — Full setup workflow (target structure)
- **[04-track-repos-and-agent-map.md](./04-track-repos-and-agent-map.md)** — Repository tracking
- **[README.md](./README.md)** — Overview of all setup workflows