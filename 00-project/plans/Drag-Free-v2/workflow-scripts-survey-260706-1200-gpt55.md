> Survey of Workflow-Scripts produced by codex exec (gpt-5.5, low reasoning) on 2026-07-06, commissioned as the evidence base for `00-project/plans/2026-07-06-workflow-system-v2-redesign-proposal.md`.

# Workflow-Scripts Repository Survey

Scope reviewed: `01-planning-and-organizing/`, `02-code-build/`, `03-debugging/`, `04-documentation/`, `05-review/`, `06-security/`, `00-project-setup/`, `11-Skills/*/SKILL.md`, `00-Meta-Workflow/00-meta/`, `00-Meta-Workflow/00-orchestrator/`, and `scripts/`.

## 1. Category Behavior And Patterns

### `00-project-setup/`

These are setup and maintenance workflows for installing Workflow-Scripts into host projects and standardizing project metadata.

Key files:

- `00-project-setup/01-setup-project.md`
  - Creates or updates a host repo structure around `project/`.
  - Defines `project/KIV/`, `project/research/`, `project/build/`, `project/plans/`, `project/plans-completed/`, `project/changelog/`, and `project/troubleshooting/`.
  - Establishes active plans in `project/plans/`, completed plans in `project/plans-completed/<category>/`, and a corresponding Type=`plan` row in `project/changelog/index.md`.
  - Also writes agent-facing docs such as AGENTS/CLAUDE/GEMINI references.

- `00-project-setup/02-optimize-workflow-scripts.md`
  - A meta-review workflow for improving workflow files themselves.
  - Instructs agents to inventory files, find overlaps, contradictions, ambiguous terminology, and then create a consolidation plan.
  - Has a full analyze, strategy, implement, verify, document lifecycle.

- `00-project-setup/03-sync-workflow-scripts.md`
  - Documents how to create and use a multi-project sync script.
  - Includes manual script template material plus operational modes: status, dry-run, verbose, auto-discovery.
  - Overlaps heavily with the actual `scripts/sync-workflow-scripts.sh`.

- `00-project-setup/04-track-repos-and-agent-map.md`
  - Instructs agents to discover nested repos and document them in agent files.
  - Focuses on repo boundaries, remotes, branches, and per-repo sync/push/pull procedures.

- `00-project-setup/05-mcp-and-config-setup.md`
  - Guides MCP/tool configuration, especially Google Developer Knowledge, Cursor, OpenCode, and model defaults.
  - This is closer to an operational setup manual than a generic workflow.

- `00-project-setup/06-skills-setup.md`
  - Large reference for agent skills across tools.
  - Mixes durable local conventions with current-ish external ecosystem advice, making it more likely to drift than most repo-local workflows.

- `00-project-setup/07-migrate-project-structure.md`
  - Migrates older root-level `changelog/`, `troubleshooting/`, `plans/`, and `plans-completed/` into the newer `project/` structure.
  - Includes backup, copy, index creation, path update, and verification steps.

Common pattern:
- Long procedural docs.
- Setup workflows frequently include shell snippets.
- Output is usually a concrete filesystem structure plus indexes.
- Naming emphasizes `YYYY-MM-DD` for durable project artifacts.
- Setup docs are the source of many path conventions used elsewhere.

### `01-planning-and-organizing/`

These workflows create, review, and finalize implementation plans.

Key files:

- `01-planning-and-organizing/00-research-and-plan.md`
  - Takes a goal/problem, repo root, optional context, and optional external resources.
  - Instructs agents to do deep codebase research, external research, synthesis, and then produce research findings plus an implementation plan.
  - Uses parallel “architecture,” “code patterns,” “dependencies,” “data flow,” and “tech stack” agents.
  - Outputs research findings and a dated implementation plan.
  - It still references `project/build/`, `plans/`, and `plans/TODO.md` in mixed ways.

