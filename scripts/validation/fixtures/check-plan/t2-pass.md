# Standard plan
**Tier:** T2

## Goal
Implement a bounded feature.

## Change Surface
- Existing feature paths.

## Decision
- **Option A (minimal):** Reuse the existing module.
- **Option B:** Introduce a new module.

## Design & Interfaces
- Keep the current public interface.

## Failure Modes & Recovery
- Revert the focused change if verification fails.

## Test Strategy
- Run the focused automated test.

## Rollout & Rollback
- Roll out with the next release; revert if needed.

## Tasks
1. [ ] Implement the bounded feature.
   - Files: `src/feature.ts`
   - Verify: run the focused automated test.
