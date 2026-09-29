# Why `01-setup-project.md` Has No Instructions for CLAUDE.md Model Routing

**Date:** 2026-09-27
**Status:** Investigation complete — findings corrected 2026-09-27 23:03; Recommended fix superseded by [`../plans/2026-09-27-claude-md-model-routing-implementation-plan.md`](../plans/2026-09-27-claude-md-model-routing-implementation-plan.md)
**Author:** claude (pi session, host project: Flash-UI-Idea-Generator); corrections by claude-opus-5-5 (Claude Code session, same host)
**Question investigated:** Why does `00-project-setup/01-setup-project.md` provide no clear instructions for setting up `CLAUDE.md` with model routing (subagent model selection) instructions?
**Method:** Full read of `01-setup-project.md` (1,373 lines), repo-wide greps of Workflow-Scripts for model-routing terms, review of the host project's `CLAUDE.md`, and git history (`git log -S "Subagent Models"`) to establish provenance.

---

## Corrections (2026-09-27 23:03)

A verification pass re-ran every cited line and search. Line citations and the root cause held; these claims did not:

| Original claim | Correction |
|----------------|------------|
| Finding 2: repo-wide grep returns only two hits; no model-routing content exists anywhere in Workflow-Scripts | False. `00-Meta-Workflow/00-token-efficiency/fable-token-savings.md:37` has a "Model Routing & Delegation (Default Behavior)" section. It is the source of the globally installed `token-efficiency` skill. Line 261 also does not match the listed search terms, so it could not have been a grep hit. Finding 2 is rewritten below. |
| Consequence 4: `AGENTS.md` "mandates parallel subagent use" | Overstated. The Execution rule is conditional: "Use parallel agents only for independent scopes where doing so materially reduces latency or improves confidence." |
| Recommended fix 1: copy the host block, including "Sonnet 5" / "Haiku 4.5", into the shared template | Contradicts Consequence 3 by replicating versioned model names into every project. It also ignores the existing token-efficiency routing policy (Finding 7). Replaced by the plan linked in the header. |

## Executive summary

The single-source-of-truth architecture (Step 1.1) deliberately reduces `CLAUDE.md` to a **thin harness file**: `@AGENTS.md` + `@PROJECT.md` imports plus a Claude-only section. Model routing is correctly classified as harness-specific content (the placement test at line 261 names "a model name" as a harness-file trigger), but the setup workflow **never defines what that content should be, never includes a step that creates it, and never verifies it exists**. Its only trace in the setup series is a one-line placeholder example (line 1004). A fresh setup executed literally produces a `CLAUDE.md` with no model routing, and each project ends up hand-writing it during unrelated work, which is what happened in the host project.

Routing policy does exist elsewhere in Workflow-Scripts: the token-efficiency doc (Finding 7). It is deliberately installed as a global skill rather than a `CLAUDE.md` patch, and nothing connects it to the setup series. Any fix must reconcile with it, not add a second policy.

## Findings

### Finding 1: The workflow intentionally reduces CLAUDE.md to a placeholder

Step 1.1 ("Agent file architecture — single source of truth") classifies files as:

| File | Holds |
|------|-------|
| `AGENTS.md` | Agent rules (harness-neutral) |
| `PROJECT.md` | Project facts |
| `docs/agents/*.md` | Long detailed guides |
| `CLAUDE.md` | Imports + **Claude-only** instructions |
| `GEMINI.md` | Imports + **Gemini-only** instructions |

The placement test (line 261) explicitly routes model names to harness files:

> 1. Does it only make sense for one harness (a model name, a tool, an import syntax)? Put it in that harness file.

Step 2.10.1's `CLAUDE.md` template (line 993) contains the setup series' only mention of the concept (line 1004):

```markdown
## Claude-Specific Instructions
- <Only instructions that apply to Claude alone, e.g. subagent model selection,
  Claude Code hooks or skills. Omit the section if there are none.>
```

