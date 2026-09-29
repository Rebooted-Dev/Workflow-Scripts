# Prior Art: Subagent Model Routing in Claude Code

**Date:** 2026-09-27
**Status:** Investigation complete; load-bearing claims verified and corrected 2026-09-27 23:42 (see Verification notes)
**Author:** claude-sonnet (research subagent)
**Question investigated:** What existing GitHub projects and published solutions implement subagent model routing in Claude Code, and what should [`../plans/2026-09-27-claude-md-model-routing-implementation-plan.md`](../plans/2026-09-27-claude-md-model-routing-implementation-plan.md) borrow, confirm, or change as a result?
**Method:** `gh search repos` / `gh search code` for agent-frontmatter and hook patterns; `gh api` reads of specific files, READMEs, and (critically) live issues on `anthropics/claude-code` (public, 148k stars, `has_issues: true`); `WebFetch` of `code.claude.com/docs/en/hooks` for the PreToolUse JSON schema. Repos were read at the file level, not summarized from third-party articles, except where noted as a WebFetch summary.

---

## Verification notes (2026-09-27 23:42, claude-opus-5-5)

The orchestrating session re-checked the load-bearing claims with `gh issue view` / `gh repo view`. Star counts and freshness for wshobson/agents, claude-mpm, and claude-code-router are confirmed. Corrections:

