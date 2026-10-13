# The cache line has not been confirmed in a live session
**Date:** 2026-10-13
**Category:** facts
**Status:** NOTED
**Source:** command: sample-input tests of the cache line; no live session

---

## Situation
- The cache segment was tested by piping sample JSON through the script, and the statusLine command was checked when run through sh -c. A live session has not been checked.

## Pattern to avoid
- Reporting the cache line as working in Claude Code before a new session shows it.

## Better approach
- Say verified with sample input until a new session confirms line 2.

## Verification
- Sample-input tests only. The live check is still open with the developer.

## Notes
- 00-project/plans/claude-cache.md, Task 7 (open, pending).
