#!/bin/bash
# sync-workflow-scripts.sh
# Syncs Workflow-Scripts across all projects
#
# IMPORTANT: Before first use, you MUST either:
#   1. Update the PROJECTS array below with your project paths, OR
#   2. Use the --auto flag to auto-discover projects, OR
#   3. Set WORKFLOW_SYNC_BASE_DIR environment variable
#
# Usage:
#   ./sync-workflow-scripts.sh              # Sync all projects
#   ./sync-workflow-scripts.sh --status     # Check status only
#   ./sync-workflow-scripts.sh --dry-run    # See what would happen
#   ./sync-workflow-scripts.sh --verbose    # Detailed output
#   ./sync-workflow-scripts.sh --auto       # Auto-discover projects
#
# Environment:
#   WORKFLOW_SYNC_BASE_DIR  Override base directory for auto-discovery
#   NON_INTERACTIVE=true    Auto-clone when Workflow-Scripts missing

# Exit on error (but we'll handle errors gracefully)
set -euo pipefail

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
# BASE_DIR: Set via WORKFLOW_SYNC_BASE_DIR env var, --auto flag, or PROJECTS array below
# Default is empty - will fail gracefully with instructions if not configured
BASE_DIR="${WORKFLOW_SYNC_BASE_DIR:-}"

# If BASE_DIR is set, resolve to absolute path and validate
if [ -n "$BASE_DIR" ]; then
  BASE_DIR="$(cd "${BASE_DIR}" 2>/dev/null && pwd)" || {
    echo -e "${RED}Error: WORKFLOW_SYNC_BASE_DIR is not a valid directory: ${BASE_DIR}${NC}" >&2
    exit 1
  }
fi
# When "true", auto-clone when Workflow-Scripts missing (no prompt); for CI/non-interactive use
NON_INTERACTIVE="${NON_INTERACTIVE:-false}"

# Project paths - UPDATE THESE WITH YOUR ACTUAL PROJECT PATHS
# Or use --auto flag to discover them automatically
PROJECTS=(
  "/Volumes/Skynet/Software Development Projects/RBC Projects/New/Nu-Meta"
  # Add more project paths here, one per line
  # "/path/to/Project2"
  # "/path/to/Project3"
)

# Flags
DRY_RUN=false
STATUS_ONLY=false
VERBOSE=false
AUTO_DISCOVER=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --dry-run|-n)
      DRY_RUN=true
      shift
      ;;
    --status|-s)
      STATUS_ONLY=true
      shift
      ;;
    --verbose|-v)
      VERBOSE=true
      shift
      ;;
    --auto|-a)
      AUTO_DISCOVER=true
      shift
      ;;
    --help|-h)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --dry-run, -n    Show what would happen without making changes"
      echo "  --status, -s     Check status of all projects (no sync)"
      echo "  --verbose, -v    Show detailed git output"
      echo "  --auto, -a       Auto-discover projects (ignores PROJECTS array)"
      echo "  --help, -h       Show this help message"
      echo ""
      echo "Environment:"
      echo "  NON_INTERACTIVE=true   Auto-clone when Workflow-Scripts missing (no prompt)"
      echo "  WORKFLOW_SYNC_BASE_DIR Override BASE_DIR for auto-discovery (--auto)"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# Auto-discovery function
find_projects() {
  local found_projects=()
  
  if [ ! -d "$BASE_DIR" ]; then
    echo -e "${RED}Error: Base directory not found: $BASE_DIR${NC}" >&2
    return 1
  fi
  
  # Find all directories containing Workflow-Scripts
  while IFS= read -r -d '' project_path; do
    # Get parent directory (the project root)
    project_root=$(dirname "$project_path")
    found_projects+=("$project_root")
  done < <(find "$BASE_DIR" -type d -name "$WORKFLOWS_DIR_NAME" -print0 2>/dev/null)
  
  # Remove duplicates and return
  printf '%s\n' "${found_projects[@]}" | sort -u
}

