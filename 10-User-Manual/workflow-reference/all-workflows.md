# All Workflows Reference

## Overview

Workflow-Scripts provides workflows organized into 10 categories. Each workflow is a self-contained Markdown file designed for AI agent execution.

## Decision Table

| Task | Workflow | File |
|------|----------|------|
| Setting up new project | Project Setup | `00-project-setup/01-setup-project.md` |
| Researching & creating plan | Research & Plan | `01-planning/00-research-and-plan.md` |
| Reviewing a plan | Plan Review | `01-planning/01-plan-review.md` |
| Finalizing a plan | Finalize Plan | `01-planning/02-finalise-plan.md` |
| Implementing changes | Execution | `02-build-code/01-execution.md` |
| Confirming execution | Confirm Execution | `02-build-code/02-confirm-execution.md` |
| Fixing a bug | Bug Fix | `03-debug/02-bug-fix-workflow.md` |
| Updating docs | Sync Documentation | `04-documentation/02-sync-documentation.md` |
| Creating docs from scratch | Create Docs | `04-documentation/01-create-docs.md` |
| Verifying completions | Mark Completed | `04-documentation/03-mark-completed.md` |
| Code review | Code Review | `05-review-audit/01-code-review.md` |
| Performance analysis | Code Optimization | `05-review-audit/02-code-optimization.md` |
| Code refactoring | Code Refactoring | `05-review-audit/03-code-refactoring.md` |
| Security audit | Security Review | `06-security/01-security-review.md` |
| Fixing security issues | Security Fix | `06-security/02-security-fix.md` |
| Non-interactive review | Orchestrator | `00-orchestrator/orchestrator-review.sh` |

## Category 0: Orchestrator (`00-orchestrator/`)

### Orchestrator Plan Review
- **File:** `00-orchestrator/orchestrator-plan-review.md`
- **Purpose:** Launch non-interactive OpenCode processes to delegate plan reviews to different models
- **When to use:** Multi-model reviews, CI/CD integration, batch processing
- **Shell script:** `00-orchestrator/orchestrator-review.sh`

## Category 0: Project Setup (`00-project-setup/`)

### Setup Project
- **File:** `00-project-setup/01-setup-project.md`
- **Purpose:** Full project initialization with multi-repo management, changelog, troubleshooting, and agent files
- **When to use:** New project setup, fresh clones

### Optimize Workflow Scripts
- **File:** `00-project-setup/02-optimize-workflow-scripts.md`
- **Purpose:** Analyze and optimize workflow scripts
- **When to use:** Periodic maintenance, after major changes

### Sync Workflow Scripts
- **File:** `00-project-setup/03-sync-workflow-scripts.md`
- **Purpose:** Multi-project sync automation
- **When to use:** Keeping workflows consistent across projects

### Track Repos and Agent Map
- **File:** `00-project-setup/04-track-repos-and-agent-map.md`
- **Purpose:** Discover repos, populate agent maps
- **When to use:** Multi-repo projects, new team members

### MCP and Config Setup
- **File:** `00-project-setup/05-mcp-and-config-setup.md`
- **Purpose:** MCP server setup (Google Dev Knowledge, Cursor, OpenCode)
- **When to use:** Setting up AI development tools

### Skills Setup
- **File:** `00-project-setup/06-skills-setup.md`
- **Purpose:** Skills configuration
- **When to use:** Adding specialized AI capabilities

## Category 0: Meta (`00-meta/`)

Supporting documents (not workflows):
- `severity-priority-rubric.md` — P0-P3 / S0-S3 scoring standards
- `sync-summary-template.md` — Template for sync summaries
- `agent-flexibility-review.md` — Analysis of agent patterns
- `parallel-agents-review.md` — Historical parallel agent review
- `filename-review.md` — Filename convention analysis

## Category 1: Planning (`01-planning/`)

### Research and Plan (Entry Point)
- **File:** `01-planning/00-research-and-plan.md`
- **Purpose:** Deep research and initial plan creation from a goal
- **When to use:** Starting new work with no plan yet
- **Input:** Goal or problem statement
- **Output:** `plans/` directory with initial plan

### Plan Review
- **File:** `01-planning/01-plan-review.md`
- **Purpose:** Review plan for correctness, risk, feasibility
- **When to use:** Before implementation, after receiving a plan
- **Input:** Plan document path
- **Output:** Feedback appended to plan

### Finalize Plan
- **File:** `01-planning/02-finalise-plan.md`
- **Purpose:** Consolidate into priority-ordered implementation plan
- **When to use:** After review, before implementation
- **Input:** Plan + review feedback
- **Output:** Priority-ordered plan in `plans/`

## Category 2: Build/Code (`02-build-code/`)

### Execution
- **File:** `02-build-code/01-execution.md`
- **Purpose:** Phase-based implementation with verification
- **When to use:** Implementing features from a plan
- **Input:** Implementation plan
- **Output:** Implemented code, updated changelog