- `01-planning-and-organizing/01-plan-review.md`
  - Reviews an existing plan for correctness, feasibility, missing steps, dependencies, and acceptance criteria.
  - Encourages parallel validation agents and multi-model/orchestrated reviews.
  - Output is an appended review section or independent `PLAN.reviews/` reports.

- `01-planning-and-organizing/02-finalise-plan.md`
  - Consumes original plan plus review feedback.
  - Produces a final implementation plan ordered by P0-P3.
  - Includes steps for reconciling `PLAN.reviews/` output and optionally deleting the review directory after the final plan is saved/logged.

- `01-planning-and-organizing/03-plan-review-and-finalise.md`
  - A wrapper: run `01-plan-review.md`, then `02-finalise-plan.md`, then verify final plan acceptance criteria.

- A third-party system prompt was previously stored in the planning directory.
  - It was an outlier rather than a planning workflow and has since been removed from maintained branch tips.
  - It does not match the repo’s workflow-file structure.

Common pattern:
- Inputs: user goal or plan path.
- Phases: research, review, synthesis, finalization.
- Outputs: research report, active plan, appended review, or final plan.
- Strong preference for parallel agents, but little mechanical automation beyond instructions.

### `02-code-build/`

These workflows implement and verify approved plans.

Key files:

- `02-code-build/01-execution.md`
  - Reads a plan, checks repo state, implements phase by phase, verifies each phase, updates plan checkboxes, and updates logs.
  - Finalization delegates to `04-documentation/03-mark-completed.md`.
  - Completed plans should be moved to `project/plans-completed/<category>/`, with indexes updated.

- `02-code-build/02-confirm-execution.md`
  - Audits whether implementation actually satisfies the plan.
  - Defines the checkbox convention: `- [✅]` only when code exists and verification/exit criteria passed; otherwise `- [ ]`.
  - Uses parallel verification agents, corrects misreported checkboxes, and records verification results.

- `02-code-build/03-execute-and-confirm.md`
  - Wrapper: execute `01-execution.md`, then run `02-confirm-execution.md`.
  - Still says to archive into `project/changelog/plans/`, which conflicts with the newer default of `project/plans-completed/<category>/`.

Common pattern:
- Inputs: approved plan, repo root, acceptance criteria.
- Loop: implement -> test/build/smoke -> update plan -> update changelog/troubleshooting.
- Output: code changes, verified plan status, logs/docs, completed plan filing.

### `03-debugging/`

These workflows diagnose bugs and turn them into fix plans.

Key files:

- `03-debugging/01-bug-description.md`
  - Produces a comprehensive bug report.
  - Reads troubleshooting history, changelog, completed plans, source, logs, and similar patterns.
  - Saves a bug description file using `bug-description-YYYY-MM-DD-HH-MM-short-title.md`.
  - Still says save to root `plans/`, not consistently to `<metadata-root>/research/` or `project/plans/`.

- `03-debugging/02-bug-fix-workflow.md`
  - Consumes a bug description and creates a fix plan.
  - Emphasizes reproducing, root cause analysis, minimal scoped fix, tests, changelog, troubleshooting entry, and verification.
  - More implementation-adjacent than `01-bug-description.md`.

Common pattern:
- Inputs: bug report, logs, affected behavior.
- Phases: evidence gathering, root cause, impact, fix plan, verification.
- Outputs: bug report and/or implementation plan plus troubleshooting/changelog updates.

### `04-documentation/`

These workflows define docs templates, sync docs after changes, and file completed work.

Key files:

- `04-documentation/00-doc-templates.md`
  - Template library for README, API docs, architecture docs, troubleshooting entries, changelog entries, etc.
  - More reference material than executable workflow.

- `04-documentation/01-create-docs.md`
  - Creates new documentation for features, APIs, setup, or architecture.
  - Instructs agents to inspect code and write docs from evidence.

- `04-documentation/02-sync-documentation.md`
  - Updates docs after code or workflow changes.
  - Focuses on keeping README/API/setup/changelog/troubleshooting consistent.

