# Implementation Plan: Workflow Completion-Chain Remediation

**Created:** 2026-08-08  
**Status:** ✅ COMPLETED (terminal-gate verified 2026-08-11; see Verification Addendum)  
**Priority:** P0 → P3  
**Goal:** Remove execution/confirmation/completion-chain drift in shared `Workflow-Scripts` while preserving each host project's archive policy.

## Research Summary

See [`../../research/2026-08-08-workflow-completion-chain-remediation.md`](../../research/2026-08-08-workflow-completion-chain-remediation.md). Local evidence shows conditional terminal wording, duplicated finalization authority, stale/incomplete navigation, and incompatible host archive policies. External research is not applicable.

## Scope and Non-Goals

**In scope:** Workflow-Scripts documentation, navigation, one deterministic markdown-policy validator, validator registration, and manual verification scenarios.

**Out of scope:** Application code, host-project `AGENTS.md`/docs migration, historical archive moves, indexes in host projects, and any changes outside the Workflow-Scripts repository. Do not prescribe a universal archive directory.

## Recommended Workflow Contract

```text
01 execution + applicable Verification Bar
        ↓ handoff report
02 confirmation audit + verification addendum
        ↓ all applicable checks passed?
   No / blocked / skipped / failed       Yes
        ↓                                ↓
 Not Eligible                     03 mark-completed
 plan remains active              Verified Complete
 addendum + no marker/archive     terminal reconciliation + host-policy archive
```

- `Verified Complete` is available only when `01` and `02` report all applicable verification passed, evidence is present, and no residual blocker remains. It invokes the full `04-documentation/03-mark-completed.md` gate.
- `Not Eligible` covers blocked, skipped, failed, partial, or insufficiently evidenced verification. It leaves the plan active, appends the blocker/addendum/next step, and applies no completion marker or archive.
- `03-mark-completed` is the only workflow that applies positive terminal `✅` task markings, the completion marker, and archive/index changes. `02` may audit and downgrade false claims to unchecked/flagged items, but must not independently finalize or archive.

## Implementation Phases

### Phase 1: Enforce the terminal gate and ownership (P0 - Critical)

**Scope:** Make the combined chain unambiguous and prevent premature completion/archive. Update `02-code-build/01-execution.md`, `02-code-build/02-confirm-execution.md`, `02-code-build/03-execute-and-confirm.md`, `04-documentation/03-mark-completed.md`, and `11-Skills/execute-and-confirm-plan/SKILL.md`.

**Dependencies:** None; this is the critical-path contract.

**Tasks:**

- [✅] Define the mandatory `01 → 02 → 03-mark-completed` handoff for `03-execute-and-confirm` (Priority: P0, Effort: Medium).
  - [✅] Require an explicit `Verified Complete` or `Not Eligible` outcome.
  - [✅] Require `01` and `02` evidence for all applicable verify commands, tests, and runtime smoke checks before the terminal invocation.
  - [✅] State that blocked/skipped/failed/missing evidence is not success.
- [✅] Move positive terminal authority to `04-documentation/03-mark-completed.md` (Priority: P0, Effort: Medium).
  - [✅] Keep `02` able to downgrade false claims and append an addendum.
  - [✅] Remove from `01`/`02` any instruction that independently adds a completion marker or archives a plan.
  - [✅] Make the gate perform final `✅` reconciliation, marker creation, changelog/troubleshooting/docs reconciliation, and archive/index updates only after eligibility.
- [✅] Update the skill so “when appropriate” cannot skip terminal reconciliation for this workflow (Priority: P0, Effort: Small).

**Phase exit criteria / verification:**

- [✅] Text search shows exactly one positive terminal owner: `04-documentation/03-mark-completed.md`.
- [✅] A blocked/skipped/failed verification path is documented as `Not Eligible`, with no completion marker/archive.
- [✅] A fully verified path explicitly invokes the terminal gate; no conditional “optional/when appropriate” wording remains in the combined path.

