---
date: "2026-07-03"
title: "Workflow-Scripts Deep Review Follow-Up Implementation Plan"
category: "review"
status: "✅ COMPLETED"
notes: "Implement the remaining open items from `00-project/plans-completed/review/2026-07-03-workflow-scripts-deep-review-260703-1337-claude.md` in priority order. Work only inside the ne"
---
# Workflow-Scripts Deep Review Follow-Up Implementation Plan

**Status:** ✅ COMPLETED

## Summary

Implement the remaining open items from `00-project/plans-completed/review/2026-07-03-workflow-scripts-deep-review-260703-1337-claude.md` in priority order. Work only inside the nested `Workflow-Scripts/` repo. Preserve the current dirty worktree, and do not touch the parent `Update-AI-Tools` repo.

## Priority 1 - Close FINDING-011: `update-workflows.sh` Safety Contract

- Treat the current script as partially fixed: it already catches untracked files, but the report still flags the lingering `git diff --name-only` pattern.
- Replace the staged-safety logic in `scripts/update-workflows.sh` with one `git status --porcelain` based check that blocks any unstaged tracked or untracked paths before committing.
- Update `scripts/validation/check-update-workflows.sh` to assert:
  - untracked files fail and are named;
  - modified-but-unstaged tracked files fail and are named;
  - staged-only changes still commit and reach mocked push;
  - `scripts/update-workflows.sh` no longer contains `git diff --name-only`.
- Update `scripts/README.md` validation table to include `check-update-workflows.sh`.
- Add a Workflow-Scripts changelog entry under `00-project/changelog/fixed/`.
- Add troubleshooting under `00-project/troubleshooting/git/` because this is a real maintenance-script safety bug.

## Priority 2 - Resolve FINDING-015: Shared Review Workflow Core

- Create `00-Meta-Workflow/00-meta/review-workflow-core.md` as the single source for:
  - metadata-root report routing;
  - rubric-only severity/priority scoring;
  - untrusted-content rule;
  - pre-flight checks;
  - finding fields;
  - evidence quality;
  - deduplication;
  - report outline;
  - acceptance criteria.
- Update these workflows to reference the shared core and keep only their domain-specific purpose, role guidance, finding fields, focus areas, and workflow-specific notes:
  - `05-review/01-code-review.md`
  - `05-review/02-code-optimization.md`
  - `05-review/03-code-refactoring.md`
  - `06-security/01-security-review.md`
- Do not force `04-website-data-refactoring.md` into the shared core unless its current structure makes the edit low-risk; otherwise list it as a follow-up.
- Extend `scripts/validation/check-review-workflow-policy.sh` to require `review-workflow-core.md` links in the four active workflows.
- Add changelog entry under `00-project/changelog/changed/`.

## Priority 3 - Finish FINDING-016: Rubric Is the Only Normative Priority Rule

- Remove the local P0/P1/P2/P3 example bullet lists from:
  - `05-review/02-code-optimization.md`
  - `05-review/03-code-refactoring.md`
  - `06-security/01-security-review.md`
- Replace each with one sentence: "Assign priority only with the shared impact x likelihood rubric; domain examples are non-binding and belong in the shared rubric if needed."
- Update `check-review-workflow-policy.sh` to fail if those three files contain indented local `P0:` / `P1:` / `P2:` / `P3:` scoring lists.
- Keep harmless summary templates like "Total findings: P0/P1/P2/P3" where they are reporting format, not scoring policy.
- Add changelog entry under `00-project/changelog/changed/`.

## Priority 4 - Backlog FINDING-023: Serial Fetch Optimization

- Do not optimize fetches unless a measured baseline proves the sync command is slow enough to matter.
- Add a short backlog note to `00-project/plans/TODO.md`: measure `scripts/sync-workflow-scripts.sh --status` across at least 5 configured projects before parallelizing fetch.
- If later implemented, keep fetch parallelism separate from status rendering and preserve existing `check-sync-workflow-scripts.sh` behavior.
- Changelog only if TODO/docs are changed.

## Test Plan

Run from `Workflow-Scripts/`:

```bash
bash scripts/validation/check-update-workflows.sh
bash scripts/validation/check-active-markdown-links.sh
bash scripts/validation/check-orchestrator-review.sh
bash scripts/validation/check-review-workflow-policy.sh
bash scripts/validation/check-sync-workflow-scripts.sh
git diff --check
```

Acceptance criteria:

- `update-workflows.sh` blocks untracked and unstaged tracked files.
- The four active review workflows link to the shared core.
- No active review workflow has local normative priority-band lists.
- Existing link, orchestrator, review-policy, and sync validators still pass.
- Changelog is updated; troubleshooting is added for the `update-workflows.sh` safety fix.

## Assumptions

- The accepted `- [✅]` checkbox convention remains unchanged.
- The deep-review workflow promotion task in `00-project/plans/TODO.md` is separate from this remediation plan.
- Existing uncommitted docs/report changes in `Workflow-Scripts/` are user-owned context and must be preserved.

## Execution Status

- [✅] Priority 1 - Close FINDING-011: `update-workflows.sh` Safety Contract
- [✅] Priority 2 - Resolve FINDING-015: Shared Review Workflow Core
- [✅] Priority 3 - Finish FINDING-016: Rubric Is the Only Normative Priority Rule
- [✅] Priority 4 - Backlog FINDING-023: Serial Fetch Optimization

## Verification Addendum

**Timestamp:** 2026-07-03 22:49 +08

### Commands run

```bash
bash scripts/validation/check-update-workflows.sh
bash scripts/validation/check-active-markdown-links.sh
bash scripts/validation/check-orchestrator-review.sh
bash scripts/validation/check-review-workflow-policy.sh
bash scripts/validation/check-sync-workflow-scripts.sh
git diff --check
```

### Results

- `check-update-workflows.sh` passed and covers untracked-file failure, modified tracked-file failure, staged-only commit success through mocked push, and the removed `git diff --name-only` pattern.
- Active Markdown links, orchestrator review policy, review workflow policy, sync workflow behavior, and whitespace checks passed.
- `scripts/update-workflows.sh` now uses `git status --porcelain` for the dirty-tree guard.
- The four active review workflows reference `00-Meta-Workflow/00-meta/review-workflow-core.md`.
- Local normative indented `P0:` / `P1:` / `P2:` / `P3:` priority-band lists were removed from the optimization, refactoring, and security review workflows; summary/reporting uses remain allowed.
- Changelog entries were added under `00-project/changelog/fixed/` and `00-project/changelog/changed/`; troubleshooting was added under `00-project/troubleshooting/git/`.
- `00-project/plans/TODO.md` contains the measured-baseline backlog note for serial fetch optimization.
- Parallel verification identified one validator gap: staged-only changes committed, but the test did not assert the mocked push output. `scripts/validation/check-update-workflows.sh` now asserts `mock git push`, and the full validation command set passed again after that correction.

### Misreporting or mismatches

One validator coverage gap was found and fixed during confirm-execution audit. No incomplete plan items remain.

### Next steps

None for this plan.