- `04-documentation/03-mark-completed.md`
  - Important completion workflow.
  - Verifies implementation, reconciles plan checkboxes, updates changelog/troubleshooting/docs, moves completed plans, and updates indexes.
  - This is the strongest source for final status and archiving behavior.

- `04-documentation/09-optional.md`
  - Optional docs guidance; lower operational weight.

- `04-documentation/ascii-art-prompts.md`
  - Prompt/template content for ASCII art. It is not structurally similar to the main workflows.

Common pattern:
- Inputs: code changes, plan, completed work, or docs request.
- Outputs: docs files, changelog entries, troubleshooting entries, updated indexes.
- Naming relies on dated entries and category folders.

### `05-review/`

These are review/audit workflows.

Key files:

- `05-review/01-code-review.md`
  - Performs code review and files report in `<metadata-root>/research/`.
  - References shared meta policies: `review-workflow-core.md`, `severity-priority-rubric.md`, and `agent-spawning-policy.md`.
  - Findings require evidence, severity, priority, and verification steps.

- `05-review/02-code-optimization.md`
  - Performance/resource/scalability review.
  - Same shared review framework, but domain focus is optimization.

- `05-review/03-code-refactoring.md`
  - Architecture, maintainability, testability, and refactoring review.
  - Same shared review framework.

- `05-review/04-website-data-refactoring.md`
  - Much longer domain-specific workflow for website data restructuring.
  - Produces a report under `<metadata-root>/research/website-data-refactoring-YYMMDD-HHMM-{model}.md`.
  - Focuses on content/data model audit and planning rather than direct code changes.

- `05-review/05-comprehensive-audit.md`
  - Broader audit wrapper.
  - Similar role to “run multiple reviews and synthesize findings.”

Common pattern:
- Inputs: scope, repo root, optional focus.
- Preflight: identify root, metadata root, rubric, in-scope files.
- Review: parallel agents by domain.
- Output: filed report in `<metadata-root>/research/`.
- Shared scoring: P0-P3 and S0-S3.

### `06-security/`

Security-specific review and remediation.

Key files:

- `06-security/01-security-review.md`
  - Structured security review filed to `<metadata-root>/research/security-review-YYMMDD-HHMM-{model}.md`.
  - Uses `review-workflow-core.md`, `severity-priority-rubric.md`, and `agent-spawning-policy.md`.
  - Focuses on auth, input validation, secrets, dependencies, crypto, misconfiguration, and exposed endpoints.

- `06-security/02-security-fix.md`
  - Consumes security findings and implements fixes.
  - Emphasizes preserving evidence, targeted remediation, tests, changelog, troubleshooting/security entries, and verification.

Common pattern:
- Stronger preflight than older workflows.
- Clearer artifact routing via `<metadata-root>`.
- Security review is aligned with shared review policy; security fix behaves like a specialized execution workflow.

### `11-Skills/*/SKILL.md`

These are concise triggerable skill wrappers for common work patterns. They are more compact and action-oriented than the markdown workflows.

Examples:

- `11-Skills/execute-and-confirm-plan/SKILL.md`
  - Trigger: “implement the plan” or named execute-and-confirm workflow.
  - Steps: read plan, implement in order, verify, reconcile status, sync repo records.

- `11-Skills/workflow-plan-review-finalize/SKILL.md`
  - Trigger: review/finalize a workflow plan.
  - Bridges the planning workflows into a short operational skill.

- `11-Skills/workflow-bug-fix-plan-and-logs/SKILL.md`
  - Trigger: debug/fix plan/log work.
  - Similar to `03-debugging/02-bug-fix-workflow.md`, but shorter.

- `11-Skills/filed-code-review-to-remediation/SKILL.md`
  - Trigger: code review report in `project/research` or converting a review into a remediation plan.
  - Explicitly says verified findings become a filed plan, and not to patch during plan-only requests.

- `11-Skills/dirty-worktree-safe-publish/SKILL.md`
  - Trigger: commit/push from mixed dirty worktree.
  - Strong guardrails around repo boundaries and file-scoped staging.

