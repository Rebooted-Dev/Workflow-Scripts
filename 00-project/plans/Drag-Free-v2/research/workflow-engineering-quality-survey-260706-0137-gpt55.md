> Survey of Workflow-Scripts engineering-quality coverage produced by codex exec (gpt-5.5, low reasoning) on 2026-07-06, commissioned as the evidence base for `2026-07-06-engineering-quality-and-lifecycle-proposal.md`. Questions Q1–Q8 probe coverage of systems design/architecture, code-design standards, error handling, observability, deployment, the greenfield path, tech-debt tracking, and plan-template quality sections.
>
> **Capture note:** the report header and the body of the Q1 (systems design / architecture) section were lost to output truncation when the run was captured. The Q1 findings below were reconstructed by claude-fable-5 from its own direct reading of the same files in the same session; Q2 onward is codex's verbatim output.
>
> **Implementation status (2026-07-06):** Baseline survey — all Q1–Q8 scored **PARTIAL** at time of capture. Drag-Free-v2 Phase 3 addressed most gaps (standards, architecture-design workflow, greenfield MVP, generic deploy, debt ledger). A formal survey re-run to confirm **COVERED** status is still pending per the companion proposal §8.

# Workflow-Scripts Engineering-Quality Survey

## Q1: Systems Design / Architecture (reconstructed — direct verification by claude-fable-5)

**Findings:** Architecture appears only as *analysis of what already exists*, never as a design activity. `01-planning-and-organizing/00-research-and-plan.md:63` defines the "Architecture agent" as "Map the overall system architecture, identify where changes would fit" — mapping, not designing. The plan-development phase has a "Decision Record" block (`00-research-and-plan.md:122-127`: approach, alternatives, trade-offs) but it is a single free-form section about the *overall approach*, not per-decision ADRs, and nothing requires interface/contract or module-boundary design. `01-plan-review.md:31` asks reviewers to "Identify design flaws and architectural concerns" with no criteria defined for what constitutes a design flaw. `04-documentation/00-doc-templates.md:77-113` contains Systems Architecture and Code Architecture templates ("Components and Boundaries", "Layers and Boundaries", "Key Abstractions") — but these are after-the-fact documentation skeletons; no lifecycle workflow requires producing or updating them before or during build. No workflow mentions ADRs (architecture decision records) as an artifact type; `<metadata-root>` has no `decisions/` location.

**Gap verdict:** PARTIAL (analysis exists; design-as-an-activity and decision records are ABSENT)

## Q2: Code Design Standards During Build

**Findings:** PARTIAL

`02-code-build/01-execution.md` enforces scoped implementation and convention checks, but not deep code-design standards. It says “Make the smallest change” ([`02-code-build/01-execution.md:48-50`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/02-code-build/01-execution.md:48)), “Check for unintended impacts on other modules” ([`02-code-build/01-execution.md:51-54`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/02-code-build/01-execution.md:51)), and “Validate code quality and adherence to project conventions” ([`02-code-build/01-execution.md:53-54`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/02-code-build/01-execution.md:53)). It also checks TypeScript/ESLint warnings ([`02-code-build/01-execution.md:61-65`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/02-code-build/01-execution.md:61)).

However, object orientation, encapsulation, immutability, memory safety, class design, and abstraction quality are mostly review/documentation concerns. `05-review/03-code-refactoring.md` scans for “missing abstractions” ([`05-review/03-code-refactoring.md:26`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/05-review/03-code-refactoring.md:26)), “type safety” issues ([`05-review/03-code-refactoring.md:30-31`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/05-review/03-code-refactoring.md:30)), and focus areas like “unclear abstractions,” “Tight coupling,” “Module boundaries,” and “Type safety” ([`05-review/03-code-refactoring.md:75-87`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/05-review/03-code-refactoring.md:75)).

Crucially, refactoring is retrospective: “Do not modify source code in this workflow” ([`05-review/03-code-refactoring.md:98-101`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/05-review/03-code-refactoring.md:98)).

**Answer to specific check:** design quality is lightly enforced during build via “project conventions” and code-quality validation, but detailed design standards are mainly checked later in review/refactoring.

