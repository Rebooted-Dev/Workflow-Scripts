# Write private files back with cat, not mv, to keep their mode
**Date:** 2026-10-13
**Category:** tooling
**Status:** NOTED
**Source:** command: stat check after a cat write-back; mode stayed -rw-------

---

## Situation
- ~/.claude/settings.json is mode 0600. A jq rewrite went to a temp file, then back over the original.

## Pattern to avoid
- mv temp file over the original: mv replaces the target's mode with the temp file's mode.

## Better approach
- jq ... > tmp && jq empty tmp && cat tmp > settings.json, then rm tmp.

## Verification
- The mode stayed -rw------- after the cat write, while the temp file was 0644. mv was not tested.

## Notes
- Backup taken first; the diff against the backup showed only the statusLine key changed.
