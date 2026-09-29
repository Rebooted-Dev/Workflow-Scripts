# Implementation Plan: Conditional Claude Code research-subagent model routing

**Created:** 2026-09-27 23:03  
**Revised:** 2026-09-28 — narrowed agent capabilities, added a bounded pre-release compatibility gate and safe migration rules, and corrected future fix logging (see Revision note). A feasibility review is appended; it does not change the tasks.  
**Status:** DRAFT  
**Tier:** T2

**Consolidated from:** the "Recommended fix" section of [`../research/2026-09-27-claude-md-model-routing-instructions-gap.md`](../research/2026-09-27-claude-md-model-routing-instructions-gap.md), its Plan Review addendum, the owner's follow-up about Claude Code, and [`../research/2026-09-27-claude-code-subagent-routing-prior-art.md`](../research/2026-09-27-claude-code-subagent-routing-prior-art.md). No `PLAN.reviews/` directory exists; nothing to archive.

## Revision note

This revision tightens the earlier proposal rather than recording implementation or runtime evidence:

- Both candidate agent definitions now use the documented `tools: Read, Grep, Glob` allowlist. Their scope is repository files, existing text logs, and static code paths; commands, tests, MCP, git history, and runtime/environment evidence are outside their capabilities and must be collected by the task owner if needed.
- Read-only behavior is bounded by the actual tool allowlist, not by `disallowedTools` or prose alone. The task-owning main agent owns integration and validation, while an authorized implementer may edit when assigned.
- A bounded scratch compatibility gate for **both** agents must pass in default Opus before the definitions propagate into setup instructions. Fable and `opusplan` are checked when accessible. Any fallback is configuration-specific and tested; a default Opus frontmatter failure stops the rollout and reopens the decision even if explicit-model calls work.
- Migration inspects each definition independently, preserves compatible/custom content, warns rather than overwrites malformed or incompatible files, and reconciles the pointer independently only when both definitions are compatible. Warning checks inspect actual YAML frontmatter and repeat on upgrades.
- The future implementation's Task 10 is classified as a workflow fix and requires a `fixed` changelog entry, a workflow troubleshooting entry, and both indexes. This plan-only revision instead gets a separate `docs` changelog entry and no troubleshooting entry.

**Plan-only status:** no setup workflow or template files were changed; no scratch project or Claude Code session was run; no compatibility result is claimed. All implementation tasks below remain unchecked.

## Summary

The setup workflow identifies model selection as a harness concern but does not create or verify project research-subagent definitions. This plan proposes conditional Claude Code definitions for `sweeper` (`model: haiku`) and `tracer` (`model: sonnet`), with an actual read-only `Read, Grep, Glob` tool allowlist, a short conditional `CLAUDE.md` pointer, safe update behavior, warning-only structural checks, and reciprocal documentation links. Rollout is gated on a bounded scratch check proving both aliases resolve as intended in the default Opus configuration.

## Goal

For a project that uses Claude Code research subagents and whose workflow authorizes delegation, setup/update can provide `.claude/agents/sweeper.md` with `model: haiku` and `.claude/agents/tracer.md` with `model: sonnet`. The optional `CLAUDE.md` pointer is conditional, no more than three bullets, and says not to pass `model` except for a tested fallback specific to that exact Claude Code version, provider, and mode. The token-efficiency source and setup workflow link to each other without changing the existing skill routing table.

## Scope and non-goals

**Future implementation scope (Workflow-Scripts only):**

- `00-project-setup/01-setup-project.md`: Step 1.1 file table; §2.10.1 `CLAUDE.md` pointer; §2.10.3 migration/update behavior; new §2.10.4 agent definitions and compatibility guidance; quick update and setup checklists; §3.6 warning-only verification.
- `00-Meta-Workflow/00-token-efficiency/fable-token-savings.md`: one reciprocal reference to the setup workflow. Preserve the existing model-routing policy and table unchanged.
- `00-project-setup/05-mcp-and-config-setup.md`: one reference to the Claude Code-specific setup section, as in the original scope.
- `00-project/changelog/fixed/<date>-fixed-claude-code-subagent-model-routing.md` and `00-project/troubleshooting/workflow/<date>-workflow-claude-code-subagent-model-routing.md`, with rows in `00-project/changelog/index.md` and `00-project/troubleshooting/index.md` (future Task 10).
- Plan completion filing under `00-project/plans-completed/implementation/` and its required indexes after successful implementation (future Task 10).

**This revision's permitted file scope only:** this plan, a new dated `00-project/changelog/docs/` entry for the plan-only revision, and a new row at the top of `00-project/changelog/index.md`.

**Non-goals:**

