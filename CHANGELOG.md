# Changelog

All notable changes to this repository are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- 2026-06-03: Moved `pull-workflows.sh`, `sync-workflow-scripts.sh`, and `update-workflows.sh` into `scripts/` only (removed repo-root wrappers); scripts resolve repo root via `REPO_ROOT`. Use `./Workflow-Scripts/scripts/pull-workflows.sh` from host projects.

### Added
- 2026-06-03: Added `08-API-Integration/08-API-Integration/03-higgsfield-mcp/` — workflow for Higgsfield MCP connect, auth, and reconnect diagnostics (filed from Podcast Studio `project/research/2026-06-03-higgsfield-mcp-connect-auth-reconnect-technical-note.md`).

### Changed
- 2026-06-03: Moved `08-port-relocation/` from `08-API-Integration/` to `07-deployment/` — aligns with deployment README; port management is deployment/dev-server concern, not API integration.
- 2026-06-03: Filed SEO Dashboard plans under `12-SEO-GEO-checklist/2026-03-18-SEO-Dashboard/` and updated checklist cross-references (was incorrectly under port-relocation).
- 2026-06-03: Flattened `08-API-Integration/` layout (removed duplicate `08-API-Integration/08-API-Integration/` nesting).
- 2026-05-24: Expanded `11-Skills/` with eight high-ROI recurring workflow skills: bug-fix plan/log workflow, provider capability verification, provider plumbing audit, execution artifact triage, export/render parity debugging, webhook bot hardening, live bot launch verification, and multi-agent plan orchestration. Reconciled overlaps by sharpening boundaries in existing plan, execute, repo-log, and dirty-worktree skills.
- 2026-05-24: Added `11-Skills/` with six reusable Codex skills for high-ROI recurring workflows: plan review/finalization, execute-and-confirm, repo logs/docs sync, filed code review to remediation, dirty worktree publishing, and prompt quality auditing.
- 2026-02-28: Completed P1.1, P1.2, and P1.3 tasks (index `06-skills-setup.md` in `00-project-setup/README.md`
- 2026-02-28: Completed P2.1– create `00-docs/old-reviews/README.md` for archival context for
- 2026-02-28: Added placeholder validation section to `00-project-setup/01-setup-project.md`
- 2026-02-28: Updated root README.md with `00-docs/` category and file structure section
- 2026-02-28: Completed P3.1 — enhanced `01-planning/01-plan-review.md` output template to explicitly require severity and priority labels per item
- 2026-02-28: Completed P3.3 — added `00-meta/glossary.md` with workflow terminology and linked from root README and 00-meta index
- 2026-02-28: Completed P3.4 — created READMEs for `08-API-Integration/01-genkit/` and `08-API-Integration/02-AI-SDK/`
- 2026-02-28: Completed P3.5 — added concrete trigger thresholds and examples to `00-meta/agent-flexibility-review.md`
- 2026-02-28: All P0-P3 tasks completed; plan fully executed
 
- 2026-02-28: Added `plans-completed/` directory with index and completed plan — moved branch-swap plan (promote beta to main, deprecate old main, new beta for updates) to `plans-completed/2026-02-28-workflow-scripts-branch-swap.plan.md`; added `plans-completed/index.md` for completed-plan records.
- 2026-02-28: Added `00-docs/CODE-REVIEW-WORKFLOW-SCRIPTS-2026-02-28.md` — verified code review report with 13 findings across P0-P3 priorities; includes validated findings, retired claims, and recommended action plan
- 2026-02-28: Added `00-docs/2026-02-28-implementation-plan-workflow-scripts-remediation.md` — phased implementation plan derived from verified code review; 4 phases (P0-P3) with tasks, dependencies, risks, exit criteria, rollback strategy

### Fixed
- 2026-05-31: Fixed code/security review findings in `orchestrator-review.sh` and the nested image-generation package. Failed or timed-out orchestrated reviews now still write status JSON with the original exit code, the default plan-review workflow path resolves to the current `01-Planning & Organizing/01-plan-review.md`, unsupported OpenRouter image-generation config has been removed from the public contract, retry classification no longer treats every generic `Error` as retryable, and the OpenAI image request `response_format` rewrite is covered by focused tests.
- 2026-05-31: Repaired active workflow links for renamed directories, rewrote the deployment index to current guide locations, made `sync-workflow-scripts.sh` and its setup guide branch-aware with `WORKFLOWS_BRANCH` override support, replaced unsafe `.env` troubleshooting examples with redacted/trusted-file guidance, added active Markdown link validation, documented reviewed-version MCP package guidance, and remediated the nested image-generation package to pass audit/test/type/build checks.
- 2026-05-31: Reconciled local review workflow and sync-script edits onto `v1.5`; review workflows now direct generated reports to `project/research/`, `05-review/README.md` links to the canonical naming conventions path, and `sync-workflow-scripts.sh` documents `WORKFLOW_SYNC_PROJECTS`.
- 2026-04-05: Fixed rubric path references across 14 files (17 occurrences) — changed `../00-meta/severity-priority-rubric.md` to `../00-Meta-Workflow/00-meta/severity-priority-rubric.md` in documentation, planning, security, debugging, and review workflows
- 2026-04-05: Standardized review workflow output directory — all 05-review workflows now use `project/plans/` consistently; removed legacy `project/build/` references from code-review workflow
- 2026-02-15: Implemented 10 improvements to code-review workflow based on verified analysis plan:
  - Added Pre-Flight Validation section with abort conditions
  - Added explicit file scope definitions (primary/secondary targets, exclusions)
  - Added Agent Spawning Thresholds with quantifiable triggers
  - Added Finding Template with table format and examples
  - Integrated rubric evidence requirements (S0/S1, S2, S3)
  - Added Deduplication process with conflict resolution
  - Added Cross-File Finding guidance for multi-file issues
  - Added structured executive summary requirements
  - Added Verification Step Quality Criteria with examples
  - Added Refactor Recommendation Criteria (valid vs laundry list)
- 2026-02-10: Fixed directory name inconsistency — changed all references from `00-initial-setup/` to `00-project-setup/` in README.md, 04-documentation/README.md, and 08-API-Integration/README.md
- 2026-02-10: Fixed shell script strict mode — added `set -e` to sync-workflow-scripts.sh to match other scripts (now uses `set -euo pipefail`)
- 2026-02-10: Fixed missing PROJECTS array validation — added check that exits with helpful message if PROJECTS is empty and --auto flag not used

### Changed
- 2026-02-10: Enhanced README.md Completion Status Conventions — added explicit Parent/Sub-task hierarchy guidelines for marking tasks complete
- 2026-02-10: Improved sync-workflow-scripts.sh documentation — added prominent header comments explaining required configuration steps before first use

### Added
- 2026-02-10: Added `00-orchestrator/` directory with orchestrator workflows — enables launching non-interactive OpenCode processes to delegate plan reviews (and other workflows) to different models. Includes:
  - `orchestrator-plan-review.md` — complete workflow documentation for delegated reviews
  - `orchestrator-review.sh` — production-ready shell script with configurable model, focus areas, timeouts, and output management
  - `README.md` — comprehensive guide with use cases, architecture, and best practices
  - Supports parallel multi-model reviews, CI/CD integration, and structured output capture
- 2026-02-10: Added `01-planning/00-research-and-plan.md` — comprehensive workflow for deep research and creating initial implementation plans. This is the entry point for any significant work when you have a goal but no plan yet. Includes phases for codebase research, external research, plan development, and output generation.
- 2026-02-10: Added SCRIPT-REVIEW-REPORT.md — review of Workflow-Scripts shell scripts and docs (sync script, pull/update helpers, doc vs script alignment, directory naming). Includes recommended action list.
- 2026-02-10: sync-workflow-scripts.sh — NON_INTERACTIVE support (auto-clone when Workflow-Scripts missing, no prompt; skip with message when no TTY). BASE_DIR override via WORKFLOW_SYNC_BASE_DIR. Help text documents both env vars.
- 2026-02-03: Added 04-documentation/03-mark-completed.md — workflow to inspect code and verify that all reported completed tasks were actually implemented; mark verified completions with ✅; flag false reporting (incomplete / not done); reconcile changelog, troubleshooting, and docs; use parallel sub-agents; display flagged issues in descending order of importance/urgency. Updated 04-documentation/README.md with index entry and overview.
- 2026-02-01: Clarified task marking and implementation plan update instructions across build, confirm-execution, bug-fix, and security-fix workflows; README "Document as You Go" and "Completion Status Conventions" now explicitly require updating the plan in `plans/` after each build phase or bug/security fix and using green check marks (`- [✅]` and `**Status:** ✅ COMPLETED`)
- 2026-01-26: Added agent flexibility review document (00-meta/agent-flexibility-review.md) - comprehensive analysis of fixed agent patterns and recommendations for flexible agent usage
- 2026-01-21: Added directory README to 00-meta/ - index with active vs historical file status and quick reference
- 2026-01-21: Added directory README to 02-build-code/ - workflow sequence diagram and task marking convention
- 2026-01-21: Added directory README to 03-debug/ - explains file ordering (start with 02-bug-fix-workflow.md)
- 2026-01-21: Added directory README to 04-documentation/ - priority buckets and expected docs structure
- 2026-01-21: Added directory README to 05-review-audit/ - decision guide for choosing review type (code/optimization/refactoring)
- 2026-01-21: Added directory README to 06-security/ - review→fix workflow sequence and security focus areas

### Changed
- 2026-02-08: Merged origin/beta into main — synced local main with origin/main (resolved conflict in 00-initial-setup/01-setup-project.md: Quick Start, Purpose, Step 4, checklist, AI agents). Merged origin/beta into main (resolved conflicts: combined slim Change Management 2.6.2 with migration steps 2.7/2.8, merged checklist and "For AI Agents" list). Pushed main to origin. Single main branch now contains all workflow content (mark-completed, electron-vite docs, multi-repo setup, slim AGENTS architecture).
- 2026-01-26: Implemented flexible agent pattern across all workflows - replaced fixed agent counts ("Agent 1", "Agent 2", etc.) with "Suggested agent roles (spawn additional agents as needed)" pattern to enable dynamic agent spawning based on task complexity
- 2026-01-26: Updated 14 workflow files with flexible agent guidance:
  - Planning: 01-plan-review.md, 02-finalise-plan.md
  - Build/Code: 01-execution.md, 02-confirm-execution.md
  - Review/Audit: 01-code-review.md, 02-code-optimization.md, 03-code-refactoring.md
  - Security: 01-security-review.md, 02-security-fix.md
  - Debug: 02-bug-fix-workflow.md
  - Documentation: 01-create-docs.md, 02-sync-documentation.md
- 2026-01-26: Enhanced all workflows with guidance to spawn additional agents when discovering new concerns, domain-specific needs, or increased task complexity
- 2026-01-26: Updated README.md Best Practices section - clarified flexible agent pattern and dynamic spawning guidance
- 2026-01-26: Updated 00-meta/parallel-agents-review.md - added note about new flexible agent approach implementation
- 2026-01-22: Rewrote macOS Electron desktop app guide with explicit renderer loading and macOS dragging instructions (loadFile, platform-specific frame config)
- 2026-01-21: Updated main README.md file structure section - reflects new directory READMEs in all directories
- 2026-01-21: Added historical status and timestamps to 00-meta/filename-review.md and parallel-agents-review.md
- 2026-01-21: Enhanced 02-build-code/01-execution.md - added proper header (Purpose, Inputs, Output) to match 02-confirm-execution.md structure

### Removed
- 2026-02-08: Removed beta branch from remote (origin) after merging into main.
- 2026-02-28: Removed `09-skills/` directory — broken symlinks to non-existent `.agents/skills/` targets eliminated; key skills documentation absorbed into `00-project-setup/06-skills-setup.md`

### Fixed
- 2026-02-10: sync-workflow-scripts.sh — Quoted git refs ('@{u}', 'HEAD..@{u}') to satisfy ShellCheck SC1083. Handle cd failure before clone (SC2164): report error and increment FAIL_COUNT instead of continuing; clone only runs after successful cd.
- 2026-01-21: Resolved critical task marking contradiction in 02-build-code - changed emoji format (`✅`/`⏳`) to checkbox format (`- [✅]`/`- [ ]`) to match 02-confirm-execution.md
- 2026-01-21: Clarified workflow sequence in 03-debug/README.md - explains that files are numbered by documentation depth, not workflow order (start with 02-bug-fix-workflow.md)

## [1.4.0] - 2026-01-20

### Added
- 2026-01-20: Added API Integration workflows navigation README (08-API-Integration/README.md) - central navigation with decision tree for choosing API integration guides
- 2026-01-20: Added unified Genkit integration guide (08-API-Integration/01-genkit/genkit-integration-guide.md) - comprehensive guide consolidating planning, implementation, and completion status
- 2026-01-20: Added service providers reference documentation overview (08-API-Integration/02-AI-SDK/service-providers/README.md) - explains purpose and usage of provider reference docs
- 2026-01-20: Added optimization analysis document (08-API-Integration/ANALYSIS.md) - comprehensive analysis of overlaps, contradictions, and ambiguities
- 2026-01-20: Added optimization strategy document (08-API-Integration/OPTIMIZATION_STRATEGY.md) - detailed optimization plan and consolidation strategy
- 2026-01-20: Added optimization completion summary (08-API-Integration/OPTIMIZATION_COMPLETE.md) - metrics and summary of completed optimization work
- 2026-01-18: Added workflow scripts optimization workflow (00-initial-setup/02-optimize-workflow-scripts.md) - comprehensive 5-phase process for analyzing, optimizing, and verifying workflow scripts
- 2026-01-18: Added deployment workflows index README (07-deployment/README.md) - central navigation with decision tree for choosing deployment guides
- 2026-01-18: Added unified port management guide (07-deployment/08-port-relocation/port-management-guide.md) - consolidates port conflict resolution, process management, and port detection
- 2026-01-18: Added focused browser auto-open guide (07-deployment/08-port-relocation/browser-auto-open.md) - dedicated guide for browser auto-open configuration across build tools
- 2026-01-18: Added port relocation directory README (07-deployment/08-port-relocation/README.md) - overview and quick start for port management guides
- 2026-01-18: Added optimization strategy document (07-deployment/OPTIMIZATION_STRATEGY.md) - comprehensive analysis and 4-phase optimization plan
- 2026-01-18: Added optimization completion summary (07-deployment/OPTIMIZATION_COMPLETE.md) - metrics and summary of completed optimization work

### Changed
- 2026-01-20: Optimized 08-API-Integration directory structure - consolidated 4 Genkit files into 1 comprehensive guide (75% reduction in Genkit-specific files)
- 2026-01-20: Enhanced AI SDK integration guide - added note clarifying project-specific references are examples to adapt
- 2026-01-20: Enhanced service provider documentation - added reference documentation notes to all provider files (openai.md, google.md, fal.md, openrouter.md, xai.md)
- 2026-01-20: Enhanced token caching analysis - added purpose statement clarifying it's a decision-making document, not a workflow guide
- 2026-01-18: Optimized 07-deployment directory structure - reduced from 11 files to 8 files (27% reduction) through consolidation and reorganization
- 2026-01-18: Consolidated port management documentation - merged 3 overlapping files (port-conflict-resolution.md, port-process-management-plan.md, AUTO_BROWSER_OPEN_GUIDE.md) into unified port-management-guide.md
- 2026-01-18: Separated browser auto-open functionality - extracted from port management into dedicated browser-auto-open.md guide
- 2026-01-18: Generalized Firebase Hosting setup guide - removed project-specific references (Clinic Mockups) to make it applicable to any project
- 2026-01-18: Enhanced Electron desktop app guide - added "When to Use This Guide" section and improved navigation with quick reference links
- 2026-01-18: Enhanced AI Studio migration guide - added Quick Start section and clarified it's a comprehensive reference guide (2100+ lines)
- 2026-01-18: Improved deployment workflow organization - created central index with decision tree, common scenarios, and best practices

### Removed
- 2026-01-20: Removed redundant genkit-integration-plan.md - consolidated into unified genkit-integration-guide.md
- 2026-01-20: Removed redundant genkit-integration.md - consolidated into unified genkit-integration-guide.md
- 2026-01-20: Removed redundant genkit-migration-implementation.md - consolidated into unified genkit-integration-guide.md
- 2026-01-20: Removed redundant GENKIT_MIGRATION_COMPLETED.md - consolidated into unified genkit-integration-guide.md
- 2026-01-18: Removed redundant port-conflict-resolution.md - consolidated into unified port-management-guide.md
- 2026-01-18: Removed redundant port-process-management-plan.md - consolidated into unified port-management-guide.md
- 2026-01-18: Removed redundant AUTO_BROWSER_OPEN_GUIDE.md - replaced with focused browser-auto-open.md
- 2026-01-18: Removed incorrect QUICK_START.md from port-relocation - contained wrong project documentation (RBC Sermonator instead of port management)
- 2026-01-18: Removed incorrect README.md from port-relocation - contained wrong project documentation (RBC SRT Translator instead of port management)

### Fixed
- 2026-01-20: Resolved Genkit integration contradictions - unified multiple "v2" revised plans into single authoritative integration guide
- 2026-01-20: Clarified ambiguities in API Integration workflows - added purpose statements to all files, clarified service provider docs are reference material, and added navigation guidance
- 2026-01-18: Resolved port management contradictions - unified simple (Vite config) and advanced (process management) approaches with clear "when to use" guidance
- 2026-01-18: Fixed incorrect content in port-relocation directory - replaced wrong project documentation with proper port management guides
- 2026-01-18: Clarified ambiguities in deployment workflows - added "When to Use" sections, quick starts, and improved navigation
- 2026-01-20: Renamed workflow mapping in README.md - swapped Implementation Plan and Plan Review file references to match actual workflow titles and purposes
- 2026-01-20: Fixed planning workflow file titles to match their actual purpose (Plan Review vs Implementation Plan)
- 2026-01-20: Updated parallel-agents-review.md to reference correct workflow file paths
- 2026-01-20: Fixed bug-description workflow to reference correct bug-fix workflow filename
- 2026-01-20: Added "historical note" status to filename-review.md to prevent confusion from stale structure references

### Changed
- 2026-01-20: Unified repository model in SHARING_AND_SYNC.md - nested repo model is now recommended, with git submodule as an advanced alternative
- 2026-01-20: Standardized documentation paths - workflows now point to `docs/CHANGELOG.md` (preferred) or `CHANGELOG.md`
- 2026-01-20: Standardized troubleshooting paths - workflows now point to `troubleshooting/<category>/...` and `troubleshooting/index.md`
- 2026-01-20: Standardized output paths - reports now saved to `plans/` (project root) instead of `../../plans/`
- 2026-01-20: Unified timestamp format - changelog entries now use `- YYYY-MM-DD: Description` (date-only), reports use `YYYY-MM-DD HH:MM` in headers
- 2026-01-20: Normalized terminology - replaced "timestamp" with "dated" where appropriate across all workflow documents
- 2026-01-20: Updated README.md to clarify workflows are for "host project" not specifically "Info-Visualizer"
- 2026-01-20: Added missing category listing in README.md to fix "seven categories" count

### Added
- 2026-01-20: Added comprehensive confirm-execution workflow with verification criteria and marking convention (`- [✅]` / `- [ ]`)
- 2026-01-20: Added "seven categories" enumeration including `00-meta/` in README.md
- 2026-01-20: Added helper script documentation to README.md with corrected descriptions

### Deprecated
- 2026-01-20: Removed Option B from SHARING_AND_SYNC.md - the mixed submodule/copy approach was mechanically incorrect and confusing

### Removed
- 2026-01-20: Removed references to `../../TROUBLESHOOTING.md` as canonical troubleshooting target
- 2026-01-20: Removed misleading relative paths (`../../plans/`, `../../docs/`) from workflow instructions
- 2026-01-20: Removed emoji task list examples (`✅` / `⏳`) from execution workflow

### Security
- 2026-01-20: Updated helper scripts to detect detached HEAD state and refuse pull if repo has uncommitted changes
- 2026-01-20: Removed dangerous `git submodule update --remote` as default recommendation in SHARING_AND_SYNC.md

### Refactor
- 2026-01-20: Refactored 08-API-Integration directory structure - consolidated Genkit files, improved navigation with README and decision tree, and clarified file purposes
- 2026-01-20: Refactored Genkit integration documentation - merged 4 overlapping files (plan, integration, migration, completed) into single comprehensive guide with all phases and status
- 2026-01-18: Refactored 07-deployment directory structure - reorganized files for better navigation, eliminated redundancy, and improved usability
- 2026-01-18: Refactored port management documentation - consolidated multiple overlapping approaches into unified guide with simple → advanced progression
- 2026-01-20: Rewrote pull-workflows.sh to properly handle nested repo model (ff-only, dirty-check, detached HEAD handling)
- 2026-01-20: Rewrote update-workflows.sh to be a maintainer-only helper that commits staged changes and pushes (no parent repo interaction)
- 2026-01-20: Replaced misleading submodule assumptions in helper scripts with explicit nested-repo behavior
- 2026-01-20: Rewrote SHARING_AND_SYNC.md to clearly document nested repo model with safe update procedures
