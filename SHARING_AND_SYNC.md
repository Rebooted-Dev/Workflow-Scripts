# Sharing and Syncing Workflows Across Projects

## Overview

This document explains how to share and sync the `workflows/` directory across multiple projects while maintaining the ability to update workflows from any project.

## Recommended Approach: Git Submodule

**Why Git Submodules?**
- ✅ Version controlled workflows
- ✅ Can update from any project
- ✅ Can pin different versions per project if needed
- ✅ Works with GitHub
- ✅ Selective updates (update only when you want)
- ✅ Each project maintains its own copy

## Setup Options

### Option A: Workflows as Separate Repository (Recommended)

Create a dedicated repository for workflows (e.g., `info-visualizer-workflows`) and include it as a submodule in each project.

#### Initial Setup

1. **Create workflows repository:**
   ```bash
   # Create new repo on GitHub: info-visualizer-workflows
   # Clone it locally
   git clone https://github.com/yourusername/info-visualizer-workflows.git
   cd info-visualizer-workflows
   
   # Copy your workflows directory content
   cp -r /path/to/current-project/workflows/* .
   git add .
   git commit -m "Initial workflows"
   git push origin main
   ```

2. **Add as submodule to each project:**
   ```bash
   cd /path/to/project-a
   git submodule add https://github.com/yourusername/info-visualizer-workflows.git workflows
   git commit -m "Add workflows as submodule"
   git push
   ```

3. **Repeat for other projects:**
   ```bash
   cd /path/to/project-b
   git submodule add https://github.com/yourusername/info-visualizer-workflows.git workflows
   git commit -m "Add workflows as submodule"
   git push
   ```

#### Updating Workflows from Any Project

**When you're working in Project A and want to update workflows:**

1. **Update the workflows submodule:**
   ```bash
   cd /path/to/project-a/workflows
   git checkout main  # or your default branch
   git pull origin main
   cd ..
   git add workflows
   git commit -m "Update workflows to latest version"
   git push
   ```

2. **Or use the helper script (see below)**

#### Pulling Workflow Updates in Other Projects

**When you want to get the latest workflows in Project B:**

```bash
cd /path/to/project-b
git pull
git submodule update --remote workflows
# Or to update to specific commit:
cd workflows
git pull origin main
cd ..
git add workflows
git commit -m "Update workflows"
```

### Option B: Workflows in Current Project, Share via Submodule

If you want to keep workflows in your current project and share them:

1. **In the current project (Info-Visualizer):**
   ```bash
   # Workflows already exist here
   # Just ensure it's committed and pushed
   git add workflows/
   git commit -m "Add workflows"
   git push
   ```

2. **In other projects, add as submodule:**
   ```bash
   cd /path/to/other-project
   git submodule add https://github.com/yourusername/Info-Visualizer.git temp-clone
   git mv temp-clone/workflows workflows
   git rm -r temp-clone
   git commit -m "Add workflows submodule from Info-Visualizer"
   ```

   **Note:** This points to the workflows directory in your main project. Updates in the main project will be available to other projects.

## Helper Scripts

### Update Workflows Script

Create a script to make updating workflows easier:

**File: `workflows/update-workflows.sh`**
```bash
#!/bin/bash
# Update workflows submodule and commit the update

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Updating workflows..."

# Navigate to workflows directory
cd "$SCRIPT_DIR"

# Check if we're in a submodule
if [ -f .git ]; then
    echo "Detected submodule. Updating from remote..."
    git checkout main || git checkout master
    git pull origin main || git pull origin master
    cd "$PROJECT_ROOT"
    git add workflows
    echo "Workflows updated. Commit with: git commit -m 'Update workflows'"
else
    echo "Not a submodule. This is the source repository."
    echo "To update other projects, push changes and run 'git submodule update --remote' in those projects."
fi
```

**Make it executable:**
```bash
chmod +x workflows/update-workflows.sh
```

### Pull Workflows Script

For pulling updates in projects that use workflows:

**File: `workflows/pull-workflows.sh`**
```bash
#!/bin/bash
# Pull latest workflows from remote

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Pulling latest workflows..."

cd "$SCRIPT_DIR"

if [ -f .git ]; then
    # It's a submodule
    git checkout main || git checkout master
    git pull origin main || git pull origin master
    cd "$PROJECT_ROOT"
    git add workflows
    echo "Workflows pulled. Review changes and commit with: git commit -m 'Update workflows'"
else
    echo "Not a submodule. Use 'git pull' to update."
fi
```

## Workflow: Updating Workflows from Any Project

