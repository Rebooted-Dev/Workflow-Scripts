# Ambiguous low-indent nested checkbox is rejected
**Tier:** T1

## Goal
Handle ambiguous nested checkbox indentation.

## Change Surface
- `src/parent.ts`

## Tasks
- [ ] Complete the parent task.
  - Files: `src/parent.ts`
  - [ ] Same-kind checkbox at the nested content column is ambiguous.
    - Verify: this cannot be attributed safely.
