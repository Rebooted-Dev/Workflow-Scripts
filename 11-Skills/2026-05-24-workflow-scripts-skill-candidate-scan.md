# Workflow-Scripts Skill Candidate Scan

**Date:** 2026-05-24  
**Scope:** `/Users/jessesng/Development Projects/Current Projects/Flash-UI-Idea-Generator/Workflow-Scripts`, excluding `Workflow-Scripts/11-Skills/`  
**Output:** Skill candidate report for reusable Codex skills/subagents

## Executive Summary

The Workflow-Scripts repository contains several strong candidates for new skills, especially where the existing workflow is long, domain-specific, and repeatedly useful across repos. The best candidates are not the large end-to-end process workflows already covered by the new `11-Skills/` set; they are narrower operational domains such as project bootstrap, repo-map generation, MCP setup, Electron packaging, port management, pre-deployment security, and SEO/GEO monitoring.

Recommended next batch:

1. `project-bootstrap` / alias `bootstrap`
2. `repo-map-sync` / alias `repo-map`
3. `mcp-config-setup` / alias `mcp-setup`
4. `skills-install-triage` / alias `skills-setup`
5. `electron-macos-packaging` / alias `mac-build`
6. `electron-vite-migration` / alias `electron-vite`
7. `dev-port-manager` / alias `ports`
8. `pre-deploy-security` / alias `deploy-check`
9. `seo-geo-launch-check` / alias `seo-geo`
10. `documentation-builder` / alias `docs-build`

These are high-value because they encode long, error-prone checklists into triggerable skills while preserving the workflow docs as deeper references.

## Method

- Enumerated Markdown and shell files under `Workflow-Scripts/`, pruning `11-Skills/`.
- Reviewed directory indexes and representative long workflow files.
- Compared candidates against the six already-created skills:
  - `workflow-plan-review-finalize`
  - `execute-and-confirm-plan`
  - `repo-logs-and-docs-sync`
  - `filed-code-review-to-remediation`
  - `dirty-worktree-safe-publish`
  - `prompt-quality-auditor`
- Prioritized candidates that are reusable, domain-specific, failure-prone, and likely to benefit from concise trigger metadata plus references to existing workflow docs.

## Existing Skill Coverage

Do not duplicate these areas unless creating a narrower specialist:

| Existing skill | Covered workflow area |
|---|---|
| `workflow-plan-review-finalize` | `01-planning-and-organizing/01-plan-review.md`, `02-finalise-plan.md` |
| `execute-and-confirm-plan` | `02-code-build/01-execution.md`, `02-confirm-execution.md`, `03-execute-and-confirm.md` |
| `repo-logs-and-docs-sync` | changelog, troubleshooting, docs/index updates |
| `filed-code-review-to-remediation` | `05-review/01-code-review.md` to remediation planning |
| `dirty-worktree-safe-publish` | safe commit/push in mixed worktrees |
| `prompt-quality-auditor` | prompt-system and UI-generation quality audits |

## Top Skill Candidates

### 1. `project-bootstrap` alias `bootstrap`

**Source files:**
- `00-project-setup/01-setup-project.md`
- `00-project-setup/07-migrate-project-structure.md`

**Use when:** Starting a new repo, migrating an existing repo into the standard `project/` structure, adding Workflow-Scripts to a project, or setting up changelog/troubleshooting/plans/docs conventions.

**Why it should be a skill:** The setup workflow is long and easy to apply partially. A skill can enforce the correct order: detect current structure, choose fresh setup vs migration, preserve existing records, create missing directories, and avoid overwriting indexes.

**Suggested behavior:**
- Detect whether the project already has `project/changelog`, `project/troubleshooting`, `project/plans`, and `project/plans-completed`.
- Apply fresh setup only for missing structures.
- Preserve existing indexes and monolithic historical files.
- Update agent docs only after reading current content.

**Priority:** P0

### 2. `repo-map-sync` alias `repo-map`

**Source file:**
- `00-project-setup/04-track-repos-and-agent-map.md`

**Use when:** A project has multiple git repos, nested Workflow-Scripts, companion repos, or agent files that need explicit repo maps and per-repo git commands.