- `11-Skills/provider-*`, `export-render-parity-debugger`, `live-bot-launch-verification`, etc.
  - Domain skills for AI provider plumbing, export parity, live bot verification, logs triage, prompt quality, and webhook hardening.

Common pattern:
- YAML front matter with `name` and `description`.
- Short `Workflow` numbered steps.
- `Guardrails` section.
- Clear trigger text in description.
- These are generally cleaner and less redundant than the long workflows.

### `00-Meta-Workflow/00-meta/`

Shared policy and convention documents.

Key files:

- `00-Meta-Workflow/00-meta/naming-conventions.md`
  - Centralizes report naming: `{report-type}-YYMMDD-HHMM-{model}.md`.
  - Defines metadata root resolution:
    - explicit output dir wins;
    - `00-project/` for Workflow-Scripts itself;
    - `project/` for host projects;
    - otherwise suggest setup.
  - Defines artifact locations for research, plans, completed plans, changelog, troubleshooting.

- `00-Meta-Workflow/00-meta/review-workflow-core.md`
  - Shared contract for review workflows.
  - Requires preflight, untrusted content handling, severity/priority rubric, evidence quality, deduplication, and report outline.

- `00-Meta-Workflow/00-meta/agent-spawning-policy.md`
  - Caps review/audit workflows at 3-6 agents per complete review session.
  - Requires primary reviewer to verify subagent findings.

- `00-Meta-Workflow/00-meta/severity-priority-rubric.md`
  - Defines impact, likelihood, priority mapping, severity labels, and evidence requirements.

- `00-Meta-Workflow/00-meta/glossary.md`
  - Defines shared terms, including the intentional `- [✅]` completion marker.

- `agent-flexibility-review.md`, `parallel-agents-review.md`, `filename-review.md`
  - Meta-audit workflows for improving workflows themselves.

Common pattern:
- These are policy references, not user-facing implementation workflows.
- They are the best place to resolve disagreements in active review workflows.
- Several active workflows still have older path conventions that do not fully reflect these meta rules.

### `00-Meta-Workflow/00-orchestrator/`

Orchestrated review support around OpenCode.

Key files:

- `00-Meta-Workflow/00-orchestrator/README.md`
  - Explains launching `opencode run` non-interactively against plans.
  - Supports model-specific, parallel, CI, and focused reviews.
  - Output: markdown review file plus JSON status file.

- `00-Meta-Workflow/00-orchestrator/orchestrator-plan-review.md`
  - Full workflow/manual for orchestrated plan review.
  - Documents prompt construction, focus areas, output handling, and integration with plan review/finalization.

- `00-Meta-Workflow/00-orchestrator/orchestrator-review.sh`
  - Actual shell implementation.
  - Validates plan, builds prompt, runs OpenCode with timeout, writes markdown output and JSON status.

Common pattern:
- Input: plan path.
- Optional flags: model, focus, output, timeout.
- Output: `*.md` review and sibling `*.json` status.
- Naming defaults to a `.reviews/` directory beside the plan.

## 2. Redundancy And Overlap

Major overlaps:

- Plan completion and filing appears in several places:
  - `02-code-build/01-execution.md`
  - `02-code-build/02-confirm-execution.md`
  - `02-code-build/03-execute-and-confirm.md`
  - `04-documentation/03-mark-completed.md`
  - `00-project-setup/01-setup-project.md`
  - `00-Meta-Workflow/00-meta/naming-conventions.md`

- Review policy is intentionally duplicated but partially centralized:
  - `05-review/01-code-review.md`
  - `05-review/02-code-optimization.md`
  - `05-review/03-code-refactoring.md`
  - `06-security/01-security-review.md`
  - `00-Meta-Workflow/00-meta/review-workflow-core.md`
  - `00-Meta-Workflow/00-meta/severity-priority-rubric.md`
  - `00-Meta-Workflow/00-meta/agent-spawning-policy.md`

