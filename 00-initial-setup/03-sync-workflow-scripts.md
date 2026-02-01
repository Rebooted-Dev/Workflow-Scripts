# Sync Workflow-Scripts Across Multiple Projects

## Purpose

Automate the process of updating `Workflow-Scripts` directories across all your projects that use these workflows. This eliminates the need to manually navigate to each project and run `git pull` in the `Workflow-Scripts` directory.

## Problem Statement

When you have multiple projects using the same `Workflow-Scripts` repository:
- You must manually navigate to each project's `Workflow-Scripts/` directory
- Run `git pull` in each one individually
- It's easy to forget which projects have been updated
- It's time-consuming and error-prone
- You lose track of which projects are synced or not

## Solution Overview

A sync script automates this process by:
1. **Finding all projects** that use Workflow-Scripts
2. **Updating each one** with the latest changes from the remote repository
3. **Reporting results** so you know what was updated and what failed

---

## Prerequisites

- Multiple projects that each have a `Workflow-Scripts/` directory (nested git repository)
- Bash shell (macOS/Linux) or Git Bash (Windows)
- Git installed and configured
- Access to the Workflow-Scripts remote repository

---

## Step 1: Create the Sync Script

### 1.1 Basic Script Structure

Create a file called `sync-workflow-scripts.sh` in a convenient location (e.g., your home directory or a scripts directory):

