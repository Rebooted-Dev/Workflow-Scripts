#!/bin/bash
# sync-workflow-scripts.sh
# Syncs Workflow-Scripts across all projects
#
# IMPORTANT: Before first use, you MUST either:
#   1. Update the PROJECTS array below with your project paths, OR
#   2. Use the --auto flag to auto-discover projects, OR
#   3. Set WORKFLOW_SYNC_BASE_DIR environment variable, OR
#   4. Set WORKFLOW_SYNC_PROJECTS environment variable
#
# Usage (from Workflow-Scripts repo or PATH):
#   ./Workflow-Scripts/scripts/sync-workflow-scripts.sh              # Sync all projects
#   ./Workflow-Scripts/scripts/sync-workflow-scripts.sh --status     # Check status only
#   ./Workflow-Scripts/scripts/sync-workflow-scripts.sh --dry-run    # See what would happen
#   ./Workflow-Scripts/scripts/sync-workflow-scripts.sh --verbose    # Detailed output
#   ./Workflow-Scripts/scripts/sync-workflow-scripts.sh --auto       # Auto-discover projects
#
# Environment:
#   WORKFLOW_SYNC_BASE_DIR  Override base directory for auto-discovery
#   WORKFLOW_SYNC_PROJECTS  Colon-separated project paths to sync
#   WORKFLOWS_BRANCH        Branch to sync; defaults to this script repo branch
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
WORKFLOWS_REMOTE_HTTPS="https://github.com/Rebooted-Dev/Workflow-Scripts"
WORKFLOWS_REMOTE_SSH="git@github.com:Rebooted-Dev/Workflow-Scripts"
AUTO_DISCOVER_MAX_DEPTH="${WORKFLOW_SYNC_MAX_DEPTH:-3}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SCRIPT_REPO_BRANCH="$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
if [ -z "${WORKFLOWS_BRANCH:-}" ]; then
  if [ -n "$SCRIPT_REPO_BRANCH" ] && [ "$SCRIPT_REPO_BRANCH" != "HEAD" ]; then
    WORKFLOWS_BRANCH="$SCRIPT_REPO_BRANCH"
  else
    WORKFLOWS_BRANCH="main"
  fi
