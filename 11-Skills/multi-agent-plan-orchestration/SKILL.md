---
name: multi-agent-plan-orchestration
description: Orchestrate multiple independent agents or model passes to produce a stronger implementation plan. Use when the user asks to launch multiple agents/models, use opencode in single-line mode, run independent parallel research/proposals, add an adversarial critique stage, or synthesize a coding-agent-ready handoff plan.
---

# Multi Agent Plan Orchestration

Use this skill for complex planning where independent passes and critique are worth the overhead.

## Workflow

1. Define the orchestration goal.
   - Confirm the desired output is a plan or handoff, not direct implementation, unless the user says otherwise.
   - Define source files, research targets, constraints, output directory, and acceptance criteria.

2. Split independent passes.
   - Assign separate agents or model runs to research, architecture, risk review, test strategy, migration order, or alternative proposals.
   - Give each pass minimal task-local context and require file/source evidence.
   - Keep outputs separate for review.

3. Critique and reconcile.
   - Compare proposals for contradictions, missing gates, unsupported assumptions, and implementation risk.
   - Use an adversarial critique pass when the user asks for it or the plan is high-impact.
   - Verify important claims against current repo files before accepting them.

4. Synthesize the handoff.
   - Produce one coding-agent-ready plan with phases, exact files, tests, rollback, docs/logging, and open questions.
   - Preserve source discipline and cite which proposals influenced the final plan.
   - File the result in the requested project directory when asked.

## Guardrails

- Do not collapse independent passes into a single brainstorm when the user requested parallelism.
- Do not pass final conclusions into critique agents unless the goal is targeted review.
- Do not start implementation from orchestration output until the user authorizes execution.
