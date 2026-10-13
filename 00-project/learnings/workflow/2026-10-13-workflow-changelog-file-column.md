# In a changelog index, the File column names the entry
**Date:** 2026-10-13
**Category:** workflow
**Status:** NOTED
**Source:** command: link checker run after the correction

---

## Situation
- The proposal's changelog row first put the proposal's path in the File column. A changelog row's File points at the changelog entry, so the proposal's path belongs in Notes.

## Pattern to avoid
- Using File for an artifact that is not a changelog entry.

## Better approach
- File: docs/<entry>.md. Notes: Filed plans/agents-patches/<name>.md.

## Verification
- The link checker passes after the correction.

## Notes
- Same rule for any index: the File column is the path of the entry the index lists.