- Sync script behavior is duplicated between:
  - `00-project-setup/03-sync-workflow-scripts.md`
  - `scripts/sync-workflow-scripts.sh`
  - `scripts/README.md`
  - `scripts/validation/check-sync-workflow-scripts.sh`

- Bug evidence gathering overlaps with execution artifact triage:
  - `03-debugging/01-bug-description.md`
  - `03-debugging/02-bug-fix-workflow.md`
  - `11-Skills/execution-artifact-triage/SKILL.md`
  - `11-Skills/workflow-bug-fix-plan-and-logs/SKILL.md`

- Skills often compress long workflows:
  - `11-Skills/execute-and-confirm-plan/SKILL.md` overlaps `02-code-build/03-execute-and-confirm.md`.
  - `11-Skills/filed-code-review-to-remediation/SKILL.md` overlaps `05-review/01-code-review.md` plus planning workflows.
  - `11-Skills/workflow-plan-review-finalize/SKILL.md` overlaps `01-planning-and-organizing/03-plan-review-and-finalise.md`.

This is not all bad. The skills are useful short-form triggers. The weakness is that not every long workflow points to the corresponding skill, and not every skill names the canonical long workflow file.

## 3. Convention Inconsistencies

Concrete inconsistencies:

- Directory naming drift:
  - Current folders are `01-planning-and-organizing/` and `02-code-build/`.
  - Some links still reference old paths like `02-build-code`, for example in `01-planning-and-organizing/00-research-and-plan.md`.
  - Memory and prior workflow history indicate this has been a recurring issue.

- Plan location drift:
  - `00-project-setup/01-setup-project.md` says active plans live in `project/plans/`.
  - `01-planning-and-organizing/00-research-and-plan.md` says output is in `project/build/` but later says create the implementation plan in `plans/`.
  - `02-code-build/03-execute-and-confirm.md` says archive into `project/changelog/plans/`.
  - Current meta convention says active plans go to `<metadata-root>/plans/` and completed plans to `<metadata-root>/plans-completed/<category>/`.

- Report naming drift:
  - `00-Meta-Workflow/00-meta/naming-conventions.md` uses `{report-type}-YYMMDD-HHMM-{model}.md`.
  - `03-debugging/01-bug-description.md` uses `bug-description-YYYY-MM-DD-HH-MM-short-title.md`.
  - Project setup uses `YYYY-MM-DD` for changelog/troubleshooting/completed plans.
  - Both date styles are valid in different contexts, but the boundary is not always explicit.

- Metadata root adoption is uneven:
  - Review/security workflows use `<metadata-root>/research/`.
  - Older planning/debugging/docs workflows still mention root `plans/`, bare `plans-completed/`, or `project/build/`.
  - `00-Meta-Workflow/00-meta/naming-conventions.md` is clearer than several older workflow files.

- Completion filing rule is split:
  - Newer convention: `project/plans-completed/<category>/` plus `project/plans-completed/index.md` plus Type=`plan` in `project/changelog/index.md`.
  - Older/alternate convention: `project/changelog/plans/`.
  - `00-project-setup/01-setup-project.md` allows `project/changelog/plans/` only when explicitly requested, but some build docs still present it as normal.

- Non-workflow content is mixed into workflow categories:
  - A third-party system prompt previously occupied the planning category and has since been removed.
  - `04-documentation/ascii-art-prompts.md` is prompt/template material.
  - These may be useful, but they weaken category clarity.

## 4. Weaknesses

- Too much manual execution:
  - Many workflows say “create directory,” “update index,” “move plan,” “check links,” and “verify logs” manually.
  - Only some of this is covered by scripts.
  - Completed-plan filing is especially error-prone because it requires moving a file and updating at least two indexes.

- Parallel-agent instructions are broad:
  - Many files tell agents to spawn parallel agents, but the repo does not provide a uniform handoff template, output schema, or reconciliation checklist outside the review core/orchestrator docs.
  - `agent-spawning-policy.md` helps, but older planning/debugging docs still read like aspirational orchestration instructions.