**Gap verdict:** PARTIAL

## Q3: Error Handling / Fallbacks / Recovery

**Findings:** PARTIAL

During implementation, error handling is not a general standard. The execution workflow says if verification fails, “fix, then re-run” ([`02-code-build/01-execution.md:73-74`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/02-code-build/01-execution.md:73)), but it does not require error taxonomy, fallback behavior, retry policy, or graceful degradation.

Error handling appears strongly in review/debugging. `05-review/03-code-refactoring.md` triggers an “error handling agent” for missing try/catch or inconsistent responses ([`05-review/03-code-refactoring.md:29-32`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/05-review/03-code-refactoring.md:29)) and includes “Error handling patterns” as a focus area ([`05-review/03-code-refactoring.md:83-85`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/05-review/03-code-refactoring.md:83)). `05-review/05-comprehensive-audit.md` checks “swallowed exceptions” and “missing edge cases” ([`05-review/05-comprehensive-audit.md:43-45`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/05-review/05-comprehensive-audit.md:43)).

Documentation guidance supports error references: “Error taxonomy” and “Recovery” are part of the docs template ([`04-documentation/00-doc-templates.md:437-458`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/04-documentation/00-doc-templates.md:437)). Optional docs recommend “common errors with recovery steps” ([`04-documentation/09-optional.md:70-77`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/04-documentation/09-optional.md:70)).

There is project-setup shell guidance: “Exit immediately if a command fails” and “exit 1 on failure” ([`00-project-setup/01-setup-project.md:1442-1452`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/00-project-setup/01-setup-project.md:1442)), but that is script/setup-specific.

**Standard or checklist?** Mostly review/debugging/documentation checklist, not a universal implementer standard.

**Gap verdict:** PARTIAL

## Q4: Observability

**Findings:** PARTIAL

There is no general workflow that sets up project observability across logging, metrics, tracing, health checks, dashboards, and alerting.

Documentation workflows mention observability as conditional docs: “Monitoring and observability: `docs/monitoring/`” with “metrics, dashboards, alerting, health checks” ([`04-documentation/01-create-docs.md:78-81`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/04-documentation/01-create-docs.md:78)). Deployment docs include “Monitoring and logging setup (only if present)” ([`04-documentation/01-create-docs.md:256-265`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/04-documentation/01-create-docs.md:256)). Optional docs also list “Monitoring / observability” as a nice-to-have ([`04-documentation/09-optional.md:88-93`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/04-documentation/09-optional.md:88)).

`05-review/05-comprehensive-audit.md` audits “logging/observability quality” and “error reporting” ([`05-review/05-comprehensive-audit.md:53-55`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/05-review/05-comprehensive-audit.md:53)).

A strong observability requirement exists only in the Electron deployment guide: “Every implementation must include a modular packaged-runtime logging mechanism” ([`07-deployment/01a-MACOS_ELECTRON_GUIDE.md:172-178`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/07-deployment/01a-MACOS_ELECTRON_GUIDE.md:172)), with a “Required modular runtime logging” section ([`07-deployment/01a-MACOS_ELECTRON_GUIDE.md:191-208`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/07-deployment/01a-MACOS_ELECTRON_GUIDE.md:191)) and “Wait for a health check” ([`07-deployment/01a-MACOS_ELECTRON_GUIDE.md:495-497`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/07-deployment/01a-MACOS_ELECTRON_GUIDE.md:495)).

**Workflow that sets it up?** Only domain-specific guides, especially Electron and SEO/GEO monitoring. No general observability setup workflow.

**Gap verdict:** PARTIAL

## Q5: `07-deployment/` Contents

**Findings:** PARTIAL

`07-deployment/` is not a generic deploy workflow. The README says it contains “deployment guides for desktop apps, web hosting, pre-deployment checks, and development-server setup” ([`07-deployment/README.md:1-3`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/07-deployment/README.md:1)). The decision tree routes to specific guides: Electron, AI Studio migration, Firebase, Nginx, SEO/GEO, security check, and port management ([`07-deployment/README.md:5-31`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/07-deployment/README.md:5)).