**Why it should be a skill:** Multi-repo confusion is a recurring failure mode. A skill can standardize repo discovery and agent-file updates without requiring the user to remember the workflow path.

**Suggested behavior:**
- Discover `.git` directories.
- Record path, remote, branch, purpose, and parent/nested relationship.
- Update `AGENTS.md`, `CLAUDE.md`, and `GEMINI.md` consistently when present.
- Warn when nested repos are not ignored by the parent repo.

**Priority:** P0

### 3. `mcp-config-setup` alias `mcp-setup`

**Source file:**
- `00-project-setup/05-mcp-and-config-setup.md`

**Use when:** Setting up or troubleshooting MCP servers, Cursor MCP stdio PATH problems, Codex/OpenCode MCP config, default model config, or tool availability.

**Why it should be a skill:** MCP/config work is environment-sensitive and easy to mis-scope. A skill can keep the work at the tool/config layer unless repo code is actually involved.

**Suggested behavior:**
- Identify target runtime: Cursor, Codex, OpenCode, oh-my-opencode, or other.
- Verify config file locations before editing.
- Separate MCP auth from platform CLI auth.
- Confirm tool visibility after config/auth changes.

**Priority:** P0

### 4. `skills-install-triage` alias `skills-setup`

**Source file:**
- `00-project-setup/06-skills-setup.md`

**Use when:** Installing, tracking, or troubleshooting agent skills in Cursor/Codex/Kilo/Gemini CLI, or when a user asks why a skill did not trigger.

**Why it should be a skill:** The source workflow contains broad skill ecosystem references, storage locations, manifest guidance, and trigger troubleshooting. A concise skill can guide practical installation and diagnosis.

**Suggested behavior:**
- Determine target agent runtime and active skill discovery locations.
- Check `SKILL.md` frontmatter, description triggers, folder names, and install paths.
- Distinguish tracked workflow skills from locally installed runtime skills.
- Recommend short aliases and README index entries for human usability.

**Priority:** P1

### 5. `electron-macos-packaging` alias `mac-build`

**Source file:**
- `07-deployment/01a-MACOS_ELECTRON_GUIDE.md`

**Use when:** Packaging a macOS Electron app, debugging blank packaged windows, app drag regions, packaged asset paths, runtime logging, code signing/notarization, or `.app` payload validation.

**Why it should be a skill:** The guide is long, high-risk, and packed with recurring Electron/macOS traps. A skill can load the guide only when needed and make the default path practical.

**Suggested behavior:**
- Verify production renderer loading strategy.
- Check build script format, payload files, `electron-builder` files array, and runtime dependency inclusion.
- Validate macOS drag regions and traffic-light safe layout.
- Inspect packaged `.app` contents before diagnosing code regressions.

**Priority:** P0

### 6. `electron-vite-migration` alias `electron-vite`

**Source file:**
- `07-deployment/01b-electron-vite.md`

**Use when:** Migrating an Electron app to `electron-vite`, adding main/preload builds, configuring dev workflow port coordination, or fixing preload/main packaging issues.

**Why it should be a skill:** This is a framework-specific migration with multiple fragile steps. It is distinct from generic Electron packaging and should stay focused on migration mechanics.

**Suggested behavior:**
- Check Node version, app structure, renderer build strategy, main/preload source layout.
- Add or verify `electron.vite.config.ts`.
- Add build/dev scripts and port coordination.
- Verify packaged preload/main paths.

**Priority:** P1

### 7. `dev-port-manager` alias `ports`

**Source files:**
- `08-API-Integration/08-port-relocation/port-management-guide.md`
- `08-API-Integration/08-port-relocation/browser-auto-open.md`

**Use when:** Dev servers keep taking new ports, `EADDRINUSE` appears, localhost URLs are confusing, or browser auto-open needs configuration.

**Why it should be a skill:** Port/process issues recur often and require quick, safe diagnosis. A skill can encode the preferred commands and avoid broad process killing.

**Suggested behavior:**
- Identify active listener with `lsof -nP -iTCP:<port> -sTCP:LISTEN`.
- Determine whether the fix is config (`strictPort`, `port`, `open`) or stale process cleanup.
- Avoid killing unrelated processes without explicit confirmation.
- Report the actual active dev URL.

**Priority:** P0

