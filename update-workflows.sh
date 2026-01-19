#!/bin/bash
# Update workflows submodule and commit the update
# Usage: ./update-workflows.sh [commit-message]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

COMMIT_MSG="${1:-Update workflows}"

echo "Updating workflows..."

# Navigate to workflows directory
cd "$SCRIPT_DIR"

# Check if we're in a submodule
if [ -f .git ]; then
    echo "Detected submodule. Updating from remote..."
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
    git checkout "$CURRENT_BRANCH" 2>/dev/null || git checkout main || git checkout master
    git pull origin "$CURRENT_BRANCH" 2>/dev/null || git pull origin main || git pull origin master
    cd "$PROJECT_ROOT"
    git add workflows
    echo "Workflows updated. Commit with: git commit -m '$COMMIT_MSG'"
    echo "Or run: git commit -m '$COMMIT_MSG' && git push"
else
    echo "Not a submodule. This is the source repository."
    echo "To update other projects, push changes and run 'git submodule update --remote' in those projects."
    
    # Check if there are uncommitted changes
    if [ -n "$(git status --porcelain)" ]; then
        echo ""
        echo "You have uncommitted changes. Commit them first:"
        echo "  git add ."
        echo "  git commit -m 'Your message'"
        echo "  git push"
    fi
fi