- Editing host projects, including Flash-UI's `CLAUDE.md` or `.claude/`; that requires the host owner's decision and a separate host-project log.
- Editing setup workflow/template files in this plan-revision task, or claiming any runtime test or implementation has occurred.
- Changing the token-efficiency routing table or its `reviewer` / `implementer` policy.
- Replacing built-in `Explore`, setting global/subagent-model environment variables, or routing other harnesses.
- An open-ended host pilot. Compatibility work is a bounded pre-release scratch check only.

## Assumptions and constraints

- Claude Code documents project agent definitions with model aliases and a `tools` allowlist. Preserve the aliases `haiku` and `sonnet`; do not introduce pinned model-version names.
- Both agent examples use the documented `tools: Read, Grep, Glob` allowlist. This allowlist is the actual read-only tool boundary in the definition. Agent prose reinforces scope but is not an enforcement mechanism; `disallowedTools` alone is not accepted as proof that an agent cannot write.
- Research agents are selected only when delegation is already authorized by the project's `AGENTS.md` or the selected workflow. Their descriptions do not create delegation authority.
- A research agent cannot provide evidence requiring unavailable capabilities. It must name the missing evidence and return that need to the parent/task owner; the task owner may collect it using separately authorized tools.
- Frontmatter model selection is not assumed to work merely because the YAML contains an alias. The pre-release gate below must observe each agent's actual runtime model.
- No runtime compatibility outcome is known yet. Fable or `opusplan` being inaccessible during the bounded check is `NOT RUN`, not a failed test and not a blocker to a validated default-Opus rollout; adoption in an untested mode requires checking that mode first.
- Main/task ownership means the task-owning main agent is accountable for evidence integration and validation. It does not prohibit an authorized implementer role from editing assigned files.

## Change Surface

| Behavior | Planned site | Class | Future verification |
|---|---|---|---|
| Claude Code agent definition discovery | `00-project-setup/01-setup-project.md`, Step 1.1 | implements | Confirm the `.claude/agents/*.md` row is conditional on Claude Code research-subagent use. |
| Agent definitions and model aliases | `00-project-setup/01-setup-project.md`, §2.10.4 | implements | Inspect both YAML frontmatters for name, description, alias, and `tools: Read, Grep, Glob`. |
| Conditional `CLAUDE.md` pointer | `00-project-setup/01-setup-project.md`, §2.10.1 | implements | At most three bullets; delegation condition, no untested model override, task-owner integration/validation statement. |
| Per-file migration and independent pointer reconciliation | `00-project-setup/01-setup-project.md`, §2.10.3 and update path | implements | Fixture matrix covers preservation, warnings, approved-patch proposals, deduplication, and idempotence. |
| Warning-only definition check | `00-project-setup/01-setup-project.md`, migration check and §3.6 | guards | Inspect actual YAML frontmatter fields; malformed/missing/incompatible state warns and never blocks. |
| Token-efficiency and MCP/config references | `00-Meta-Workflow/00-token-efficiency/fable-token-savings.md`, `00-project-setup/01-setup-project.md`, and `00-project-setup/05-mcp-and-config-setup.md` | documents | One reciprocal reference each way between the first two; one pointer in the MCP/config guide; routing table has no changes. |
| Workflow-fix record (future implementation) | `00-project/changelog/fixed/`, `00-project/troubleshooting/workflow/` and both indexes | records | `check-meta-logs.sh` validates the paired entries and indexes. |
| Plan-only record (this revision) | New dated file in `00-project/changelog/docs/` and `00-project/changelog/index.md` | records | Separate from future fix logs; no troubleshooting entry. |

## Decision

- **Option A (minimal) — routing prose alone:** rejected. It is advisory and can be displaced by a per-invocation model argument.
- **Option B — two project agent definitions:** preferred only after the bounded compatibility gate validates default Opus. Use aliases in frontmatter and an actual tool allowlist; use the conditional pointer to describe invocation policy, not to claim enforcement.
- **Hook enforcement:** deferred. Prior-art reports do not justify relying on hook input rewriting as a stable enforcement path.
- **`Explore` override:** deferred. Replacing a built-in agent has separate quality and maintenance risks.
- **Chosen conditional decision:** proceed with Option B only if both definitions run on their declared aliases in default Opus without an explicit per-invocation `model`. If either fails after inspecting overrides, stop and revise this decision. A tested explicit-model fallback does not rescue a failed default-Opus gate. Optional Fable/`opusplan` results can constrain use in those modes without blocking a validated Opus rollout.

## Design & Interfaces

### Candidate agent definitions