fi
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
# Or set WORKFLOW_SYNC_PROJECTS env var (colon-separated paths)
if [ -n "${WORKFLOW_SYNC_PROJECTS:-}" ]; then
  IFS=':' read -ra PROJECTS <<< "$WORKFLOW_SYNC_PROJECTS"
  for i in "${!PROJECTS[@]}"; do
    if [[ "${PROJECTS[$i]}" != /* ]]; then
      PROJECTS[i]="$(pwd)/${PROJECTS[$i]}"
    fi
  done
else
  PROJECTS=(
    # Add your project paths here, one per line:
    # "/path/to/Project1"
    # "/path/to/Project2"
    # "/path/to/Project3"
  )
fi

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
      echo "  WORKFLOW_SYNC_PROJECTS Colon-separated project paths to sync"
      echo "  WORKFLOWS_BRANCH       Branch to sync (default: script repo branch, fallback: main)"
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
  local project_path
  local project_root
  
  if [ ! -d "$BASE_DIR" ]; then
    echo -e "${RED}Error: Base directory not found: $BASE_DIR${NC}" >&2
    return 1
  fi
  
  # Find all directories containing Workflow-Scripts
  while IFS= read -r -d '' project_path; do
    # Get parent directory (the project root)
    project_root=$(dirname "$project_path")
    found_projects+=("$project_root")
  done < <(find "$BASE_DIR" -maxdepth "$AUTO_DISCOVER_MAX_DEPTH" \
    \( -name .git -o -name node_modules -o -name build -o -name dist -o -name backup -o -name backups \) -prune \
    -o -type d -name "$WORKFLOWS_DIR_NAME" -print0 2>/dev/null)
  
  # Remove duplicates and return
  if [ ${#found_projects[@]} -gt 0 ]; then
    printf '%s\n' "${found_projects[@]}" | sort -u
  fi
}

is_workflows_remote() {
  local remote_url="$1"
  case "$remote_url" in
    "$WORKFLOWS_REMOTE_HTTPS"|"$WORKFLOWS_REMOTE_HTTPS.git"|"$WORKFLOWS_REMOTE_SSH"|"$WORKFLOWS_REMOTE_SSH.git")
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

# Use auto-discovery if requested
if [ "$AUTO_DISCOVER" = true ]; then
  echo -e "${BLUE}Auto-discovering projects in: $BASE_DIR (max depth: $AUTO_DISCOVER_MAX_DEPTH)${NC}"
  PROJECTS=()
  while IFS= read -r project_path; do
    [ -n "$project_path" ] && PROJECTS+=("$project_path")
  done < <(find_projects)
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
  echo "  4. Set WORKFLOW_SYNC_PROJECTS env var (colon-separated project paths)"
  echo ""
  echo "Example:"
  echo "  ./Workflow-Scripts/scripts/sync-workflow-scripts.sh --auto"
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
  echo -e "Branch: ${WORKFLOWS_BRANCH}"
  echo ""
  
  for project_path in "${PROJECTS[@]}"; do
    project_name=$(basename "$project_path")
    workflows_path="${project_path}/${WORKFLOWS_DIR_NAME}"
    
    if [ ! -d "$project_path" ]; then
      echo -e "${RED}✗${NC} $project_name: Project directory not found"
      missing_count=$((missing_count + 1))
      continue
    fi
    
    if [ ! -d "$workflows_path/.git" ]; then
      echo -e "${YELLOW}⊘${NC} $project_name: Workflow-Scripts not found or not a git repo"
      missing_count=$((missing_count + 1))
      continue
    fi
    
    remote_url=$(git -C "$workflows_path" remote get-url origin 2>/dev/null || echo "")
    if ! is_workflows_remote "$remote_url"; then
      echo -e "${RED}✗${NC} $project_name: origin remote does not match Workflow-Scripts ($remote_url)"
      missing_count=$((missing_count + 1))
      continue
    fi
    
    # Fetch quietly
    if [ "$VERBOSE" = true ]; then
      if ! git -C "$workflows_path" fetch origin; then
        echo -e "${RED}✗${NC} $project_name: Fetch failed"
        missing_count=$((missing_count + 1))
        continue
      fi
    else
      if ! git -C "$workflows_path" fetch origin --quiet 2>/dev/null; then
        echo -e "${RED}✗${NC} $project_name: Fetch failed"
        missing_count=$((missing_count + 1))
        continue
      fi
    fi
    
    target_ref="origin/${WORKFLOWS_BRANCH}"
    if ! git -C "$workflows_path" rev-parse --verify "$target_ref" >/dev/null 2>&1; then
      echo -e "${RED}✗${NC} $project_name: Remote branch not found: ${target_ref}"
      missing_count=$((missing_count + 1))
      continue
    fi

    # Check status against the configured sync branch, not a stale upstream.
    LOCAL=$(git -C "$workflows_path" rev-parse @ 2>/dev/null || echo "")
    REMOTE=$(git -C "$workflows_path" rev-parse "$target_ref" 2>/dev/null || echo "")
    
    if [ -z "$LOCAL" ] || [ -z "$REMOTE" ]; then
      echo -e "${YELLOW}⊘${NC} $project_name: Cannot determine status"
      continue
    fi
    
    BASE=$(git -C "$workflows_path" merge-base @ "$target_ref" 2>/dev/null || echo "")
    
    if [ "$LOCAL" = "$REMOTE" ]; then
      echo -e "${GREEN}✓${NC} $project_name: Up to date"
      success_count=$((success_count + 1))
    elif [ "$LOCAL" = "$BASE" ]; then
      behind=$(git -C "$workflows_path" rev-list --count "HEAD..${target_ref}" 2>/dev/null || echo "?")
      echo -e "${YELLOW}⚠${NC} $project_name: Behind by $behind commit(s)"
      behind_count=$((behind_count + 1))
    elif [ "$REMOTE" = "$BASE" ]; then
      ahead=$(git -C "$workflows_path" rev-list --count "${target_ref}..HEAD" 2>/dev/null || echo "?")
      echo -e "${BLUE}→${NC} $project_name: Ahead by $ahead commit(s)"
      ahead_count=$((ahead_count + 1))
    else
      echo -e "${RED}✗${NC} $project_name: Diverged from remote"
      diverged_count=$((diverged_count + 1))
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
echo -e "Branch: ${WORKFLOWS_BRANCH}"
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
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo ""
    continue
  fi
  
  # Check if Workflow-Scripts directory exists
  if [ ! -d "$workflows_path" ]; then
    echo -e "  ${YELLOW}⚠ Workflow-Scripts not found${NC}"
    if [ "$DRY_RUN" = true ]; then
      echo -e "  ${BLUE}[DRY RUN] Would prompt to clone ${WORKFLOWS_BRANCH} (or auto-clone if NON_INTERACTIVE=true)${NC}"
      SKIP_COUNT=$((SKIP_COUNT + 1))
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
        if git -C "$project_path" clone --branch "$WORKFLOWS_BRANCH" "$WORKFLOWS_REMOTE" "$WORKFLOWS_DIR_NAME"; then
          echo -e "  ${GREEN}✓ Cloned successfully${NC}"
          SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        else
          echo -e "  ${RED}✗ Clone failed${NC}"
          FAIL_COUNT=$((FAIL_COUNT + 1))
        fi
      else
        SKIP_COUNT=$((SKIP_COUNT + 1))
      fi
    fi
    echo ""
    continue
  fi
  
  # Check if it's a git repository
  if [ ! -d "$workflows_path/.git" ]; then
    echo -e "  ${RED}✗ Not a git repository${NC}"
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo ""
    continue
  fi
  
  remote_url=$(git -C "$workflows_path" remote get-url origin 2>/dev/null || echo "")
  if ! is_workflows_remote "$remote_url"; then
    echo -e "  ${RED}✗ Origin remote mismatch: ${remote_url}${NC}"
    echo -e "  ${YELLOW}  Expected HTTPS or SSH remote for Rebooted-Dev/Workflow-Scripts${NC}"
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo ""
    continue
  fi
  
  # Check for uncommitted changes
  STASH_CREATED=false
  if [ -n "$(git -C "$workflows_path" status --porcelain)" ]; then
    echo -e "  ${YELLOW}⚠ Uncommitted changes detected${NC}"
    if [ "$DRY_RUN" = true ]; then
      echo -e "  ${BLUE}[DRY RUN] Would stash changes${NC}"
    else
      echo -e "  ${YELLOW}  Stashing changes...${NC}"
      if git -C "$workflows_path" stash push -u -m "Auto-stash before sync $(date +%Y-%m-%d\ %H:%M:%S)" 2>/dev/null; then
        STASH_CREATED=true
      else
        echo -e "  ${RED}✗ Stash failed${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        echo ""
        continue
      fi
    fi
  fi
  
  # Check current branch
  current_branch=$(git -C "$workflows_path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "detached")
  upstream_ref=$(git -C "$workflows_path" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || echo "")
  if [ "$current_branch" == "detached" ] || [ "$current_branch" == "HEAD" ]; then
    echo -e "  ${YELLOW}⚠ Detached HEAD state${NC}"
    if [ "$DRY_RUN" = true ]; then
      echo -e "  ${BLUE}[DRY RUN] Would switch to ${WORKFLOWS_BRANCH} branch${NC}"
    else
      echo -e "  ${YELLOW}  Switching to ${WORKFLOWS_BRANCH} branch...${NC}"
      git -C "$workflows_path" fetch origin 2>/dev/null || true
      git -C "$workflows_path" checkout "$WORKFLOWS_BRANCH" 2>/dev/null || git -C "$workflows_path" checkout -b "$WORKFLOWS_BRANCH" "origin/${WORKFLOWS_BRANCH}" 2>/dev/null || {
        echo -e "  ${RED}✗ Cannot switch to branch${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        echo ""
        continue
      }
      current_branch=$(git -C "$workflows_path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "detached")
      upstream_ref=$(git -C "$workflows_path" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || echo "")
    fi
  fi

  if [ "$current_branch" != "$WORKFLOWS_BRANCH" ]; then
    if [ "$DRY_RUN" = true ]; then
      echo -e "  ${BLUE}[DRY RUN] Would switch from ${current_branch} to ${WORKFLOWS_BRANCH}${NC}"
    else
      echo -e "  ${YELLOW}  Switching from ${current_branch} to ${WORKFLOWS_BRANCH}...${NC}"
      git -C "$workflows_path" checkout "$WORKFLOWS_BRANCH" 2>/dev/null || git -C "$workflows_path" checkout -b "$WORKFLOWS_BRANCH" "origin/${WORKFLOWS_BRANCH}" 2>/dev/null || {
        echo -e "  ${RED}✗ Cannot switch to ${WORKFLOWS_BRANCH}${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        echo ""
        continue
      }
      current_branch=$(git -C "$workflows_path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "detached")
      upstream_ref=$(git -C "$workflows_path" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || echo "")
    fi
  fi

  if [ -n "$upstream_ref" ] && [ "$upstream_ref" != "origin/${WORKFLOWS_BRANCH}" ]; then
    echo -e "  ${YELLOW}⚠ Upstream is ${upstream_ref}, expected origin/${WORKFLOWS_BRANCH}${NC}"
    if [ "$DRY_RUN" = true ]; then
      echo -e "  ${BLUE}[DRY RUN] Would use origin/${WORKFLOWS_BRANCH} and avoid pulling ${upstream_ref}${NC}"
    fi
  fi
  
  # Fetch latest changes
  echo -e "  ${BLUE}→ Fetching latest changes...${NC}"
  if [ "$DRY_RUN" = true ]; then
    echo -e "  ${BLUE}[DRY RUN] Would fetch from origin${NC}"
  else
    if [ "$VERBOSE" = true ]; then
      git -C "$workflows_path" fetch origin || {
        echo -e "  ${RED}✗ Fetch failed${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        echo ""
        continue
      }
    else
      git -C "$workflows_path" fetch origin --quiet 2>/dev/null || {
        echo -e "  ${RED}✗ Fetch failed${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        echo ""
        continue
      }
    fi
  fi
  
  target_ref="origin/${WORKFLOWS_BRANCH}"
  if [ "$DRY_RUN" != true ] && ! git -C "$workflows_path" rev-parse --verify "$target_ref" >/dev/null 2>&1; then
    echo -e "  ${RED}✗ Remote branch not found: ${target_ref}${NC}"
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo ""
    continue
  fi

  # Check if behind against the configured sync branch, not a stale upstream.
  LOCAL=$(git -C "$workflows_path" rev-parse @ 2>/dev/null || echo "")
  REMOTE=$(git -C "$workflows_path" rev-parse "$target_ref" 2>/dev/null || echo "")
  SYNC_READY_FOR_STASH_POP=false
  
  if [ -z "$LOCAL" ] || [ -z "$REMOTE" ]; then
    echo -e "  ${YELLOW}⚠ Cannot determine sync status${NC}"
    SKIP_COUNT=$((SKIP_COUNT + 1))
    echo ""
    continue
  fi
  
  BASE=$(git -C "$workflows_path" merge-base @ "$target_ref" 2>/dev/null || echo "")
  
  if [ "$LOCAL" = "$REMOTE" ]; then
    echo -e "  ${GREEN}✓ Already up to date${NC}"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    SYNC_READY_FOR_STASH_POP=true
  elif [ "$LOCAL" = "$BASE" ]; then
    echo -e "  ${BLUE}→ Pulling changes...${NC}"
    if [ "$DRY_RUN" = true ]; then
      echo -e "  ${BLUE}[DRY RUN] Would pull changes from origin/${WORKFLOWS_BRANCH}${NC}"
      SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
      if [ "$VERBOSE" = true ]; then
        if git -C "$workflows_path" pull --ff-only origin "$WORKFLOWS_BRANCH"; then
          echo -e "  ${GREEN}✓ Updated successfully${NC}"
          SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
          SYNC_READY_FOR_STASH_POP=true
        else
          echo -e "  ${RED}✗ Pull failed (may need manual merge)${NC}"
          FAIL_COUNT=$((FAIL_COUNT + 1))
        fi
      else
        if git -C "$workflows_path" pull --ff-only origin "$WORKFLOWS_BRANCH" --quiet 2>/dev/null; then
          echo -e "  ${GREEN}✓ Updated successfully${NC}"
          SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
          SYNC_READY_FOR_STASH_POP=true
        else
          echo -e "  ${RED}✗ Pull failed (may need manual merge)${NC}"
          FAIL_COUNT=$((FAIL_COUNT + 1))
        fi
      fi
    fi
  elif [ "$REMOTE" = "$BASE" ]; then
    echo -e "  ${YELLOW}⚠ Local commits ahead of remote${NC}"
    echo -e "  ${YELLOW}  Consider pushing your changes${NC}"
    SKIP_COUNT=$((SKIP_COUNT + 1))
  else
    echo -e "  ${YELLOW}⚠ Diverged from remote${NC}"
    echo -e "  ${YELLOW}  Manual merge required${NC}"
    SKIP_COUNT=$((SKIP_COUNT + 1))
  fi

  if [ "$STASH_CREATED" = true ] && [ "$SYNC_READY_FOR_STASH_POP" = true ]; then
    echo -e "  ${YELLOW}  Re-applying stashed changes...${NC}"
    if git -C "$workflows_path" stash pop --quiet; then
      echo -e "  ${GREEN}✓ Stashed changes reapplied${NC}"
    else
      echo -e "  ${RED}✗ Stash pop failed; resolve manually with:${NC}"
      echo -e "  ${YELLOW}  git -C \"${workflows_path}\" stash pop${NC}"
      FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
  elif [ "$STASH_CREATED" = true ]; then
    echo -e "  ${YELLOW}⚠ Stash retained; recover manually with:${NC}"
    echo -e "  ${YELLOW}  git -C \"${workflows_path}\" stash pop${NC}"
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
