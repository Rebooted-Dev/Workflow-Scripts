# 2026-07-04 00:00

# Parallel Agent Harness Concept Test - Implementation Plan

**Status:** Active (ready to execute)
**Parent plan:** `00-project/plans/2026-07-03-multi-model-plan-review-pass-system-implementation-plan.md`
**Purpose:** Prove that an orchestrator can launch parallel sub-agent passes through multiple harnesses, collect one artifact per pass, preserve protected files, and produce a manifest plus synthesis report.
**Project metadata root:** `00-project/` only because this plan tests changes to the Workflow-Scripts system itself. For consumer-project tests, the same layout belongs under that project's root-level `project/` directory.

## Summary

Run a small, low-risk concept test of the adversarial orchestration mechanism before implementing the full research/planning/review workflow system. The test uses a synthetic source packet and asks each harness to produce a tiny structured report. The orchestrator then verifies that each pass wrote exactly one assigned artifact, records statuses in `_manifest.json`, and writes `_synthesis.md`.

This test is about harness mechanics, isolation, and artifact discipline. It is not a quality benchmark for the models.

## Test scope

Harnesses to support:

| Harness | Required for pass? | Initial expectation |
|---|---:|---|
| `opencode` | yes, if installed/configured | Non-interactive CLI run with `opencode run`, positional prompt, `-m`, `--title`, `-f`, and `--format json` where supported. |
| `codex` | yes, if installed/configured | Non-interactive Codex CLI/subagent invocation; exact command must be discovered before launch. |
| `droid` | yes, if installed/configured | Non-interactive Droid agent invocation; exact command must be discovered before launch. |
| `claude` | yes, if installed/configured | Non-interactive Claude/Claude Code invocation; exact command must be discovered before launch. |
| `manual-stub` | fallback | If a harness is not installed or cannot run non-interactively, create a skipped status entry and use a manual stub only for manifest/synthesis shape validation. |

The concept test passes if at least two real harnesses complete successfully and every unavailable harness is represented honestly as `unavailable`, `skipped`, or `blocked` in the manifest.

## Artifact layout

For this Workflow-Scripts-system test, all files created by this test live under:

```text
00-project/build/adversarial-multi-model-workflow/harness-test/
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
        synthetic.review.general.opencode.<timestamp>.md
        synthetic.review.general.codex.<timestamp>.md
        synthetic.review.general.droid.<timestamp>.md
        synthetic.review.general.claude.<timestamp>.md
```

Do not create or edit files under `00-Meta-Workflow/`, `01-planning-and-organizing/`, or other top-level workflow directories during this test. For consumer-project runs, substitute `<consumer-project-root>/project/` for `00-project/` in the artifact layout above.

## Synthetic task

Create `synthetic-source-packet.md` with a deliberately small source packet:

- A short fake plan with three numbered claims.
- One obvious inconsistency that each pass should notice.
- One harmless ambiguity that may produce divergent recommendations.
- An instruction that the source packet is protected and must not be edited.

Each harness receives the same prompt:

```text
Read the attached synthetic source packet. Write one structured review artifact to the exact output path provided by the orchestrator. Do not edit the source packet or any other file.

Required fields:
- harness
- model
- status
- findings: list of {id, title, evidence, severity, priority, fix}
- notes
```

## Roadmap

### Phase 1 - Harness discovery (P1)

**Scope/objective:** Determine which requested harnesses are available locally and how to run them non-interactively.

**Key tasks:**

1. **(Small)** Check whether `opencode`, `codex`, `droid`, and `claude` are on `PATH`.
2. **(Small)** Capture each available harness version/help output into `00-project/build/adversarial-multi-model-workflow/harness-test/discovery/`.
3. **(Medium)** Record the safest non-interactive invocation shape for each harness, including model flag, prompt/file attachment support, output format, and timeout behavior.
4. **(Small)** Mark unavailable or interactive-only harnesses as `unavailable` or `blocked` in a discovery note rather than inventing a fake command.

**Verification / exit criteria:** discovery note exists and lists the command shape or blocked reason for every requested harness.

### Phase 2 - Test packet and manifest skeleton (P1)

**Scope/objective:** Build the test fixture under `00-project/build/...`.

**Key tasks:**

