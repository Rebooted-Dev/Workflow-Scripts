# Workflows Drag-Free Deep Review

**Date:** 260710 1420 (Asia/Singapore)  
**Model:** GPT-5 Codex  
**Repository root:** `/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts`  
**Scope:** `workflows-drag-free/` correctness, routing, validator integrity, self-application, and instruction clarity  
**Status:** Complete  

## Scope and exclusions

This was a read-only review of the current dirty worktree. Existing migration edits were treated as current-state evidence and were not changed. Per the user's direction during the review, the security audit was stopped and security candidates are excluded from this report. Performance was not promoted as a separate lens because no measured hot path or user-reported slowdown was found.

The only repository writes from the review are this report and its required changelog record.

## Executive summary

Six confirmed findings remain: **P0: 0, P1: 4, P2: 2, P3: 0**. The dominant issue is not broken redirect migration: the redirect, active-link, catalog-freshness, review-policy, CLI, and orchestrator validators all pass. The dominant issue is that the generated router and several review workflows are internally consistent only within an incomplete or stale contract.

Top P1 actions:

1. Repair the shared-core references used by review/security workflows and the stale rubric pointer inside the shared core.
2. Make every intended routable workflow discoverable and require `next`/`prev` targets to resolve.
3. Replace the three unconditional migration-check no-ops with real checks or remove them from the gate.
4. Make `wf run` resolve and dispatch its requested workflow instead of ignoring `workflow_id` and always launching plan review.

## Findings

### FINDING-001 — Shared review-core references resolve outside `workflows-drag-free`

**Status:** CONFIRMED / Verified  
**Files:** `05-review/01-code-review.md:34-36,51,67`; `05-review/05-comprehensive-audit.md:31`; `05-review/06-deep-review.md:50`; `06-security/01-security-review.md:34-36,44`; `06-security/02-security-fix.md:14,41,75,94`; `00-core/meta/review-workflow-core.md:12`  
**Behavior:** The domain workflows use `../../00-core/...`. From `05-review/` or `06-security/`, that points to repository-root `00-core/`, which does not exist. The correct package-relative prefix is `../00-core/`. After reaching the shared core, its own pre-flight rule names the retired `../00-Meta-Workflow/00-meta/severity-priority-rubric.md` path.  
**Impact:** Normal review execution cannot reliably load its mandatory routing, scoring, spawning, and naming contracts. Agents can work around the defect by locating the current files manually, but the workflow's declared pre-flight is broken.  
**Severity:** S2 — partial workflow failure with a manual path-discovery workaround.  
**Priority:** P1 — medium impact on a likely/normal review path; fix before relying on these workflows as automated gates.  
**Fix:** Change the domain references to `../00-core/...`; change the shared-core rubric pointer to `severity-priority-rubric.md` or the correct sibling path. Add these references to the active-link validator or a dedicated workflow-contract validator.  
**Verification:** Run the path-resolution snippet in the verification addendum and require every referenced target to report `exists=True`; rerun `check-active-markdown-links.sh` and `check-review-workflow-policy.sh`.

### FINDING-002 — Incomplete catalog plus permissive routing sends valid intents to the wrong workflow

**Status:** CONFIRMED / Verified  
**Files:** `tools/wf:124-142,343-359`; `01-planning/01-plan-review.md:14`; `01-planning/02-finalise-plan.md:1`; `06-security/01-security-review.md:14`; `06-security/02-security-fix.md:1`; generated `ROUTER.md:15,22`  
**Behavior:** `records()` silently skips Markdown without frontmatter, yet active graph edges name IDs such as `finalise-plan` and `security-fix` whose canonical files have no frontmatter and therefore no catalog record. Routing uses substring token counts, falls back to the full catalog on no match, always chooses a record, and exits zero. `wf route 'finalise the plan'` currently returns `execution`; `wf route 'security fix'` returns `bug-fix-workflow`.  
**Impact:** A user or agent can request a legitimate planning or remediation transition and receive a different operational workflow. In an agent-driven system this can turn a planning request into implementation or route security remediation through the generic bug workflow.  
**Severity:** S2 — wrong workflow selection with a manual direct-file workaround.  
**Priority:** P1 — medium impact on likely workflow-routing paths.  
**Fix:** Add frontmatter to every workflow intended to be routable, starting with all unresolved `next`/`prev` IDs. Make validation fail unresolved graph edges. Route exact IDs/triggers first; reject no-match and ambiguous queries instead of alphabetical fallback.  
**Verification:** Assert `finalise-plan` and `security-fix` exist in `catalog.json`; assert every `next`/`prev` resolves; add route fixtures for `finalise the plan`, `security fix`, unknown text, and ambiguous shared-token text.

