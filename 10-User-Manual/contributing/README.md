# Contributing Guide

## Who This Is For

This guide is for developers who want to modify, improve, or contribute to the Workflow-Scripts repository itself — not for people who simply use the workflows in their projects.

## Development Setup

### Prerequisites

- Git
- Bash (macOS or Linux)
- A GitHub account (for pull requests)

### Clone the Repository

```bash
git clone https://github.com/Rebooted-Dev/Workflow-Scripts
cd Workflow-Scripts
```

### Branch

Work on feature branches off `main`:

```bash
git checkout -b docs/improve-execution-workflow
```

## How To Make Changes

### File Conventions

- **Numbered prefixes** (e.g., `01-`, `02-`) indicate sequence or workflow order
- **Descriptive names** for standalone files
- **Each directory** should have a `README.md` with navigation guidance
- Use **kebab-case** for filenames

### Commit Conventions

Use concise, imperative commit messages:

```
docs: clarify execution workflow verification steps
fix: resolve task marking contradiction in build-code
feat: add orchestrator review workflow
```

Common prefixes: `docs:`, `fix:`, `feat:`, `chore:`, `refactor:`

### Coding Standards

- Keep changes small and focused
- Match the style of existing files in the area you edit
- Include "When to Use" and "How to Use" sections in workflow files
- Reference the shared rubric (`00-meta/severity-priority-rubric.md`) for priority scoring
- Use the flexible agent pattern: "Suggested agent roles (spawn additional agents as needed)"

### Updating the Master Index

If you add or rename workflow files, update `README.md`:
- The decision table
- The detailed workflow descriptions
- The file structure diagram

## Pull Request Process

1. Ensure your changes are consistent with existing workflows
2. Update `README.md` if you add/rename workflows
3. Update `CHANGELOG.md` with a description of your change
4. Create a PR against `main` on GitHub
5. Describe what changed and why

### PR Checklist

- [ ] Changes are focused and small
- [ ] File naming follows existing conventions
- [ ] `README.md` updated if workflows added/renamed
- [ ] `CHANGELOG.md` updated
- [ ] No secrets or credentials committed
- [ ] Tested shell script changes locally

## Security and Secrets

- Never commit secrets, API keys, or credentials
- Use environment variables for any sensitive configuration
- The `sync-workflow-scripts.sh` script has a configurable `BASE_DIR` — do not commit paths containing sensitive project locations

## Getting Help

- Open an issue on [GitHub](https://github.com/Rebooted-Dev/Workflow-Scripts)
- Check `00-docs/` for internal reviews and analysis documents

## See Also

- [Developer Guide](../developer-guide/README.md) — Architecture and file map
- [Workflow-Scripts README](../../README.md) — Master workflow index
- [SHARING_AND_SYNC](../../SHARING_AND_SYNC.md) — Multi-project sharing guide