These are the candidate definitions for the scratch compatibility gate. Do not copy them into reusable setup instructions or propagate them to projects until the default-Opus gate passes and this plan's decision is confirmed.

```markdown
---
name: sweeper
description: Read-only searches of repository files and existing text logs, reference inventories, and bounded lookups. Use for already-authorized research delegation when only the findings are needed.
model: haiku
tools: Read, Grep, Glob
---

Use only the allowed tools to inspect repository files and existing text logs. Do not inspect git history, invoke MCP, run commands or tests, or claim live/runtime evidence. If requested evidence needs an unavailable capability, identify it and return the evidence request to the parent/task owner. Report file and line references, limits, and uncertainty. Do not edit files.
```

```markdown
---
name: tracer
description: Read-only tracing of static code paths across repository files. Use for already-authorized research delegation when an answer depends on following execution through source files.
model: sonnet
tools: Read, Grep, Glob
---

Use only the allowed tools to trace static code paths in repository files. Do not inspect git history, invoke MCP, run commands or tests, or claim live/runtime evidence. If requested evidence needs an unavailable capability, identify it and return the evidence request to the parent/task owner. Report file and line references, the path followed, and a hypothesis with evidence and limits. Do not edit files.
```

The frontmatter `tools` allowlist is the defined actual tool boundary for these read-only agents. Do not replace it with `disallowedTools`, and do not claim that behavioral instructions by themselves prevent writes. Neither agent can obtain machine metadata, a live model identity, command/test output, MCP responses, git history, or other evidence outside its allowed tools; the task owner must supply or collect such evidence separately.

### Conditional `CLAUDE.md` pointer

Include this pointer only in projects that use Claude Code research subagents. It is three bullets maximum:

```markdown
- If research-subagent delegation is authorized by `AGENTS.md` or the selected workflow, use `sweeper` for repository files and existing text logs, and `tracer` for static code paths.
- Do not pass `model` unless an explicit fallback was tested for this exact Claude Code version, provider, and mode; otherwise let each definition's alias apply.
- Treat reports as hypotheses. The task-owning main agent integrates findings and owns validation; an authorized implementer may edit when assigned.
```

If a fallback is proven for an optional configuration, replace only the second bullet for the project/configuration where that fallback is valid. State the exact tested version, provider, and mode, and the explicit alias for **both** agents; state that untested configurations omit `model`. Do not publish a generic or universal fallback. When removing a fallback, restore the unchanged normal second bullet and retain the rest of the normal pointer.

### Migration and update behavior

Apply only when the project uses Claude Code research subagents and delegation is authorized:

1. Inspect `sweeper.md` and `tracer.md` independently. A missing definition may be created from the approved template after the compatibility gate. Preserve each existing definition unchanged when its parsed frontmatter and behavior are compatible with its contract, even if it has additional compatible local content.
2. If an existing definition is malformed or incompatible, leave it untouched, emit a warning, and propose a specific patch for owner approval. Never silently overwrite or “repair” it.
3. Reconcile the `CLAUDE.md` pointer independently from file creation, and only when **both** definitions are compatible. Add it if absent; remove duplicate copies of the owned pointer; preserve unrelated instructions and unrelated/custom routing. If either definition is incompatible while a pointer already exists, warn that the pointer may be misleading and propose an approved repair or removal. If custom instructions conflict with this pointer or the agent contract, warn and propose an approved patch instead of overwriting the conflict.
4. Do not automatically delete or replace per-task routing tables. Preserve unrelated entries; any cleanup or conflict resolution requires explicit approval.
5. Repeat the structural check on every setup/update, including upgrades, so drift is surfaced after installation.

“Compatible” requires valid YAML frontmatter with the expected filename/name pairing, a non-empty description consistent with the agent's bounded scope, the expected alias (`haiku` for `sweeper`, `sonnet` for `tracer`), and the exact `Read, Grep, Glob` tools allowlist. The body must not expand the agent's allowed evidence or write scope.

### Warning-only checks

When Claude Code research-subagent definitions are in use, the migration and §3.6 checks inspect the actual YAML frontmatter—not merely the presence of a `model:` line—for a parseable frontmatter block, expected `name`, meaningful `description`, expected alias, and exact `tools` allowlist. Missing, malformed, or incompatible data prints a clear warning and proposes owner review; it never fails setup or claims runtime compatibility. These structural checks do not replace the pre-release runtime gate or checks required after a Claude Code upgrade.

### Bounded pre-release scratch compatibility gate

Run this gate after drafting the two candidate definitions above and **before** copying them into setup workflow/templates or propagating them to projects. Use a disposable scratch project; this is not an open-ended host pilot.