```bash
#!/bin/bash
# sync-workflow-scripts.sh
# Syncs Workflow-Scripts across all projects

# Exit on error
set -e
set -u
set -o pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
WORKFLOWS_DIR_NAME="Workflow-Scripts"
WORKFLOWS_REMOTE="https://github.com/Rebooted-Dev/Workflow-Scripts"
WORKFLOWS_BRANCH="main"

# Non-interactive mode: Set to "true" for CI/CD or automated runs
# When "true", automatically clones Workflow-Scripts if missing (no prompt)
# When "false", prompts user for confirmation (interactive mode)
NON_INTERACTIVE="${NON_INTERACTIVE:-false}"

# Project paths - EXAMPLES (replace with your actual project paths)
# These are placeholder examples showing the expected format.
# Replace the entire PROJECTS array with your own project paths.
PROJECTS=(
  "/path/to/your/Project1"  # Example: Replace with your actual path
  # Add more project paths here, one per line
  # "/path/to/Project2"
  # "/path/to/Project3"
)

# Counters
SUCCESS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0
TOTAL_PROJECTS=${#PROJECTS[@]}

echo -e "${BLUE}=== Workflow-Scripts Sync Tool ===${NC}"
echo -e "Syncing ${TOTAL_PROJECTS} project(s)..."
echo ""

# Process each project
for project_path in "${PROJECTS[@]}"; do
  project_name=$(basename "$project_path")
  workflows_path="${project_path}/${WORKFLOWS_DIR_NAME}"
  
  echo -e "${BLUE}Checking: ${project_name}${NC}"
  echo -e "  Path: ${project_path}"
  
  # Check if project directory exists
  if [ ! -d "$project_path" ]; then
    echo -e "  ${RED}✗ Project directory not found${NC}"
    ((FAIL_COUNT++))
    echo ""
    continue
  fi
  
  # Check if Workflow-Scripts directory exists
  if [ ! -d "$workflows_path" ]; then
    echo -e "  ${YELLOW}⚠ Workflow-Scripts not found${NC}"
    
    # Determine whether to clone based on interactive mode
    clone_workflows=false
    if [ "$NON_INTERACTIVE" = "true" ]; then
      echo -e "  ${BLUE}→ Non-interactive mode: auto-cloning...${NC}"
      clone_workflows=true
    elif [ -t 0 ]; then
      # Interactive mode with TTY available
      echo -e "  ${YELLOW}  Would you like to clone it? (y/n)${NC}"
      read -r response
      if [[ "$response" =~ ^[Yy]$ ]]; then
        clone_workflows=true
      fi
    else
      # No TTY available in interactive mode - skip to avoid hanging
      echo -e "  ${YELLOW}  No TTY available - skipping (set NON_INTERACTIVE=true to auto-clone)${NC}"
    fi
    
    if [ "$clone_workflows" = "true" ]; then
      echo -e "  ${BLUE}→ Cloning Workflow-Scripts...${NC}"
      cd "$project_path"
      if git clone "$WORKFLOWS_REMOTE" "$WORKFLOWS_DIR_NAME"; then
        echo -e "  ${GREEN}✓ Cloned successfully${NC}"
        ((SUCCESS_COUNT++))
      else
        echo -e "  ${RED}✗ Clone failed${NC}"
        ((FAIL_COUNT++))
      fi
    else
      echo -e "  ${YELLOW}⊘ Skipped${NC}"
      ((SKIP_COUNT++))
    fi
    echo ""
    continue
  fi
  
  # Check if it's a git repository
  if [ ! -d "$workflows_path/.git" ]; then
    echo -e "  ${RED}✗ Not a git repository${NC}"
    ((FAIL_COUNT++))
    echo ""
    continue
  fi
  
  # Navigate to Workflow-Scripts directory
  cd "$workflows_path"
  
  # Check for uncommitted changes
  if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo -e "  ${YELLOW}⚠ Uncommitted changes detected${NC}"
    echo -e "  ${YELLOW}  Stashing changes...${NC}"
    git stash push -m "Auto-stash before sync $(date +%Y-%m-%d\ %H:%M:%S)"
  fi
  
  # Check current branch
  current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "detached")
  if [ "$current_branch" == "detached" ] || [ "$current_branch" == "HEAD" ]; then
    echo -e "  ${YELLOW}⚠ Detached HEAD state${NC}"
    echo -e "  ${YELLOW}  Switching to ${WORKFLOWS_BRANCH} branch...${NC}"
    git fetch origin
    git checkout "$WORKFLOWS_BRANCH" || git checkout -b "$WORKFLOWS_BRANCH" "origin/${WORKFLOWS_BRANCH}"
  fi
  
  # Fetch latest changes
  echo -e "  ${BLUE}→ Fetching latest changes...${NC}"
  if ! git fetch origin; then
    echo -e "  ${RED}✗ Fetch failed${NC}"
    ((FAIL_COUNT++))
    echo ""
    continue
  fi
  
  # Check if behind
  LOCAL=$(git rev-parse @)
  REMOTE=$(git rev-parse "@{u}")
  BASE=$(git merge-base @ "@{u}")
  
  if [ "$LOCAL" = "$REMOTE" ]; then
    echo -e "  ${GREEN}✓ Already up to date${NC}"
    ((SUCCESS_COUNT++))
  elif [ "$LOCAL" = "$BASE" ]; then
    echo -e "  ${BLUE}→ Pulling changes...${NC}"
    if git pull --ff-only origin "$WORKFLOWS_BRANCH"; then
      echo -e "  ${GREEN}✓ Updated successfully${NC}"
      ((SUCCESS_COUNT++))
    else
      echo -e "  ${RED}✗ Pull failed (may need manual merge)${NC}"
      ((FAIL_COUNT++))
    fi
  elif [ "$REMOTE" = "$BASE" ]; then
    echo -e "  ${YELLOW}⚠ Local commits ahead of remote${NC}"
    echo -e "  ${YELLOW}  Consider pushing your changes${NC}"
    ((SKIP_COUNT++))
  else
    echo -e "  ${YELLOW}⚠ Diverged from remote${NC}"
    echo -e "  ${YELLOW}  Manual merge required${NC}"
    ((SKIP_COUNT++))
  fi
  
  echo ""
done

# Summary
echo -e "${BLUE}=== Summary ===${NC}"
echo -e "${GREEN}✓ Successfully synced: ${SUCCESS_COUNT}${NC}"
echo -e "${YELLOW}⊘ Skipped: ${SKIP_COUNT}${NC}"
echo -e "${RED}✗ Failed: ${FAIL_COUNT}${NC}"
echo ""

if [ $FAIL_COUNT -eq 0 ] && [ $SKIP_COUNT -eq 0 ]; then
  echo -e "${GREEN}All projects are up to date!${NC}"
  exit 0
elif [ $FAIL_COUNT -gt 0 ]; then
  echo -e "${RED}Some projects failed to sync. Check the output above.${NC}"
  exit 1
else
  echo -e "${YELLOW}Some projects were skipped. Review the output above.${NC}"
  exit 0
fi
```

