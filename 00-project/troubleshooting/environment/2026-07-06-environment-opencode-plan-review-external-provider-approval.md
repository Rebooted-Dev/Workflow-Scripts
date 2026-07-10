---
date: 2026-07-06
category: environment
title: OpenCode plan review requires external provider approval
status: blocked
---

# OpenCode Plan Review Requires External Provider Approval

## Issue

A real `tools/wf run plan-review` attempt reached the non-stub OpenCode path, but the first sandboxed run failed because OpenCode tried to open its log outside the workspace. The escalated rerun was rejected because it would send repository plan content through an external model/provider path without explicit approval.

## Impact

The workflow command path and manifest generation were exercised, but the TODO item for a successful non-stub provider review cannot be marked complete until the user explicitly approves the external-provider run.

## Evidence

Sandboxed command:

```bash
tools/wf run plan-review 00-project/plans/Drag-Free-v2/research/2026-07-06-workflow-system-v2-redesign-proposal.md --output 00-project/plans/Drag-Free-v2/research/2026-07-06-workflow-system-v2-redesign-proposal.reviews/2026-07-06-opencode-plan-review.md --timeout 5

> **Path note (2026-07-10):** Plan package relocated to `workflows-drag-free/00-project/research/2026-07-06-workflow-system-v2-redesign-proposal.md` (and sibling `.reviews/`). The command above records the original run path.
```

Generated output:

```text
Error: Unexpected error

Unknown: FileSystem.open (/Users/jesse/.local/share/opencode/log/opencode.log)
```

The generated manifest records `status: failed` and `exit_code: 1`.

## Resolution

Blocked pending explicit user approval for an external OpenCode provider run over the repository plan file.