| Main configuration | Agents to invoke without a per-invocation `model` | Required evidence |
|---|---|---|
| Default Opus | `sweeper` → Haiku; `tracer` → Sonnet | Required for both agents. Observe actual runtime model through `/tasks` or machine metadata. |
| Fable, if accessible | `sweeper` → Haiku; `tracer` → Sonnet | If inaccessible, record `NOT RUN`; do not block a default-Opus rollout. Check before adopting in Fable. |
| `opusplan`, if accessible | `sweeper` → Haiku; `tracer` → Sonnet | If inaccessible, record `NOT RUN`; do not block a default-Opus rollout. Check before adopting in `opusplan`. |

For each run, capture the Claude Code version, provider, main mode, whether `CLAUDE_CODE_SUBAGENT_MODEL` and `CLAUDE_CODE_SUBAGENT_MODEL_FORCE` are set and their relevant values, the loaded `tools` allowlist, invocation details (including whether `model` was omitted), and the observed runtime model. Base the result on `/tasks` or machine metadata, not on the agent's response, configured frontmatter, or the requested alias alone.

If either agent's observed model mismatches its alias in a tested configuration, inspect applicable overrides and configuration first, then test explicit `model: "haiku"` and `model: "sonnet"` for **both** agents in that same configuration. Record each result. A fallback may be documented only for the exact version/provider/mode configuration in which both explicit calls were proven; do not extrapolate to other configurations. If default-Opus frontmatter fails, stop and revise the decision even if both explicit calls work. For an inaccessible optional mode, record `NOT RUN`; do not infer success or publish a fallback for it, and require this check before adoption in that mode.

## Failure Modes & Recovery

| Failure | Detection | Recovery |
|---|---|---|
| Either alias is ignored in default Opus | Actual runtime identity differs for either agent | Inspect overrides, test explicit aliases for both, stop propagation, and revise the decision even if explicit calls work. |
| Alias is ignored only in an accessible optional mode | Runtime identity differs in Fable or `opusplan` | Inspect overrides and test explicit aliases for both; limit any fallback to the exact proven configuration, or do not adopt in that mode. |
| Optional mode is unavailable | Cannot start/observe that mode | Record `NOT RUN`; continue only with validated Opus. Require a gate before adoption in the unavailable mode. |
| Existing definition is malformed or incompatible | Actual frontmatter parse/contract check warns | Preserve it and propose an approved patch; do not overwrite or add a misleading pointer. |
| Pointer conflicts with custom routing | Migration detects conflicting custom instructions | Preserve unrelated routing and propose an approved reconciliation; do not silently replace it. |
| Structural check is mistaken for runtime proof | Frontmatter passes but runtime gate is missing or stale | Keep the distinction explicit; repeat actual runtime checks after Claude Code upgrades. |
| Read-only restriction is overstated | Definition lacks the documented allowlist or prose relies on `disallowedTools` | Do not ship until both examples have the exact documented allowlist; make no stronger enforcement claim. |

## Test Strategy

- **Plan structure:** `bash scripts/validation/check-plan.sh 00-project/plans/2026-09-27-claude-md-model-routing-implementation-plan.md` exits 0.
- **Scratch compatibility gate:** run the bounded matrix above for both agents; record actual runtime identity and all configuration evidence. No result is claimed in this DRAFT.
- **Structural checks:** verify both agent YAML frontmatters contain the correct `name`, a scope-appropriate `description`, the alias, and exactly `tools: Read, Grep, Glob`. Check setup and update paths both warn without failing on missing/malformed/incompatible definitions.
- **Migration fixture matrix:**
  - Fresh project with neither agent nor pointer: create both approved definitions and one pointer; no warning.
  - One compatible agent missing: preserve the existing compatible file, create only the missing one, and reconcile one pointer.
  - Both compatible files present but no pointer: preserve both files and add exactly one pointer.
  - Custom/conflicting routing: preserve unrelated content and routing; warn and propose an approved patch for the conflict.
  - Malformed or incompatible definition: preserve it, warn/propose a patch, and do not add/reconcile a pointer unless both definitions are compatible.
  - Existing pointer with an incompatible definition: preserve project content, warn that routing may be misleading, and propose an approved repair or removal.
  - Second run after each successful migration: no duplicate pointer, no unrelated changes, no further migration diff (idempotence).
- **Repeat check:** run structural warning checks after a simulated/real setup upgrade; the check remains warning-only and does not claim runtime selection.
- **Documentation links:** confirm setup and token-efficiency each link to the other once, `05-mcp-and-config-setup.md` links to the Claude Code setup section once, and the existing token-efficiency routing table is unchanged.
- **Logging:** future implementation must satisfy the paired fixed/troubleshooting log and both-index checks. This plan-only revision does not run or claim the implementation's checks.

