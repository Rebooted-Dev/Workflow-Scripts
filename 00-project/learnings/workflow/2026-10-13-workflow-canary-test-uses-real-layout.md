# A canary check must test the repo's real layout
**Date:** 2026-10-13
**Category:** workflow
**Status:** NOTED
**Source:** command: check-agent-rules-load.sh run against a copy of the old import layout

---

## Situation
- The first version of check-agent-rules-load.sh built its own symlink in a scratch copy. Run against the old layout (CLAUDE.md = `@AGENTS.md`), it still passed, because the canary was seen.

## Pattern to avoid
- Building the test layout inside the check instead of copying the repo's real CLAUDE.md.

## Better approach
- Copy the repo's CLAUDE.md with `cp -P`: a symlink stays a symlink, and an @ import is copied as text and fails from the subfolder. Keep a negative case (the old layout) that must fail.

## Verification
- Negative run (old import layout): "NONE" from sub/deep/, and the check failed. Positive run (symlink layout): the canary was seen and the check passed.

## Notes
- `scripts/validation/check-agent-rules-load.sh`.
