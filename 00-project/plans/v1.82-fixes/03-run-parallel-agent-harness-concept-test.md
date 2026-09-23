# 2026-09-22 16:37

# Run Parallel Agent Harness Concept Test

**Status:** Active — authoritative successor to the finalized July harness source; concept test not run

**Summary:** Run a bounded, disposable harness concept test that discovers the current command and permission behavior of `opencode`, `codex`, `droid`, and `claude`, launches verified non-interactive passes, proves protected-scope isolation and artifact discipline, and produces a single-writer manifest and synthesis record. This is a mechanics test, not a model-quality benchmark and not a reusable launcher project.

## Source and review provenance

- Authoritative source: [`Parallel Agent Harness Concept Test — Finalised Implementation Plan`](../../research/v1.82-fixes/2026-07-04-parallel-agent-harness-concept-test-implementation-plan.md).
- Superseded draft retained for provenance: [`Parallel Agent Harness Concept Test — draft`](../../research/v1.82-fixes/2026-07-04-parallel-agent-harness-concept-test-plan.md). Do not execute the draft independently.
- Workflow review contract: [`Plan Review and Finalisation`](../../../01-planning-and-organizing/03-plan-review-and-finalise.md).
- Advisory review inputs: the finalized source's inline review addendum, the two independent read-only reviews, and Oracle graph review supplied for this task. Corrections incorporated here include fresh discovery for all four harnesses, dynamic run IDs, full protected-scope detection, single manifest ownership, explicit non-stub quorum, lowest-common-denominator path delivery, timeout/cleanup handling, and strict anti-generalization scope.

## Entry gates

- Use a newly generated run ID; never reuse the historical hardcoded `2026-07-04-harness-concept` run ID.
- Use a disposable isolated workspace, separate from the live Workflow-Scripts worktree and consumer repositories.
- Hash every protected source/input path and capture a full dirty-state baseline before launch; the run fails on any unauthorized write outside the run-owned output directory.
- Discover current tool/version/help/permission behavior for all four harnesses at execution time, including `opencode`; do not rely on July availability or syntax claims.

## P0–P3 priority roadmap

### P0 — discovery and isolation gates

- [ ] 1. **(Small)** Discover whether `opencode`, `codex`, `droid`, and `claude` are installed, capture version/help output, and determine the safest non-interactive command, prompt delivery, model selection, output format, permission/approval mode, and timeout behavior for each.
- [ ] 2. **(Medium)** Create a disposable isolated workspace and run-owned output directory. Capture protected-scope hashes and repository dirty-state baseline before creating the synthetic packet.
- [ ] 3. **(Small)** Generate a unique run ID and precompute unique artifact, log, status, and manifest paths; no path may contain a fixed historical run identifier.
- [ ] 4. **(Small)** Mark any unavailable, interactive-only, permission-blocked, or unstable harness honestly; do not invent commands or retry-loop a blocked nested `claude` invocation.

**Dependencies:** Independent after the meta safety baseline. No launch occurs unless all four discovery records and isolation checks exist.

### P1 — prepare and execute the bounded test

- [ ] 1. **(Small)** Create the deliberately small protected synthetic source packet and its hash. Include three claims, one obvious inconsistency, one harmless ambiguity, and a clear no-edit instruction.
- [ ] 2. **(Medium)** Prepare one common prompt containing absolute source and assigned-artifact paths for every harness. Use `opencode` file attachment only as an optimization; the absolute paths remain authoritative.
- [ ] 3. **(Medium)** Write the manifest skeleton once as orchestrator. Launch each verified harness independently with its own timeout and assigned log/artifact path; every harness receives one writable output path and no manifest access.
- [ ] 4. **(Small)** If a manual stub is needed for shape validation, label it `stub: true`; it never counts toward the quorum. Require at least two real, non-stub successful completions, while accounting honestly for all four requested harnesses.
- [ ] 5. **(Small)** Ensure the orchestrator alone writes final manifest status after all child processes finish. Passes may report through status files or process results, never concurrent manifest writes.

