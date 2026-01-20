#!/bin/bash
# Helper for maintainers: commit + push changes in the workflows repo.
#
# This script intentionally does NOT touch the parent project repo.
#
# Usage:
#   ./workflows/update-workflows.sh "docs: clarify workflow instructions"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMIT_MSG="${1:-}"

cd "$SCRIPT_DIR"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: '$SCRIPT_DIR' is not a git repository."
    exit 1
fi

if [ -z "$COMMIT_MSG" ]; then
    echo "No commit message provided."
    echo "Review and commit manually:" 
    echo "  cd workflows"
    echo "  git status"
    echo "  git add ."
    echo "  git commit -m 'docs: ...'"
    echo "  git push"
    exit 1
fi

if [ -n "$(git diff --name-only)" ]; then
    echo "Error: you have unstaged changes. Stage them first (git add ...)."
    exit 1
fi

if git diff --cached --quiet; then
    echo "Error: no staged changes to commit."
    exit 1
fi

git commit -m "$COMMIT_MSG"
git push
echo "Workflows changes pushed."
