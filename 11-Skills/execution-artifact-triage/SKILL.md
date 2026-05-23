---
name: execution-artifact-triage
description: Triage saved runtime artifacts before editing code. Use when the user asks to inspect project/execution, project/errors, console.md, terminal.md, output.md, saved logs, warning output, large log-like files, or asks whether a warning/error needs a fix.
---

# Execution Artifact Triage

Use this skill when saved runtime evidence is the source of truth.

## Workflow

1. Read artifacts first.
   - Inspect the named files before code edits.
   - Check timestamps, repeated sections, stale noise, truncation, and whether artifacts are tracked evidence.
   - If the user asks about large logs, measure size and references before recommending deletion.

2. Classify evidence.
   - Current blocker, current warning, benign framework noise, stale prior failure, upstream/service issue, environment issue, or generated output artifact.
   - Separate saved console/terminal evidence from assumptions about the runtime.

3. Trace only as needed.
   - Use code search to map the logged route/component/export/provider path.
   - Avoid changing code just to silence a warning unless it affects behavior, tests, build, packaging, or user output.

4. Recommend or proceed.
   - If the user asked only to investigate, provide cause, impact, and next action.
   - If the user asked to fix, hand off to `workflow-bug-fix-plan-and-logs` with the classified evidence.
   - Prefer truncating or preserving tracked evidence logs over deleting referenced artifacts.

## Guardrails

- Do not treat a non-empty log as current truth without checking recency and context.
- Do not delete tracked evidence files unless explicitly asked and references are reconciled.
- Do not conflate old npm audit/provider failures with the current warning under investigation.
