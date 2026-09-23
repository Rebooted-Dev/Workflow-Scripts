# Research Findings: Workflow Completion-Chain Remediation

**Date:** 2026-08-08  
**Scope:** Documentation and validation changes to the shared `Workflow-Scripts` execution, confirmation, and completion chain.  
**Research mode:** Local repository inspection only; no source code or host-project files were changed.

## Executive Summary

The shared workflow has the right intended order—execute, verify, confirm, then reconcile—but its terminal handoff is not consistently mandatory. Conditional wording in the confirmation/skill paths allows an executor to stop after verification or to treat archive work as an independent step, so `04-documentation/03-mark-completed.md` can be skipped. The same documents also prescribe archive locations that are not portable across host projects. The recommended remediation is to make `03-mark-completed` the single mandatory terminal gate for the combined `01 → 02 → 03` workflow, make it the only workflow that positively finalizes task marks/marker/archive, resolve archive policy from the host project, constrain active-plan discovery, and add deterministic policy validation plus manual chain scenarios.

## Evidence-Based Current-State Findings

### 1. The completion handoff is described, but not enforced consistently

- `02-code-build/01-execution.md:89-90` says to follow `03-mark-completed` for marking conventions, and `:104-110` requires the full gate at finalization but also presents confirmation as optional at the end of the execution-only workflow.
- `02-code-build/02-confirm-execution.md:85-102` audits every task and says to add a completion marker only after verification, then says to execute `03-mark-completed` when fully verified. It also independently specifies marking and archiving behavior.
- `02-code-build/03-execute-and-confirm.md:20-24` defines the completion bar and says archive occurs only after `01` and `02`; `:30-46` says the combined workflow runs both, then conditionally runs the terminal workflow.
- `11-Skills/execute-and-confirm-plan/SKILL.md:16-45` repeats the ambiguity: step 4 says “when appropriate” for archive/status reconciliation, while step 5 separately syncs records.
- The code-build README presents a sequence diagram ending at `02` (`02-code-build/README.md:13-24`) while pointing to `03-mark-completed` as the single source of truth for marking/archive (`:39-44`).
- The main README calls `03-mark-completed` the single source of truth (`Workflow-Scripts/README.md:786-792`), but its quick-start table omits the terminal gate and its root tree lists only `04-documentation/02-sync-documentation.md` (`:47-62,897-908`).

**Failure mode (local evidence and bounded inference):** The documents do not provide one unambiguous terminal state transition. An executor can satisfy the `01`/`02` verification language, interpret “when appropriate”/“when fully verified” as permission to stop, and never invoke `03-mark-completed`; alternatively, `02` can be treated as the owner of completion marking/archive. This explains how verification can appear complete while the required reconciliation/archive gate does not run. The repository evidence proves the wording conflict and missing navigation; it does not identify a unique historical operator or run log.

### 2. Completion responsibilities are duplicated

`03-mark-completed` owns the verification of claimed completions and the reconciliation process (`04-documentation/03-mark-completed.md:87-91,112-136`). Its acceptance criteria require every claimed completion to be verified, false claims to be flagged, records to be reconciled, and parallel verification to be used (`:167-172`). Yet `02-confirm-execution.md:85-102` permits it to add a completion marker and describes archive/index updates. The terminal gate therefore needs exclusive authority for positive terminal `✅` task marking, completion marker, and archive; confirmation should audit and downgrade claims, not finalize.

### 3. Generic archive paths conflict with host-project policy

The shared docs contain generic instructions for `project/changelog/plans/` (`02-code-build/02-confirm-execution.md:97-102` and `04-documentation/03-mark-completed.md:123-132`) even though host projects document different policies:

- **Nu-Meta:** defaults to `project/plans-completed/<category>/`, with an explicit `project/changelog/plans/` override (`Nu-Meta/AGENTS.md:65`).
- **YT Apps:** has the same default-plus-explicit-override rule (`YT Apps/AGENTS.md:102`).
- **RBC SRT Batch Translator:** documents `project/changelog/plans/` as the completed-plan destination (`rbc-srt-batch-translator-(New UI)-0.5/AGENTS.md:171,202-205`).
- **SRT Studio:** uses root-level `plans-completed/` (`SRT-Studio-New-UI/CLAUDE.md:15`, `SRT-Studio-New-UI/plans-completed/README.md:3-20`).

