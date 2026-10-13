# Leave untracked drafts you did not write out of commits
**Date:** 2026-10-13
**Category:** workflow
**Status:** ACTIVE

---

## Situation
- 00-project/plans/agents-patches/ appeared untracked during the session. It held a template with an Example entry (delete me) placeholder, and this session did not create it.

## Pattern to avoid
- Staging the whole directory because the request said stage the repo.

## Better approach
- Stage the explicit list of files you changed, leave the rest untracked, and say which files were left out and why.

## Verification
- The cache setup commit (e325235) left the draft out, and it stayed untracked afterwards.

## Notes
- The developer was asked what to do with the draft; it is still untracked.