### FINDING-003 — Three advertised migration checks are unconditional no-ops

**Status:** CONFIRMED / Verified  
**Files:** `tools/wf:510-524,566-574`; `scripts/validation/check-wf-cli.sh:9-13`  
**Behavior:** `init-frontmatter`, `init-ledger-frontmatter`, and `prune-skipped-frontmatter` all call `no_op_check()`, which prints `check passed` and returns zero without inspecting any file. The validation suite presents these outputs as gates.  
**Impact:** Migration omissions and stale metadata receive explicit false-positive success messages. This is directly relevant to FINDING-002: canonical workflows lacking frontmatter coexist with `init-frontmatter check passed`.  
**Severity:** S2 — validation fails to detect partial workflow-system failure.  
**Priority:** P1 — likely on every CLI validation run and undermines release confidence.  
**Fix:** Implement deterministic checks for each command, or remove them from `check-wf-cli.sh` until implemented. At minimum, frontmatter checking must enumerate intended active workflows lacking required metadata and exit nonzero.  
**Verification:** Add negative fixtures for a missing workflow frontmatter block, missing ledger metadata, and forbidden retained frontmatter; each check must fail before repair and pass after repair.

### FINDING-004 — `wf run` ignores `workflow_id` and always launches plan review

**Status:** CONFIRMED / Verified  
**File:** `tools/wf:467-485,555-559`  
**Behavior:** The CLI accepts `workflow_id` and records it in the manifest, but never resolves or uses it. Every invocation runs `tools/orchestrator/orchestrator-review.sh`, regardless of the requested ID. A nonexistent ID is accepted if the review subprocess succeeds.  
**Impact:** The command advertises generic workflow execution but performs only plan review, producing misleading success manifests and breaking any caller that expects the requested workflow to run.  
**Severity:** S2 — primary command contract is partially broken; direct workflow invocation remains a workaround.  
**Priority:** P1 — likely whenever `wf run` is used outside plan review.  
**Fix:** Resolve `workflow_id` against the catalog, reject unknown IDs, and dispatch only through a runner explicitly declared for the selected workflow. If the command is intentionally review-only, rename/restrict it and remove the unused ID contract.  
**Verification:** Add fixtures for a known review workflow, a known non-review workflow, and an unknown ID; require the declared runner or an explicit unsupported/unknown failure, and verify the manifest matches the operation actually executed.

### FINDING-005 — Security-fix self-application writes records to a retired layout

**Status:** CONFIRMED / Verified  
**File:** `06-security/02-security-fix.md:97-106`  
**Behavior:** The workflow directs completed fixes to a bullet in `docs/CHANGELOG.md` or `CHANGELOG.md` and to root `troubleshooting/security/`. This package's authoritative system is `00-project/changelog/<type>/...` plus `00-project/changelog/index.md`, and `00-project/troubleshooting/<category>/...` plus its index.  
**Impact:** Applying the workflow to Workflow-Scripts itself omits required canonical records or creates parallel record trees.  
**Severity:** S2 — documentation/bookkeeping completion is wrong, while the code fix itself can still succeed.  
**Priority:** P2 — medium impact with possible/conditional self-application.  
**Fix:** Delegate record routing to the metadata-root/repo-records contract and explicitly require both canonical changelog and troubleshooting entries for security bugs.  
**Verification:** Add a self-application fixture for a Workflow-Scripts security fix and assert the resulting paths and index rows are under `workflows-drag-free/00-project/`.

### FINDING-006 — Review pre-flight recovery names the retired setup path