"Subagent model selection" is named as an *example placeholder* and never elaborated. The template instructs: "Omit the section if there are none". Since the workflow never supplies the content, a literal execution omits it.

### Finding 2: The setup series has no routing content; the repo's only routing policy is not linked from it

Repo-wide grep (`grep -rniE 'model routing|subagent|sonnet|haiku|opus|model selection' --include='*.md'`) returns many hits. Most are unrelated: API provider docs, historical plans, SEO research, and skill descriptions. Within `00-project-setup/` the only relevant hit is `01-setup-project.md:1004`.

The one relevant hit outside the setup series is `00-Meta-Workflow/00-token-efficiency/fable-token-savings.md:37` ("Model Routing & Delegation"), covered in Finding 7. The setup series does not reference it.

So there is no template block, recommended task-to-model mapping, or syntax example (for example `model: "sonnet"` on a subagent spawn) anywhere in `00-project-setup/`, and no setup step that creates a model-routing section.

### Finding 3: The model-config workflow that exists covers different harnesses only

`00-project-setup/05-mcp-and-config-setup.md` *does* cover model/provider configuration, but only for **Cursor** and **OpenCode** (§4 default model `zai-coding-plan/glm-5`; §5 oh-my-opencode `agents.sisyphus.model` overrides). Claude Code subagent model routing is not in the setup series' scope.

### Finding 4: Verification and checklists never check harness content

- **Step 3.6** ("Verify the agent files", line 1137): the `CLAUDE.md` / `GEMINI.md` check (line 1148) only asserts the `@AGENTS.md` and `@PROJECT.md` import lines exist.
- **Complete Setup Checklist** (line 1322): checks only "thin import form with harness-only content", which is form, not substance.
- **Quick update checklist** (line 173): same — "thin import form, harness-only content (Step 2.10.3)".

No check verifies that the Claude-specific section is populated, so the omission is invisible at setup-verification time.

### Finding 5: The update path cannot heal the gap either

"Updating an existing project that already uses this system" (line 144, the `CLAUDE.md / GEMINI.md` bullet) and Step 2.10.3 ("Create or migrate the harness files", line 1021) define migration rules for an *existing* `CLAUDE.md`:

> 3. Harness-only content → keep it under the harness-specific section.

"Keep it" preserves model routing *if it already exists*, but nothing says "create model routing if missing." A project whose `CLAUDE.md` was created from the template stays routing-less, even after repeated update runs.

### Finding 6: Provenance — the host project's model routing was added ad hoc

