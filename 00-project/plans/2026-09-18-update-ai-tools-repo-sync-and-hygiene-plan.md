# 2026-09-18

# Update-AI-Tools Repo Sync, Relocation Docs, and Git Hygiene Plan

**Status:** Active (ready to execute)
**Priority:** P1  **Severity:** S2
**Workflow:** `02-code-build/03-execute-and-confirm.md` (execute → confirm → terminal gate)
**Rationale:** The Update-AI-Tools main repo carries an OPEN troubleshooting issue (`environment/2026-08-22-environment-workflow-scripts-relocated.md`) documenting that the Workflow-Scripts companion moved under `Shared-Links/` while `AGENTS.md` and `docs/agents/repository-map.md` still describe the old root-level `Workflow-Scripts/` path and `main` branch. Additionally, two stale local branches have deleted remotes and three July-2026 stashes are unreviewed. Documentation drift plus unreviewed git state is a medium-impact, likely-path failure with workarounds, so S2/P1.
**Current evidence (2026-09-18):**
- `Shared-Links` (symlink → `/Users/jessesng/Development Projects/Shared-Common-Library/Shared-Links`) added to main repo `.gitignore` (commit `7ec3a2f`), which completes half of Option A from the OPEN issue.
- Live companion checkout: `Shared-Links/Workflow-Scripts`, remote `https://github.com/Rebooted-Dev/Workflow-Scripts.git`, branch `v1.72`, clean, in sync with `origin/v1.72` after pull on 2026-09-18.
- `AGENTS.md` still states main repo location `/Users/jesse/Development/Personal/Update-AI-Tools` (actual: `/Volumes/Skynet/Software Development Projects/Personal/update-ai-tools`) and companion at `Workflow-Scripts/` on `main` branch.
- `docs/agents/repository-map.md` has the same stale path/branch references (lines 8, 13, 18, 20, 24).
- Stale branches: `reog` (24537dc), `reorg` (de24cd8) — upstreams deleted (`[origin/reog: gone]`, `[origin/reorg: gone]`).
- Stashes: `stash@{0}` auto-stash 2026-07-10 (23 files), `stash@{1}` WIP on reorg (12 files), `stash@{2}` backup before clean reset (5 files) — all predate the 2026-09-18 sync; content vs current `main` unverified.

## Bounded scope and change inventory

Repositories touched:
- **Update-AI-Tools main repo** (`/Volumes/Skynet/Software Development Projects/Personal/update-ai-tools`): `AGENTS.md`, `docs/agents/repository-map.md`, `project/troubleshooting/environment/2026-08-22-environment-workflow-scripts-relocated.md`, `project/troubleshooting/index.md`, `project/changelog/<type>/` + `project/changelog/index.md`; git branch/stash deletion.
- **Workflow-Scripts companion** (`Shared-Links/Workflow-Scripts`): this plan file, its completion markers, and archive at the terminal gate.

Out of scope (owner decision required, do not act):
- Deleting any duplicate Workflow-Scripts checkouts (`Shared-Common-Library/Workflow-Scripts` direct copy, `Personal/Workflow-Scripts` beta copy, per-project umbrella copies). This plan only documents the canonical path.
- Changing application code, scripts, or tests in either repo.
- Deleting `reog`/`reorg` if their commits turn out to be unmerged and unsuperseded (flag instead).

## Phase 1 — P1/S2: Correct relocation docs in the main repo

**Tasks:**

1. `AGENTS.md`: correct main repo **Location** to `/Volumes/Skynet/Software Development Projects/Personal/update-ai-tools` (Small).
2. `AGENTS.md`: rewrite companion-repo location lines to `Shared-Links/Workflow-Scripts` (symlink → `/Users/jessesng/Development Projects/Shared-Common-Library/Shared-Links/Workflow-Scripts`), branch `v1.72`; update the `cd Workflow-Scripts` snippets and the tracked-repositories row accordingly (Small; dependency: task 1 for consistent wording).
3. `docs/agents/repository-map.md`: fix the repository table row (path `Shared-Links/Workflow-Scripts`, branch `v1.72`), the primary **Path** line, companion path/sync lines, and the ignore-rule note (`Shared-Links` is the gitignored entry, not `Workflow-Scripts/`) (Small; dependency: task 2).
4. `docs/agents/repository-map.md` + `AGENTS.md`: state the canonical-checkout rule and that duplicates exist but are not tracked by the main repo (Small; dependency: task 3).

