# check-plan --state passes a plan with no checkboxes
**Date:** 2026-10-13
**Category:** tooling
**Status:** NOTED
**Source:** command: check-plan.sh run after adding the Tasks and Success Criteria sections

---

## Situation
- The cache plan had no checkboxes. check-plan.sh --state printed OK (LEGACY, state), with only a warning about the missing Tier header.

## Pattern to avoid
- Treating a passing validator as proof the plan follows the checkbox rule.

## Better approach
- Look for the Tasks and Success Criteria checkboxes first, add them, then run the validator. Leave Tier unset only when the choice belongs to the developer, since --require-tier fails without one.

## Verification
- After adding the Tasks and Success Criteria sections, the validator passed with the same Tier warning.

## Notes
- Validator gap noted; the validator itself was not changed.