This proves that generic Workflow-Scripts must not prescribe a global archive destination. The terminal gate should read the host repository's `AGENTS.md` and project documentation, honor the documented default, and honor an explicit alternate request only when the host policy permits it.

### 4. Active-plan discovery can select the wrong artifact

`04-documentation/03-mark-completed.md:87-91` directs scans of `project/build/` and the already archived `project/changelog/plans/`. That mixes active and historical documents and does not prioritize a named target. The safer contract is: named target first; otherwise search `<metadata-root>/plans/**` and `<metadata-root>/build/**`; do not scan archives by default; exclude `README.md`, `TODO.md`, review artifacts, and other navigation/report-only files unless explicitly named.

### 5. Validation conventions already exist

The adjacent validation convention is a deterministic Bash script with `set -euo pipefail`, repository-root resolution, explicit file lists, failing diagnostics, and a final success line (`Workflow-Scripts/scripts/validation/check-review-workflow-policy.sh:1-57`). The scripts README registers validation helpers and their purposes (`Workflow-Scripts/scripts/README.md:28-36`). A new policy validator can follow that convention without introducing a framework.

## External Research

**Not applicable.** This is a local documentation-policy and workflow-chain remediation. No external library, API, community pattern, or web research is needed; the authoritative evidence is the checked-in Workflow-Scripts content and host-project policy documents listed above.

## Recommendations and Decision Record

### Recommended approach

1. **P0 terminal-gate contract:** For the combined workflow, `01` must report applicable verification, `02` must audit it and append evidence, and only then must `03-mark-completed` run. Define two explicit outcomes: `Verified Complete` invokes the terminal gate; `Not Eligible` leaves the plan active with an addendum and no completion marker/archive.
2. **Single finalization owner:** Only `03-mark-completed` may apply positive terminal `✅` task marks, a completion marker, and archive/index changes. `02` may correct false claims downward and document blockers, but may not finalize/archive.
3. **Host-policy resolution:** Remove generic hardcoded archive paths from `01`, `02`, and `03`. Have the terminal gate resolve the actual host policy from `AGENTS.md` and project docs; default/override semantics are host-specific.
4. **Deterministic discovery and validation:** Implement named-target-first active-plan discovery and a lightweight markdown-policy validator. Add a manual scenario matrix for policy and verification edge cases.

### Alternatives considered

| Alternative | Decision | Reason |
|---|---|---|
| Keep `02` as an independent finalizer | Reject | Preserves duplicated authority and allows the combined chain to bypass the terminal reconciliation workflow. |
| Standardize every host on one archive directory | Reject | Contradicted by the four inspected host-project policies; would require owner-approved migrations outside this lane. |
| Add only prose and no validator | Reject | The current drift is textual and navigation-sensitive; deterministic checks are low-cost regression protection. |
| Migrate historical host records now | Defer to P3 | No host-policy migration is authorized; inventory/deprecation notes are needed only if residual ambiguity remains after verification. |

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Removing generic paths leaves an unresolved host with no readable policy | Medium | High | Define a terminal-gate `Not Eligible`/policy-resolution error; require an explicit owner decision rather than guessing. |
| Tightened discovery misses a legitimately named legacy plan | Medium | Medium | Named target always wins; support documented `<metadata-root>/plans/**` and `/build/**`; report candidates and exclusions. |
| Docs become internally consistent but host copies drift later | Medium | Medium | Add validator assertions for handoff, paths, discovery, navigation, and stale links; document rerun command. |
| Existing historical docs contain ambiguous completion language | Medium | Low | Inventory only after P0–P2 verification; record deprecation notes as P3, without rewriting host repositories. |
| Terminal gate changes expose incomplete verification that was previously archived | Medium | High | Require explicit `Not Eligible` addendum and preserve the plan active; never archive blocked/skipped/failed work. |

## Research Conclusions / Exit Conditions for Planning

- The critical defect is workflow-chain drift, not an application runtime defect.
- The remediation must be implemented in Workflow-Scripts, but this research lane changes only the two suite-governance documents named by the request.
- The implementation plan is priority ordered P0 → P3, includes effort/dependencies/risks, and is ready for review at `project/plans/2026-08-08-workflow-completion-chain-remediation.md`.
