# 2026-07-04 11:43

# Parallel Agent Harness Concept Test - Finalised Implementation Plan

**Status:** Active (ready to execute)
**Parent plan:** `00-project/plans/2026-07-03-multi-model-plan-review-pass-system-implementation-plan.md`
**Consolidated from:** the 2026-07-04 harness concept test draft plus its inline 2026-07-04 11:43 review addendum (Model: claude-fable-5). This document is self-contained; the draft is superseded and does not need to be consulted.
**Purpose:** Prove that an orchestrator can launch parallel sub-agent passes through multiple harnesses, collect exactly one artifact per pass, preserve protected files, and produce a manifest plus synthesis report.
**Project metadata root:** `00-project/` only because this plan tests changes to the Workflow-Scripts system itself. For consumer-project tests, the same layout belongs under that project's root-level `project/` directory.

## Summary

Run a small, low-risk concept test of the adversarial orchestration mechanism before implementing the full research/planning/review workflow system. The test uses a synthetic source packet and asks each harness to produce a tiny structured report. The orchestrator then verifies that each pass wrote exactly one assigned artifact, records statuses in `_manifest.json`, and writes `_synthesis.md`.

This test is about harness mechanics, isolation, and artifact discipline. It is not a quality benchmark for the models.

**Verified environment facts (2026-07-04):** all four harnesses are installed and on `PATH` (`opencode` at `~/.opencode/bin/opencode`; `codex`, `droid`, `claude` at `~/.local/bin/`). `opencode run --help` confirms `-m`, `--title`, `-f/--file`, and `--format json`. Phase 1 discovery therefore focuses on `codex`, `droid`, and `claude` invocation shapes only.

## Test scope

Harnesses to run:

| Harness | Required for pass? | Invocation status |
|---|---:|---|
| `opencode` | yes | Verified: `opencode run -m <provider/model> --title <run-title> -f <source-file> --format json "<prompt>"`. |
| `codex` | yes | On `PATH`; exact non-interactive command shape must be verified in Phase 1 before launch. |
| `droid` | yes | On `PATH`; exact non-interactive command shape must be verified in Phase 1 before launch. |
| `claude` | yes | On `PATH`; expected shape `claude -p "<prompt>" --output-format json` with an explicit permission mode (see nested-invocation rule below). Verify in Phase 1. |
| `manual-stub` | fallback only | Used only when a harness cannot run non-interactively, and only to validate manifest/synthesis shape. Stub entries carry `"stub": true` and **never** count toward the pass quorum. |

**Pass criterion:** at least two **real** (non-stub) harness passes complete successfully, every other harness is represented honestly as `unavailable`, `skipped`, or `blocked` in the manifest, and the isolation checks (git-clean check and source hash) pass.

**Nested `claude` invocation rule:** if this test is executed from inside a Claude Code session, launch the `claude` pass as a detached child process with its own timeout and a permission mode restricted to writing its assigned artifact path. If nesting proves unstable, mark the pass `blocked` with the observed error; do not retry-loop.

## Artifact layout

All files created by this test live under:

```text
00-project/build/adversarial-multi-model-workflow/harness-test/
  discovery/
    <harness>-version.txt / <harness>-help.txt / discovery-note.md
  source/
    synthetic-source-packet.md
    protected-source-hash.txt
  runs/
    2026-07-04-harness-concept/
      _manifest.json
      _synthesis.md
      logs/
        opencode.events.jsonl
        codex.events.log
        droid.events.log
        claude.events.log
      artifacts/
        synthetic.review.general.opencode.<YYYY-MM-DD-HH-MM>.md
        synthetic.review.general.codex.<YYYY-MM-DD-HH-MM>.md
        synthetic.review.general.droid.<YYYY-MM-DD-HH-MM>.md
        synthetic.review.general.claude.<YYYY-MM-DD-HH-MM>.md
```

Artifact timestamps use the `YYYY-MM-DD-HH-MM` format, matching the `PLAN.reviews` naming convention in `01-planning-and-organizing/01-plan-review.md`.

Do not create or edit files under `00-Meta-Workflow/`, `01-planning-and-organizing/`, or other top-level workflow directories during this test. For consumer-project runs, substitute `<consumer-project-root>/project/` for `00-project/` in the layout above.