**Status:** CONFIRMED / Verified  
**Files:** `05-review/01-code-review.md:56`; `06-security/01-security-review.md:49`  
**Behavior:** Both workflows tell the user to run `00-project-setup/01-setup-project.md` when metadata is absent. The active workflow is `00-setup/01-setup-project.md`; the named package path does not exist.  
**Impact:** The prescribed recovery action fails exactly when metadata setup is missing.  
**Severity:** S2 — recovery path fails; the correct workflow is nearby and discoverable.  
**Priority:** P2 — medium impact on a possible setup-error path.  
**Fix:** Replace the retired path and add it to link/path validation.  
**Verification:** Require the referenced setup file to exist from both workflow locations and run the active-link validator.

## Lower-impact documentation drift

Not promoted as a separate scored finding: root `README.md:37-51` describes eleven categories, includes repo-root `11-Skills/` within a package-oriented list, then calls the active `00-core/meta/` directory `00-meta/`. The links themselves are valid, but the terminology should be corrected when the README is next touched.

## Strengths worth preserving

- `MOVED.json` and `catalog.json.redirects` agree on all 146 redirects.
- The moved-target validator reports zero missing, self-stubbed, mismatched, or malformed mappings.
- Active Markdown link validation, review-policy checks, catalog freshness, CLI fixtures, and orchestrator regression checks all pass.
- The review workflows explicitly require source-line verification and prohibit modifying reviewed source during review.
- The numbered package layout and flattened `00-project/` metadata boundary are clear in the repo-local agent guidance.

## Recommended sequence

1. Fix FINDING-001 so every review loads the intended contracts.
2. Fix FINDING-002 and FINDING-003 together; the real frontmatter/graph gate should prevent incomplete catalogs from being marked fresh.
3. Resolve FINDING-004's command contract and add dispatch fixtures.
4. Correct FINDING-005 and FINDING-006, then clean up the README terminology.
5. Rerun the validators listed below and add negative regression fixtures before closing the remediation plan.

## Verification addendum — 2026-07-10 14:20 +08

Every finding was re-checked against the current worktree after initial discovery.

| Finding | Verification status | Evidence |
|---|---|---|
| FINDING-001 | Verified | Direct `Path.resolve().exists()` checks returned `False` for every emitted `../../00-core/...` reference; current sibling targets exist under `workflows-drag-free/00-core/`. The shared core still names the retired rubric path at line 12. |
| FINDING-002 | Verified | `wf route 'finalise the plan'` returned `execution`; `wf route 'security fix'` returned `bug-fix-workflow`. Canonical `02-finalise-plan.md` and `02-security-fix.md` begin without frontmatter. |
| FINDING-003 | Verified | All three commands printed `check passed`; source lines 510-512 and 569-574 prove they call an unconditional zero-return function. |
| FINDING-004 | Verified | Source trace shows `workflow_id` is only copied into the manifest; subprocess construction always selects `orchestrator-review.sh`. |
| FINDING-005 | Verified | Named root changelog/troubleshooting paths are absent; canonical indexed systems exist under `00-project/` and are mandated by `00-project/AGENTS.md`. |
| FINDING-006 | Verified | `workflows-drag-free/00-project-setup/01-setup-project.md` is absent; `workflows-drag-free/00-setup/01-setup-project.md` exists. |

Commands executed (all read-only against source):

```text
./scripts/validation/check-active-markdown-links.sh     # PASS: Active markdown links OK
./scripts/validation/check-moved-targets.sh             # PASS: 146 rows; 0 missing/self-stubbed/mismatched/malformed
./scripts/validation/check-review-workflow-policy.sh     # PASS
./scripts/validation/check-wf-cli.sh                     # PASS, including the three no-op messages
./scripts/validation/check-orchestrator-review.sh        # PASS
workflows-drag-free/tools/wf route 'finalise the plan'   # WRONG RESULT: execution
workflows-drag-free/tools/wf route 'security fix'        # WRONG RESULT: bug-fix-workflow
workflows-drag-free/tools/wf init-frontmatter --check    # FALSE ASSURANCE: check passed
workflows-drag-free/tools/wf init-ledger-frontmatter --check
workflows-drag-free/tools/wf prune-skipped-frontmatter --check
```

No PLAUSIBLE findings remain in this report. Security candidates were excluded at the user's request rather than adjudicated here.