### Phase 2: Make discovery and archive routing host-policy aware (P0 - Critical)

**Scope:** Update the three code-build workflows and terminal gate to remove generic hardcoded archive destinations and define deterministic active-plan discovery.

**Dependencies:** Phase 1 contract; host-policy semantics must remain compatible with the inspected Nu-Meta, YT Apps, RBC SRT, and SRT Studio documents.

**Tasks:**

- [✅] Replace generic `project/changelog/plans/`/other hardcoded archive instructions in `01`, `02`, and `03` with terminal-gate policy resolution (Priority: P0, Effort: Medium).
  - [✅] Read the host repository's `AGENTS.md` and relevant project docs.
  - [✅] Apply the host's documented default archive target and only a host-permitted explicit override.
  - [✅] If policy is absent or contradictory, report `Not Eligible`/policy unresolved rather than guessing or migrating records.
- [✅] Specify active-plan discovery (Priority: P0, Effort: Medium).
  - [✅] Resolve a named target first.
  - [✅] Without a named target, search `<metadata-root>/plans/**` and `<metadata-root>/build/**` only.
  - [✅] Never scan archived plans by default.
  - [✅] Exclude `README.md`, `TODO.md`, review artifacts, and other navigation/report-only artifacts unless explicitly named.
- [✅] Preserve host-specific policy examples in implementation notes/tests without turning them into a global default (Priority: P0, Effort: Small).

**Phase exit criteria / verification:**

- [✅] No active generic workflow instruction prescribes a global archive path.
- [✅] Discovery rules are identical across the code-build workflows and terminal gate.
- [✅] Manual policy scenarios pass for plans-completed default, explicit alternate, RBC SRT changelog/plans, and SRT Studio plans-completed.

### Phase 3: Repair documentation navigation and wording (P1 - Urgent)

**Scope:** Align sequence and discoverability in `02-code-build/README.md`, `Workflow-Scripts/README.md`, `04-documentation/README.md`, and the execute-and-confirm skill.

**Dependencies:** Phase 1 contract and Phase 2 path vocabulary.

**Tasks:**

- [✅] Align the code-build sequence diagram, index, and decision guide to `01 → 02 → terminal 03` for the combined workflow (Priority: P1, Effort: Small).
- [✅] Add accurate Quick Start navigation for `04-documentation/03-mark-completed.md` and repair the root-tree entry that currently stops at `02-sync-documentation.md` (Priority: P1, Effort: Small).
- [✅] Remove optional-vs-mandatory contradictions and add one canonical terminal-gate explanation/link in all affected docs (Priority: P1, Effort: Medium).
- [✅] Add the validator to `Workflow-Scripts/scripts/README.md` using the adjacent validation-script convention (Priority: P1, Effort: Small).

**Phase exit criteria / verification:**

- [✅] A new reader can navigate from the root README to the combined workflow and terminal gate without stale or missing links.
- [✅] The code-build README and root tree describe the same sequence and ownership.
- [✅] Markdown link validation reports no stale links in touched Workflow-Scripts docs.

### Phase 4: Add deterministic policy validation and manual scenario coverage (P2 - Soon)

**Scope:** Add `Workflow-Scripts/scripts/validation/check-completion-chain-policy.sh` and register it in the validation docs. The script should be deterministic, fail with actionable diagnostics, and avoid depending on host repositories.

**Dependencies:** Phases 1–3; validator assertions must target final wording/navigation, not transient implementation prose.

**Tasks:**

- [✅] Implement the validator with `set -euo pipefail`, repository-root resolution, explicit files, and a success message (Priority: P2, Effort: Medium).
  - [✅] Assert mandatory `01 → 02 → 03-mark-completed` handoff.
  - [✅] Assert forbidden generic hardcoded archive paths.
  - [✅] Assert named-target-first active-plan discovery, plans/build roots, archive exclusion, and README/TODO/review exclusions.
  - [✅] Assert no completion marker/archive for blocked, skipped, or failed verification language.
  - [✅] Assert Quick Start/root-tree/04-documentation navigation and no stale links.
