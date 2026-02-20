# Debug Workflows

This directory contains workflows for systematically identifying and fixing bugs.

## Workflow Index

| File | Purpose | When to Use |
|------|---------|-------------|
| [`02-bug-fix-workflow.md`](./02-bug-fix-workflow.md) | Initial bug investigation and fix | **Start here** - When a bug is first reported |
| [`01-bug-description.md`](./01-bug-description.md) | Comprehensive bug documentation | When a bug persists after initial fix attempts |

## Workflow Sequence

```
Bug Reported
     │
     ▼
┌────────────────────────┐
│ 02-bug-fix-workflow.md │  ◀── Start here for initial investigation
│ (Initial investigation) │
└──────────┬─────────────┘
           │
           ▼
      Bug Fixed? ───Yes──▶ Done (update changelog + troubleshooting)
           │
           No
           │
           ▼
┌────────────────────────┐
│ 01-bug-description.md  │  ◀── Escalate to detailed documentation
│ (Persistent bug report) │
└────────────────────────┘
```

> **Note on file numbering**: The files are numbered based on documentation depth, not workflow sequence. Start with `02-bug-fix-workflow.md` for initial investigation.

## Quick Decision Guide

**Is this a newly reported bug?**
- Yes → Use [`02-bug-fix-workflow.md`](./02-bug-fix-workflow.md)

**Has the bug persisted after multiple fix attempts?**
- Yes → Use [`01-bug-description.md`](./01-bug-description.md) to create comprehensive documentation

## Key Concepts

### Hypothesis-Driven Investigation

Both workflows use a hypothesis-driven approach:
1. Gather evidence (logs, screenshots, reproduction steps)
2. Formulate hypotheses about root cause
3. Investigate using parallel agents
4. Identify root cause with evidence
5. Implement and verify fix

### Parallel Agent Pattern

Both workflows use 5 parallel agents for investigation:
- Agent 1: Trace through codebase / Review troubleshooting history
- Agent 2: Analyze error logs / Review changelog
- Agent 3: Check for similar bugs / Examine codebase context
- Agent 4: Review recent changes / Review error evidence
- Agent 5: Examine data flow / Investigate patterns

### Documentation Requirements

After fixing bugs:
- Update changelog (`docs/CHANGELOG.md` or `CHANGELOG.md`)
- Create troubleshooting entry in `troubleshooting/` directory
- Update `troubleshooting/index.md`
- **Regression tests:** Add a regression test when it fits. Ensure project agent files (AGENTS.md, CLAUDE.md, GEMINI.md) include **Bugs: add regression test when it fits.** so all agents do this automatically (see [00-project-setup/01-setup-project.md](../00-project-setup/01-setup-project.md) Step 1.3).

## Related Workflows

- [Code Review](../05-review-audit/01-code-review.md) - May identify bugs during review
- [Security Fix](../06-security/02-security-fix.md) - For security-related bugs
- [Execution](../02-build-code/01-execution.md) - For implementing the fix
