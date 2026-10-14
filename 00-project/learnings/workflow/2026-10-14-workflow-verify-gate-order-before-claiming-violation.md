# Verify gate order before claiming a filing-sequence violation

**Date:** 2026-10-14
**Category:** workflow
**Status:** NOTED
**Source:** file: `04-documentation/03-mark-completed.md`, Phase 4 execution order; command: `git status --short` showed this plan at its completed-plan destination after the move

---

## Situation
- A terminal-gate move-order warning was made before comparing the actual action sequence to the gate. The changelog/troubleshooting entries, setup docs, TODO debt routing, status evidence, and pre-move state check had already been completed before the plan move; only post-move link/index reconciliation remained.

## Pattern to avoid
- Claiming the terminal gate was run out of order without checking the recorded step sequence.

## Better approach
- Compare the session's actions to the gate's explicit Phase 4 ordering before flagging a sequencing problem. In Full completion mode, steps 1, 2, 4, 5, 6, and 7 precede deferred step 3; post-move link and index reconciliation is part of step 3.

## Verification
- Read `03-mark-completed.md` Phase 4 instructions and checked the session sequence: the listed pre-filing reconciliations and `check-plan --require-tier --state` preceded the plan move.

## Notes
- The plan remains at its actual completed-plan path while post-move index/link verification finishes; no rollback or additional artifact move was made.
