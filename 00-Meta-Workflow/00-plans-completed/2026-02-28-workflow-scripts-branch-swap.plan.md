---
name: Workflow-Scripts branch swap
overview: Promote current beta to main, preserve old main as a deprecated branch, and create a fresh beta for ongoing work. This requires a force-push of main on the remote.
todos: []
isProject: false
---

# Workflow-Scripts: Promote beta to main, deprecate old main, new beta for updates

## Goal

- **main** = current `beta` content (latest docs, 06-skills-setup, 00-docs, no 09-skills symlinks).
- **Old main** = preserved as a separate branch named for deprecation (e.g. `1.0-deprecated`).
- **beta** = new branch from the new `main`; all future local updates go to `beta`.

## Important caveats

- **Force-push:** Making `main` point to `beta`'s commit requires rewriting remote `main`. Anyone who has cloned the repo and has `main` checked out will see history change; they should re-sync or re-clone.
- **Branch name:** Git allows spaces, but a name like `1.0-deprecated` or `deprecated/1.0` is easier to use on the command line and in CI. The plan below uses `1.0-deprecated`; you can rename to `1.0 Deprecated` when creating the branch if you prefer.

## Repo context

- **Repo:** [Workflow-Scripts](https://github.com/Rebooted-Dev/Workflow-Scripts) (nested under Info-Visualizer).
- **Current state:** Local `beta` is at `12d9569` (recent push). Local `main` is behind (e.g. `27f2837` / `b520d65`). Remote `origin/main` and `origin/beta` exist.

## Steps (run from `Workflow-Scripts/`)

### 1. Fetch and ensure local is up to date

```bash
cd Workflow-Scripts
git fetch origin
git checkout beta
git pull origin beta
```

### 2. Create branch that preserves old main (deprecated)

Create a branch from current remote `main` so its history is kept:

```bash
git branch 1.0-deprecated origin/main
```

Optional: if you want the branch name with a space, use `git branch "1.0 Deprecated" origin/main` (quoting required in shells).

### 3. Make local main match beta

```bash
git checkout main
git reset --hard beta
```

Now local `main` points to the same commit as `beta` (e.g. `12d9569`).

### 4. Push the deprecated branch

```bash
git push -u origin 1.0-deprecated
```

(Use `"1.0 Deprecated"` if you created the branch with that name.)

### 5. Force-push the new main (destructive on remote)

```bash
git push origin main --force
```

**Warning:** This rewrites `origin/main`. Notify collaborators; they may need to run `git fetch origin && git reset --hard origin/main` on their local `main`, or re-clone.

### 6. Create new beta from current main and push

```bash
git checkout -b beta
git push -u origin beta
```

At this point `main` and `beta` point to the same commit. Future work: commit and push on `beta`; when you want to "release," merge `beta` into `main` (or make `main` the branch you force-update from `beta` periodically).

### 7. (Optional) Set GitHub default branch

If you want new PRs to target `beta` by default, in GitHub: **Settings → General → Default branch** and switch to `beta`. Otherwise leave default as `main` so the default view is the new "stable" content.

## Resulting layout


| Branch           | Content / role                                        |
| ---------------- | ----------------------------------------------------- |
| `main`           | Current beta content (new "stable"); default view.    |
| `1.0-deprecated` | Old main preserved for reference.                     |
| `beta`           | Branch for new updates; merge into `main` when ready. |


## Summary

Yes, this is possible. The sequence is: preserve old main as `1.0-deprecated`, reset local `main` to `beta`, force-push `main`, then create and push a new `beta` from `main`. The only destructive step is the force-push of `main`; the rest is branch creation and normal pushes.
