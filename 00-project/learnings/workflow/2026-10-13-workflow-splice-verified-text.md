# Splice verified text into docs instead of retyping it
**Date:** 2026-10-13
**Category:** workflow
**Status:** ACTIVE

---

## Situation
- Retyping the cache status-line script and the learnings templates into new docs risks small drift. Splicing from the source and comparing bytes caught none, and a 57-line template matched line by line.

## Pattern to avoid
- Retyping a verified script or template into a second file by hand.

## Better approach
- Extract the block from the source by a marker (not a line number), write it to the target, re-extract it from the target, and cmp the two. Line numbers move whenever text is inserted above them.

## Verification
- cmp reported byte-identical for the cache script in file 10 and for the learnings README in both repos.

## Notes
- Markers were needed because checkbox insertions moved the plan's line numbers.