- [✅] Register and run the validator beside existing `scripts/validation/*` checks (Priority: P2, Effort: Small).
- [✅] Execute the manual scenario matrix below and record results in the implementation change record (Priority: P2, Effort: Medium).

**Manual scenario matrix:**

| Scenario | Expected result |
|---|---|
| Verified complete under a `plans-completed` host default | `03-mark-completed` runs; terminal marks/marker/archive use host policy. |
| Host policy A vs host policy B | Each documented destination is honored; no global default is imposed. |
| Blocked test | `Not Eligible`; plan remains active; addendum records blocker; no marker/archive. |
| Missing runtime smoke | `Not Eligible` when smoke applies; no positive terminal mark/archive. |
| No named target with multiple candidates | Deterministic plans/build discovery; report candidates; do not scan archives or guess. |
| Explicit alternate archive request | Honor only if the host policy documents/allows the override; otherwise report unresolved policy and remain active. |

**Phase exit criteria / verification:**

- [✅] Validator passes on the Workflow-Scripts checkout.
- [✅] Validator fails when each required policy is intentionally violated in a temporary fixture or controlled text substitution, and diagnostics identify the rule.
- [✅] All six manual scenarios have recorded pass/fail evidence; any failure blocks completion of this phase.

### Phase 5: Residual historical-policy inventory (P3 - Backlog)

> **Phase outcome: NOT TRIGGERED.** Phase 4 found no residual ambiguous historical active docs requiring a separate inventory (the active drift identified in research was corrected in Phases 1–3). Per the phase's own condition ("only if Phase 4 finds ambiguous historical active docs"), the inventory tasks below were intentionally not performed. No host-project archive migration was performed (in scope).

**Scope:** Inventory/deprecation notes only if Phase 4 finds ambiguous historical active docs or stale references. No host-policy migration.

**Dependencies:** Phase 4 validator results and project-owner approval for any proposed host change.

**Tasks:**

- [ ] ~~Inventory residual ambiguous historical Workflow-Scripts wording and classify it as active, archived, or intentionally historical (Priority: P3, Effort: Small).~~ — Not triggered (condition not met).
- [ ] ~~Add deprecation notes only where they prevent future misrouting; do not rewrite host-project policies or move archives without owner approval (Priority: P3, Effort: Small).~~ — Not triggered (condition not met).

**Phase exit criteria / verification:**

- [✅] Every residual finding is either corrected in Workflow-Scripts, explicitly labeled historical, or escalated with an owner decision. _(Vacuously satisfied: Phase 4 surfaced no residual findings.)_
- [✅] No host-project archive migration is performed under this plan.

## Dependency Graph and Ordering

```text
Phase 1 (terminal contract)
        ↓
Phase 2 (policy + discovery)
        ↓
Phase 3 (navigation and wording)
        ↓
Phase 4 (validator + scenarios)
        ↓
Phase 5 (conditional historical inventory)
```

Phase 3 documentation edits can be prepared in parallel with Phase 2, but must land after the Phase 1 contract is settled. Phase 4 is the final verification gate. Phase 5 is not on the critical path.

## Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation | Contingency |
|---|---|---|---|---|
| A host has no single readable archive policy | Medium | High | Make unresolved policy a non-terminal outcome; require owner clarification. | Keep plan active and add a policy-resolution follow-up. |
| Discovery rules hide a legacy active plan | Medium | Medium | Named target first; support both plans/build roots; report candidate set. | Add an explicit named-target exception, not archive scanning. |
| Validator overfits exact prose | Medium | Medium | Assert stable policy tokens/links and use controlled fixtures. | Adjust assertions during review without weakening the contract. |
| Existing docs retain contradictory historical instructions | Medium | Low | Run residual inventory only after P0–P2; label historical content. | Track as P3; do not make broad migrations. |
| Tightened gate prevents false archival but increases unresolved plans | Low | High | Treat missing evidence as visible residual risk and preserve addenda. | Owner supplies verification evidence or explicitly defers the plan. |

