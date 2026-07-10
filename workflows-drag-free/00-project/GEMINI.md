# Repository Guidelines (Gemini)

workflows-drag-free: Drag-Free workflow tree meta workspace under Workflow-Scripts.

## Core Principles

- Follow the project's architectural principles (workflow clarity, configuration-driven routing, parallel execution where appropriate).
- See AGENTS.md for Execution, Repository Management, Changelog & Troubleshooting.
- **Bugs:** add regression test when it fits.

## Essential Standards

- **Coding**: Prefer clear markdown and careful shell; Conventional Commits (`feat:`, `fix:`, `docs:`, etc.).
- **Docs**: Update changelog (`changelog/` directory) and troubleshooting (`troubleshooting/`) when applicable (see AGENTS.md).
- **Plans**: See `plans/README.md` and `plans/TODO.md`. Active plans in `plans/` or `build/`. **Completed plans filing rule:** When the user asks to file a plan as completed, move it to **`plans-completed/<category>/`**, update **`plans-completed/index.md`**, and add a Type=plan row to **`changelog/index.md`** (File `../plans-completed/...`). See [Changelog & Troubleshooting](docs/agents/changelog-and-troubleshooting.md) § Plans completed.

## Quick Reference

- **Git root**: Workflow-Scripts repository (`Workflow-Scripts/`).
- **Project structure**: See [Project Structure](docs/agents/project-structure.md).
- **Changelog, troubleshooting, docs, plans**: See AGENTS.md.

## Tracked Repositories

See [Repository Map](docs/agents/repository-map.md) for paths, remotes, and sync instructions.

## Detailed Documentation

For comprehensive information, see:

- [Project Structure & Organization](docs/agents/project-structure.md)
- [Development Workflow](docs/agents/development-workflow.md)
- [Coding Standards](docs/agents/coding-standards.md)
- [Testing Strategy](docs/agents/testing-strategy.md)
- [Commit & PR Workflow](docs/agents/commit-workflow.md)
- [Documentation Workflow](docs/agents/documentation-workflow.md)
- [Security Guidelines](docs/agents/security-guidelines.md)
- [Changelog & Troubleshooting](docs/agents/changelog-and-troubleshooting.md)

For repository management, changelog, troubleshooting, and plans (README + TODO), see **AGENTS.md**.
