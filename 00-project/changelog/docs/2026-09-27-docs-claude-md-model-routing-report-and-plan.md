# Correct CLAUDE.md model-routing gap report and file implementation plan

**Date:** 2026-09-27
**Type:** docs

## Summary

Verified and corrected [`research/2026-09-27-claude-md-model-routing-instructions-gap.md`](../../research/2026-09-27-claude-md-model-routing-instructions-gap.md), then ran `01-planning-and-organizing/03-plan-review-and-finalise.md` over its Recommended fix.

- **Report corrections:** Finding 2 was false: `00-Meta-Workflow/00-token-efficiency/fable-token-savings.md:37` already holds a routing policy. Consequence 4 overstated `AGENTS.md` as mandating parallel agents. Added Finding 7 (token-efficiency skill vs `CLAUDE.md` precedence) and a Corrections table.
- **Review:** addendum appended to the report (S1/P1: versioned names in the template recreate the staleness risk; S1/P1: second routing policy with no precedence).
- **Plan:** [`plans/2026-09-27-claude-md-model-routing-implementation-plan.md`](../../plans/2026-09-27-claude-md-model-routing-implementation-plan.md) (T2, DRAFT) — alias-only template block, conditional create on update, warning-only checks, cross-links. Passes `check-plan.sh`. No `PLAN.reviews/` directory was used.

- **Plan revised (23:21):** routing moved from a `CLAUDE.md` table to project agent definitions (`.claude/agents/sweeper.md` `model: haiku`, `tracer.md` `model: sonnet`) with a short `CLAUDE.md` pointer. Reason: per the Claude Code subagents docs, agent frontmatter `model` is applied by Claude Code, a per-invocation `model` overrides it, and built-in Explore inherits the main model. An `Explore` override is deferred with a trigger.

- **Prior art (23:42):** added [`research/2026-09-27-claude-code-subagent-routing-prior-art.md`](../../research/2026-09-27-claude-code-subagent-routing-prior-art.md) (research subagent, Sonnet) with verification notes correcting two overstated claims (hook `updatedInput` "confirmed broken"; claude-mpm archived doc presented as current). Plan revised: live check repeated per Claude Code upgrade and across Opus/Fable/`opusplan` (open issues #91890, #93157); documented fallback pointer passing `model` explicitly; "Use PROACTIVELY" descriptions borrowed from wshobson/agents; hook enforcement recorded as rejected Option D with a re-test trigger.

No workflow files changed yet; implementation is pending plan approval.
