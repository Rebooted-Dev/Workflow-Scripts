---
date: 2026-07-06
kind: reference
status: draft
---

# Legacy Meta Compatibility Follow-up Implementation Plan

## Summary

This follow-up plan preserves compatibility after migrating retained `00-Meta-Workflow/` content to canonical paths.

## Phase 1 - Guard Current Migration (P1)

- [ ] Keep `00-Meta-Workflow/` compatibility files until redirect cleanup is explicitly reached.
- [ ] Keep `00-project/research/2026-07-06-legacy-meta-workflow-migration-decision.md` linked from TODO.
- [ ] Continue running `tools/wf validate` and active markdown link checks after any moved-path edits.

## Phase 2 - Release-Cycle Cleanup Decision (P2)

- [ ] After the next release cycle, decide whether to delete root redirect stubs and compatibility directories.
- [ ] Before deleting, file a cleanup plan listing exact paths, consumers affected, rollback, and validation commands.
- [ ] Archive or delete consolidated logs only after live promotion/audit evidence is no longer needed.

## Validation

- Every `00-Meta-Workflow/` row in `MOVED.md` has an existing canonical target.
- `tools/wf validate` passes with zero warnings.
- `check-active-markdown-links.sh` passes.
