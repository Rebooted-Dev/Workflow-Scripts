# Write temporary files to the session scratchpad
**Date:** 2026-10-13
**Category:** workflow
**Status:** NOTED
**Source:** command: rm -f of a stray /tmp file; later checks used scratchpad paths

---

## Situation
- While checking anchors I wrote a scratch file to /tmp, which the environment rules forbid.

## Pattern to avoid
- Using /tmp out of habit for intermediate output.

## Better approach
- Use the scratchpad path from the environment section for every intermediate file.

## Verification
- The stray file was removed (rm -f /tmp/x). Later checks used scratchpad paths.

## Notes
- Environment rule: scratchpad for temporary files.
