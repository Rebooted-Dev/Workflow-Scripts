# Log only what happened, with its source

**Date:** 2026-10-13
**Category:** workflow
**Status:** ACTIVE
**Source:** file: 00-project/research/2026-10-13-agent-learnings-load-and-accuracy-report.md, section 6.2 (developer accepted the accuracy rule)
**Approved:** 2026-10-13

---

## Situation
- In a sandbox replica, a correction entry said the developer had confirmed the ACTIVE marking and that the agent had failed to follow a rule. Neither appeared in the prompt.

## Pattern to avoid
- Adding confirmations, failures, or reasons that the session does not show.

## Better approach
- Write only what happened in the session, and cite its source: a file, a command and its result, or the developer's message.

## Verification
- The structural checker passes such entries, because it checks format and not content. The README now has an Accuracy section that forbids these claims.

## Notes
- See `troubleshooting/workflow/2026-10-13-workflow-rules-not-loaded-from-subfolder.md`.