## Rollout & Rollback

Propagate only after the default-Opus frontmatter gate passes for both agents and the decision is confirmed. Optional Fable/`opusplan` checks may be `NOT RUN` without blocking that limited rollout, but a project must validate a mode before adopting the definitions there. Include any fallback only for the exact configuration whose two explicit-model invocations were proven. Repeat runtime compatibility checks after each Claude Code upgrade; the structural updater check also runs on every update.

Rolling back the Workflow-Scripts change and cleaning up definitions already created in consumer projects are separate operations. A Workflow-Scripts revert does not delete consumer files. Consumer cleanup needs its own approved migration/cleanup action and must preserve unrelated project content. Removing a temporary fallback restores the normal conditional pointer rather than deleting it.

## Tasks

### Phase 1: Bounded compatibility gate — before propagation

1. [ ] Run the scratch compatibility gate against the candidate definitions in this plan. Test both agents in default Opus, and in Fable and `opusplan` when accessible. Inspect overrides and test explicit model aliases for both agents in any mismatching configuration. Record version/provider/mode, the two relevant environment variables, allowlist, invocation, and actual runtime model. Stop and revise the decision if default Opus frontmatter fails, regardless of fallback results. (P1, Effort: M)
   - Files: scratch project only; this plan's decision/result note
   - Verify: evidence meets the bounded gate above; inaccessible optional modes are explicitly `NOT RUN`; no setup instructions or project templates are changed before the default gate passes (cost/prerequisites: Claude Code access for the default Opus session; optional-mode access only for those optional checks).

### Phase 2: Definitions and conditional pointer

2. [ ] Add a conditional `.claude/agents/*.md` row to Step 1.1 and add §2.10.4 with both approved candidate definitions, the actual `tools` allowlist, evidence boundaries, and upgrade recheck guidance. Include no generic fallback claim. (P1, Effort: S)
   - Files: `00-project-setup/01-setup-project.md`
   - Verify: both examples retain `model: haiku` / `model: sonnet`, `tools: Read, Grep, Glob`, and their separate bounded scopes; no `disallowedTools`-only claim (cost/prerequisites: Task 1 default-Opus gate passes).
3. [ ] Replace the §2.10.1 placeholder with the conditional pointer, at most three bullets, using the text in Design & Interfaces. Document an optional configuration-specific fallback only when Task 1 proves both agents for that exact configuration; keep the normal pointer as the rollback text. (P1, Effort: S)
   - Files: `00-project-setup/01-setup-project.md`
   - Verify: the pointer is conditional, no more than three bullets, does not generally pass `model`, allows an authorized implementer to edit, and assigns integration/validation to the task owner (cost/prerequisites: Task 2).

### Phase 3: Safe migration, checks, and documentation links

4. [ ] Add conditional migration/update rules to §2.10.3 and the update/checklist references: inspect files independently; create only missing definitions; preserve compatible files; warn/propose approved patches for malformed or incompatible files; reconcile/deduplicate the pointer only if both files are compatible; preserve unrelated routing. (P1, Effort: M)
   - Files: `00-project-setup/01-setup-project.md`
   - Verify: all five migration invariants in Design & Interfaces are present; create behavior is limited to authorized Claude Code research-subagent use (cost/prerequisites: Tasks 2–3).
5. [ ] Add warning-only checks to migration and §3.6 that inspect parseable YAML frontmatter `name`, `description`, model alias, and the exact tools allowlist; repeat them on each update/upgrade. (P2, Effort: M)
   - Files: `00-project-setup/01-setup-project.md`
   - Verify: missing/malformed/incompatible frontmatter emits a warning, never a blocking failure; check is not described as runtime-model proof (cost/prerequisites: Task 2).
6. [ ] Update the Complete Setup Checklist to require definitions only if the project uses Claude Code research subagents, and keep the item non-blocking when such delegation is not used. (P2, Effort: S)
   - Files: `00-project-setup/01-setup-project.md`
   - Verify: the conditional wording matches the create/update and warning-check conditions (cost/prerequisites: Tasks 4–5).
7. [ ] Add one reciprocal reference from the setup workflow to the existing token-efficiency routing source and one back from that source to §2.10.4; add one pointer from the MCP/config setup guide to §2.10.4. Do not edit the existing routing table. (P2, Effort: S)
   - Files: `00-project-setup/01-setup-project.md`, `00-Meta-Workflow/00-token-efficiency/fable-token-savings.md`, `00-project-setup/05-mcp-and-config-setup.md`
   - Verify: one relevant link each way, one pointer in the MCP/config guide, and zero routing-table changes (cost/prerequisites: Tasks 2–3).