### 1.2 Make Script Executable

After creating the script, make it executable:

```bash
chmod +x sync-workflow-scripts.sh
```

### 1.3 Customize the Script

**Update the PROJECTS array** with your actual project paths:

```bash
PROJECTS=(
  "/Volumes/Skynet/Software Development Projects/RBC Projects/New/Nu-Meta"
  "/Volumes/Skynet/Software Development Projects/RBC Projects/New/Project2"
  "/Volumes/Skynet/Software Development Projects/RBC Projects/New/Project3"
  # Add all your projects here
)
```

**Optional: Adjust configuration variables** if needed:

```bash
WORKFLOWS_DIR_NAME="Workflow-Scripts"  # Change if you use a different directory name
WORKFLOWS_REMOTE="https://github.com/Rebooted-Dev/Workflow-Scripts"  # Your remote URL
WORKFLOWS_BRANCH="main"  # Your default branch name
```

**Non-Interactive Mode (for CI/CD):**

For automated runs where user input is not available:

```bash
# Option 1: Set environment variable
export NON_INTERACTIVE="true"
./sync-workflow-scripts.sh

# Option 2: One-time execution
NON_INTERACTIVE="true" ./sync-workflow-scripts.sh
```

When `NON_INTERACTIVE="true"`, the script will:
- Automatically clone Workflow-Scripts if missing (no prompt)
- Skip operations requiring user confirmation
- Never hang waiting for input

---

## Step 2: Advanced Features (Optional)

### 2.1 Auto-Discovery Mode

Instead of manually listing projects, you can have the script find them automatically:

```bash
# Add this function before the main loop
find_projects() {
  local base_dir="/Volumes/Skynet/Software Development Projects/RBC Projects/New"
  local found_projects=()
  
  # Find all directories containing Workflow-Scripts
  while IFS= read -r -d '' project_path; do
    # Get parent directory (the project root)
    project_root=$(dirname "$project_path")
    found_projects+=("$project_root")
  done < <(find "$base_dir" -type d -name "$WORKFLOWS_DIR_NAME" -print0 2>/dev/null)
  
  # Remove duplicates and return
  printf '%s\n' "${found_projects[@]}" | sort -u
}

# Use auto-discovery (comment out PROJECTS array and use this instead)
# PROJECTS=($(find_projects))
```

### 2.2 Dry-Run Mode

Add a `--dry-run` flag to see what would happen without making changes:

```bash
# Add at the top after configuration
DRY_RUN=false
if [[ "$1" == "--dry-run" ]] || [[ "$1" == "-n" ]]; then
  DRY_RUN=true
  echo -e "${YELLOW}DRY RUN MODE - No changes will be made${NC}"
  echo ""
fi

# Then in the pull section, wrap the actual command:
if [ "$DRY_RUN" = true ]; then
  echo -e "  ${BLUE}[DRY RUN] Would pull changes${NC}"
else
  git pull --ff-only origin "$WORKFLOWS_BRANCH"
fi
```

### 2.3 Status Check Mode

Add a `--status` flag to check which projects are behind:

