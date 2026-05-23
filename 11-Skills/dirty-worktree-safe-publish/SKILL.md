---
name: dirty-worktree-safe-publish
description: Safely commit and push intended changes from a mixed or dirty worktree. Use when the user asks to push updates, commit current work, publish a fix, or handle git status with unrelated local changes, nested repositories, ignored generated files, or possible index.lock issues.
---

# Dirty Worktree Safe Publish

Use this skill to publish only the intended work without disturbing unrelated changes.

## Workflow

1. Map repository boundaries.
   - Confirm the repo root with `git rev-parse --show-toplevel`.
   - Detect nested repositories such as `Workflow-Scripts/` and manage them independently.
   - Check branch and remote before committing.

2. Inspect dirty state.
   - Run `git status --short`.
   - Classify changes as intended, unrelated user work, generated artifacts, ignored runtime output, or nested-repo changes.
   - If a touched file contains unrelated edits, inspect the diff carefully before staging.

3. Verify publish scope.
   - Run the relevant tests/builds for the intended change when feasible.
   - Stage files explicitly with file-scoped `git add` commands.
   - Review `git diff --cached --stat` and `git diff --cached` before committing.

4. Commit and push.
   - Use a clear commit message that matches the changed repo.
   - Push the current branch to the expected remote.
   - Report commit hash and push target.

5. Handle git blockers.
   - If `.git/index.lock` appears, verify no git process is active before removing it.
   - Do not use broad cleanup or destructive commands unless the user explicitly approves.
   - After resolving a blocker, rerun the same narrow staging flow.

## Guardrails

- Never stage with `git add .` in a mixed worktree unless the user explicitly asked to include everything and the diff was reviewed.
- Never commit nested-repo changes from the parent repo.
- Never revert unrelated changes to make the worktree look clean.