### Phase 4: Fixtures, final verification, and required fix logs

8. [ ] Implement and run the migration fixture matrix: fresh project, one missing definition, both definitions/no pointer, custom conflict, malformed definition, and second-run idempotence. Confirm warning-only outcomes and preservation expectations. (P1, Effort: M)
   - Files: `00-project-setup/01-setup-project.md` validation snippets and disposable fixtures
   - Verify: every scenario matches the expected outcome listed in Test and Verification Strategy; no fixture authorizes silent overwrite or blocking failure (cost/prerequisites: Tasks 4–5).
9. [ ] Run the final static/content review and the plan validator; repeat the scratch gate for any configuration needed by the intended rollout. Confirm all Change Surface sites are updated or explicitly out of scope and all task results are recorded. (P1, Effort: S)
   - Files: planned change surface and this plan's evidence note
   - Verify: `bash scripts/validation/check-plan.sh 00-project/plans/2026-09-27-claude-md-model-routing-implementation-plan.md` exits 0; default Opus evidence is present; no untested fallback or successful runtime claim is present (cost/prerequisites: Tasks 1–8).
10. [ ] Record the future workflow fix as a `fixed` changelog entry **and** a `workflow` troubleshooting entry, update both indexes, then complete/file this plan through `04-documentation/03-mark-completed.md`. Do not substitute a changelog-only record for the implemented workflow fix. (P1, Effort: S)
    - Files: `00-project/changelog/fixed/<date>-fixed-claude-code-subagent-model-routing.md`, `00-project/troubleshooting/workflow/<date>-workflow-claude-code-subagent-model-routing.md`, `00-project/changelog/index.md`, `00-project/troubleshooting/index.md`, this plan, and the applicable `00-project/plans-completed/implementation/` file and index
    - Verify: the fixed and workflow troubleshooting entries describe the defect, fix, evidence, and verification; both indexes point to the matching entries; `bash scripts/validation/check-meta-logs.sh --staged` passes at the future implementation's authorized closeout; `03-mark-completed.md` criteria are satisfied before filing (cost/prerequisites: Tasks 1–9 and a verified working implementation).

## Dependencies

- Task 1 is the release gate and precedes every propagation task. If default Opus frontmatter fails, stop and revise the decision; a successful explicit fallback is insufficient to proceed.
- Tasks 2–3 define/publish the approved agent contract and pointer before migration logic (Task 4) or checks (Task 5) refer to them.
- Task 6 depends on the migration and checks being conditional and warning-only.
- Task 7 is documentation-only and must not alter the token-efficiency routing table.
- Task 8 depends on Tasks 4–5 and verifies the exact preservation/warning contract.
- Task 9 follows all implementation and fixture work; Task 10 is last and requires a verified fix.
- Optional-mode `NOT RUN` does not block the default Opus gate, but blocks claiming compatibility or using a fallback in that mode.

## Deferred and debt

- **Hook enforcement:** reconsider only when official behavior is documented and can be verified; do not use a hook as an assumed workaround.
- **Built-in `Explore` override:** reconsider only after host evidence shows it is needed and a separate quality comparison is approved.
- **Non-Anthropic executors and other harnesses:** outside scope; current agent definitions are Claude Code-specific.
- **Global subagent model defaults:** no environment-level policy is proposed.
- **Delegated test writing:** outside scope for these read-only research agents; a separately authorized implementer may edit and validate when assigned.
- **Consumer cleanup on rollback:** separate approved operation, not coupled to reverting the shared workflow.

## Risks

| Risk | Impact | Likelihood | Severity | Mitigation |
|---|---|---|---|---|
| Frontmatter alias is ignored in default Opus | Medium | Possible | S2 | Required bounded gate before propagation; stop and revise the decision even if explicit aliases work. |
| Frontmatter differs only in an optional mode | Medium | Possible | S2 | Test both agents, limit fallback to the exact proven version/provider/mode, and check before adopting in an untested mode. |
| Optional mode is inaccessible before rollout | Low | Possible | S3 | Record `NOT RUN`; allow validated Opus rollout only, with mode-specific adoption gated later. |
| Existing custom definitions or routing are overwritten | High | Possible | S2 | Inspect each file separately; preserve compatible content; warn and propose approved patches for conflict. |
| Agent read-only boundary is misrepresented | High | Possible | S2 | Require the documented tool allowlist in both examples; do not rely on prose or `disallowedTools` alone. |
| Structural check is mistaken for runtime compatibility | Medium | Possible | S2 | Keep warning checks and actual-model compatibility evidence separate; repeat runtime gate after upgrades. |
| Pointer creates a second/conflicting routing policy | Medium | Possible | S2 | Make it conditional, deduplicate only owned pointer text, preserve unrelated routing, and keep token source policy unchanged. |

