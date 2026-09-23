# Astra Setup-Instruction Audit

**Date:** 2026-09-22  
**Status:** Read-only planning input; no experiment or live instruction change performed

## Purpose and evidence discipline

This note audits the instructions that a future Astra evaluation may generate and consume. It does not recover or replace the historical protocol, report experiment outcomes, select an arm, or authorize changes to live AGENTS/setup files. Claims are classified as `Astra fact`, `harness-specific`, `local observation`, `hypothesis`, or `experiment result`; this note contains no experiment results.

## Verified first-party sources

- **Astra fact:** [GPT-6 Astra guide](https://developers.openai.com/api/docs/guides/latest-model/gpt-6-astra.md), accessed 2026-09-22. The guide recommends auditing accessible instructions and warns that Astra is sensitive to skills and AGENTS guidance; unclear or conflicting instructions can cause pauses or blocks; it tends to under-delegate and may over-test small changes. These facts motivate attribution tests, not a blanket diagnosis of any local behavior.
- **Astra fact:** [GPT-6 Astra model page](https://developers.openai.com/api/docs/models/gpt-6-astra), accessed 2026-09-22. The exact model ID is `gpt-6-astra`. `openai/gpt-6-astra` is recorded separately as a provider/harness identity when applicable. Public documentation does not establish runtime access.
- **Astra fact:** the planned API contract uses Responses for tool calling. Unsupported `temperature`, `top_p`, and `top_logprobs` controls must not be fabricated, and there is no supported temperature-zero Astra configuration. Use supported effort `low`, `medium`, `high`, `xhigh`, or `max`; hold effective effort fixed, record an omitted request setting as omitted, and record the resolved default if observable. `none` is unsupported and omission is not equivalent to `none`; an unobservable default remains unknown.
- **Harness-specific boundary:** [Codex agent configuration](https://developers.openai.com/codex/agent-configuration/agents-md), accessed 2026-09-22, documents Codex AGENTS hierarchy and a 32 KiB `project_doc_max_bytes` default. Those mechanics are not evidence about OpenCode or another harness and must not be copied into the evaluation as universal loading rules.

### Short exact excerpts from the Astra guide

Accessed 2026-09-22; section names identify the source locations. These quotes ground hypotheses and do not claim observed degradation:

- **Instruction following:** “It can be more sensitive to instructions contained in skills and other files, such as `AGENTS.md`.” ([source section](https://developers.openai.com/api/docs/guides/latest-model/gpt-6-astra.md#instruction-following))
- **Instruction following:** “For example, unclear or conflicting guidance in a skill file may cause the model to pause and block work early.” ([source section](https://developers.openai.com/api/docs/guides/latest-model/gpt-6-astra.md#instruction-following))
- **Testing and verification:** “For smaller tasks, this can result in broader tests than the task requires.” ([source section](https://developers.openai.com/api/docs/guides/latest-model/gpt-6-astra.md#testing-and-verification))

## Concrete local observations

The following are local documentation facts, not Astra behavior claims:

1. [`01-setup-project.md`](../../../00-project-setup/01-setup-project.md) §“Updating an existing project that already uses this system” (lines 128–158) tells an existing-project AGENTS/setup update to preserve existing changelog/troubleshooting indexes, project-specific content, and unrelated files rather than rerun initial setup. §1.1/§1.2 (lines 245–264) keeps root AGENTS content slim and uses calibrated delegation. §2.10.1–§2.10.2 (lines 1021–1094) defines generated CLAUDE/GEMINI guidance that refers back to AGENTS; §2.11 (lines 1142–1157) follows generation with repo-map discovery.
2. [`04-track-repos-and-agent-map.md`](../../../00-project-setup/04-track-repos-and-agent-map.md) §2.1 (lines 84–129) permits either identical inline repo-map content in AGENTS/CLAUDE/GEMINI or a canonical document with identical short links. §2.4 (lines 150–170) defines the synchronization checks. The existence of two supported shapes is not itself a contradiction; the experiment must inventory which shape was generated and actually loaded.
3. [`workflow-applicability.md`](../../../00-Meta-Workflow/00-meta/workflow-applicability.md) §Authority layers (lines 5–13) establishes user → host AGENTS → selected workflow authority; §Task sizing and delegation (lines 15–25) sizes localized/bounded/broad work and says examples are non-normative unless marked required. This supports testing authority and scope rather than assuming every example is active policy.
4. The setup material's existing-project and generated-agent guidance (01-setup-project.md lines 128–158 and 1021–1094) mandates changelog/troubleshooting behavior in applicable situations. That is valid policy cost. It must be measured as required work and evaluated separately from discretionary ceremony; it must not be labeled unnecessary merely because it adds steps.

## Local risk hypotheses and coverage gaps

These are hypotheses for the evaluation, not findings:

- A generation agent may overwrite or omit consumer-specific rules, indexes, links, or unrelated content when asked to create a standard setup. Test identical synthetic fresh and existing projects and score artifacts before any session consumes them.
- Repeated AGENTS/CLAUDE/GEMINI guidance may appear more influential than it is if only one copy is loaded, or less influential than expected if linked/nested/global guidance is omitted. Capture read/load traces and separate generated-content quality from fresh-session consumption.
- Inline and canonical repo-map variants may produce different link/repo-scope behavior. Test the selected local variant and preserve the other as a documented coverage gap unless budget approves a paired case.
- A model may under-delegate useful independent work or delegate trivial work whose coordination cost dominates. Pair a meaningful regression fix with a trivial direct task and count subagent cost, not just call count.
- Missing tools or skills, delegation limits, nested guidance, untrusted docs, user restrictions, and system/developer/tool authority may be confused by a single attribution prompt. Freeze observable layers, disclose opaque layers, and use the same diagnostic prompt for both variants or a separate diagnostic rerun.
- Verification may be skipped for meaningful changes or performed excessively for trivial changes. Test both and classify required policy verification separately from avoidable ceremony.
- A non-JavaScript project may receive fabricated JavaScript commands from generic setup/build guidance. Include a non-JavaScript fixture with explicit command discovery checks.

Coverage is incomplete until Plan 01 recovers the protocol. The future map must retain all eight protocol tasks, including the historical pilot emphasis on tasks 3/4/7/8. Only a selected current-v1.82 arm with an approved supplement may add the supplemental cases listed in Plan 05; a historical arm remains unchanged unless a separate extension is approved and separately scored. The map must not turn every factor into a combinatorial matrix.

## Recommendations to Plan 05

- Preserve the blocked state until protocol provenance checks pass and one arm is explicitly selected. The current-v1.82 arm is recommended for consideration, not selected. The historical `64acb75` versus `5f87cc9` pair answers only its historical question; no third silent baseline is permitted, and relative non-degradation is not proof of no absolute harm.
- If the current-v1.82 arm is selected and its supplement is approved, treat setup as two stages: generate outputs in identical fresh/existing synthetic projects while preserving custom rules/indexes/unrelated content, then have fresh sessions consume unmodified outputs. Record generation and consumption variance separately; setup failure is an outcome and repairs are not allowed before scoring. Keep historical-arm runs on the recovered protocol unchanged unless a separately approved extension is required.
- Freeze the whole effective stack and API/runtime configuration, including linked guidance, skills, caches, compaction, context, subagents, permissions, and opaque layers. Manipulate only the instruction delta; do not pool separate reasoning or harness tests.
- Prefer two approved immutable revisions. Because the live checkout is dirty, never pretend `HEAD` captures it and never mutate it to pin a revision. If authorized, export base plus patch/untracked manifests, hashes, and exclusions in isolation.
- Use default-deny isolation with disposable HOME/env/cache, synthetic secrets, no live mounts, symlink-boundary checks, approved endpoint allowlisting, and logs for attempted as well as prevented violations. Keep provider keys out of fixtures.
- Freeze and preregister quality non-inferiority, critical safety blockers, minimum meaningful efficiency/blocking gain, repetitions, paired randomization, an uncertainty-bound criterion against the approved margin, retries/invalids, budget, and stopping. A nonsignificant difference is not non-inferiority, and safety blockers are independent of efficiency. A budget-limited pilot is exploratory; underpowered evidence is inconclusive. Use deterministic checks and blinded human review before any optional calibrated grader.
- Count total tokens/cost/time including subagents, retrieval, setup, and required policy work. Do not equate fewer calls or shorter roots with quality, and do not let aggregate scores hide task-class regressions. Zero failures is not proof of safety.
- Adopt only on maintained quality/safety plus the preregistered efficiency/blocking gain. Otherwise report failed or inconclusive relative evidence, make no universal Astra claim, and require a separate approval/plan for any live instruction rewrite.

## Related records

- Evaluation plan: [`05-run-astra-instruction-evaluation.md`](../../plans/v1.82-fixes/05-run-astra-instruction-evaluation.md)
- Current source plan: [`2026-09-10-astra-instruction-evaluation-plan.md`](2026-09-10-astra-instruction-evaluation-plan.md)
- Protocol recovery gate: [`01-reconcile-research-and-source-integrity.md`](../../plans/v1.82-fixes/01-reconcile-research-and-source-integrity.md)
- Sizing and authority: [`workflow-applicability.md`](../../../00-Meta-Workflow/00-meta/workflow-applicability.md)