- Trigger clarity varies:
  - `11-Skills/*/SKILL.md` files have strong trigger descriptions.
  - Long workflow docs often have “When to Use” sections, but some docs are reference manuals rather than workflows.
  - Prompt/reference documents such as `ascii-art-prompts.md` have unclear trigger semantics inside their categories.

- Path conventions are brittle:
  - Several workflows depend on resolving whether this is Workflow-Scripts itself or a host project.
  - `<metadata-root>` solves this conceptually, but not all active workflows consistently use it.
  - Relative links and old directory names have historically drifted.

- Current external references can stale:
  - `00-project-setup/06-skills-setup.md` includes external skills ecosystem details and leaderboards.
  - It should be treated as a periodically refreshed catalog, not stable setup truth.

- Review workflows are stronger than planning/debugging workflows:
  - Review/security have shared core, severity rubric, metadata-root routing, untrusted content rule, and validation scripts.
  - Planning/debugging/docs are less normalized and more likely to contradict setup conventions.

- Automation coverage is incomplete:
  - There are validators for active markdown links, review policy, orchestrator behavior, sync script compatibility, and update script behavior.
  - There is no validator for all path convention drift, date format drift, completed-plan filing correctness, skill/workflow mapping, or non-workflow files in workflow directories.

## 5. Scripts And Validators

### `scripts/pull-workflows.sh`

Purpose:
- Pull latest Workflow-Scripts updates from inside a host project’s nested `Workflow-Scripts/` clone.

Behavior:
- Resolves script dir and repo root.
- Verifies repo is a git worktree.
- Refuses to pull if there are uncommitted changes.
- Handles detached HEAD by fetching and exiting with guidance.
- Runs `git pull --ff-only`.

Strength:
- Safe for nested repo usage.

Limitation:
- No branch selection or auto-stash. That is probably good for safety.

### `scripts/update-workflows.sh`

Purpose:
- Maintainer helper to commit already staged changes and push.

Behavior:
- Requires a commit message.
- Refuses if there are unstaged or untracked changes.
- Refuses if nothing is staged.
- Runs `git commit -m "$COMMIT_MSG"` and `git push`.

Strength:
- Prevents accidental broad commits from dirty worktrees.
- Aligns with `11-Skills/dirty-worktree-safe-publish/SKILL.md`.

Limitation:
- Does not run validators before commit.
- Does not show staged diff itself.

### `scripts/sync-workflow-scripts.sh`

Purpose:
- Sync Workflow-Scripts across multiple host projects.

Behavior:
- Supports:
  - `--status`
  - `--dry-run`
  - `--verbose`
  - `--auto`
  - `WORKFLOW_SYNC_BASE_DIR`
  - `WORKFLOW_SYNC_PROJECTS`
  - `WORKFLOWS_BRANCH`
  - `NON_INTERACTIVE=true`
- Auto-discovers projects containing `Workflow-Scripts`.
- Verifies origin remote matches HTTPS or SSH Workflow-Scripts remote.
- Fetches target branch and compares local/remote status.
- Can clone missing Workflow-Scripts in non-interactive mode.
- Avoids `cd` in main loops and uses `git -C`.

Strength:
- Practical cross-project maintenance script.
- Handles empty config gracefully.

Limitations:
- Hardcoded remote is `Rebooted-Dev/Workflow-Scripts`.
- Project list configuration remains manual unless env vars or `--auto` are used.
- The documentation copy in `00-project-setup/03-sync-workflow-scripts.md` can drift from the script.

### `scripts/validation/check-active-markdown-links.sh`

Purpose:
- Checks active markdown links.

Behavior:
- Walks repo markdown files with Node.
- Skips `.git`, `node_modules`, `backups`, `old-reviews`, and `00-Meta-Workflow/00-plans-completed`.
- Strips fenced code before checking links.
- Ignores external URLs, mailto, and pure anchors.
- Fails on missing local markdown targets inside the repo.