```bash
# Add status check function
check_status() {
  for project_path in "${PROJECTS[@]}"; do
    workflows_path="${project_path}/${WORKFLOWS_DIR_NAME}"
    
    if [ ! -d "$workflows_path/.git" ]; then
      continue
    fi
    
    cd "$workflows_path"
    git fetch origin --quiet
    
    LOCAL=$(git rev-parse @ 2>/dev/null)
    REMOTE=$(git rev-parse "@{u}" 2>/dev/null)
    BASE=$(git merge-base @ "@{u}" 2>/dev/null)
    
    project_name=$(basename "$project_path")
    
    if [ "$LOCAL" = "$REMOTE" ]; then
      echo -e "${GREEN}✓${NC} $project_name: Up to date"
    elif [ "$LOCAL" = "$BASE" ]; then
      behind=$(git rev-list --count HEAD..@{u})
      echo -e "${YELLOW}⚠${NC} $project_name: Behind by $behind commit(s)"
    elif [ "$REMOTE" = "$BASE" ]; then
      ahead=$(git rev-list --count @{u}..HEAD)
      echo -e "${BLUE}→${NC} $project_name: Ahead by $ahead commit(s)"
    else
      echo -e "${RED}✗${NC} $project_name: Diverged"
    fi
  done
}

# Add flag handling at the start
if [[ "$1" == "--status" ]] || [[ "$1" == "-s" ]]; then
  check_status
  exit 0
fi
```

### 2.4 Verbose Mode

Add `--verbose` flag for detailed output:

```bash
VERBOSE=false
if [[ "$1" == "--verbose" ]] || [[ "$1" == "-v" ]]; then
  VERBOSE=true
fi

# Then use it throughout:
if [ "$VERBOSE" = true ]; then
  git pull --ff-only origin "$WORKFLOWS_BRANCH" --verbose
else
  git pull --ff-only origin "$WORKFLOWS_BRANCH" --quiet
fi
```

---

## Step 3: Usage

### 3.1 Basic Usage

Run the script from anywhere:

```bash
./sync-workflow-scripts.sh
```

Or with full path:

```bash
/path/to/sync-workflow-scripts.sh
```

### 3.2 With Flags

```bash
# Check status without making changes
./sync-workflow-scripts.sh --status

# Dry run (see what would happen)
./sync-workflow-scripts.sh --dry-run

# Verbose output
./sync-workflow-scripts.sh --verbose
```

### 3.3 Add to PATH (Optional)

For easier access, add the script to your PATH:

```bash
# Create a bin directory in your home folder (if it doesn't exist)
mkdir -p ~/bin

# Move or symlink the script there
mv sync-workflow-scripts.sh ~/bin/
# OR create a symlink
ln -s /path/to/sync-workflow-scripts.sh ~/bin/sync-workflows

# Add to PATH (add this to your ~/.zshrc or ~/.bashrc)
export PATH="$HOME/bin:$PATH"

# Reload your shell config
source ~/.zshrc  # or source ~/.bashrc
```

Now you can run it from anywhere:

```bash
sync-workflows
```

---

## Step 4: Integration with Existing Workflows

### 4.1 Update SHARING_AND_SYNC.md

Add a reference to this sync script in `SHARING_AND_SYNC.md`:

```markdown
### Option C (Multi-Project Sync Script)

For managing multiple projects, use the sync script:

```bash
# Sync all projects at once
./sync-workflow-scripts.sh

# Check status of all projects
./sync-workflow-scripts.sh --status
```

See [`00-initial-setup/03-sync-workflow-scripts.md`](../00-initial-setup/03-sync-workflow-scripts.md) for setup instructions.
```

### 4.2 Add to Project Setup Workflow

Update `01-setup-project.md` to mention the sync script option:

```markdown
## Step 5: Set Up Multi-Project Sync (Optional)

If you have multiple projects using Workflow-Scripts, consider setting up the sync script:

See [`03-sync-workflow-scripts.md`](./03-sync-workflow-scripts.md) for instructions.
```

---

## Step 5: Troubleshooting

### Common Issues

#### Issue: "Project directory not found"

**Cause**: The path in the PROJECTS array is incorrect or the project was moved.

**Solution**: 
- Verify the path exists: `ls -la "/path/to/project"`
- Update the PROJECTS array with the correct path
- Use auto-discovery mode to find projects automatically

#### Issue: "Not a git repository"

**Cause**: The `Workflow-Scripts/` directory exists but isn't a git repository.

**Solution**:
```bash
cd /path/to/project/Workflow-Scripts
git init
git remote add origin https://github.com/Rebooted-Dev/Workflow-Scripts
git fetch
git checkout -b main origin/main
```

#### Issue: "Pull failed (may need manual merge)"

**Cause**: The local repository has diverged from remote or has conflicts.