# Use auto-discovery if requested
if [ "$AUTO_DISCOVER" = true ]; then
  echo -e "${BLUE}Auto-discovering projects in: $BASE_DIR${NC}"
  mapfile -t PROJECTS < <(find_projects)
  if [ ${#PROJECTS[@]} -eq 0 ]; then
    echo -e "${YELLOW}No projects found with $WORKFLOWS_DIR_NAME directory${NC}"
    exit 0
  fi
  echo -e "${GREEN}Found ${#PROJECTS[@]} project(s)${NC}"
  echo ""
fi

# Validate PROJECTS array is populated
if [ ${#PROJECTS[@]} -eq 0 ]; then
  echo -e "${YELLOW}Warning: PROJECTS array is empty.${NC}"
  echo ""
  echo "To use this script, either:"
  echo "  1. Edit PROJECTS array in this script with your project paths"
  echo "  2. Use --auto flag to auto-discover projects"
  echo "  3. Set WORKFLOW_SYNC_BASE_DIR environment variable"
  echo ""
  echo "Example:"
  echo "  ./sync-workflow-scripts.sh --auto"
  echo ""
  exit 1
fi

# Status check function
check_status() {
  local success_count=0
  local behind_count=0
  local ahead_count=0
  local diverged_count=0
  local missing_count=0
  
  echo -e "${BLUE}=== Workflow-Scripts Status Check ===${NC}"
  echo ""
  
  for project_path in "${PROJECTS[@]}"; do
    project_name=$(basename "$project_path")
    workflows_path="${project_path}/${WORKFLOWS_DIR_NAME}"
    
    if [ ! -d "$project_path" ]; then
      echo -e "${RED}✗${NC} $project_name: Project directory not found"
      ((missing_count++))
      continue
    fi
    
    if [ ! -d "$workflows_path/.git" ]; then
      echo -e "${YELLOW}⊘${NC} $project_name: Workflow-Scripts not found or not a git repo"
      ((missing_count++))
      continue
    fi
    
    cd "$workflows_path" 2>/dev/null || continue
    
    # Fetch quietly
    if [ "$VERBOSE" = true ]; then
      git fetch origin
    else
      git fetch origin --quiet 2>/dev/null
    fi
    
    # Check status
    LOCAL=$(git rev-parse @ 2>/dev/null || echo "")
    REMOTE=$(git rev-parse '@{u}' 2>/dev/null || echo "")
    
    if [ -z "$LOCAL" ] || [ -z "$REMOTE" ]; then
      echo -e "${YELLOW}⊘${NC} $project_name: Cannot determine status"
      continue
    fi
    
    BASE=$(git merge-base @ '@{u}' 2>/dev/null || echo "")
    
    if [ "$LOCAL" = "$REMOTE" ]; then
      echo -e "${GREEN}✓${NC} $project_name: Up to date"
      ((success_count++))
    elif [ "$LOCAL" = "$BASE" ]; then
      behind=$(git rev-list --count 'HEAD..@{u}' 2>/dev/null || echo "?")
      echo -e "${YELLOW}⚠${NC} $project_name: Behind by $behind commit(s)"
      ((behind_count++))
    elif [ "$REMOTE" = "$BASE" ]; then
      ahead=$(git rev-list --count '@{u}..HEAD' 2>/dev/null || echo "?")
      echo -e "${BLUE}→${NC} $project_name: Ahead by $ahead commit(s)"
      ((ahead_count++))
    else
      echo -e "${RED}✗${NC} $project_name: Diverged from remote"
      ((diverged_count++))
    fi
  done
  
  echo ""
  echo -e "${BLUE}=== Summary ===${NC}"
  echo -e "${GREEN}✓ Up to date: $success_count${NC}"
  echo -e "${YELLOW}⚠ Behind: $behind_count${NC}"
  echo -e "${BLUE}→ Ahead: $ahead_count${NC}"
  echo -e "${RED}✗ Diverged: $diverged_count${NC}"
  echo -e "${YELLOW}⊘ Missing/Not found: $missing_count${NC}"
}

# If status-only mode, run check and exit
if [ "$STATUS_ONLY" = true ]; then
  check_status
  exit 0
fi

# Main sync process
SUCCESS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0
TOTAL_PROJECTS=${#PROJECTS[@]}

if [ "$DRY_RUN" = true ]; then
  echo -e "${YELLOW}=== DRY RUN MODE - No changes will be made ===${NC}"
  echo ""
fi

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
    if [ "$DRY_RUN" = true ]; then
      echo -e "  ${BLUE}[DRY RUN] Would prompt to clone (or auto-clone if NON_INTERACTIVE=true)${NC}"
      ((SKIP_COUNT++))
    else
      clone_workflows=false
      if [ "$NON_INTERACTIVE" = "true" ]; then
        echo -e "  ${BLUE}→ Non-interactive mode: auto-cloning...${NC}"
        clone_workflows=true
      elif [ -t 0 ]; then
        echo -e "  ${YELLOW}  Would you like to clone it? (y/n)${NC}"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
          clone_workflows=true
        fi
      else
        echo -e "  ${YELLOW}  No TTY - skipping (set NON_INTERACTIVE=true to auto-clone)${NC}"
      fi
      if [ "$clone_workflows" = true ]; then
        echo -e "  ${BLUE}→ Cloning Workflow-Scripts...${NC}"
        if ! cd "$project_path" 2>/dev/null; then
          echo -e "  ${RED}✗ Cannot access project directory${NC}"
          ((FAIL_COUNT++))
        elif git clone "$WORKFLOWS_REMOTE" "$WORKFLOWS_DIR_NAME"; then
          echo -e "  ${GREEN}✓ Cloned successfully${NC}"
          ((SUCCESS_COUNT++))
        else
          echo -e "  ${RED}✗ Clone failed${NC}"
          ((FAIL_COUNT++))
        fi
      else
        ((SKIP_COUNT++))
      fi
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
  cd "$workflows_path" || {
    echo -e "  ${RED}✗ Cannot access directory${NC}"
    ((FAIL_COUNT++))
    echo ""
    continue
  }
  
  # Check for uncommitted changes
  if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo -e "  ${YELLOW}⚠ Uncommitted changes detected${NC}"
    if [ "$DRY_RUN" = true ]; then
      echo -e "  ${BLUE}[DRY RUN] Would stash changes${NC}"
    else
      echo -e "  ${YELLOW}  Stashing changes...${NC}"
      git stash push -m "Auto-stash before sync $(date +%Y-%m-%d\ %H:%M:%S)" 2>/dev/null || {
        echo -e "  ${RED}✗ Stash failed${NC}"
        ((FAIL_COUNT++))
        echo ""
        continue
      }
    fi
  fi
  
  # Check current branch
  current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "detached")
  if [ "$current_branch" == "detached" ] || [ "$current_branch" == "HEAD" ]; then
    echo -e "  ${YELLOW}⚠ Detached HEAD state${NC}"
    if [ "$DRY_RUN" = true ]; then
      echo -e "  ${BLUE}[DRY RUN] Would switch to ${WORKFLOWS_BRANCH} branch${NC}"
    else
      echo -e "  ${YELLOW}  Switching to ${WORKFLOWS_BRANCH} branch...${NC}"
      git fetch origin 2>/dev/null || true
      git checkout "$WORKFLOWS_BRANCH" 2>/dev/null || git checkout -b "$WORKFLOWS_BRANCH" "origin/${WORKFLOWS_BRANCH}" 2>/dev/null || {
        echo -e "  ${RED}✗ Cannot switch to branch${NC}"
        ((FAIL_COUNT++))
        echo ""
        continue
      }
    fi
  fi
  
  # Fetch latest changes
  echo -e "  ${BLUE}→ Fetching latest changes...${NC}"
  if [ "$DRY_RUN" = true ]; then
    echo -e "  ${BLUE}[DRY RUN] Would fetch from origin${NC}"
  else
    if [ "$VERBOSE" = true ]; then
      git fetch origin || {
        echo -e "  ${RED}✗ Fetch failed${NC}"
        ((FAIL_COUNT++))
        echo ""
        continue
      }
    else
      git fetch origin --quiet 2>/dev/null || {
        echo -e "  ${RED}✗ Fetch failed${NC}"
        ((FAIL_COUNT++))
        echo ""
        continue
      }
    fi
  fi
  
  # Check if behind
  LOCAL=$(git rev-parse @ 2>/dev/null || echo "")
  REMOTE=$(git rev-parse '@{u}' 2>/dev/null || echo "")
  
  if [ -z "$LOCAL" ] || [ -z "$REMOTE" ]; then
    echo -e "  ${YELLOW}⚠ Cannot determine sync status${NC}"
    ((SKIP_COUNT++))
    echo ""
    continue
  fi
  
  BASE=$(git merge-base @ '@{u}' 2>/dev/null || echo "")
  
  if [ "$LOCAL" = "$REMOTE" ]; then
    echo -e "  ${GREEN}✓ Already up to date${NC}"
    ((SUCCESS_COUNT++))
  elif [ "$LOCAL" = "$BASE" ]; then
    echo -e "  ${BLUE}→ Pulling changes...${NC}"
    if [ "$DRY_RUN" = true ]; then
      echo -e "  ${BLUE}[DRY RUN] Would pull changes${NC}"
      ((SUCCESS_COUNT++))
    else
      if [ "$VERBOSE" = true ]; then
        if git pull --ff-only origin "$WORKFLOWS_BRANCH"; then
          echo -e "  ${GREEN}✓ Updated successfully${NC}"
          ((SUCCESS_COUNT++))
        else
          echo -e "  ${RED}✗ Pull failed (may need manual merge)${NC}"
          ((FAIL_COUNT++))
        fi
      else
        if git pull --ff-only origin "$WORKFLOWS_BRANCH" --quiet 2>/dev/null; then
          echo -e "  ${GREEN}✓ Updated successfully${NC}"
          ((SUCCESS_COUNT++))
        else
          echo -e "  ${RED}✗ Pull failed (may need manual merge)${NC}"
          ((FAIL_COUNT++))
        fi
      fi
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

if [ "$DRY_RUN" = true ]; then
  echo -e "${YELLOW}This was a dry run. No changes were made.${NC}"
  exit 0
fi

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