**Dependencies:** P0 discovery and isolation. The default ten-minute test timeout is an intentional concept-test override; it must not be generalized into a parent workflow contract.

### P2 — validate artifacts, isolation, timeout, and synthesis

- [ ] 1. **(Medium)** Validate every completed artifact against the required fields (`harness`, `model`, `status`, `findings`, and `notes`) without silently normalizing malformed output.
- [ ] 2. **(Small)** Re-hash protected inputs and compare full-tree state with the baseline. Fail the run on source mutation, unauthorized writes, path escape, or any output outside the dynamic run-owned directory.
- [ ] 3. **(Small)** Record complete, failed, timeout, unavailable, blocked, and stub statuses, exit information, logs, cleanup result, and whether the real-completion quorum was met.
- [ ] 4. **(Medium)** Write a synthesis record that references every harness, lists malformed/missing artifacts, and uses manual evidence review only. Do not add fuzzy clustering, embeddings, or speculative cross-model generalization.
- [ ] 5. **(Small)** Apply timeout cleanup and prove no child process or disposable workspace remains unexpectedly active. Keep or archive outputs only according to a recorded, authorized cleanup decision.

**Dependencies:** P1 launch completion. Synthesis cannot declare success unless both real-completion quorum and protected-scope checks pass.

### P3 — separately authorized lessons only

- [ ] 1. **(Small)** Distinguish preparation findings (discovery, fixture, command, and isolation records) from post-test lesson reconciliation.
- [ ] 2. **(Small)** After the test, seek explicit authorization before changing any parent plan, workflow contract, or documentation based on lessons. A lesson may be recorded as a bounded follow-up decision; it does not authorize implementation.
- [ ] 3. **(Small)** If the concept passes, do not automatically build `fan-out-adversarial.sh`, a reusable launcher, or a framework. If it fails, record the observed blocker and stop.

**Dependencies:** P2 evidence and explicit post-test authorization. No automatic source or production update is part of this concept test.

## Scope and non-goals

In scope are fresh discovery, disposable isolation, one synthetic packet, four harness accounting, two-real-completion quorum, one manifest writer, artifact validation, timeout/cleanup, and an audit synthesis. Out of scope are model-quality benchmarking, a reusable launcher or framework, fuzzy/embedding clustering, persistent defaults, speculative generalization, production workflow edits, consumer-repository edits, live-worktree writes, and expensive research runs.

## Risks and mitigations

- **Tool syntax or permission drift (S1/P0):** discover version/help/permission behavior immediately before launch and mark unsupported tools honestly.
- **Unauthorized write or source tampering (S0/P0):** disposable workspace, protected-scope hashes, full-tree baseline comparison, and run-owned output boundary.
- **Manifest corruption (S1/P1):** orchestrator-only skeleton/final writes; no child writes to the manifest.
- **False quorum from stubs (S2/P1):** explicit `stub: true`; only two real non-stub completions satisfy quorum.
- **Hung or orphaned processes (S1/P2):** per-pass timeout, cleanup verification, and no retry loop for blocked nested invocations.
- **Concept test becomes architecture work (S2/P3):** require separate approval and prohibit reusable launcher/framework implementation.

## Validation and objective exit criteria

**Validation owner:** parent orchestrator.

- Fresh discovery records exist for all four harnesses, including `opencode`, with verified command or evidenced unavailable/blocked status.
- A dynamic run ID, disposable workspace, protected-scope hashes, and pre-launch dirty-state baseline exist.
- The manifest has one authoritative writer and accounts honestly for all four harnesses; at least two real non-stub passes complete successfully.
- Every accepted artifact is valid, every timeout/failure/blocked result is recorded, and no unauthorized path changed.
- Protected inputs retain their hashes, child processes are cleaned up, and the synthesis records the cleanup decision and all lessons without fuzzy clustering or speculative generalization.
- Any post-test reconciliation is separately authorized; no reusable launcher/framework or production change is inferred from a passing concept test.