### 8. `pre-deploy-security` alias `deploy-check`

**Source file:**
- `07-deployment/08a-pre-deployment-security-check.md`

**Use when:** Preparing for deployment, checking dependencies, env/secrets, build/lint/typecheck, and lightweight security posture before release.

**Why it should be a skill:** It is small enough to become a direct skill and useful across most web apps. It can also call repo-specific scripts when present.

**Suggested behavior:**
- Detect package managers and app roots.
- Run or recommend audit, outdated, build, lint, and typecheck checks.
- Check `.env` handling and hardcoded secret risks.
- File deferred items as changelog/troubleshooting or plan tasks when appropriate.

**Priority:** P1

### 9. `seo-geo-launch-check` alias `seo-geo`

**Source files:**
- `12-SEO-GEO-checklist/01-fully-automated-tasks.md`
- `12-SEO-GEO-checklist/02-semi-automated-tasks.md`
- `12-SEO-GEO-checklist/03-manual-human-tasks.md`
- `12-SEO-GEO-checklist/04-routine-monitoring-tasks.md`

**Use when:** Launching or auditing a public website for SEO, GEO/AI discoverability, security headers, sitemap/robots, structured data, Lighthouse, monitoring, and launch-day checks.

**Why it should be a skill:** The current checklist is useful but fragmented across four files by automation level. A skill can route between automated, semi-automated, manual, and recurring monitoring tasks.

**Suggested behavior:**
- Classify the task as launch check, live smoke, monitoring setup, or recurring audit.
- Run available local checks first; use browser/curl/live checks when authorized.
- Track human-required items separately from automated pass/fail.
- Produce a concise launch-readiness table.

**Priority:** P1

### 10. `documentation-builder` alias `docs-build`

**Source files:**
- `04-documentation/00-doc-templates.md`
- `04-documentation/01-create-docs.md`
- `04-documentation/02-sync-documentation.md`
- `04-documentation/ascii-art-prompts.md`

**Use when:** Creating docs from scratch, refreshing docs from code, choosing documentation templates, or adding ASCII architecture/process diagrams.

**Why it should be a skill:** The docs workflows contain reusable templates and parallel writing guidance. This should be separate from `repo-logs-and-docs-sync`, which is about change records after implementation.

**Suggested behavior:**
- Choose create-vs-sync mode.
- Inventory existing docs before writing.
- Generate only docs justified by the repo and user need.
- Use templates for README, architecture, API, data, testing, deployment, design, tutorials, and diagrams.

**Priority:** P1

## Additional Good Candidates

### `workflow-library-maintainer` alias `workflow-audit`

**Source files:**
- `00-project-setup/02-optimize-workflow-scripts.md`
- `00-Meta-Workflow/00-meta/naming-conventions.md`
- `00-Meta-Workflow/00-meta/filename-review.md`
- `00-Meta-Workflow/00-meta/parallel-agents-review.md`

**Use when:** Auditing Workflow-Scripts itself for duplication, contradictions, broken links, organization drift, or naming inconsistencies.

**Priority:** P2

### `mark-completed-verifier` alias `mark-done`

**Source file:**
- `04-documentation/03-mark-completed.md`

**Use when:** A plan or report claims tasks are complete and needs code-backed verification, false-completion flags, and reconciled logs.

**Priority:** P2

**Note:** Some of this overlaps with `execute-and-confirm-plan`, but this candidate is useful as a read-only verifier for already-claimed completion.

### `website-data-refactor` alias `data-refactor`

**Source file:**
- `05-review/04-website-data-refactoring.md`

**Use when:** Static website content is scattered, duplicated, untyped, or needs migration to centralized typed data modules.

**Priority:** P2

### `ai-api-integration` alias `ai-api`

**Source files:**
- `08-API-Integration/08-API-Integration/01-genkit/genkit-integration-guide.md`
- `08-API-Integration/08-API-Integration/02-AI-SDK/ai-sdk-integration-v2.md`
- `08-API-Integration/08-API-Integration/02-AI-SDK/service-providers/*.md`

**Use when:** Integrating Genkit, Vercel AI SDK, provider adapters, streaming, or provider-specific AI SDK options.

**Priority:** P2

