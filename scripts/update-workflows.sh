#!/bin/bash
# Helper for maintainers: commit + push changes in the Workflow-Scripts repo.
#
# This script intentionally does NOT touch the parent project repo.
#
# Usage (from Workflow-Scripts repo):
#   ./scripts/update-workflows.sh "docs: clarify workflow instructions"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
COMMIT_MSG="${1:-}"

cd "$REPO_ROOT"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: '$REPO_ROOT' is not a git repository."
    exit 1
fi

if [ -z "$COMMIT_MSG" ]; then
    echo "No commit message provided."
    echo "Review and commit manually:" 
    echo "  cd Workflow-Scripts"
    echo "  git status"
    echo "  git add ."
    echo "  git commit -m 'docs: ...'"
    echo "  git push"
    exit 1
fi

unstaged_paths="$(git diff --name-only)"
untracked_paths="$(git ls-files --others --exclude-standard)"

if [ -n "$unstaged_paths" ] || [ -n "$untracked_paths" ]; then
    echo "Error: you have unstaged or untracked changes. Stage or remove them first."
    if [ -n "$unstaged_paths" ]; then
        echo "Unstaged tracked paths:"
        printf '%s\n' "$unstaged_paths"
    fi
    if [ -n "$untracked_paths" ]; then
        echo "Untracked paths:"
        printf '%s\n' "$untracked_paths"
    fi
    exit 1
fi

if git diff --cached --quiet; then
    echo "Error: no staged changes to commit."
    exit 1
fi

git commit -m "$COMMIT_MSG"
git push
echo "Workflow-Scripts changes pushed."
