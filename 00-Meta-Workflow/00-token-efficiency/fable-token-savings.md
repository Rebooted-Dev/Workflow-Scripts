# Token Savings Plan — Claude Code Skill

Implementation-specific to **Claude Code**. Installs as a **skill only** (no `CLAUDE.md` patch). The skill is discovered and loaded on demand, keeping the system prompt lean (which is the whole point).

> Scope note: This plan targets Claude Code. It is NOT portable to Factory Droid (which uses `.factory/droids/` + the `Skill` tool with named skills) or other agent runtimes. Claude Code-specific features used: `.claude/skills/*/SKILL.md` discovery, `/compact`, `/context`, `/rewind`, `ENABLE_PROMPT_CACHING_1H=1`, cache usage fields, and the reviewer/implementer subagent pattern.

> **Installed globally** at `~/.claude/skills/token-efficiency/SKILL.md` so it applies to every project on this machine, not just this repo.

---

## 1. The skill file

Claude Code discovers skills as **one directory per skill** containing a `SKILL.md`. Two valid locations:

- **Global (all projects):** `~/.claude/skills/token-efficiency/SKILL.md` ← used here
- **Project-scoped (committable):** `<repo>/.claude/skills/token-efficiency/SKILL.md`

> Frontmatter note: Claude Code skills only honor `name` and `description`. `model:` / `effort:` are **not** part of the skill schema and are ignored — model/effort routing must live in the body as guidance (applied manually via `/model`, `/effort`, or per-subagent). The `description` is the sole trigger the model reads to decide whether to auto-load the skill, so keep it specific about *when* to activate.

Full content:

```markdown
---
name: token-efficiency
description: Guidelines for minimizing token usage, maximizing prompt cache hits, efficient model delegation, context management, and cost-effective long-running sessions in Claude Code / Fable. Activate whenever the active model is Fable (any Fable variant, e.g. Fable 5) — Fable is the premium orchestration model, so cost discipline always applies. Also use for long-running or complex tasks, multi-phase agent workflows, when approaching usage limits, or any time you want to reduce cost or improve cache hit rate. Prefers GLM 5.2 for execution outside Fable when available.
---

# Token Efficiency Guidelines

## Core Principles
- **Stable prefixes win**: Keep system instructions, CLAUDE.md content, tool definitions, and routing rules consistent. Changes early in the prompt invalidate cache for everything after.
- **Minimize mid-task changes**: Set model and effort level at the start of a task. Avoid switching models or effort levels unless necessary.
- **Active sessions stay cheap**: With 5-minute TTL, frequent turns keep the cache warm. Long pauses trigger expensive full recomputes.
- **Scope aggressively**: Always define "Files touched" lists. Never let implementation touch files outside the approved plan.
- **Prefer cheap models for execution**: Reserve Fable for planning, judgment, and review. Use GLM 5.2 for implementation (fallback: Sonnet/Haiku) when GLM 5.2 is unavailable.

## Model Routing & Delegation (Default Behavior)
The higher your tier, the more you delegate. Push work down. Keep your own context for judgment.

| Model    | Best for                  | Delegate?         | Effort  | Notes |
|----------|---------------------------|-------------------|---------|-------|
| GLM 5.2  | Bulk mechanical, scoped research, implementation, multi-step reasoning | When it helps | low–xhigh | Preferred model outside Fable; scale effort to task. Fallback to Haiku/Sonnet/Opus if unavailable |
| Fable 5  | Judgment, taste, planning, review | By default     | medium  | Use xhigh only for hardest calls |

**Escalation rule**: If a child model encounters work above its tier, return it to the parent instead of attempting it. Never escalate automatically.

**Orchestrator-Executor Pattern** (recommended for complex tasks):
1. You (Fable xhigh, or GLM 5.2 xhigh if Fable unavailable) act as **Orchestrator**: Write detailed plan + "Files touched" list + todo.
2. Before showing plan to user, call `reviewer` subagent (Fable xhigh) to critique the plan.
3. Revise plan based on critique → present to user for approval.
4. Delegate **all** implementation to `implementer` subagent (GLM 5.2 medium, or Sonnet if unavailable).
5. After implementation, call `reviewer` subagent on scoped diff for final review.
6. Human gates after plan and after diff review.

## Prompt Caching Best Practices
- Place stable/reusable content (instructions, routing rules, tool definitions, large context) at the **beginning** of prompts.
- Use automatic caching (Claude Code default). Avoid unnecessary changes to early content.
- For long breaks: Use 1-hour TTL (`ENABLE_PROMPT_CACHING_1H=1`) or `/compact` before pausing.
- Monitor cache performance via usage fields (`cache_read_input_tokens` vs `cache_creation_input_tokens`). Aim for high read ratio.
- After `/compact` or long pauses, the next turn may be a full cache write — budget for it.

## Context Management Rules
- Keep main CLAUDE.md under ~200-300 lines. Move detailed rules and examples here (this file).
- Use `/context` regularly to audit usage.
- Use `/compact` at natural task boundaries (not mid-task).
- Prefer `/rewind` when abandoning a path.
- Create handoff `.md` files at major phase ends so new sessions can continue cleanly.
- One topic per thread when possible. Edit the original prompt instead of chaining corrections.

## Output Style (Caveman Mode)
Respond tersely and precisely:
- Short sentences only.
- No filler, preambles, hedging, or unnecessary explanations.
- Result / diff / summary / command first.
- Only explain when explicitly asked.
- This typically reduces output tokens by 65-75% with no loss in code quality.

## Tool & CLI Handling
- Prefer lightweight tools first (text-based over screenshot-based).
- Use RTK (or equivalent) to filter/compress terminal output before it enters context.
- Use Context Mode or similar for MCP/tool output summarization when available.
- Never dump raw large outputs (build logs, test results, grep) without compression.

## Session Workflow Recommendations
1. Start with clear goal and plan (orchestrator mode).
2. Get human approval on plan before heavy implementation.
3. Use subagents with fresh context for scoped work.
4. Review diffs with high-intelligence model before shipping.
5. Compact or handoff at logical stopping points.
6. When cache feels cold or context is bloated → compact + continue or start fresh with handoff file.

## When to Apply These Guidelines
- **Whenever the active model is Fable** (any Fable variant) — the premium orchestration model, so delegate execution downward and keep the cache warm
- Long-running or complex tasks
- When approaching usage limits
- Multi-phase agent workflows
- Any time you want to reduce cost or improve cache hit rate
- Before starting a new major feature or debugging session
```

