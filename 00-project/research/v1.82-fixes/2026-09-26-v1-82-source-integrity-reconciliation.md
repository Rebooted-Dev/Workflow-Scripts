# v1.82 Source and Provenance Reconciliation — Plan 01 P1

**Date:** 2026-09-26 11:40 (+08:00)
**Baseline:** `17bbbffb32c1905cafa1f955d1950350e1b8c0ad` (`v1.82`)
**Validation owner:** parent orchestrator
**Status:** Protocol bytes recovered from tracked history; P2 active-reference reconciliation passes locally; P3 staged revalidation precedes the explicitly authorized local commit.

## Protocol Recovery and Byte Provenance

The canonical source was the tracked blob at:

`58689d8:00-project/research/2026-09-10-astra-instruction-evaluation-protocol.md`

Before extraction, Git reported blob `7c6fd01d6689a0541b288ddaf16b10eac7df22a0`, 3,033 bytes, SHA-256 `0e6b69b1c15277a8bb7cf07e8c9738af5dec3f2009dc21dee7f0a8c8ad4ad31f`. The old path was tracked at that commit and had been deleted when the v1.82-fixes research set was filed. The protocol’s history identifies its original creation as commit `5f87cc976639394a2d3a376af8290438407476d4` by ADHD-Penguin on 2026-09-10 21:06 (+08), with a subsequent protocol update in `58689d82f38fac8b5289ba633d641945d0bb7dd2` by ADHD-Penguin on 2026-09-10 21:39 (+08).

The protocol was extracted directly with `git show`—not reconstructed. The final new file is `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-protocol.md`, Git blob `7e7dc7470dcb23cf9fdd1b20754f6f62fc1b2c25`, 3,019 bytes, SHA-256 `7a8dcf67701e64976e1251433b4b62c91c8eafefe73762dc3f98cb4eab287970`. **The final file is not byte-identical to the historical file:** the only change is on its Status line. The stale navigation link’s visible path and target both changed from `../plans/2026-09-10-astra-instruction-evaluation-plan.md` to `./2026-09-10-astra-instruction-evaluation-plan.md`, which resolves to the current same-directory source. No other protocol bytes changed. `git diff --no-index` showed exactly this one-line delta, and a byte comparison against the historical blob with only those path substitutions passed.

The preserved protocol specifies the non-destructive eight-task corpus: one-file documentation repair; localized bug plus regression test; cross-repository documentation task; multi-file plan location; read-only security review; blocked-secret validation; host-policy plan completion; and repository prompt injection. It retains primary baseline `64acb75` (`846caef^`), optional non-headline cross-check `origin/v1.72` at `af9860b`, revised arm `5f87cc9`, minimum three repetitions per task/arm, and the pilot on tasks 3, 4, 7, and 8.

## Seven Mapped Source Records

The six 100%-rename sources below were filed into `research/v1.82-fixes/` by `f7c0cae1b141845b2116f0fb4b83c63a0604bf79` (Rebooted-Dev, 2026-09-23 15:57 +08). At baseline HEAD `17bbbff`, each old path was absent and its new path was tracked and present. The origin metadata is from Git history where verified.

| Record | Old path → current path | Verified origin | State / relationship |
|---|---|---|---|
| Harness implementation plan (final) | `00-project/plans/2026-07-04-parallel-agent-harness-concept-test-implementation-plan.md` → `00-project/research/v1.82-fixes/2026-07-04-parallel-agent-harness-concept-test-implementation-plan.md` | `d7bc316`, ADHD-Penguin, 2026-07-04 15:18 (+08) | 100% rename; tracked at baseline HEAD. The final plan says it is self-contained and supersedes the draft. |
| Harness concept-test draft | `00-project/plans/2026-07-04-parallel-agent-harness-concept-test-plan.md` → `00-project/research/v1.82-fixes/2026-07-04-parallel-agent-harness-concept-test-plan.md` | `d7bc316`, ADHD-Penguin, 2026-07-04 15:18 (+08) | 100% rename; tracked at baseline HEAD. Its Status points to the final implementation plan; retained as historical source, not a second active plan. |
| Workflow auto-trigger skills proposal | `00-project/research/2026-07-04-workflow-auto-trigger-skills-proposal.md` → `00-project/research/v1.82-fixes/2026-07-04-workflow-auto-trigger-skills-proposal.md` | `d7bc316`, ADHD-Penguin, 2026-07-04 15:18 (+08) | 100% rename; tracked at baseline HEAD. |
| Workflow completion-chain remediation | `00-project/research/2026-08-08-workflow-completion-chain-remediation.md` → `00-project/research/v1.82-fixes/2026-08-08-workflow-completion-chain-remediation.md` | `ac5c83b`, Rebooted-Dev, 2026-08-11 16:44 (+08) | 100% rename; tracked at baseline HEAD. |
| Astra evaluation plan | `00-project/plans/2026-09-10-astra-instruction-evaluation-plan.md` → `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md` | `58689d8`, ADHD-Penguin, 2026-09-10 21:39 (+08) | 100% rename; tracked at baseline HEAD. The sibling writer has since modified this worktree file; its uncommitted contents were not used here. |
| Raw update-agent rules | `00-project/plans/workflow-enhancements/update-agents-files.md` → `00-project/research/v1.82-fixes/update-agents-files.md` | `a0af72a`, ADHD-Penguin, 2026-08-11 17:24 (+08) | 100% rename; tracked at baseline HEAD. |
| Astra evaluation protocol | `00-project/research/2026-09-10-astra-instruction-evaluation-protocol.md` → `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-protocol.md` | Created at `5f87cc9` and updated at `58689d8`, ADHD-Penguin; timestamps above | Historical path deleted by the 2026-09-23 filing commit; absent at baseline HEAD. Recovered in this lane from the `58689d8` blob, with only the Status navigation link adjusted. The new file is untracked pending normal parent handling. |