**Exit criteria (map to Verification Bar):**
- `grep -n "Users/jesse/Development/Personal/Update-AI-Tools" AGENTS.md docs/agents/repository-map.md` returns no hits (grep evidence).
- Every `cd Workflow-Scripts`-style instruction in the two files resolves to the symlinked path from the project root (grep + `cd` smoke test).
- No verify/test command applies to docs-only edits (stated explicitly); static hygiene = `git diff` review shows only intended files.

## Phase 2 — P1/S2: Close the OPEN relocation troubleshooting entry

**Tasks:**

1. Update `project/troubleshooting/environment/2026-08-22-environment-workflow-scripts-relocated.md`: `Status: OPEN` → `RESOLVED`, append a **Resolution** section recording Option A completion (gitignore entry commit `7ec3a2f` on 2026-09-18; docs corrected in Phase 1) and the canonical-path decision (Small; dependency: Phase 1).
2. Update the matching row in `project/troubleshooting/index.md` from `OPEN` to `RESOLVED` (Small; dependency: task 1).

**Exit criteria:**
- Entry file shows `Status: RESOLVED` with a dated Resolution section; index row matches (grep evidence).
- No other troubleshooting index row references the relocation as open (grep evidence).

## Phase 3 — P1/S3: Git hygiene (stale branches and stashes)

**Tasks:**

1. Branch `reog` (24537dc): verify merged-or-superseded via `git merge-base --is-ancestor 24537dc main` and, if unmerged, `git log main --oneline --grep=<subject fragments>` / patch comparison. Delete only if merged or content demonstrably present in `main`; otherwise flag for owner decision (Small).
2. Branch `reorg` (de24cd8): same verification-and-delete rule as task 1 (Small; dependency: task 1 method).
3. Stashes: for each of `stash@{0..2}`, run `git stash show -p` and compare against current `main` (files exist, changes already present, or obsolete against current script versions). Drop superseded stashes with evidence; keep/flag any stash containing unique unmerged work (Medium; dependency: none).

**Exit criteria:**
- `git branch -vv` shows no `[origin/*: gone]` entries, or any survivor carries an explicit owner-decision flag in the plan addendum (command evidence).
- `git stash list` is empty, or each surviving stash is justified in the addendum with what unique content it holds (command evidence).
- Static hygiene: `git status` shows only intended staged/untracked files; nothing destructive done without evidence recorded here.

## Phase 4 — Log reconciliation, commits, and push

**Tasks:**

1. Main repo changelog: add `project/changelog/docs/2026-09-18-docs-repo-sync-relocation-hygiene.md` (covering Phases 1–3) + top row in `project/changelog/index.md` (Small; dependency: Phases 1–3).
2. Main repo: review full `git diff`, commit, push to `origin/main`; confirm `git status -sb` clean and in sync (Small; dependency: task 1).
3. Workflow-Scripts companion: commit this plan file (filing); at the terminal gate, archive it per host policy with `plans-completed/` index + changelog Type=plan row, then push (Small; dependency: gate).

**Exit criteria:**
- Changelog entry + index row exist and match the actual diff (read-back evidence).
- `git push` succeeds; `main...origin/main` shows 0/0 for the main repo and the companion (command evidence).
- No secrets or unintended files in either diff (`git diff --stat` review).

## Risks and mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Stash contains unique unmerged work | Medium | Medium | Compare patch against `main` before dropping; keep + flag rather than delete |
| `reog`/`reorg` hold unmerged commits | Medium | Medium | Ancestor/content check before delete; flag for owner if unmerged |
| Other docs reference the old companion path beyond the two target files | Low | Low | Repo-wide grep for `cd Workflow-Scripts` / `Workflow-Scripts/` in `docs/` and root `*.md`; fix strays in the same phase |
| Workflow-Scripts pull brings conflicting conventions mid-execution | Low | Low | Companion already pulled to `origin/v1.72` before filing; re-fetch before gate commits |

## Acceptance criteria

- [ ] `AGENTS.md` and `docs/agents/repository-map.md` document the real main-repo path, the `Shared-Links/Workflow-Scripts` companion location, and the `v1.72` branch — verified by grep showing zero stale references.
- [ ] Troubleshooting entry `2026-08-22-environment-workflow-scripts-relocated.md` is `RESOLVED` with a dated Resolution section, and its index row says `RESOLVED`.
- [ ] Stale branches `reog`/`reorg` are deleted **or** flagged with evidence that they hold unique work.
- [ ] All three July stashes are dropped **or** each survivor is justified with its unique content.
- [ ] Main repo changelog entry + index row exist; both repos committed and pushed; `git status -sb` clean and 0/0 vs origin for main, companion branch `v1.72` in sync.
- [ ] Verification addendum records commands, grep evidence, and any flagged residual risk.
