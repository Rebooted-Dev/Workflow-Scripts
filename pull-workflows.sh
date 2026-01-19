#!/bin/bash
# Pull latest workflows from remote
# Usage: ./pull-workflows.sh [commit-message]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

COMMIT_MSG="${1:-Update workflows to latest version}"

echo "Pulling latest workflows..."

cd "$SCRIPT_DIR"

if [ -f .git ]; then
    # It's a submodule
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
    git checkout "$CURRENT_BRANCH" 2>/dev/null || git checkout main || git checkout master
    git pull origin "$CURRENT_BRANCH" 2>/dev/null || git pull origin main || git pull origin master
    cd "$PROJECT_ROOT"
    git add workflows
    echo ""
    echo "Workflows pulled successfully."
    echo "Review changes with: git diff --cached"
    echo "Commit with: git commit -m '$COMMIT_MSG'"
    echo "Or auto-commit: git commit -m '$COMMIT_MSG' && git push"
else
    echo "Not a submodule. Use 'git pull' to update."
    git pull
fi
