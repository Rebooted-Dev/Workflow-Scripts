# Testing Strategy (workflows-drag-free)

- Prefer existing Workflow-Scripts validation scripts and `tools/wf validate` when available.
- When fixing workflow or tooling bugs, **add a regression test when it fits** (shell check, link check, or small fixture).
- Manual verification: confirm indexes still list new entries; confirm dated filenames use `YYYY-MM-DD`.
