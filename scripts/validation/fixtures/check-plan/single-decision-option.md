# One-option decision
**Tier:** T2

## Goal
Implement a bounded change.

## Change Surface
- `src/example.ts`

## Decision
- **Option A (minimal):** Keep the current implementation.

## Design & Interfaces
- No public interface changes.

## Failure Modes & Recovery
- Revert the change if validation fails.

## Test Strategy
- Run the focused test.

## Rollout & Rollback
- Roll out with the next release.

## Tasks
1. [ ] Implement the change.
   - Files: `src/example.ts`
   - Verify: run the focused test.