---

## 2. Installation (skill only)

### Global — applies to every project on this machine (used here)

```bash
mkdir -p ~/.claude/skills/token-efficiency
# save the content above as ~/.claude/skills/token-efficiency/SKILL.md
```

Nothing to commit — this lives in your personal `~/.claude` config, alongside your other global skills. It is available in all repos automatically.

### Alternative — project-scoped and committable (team benefit)

```bash
mkdir -p <repo>/.claude/skills/token-efficiency
# save the content above as <repo>/.claude/skills/token-efficiency/SKILL.md
git add .claude/skills/token-efficiency/SKILL.md
git commit -m "feat: add token-efficiency skill"
```

No `CLAUDE.md` patch is added in either case. The skill is discovered by Claude Code from the `skills/` directory and loaded on demand, so it costs zero tokens when not in use.

### Verify

Start a new session and run `/context` — `token-efficiency` should appear in the skills list. (New skills are indexed at session start, so an already-open session won't see it until reloaded.)

---

## 3. Invocation

Trigger the skill explicitly when relevant:

- "Apply token-efficiency guidelines for this task."
- "Use the orchestrator-executor pattern from the token-efficiency skill."
- Or let Claude Code discover and load it automatically when a long/complex task is detected.

---

## Why skill-only (not patched files)

- **Token cost**: Embedding ~150 lines of rules directly in `CLAUDE.md` would bloat the system prompt on every turn, undercutting the goal.
- **On-demand loading**: Skills load only when relevant; patched files are always in context.
- **Separation of concerns**: Core config stays focused; optimization rules are versioned and updateable independently.
- **Discovery**: The `.claude/skills/<name>/SKILL.md` layout is the idiomatic Claude Code mechanism for this — global (`~/.claude`) or project-scoped (`<repo>/.claude`).
