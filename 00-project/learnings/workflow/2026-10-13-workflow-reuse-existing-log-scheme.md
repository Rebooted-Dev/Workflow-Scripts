# Reuse the project's existing log scheme for agent-written logs
**Date:** 2026-10-13
**Category:** workflow
**Status:** ACTIVE

---

## Situation
- For agent learnings I first designed a split active-rules and log file, and first put the log at the repo root. The developer corrected both: keep it in the project's project/ directory, with the same index and category scheme as the changelog and troubleshooting logs.

## Pattern to avoid
- Inventing a new file layout for a log the project already keeps as an index with category folders.

## Better approach
- Read the existing log's README and index first, copy its shape, and change only the content (categories, status values).

## Verification
- Two developer corrections in the session; the revised layout was implemented and passes the link check.

## Notes
- Learnings design: 00-project-setup/11-agent-learnings.md; proposal: 00-project/plans/agents-patches/agent-learnings-proposal.md.
