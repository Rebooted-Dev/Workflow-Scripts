# A project's statusLine replaces the user-level one
**Date:** 2026-10-13
**Category:** facts
**Status:** ACTIVE

---

## Situation
- statusLine is an object. A project's copy replaces the whole user-level block, including refreshInterval and the script, rather than merging with it.

## Pattern to avoid
- Assuming the user-level status line applies in every project.

## Better approach
- Scan each project's settings with jq -e has statusLine. Report overrides, and change them only with a yes.

## Verification
- Scanned ~/Development on 2026-10-13: no overrides found. The precedence rule is from the Claude Code settings docs, quoted in file 10, section 13; not re-checked live.

## Notes
- Setup doc Step 2.13 and file 10 Step 6 cover the check; [cache doc](../../changelog/changed/2026-10-13-changed-claude-cache-statusline-plan.md) records the install.
