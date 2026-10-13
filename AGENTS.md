# Workflow-Scripts Agent Rules

These rules apply when you **change** files in this repository. If you are only reading workflows to apply them to a host project, follow the host project's rules and log there.

## Execution

- Use parallel sub-agents only for independent scopes where doing so materially reduces latency or improves confidence. Keep dependent work sequential; assign non-overlapping write ownership and verify findings before acting on them. Handle small localized work directly.
- Use at most **12 concurrent sub-agents per task**, including any nested sub-agents, subject to the runtime's available concurrency limit. This is a ceiling, not a target.

## Agent Learnings

- **Before non-trivial work:** read `00-project/learnings/index.md` and follow each entry marked ACTIVE.
- **After a mistake, a correction, or a verified non-obvious fact:** add an entry under `00-project/learnings/<category>/` and a row at the top of `00-project/learnings/index.md` (conventions in `00-project/learnings/README.md`), then tell the user what you added and where. Mark an entry ACTIVE only when it is verified or recurring. Learnings are not changelog or troubleshooting entries.
- **Check the log:** after changing `00-project/learnings/`, run `bash scripts/validation/check-learnings.sh`. Its self-test is `scripts/validation/check-learnings-selftest.sh`.

## Logging changes to this repository

- Every change to Workflow-Scripts is logged in **`00-project/`**, even when the session started in a host project that has this repository cloned or linked inside it. Never log Workflow-Scripts changes in a host project's `project/` directory.
  - **Changelog (every change):** `00-project/changelog/<type>/<yyyy-mm-dd>-<type>-<short-title>.md` plus a row at the top of `00-project/changelog/index.md`.
  - **Troubleshooting (every fix):** `00-project/troubleshooting/<category>/<yyyy-mm-dd>-<category>-<short-title>.md` plus a row at the top of `00-project/troubleshooting/index.md`. Here the workflows *are* the product, so a workflow defect is a bug: a contradiction, a broken handoff, a rule agents follow wrongly, a script failure, or a wrong or broken reference. See the waiver rule in [`00-project/AGENTS.md`](00-project/AGENTS.md).
- If one task changes both a host project and this repository, each repository gets its own entries. Cross-link them.
- Commit from this repository's root. `scripts/validation/check-meta-logs.sh` enforces the logging rules. Enable it once per clone with `git config core.hooksPath scripts/hooks`.

Full meta rules and conventions: [`00-project/AGENTS.md`](00-project/AGENTS.md).
