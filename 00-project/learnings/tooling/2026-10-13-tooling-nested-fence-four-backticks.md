# Use four-backtick fences around templates that contain code blocks
**Date:** 2026-10-13
**Category:** tooling
**Status:** NOTED
**Source:** file: source read; template extracted from the outer fence (57 lines)

---

## Situation
- The proposal's README template had triple-backtick blocks inside a triple-backtick fence. The outer fence closed at the first inner block, so the rest of the template would render as body text.

## Pattern to avoid
- Nesting fences of the same length.

## Better approach
- Use four backticks for the outer fence and keep three for the inner blocks.

## Verification
- Checked by reading the source and by extracting the template from the outer fence (57 lines). Not rendered in a viewer.

## Notes
- Fixed in the proposal in this session.