Strength:
- Catches broken internal docs links without being confused by code blocks.

Limitation:
- Does not validate anchors.
- Does not scan skipped historical directories.

### `scripts/validation/check-orchestrator-review.sh`

Purpose:
- Tests `00-Meta-Workflow/00-orchestrator/orchestrator-review.sh`.

Behavior:
- Creates fake `opencode` and fake `timeout`.
- Verifies exit code propagation.
- Verifies JSON status fields for failed and timeout cases.
- Verifies default `.reviews` output directory behavior.
- Ensures the orchestrator does not use deprecated `--prompt` behavior.

Strength:
- Good behavioral test for a shell orchestrator.

Limitation:
- Uses fake OpenCode only; does not verify real OpenCode integration.

### `scripts/validation/check-review-workflow-policy.sh`

Purpose:
- Enforces shared review workflow policy.

Behavior:
- Checks active review/security files:
  - `05-review/01-code-review.md`
  - `05-review/02-code-optimization.md`
  - `05-review/03-code-refactoring.md`
  - `06-security/01-security-review.md`
- Requires references to:
  - `agent-spawning-policy.md`
  - `review-workflow-core.md`
  - `<metadata-root>/research/`
  - untrusted content guidance
- Fails if stale local agent maximums or stale `plans/security-review` routing appear.

Strength:
- Prevents regression in the most normalized workflow family.

Limitation:
- Does not cover `05-review/04-website-data-refactoring.md` or `05-review/05-comprehensive-audit.md`.

### `scripts/validation/check-sync-workflow-scripts.sh`

Purpose:
- Regression checks for `scripts/sync-workflow-scripts.sh`.

Behavior:
- Enforces Bash 3.2 compatibility by rejecting `mapfile`.
- Rejects post-increment patterns that can fail under `set -e`.
- Rejects `cd "$workflows_path"` in loops.
- Requires SSH remote support.
- Creates temp repos and verifies empty auto-discovery and SSH remote handling behavior.

Strength:
- Good portability and safety checks.

Limitation:
- Does not exercise full successful sync/pull because it avoids real network/remotes.

### `scripts/validation/check-update-workflows.sh`

Purpose:
- Regression checks for `scripts/update-workflows.sh`.

Behavior:
- Creates a temp Workflow-Scripts repo.
- Verifies untracked files cause failure and are named.
- Verifies unstaged tracked changes cause failure and are named.
- Verifies staged-only changes commit and push path is reached via mocked `git push`.
- Ensures the script uses `git status --porcelain`, not `git diff --name-only`.

Strength:
- Directly tests dirty-tree safety.

Limitation:
- Uses `/usr/bin/git` inside the mock, which is macOS-specific enough to watch if porting.

## High-Value Cleanup Recommendations

1. Normalize artifact routing across planning/debugging/build docs to the metadata-root rule in `00-Meta-Workflow/00-meta/naming-conventions.md`.

2. Pick one default active-plan location:
   - Prefer `<metadata-root>/plans/` because that matches current setup and memory-backed convention.
   - Treat `project/build/` as legacy or specialized only if intentionally retained.

3. Pick one completed-plan default:
   - Prefer `<metadata-root>/plans-completed/<category>/`.
   - Keep `<metadata-root>/changelog/plans/` only as explicit alternate behavior.

4. Add a validator for stale path names:
   - Catch `02-build-code`, root `plans/`, root `plans-completed/`, old `changelog/plans` defaults, and inconsistent `project/build` references.

5. Move or clearly label remaining non-workflow prompt/reference files:
   - `04-documentation/ascii-art-prompts.md`

6. Make `04-documentation/03-mark-completed.md` the single canonical completion/filing authority and have build/debug/planning workflows link to it instead of restating filing rules.

7. Add a compact workflow-to-skill mapping table so agents know when to use the short `11-Skills/*` version versus the long workflow file.