### Scenario: You're working in Project A and want to update a workflow

1. **Edit the workflow file:**
   ```bash
   cd /path/to/project-a/workflows
   # Edit the file you want to update
   vim 05-review-audit/03-code-review.md
   ```

2. **Commit to workflows submodule:**
   ```bash
   cd /path/to/project-a/workflows
   git add 05-review-audit/03-code-review.md
   git commit -m "Update code-review workflow: add parallel file reading"
   git push origin main
   ```

3. **Update the parent project reference:**
   ```bash
   cd /path/to/project-a
   git add workflows
   git commit -m "Update workflows: improved code-review"
   git push
   ```

4. **In other projects, pull the update:**
   ```bash
   cd /path/to/project-b
   git pull  # Gets the updated submodule reference
   git submodule update --remote workflows
   # Or use the pull script:
   ./workflows/pull-workflows.sh
   ```

## Alternative: Symlink Approach (Not Recommended for Git)

If you prefer symlinks (simpler but less git-friendly):

### Setup

1. **Create central workflows location:**
   ```bash
   mkdir -p ~/shared-workflows
   cp -r /path/to/current-project/workflows ~/shared-workflows/
   ```

2. **Create symlinks in each project:**
   ```bash
   cd /path/to/project-a
   rm -rf workflows  # Remove existing
   ln -s ~/shared-workflows/workflows workflows
   
   cd /path/to/project-b
   rm -rf workflows
   ln -s ~/shared-workflows/workflows workflows
   ```

**Limitations:**
- ❌ Symlinks don't work well with git (git will track the symlink, not the content)
- ❌ Not portable across different machines
- ❌ Requires central location setup
- ❌ Harder to version control

**Better alternative:** Use git submodules (Option A above).

## Alternative: Git Subtree (Self-Contained)

If you want workflows to be part of each project's history:

```bash
# In the workflows repository
git subtree push --prefix=workflows origin workflows-branch

# In each project
git subtree add --prefix=workflows https://github.com/yourusername/info-visualizer-workflows.git workflows-branch --squash

# To update:
git subtree pull --prefix=workflows https://github.com/yourusername/info-visualizer-workflows.git workflows-branch --squash
```

**Pros:** Self-contained, no submodule complexity  
**Cons:** More complex update commands, merges workflows into project history

## Recommended Workflow for Your Use Case

Given your requirements:
- ✅ Update from any project
- ✅ Selective sharing
- ✅ Work in progress
- ✅ Don't want to switch projects

**I recommend: Git Submodule (Option A)**

### Quick Reference

**Update workflows (from any project):**
```bash
cd workflows
git add .
git commit -m "Update workflow: [description]"
git push origin main
cd ..
git add workflows
git commit -m "Update workflows reference"
git push
```

**Pull latest workflows (in other projects):**
```bash
git submodule update --remote workflows
# Or
cd workflows && git pull && cd ..
git add workflows && git commit -m "Update workflows"
```

## GitHub Setup

1. **Create workflows repository on GitHub:**
   - Go to GitHub
   - Create new repository: `info-visualizer-workflows`
   - Make it public or private (your choice)

2. **Push workflows:**
   ```bash
   cd workflows
   git remote add origin https://github.com/yourusername/info-visualizer-workflows.git
   git push -u origin main
   ```

3. **Add to projects as submodule:**
   ```bash
   git submodule add https://github.com/yourusername/info-visualizer-workflows.git workflows
   ```

## Troubleshooting

### Submodule shows as modified but you didn't change anything
```bash
cd workflows
git status  # Check what changed
# If it's just the commit reference, that's normal after pulling
```

### Want to update to specific version
```bash
cd workflows
git checkout <commit-hash>
cd ..
git add workflows
git commit -m "Pin workflows to specific version"
```

### Remove submodule (if needed)
```bash
git submodule deinit workflows
git rm workflows
rm -rf .git/modules/workflows
```

## Best Practices

1. **Always commit submodule updates** in the parent project after updating workflows
2. **Use descriptive commit messages** when updating workflows
3. **Tag workflow versions** for important releases:
   ```bash
   cd workflows
   git tag v1.0.0
   git push origin v1.0.0
   ```
4. **Document breaking changes** in workflow files or CHANGELOG
5. **Test workflow updates** in one project before pushing to all

## Summary

**For your use case, use Git Submodules:**
- Create separate `info-visualizer-workflows` repository
- Add as submodule to each project
- Update from any project by committing to workflows submodule
- Pull updates in other projects with `git submodule update --remote`

This gives you version control, selective updates, and the ability to work from any project.