## Isolation and single-writer rules

1. **Orchestrator is the sole writer of `_manifest.json`.** It writes the skeleton once before launch and the final state once after all passes complete (`wait`). Per-pass results are held in per-pass status files or orchestrator memory in between — passes never write the manifest, and no concurrent manifest writes occur.
2. **Full-tree change detection.** Capture `git status --porcelain` (Workflow-Scripts repo) before launch and after all passes complete. Fail the run if any path outside `harness-test/runs/2026-07-04-harness-concept/` changed.
3. **Protected source hash.** Hash `synthetic-source-packet.md` before launch into `source/protected-source-hash.txt`; re-hash after all passes and fail the run on mismatch. This is a secondary, explicit guard on top of the git check.
4. **One artifact per pass.** Output paths are precomputed and unique before launch; each pass is instructed to write only its assigned path.

## Synthetic task

Create `synthetic-source-packet.md` with a deliberately small source packet:

- A short fake plan with three numbered claims.
- One obvious inconsistency that each pass should notice.
- One harmless ambiguity that may produce divergent recommendations.
- An instruction that the source packet is protected and must not be edited.

Each harness receives the same prompt. Because only `opencode` has a verified file-attach flag, the **absolute source-packet path and absolute output artifact path are embedded directly in the prompt text for every harness**; `-f` attachment is an opencode-only optimization on top of that.

```text
Read the synthetic source packet at <ABSOLUTE_SOURCE_PATH>. Write one structured review artifact to exactly <ABSOLUTE_ARTIFACT_PATH>. Do not edit the source packet or any other file.

Required fields:
- harness
- model
- status
- findings: list of {id, title, evidence, severity, priority, fix}
- notes
```

## Manifest schema

`_manifest.json` contains run-level fields `run_id`, `source`, `launched_at`, `timeout_minutes` (10 — an intentional test-scale override; the parent contract default remains 30), `quorum` (2 real completions), and `cleanup` (decision recorded in Phase 5). Each pass entry contains: `id`, `harness`, `model`, `role`, `artifact`, `log`, `status`, `exit`, `started_at`, and `stub` (boolean). Any remaining divergence from the parent manifest contract (for example `findings_or_claims`) is recorded as an explicit lesson in `_synthesis.md`.

## Roadmap

### Phase 1 - Harness invocation verification (P1)

**Scope/objective:** Confirm non-interactive invocation shapes. `PATH` presence and the opencode command shape are already verified (2026-07-04); do not re-derive them.

**Key tasks:**

1. **(Small)** Capture version/help output for all four harnesses into `harness-test/discovery/` for the record.
2. **(Medium)** Verify and record the safest non-interactive invocation shape for `codex`, `droid`, and `claude`: model flag, how the prompt is passed, output format, permission/approval mode, and timeout behavior. For `claude`, verify `claude -p ... --output-format json` plus an explicit restricted permission mode.
3. **(Small)** Mark any harness that turns out to be interactive-only as `blocked` in `discovery/discovery-note.md` with the observed evidence rather than inventing a command.

**Verification / exit criteria:** `discovery-note.md` lists a verified command shape or a blocked reason with evidence for every harness.

### Phase 2 - Test packet and manifest skeleton (P1)

**Scope/objective:** Build the test fixture under `harness-test/`.

**Key tasks:**

1. **(Small)** Create `source/synthetic-source-packet.md` per the synthetic task spec.
2. **(Small)** Hash the source packet into `source/protected-source-hash.txt`.
3. **(Medium)** Write the `_manifest.json` skeleton per the manifest schema above (orchestrator-only write).
4. **(Small)** Precompute unique artifact and log paths for every pass before launching anything.
5. **(Small)** Capture the pre-launch `git status --porcelain` baseline.

**Verification / exit criteria:** source packet, hash, and manifest skeleton exist; artifact paths are unique; every pass prompt names exactly one writable path; git baseline captured.

### Phase 3 - Parallel launch (P1)

**Scope/objective:** Launch available harnesses in parallel and record status without letting one failure stop the run.

**Key tasks:**