## Success criteria

- [ ] Default Opus scratch gate confirms `sweeper` runs on Haiku and `tracer` on Sonnet without a per-invocation `model`; evidence captures version/provider/mode, relevant environment, allowlist, invocation, and actual runtime model.
- [ ] If default Opus fails frontmatter routing, propagation stops and the decision is revised even if explicit-model calls work.
- [ ] Fable and `opusplan` have recorded results or explicit `NOT RUN`; no untested optional mode or universal fallback is claimed.
- [ ] Both definitions retain model aliases `haiku` and `sonnet`, and both use the actual `tools: Read, Grep, Glob` allowlist with bounded repository/static scopes.
- [ ] The pointer is conditional, at most three bullets, and only passes `model` for a fully tested exact configuration; its normal form is restored when a fallback is removed.
- [ ] Migration inspects files independently, preserves compatible files and unrelated routing, warns/proposes approved changes for incompatible/malformed state, and reconciles the pointer only when both definitions are compatible.
- [ ] Warning checks inspect actual YAML frontmatter fields, remain non-blocking, and repeat on updates/upgrades.
- [ ] The fixture matrix passes, including second-run idempotence.
- [ ] Reciprocal token-efficiency references and the MCP/config guide pointer exist without changing the existing routing table.
- [ ] Future Task 10 creates the fixed changelog and workflow troubleshooting entry and updates both indexes before the plan is filed complete.
- [ ] The current plan-only revision remains accurately described: no setup implementation or live compatibility test is claimed.

## Feasibility review (2026-09-28)

Appended review of this draft only. `bash scripts/validation/check-plan.sh` exited 0 before this section was added. No setup file, template, scratch project, or Claude Code session was changed or run for this review. The tasks above stay unchecked. Host-project edits stay out of this plan.

The draft is feasible as a Workflow-Scripts change. Tasks 2–7 and 10 edit markdown at sites that exist: Step 1.1's file table, the §2.10.1 placeholder, §2.10.3, §3.6, and the checklists. §2.10.4 is unused. `tools: Read, Grep, Glob` and the aliases `haiku` and `sonnet` match the Claude Code subagent docs (published 2026-09-26). The documented model order matches the draft: a per-invocation `model` wins, then the agent file, then `CLAUDE_CODE_SUBAGENT_MODEL`, then the main conversation's model. `CLAUDE_CODE_SUBAGENT_MODEL_FORCE=1` ignores the agent file (v2.1.257+). `/tasks` names the model on a subagent's row (v2.1.242+). `opusplan` is still a documented alias. Task 10's `fixed` entry plus a `workflow` troubleshooting entry matches `00-project/AGENTS.md` and `check-meta-logs.sh`. Filing into `00-project/plans-completed/implementation/` matches this repo's archive rule.

The goal is provisioning: setup can write the two agent files and a conditional pointer. Claude still sends ordinary codebase search to the built-in Explore agent, which inherits the parent model (v2.1.198+). `sweeper` and `tracer` run when something selects those names. That limit is already deferred with the Explore override. It does not stop the setup workflow from creating the files.

### Task 1 can record a false pass

The scratch gate is the right release check. As written, it can still record the wrong result:

- Frontmatter outranking `CLAUDE_CODE_SUBAGENT_MODEL` dates from v2.1.251. On an older binary the environment variable wins, so a mismatch there does not mean the agent file is wrong. `CLAUDE_CODE_SUBAGENT_MODEL_FORCE` means what this plan says only from v2.1.257. `/tasks` names the model only from v2.1.242. The gate needs that version floor.
- A finished subagent stays on the `/tasks` list for about 30 seconds. These agents are small enough to exit first. The durable record is the session transcript under `~/.claude/projects/`, which carries the model on the request. "Machine metadata" does not name that file.
- The primary run has to launch Claude Code after `.claude/agents/` exists. A session that started before that directory was created does not see it. The run also needs both environment variables unset, and no managed settings or `--agents` flag: those two sources outrank `.claude/agents/`. A scratch directory does not isolate them. A user-level file of the same name does not shadow the project file.
- The expected Sonnet is the alias for the provider under test. On the Anthropic API that is Sonnet 5. On Bedrock and Google Cloud's Agent Platform it is Sonnet 4.5. On Microsoft Foundry it is Sonnet 4.5 for `sonnet` and Opus 4.6 for `opus`.