| Claim below | Checked state |
|-------------|---------------|
| `#44412` is a duplicate of `#18346` | It was closed as a duplicate of [`#39814`](https://github.com/anthropics/claude-code/issues/39814) ("PreToolUse hook `updatedInput` silently ignored for Agent tool"). |
| `updatedInput` is "confirmed broken" for the Agent tool | Overstated. `#39814` was closed `NOT_PLANNED` on 2026-05-21 as inactive, with no linked fix. It was reported broken in April 2026; its current behavior is unverified. |
| `#18346` is the canonical open issue | It was closed `NOT_PLANNED` (stale) on 2026-06-11. The live reports are [`#91890`](https://github.com/anthropics/claude-code/issues/91890) (open, 2.1.259, full model ID ignored under a Fable parent), [`#93157`](https://github.com/anthropics/claude-code/issues/93157) (open, `opusplan` overrides frontmatter), and [`#89723`](https://github.com/anthropics/claude-code/issues/89723) (open, plugin-level only). `#91890` used a full model ID, not an alias; whether aliases are affected is unknown. |
| claude-mpm documents that frontmatter and hooks do not work | The source file is `docs/_archive/2026-04-research/claude-code-agent-model-field-behavior-2026-04-05.md`, an archived April 2026 finding, not current documentation. |

These corrections are applied in the plan's 23:42 revision.

## Summary table

| Project | URL | Mechanism | Borrowable | Freshness |
|---|---|---|---|---|
| wshobson/agents | github.com/wshobson/agents | Frontmatter `model:` on 202 project/plugin agents + a written tiering policy | Tier table, `description` phrasing ("Use PROACTIVELY for…"), `model: inherit` idiom, Sonnet→Haiku orchestration patterns | 40,027 stars, pushed 2026-09-26 (active) |
| musistudio/claude-code-router | github.com/musistudio/claude-code-router | Local proxy (`127.0.0.1:3456`) swapping provider/model per request category (default/background/think/longContext) | The only concrete mechanism found for routing Claude Code to non-Anthropic models (e.g. GLM) | 37,446 stars, pushed 2026-09-27 (active) |
| bobmatnyc/claude-mpm | github.com/bobmatnyc/claude-mpm | `CLAUDE_CODE_SUBAGENT_MODEL` env var + explicit `model` param; explicitly documents that frontmatter `model:` and `updatedInput` hooks **do not work**, citing filed bugs | Env-var-first guidance; "PM + subagents" tiering summary | 154 stars, pushed 2026-08-31 (active) |
| aleks-apostle/claude-code-patches | github.com/aleks-apostle/claude-code-patches | Binary patch of `cli.js` rewriting hardcoded model strings on **built-in** `Plan`/`Explore`/`general-purpose` agents | Evidence that built-in Explore's model has been hardcoded (not "inherit") in past versions; a workaround pattern for the deferred Explore-override item | 67 stars, last commit 2025-12-09 (targets CC v2.0.33 — ~10 months stale, brittle by construction) |
| 0xmariowu/builders-dont-cry | github.com/0xmariowu/builders-dont-cry | PreToolUse hook (warn-only) on the Agent tool: logs every spawn, nags if ≥2 agents share no `model` override | Concrete, if crude, example of hook #2 from the brief; shows the log-only pattern | 4 stars, pushed 2026-05-06 (essentially unmaintained / hobby scale) |
| oscarmenendezgarcia/prism | github.com/oscarmenendezgarcia/prism | Custom orchestrator injects `--model` as a CLI flag per pipeline stage rather than trusting frontmatter; docs explicitly hedge that frontmatter may win over the flag | Independent confirmation that other builders don't trust frontmatter either, and route around it | 7 stars, pushed 2026-08-31 (small, active) |
| anthropics/claude-code (issues) | github.com/anthropics/claude-code | N/A — primary-source bug reports, not a routing implementation | The decisive evidence for this whole investigation (see Mechanism 1) | Repo active (pushed 2026-09-26); issue thread spans Jan–Sep 2026, several instances still open |
| charliechan53/superpower-router | github.com/charliechan53/superpower-router | Unknown — README 404s | None usable | 0 stars, README missing — treat as abandoned/broken |

---

## Per-mechanism findings

### Mechanism 1: Frontmatter `model:` — documented to work, extensively reported as broken

The docs (per the plan's already-confirmed facts) say the Agent tool "uses the agent definition's model" when no per-invocation `model` is passed. **Live issues on `anthropics/claude-code` contradict this for long stretches of 2026, including recently.**

- **Canonical issue** [`#18346`](https://github.com/anthropics/claude-code/issues/18346) — "Claude Code does not respect agent model definition, uses wrong model." Opened 2026-01-15, 14 comments through 2026-08-13, **closed `not_planned` by a stale-bot on 2026-06-11** — not because it was fixed. Reporters across CC v2.1.7 through v2.1.139 confirm the bug on macOS and Windows. Representative comments:
  > "Agent definition `model:` not enforced — Caller can override with Task tool `model` parameter — No mechanism to enforce agent-defined model." (cheeselemon, 2026-02-19)

  > "Confirming this issue on CLI v2.1.114. Subagent `model` frontmatter and the Agent tool `model` parameter are both ignored for Opus specifically, while `sonnet` and `haiku` values still route correctly." (yyy-yuichi, 2026-04-19)

- **Two duplicate reports filed by the claude-mpm maintainer** ([`#44385`](https://github.com/anthropics/claude-code/issues/44385), [`#44412`](https://github.com/anthropics/claude-code/issues/44412), both closed as duplicates of `#18346` on 2026-04-10) include controlled repro steps and this conclusion:
  > "Both issues together mean there is NO programmatic way to set subagent models — only the calling agent's explicit `model` parameter works." (#44412)

- **The bug is still being filed as of this month**, and is not uniform — it appears version- and mode-dependent:
  - [`#91890`](https://github.com/anthropics/claude-code/issues/91890) (open, 2026-09-03): a **user-scoped project agent** (`~/.claude/agents/frontend-developer.md`, exactly our plan's mechanism) with `model: claude-opus-4-8` ran on the parent's Fable 5.1 instead, on CC v2.1.259.
  - [`#93157`](https://github.com/anthropics/claude-code/issues/93157) (open, 2026-09-09): "opusplan mode overrides subagent model frontmatter, ignoring agent config."
  - [`#89723`](https://github.com/anthropics/claude-code/issues/89723) (open, 2026-08-26) draws a distinction relevant to us: **"project-level agents honor it"** — frontmatter `model:` works when the file lives in the project's `.claude/agents/`, but the *same file shipped inside a plugin's `agents/*.md`* is ignored. Direct quote:
    > "Subagents shipped inside a plugin (`<plugin>/agents/<name>.md`) do not honor the `model:` frontmatter key. The same file placed under the project's `.claude/agents/` does honor it, and passing `model` explicitly on the Agent tool call also works."
  - [`#92660`](https://github.com/anthropics/claude-code/issues/92660) (open, 2026-09-07): subagents inherit the session's *effort* setting regardless of per-model `modelSettings`, a related but distinct cost leak.

**Read on our plan:** Our plan's `sweeper`/`tracer` are project-level (`.claude/agents/`), which `#89723` says is the mechanism most likely to work, not plugin-distributed. But `#91890` (Sept 2026, same placement) shows even that isn't guaranteed. The bug family is real, longstanding (9+ months), not fixed, and its own reporters can't agree on a single trigger — sometimes it's Opus-specific, sometimes `opusplan` mode, sometimes a mid-session frontmatter edit. **The plan's Task 7 live smoke test is not a formality; it is the load-bearing verification step**, and it should be treated as something to re-run after Claude Code version bumps, not a one-time gate.

### Mechanism 2: PreToolUse hooks and `updatedInput` — documented as generic, confirmed broken for the Agent tool specifically

Per `code.claude.com/docs/en/hooks` (fetched directly, quoted by the fetch's summarizer — not independently re-verified against raw HTML, flagged accordingly):

> "`updatedInput`: For `PreToolUse`, tool input object with the same schema as `tool_input` from the hook's input. Claude Code passes the updated input to the tool instead of the original input."

This is a **primary-source confirmation that PreToolUse hooks are documented to be able to rewrite tool input generically**, which would in principle let a hook rewrite `tool_input.model` on an `Agent` tool call before it runs.

In practice, `#44412` (closed as duplicate of `#18346`, same root-cause family) reports this specific case as broken, with a full repro:
```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow",
    "updatedInput": { "subagent_type": "python-engineer", "model": "sonnet", ... }
  }
}
```
> "Hook fires correctly (confirmed via file logging). Agent spawns with parent model (Opus) instead of sonnet. ... updatedInput is silently ignored [for the Agent tool]."

The only concrete hook-based routing implementation found in the wild, `0xmariowu/builders-dont-cry`'s `agent-routing-guard.sh`, does **not** attempt `updatedInput` enforcement — it only logs spawns and prints a warning string to stdout when ≥2 agents share no `model` override, explicitly documented as "WARN only — outputs reminder, does NOT block":
```bash
# Rule: >=2 agents → should be sonnet (unless explicitly opus for good reason)
if [ "$NEXT_COUNT" -ge 2 ] && [ "$MODEL" = "default" ]; then
  MSG="[agent-routing-guard] Agent #$NEXT_COUNT ($DESC) has no model override..."
  echo "$MSG"
fi
exit 0
```
No project was found that successfully enforces model selection via a PreToolUse hook on the Agent tool. Given `#44412`, this is consistent with the mechanism being currently broken, not merely unpopular.

### Mechanism 3: Overriding built-in agents (Explore, Plan, general-purpose)

`aleks-apostle/claude-code-patches`'s `patch-subagent-models.js` (targets CC **v2.0.33**, ~10 months old relative to today) patches hardcoded strings in the compiled `cli.js`:
```
searchPattern: 'a3A={agentType:"Plan",...,model:"sonnet"}'
searchPattern: '...,source:"built-in",baseDir:"built-in",model:"haiku"}});var a3A;'  // Explore
```
This shows that, at least in v2.0.33, the built-in **Explore agent had a hardcoded `model:"haiku"`** baked into the bundle — not "inherits from parent" as our plan's cited docs (checked against a later version) describe. Whether this changed between v2.0.33 and the version behind our plan's docs citation is not something this research could pin down from the patch alone.

A comment on the canonical bug thread adds a further wrinkle, independent of this patch:
> "issue: Explore subagent use opus but not haiku. try-fix: Wrote some prompt that tell Claude code when it want to fire Explore subagent then use Haiku, not by inherit. result: not work. I saw the gray text declare the Explore Agent used Haiku4.5, but actual Opus by capture http." (lkv1988, 2026-03-11, v2.1.72)

This says the **displayed** model label and the **billed** model can diverge — a UI/telemetry-vs-reality gap, not just a routing gap.

**Read on our plan's deferred Option C:** the deferral is validated (don't touch Explore yet), but the stated trigger condition ("a side-by-side search comparison shows no quality loss") is necessary but not sufficient — add a check that the override actually changes the *billed* model (via a real API log or cost report), not just the UI's model label, per lkv1988's report.

### Mechanism 4: Orchestrator/executor patterns and naming conventions

`wshobson/agents` (40k stars, 202 agents, actively maintained) is the strongest example of a cost-tiered agent collection and documents the pattern explicitly in `docs/agents.md`:

```
| Tier | Model    | Use                                                              |
| 0    | Fable 5  | Longest-horizon autonomous work (opt-in, premium cost)           |
| 1    | Opus     | Architecture, security, code review, production-critical         |
| 2    | inherit  | User-chosen — backend, frontend, AI/ML, specialized              |
| 3    | Sonnet   | Docs, testing, debugging, API references                         |
| 4    | Haiku    | Fast operational tasks, SEO, deployment, content                 |
```

Each agent file's frontmatter is minimal — `name`, `description`, `model` — and the `description` field is written to bias Claude's own agent selection, e.g.:
```yaml
---
name: comprehensive-review-code-reviewer
description: Elite code review expert ... Use PROACTIVELY for code quality assurance.
model: opus
---
```
The repo's README documents four explicit "Hybrid Orchestration Patterns" (e.g., "Sonnet: backend-architect (design) → Haiku: generate endpoints → Haiku: test-automator → Sonnet: code-reviewer"), i.e. planner-on-strong-model, implementer-on-cheap-model, reviewer-on-strong-model again — the same shape as our plan's `sweeper`/`tracer` split, just with more roles.

Note: this repo's tiering table describes the *intended* policy; given Mechanism 1's findings, there's no independent confirmation in the repo that the 202 agents' frontmatter models are reliably honored by Claude Code itself — it's exposed to the same bug family.

`oscarmenendezgarcia/prism`'s blueprint doc independently arrived at the same distrust of frontmatter, choosing to inject `--model` via CLI flag instead, with an explicit escape hatch to headless mode if the flag turns out to be overridden by frontmatter:
> "Option A — `--model` flag in subagent mode: ... Risk: Claude Code CLI may let the agent's frontmatter model take precedence over the flag (undocumented behavior). Option B — Switch to headless mode ... Recommendation: Option A with documented escape-hatch to Option B."

### Mechanism 5: Measuring whether routing actually happens

No dedicated tool was found for verifying per-subagent model routing in Claude Code specifically (no OpenTelemetry dashboard, no statusline project scoped to this). `claude-mpm`'s `docs/optimization.md` self-reports a before/after cost table (Opus $3.61 → Sonnet $1.32, unverified/self-reported) but its actual verification method is the same one our plan already uses: read the transcript and confirm which model a subagent reports for itself. Several of the GitHub issues above use this exact method (asking the subagent to self-report `"the model ID you are running on"` and checking the terminal's task header / billing).

**Read on our plan:** Task 7's transcript-grep approach is already the state of the art found here — nothing better exists in the wild. It should be scheduled to re-run periodically (see Mechanism 1), not treated as a one-time check.

### Mechanism 6: Routing to non-Anthropic models (GLM, etc.)

`musistudio/claude-code-router` (37k stars) is the dominant tool: a local proxy on `127.0.0.1:3456` that Claude Code points at via `ANTHROPIC_BASE_URL`, with routing rules keyed on request category (`default`, `background`, `think`, `longContext`) rather than on `subagent_type`. Per its README (WebFetch summary, not independently re-verified against source):
> "Switch providers or models without changing your workflow ... Define routing rules with conditions on request headers and bodies ... Request logs display resolved provider, model, status, tokens, latency, and errors."

This operates **below** the Agent-tool/frontmatter layer — it swaps the provider for the whole session or for a request category, and there is no evidence found (in the README or elsewhere) that CCR distinguishes `sweeper` vs `tracer` by `subagent_type`. It would need its own category-to-provider mapping (e.g., `background` → GLM 5.2) to approximate the token-efficiency doc's GLM preference, and would apply uniformly rather than per-agent. This is a plausible way to close the "GLM 5.2 unavailable, falls back to Sonnet/Haiku" gap noted in `fable-token-savings.md`, but it is unverified here and out of this plan's stated scope (Workflow-Scripts non-goals explicitly exclude "routing for other harnesses" — CCR is adjacent, not a Claude Code harness feature, but still worth a footnote).

---

## Implications for our plan

Plan reference: [`2026-09-27-claude-md-model-routing-implementation-plan.md`](../plans/2026-09-27-claude-md-model-routing-implementation-plan.md).

| Plan item | Verdict | Evidence |
|---|---|---|
| Decision: Option B (project agent frontmatter, `sweeper`=haiku, `tracer`=sonnet) | **Confirm, with a stronger caveat** | `#89723` confirms project-level (not plugin-level) frontmatter is the variant most likely to work; but `#18346`/`#91890`/`#93157` show it is an actively recurring, unresolved bug family through Sept 2026, including on plain project agents. The plan's choice is still the best available option — it's just not as deterministic as the plan's Decision section implies ("The model is applied by Claude Code, not remembered by the main model"). |
| Task 7 (live smoke test, gate before Task 8) | **Confirm and strengthen** | Already the right instinct. Add: re-run after any Claude Code version bump, not just once at rollout, given the version-dependent flakiness in the issue thread (works in some CC versions/modes, not others, e.g. `opusplan` mode per `#93157`). |
| CLAUDE.md pointer: "Do not pass `model` when spawning [sweeper/tracer]" | **Change — soften to a documented fallback, not an absolute rule** | `claude-mpm`'s maintainer, after filing `#44385`/`#44412`, concluded frontmatter and `updatedInput` hooks don't reliably work and that "only explicit `model` param or env var works." If our plan's smoke test (Task 7) ever fails or regresses, the current pointer text gives the model no sanctioned way to fix it. Recommend adding one line: "If a `sweeper`/`tracer` transcript shows the wrong model, pass `model` explicitly as a stopgap and note it in the changelog." |
| Deferred: `CLAUDE_CODE_SUBAGENT_MODEL` env var | **Add — reconsider priority, don't fully defer** | This is the mechanism `claude-mpm` (154 stars, active, and the source of two of the four cited bug reports) treats as the reliable one, precisely because it doesn't depend on frontmatter parsing at spawn time. It's a blunt instrument (one model for *all* subagents without an explicit override), so it doesn't replace the sweeper/tracer split, but it's a cheap safety net if frontmatter silently fails for a given project or CC version. Consider un-deferring as an S2 (not S3) item, or at least naming it as the Task 7 failure fallback rather than leaving it unconnected. |
| Deferred: Option C, override built-in `Explore` with `model: haiku` | **Confirm deferral, tighten the trigger** | `claude-code-patches` shows Explore's model has been hardcoded in the bundle before (not "inherit"), and `lkv1988`'s report shows the UI-displayed model and the billed model can diverge for Explore specifically. Add to the trigger: verify via a real cost/usage log, not just the terminal's model label, that an Explore override actually changes what's billed. |
| Non-goal: hook-based enforcement (not currently in plan, but in this research's scope) | **Add as an explicitly rejected option, not merely unconsidered** | `#44412` (filed with a full repro, closed as duplicate of the still-open `#18346` family) shows `updatedInput` is documented to work generically but is currently broken specifically for the Agent tool. A future contributor proposing "let's add a hook that rewrites `model`" should be pointed at this issue rather than rediscovering the failure. Worth one line in the plan's Deferred & Debt section. |
| Non-goal: GLM 5.2 / non-Anthropic routing | **No change, but add a footnote** | `claude-code-router` is a plausible way to close the fallback gap in `fable-token-savings.md` ("GLM 5.2 unavailable in-session, falls back to Sonnet/Haiku"), but it routes by request category, not `subagent_type`, and wasn't verified against source. Out of scope for this plan; worth a one-line pointer in the token-efficiency cross-reference (Task 4) for whoever picks this up later. |
| Design detail: agent `description` wording | **Add, low cost** | `wshobson/agents`' convention of ending agent descriptions with "Use PROACTIVELY for X" is a specific, widely-used (202 agents) phrasing to bias Claude's own agent selection. The plan's current `sweeper`/`tracer` descriptions ("Use for…") could adopt this phrasing with no other changes. |
| Design detail: `model: inherit` | **No action** | Not applicable — the plan's agents use fixed models by design (that's the point). Noted only so a future reader doesn't mistake `inherit` for a bug; it's a deliberate wshobson idiom for user-chosen-model agents, unrelated to our two fixed-model agents. |

---

## Open questions

1. **Is the frontmatter bug fixed in the Claude Code version this project actually runs?** Not resolved here — the issue thread shows version-dependent behavior (works in some CC releases/modes, not others). Recommend checking `claude --version` in this host and treating Task 7's live smoke test result as version-specific, not permanent.
2. **Does `CLAUDE_CODE_SUBAGENT_MODEL_FORCE`** (named in the plan's already-confirmed facts) actually override a per-invocation `model` too, or only the frontmatter default? No source found in this research states its exact precedence; the plan's resolution-order note is not independently re-verified here beyond what was already confirmed before this task started.
3. **Does `claude-code-router` (or any proxy) read `subagent_type` from the Agent tool's request body** to route per-agent rather than per-category? Not found documented either way; would need source-level inspection of CCR, not just its README.
4. **Why does `#91890`'s user-scoped agent fail when `#89723` says project-level agents work?** Both are "project/user scoped, not plugin," yet one works and one doesn't in the reporters' hands. Possibly a live-edit/cache-reload issue (the reporter added the `model:` line mid-session before spawning) rather than a placement issue — not confirmed.
5. **Is `charliechan53/superpower-router` worth re-checking later?** Its README currently 404s; the repo may simply be broken or renamed. Not pursued further given zero stars and no working documentation.