1. **(Medium)** Launch verified harnesses concurrently using their Phase 1 command shapes, embedding absolute source and artifact paths in each prompt.
2. **(Small)** Apply the 10-minute per-pass timeout.
3. **(Small)** Capture each pass's stdout/stderr or JSON events into its assigned log file.
4. **(Small)** After `wait` completes, the orchestrator writes final pass statuses (`complete`, `failed`, `timeout`, `unavailable`, `blocked`) to `_manifest.json` in a single pass — no per-pass concurrent manifest writes.
5. **(Small)** Run both isolation checks: re-hash the source packet, and diff `git status --porcelain` against the baseline. Fail the run if the hash changed or any path outside the run directory changed.

**Verification / exit criteria:** at least two real (non-stub) harnesses complete, all other harnesses carry honest statuses, and both isolation checks pass.

### Phase 4 - Synthesis and audit (P1)

**Scope/objective:** Prove that the orchestrator can consume multiple artifacts and produce one audit trail.

**Key tasks:**

1. **(Medium)** Read every completed artifact and validate required fields against the schema in the prompt.
2. **(Small)** Log malformed or missing artifacts in `_synthesis.md`; do not silently normalize.
3. **(Medium)** Cluster findings by evidence field and title similarity by manual review only; no embedding/fuzzy automation in this test.
4. **(Small)** Write `_synthesis.md` with pass statuses, common findings, single-source findings, conflicts, manifest-contract divergences, and lessons.
5. **(Small)** Update the parent implementation plan with a dated lessons addendum if the test changes the intended harness contract.

**Verification / exit criteria:** `_synthesis.md` exists, references every harness (including stubs, marked as such), and states whether the concept is ready for a reusable prototype launcher.

### Phase 5 - Follow-up plan decision and cleanup (P2)

**Scope/objective:** Decide whether to build the reusable prototype launcher, and settle the fate of the test outputs.

**Key tasks:**

1. **(Small)** If the concept passes, file a follow-up implementation plan under `00-project/plans/` for `fan-out-adversarial.sh`.
2. **(Small)** If the concept fails, file a short investigation note under `00-project/research/` identifying which harnesses blocked and why.
3. **(Small)** Record the cleanup decision for `runs/2026-07-04-harness-concept/` in the manifest `cleanup` field: keep in place as audit trail, or archive under `00-project/build/archive/`, and note the decision in the follow-up plan or changelog entry.
4. **(Small)** Do not promote anything into top-level workflow directories from this test.

**Verification / exit criteria:** follow-up decision and cleanup decision are recorded under `00-project/`; no top-level workflow files were created or edited.

## Risks and mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Harness is installed but only supports interactive use | Blocks automation | Mark `blocked` with evidence; manual-stub for manifest/synthesis shape validation only, `stub: true`, excluded from quorum. |
| Nested `claude` session conflicts | Hung or failed pass | Detached child process, explicit permission mode, own timeout; mark `blocked` on instability instead of retrying. |
| Concurrent writes corrupt `_manifest.json` | Invalid audit trail | Orchestrator is sole manifest writer; single write after `wait`. |
| A pass edits the protected source or other repo files | Invalid test | Source hash before/after **and** `git status --porcelain` diff scoped to the run directory. |
| Harness command syntax changes | Failed launch | Capture help/version output in `discovery/` first; command shapes recorded before launch. |
| Output schemas vary by model | Synthesis friction | Tiny required schema; log malformed artifacts instead of silently normalizing. |
| Credentials or model access missing | Partial run | Quorum is two real completions; represent missing access honestly in `_manifest.json`. |

## Out of scope

- Benchmarking model quality.
- Editing production workflow files.
- Creating persistent launcher defaults.
- Running expensive high-token research or review tasks.
- Embedding/fuzzy clustering automation.
- Writing outside the active target project's metadata tree (`00-project/` for Workflow-Scripts-system work, `<project-root>/project/` for consumer-project work).

## References

- `00-project/plans/2026-07-03-multi-model-plan-review-pass-system-implementation-plan.md` (parent: harness contract, manifest contract, model roster)
- `00-project/research/opencode-parameters.md` (opencode CLI flag reference, snapshot 2026-07-04)
- `00-Meta-Workflow/00-orchestrator/orchestrator-plan-review.md`
- `00-project-setup/01-setup-project.md`
- `00-Meta-Workflow/00-meta/severity-priority-rubric.md`