The directory contains specific tech guides: macOS Electron, electron-vite, AI Studio to desktop, SEO/AI search plan, port relocation, and pre-deployment security check.

There is a “Comprehensive Production Readiness” sequence: SEO/GEO checklist, pre-deployment security check, deploy, then monitoring ([`07-deployment/README.md:104-109`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/07-deployment/README.md:104)). This is not a repeatable “deploy an MVP” path from scaffold to production.

`08a-pre-deployment-security-check.md` covers:
- dependency vulnerabilities via `npm audit` ([`07-deployment/08a-pre-deployment-security-check.md:7-19`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/07-deployment/08a-pre-deployment-security-check.md:7))
- outdated dependencies ([`07-deployment/08a-pre-deployment-security-check.md:28-38`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/07-deployment/08a-pre-deployment-security-check.md:28))
- env/secrets ([`07-deployment/08a-pre-deployment-security-check.md:46-55`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/07-deployment/08a-pre-deployment-security-check.md:46))
- build/lint/typecheck ([`07-deployment/08a-pre-deployment-security-check.md:62-70`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/07-deployment/08a-pre-deployment-security-check.md:62))
- optional SAST/runtime/supply-chain checks ([`07-deployment/08a-pre-deployment-security-check.md:77-87`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/07-deployment/08a-pre-deployment-security-check.md:77))

**Gap verdict:** PARTIAL

## Q6: Greenfield Path

**Findings:** PARTIAL

There is a project setup workflow for “a new project” ([`00-project-setup/01-setup-project.md:1-4`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/00-project-setup/01-setup-project.md:1)), but it sets up Workflow-Scripts, `project/`, docs, changelog, troubleshooting, and agent files. Its quick start assumes an existing `<PROJECT_PATH>` and a git repo ([`00-project-setup/01-setup-project.md:16-24`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/00-project-setup/01-setup-project.md:16)); prerequisites include “Git repository initialized” ([`00-project-setup/01-setup-project.md:112-117`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/00-project-setup/01-setup-project.md:112)).

`01-planning-and-organizing/00-research-and-plan.md` accepts a “goal or problem statement” and is the “starting point” for significant work ([`01-planning-and-organizing/00-research-and-plan.md:3-13`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/01-planning-and-organizing/00-research-and-plan.md:3)), but much of it assumes current repo/codebase analysis ([`01-planning-and-organizing/00-research-and-plan.md:59-67`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/01-planning-and-organizing/00-research-and-plan.md:59)).

Documentation can be created “from scratch” for new projects ([`04-documentation/01-create-docs.md:51-55`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/04-documentation/01-create-docs.md:51)), but this is documentation, not product scaffolding.

**Conclusion:** there is no single greenfield workflow from idea/concept → product architecture → scaffold → implementation → deploy MVP. The pieces exist separately and generally assume an existing repository.

**Gap verdict:** PARTIAL

## Q7: Tech Debt Tracking / Budgeting

**Findings:** PARTIAL

There is tech debt analysis, but not a debt ledger or budget mechanism.

`05-review/03-code-refactoring.md` explicitly identifies “technical debt” and refactoring opportunities ([`05-review/03-code-refactoring.md:3-6`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/05-review/03-code-refactoring.md:3)), and requires a “Technical debt summary” plus “Recommended refactoring roadmap” ([`05-review/03-code-refactoring.md:51-56`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/05-review/03-code-refactoring.md:51)).

Planning finalisation can classify “tech debt paydown with near-term value” as P2 and “long-term refactors” as P3 ([`01-planning-and-organizing/02-finalise-plan.md:53-57`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/01-planning-and-organizing/02-finalise-plan.md:53)).

The README describes a “Tech debt sprint” using refactoring first, then implementation planning ([`05-review/README.md:42-62`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/05-review/README.md:42)).

There is no standing debt ledger, explicit debt budget, recurring debt review cadence, debt acceptance template, or refactor trigger policy beyond review workflows.

**Gap verdict:** PARTIAL