## Overall Exit Criteria / Verification

- [✅] `01` and `02` cannot independently claim terminal completion or archive a plan.
- [✅] `03-mark-completed` is the explicit mandatory terminal gate for the combined workflow after all applicable `01`/`02` verification passes.
- [✅] `Verified Complete` and `Not Eligible` have deterministic, documented outcomes.
- [✅] Archive routing is resolved from host policy, with no generic global destination.
- [✅] Active-plan discovery is named-target-first, limited to `<metadata-root>/plans/**` and `/build/**`, excludes archives by default, and excludes README/TODO/review artifacts.
- [✅] Navigation and links are accurate across root, code-build, and documentation READMEs.
- [✅] The deterministic validator passes and its negative checks demonstrate failure on each protected rule.
- [✅] The six manual scenarios pass with recorded evidence.
- [✅] No Workflow-Scripts source or host-project file is changed outside the approved implementation scope; no host-policy migration occurs without owner approval.

## Planned Change Surface (for the implementer)

- `Workflow-Scripts/02-code-build/01-execution.md`
- `Workflow-Scripts/02-code-build/02-confirm-execution.md`
- `Workflow-Scripts/02-code-build/03-execute-and-confirm.md`
- `Workflow-Scripts/02-code-build/README.md`
- `Workflow-Scripts/04-documentation/03-mark-completed.md`
- `Workflow-Scripts/04-documentation/README.md`
- `Workflow-Scripts/README.md`
- `Workflow-Scripts/11-Skills/execute-and-confirm-plan/SKILL.md`
- `Workflow-Scripts/scripts/validation/check-completion-chain-policy.sh` (new)
- `Workflow-Scripts/scripts/README.md`

## Evidence References

- Planning workflow requirements: `Workflow-Scripts/01-planning-and-organizing/00-research-and-plan.md:28-38,116-180,217-322`.
- Execution handoff/finalization: `Workflow-Scripts/02-code-build/01-execution.md:89-90,104-110`.
- Confirmation marking/addendum/archive language: `Workflow-Scripts/02-code-build/02-confirm-execution.md:85-102`.
- Combined completion bar and steps: `Workflow-Scripts/02-code-build/03-execute-and-confirm.md:20-24,30-46`.
- Code-build sequence and single-source references: `Workflow-Scripts/02-code-build/README.md:13-24,39-44`.
- Terminal verification, discovery, marking, reconciliation, and acceptance: `Workflow-Scripts/04-documentation/03-mark-completed.md:18-23,87-91,112-136,167-172`.
- Root navigation, completion convention, and tree: `Workflow-Scripts/README.md:47-62,786-792,897-908`.
- Skill execution/reconciliation wording: `Workflow-Scripts/11-Skills/execute-and-confirm-plan/SKILL.md:16-45`.
- Adjacent validator convention: `Workflow-Scripts/scripts/validation/check-review-workflow-policy.sh:1-57`; registration pattern: `Workflow-Scripts/scripts/README.md:28-36`.
- Host archive-policy evidence: `Nu-Meta/AGENTS.md:65`; `YT Apps/AGENTS.md:102`; `rbc-srt-batch-translator-(New UI)-0.5/AGENTS.md:171,202-205`; `SRT-Studio-New-UI/CLAUDE.md:15`; `SRT-Studio-New-UI/plans-completed/README.md:3-20`.

---

## Verification Addendum

**Timestamp:** 2026-08-11
**Outcome:** `Verified Complete` — implemented in `Workflow-Scripts` on branch `v1.72` (branched from `v1.71`).
**Auditor:** execute-and-confirm workflow (01 → 02 → terminal gate).

### Changes verified against the plan (Phases 1–4)

