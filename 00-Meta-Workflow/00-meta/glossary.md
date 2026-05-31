# Workflow Terminology Glossary

Common terms and conventions used across Workflow-Scripts documentation.

## Priority Levels (P0–P3)

| Term | Definition | When to Use |
|------|-----------|-------------|
| **P0 Blocker** | Critical path issue; must fix before merge | Security-critical, data loss, total outage, release-stoppers |
| **P1 Urgent** | High impact; fix before release | Major functionality broken, high user impact, likely failures |
| **P2 Soon** | Medium impact; fix next sprint | Important improvements, tech debt with near-term value |
| **P3 Backlog** | Low impact; track and defer | Nice-to-have, long-term refactors, cosmetic issues |

## Severity Levels (S0–S3)

| Term | Definition | Examples |
|------|-----------|----------|
| **S0 Critical** | Security breach, data loss, total outage | Auth bypass, data corruption, service down |
| **S1 High** | Major functionality broken, wide user impact | Core feature fails, widespread errors |
| **S2 Medium** | Partial failure, workaround exists | Edge case bugs, degraded performance |
| **S3 Low** | Minor UX, cosmetic, maintainability | Typos, inconsistent formatting, code style |

## Workflow Categories

| Directory | Purpose |
|-----------|---------|
| **01a-orchestrator/** | Launch non-interactive OpenCode processes to delegate workflows |
| **00-project-setup/** | Set up new projects with dual repo management |
| **00-meta/** | Templates, rubrics, analysis documents about workflows |
| **00-docs/** | Generated reports, archived reviews, analysis documents |
| **01-planning/** | Create and review implementation plans |
| **02-build-code/** | Execute implementation with verification |
| **03-debug/** | Systematically identify and fix bugs |
| **04-documentation/** | Keep documentation in sync with code |
| **05-review-audit/** | Review code and plans for quality |
| **06-security/** | Security reviews and fixes |
| **07-deployment/** | Deployment guides and configuration |
| **08-API-Integration/** | API integration guides |

## Task Marking Conventions

| Symbol | Meaning |
|--------|---------|
| `- [✅]` | Completed task — mark immediately after completion and verification |
| `- [ ]` | Pending or in-progress task |
| `**Status:** ✅ COMPLETED` | Plan or document fully complete |

## Agent Concepts

| Term | Definition |
|------|-----------|
| **Parallel agents** | Multiple AI agents working simultaneously on different aspects of a task |
| **Spawn additional agents** | Create more agents when discovering new concerns or complexity |
| **Parallel batch reading** | Reading multiple files concurrently rather than sequentially |

## Repository Management

| Term | Definition |
|------|-----------|
| **Multi-repo** | Project has multiple repositories (main app + Workflow-Scripts) |
| **Nested repo** | Workflow-Scripts cloned as separate git repo inside project directory |
| **Host project** | The main application project using these workflows |

## Documentation Structure

| Term | Definition |
|------|-----------|
| **Changelog** | Record of changes: `changelog/<type>/<YYYY-MM-DD>-<title>.md` |
| **Troubleshooting** | Issue records: `troubleshooting/<category>/<YYYY-MM-DD>-<title>.md` |
| **Plans** | Active plans in `plans/`; completed plans moved to `plans-completed/` |
| **00-docs/** | Generated reports and archived analysis |
| **00-meta/** | Templates and rubrics for workflow design |

## Common Placeholders

When you see these in workflow files, replace with actual values:

| Placeholder | Replace With |
|-------------|--------------|
| `<PROJECT_NAME>` | Your project name (e.g., "my-app") |
| `<PROJECT_PATH>` | Full path to project (e.g., "/Users/name/projects/my-app") |
| `<WORKFLOWS_DIR>` | Workflows directory name (e.g., "Workflow-Scripts") |
| `<GIT_REMOTE>` | Your project's git remote URL |
| `<WORKFLOWS_REMOTE>` | Workflows repo URL |

## Report & Document Naming Conventions

When workflows generate reports or analysis documents, follow the convention defined in [`naming-conventions.md`](./naming-conventions.md).

**Quick Reference:**
- **Format:** `{report-type}-YYMMDD-HHMM-{model}.md`
- **YYMMDD**: 2-digit year, month, day
- **HHMM**: 24-hour format time
- **{model}**: AI model name (e.g., `claude`, `gpt4`, `gemini`)

**Examples:**
- `code-review-260404-1430-claude.md`
- `security-audit-260403-0920-gpt4.md`

---

**See also:**
- Severity & Priority Rubric: [`severity-priority-rubric.md`](./severity-priority-rubric.md)
- Main README: [`../README.md`](../../README.md)