## Q8: Plan Templates and Required Quality Sections

**Findings:** PARTIAL

`00-research-and-plan.md` requires some quality/design sections:
- “Decision Record” with alternatives and trade-offs ([`01-planning-and-organizing/00-research-and-plan.md:122-127`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/01-planning-and-organizing/00-research-and-plan.md:122))
- phase “Risks and mitigations” and “Exit criteria” ([`01-planning-and-organizing/00-research-and-plan.md:138-143`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/01-planning-and-organizing/00-research-and-plan.md:138))
- “Dependencies” and “Risks and Mitigations” in the plan skeleton ([`01-planning-and-organizing/00-research-and-plan.md:258-269`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/01-planning-and-organizing/00-research-and-plan.md:258))
- output requires risks and “clear acceptance criteria” ([`01-planning-and-organizing/00-research-and-plan.md:295-301`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/01-planning-and-organizing/00-research-and-plan.md:295))

But it does not require named sections for architecture decisions, error-handling strategy, test strategy, rollout/rollback, or observability plan. Testing appears as agent research/review, not as a required plan section.

`04-documentation/00-doc-templates.md` has strong documentation sections for architecture, APIs/errors, deployment, security, and errors ([`04-documentation/00-doc-templates.md:77-113`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/04-documentation/00-doc-templates.md:77), [`04-documentation/00-doc-templates.md:129-159`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/04-documentation/00-doc-templates.md:129), [`04-documentation/00-doc-templates.md:437-458`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/04-documentation/00-doc-templates.md:437)). `04-documentation/01-create-docs.md` includes rollback and monitoring/logging setup in deployment docs, but only “if present” ([`04-documentation/01-create-docs.md:256-265`](/Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts/04-documentation/01-create-docs.md:256)).

**Gap verdict:** PARTIAL

# Five Biggest Engineering-Quality Gaps

1. No universal implementation-time code-design standard: build execution does not require explicit interface contracts, encapsulation, abstraction boundaries, immutability, memory safety, or type-safety policy beyond project conventions.

2. No general architecture-design workflow: architecture is mostly “map existing system” plus ADR-like decision notes, not a structured greenfield/system-design process with boundaries, contracts, trade-offs, and decision records.

3. No general observability setup path: logging/metrics/tracing/health checks/alerting are optional docs or domain-specific guides, not a default project readiness requirement.

4. Error handling is not enforced as an implementation standard: recovery, fallback, retry, user-visible errors, and silent-failure avoidance mostly appear in review/debugging/security docs.

5. No end-to-end greenfield MVP lane: setup, planning, implementation, documentation, security, and deployment exist as separate workflows, but there is no repeatable idea → scaffold → architecture → build → deploy MVP path.

---

## Post-Implementation Remediation Map (2026-07-06)

| Survey gap | Drag-Free-v2 remediation | Status |
|---|---|---|
| Q1 Architecture/design absent | `workflows/planning/04-architecture-design.md` + `<metadata-root>/decisions/` | [✅] Implemented |
| Q2 No build-time code-design standard | `core/standards/code-design.md` wired in `workflows/build/01-execution.md` | [✅] Implemented |
| Q3 Error handling review-only | `core/standards/error-handling.md` + execution wiring | [✅] Implemented |
| Q4 No observability lifecycle | `core/standards/observability.md` + greenfield MVP baseline | [✅] Implemented |
| Q5 No generic deploy path | `workflows/deployment/00-deploy.md` | [✅] Implemented |
| Q6 No greenfield lane | `workflows/setup/08-greenfield-mvp.md` | [✅] Implemented |
| Q7 No debt ledger | `core/debt-ledger.md` + `wf debt add/list` | [✅] Implemented |
| Q8 Plan template quality sections | T2/T3 sections in plan skeleton | [✅] Implemented — `wf validate` tier checks pending |
| Survey re-run (COVERED verdict) | `workflow-engineering-quality-survey-rerun-260706-gpt5.md` | [✅] Completed |
| T3 end-to-end pilot demonstration | Real new project through MVP gate | [ ] Pending |