With those four conditions written into Task 1, the gate is a real stop/go. Without them, Task 9 can accept Opus evidence that does not prove the frontmatter.

### Task 8 has no runner

The migration rules are prose in `01-setup-project.md`. Nothing in the repo creates the files, warns, or writes a diff. "Second-run idempotence" needs a runner this plan does not add. "Compatible" includes a judgment that the body does not widen the agent's scope, while the warning check inspects frontmatter fields. A file can pass the check and break the contract.

Task 8's verify line cites "Test and Verification Strategy." The heading in this plan is `## Test Strategy`. The task list also drops the "existing pointer with an incompatible definition" scenario that Test Strategy includes.

Task 8 is feasible as a recorded dry-run of the seven Test Strategy scenarios, with frontmatter and body scored separately. It is not feasible as an automated matrix that passes.

### The finished workflow contradicts itself

Three edits collide with text the same files already contain. Each is small enough to land in the task that already touches that file:

- Step 1.1's placement test still says a model name belongs in the harness file, and that each rule lives in exactly one file. Task 2 adds a table row for `.claude/agents/*.md` and leaves the test alone. A later setup pass can move `model:` back into `CLAUDE.md`. Amend the placement test in Task 2.
- The three pointer bullets have to stay outside the fenced template at §2.10.1. That fence is what setup copies, and the template says to omit the section when there is nothing Claude-specific to say. Pasting the bullets into the fence gives every project the pointer. Task 3 should put the condition in the instruction outside the fence.
- Task 7 keeps the token-efficiency routing table unchanged and adds only a cross-link. That table still sends scoped research to GLM 5.2. The new pointer sends the same work to `sweeper` and `tracer`. The Agent tool's model field accepts `sonnet`, `opus`, `haiku`, `fable`, a full model ID, or `inherit`, so it cannot select GLM. The aliases are the route that can run inside Claude Code. This plan never says that in either file. Both instructions will be in context together. Task 7 needs one precedence sentence at the link, in both files, without rewriting the table.

### CLAUDE.md fix scope

A per-invocation `model` outranks the agent file. Any `CLAUDE.md` that tells the session to set `model` on each spawn defeats `sweeper` and `tracer` even after the files exist and the gate has passed.

That instruction is already in existing project files. The known instance is Flash-UI-Idea-Generator's root `CLAUDE.md`, under `## Subagent Models`: it tells the main session to pass `model: "sonnet"` or `model: "haiku"` on every spawn, and its Haiku bullet still includes git history, which `sweeper` cannot collect. Editing that file is host work, with its own host log, and stays outside this plan's tasks.

The same fix has to change the CLAUDE.md sources in `00-project-setup/`. Setup is what writes new `CLAUDE.md` files and what preserves harness-only blocks on update. Editing only the existing project files leaves the next setup or update able to recreate or keep the override. There is no file named `CLAUDE.md` inside `00-project-setup/`. The sources that have to be part of the fix are:

| Source | What it does today | What the fix has to change |
|---|---|---|
| `00-project-setup/01-setup-project.md` §1.1 placement test | Sends "a model name" to the harness file | Stop sending per-invocation `model` into `CLAUDE.md`. The alias lives in `.claude/agents/*.md`. |
| `00-project-setup/01-setup-project.md` §2.10.1 | Fenced `CLAUDE.md` template. The only routing text is the placeholder "subagent model selection." Setup copies this fence. | Conditional pointer outside the fence, per Task 3. The copied template must not tell the session to pass `model`. |
| `00-project-setup/01-setup-project.md` §2.10.3 rule 3, the "What to update" list, and the quick update checklist | Keep existing harness-only content. A "set the `model`" block is harness-only, so update runs preserve it. | Treat that block as a conflict with the agent-file contract: warn and propose an approved removal. Do not keep it silently. |
| `00-project-setup/08-kaparthy-template.md` | A `CLAUDE.md` body stored in the setup directory. Placement note says to install it as `docs/agents/coding-discipline.md`, and to put it in `CLAUDE.md` only when it should apply to Claude alone. It has no model-routing block. | Include it in the fix pass so a later edit does not add a per-invocation `model` instruction to this body. |

Workflow-Scripts' own root `CLAUDE.md` is `@AGENTS.md` only. It does not pass `model`. It is not one of the files that recreate the override.

Task 3, as written, replaces the §2.10.1 placeholder with the "do not pass `model`" pointer. That is the setup half of the new text. It does not by itself remove a preserved "set the `model`" block, and it does not edit existing project `CLAUDE.md` files. Both halves are required for the override to stay gone: the `00-project-setup` sources in the table above, and each existing project `CLAUDE.md` that passes `model`, as separate host work.