1. **(Small)** Create `source/synthetic-source-packet.md`.
2. **(Small)** Hash the source packet and write `source/protected-source-hash.txt`.
3. **(Medium)** Create a manifest skeleton with one pass per harness: `id`, `harness`, `model`, `role`, `artifact`, `log`, `status`, `exit`, and `started_at`.
4. **(Small)** Precompute unique output paths before launching any pass.

**Verification / exit criteria:** source packet exists, hash exists, output paths are unique, and no pass has write permission by prompt to any file except its assigned artifact.

### Phase 3 - Parallel launch (P1)

**Scope/objective:** Launch available harnesses in parallel and record status without letting one failure stop the run.

**Key tasks:**

1. **(Medium)** Launch available harnesses concurrently using their verified command shapes.
2. **(Small)** Apply a short timeout, default 10 minutes per pass.
3. **(Small)** Capture stdout/stderr or JSON events into the assigned log file.
4. **(Small)** Update `_manifest.json` with `complete`, `failed`, `timeout`, `unavailable`, or `blocked`.
5. **(Small)** Re-hash `synthetic-source-packet.md` after all passes complete and fail the run if the hash changed.

**Verification / exit criteria:** at least two real harnesses complete, all other harnesses have honest statuses, and the protected source hash matches.

### Phase 4 - Synthesis and audit (P1)

**Scope/objective:** Prove that the orchestrator can consume multiple artifacts and produce one audit trail.

**Key tasks:**

1. **(Medium)** Read every completed artifact and validate required fields.
2. **(Small)** Log malformed or missing artifacts in `_synthesis.md`.
3. **(Medium)** Cluster findings by evidence field and title similarity by manual review only; do not add embedding/fuzzy automation in this test.
4. **(Small)** Write `_synthesis.md` with pass statuses, common findings, single-source findings, conflicts, and lessons.
5. **(Small)** Update the parent implementation plan with a dated lessons addendum if the test changes the intended harness contract.

**Verification / exit criteria:** `_synthesis.md` exists, references every harness, and states whether the concept is ready for a reusable prototype launcher.

### Phase 5 - Follow-up plan decision (P2)

**Scope/objective:** Decide whether to build the reusable prototype launcher.

**Key tasks:**

1. **(Small)** If the concept passes, file a follow-up implementation plan under `00-project/plans/` for `fan-out-adversarial.sh`.
2. **(Small)** If the concept fails, file a short investigation note under `00-project/research/` identifying which harnesses blocked and why.
3. **(Small)** Do not promote anything into top-level workflow directories from this test.

**Verification / exit criteria:** follow-up decision is recorded under `00-project/`; no top-level workflow files were created or edited.

## Risks and mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Harness is installed but only supports interactive use | Blocks automation | Mark `blocked`; keep manual-stub for manifest validation only. |
| Harness command syntax changes | Failed launch | Capture help/version output first and keep command shape in discovery notes. |
| A pass edits the protected source | Invalid test | Hash source before/after and fail the run. |
| Output schemas vary by model | Synthesis friction | Use a tiny required schema and log malformed artifacts instead of silently normalizing. |
| Credentials or model access missing | Partial run | Require at least two real harness completions; represent missing access honestly in `_manifest.json`. |

## Out of scope

- Benchmarking model quality.
- Editing production workflow files.
- Creating persistent launcher defaults.
- Running expensive high-token research or review tasks.
- Writing outside the active target project's metadata tree (`00-project/` for Workflow-Scripts-system work, `<project-root>/project/` for consumer-project work).

## References

- `00-project/plans/2026-07-03-multi-model-plan-review-pass-system-implementation-plan.md`
- `00-project-setup/01-setup-project.md`
- `00-Meta-Workflow/00-orchestrator/orchestrator-plan-review.md`
- `00-project/research/opencode-parameters.md`

---

## 2026-07-04 11:43 - Plan Review (Model: claude-fable-5)

Findings verified against the live environment on 2026-07-04: all four harnesses (`opencode`, `codex`, `droid`, `claude`) are on `PATH`, and `opencode run --help` confirms `-m`, `--title`, `-f/--file`, and `--format json` exist as claimed. All referenced files exist (`00-project/plans/2026-07-03-multi-model-plan-review-pass-system-implementation-plan.md`, `00-project-setup/01-setup-project.md`, `00-Meta-Workflow/00-orchestrator/orchestrator-plan-review.md`, `00-project/research/opencode-parameters.md`).

### P1

