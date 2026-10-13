# Heading anchors drop punctuation, so Step 2.13 becomes step-213
**Date:** 2026-10-13
**Category:** tooling
**Status:** ACTIVE

---

## Situation
- The table-of-contents links in file 10 and the Step 2.13 link in file 01 were written by hand and had to match the heading slugs.

## Pattern to avoid
- Writing an anchor by guessing its slug.

## Better approach
- Generate slugs with tr and sed, then check each link target against them with grep -x.

## Verification
- All 15 TOC anchors in file 10 matched after the check, and the file 01 anchor matched its heading.

## Notes
- Example: Step 2.13: Claude Code cache status line gives step-213-claude-code-cache-status-line-optional-once-per-machine.
