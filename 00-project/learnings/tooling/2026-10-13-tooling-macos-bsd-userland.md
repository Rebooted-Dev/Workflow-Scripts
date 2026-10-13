# macOS uses BSD userland, so GNU flags fail
**Date:** 2026-10-13
**Category:** tooling
**Status:** ACTIVE

---

## Situation
- ls --time-style and cat -A both failed on this machine with illegal option errors.

## Pattern to avoid
- Using GNU-only flags from a Linux example.

## Better approach
- Use stat -f for timestamps, od -c for raw bytes, and sed -i '' for in-place edits. Check a command's flags before a long script depends on them.

## Verification
- The failing flags were seen in the session. stat -f, od -c, and sed -i '' worked.

## Notes
- Other GNU-only options may fail the same way; test them first.