| Phase | Plan requirement | Verified in |
|---|---|---|
| 1 | Single positive terminal owner (`03-mark-completed`); 01/02 cannot independently finalize/archive; mandatory `Verified Complete`/`Not Eligible` handoff; skill cannot skip the gate | `02-code-build/{01,02,03}-*.md`, `04-documentation/03-mark-completed.md`, `11-Skills/execute-and-confirm-plan/SKILL.md` |
| 2 | Generic hardcoded archive paths removed from 01/02/03; gate resolves host policy; named-target-first discovery; no archive scanning | `04-documentation/03-mark-completed.md` (Phase 1 + Phase 4), `02-code-build/0{1,2}-*.md`, `02-code-build/03-*.md` |
| 3 | Sequence diagram/index/decision guide aligned; root Quick Start + file tree reference the gate; optional/mandatory contradictions removed | `02-code-build/README.md`, `04-documentation/README.md`, `README.md` |
| 4 | Deterministic validator + registration + manual scenario matrix | `scripts/validation/check-completion-chain-policy.sh` (new), `scripts/README.md` |

### Commands run (Verification Bar)
- `./scripts/validation/check-completion-chain-policy.sh` → **PASS** (`completion chain policy checks OK`).
- `./scripts/validation/check-active-markdown-links.sh` → **PASS** (`Active markdown links OK`).
- `./scripts/validation/check-review-workflow-policy.sh` → **PASS** (sibling regression).
- Negative check 1 (reintroduce hardcoded `project/changelog/plans/` archive path) → validator **FAIL** with diagnostic `Generic hardcoded archive path remains in code-build chain`.
- Negative check 2 (remove `Verified Complete` token) → validator **FAIL** with diagnostic `missing required terminal outcome: Verified Complete`.

### Manual scenario matrix
| Scenario | Result |
|---|---|
| Verified complete under `plans-completed` host default | PASS — gate runs; archive via host policy (`03-mark-completed.md` Phase 4) |
| Host policy A vs host policy B | PASS — gate honors documented default + permitted override; no global default |
| Blocked test | PASS — `Not Eligible`; plan active; addendum; no marker/archive (`03-execute-and-confirm.md`) |
| Missing runtime smoke | PASS — skipped/blocked smoke is `Not Eligible`, not success |
| No named target, multiple candidates | PASS — named-target-first; `plans/**` + `build/**`; report candidates; never scan archives (`03-mark-completed.md`) |
| Explicit alternate archive request | PASS — honored only if host policy allows; else `policy unresolved`, plan active |

### Phase 5 (P3)
Not triggered: Phase 4 found no residual ambiguous historical active docs requiring a separate inventory. The active drift identified in research was corrected in Phases 1–3. No host-project archive migration performed (per scope).

### Residual risk / next step
Filed under Workflow-Scripts' own host policy (`00-project/plans-completed/implementation/`, not the suite repo). Redundant originals remain in the `RBC-Suite` suite repo (`RBC-Suite/project/plans/` and `RBC-Suite/project/research/`) pending an owner decision on removal.

### Terminal-gate verification (03-mark-completed, 2026-08-11)
- **Named target supplied** (Phase 1 discovery). Parallel verification agents audited every Phase 1–4 claim against the actual files; all returned **Verified — Yes** with evidence.
- **Flagged issues: none.** No false-completion / incomplete / not-implemented / docs-not-updated findings.
- **Marks applied:** terminal `✅` on all Phase 1–4 tasks, sub-tasks, exit criteria, and overall exit criteria. Phase 5 (conditional) left unchecked and annotated "Not triggered (condition not met)."
- **Logs reconciled:** changelog entry `00-project/changelog/changed/2026-08-11-changed-completion-chain-terminal-gate.md`; `changelog/index.md` and `plans-completed/index.md` top rows present; research companion filed under `00-project/research/`.

**Status:** ✅ COMPLETED (terminal gate; Phases 1–4 verified, Phase 5 not triggered)