**Solution**:
```bash
cd /path/to/project/Workflow-Scripts
git status  # Check what's happening
git pull    # Try regular pull (not --ff-only)
# Resolve conflicts if any, then commit
```

#### Issue: "Uncommitted changes detected"

**Cause**: You have local modifications in Workflow-Scripts that haven't been committed.

**Solution**:
- The script automatically stashes changes
- After sync, check if you need the stashed changes: `git stash list`
- Apply stashed changes if needed: `git stash pop`
- Or commit your changes first, then sync

#### Issue: Script permission denied

**Cause**: The script isn't executable.

**Solution**:
```bash
chmod +x sync-workflow-scripts.sh
```

---

## Step 6: Best Practices

### 6.1 Regular Sync Schedule

Sync regularly to keep all projects up to date:

```bash
# Add to your crontab for daily sync (optional)
# Run at 9 AM every day
0 9 * * * /path/to/sync-workflow-scripts.sh >> ~/sync-workflows.log 2>&1
```

### 6.2 Check Status Before Major Work

Before starting work that might affect workflows:

```bash
./sync-workflow-scripts.sh --status
```

### 6.3 Commit Workflow Changes Before Syncing

If you've made changes to workflows in one project:

```bash
cd /path/to/project/Workflow-Scripts
git add .
git commit -m "docs: update workflow description"
git push
```

Then sync other projects to get the changes.

### 6.4 Keep Project List Updated

When you add a new project:
1. Add it to the PROJECTS array in the script
2. Or use auto-discovery mode to find it automatically

### 6.5 Version Control the Script

Consider adding the sync script to a version-controlled location:

```bash
# Store in a shared scripts repository or in Workflow-Scripts itself
cp sync-workflow-scripts.sh ~/Workflow-Scripts/scripts/
```

---

## Comparison: Sync Script vs Alternatives

| Feature | Sync Script | Manual Sync | Symlinks | Git Submodules |
|---------|-------------|-------------|----------|----------------|
| **Ease of Use** | ✅ One command | ❌ Multiple commands | ✅ Automatic | ⚠️ Complex |
| **Portability** | ✅ Works everywhere | ✅ Works everywhere | ❌ System-dependent | ✅ Works everywhere |
| **Git Compatibility** | ✅ No issues | ✅ No issues | ⚠️ Can confuse Git | ✅ Standard |
| **Isolation** | ✅ Per-project | ✅ Per-project | ❌ Shared | ✅ Per-project |
| **Setup Complexity** | ⚠️ One-time setup | ✅ None | ⚠️ Per-project | ⚠️ Per-project |
| **Error Handling** | ✅ Built-in | ❌ Manual | ❌ None | ⚠️ Git handles |
| **Status Checking** | ✅ Built-in | ❌ Manual | N/A | ⚠️ Git commands |

---

## Summary

The sync script provides:
- ✅ **Automation**: Update all projects with one command
- ✅ **Safety**: Handles uncommitted changes, detached HEAD, etc.
- ✅ **Visibility**: Clear reporting of what was updated
- ✅ **Flexibility**: Dry-run, status check, verbose modes
- ✅ **Portability**: Works on any system with bash and git

**Next Steps**:
1. Create the script with your project paths
2. Make it executable
3. Test it with `--dry-run` first
4. Run it regularly to keep projects in sync
5. Consider adding it to your PATH for convenience

---

## For AI Agents Executing This Workflow

When helping users set up the sync script:

1. **Read existing configuration** - Check if a sync script already exists
2. **Gather project paths** - Ask user for all project locations or use auto-discovery
3. **Create the script** - Use the template above, customizing with actual paths
4. **Test first** - Always test with `--dry-run` before running for real
5. **Verify permissions** - Ensure script is executable
6. **Document location** - Note where the script was created
7. **Update documentation** - Add references in SHARING_AND_SYNC.md if appropriate

**Safety Guidelines**:
- Never force push or overwrite user changes
- Always check for uncommitted changes before pulling
- Provide clear error messages
- Preserve user's local modifications (use stash)
- Exit with appropriate status codes for scripting
