# Development Workflow (workflows-drag-free)

## Working on this tree

1. Prefer editing under `Workflow-Scripts/workflows-drag-free/`.
2. Run git from the **Workflow-Scripts** repository root.
3. After material changes, update `00-project/changelog/` (and troubleshooting when applicable).
4. Active plans live in `00-project/plans/`; file completed plans to `00-project/plans-completed/<category>/`.

## Validation (when available)

From Workflow-Scripts root, prefer project validation scripts or `tools/wf` if present in this tree or the live repo:

```bash
cd /Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts
# Examples (if present):
# bash scripts/validation/check-active-markdown-links.sh
# tools/wf validate
```

## Commits

Use Conventional Commits (`feat:`, `fix:`, `docs:`, `config:`, etc.) when committing Workflow-Scripts changes.