### Confirm Execution
- **File:** `02-build-code/02-confirm-execution.md`
- **Purpose:** Post-execution verification
- **When to use:** After implementation phases
- **Output:** Verification report

### Execute and Confirm
- **File:** `02-build-code/03-execute-and-confirm.md`
- **Purpose:** Combined execute + confirm in one workflow
- **When to use:** Smaller changes that don't need separate phases

### Execute Plan
- **File:** `02-build-code/03-execute-plan.md`
- **Purpose:** Plan execution variant
- **When to use:** Alternative execution approach

## Category 3: Debug (`03-debug/`)

### Bug Description
- **File:** `03-debug/01-bug-description.md`
- **Purpose:** Bug report template and intake
- **When to use:** Documenting a new bug

### Bug Fix
- **File:** `03-debug/02-bug-fix-workflow.md`
- **Purpose:** Hypothesis-driven systematic bug fixing
- **When to use:** When a bug is reported or discovered
- **Input:** Bug report, logs, screenshots
- **Output:** Fixed code, troubleshooting entry

## Category 4: Documentation (`04-documentation/`)

### Create Docs
- **File:** `04-documentation/01-create-docs.md`
- **Purpose:** Generate comprehensive documentation from scratch
- **When to use:** New project, undocumented codebase
- **Output:** Complete `docs/` structure

### Sync Documentation
- **File:** `04-documentation/02-sync-documentation.md`
- **Purpose:** Update existing documentation to match codebase
- **When to use:** After code changes, periodic maintenance
- **Input:** Repository root
- **Output:** Updated `docs/`

### Mark Completed
- **File:** `04-documentation/03-mark-completed.md`
- **Purpose:** Verify reported completions are actually implemented
- **When to use:** Validating plan/task completion claims
- **Output:** Verified completion status

## Category 5: Review/Audit (`05-review-audit/`)

### Code Review
- **File:** `05-review-audit/01-code-review.md`
- **Purpose:** Structured code review for defects, risks, refactoring
- **When to use:** Before merge, periodic audits
- **Input:** Repository root or focus areas
- **Output:** `plans/code-review-YYYY-MM-DD-HH-MM.md`

### Code Optimization
- **File:** `05-review-audit/02-code-optimization.md`
- **Purpose:** Performance bottleneck analysis
- **When to use:** Performance issues, before scaling
- **Output:** `plans/code-optimization-YYYY-MM-DD-HH-MM.md`

### Code Refactoring
- **File:** `05-review-audit/03-code-refactoring.md`
- **Purpose:** Code quality and technical debt analysis
- **When to use:** Difficult-to-maintain code, before adding features
- **Output:** `plans/code-refactoring-YYYY-MM-DD-HH-MM.md`

## Category 6: Security (`06-security/`)

### Security Review
- **File:** `06-security/01-security-review.md`
- **Purpose:** Structured security audit (OWASP coverage, 6 parallel agents)
- **When to use:** Before releases, periodic audits, after incidents
- **Output:** `plans/security-review-YYYY-MM-DD-HH-MM.md`

### Security Fix
- **File:** `06-security/02-security-fix.md`
- **Purpose:** Systematic vulnerability remediation
- **When to use:** After security review, when vulnerabilities found
- **Output:** Fixed code, troubleshooting entry

## Category 7: Deployment (`07-deployment/`)

Deployment-specific guides (not generic workflows):
- `01a-MACOS_ELECTRON_GUIDE.md` — macOS Electron setup
- `01b-electron-vite.md` — Electron + Vite integration
- `02-ai-studio-to-desktop.md` — AI Studio migration
- `08-port-relocation/` — Port management
- `10-firebase-setup.md` — Firebase Hosting
- `11-nginx.md` — Nginx configuration

See `07-deployment/README.md` for the decision tree.

## Category 8: API Integration (`08-API-Integration/`)

API integration guides:
- `01-genkit/` — Google Genkit integration
- `02-AI-SDK/` — Vercel AI SDK integration

See `08-API-Integration/README.md` for the decision tree.

## Typical Workflow Sequences

### New Feature
```
Research → Plan → Review → Refine → Implement → Review → Document
```

### Bug Fix
```
Report → Investigate → Fix → Review → Document
```

### Security
```
Review → Fix Critical → Review → Document
```

### Periodic Maintenance
```
Code Review → Plan → Implement → Document
```

## Output Locations

| Output Type | Location | Format |
|-------------|----------|--------|
| Plans and reports | `plans/` | `plans/<type>-YYYY-MM-DD-HH-MM.md` |
| Changelog | `project/changelog/` | `<yyyy-mm-dd>-<type>-<short-title>.md` |
| Troubleshooting | `project/troubleshooting/` | `<yyyy-mm-dd>-<category>-<short-title>.md` |
| Documentation | `docs/` | Standard markdown structure |
