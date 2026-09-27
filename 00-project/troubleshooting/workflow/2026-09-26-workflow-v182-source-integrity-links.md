# v1.82 source-integrity links and navigation were stale

**Date:** 2026-09-26
**Category:** workflow
**Status:** corrected locally; user-approved local commit pending parent restage and revalidation

## Symptom

The relocated active Astra evaluation plan had four broken outbound links. The old parallel-agent harness draft still appeared Active despite a finalised successor, and the active TODO item retained a bare-name reference plus an obsolete instruction to fix the already-pinned baseline.

## Root Cause

The protocol was deleted in commit `f7c0cae` while six source files were renamed, leaving active references pointed at obsolete paths. The protocol's restored location, the harness draft's supersession, and the approval-gated evaluation route had not been reconciled with those moves.

## Fix

- Recovered the protocol from historical commit/blob `58689d8` / `7c6fd01` (SHA-256 prefix `0e6b69…`) and applied navigation-only adjustments in the final protocol blob `7e7dc747` (SHA-256 prefix `7a8dcf…`). The companion provenance report carries the full details.
- Repointed Astra plan references at `:7` and `:95` to the sibling protocol, `:96` to the archived source plan, and `:97` to the workflow-applicability policy.
- Marked the draft harness source superseded by the same-directory final plan. Linked the active TODO item to the relocated Astra plan and routed future execution through approval-gated Plan 05; removed the stale baseline-fix instruction without changing the pinned value.
- Preserved the independent Astra setup audit. No corpus/pin changes, experiments, host-project edits, or Plan 05 arm selection were made.

## Verification

- Parent reports `check-active-markdown-links.sh` and all non-link validators pass locally. Parent `check-meta-logs.sh --staged` passed for the staged ten-path set.
- User authorization for a local commit of exactly the ten documented paths is recorded; no push was authorized. Strict staged whitespace validation reported only the two preserved historical hard-line-break spaces at protocol lines 3–4, with all other staged paths passing. The parent will restage this updated report/records/indexes and rerun strict checks; a local commit follows only if revalidation passes.
- The records and source edits are **not yet committed or CI-verified**. No remote CI result or unqualified whitespace pass is claimed.

## Notes / Lessons

- After a full-set rename or source recovery, update active references and draft/successor status together while preserving historical and archive citations.
- A tracker link or locally passing link check does not authorize an experiment, select an evaluation arm, or imply remote CI verification.
