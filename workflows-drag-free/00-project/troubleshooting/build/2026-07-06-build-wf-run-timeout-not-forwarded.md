---
date: 2026-07-06
category: build
title: wf run timeout not forwarded
status: resolved
---

# wf run Timeout Not Forwarded

## Issue

`tools/wf run` exposed a `--timeout` option, but the command did not pass the value through to `tools/orchestrator/orchestrator-review.sh`.

## Impact

Callers could believe a non-stub provider run was bounded, while the orchestrator would still use its default timeout behavior.

## Evidence

`tools/wf run --help` listed `--timeout`, but `cmd_run()` built the orchestrator command with only the plan path and `--output`.

## Resolution

Resolved on 2026-07-06 by appending `--timeout <value>` to the orchestrator command when the caller supplies `args.timeout`.

## Validation

Running `tools/wf run ... --timeout 5` now reaches the orchestrator with `Timeout: 5 minutes`.
