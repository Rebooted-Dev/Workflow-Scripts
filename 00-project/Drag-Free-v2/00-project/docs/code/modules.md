# Modules

## `scripts/` — Repository Maintenance

| Module | Path | Responsibility |
|--------|------|----------------|
| Pull | `scripts/pull-workflows.sh` | ff-only pull with dirty-tree and detached-HEAD guards |
| Update | `scripts/update-workflows.sh` | Maintainer staged-only commit + push |
| Sync | `scripts/sync-workflow-scripts.sh` | Multi-project batch pull (`PROJECTS[]`, flags, env vars) |
| Link check | `scripts/validation/check-active-markdown-links.sh` | Markdown link validation |
| Orchestrator check | `scripts/validation/check-orchestrator-review.sh` | Orchestrator workflow validation |
| Sync check | `scripts/validation/check-sync-workflow-scripts.sh` | Sync script portability and policy |
| Update check | `scripts/validation/check-update-workflows.sh` | Staged-only publish contract |
| Review policy check | `scripts/validation/check-review-workflow-policy.sh` | Agent policy and output routing |
| Changelog migrate (archived) | `00-project/build/archive/migrate-changelog.py` | One-time legacy CHANGELOG.md → `00-project/changelog/` |

## `00-orchestrator/` — Delegated Review

| Module | Path | Responsibility |
|--------|------|----------------|
| Review script | `00-Meta-Workflow/00-orchestrator/orchestrator-review.sh` | Launch OpenCode non-interactive review |
| Workflow doc | `00-Meta-Workflow/00-orchestrator/orchestrator-plan-review.md` | Full orchestrator workflow |
| Index | `00-Meta-Workflow/00-orchestrator/README.md` | Usage, architecture, CI notes |

## Workflow Categories (Instruction Modules)

Each numbered directory is a **module group** of related workflows:

| Group | Path | Workflows |
|-------|------|-----------|
| Setup | `00-project-setup/` | Bootstrap, optimize, sync, MCP, skills, track repos, migrate — see [README](../../../../../00-project-setup/README.md) |
| Planning | `01-planning-and-organizing/` | Research, review, finalise |
| Build | `02-code-build/` | Execution, confirm |
| Debug | `03-debugging/` | Bug description, bug fix |
| Documentation | `04-documentation/` | Create docs, sync docs, mark completed |
| Review | `05-review/` | Code review, optimization, refactoring, website data refactoring, comprehensive audit |
| Security | `06-security/` | Security review, security fix |
| Deployment | `07-deployment/` | Electron, ports, checklists |
| API Integration | `08-API-Integration/` | Genkit, AI SDK, MCP, misc guides |

## `11-Skills/` — Codex Skill Bundles

14 skill bundles; each contains `SKILL.md` + `agents/openai.yaml`:

| Skill | Wraps |
|-------|-------|
| `workflow-plan-review-finalize` | Planning workflows |
| `execute-and-confirm-plan` | Build workflows |
| `repo-logs-and-docs-sync` | Changelog + documentation |
| `filed-code-review-to-remediation` | Review → fix pipeline |
| `dirty-worktree-safe-publish` | Safe git publish |
| `prompt-quality-auditor` | Prompt QA |
| `workflow-bug-fix-plan-and-logs` | Debug workflows |
| `multi-agent-plan-orchestration` | Orchestrator |
| `provider-plumbing-auditor` | API integration audits |
| `provider-capability-verification` | Provider capability checks |
| `webhook-bot-hardening-reviewer` | Webhook security |
| `live-bot-launch-verification` | Bot launch checks |
| `export-render-parity-debugger` | Render parity debugging |
| `execution-artifact-triage` | Build artifact triage |

Research scan (not a skill bundle): `11-Skills/2026-05-24-workflow-scripts-skill-candidate-scan.md`.

## `@ai-sdk/image-generation` — TypeScript Package

Path: `08-API-Integration/02-AI-SDK/src-core/@ai-sdk/image-generation/`

| Module | Path | Responsibility |
|--------|------|----------------|
| Entry | `src/index.ts` | Public API exports |
| Generator | `src/core/generator.ts` | Image generation orchestration |
| Registry | `src/core/registry.ts` | Provider registration and lookup |
| OpenAI | `src/providers/openai.ts` | OpenAI image provider |
| Google | `src/providers/google.ts` | Google image provider |
| xAI | `src/providers/xai.ts` | xAI image provider |
| Fal | `src/providers/fal.ts` | Fal image provider |
| Config | `src/config/` | Provider configuration |
| Utils | `src/utils/` | Shared helpers |

Tests: `tests/unit/` (vitest).

## `00-project/` — Meta Modules

| Module | Path | Responsibility |
|--------|------|----------------|
| Changelog | `00-project/changelog/` | One file per change + `index.md` |
| Troubleshooting | `00-project/troubleshooting/` | Bug/issue entries + `index.md` |
| Plans | `00-project/plans/` | Active plans, `TODO.md` |
| Research | `00-project/research/` | Review/audit/research reports |
| Plans completed | `00-project/plans-completed/` | Filed completed plans |
| Docs | `00-project/docs/` | This documentation set |
| Agent rules | `00-project/AGENTS.md` | Slim agent instructions |

## Import / Export Patterns

- **Shell scripts**: sourced libs minimal; each script is self-contained with `REPO_ROOT` resolution
- **Skills**: `SKILL.md` exports trigger conditions; points to workflow paths (no code imports)
- **Image package**: `src/index.ts` re-exports public API; providers registered via registry module
- **Workflows**: cross-reference via relative Markdown links and shared rubric path