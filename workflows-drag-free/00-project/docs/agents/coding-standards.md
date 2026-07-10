# Coding Standards (workflows-drag-free)

This workspace is primarily **markdown workflows**, catalogs, and shell tooling.

- Prefer clear, skimmable markdown; keep agent-facing docs under `00-project/docs/agents/`.
- Workflow filenames and dated artifacts use **YYYY-MM-DD** prefixes where the conventions require them.
- Shell scripts: prefer `set -euo pipefail` for new scripts; avoid destructive git operations without explicit user confirmation.
- Do not invent nested `project/` wrappers under `00-project/` — this meta is **flattened**.