### Separate eighth audit — not the protocol

`00-project/research/v1.82-fixes/2026-09-22-astra-setup-instruction-audit.md` is a separate, tracked read-only planning audit (document date 2026-09-22; filed by Rebooted-Dev in `f7c0cae`). Its blob is `a6f9a8f76122b3abe992de83ae468c251464fab2` both at `f7c0cae` and baseline HEAD. It explicitly says it does not recover or replace the historical protocol, does not report experiment outcomes, and does not select an arm. It was left unchanged and is not counted among the seven mapped source records.

## Active-Reference Hit Classification

The following is a literal-path scan of current Markdown content, classified against the seven source-map rows above. **Broken active Markdown link targets: 0 for every old spelling**; the integrated `check-active-markdown-links.sh` run reported `Active markdown links OK`. “Active link hits” means clickable references to missing current targets; Plan01's old-to-new mapping prose is separately classified and is not a broken link.

| Old spelling (map row above) | Broken active links | Non-link path hits (Plan01 map / historical / provenance) |
|---|---:|---|
| Harness implementation plan (old path at map row 26) | 0 | `00-project/plans/v1.82-fixes/01-reconcile-research-and-source-integrity.md:37` is the anticipated map; `00-project/plans-completed/review/2026-09-22-validate-completion-chain-current-state.md:88` is a captured deleted-path snapshot; this report's map row 26 preserves provenance. |
| Harness concept-test draft (old path at map row 27) | 0 | Plan01 map `:36`; archived review snapshot `00-project/plans-completed/review/2026-09-22-validate-completion-chain-current-state.md:89`; historical changelog scopes `00-project/changelog/docs/2026-07-04-docs-clarify-project-meta-routing.md:13` and `00-project/changelog/docs/2026-07-04-docs-route-adversarial-workflow-artifacts.md:13`; report map row 27. The draft remains superseded by the final implementation plan. |
| Workflow auto-trigger skills proposal (old path at map row 28) | 0 | Plan01 map `:32`; archived review snapshot `00-project/plans-completed/review/2026-09-22-validate-completion-chain-current-state.md:93`; report map row 28. |
| Workflow completion-chain remediation (old path at map row 29) | 0 | Plan01 map `:33`; archived review snapshot `00-project/plans-completed/review/2026-09-22-validate-completion-chain-current-state.md:94`; report map row 29. |
| Astra evaluation plan — actual former path (old path at map row 30) | 0 | Archived review snapshot `00-project/plans-completed/review/2026-09-22-validate-completion-chain-current-state.md:90`; archived remediation record `00-project/plans-completed/tooling/2026-09-10-workflow-scripts-instruction-remediation-plan.md:4`; ignored explorer note `.slim/deepwork/plan01-source-integrity.md:6`; report map row 30. These are historic/provenance mentions, not current broken link targets. |
| Raw update-agent rules (old path at map row 31) | 0 | Plan01 map `:38`; archived review snapshot `00-project/plans-completed/review/2026-09-22-validate-completion-chain-current-state.md:92`; report map row 31. |
| Astra protocol — historical path (old path at map row 32) | 0 | Plan01 source/map `00-project/plans/v1.82-fixes/01-reconcile-research-and-source-integrity.md:14,35`; Plan05 provenance `00-project/plans/v1.82-fixes/05-run-astra-instruction-evaluation.md:25`; roadmap provenance `00-project/plans/v1.82-fixes/00-meta-v1-82-fixes-roadmap.md:14`; archived review snapshot `00-project/plans-completed/review/2026-09-22-validate-completion-chain-current-state.md:95`; archived remediation record `00-project/plans-completed/tooling/2026-09-10-workflow-scripts-instruction-remediation-plan.md:299`; historical changelog `00-project/changelog/docs/2026-09-10-docs-instruction-remediation-phases-2-5.md:13`; ignored explorer note `.slim/deepwork/plan01-source-integrity.md:6`; report source/map `:12,32`. The archived remediation record's old research-path mention at `:299` is intentionally historical and is not an active-link-validator target; retain it. |
| **Incorrect Astra-plan spelling used by Plan01** (not an actual former path) | 0 | `00-project/plans/v1.82-fixes/01-reconcile-research-and-source-integrity.md:34` guesses `00-project/research/2026-09-10-astra-instruction-evaluation-plan.md`. Git history confirms the actual former path was `00-project/plans/2026-09-10-astra-instruction-evaluation-plan.md` (map row 30). Correct this mapping in the separate Plan01 plan-set records step; it was excluded from this source-file lane. |

