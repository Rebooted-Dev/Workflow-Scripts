# Parent evidence after nested child and grandchild
**Tier:** T1

## Goal
Complete the nested work.

## Change Surface
- `src/parent.ts`
- `src/child.ts`
- `src/grandchild.ts`

## Tasks
1. [ ] Complete the parent task.
    - Files: `src/parent.ts`
    - [ ] Complete the child task.
      - Files: `src/child.ts`
      - [ ] Complete the grandchild task.
        - Files: `src/grandchild.ts`
        - Verify: run the grandchild test.
      - Verify: run only the child test.
    - Verify: run the parent test.
