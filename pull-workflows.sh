#!/bin/bash
# Pull the latest Workflow-Scripts updates into this project.
#
# This assumes `workflows/` is a nested git repository managed independently
# from the main project repo.
#
# Usage:
#   ./workflows/pull-workflows.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Pulling latest workflows..."

cd "$SCRIPT_DIR"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: '$SCRIPT_DIR' is not a git repository."
    echo "Expected workflows to be cloned into ./workflows."
    exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
    echo "Error: workflows repo has uncommitted changes."
    echo "Commit/stash them before pulling updates."
    exit 1
fi

CURRENT_BRANCH="$(git symbolic-ref --quiet --short HEAD || true)"
if [ -z "$CURRENT_BRANCH" ]; then
    echo "Note: workflows repo is in detached HEAD; fetching without switching branches."
    git fetch --all --prune
    echo "To get updates, switch to a branch first (e.g., 'git switch main')."
    exit 0
fi

git pull --ff-only
echo "Workflows updated (branch: $CURRENT_BRANCH)."