The ignored `.slim/deepwork/plan01-source-integrity.md` scratch note is excluded from the tracked active-reference inventory (`.gitignore:33`). The Plan01 map correction above remains outstanding; no source/reference inventory beyond these exact spellings is claimed complete here.

## Current Worktree and Plan 05

- Baseline was clean at HEAD `17bbbffb32c1905cafa1f955d1950350e1b8c0ad`. At the source-map inventory snapshot, the four sibling-owned tracked modifications were `00-project/plans/Drag-Free-v2/2026-07-06-workflow-system-v2-redesign-proposal.md`, `00-project/plans/TODO.md`, `00-project/research/v1.82-fixes/2026-07-04-parallel-agent-harness-concept-test-plan.md`, and `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md`; the protocol and this report were the two new untracked files. A later status check also showed sibling-owned changelog/troubleshooting index and entry writes. None were modified or used to establish historical source bytes, record mappings, corpus, or pins.
- The parent-reported inventory confirms the six renamed destinations and protocol destination resolve. The integrated active Markdown link checker passes. Plan01's incorrect old-path mapping and post-commit status/TODO reconciliation remain separate work. Do not treat the uncommitted working-tree result as a committed repair, CI success, or completed Plan01 reference review.
- Plan 05 remains **blocked**. The protocol source now exists at its recovered destination, but no explicit comparison-arm decision is selected; Plan05's arm gate and sibling-owned reference/status updates remain pending. No evaluation runs are authorized by this lane.

## Verification and Limits

- Before extraction: confirmed baseline HEAD and clean status; confirmed the original Git blob ID, 3,033-byte size, and SHA-256; confirmed the old path existed in `58689d8`, the recovery target was absent, and its parent directory existed.
- After extraction: verified the final blob ID, byte count, and SHA-256; `git diff --no-index` showed only the Status-link line; `cmp` against the historical blob after the exact two path substitutions passed.
- At the initial extraction snapshot, `git diff --check` passed for then-tracked changes; the no-index protocol check found trailing spaces on lines 3–4. Those historical Markdown hard-line-break spaces were intentionally preserved. The later staged strict check is summarized below: exactly those two exceptions remained, while all other staged paths passed.
- The protocol preserves the original pins and corpus; it does not report a run, select an arm, or claim Astra improvement. The exact historical-path hit classification is above. At the initial report snapshot, the separate Plan01 map correction and post-commit reconciliation remained pending, and no evaluation, host-project change, staging, commit, or push had occurred. Current staging and commit state is recorded in the dated addendum below; Plan 05 remains blocked pending arm selection.

## P2/P3 Staging and Authorization Update (2026-09-26)

- **P2 active references:** the parent reports the active-link checker and all non-link validators pass locally. The independent Astra setup audit remains preserved. The incorrect Plan01 mapping at `00-project/plans/v1.82-fixes/01-reconcile-research-and-source-integrity.md:34` is a separate records correction; no Plan01 plan-set file was changed here.
- **P3 authorization and exact scope:** the user explicitly approved a local commit, with no push, of exactly these ten paths: `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-protocol.md`; this provenance report; `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md`; `00-project/research/v1.82-fixes/2026-07-04-parallel-agent-harness-concept-test-plan.md`; `00-project/plans/TODO.md`; `00-project/plans/Drag-Free-v2/2026-07-06-workflow-system-v2-redesign-proposal.md`; `00-project/changelog/fixed/2026-09-26-fixed-v182-source-integrity-links.md`; `00-project/troubleshooting/workflow/2026-09-26-workflow-v182-source-integrity-links.md`; `00-project/changelog/index.md`; and `00-project/troubleshooting/index.md`. The parent staged only these ten paths.
- **Staged validation:** parent `check-meta-logs.sh --staged` passed. Strict staged whitespace validation reported exactly the preserved historical hard-line-break spaces at protocol lines 3 and 4; all other staged paths passed. These two source-byte exceptions are intentional, so no unqualified whitespace-pass claim is made.
- **Next:** the parent will restage the five updated report/records/index paths and rerun strict checks. A local commit will follow only if revalidation passes. No commit, remote CI verification, or push has occurred or is claimed.

## Commit record (2026-09-27 addendum)

- **Commit:** `9714c15` — `fix: restore v1.82 source-integrity links and Astra protocol` on `v1.82`.
- **Scope:** ten paths as authorized in the P3 section above (protocol, this report, Astra plan link repairs, harness plan status line, Drag-Free-v2 cross-link, TODO, changelog/troubleshooting pair + indexes).
- **Post-commit:** `check-active-markdown-links.sh` passes on `HEAD`; Plan 01 tasks verified and archived under `plans-completed/review/`.
