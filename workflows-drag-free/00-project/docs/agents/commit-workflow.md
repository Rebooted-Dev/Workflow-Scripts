# Commit & PR Workflow (workflows-drag-free)

## Where to commit

Commit under **Workflow-Scripts** (not Update-AI-Tools for these paths, unless the parent repo intentionally tracks them):

```bash
cd /Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts
git add workflows-drag-free/
git commit -m "docs: describe the change"
git push
```

## Message style

- Conventional Commits: `feat:`, `fix:`, `docs:`, `refactor:`, `config:`, etc.
- Mention `workflows-drag-free` or `00-project` when the change is scoped to this tree.