**Caution:** This skill should browse current official docs for modern API details because provider docs change frequently.

### `ai-studio-desktop-migration` alias `ai-studio`

**Source file:**
- `07-deployment/02-ai-studio-to-desktop.md`

**Use when:** Migrating notebooks or AI Studio prototypes into local desktop/web projects.

**Priority:** P2

**Caution:** The source guide is very large and contains scripts/examples. Build this skill with references rather than putting the full guide in `SKILL.md`.

### `orchestrated-review-runner` alias `delegate-review`

**Source files:**
- `00-Meta-Workflow/00-orchestrator/orchestrator-plan-review.md`
- `00-Meta-Workflow/00-orchestrator/orchestrator-review.sh`

**Use when:** Running delegated, non-interactive model reviews and capturing outputs to files.

**Priority:** P2

## Lower-Priority or Better as References

| Area | Recommendation |
|---|---|
| `00-Meta-Workflow/00-meta/severity-priority-rubric.md` | Keep as reference used by many skills/workflows. Do not make a standalone skill. |
| Provider docs under `02-AI-SDK/service-providers/` | Keep as references loaded by `ai-api-integration`; browse official docs when freshness matters. |
| Completed plans under `00-Meta-Workflow/00-plans-completed/` | Keep as historical examples, not skills. |
| `09-11 Misc/` docs | Convert only if a workflow becomes recurring again; current candidates are lower priority than deployment/API/SEO areas. |
| Old reviews under `00-docs/old-reviews/` | Historical context only. |

## Suggested Human-Friendly Alias Pattern

Use short aliases in `11-Skills/README.md` and inside each `SKILL.md` body. Keep canonical folder names descriptive, but make user prompts easy.

| Alias | Canonical skill name |
|---|---|
| `bootstrap` | `project-bootstrap` |
| `repo-map` | `repo-map-sync` |
| `mcp-setup` | `mcp-config-setup` |
| `skills-setup` | `skills-install-triage` |
| `mac-build` | `electron-macos-packaging` |
| `electron-vite` | `electron-vite-migration` |
| `ports` | `dev-port-manager` |
| `deploy-check` | `pre-deploy-security` |
| `seo-geo` | `seo-geo-launch-check` |
| `docs-build` | `documentation-builder` |
| `workflow-audit` | `workflow-library-maintainer` |
| `mark-done` | `mark-completed-verifier` |
| `data-refactor` | `website-data-refactor` |
| `ai-api` | `ai-api-integration` |
| `ai-studio` | `ai-studio-desktop-migration` |
| `delegate-review` | `orchestrated-review-runner` |

## Recommended Implementation Order

### Batch 1: Highest operational ROI

1. `project-bootstrap`
2. `repo-map-sync`
3. `dev-port-manager`
4. `electron-macos-packaging`
5. `mcp-config-setup`

These address the most frequent expensive failures: wrong repo boundary, wrong project structure, confusing dev server state, Electron packaging drift, and MCP/tool auth/config issues.

### Batch 2: Launch and docs productivity

1. `pre-deploy-security`
2. `seo-geo-launch-check`
3. `documentation-builder`
4. `skills-install-triage`
5. `electron-vite-migration`

These are strong but slightly more situational.

### Batch 3: Specialist expansions

1. `workflow-library-maintainer`
2. `mark-completed-verifier`
3. `website-data-refactor`
4. `ai-api-integration`
5. `ai-studio-desktop-migration`
6. `orchestrated-review-runner`

These should be created when the matching work becomes active again.

## Skill Design Notes

- Keep each `SKILL.md` concise and procedural.
- Put long source workflow details in `references/` or link back to Workflow-Scripts paths rather than copying thousands of lines.
- Add `agents/openai.yaml` metadata with short display names.
- Include a `Human aliases:` line in each skill body.
- Validate each skill with the skill validator after creation.
- For API/provider skills, require current official documentation checks because provider details drift.

## Conclusion

The next best skills should focus on operational domains rather than duplicating the already-created plan/review/logging skills. The strongest candidates are `project-bootstrap`, `repo-map-sync`, `mcp-config-setup`, `electron-macos-packaging`, and `dev-port-manager`; together they would prevent several recurring classes of agent mistakes across the user's repos.