1. **Concurrent manifest writes (S2/P1)**
   - **Rationale:** Phase 3 task 4 updates `_manifest.json` while passes run in parallel. If per-pass updates happen concurrently, writes can interleave and corrupt the JSON — the exact failure class the single-writer rule exists to prevent.
   - **Actionable fix:** Make the orchestrator the sole writer of `_manifest.json`. Record per-pass results in per-pass status files (or in-memory) and write the manifest once after `wait` completes, plus at most one pre-launch skeleton write.

2. **Protection covers only one file (S2/P1)**
   - **Rationale:** Hashing `synthetic-source-packet.md` detects tampering with that file only. A misbehaving pass could edit any other repo file (workflow docs, other passes' artifacts) undetected. Workflow-Scripts is a git repo, so full-tree detection is free.
   - **Actionable fix:** Capture `git status --porcelain` before launch and after all passes complete; fail the run if any path outside `00-project/build/adversarial-multi-model-workflow/harness-test/runs/<run-id>/` changed. Keep the source hash check as a secondary explicit guard.

3. **Nested `claude` invocation risk (S2/P1)**
   - **Rationale:** The plan will likely be executed from inside a Claude Code session. Launching `claude` non-interactively from within another `claude` session can hit session/permission conflicts, and the default interactive permission prompts will hang a headless run.
   - **Actionable fix:** Specify the invocation up front: `claude -p "<prompt>" --output-format json` with an explicit permission mode restricted to writing the assigned artifact path, launched as a detached child process with its own timeout. If it proves unstable when nested, mark the pass `blocked` with the observed error rather than retrying.

4. **Stub passes vs. quorum ambiguity (S3/P1)**
   - **Rationale:** `manual-stub` artifacts exist to validate manifest/synthesis shape, but the pass criterion is "at least two real harnesses complete." The plan implies but never states that stubs are excluded from that count.
   - **Actionable fix:** Add `stub: true` to stub manifest entries and state explicitly that stub passes never count toward the two-real-completion quorum.

5. **Artifact-path and source delivery unspecified per harness (S3/P1)**
   - **Rationale:** The shared prompt says "the exact output path provided by the orchestrator," but only `opencode` has a verified file-attach flag (`-f`). How codex/droid/claude receive the source packet and output path is undefined.
   - **Actionable fix:** Use the lowest common denominator: embed the absolute source-packet path and absolute output artifact path directly in the prompt text for every harness; treat `-f` attachment as an opencode-only optimization.

### P2

6. **Phase 1 discovery is partially complete (S3/P2)**
   - **Rationale:** All four harnesses are already confirmed on `PATH`, and the opencode command shape is verified against `opencode run --help` (2026-07-04). Re-discovering this is wasted effort.
   - **Actionable fix:** Narrow Phase 1 to (a) capturing version/help output for the record and (b) verifying non-interactive invocation shape for `codex`, `droid`, and `claude` only.

7. **Timeout diverges silently from parent contract (S3/P2)**
   - **Rationale:** Parent plan specifies a default 30-minute pass timeout; this test uses 10 minutes without noting the divergence, which could be read as a contract change.
   - **Actionable fix:** State that 10 minutes is an intentional test-scale override and the parent contract default remains 30 minutes.

8. **Manifest schema diverges from parent contract (S3/P2)**
   - **Rationale:** Parent manifest contract includes `findings_or_claims`, quorum, timeout, and cleanup decision; the test skeleton omits them. Unnoted divergence weakens the test's value as a contract rehearsal.
   - **Actionable fix:** Add run-level `timeout`, `quorum`, and `cleanup` fields to the skeleton (cheap), and record any remaining field divergence as an explicit lesson in `_synthesis.md`.

9. **Artifact timestamp format undefined (S3/P2)**
   - **Actionable fix:** Fix the format as `YYYY-MM-DD-HH-MM`, matching the `PLAN.reviews` naming convention already used by `01-plan-review.md`.

### P3

10. **`discovery/` missing from artifact layout tree (S3/P3):** Phase 1 writes to `harness-test/discovery/` but the layout diagram omits it. Add it to the tree.
11. **No cleanup decision for test outputs (S3/P3):** Phase 5 decides the follow-up plan but not the fate of `runs/` artifacts. Add a small task: keep as audit trail or archive, recorded in the manifest `cleanup` field.

### Over-engineering check

The plan is well-bounded: manual clustering only, no embedding automation, no persistent launcher defaults, explicit out-of-scope list. No items exceed the stated goal; no MVP reduction needed.

