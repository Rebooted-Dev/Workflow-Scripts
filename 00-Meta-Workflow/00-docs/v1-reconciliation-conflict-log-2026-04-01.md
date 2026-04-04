# v1 Reconciliation Conflict Log

Date: 2026-04-01
Branch: `reconcile/v1-main-beta-master`
Scope: Merge `origin/beta` and `origin/master` into `main` baseline

## Summary

Two merge conflicts occurred, both in:

- `00-project-setup/01-setup-project.md`

No source-code conflicts were encountered outside this workflow document.

## Conflict 1: merge of `origin/beta`

- **Type:** content conflict
- **Location:** migration guidance around plans/changelog structure
- **Resolution:** kept current v1 taxonomy and guidance used in the `main` line (plans-completed-oriented wording preserved where it conflicted with beta wording that moved all plan handling to `project/changelog/plans/`).
- **Rationale:** reconciliation plan specified preference for current folder taxonomy while consolidating branch history.

## Conflict 2: merge of `origin/master`

- **Type:** content conflict (same sections as above)
- **Location:** `00-project-setup/01-setup-project.md`
- **Resolution:** retained the already-resolved integration version from conflict 1.
- **Rationale:** avoids reintroducing divergent wording from historical branch merges and keeps one consistent v1 convention.

## Follow-up Notes

- If the team decides to standardize exclusively on `project/changelog/plans/` for v1.x, update this file and the setup workflow in a dedicated docs change after release tagging.