The host project (`Flash-UI-Idea-Generator`) has a working model-routing section in its `CLAUDE.md`, under the heading `## Subagent Models` (not the template's `## Claude-Specific Instructions`):

> **Sonnet 5** (`model: "sonnet"`): tracing code paths, root-cause analysis, reviewing fixes, writing tests.
> **Haiku 4.5** (`model: "haiku"`): searches, file and log sweeps, git history, inventorying references.

`git log -S "Subagent Models" -- CLAUDE.md` shows it was introduced in commit `9933f0b` ("feat: Grok and OpenAI subscription providers with streaming generation"). It was hand-written during unrelated feature work, not produced by any workflow run.

### Finding 7: An existing routing policy lives in the token-efficiency skill, deliberately outside CLAUDE.md

`00-Meta-Workflow/00-token-efficiency/fable-token-savings.md` defines a global Claude Code skill, installed at `~/.claude/skills/token-efficiency/SKILL.md`, that "Installs as a **skill only** (no `CLAUDE.md` patch)". Its routing section (line 37) assigns:

- **Fable** — judgment, planning, review (orchestrator).
- **GLM 5.2** — implementation and bulk work, with "fallback: Sonnet/Haiku" when GLM 5.2 is unavailable (line 35).

The two policies overlap but do not conflict in Claude Code. The Claude Code Agent tool's `model` parameter accepts only the aliases `sonnet`, `opus`, `haiku`, and `fable`, so GLM 5.2 cannot be selected for an in-session subagent. The skill's own fallback (Sonnet/Haiku) applies, which is exactly what the host `CLAUDE.md` block specifies. The gap is that nothing states this precedence, so a reader sees two routing tables and no rule for which wins.

## Root cause

The single-source-of-truth refactor (Step 1.1 / Step 2.10) deliberately stripped `CLAUDE.md` down to imports plus a per-project placeholder, and correctly classified model routing as harness-specific content. But it decided *where* model routing belongs (`CLAUDE.md`) without deciding *what it is*, *whether it must exist*, or *how it relates* to the token-efficiency routing policy that already existed as a global skill. The one-line placeholder at line 1004 is the only trace of the decision in the setup series.

## Consequences

1. **Fresh setups ship without routing.** Literal workflow execution omits the Claude-specific section ("Omit the section if there are none" + no supplied content).
2. **Per-project drift.** Each project invents its own routing vocabulary, model names, and task mapping.
3. **Staleness risk.** Hand-written sections reference versioned model names (for example "Sonnet 5", "Haiku 4.5") with no canonical place to update when models change. The aliases (`sonnet`, `haiku`) already track the latest model in each family; only the display names go stale.
4. **Two unreconciled policies.** A project with a routing block and the global token-efficiency skill has two routing tables with no stated precedence.
5. **Routing detail for the conditional parallel-agents rule has no home.** `AGENTS.md` permits parallel agents for independent scopes when they materially help; the harness file that should say which model to spawn for which task is left empty.

## Recommended fix

Superseded — see the finalised plan: [`../plans/2026-09-27-claude-md-model-routing-implementation-plan.md`](../plans/2026-09-27-claude-md-model-routing-implementation-plan.md). The original proposal is kept below as the reviewed source.

<details>
<summary>Original proposal (reviewed in the addendum below)</summary>

1. **Add a canonical "Subagent model routing" block to the Step 2.10.1 template**, e.g.:

   ```markdown
   ## Subagent Models

   When spawning parallel subagents (per `AGENTS.md`), set the `model` on each by task:

   - **Sonnet 5** (`model: "sonnet"`): tracing code paths, root-cause analysis, reviewing fixes, writing tests.
   - **Haiku 4.5** (`model: "haiku"`): searches, file and log sweeps, git history, inventorying references.

   The main session owns the root-cause verdict and the fix. Treat each subagent report as a hypothesis and confirm it against code or live evidence before acting.
   ```

   (Matches the block already proven in the host project's `CLAUDE.md`.)

2. **Add a Step 3.6 verification check** that `CLAUDE.md` contains a populated Claude-specific section (not just import lines).
3. **Add a Complete Setup Checklist item** for the model-routing section.
4. **Extend the update path** ("Updating an existing project" → What to update) so Step 2.10.3 also *creates* missing model routing, not only preserves existing harness content.
5. Optionally: note in `05-mcp-and-config-setup.md` that Claude Code subagent routing is handled via `CLAUDE.md` (cross-reference), closing the harness-coverage gap.

</details>

## Evidence index

| Claim | Source |
|-------|--------|
| Placement test routes model names to harness files | `00-project-setup/01-setup-project.md:261` |
| Setup series' only mention: template placeholder | `00-project-setup/01-setup-project.md:1004` |
| Template section | `00-project-setup/01-setup-project.md` §2.10.1 (line 993) |
| Update path migrates but never creates harness content | `01-setup-project.md:144`; §2.10.3 (line 1021), rule 3 |
| Verification checks imports only | `01-setup-project.md` §3.6 (lines 1137–1148) |
| Checklists check form only | `01-setup-project.md:1322`, `:173` |
| Model config covers Cursor/OpenCode only | `00-project-setup/05-mcp-and-config-setup.md` §4–5 (lines 233–263) |
| Host project routing added ad hoc | `git log -S "Subagent Models"` → commit `9933f0b` |
| Existing routing policy, skill-only by design | `00-Meta-Workflow/00-token-efficiency/fable-token-savings.md:3`, `:35`, `:37` |
| Agent tool `model` accepts aliases only | Claude Code Agent tool schema: `sonnet`, `opus`, `haiku`, `fable` |

---

## Current state

- R1 (template block with versioned names) — superseded; plan Task 1 uses aliases only.
- R2 (Step 3.6 check) — accepted as a warning, not a failure; plan Task 3.
- R3 (Complete Setup Checklist item) — accepted; plan Task 4.
- R4 (update path creates missing routing) — accepted, conditional on subagent use; plan Task 2.
- R5 (`05-mcp` cross-reference) — accepted as P3; plan Task 6.
- New: precedence between `CLAUDE.md` routing and the token-efficiency skill — plan Task 5.
- 2026-09-27 23:21 revision: plan now routes via `.claude/agents/` definitions with `model` frontmatter (`sweeper` → haiku, `tracer` → sonnet) plus a short `CLAUDE.md` pointer, instead of a `CLAUDE.md` table. A `CLAUDE.md` rule is advisory and was exercised in only 2 of 11 host sessions; Claude Code applies agent frontmatter itself. Task numbers above refer to the 23:03 draft.

2026-09-27 23:03 (local time, 24h) - Plan Review (Model: claude-opus-5-5)

Scope: the "Recommended fix" section above, treated as the source plan. Change Surface searches re-run: `grep -rniE 'model routing|subagent|sonnet|haiku|opus|model selection' --include='*.md' .` and `grep -n 'CLAUDE.md' 00-project-setup/01-setup-project.md`.

### P1

- **S1/P1 — Proposed block reintroduces the staleness it warns about.** *Rationale:* Consequence 3 names versioned model names as the staleness risk; R1 copies "Sonnet 5" / "Haiku 4.5" into a template every project duplicates, and the update path (Finding 5) never refreshes harness content. *Fix:* the template uses aliases only (`model: "sonnet"`, `model: "haiku"`), with no version strings. Verify with `grep -nE '(Sonnet|Haiku|Opus|Fable) [0-9]' 00-project-setup/01-setup-project.md` → no hits in §2.10.1.
- **S1/P1 — Second routing policy with no precedence (engineering standards §2, source of truth).** *Rationale:* `fable-token-savings.md:35–51` already routes execution to GLM 5.2 with a Sonnet/Haiku fallback; R1 adds a competing table and says nothing about it. *Fix:* state in both places that in Claude Code the `CLAUDE.md` block is the in-harness routing, and that it matches the skill's own fallback because the Agent tool cannot select GLM. The token-efficiency doc gets a one-line cross-reference; the template does not restate the skill.

### P2

- **S2/P2 — Verification as proposed would fail valid projects.** *Rationale:* R2 requires a populated section, but "Omit the section if there are none" remains valid for projects that never spawn subagents; a hard failure contradicts the template. *Fix:* make the check a warning (`⚠`) keyed on `model: "` rather than on a heading, since the host uses `## Subagent Models` and the template uses `## Claude-Specific Instructions`.
- **S2/P2 — Heading mismatch unaddressed.** *Rationale:* Host uses `## Subagent Models`; template uses `## Claude-Specific Instructions`. R1 introduces a third shape by adding a new `##` section. *Fix:* keep one top-level `## Claude-Specific Instructions` heading and put routing under `### Subagent models` inside it; checks grep content, not headings.
- **S3/P2 — R4 has no condition.** *Rationale:* "create missing routing" on every update would add routing to projects that never use subagents. *Fix:* add routing on update only when the project uses subagents or the owner asks; otherwise leave the placeholder.

### P3

- **S3/P3 — R5 cross-reference is low value but cheap.** Keep as the last task.
- **S3/P3 — Host `CLAUDE.md` still carries versioned names.** Out of scope for this Workflow-Scripts plan (host changes are logged in the host); record as deferred.

**Missing from the source plan:** Change Surface, Decision with a minimal option, Test Strategy, Rollback, and the `00-project/` changelog task required by `AGENTS.md`. All are added in the finalised plan.
