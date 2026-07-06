# Workflow Instruction Library Survey — Token Cost & Agent Roles

**Date:** 2026-07-06 01:20
**Model:** codex/gpt-5.5 (reasoning effort: low), delegated by claude-fable-5
**Scope:** `00-project-setup`, `01-planning-and-organizing`, `02-code-build`, `03-debugging`, `04-documentation`, `05-review`, `06-security`, `00-Meta-Workflow`. Read-only survey.
**Purpose:** Evidence base for the token-efficiency and agent-role additions (KI-10/KI-11) to `00-project/plans/2026-07-06-workflow-system-v2-redesign-proposal.md`.

---

## Q1: Token Cost Findings

| File | Lines | Est. domain-specific | Est. boilerplate/token waste | Evidence |
|---|---:|---:|---:|---|
| `05-review/01-code-review.md` | 199 | 45% | 55% | References shared core at lines 6, 21, 37, 104, but restates core rules throughout. |
| `05-review/02-code-optimization.md` | 101 | 45% | 55% | Shared core referenced at line 6, then repeats scoring, ordering, untrusted content, report fields, acceptance. |
| `05-review/03-code-refactoring.md` | 105 | 45% | 55% | Same pattern as optimization: core referenced at line 6, duplicated at 13-19, 40-73, 89-100. |
| `05-review/05-comprehensive-audit.md` | 131 | 70% | 30% | More domain-specific audit prompt, but duplicates severity/untrusted/finding/report structure at 3-13, 39-41, 113-127. |
| `06-security/01-security-review.md` | 137 | 55% | 45% | Core referenced at 6, 14, then duplicated in 16-33, 56-90, 109-115, 117-129. |
| `06-security/02-security-fix.md` | 176 | 70% | 30% | More remediation-specific, but repeats agent policy 3 times at 41, 75, 94 and navigation at 162-168. |
| `01-planning-and-organizing/00-research-and-plan.md` | 341 | 55% | 45% | Embedded templates at 155-159, 190-215, 225-270, 276-284; router boilerplate at 6-20, 326-331. |
| `02-code-build/01-execution.md` | 114 | 65% | 35% | Agent role boilerplate at 31-41, 50-60, 62-72; navigation at 107-114. |
| `03-debugging/02-bug-fix-workflow.md` | 180 | 65% | 35% | Parallel-agent menus repeated across investigation/implementation/verification at 31-100. |
| `04-documentation/01-create-docs.md` | 484 | 55% | 45% | Large role map at 130-189; template dependency and workflow boilerplate at 91-94, 466 onward. |
| `04-documentation/03-mark-completed.md` | 185 | 60% | 40% | Agent menu is highly specific but still hard-coded at 93-110; output contract present only here. |
| `00-project-setup/01-setup-project.md` | 1466 | 60% | 40% | Very large embedded templates/examples: e.g. agent instructions at 257-285 and entry template at 514-518. |
| `00-project-setup/02-optimize-workflow-scripts.md` | 708 | 65% | 35% | Already diagnoses duplication and templates, but contains its own analysis templates at 175 onward and examples at 105, 135, 592. |

### A. Shared-Core Duplication

Shared core already defines report routing, pre-flight, untrusted content, severity/priority, finding fields, evidence quality, dedupe, report outline, acceptance at `00-Meta-Workflow/00-meta/review-workflow-core.md:5-61`.

Approximate duplicated lines per workflow:

| Workflow | Restated from core | Concrete evidence |
|---|---:|---|
| `05-review/01-code-review.md` | ~95 lines | Pre-flight duplicates core `10-18` at `20-34`; evidence duplicates core `38-42` at `39-50`; finding fields duplicate core `25-35` at `77-90`; dedupe/order duplicates core `44-55` at `104-148`; acceptance duplicates core `57-61` at `174-180`. |
| `05-review/02-code-optimization.md` | ~43 lines | Severity/order/untrusted at `13-19`; finding/report fields at `40-72`; acceptance/notes at `86-100`. |
| `05-review/03-code-refactoring.md` | ~45 lines | Severity/order/untrusted at `13-19`; finding/report fields at `40-73`; acceptance/notes at `89-105`. |
| `05-review/05-comprehensive-audit.md` | ~24 lines | Severity mapping and core scoring at `3-13`; finding contract at `39-41`; final report outline at `113-120`; constraints overlap evidence quality at `122-127`. |
| `06-security/01-security-review.md` | ~58 lines | Pre-flight at `13-25`; severity/untrusted at `27-33`; finding fields at `56-65`; summary/report output at `69-90`; acceptance at `109-115`. |

Agent spawning core is only 26 lines at `00-Meta-Workflow/00-meta/agent-spawning-policy.md:5-26`, but workflows restate the cap and batch-reading rule repeatedly: `05-review/01-code-review.md:65-75`, `06-security/01-security-review.md:53-54`, and `06-security/02-security-fix.md:41-42`, `75-76`, `94-95`.

### B. Embedded Templates / Examples To Externalize

High-yield moves to on-demand template files:

- `01-planning-and-organizing/00-research-and-plan.md:190-215` embeds a full research findings template; `225-270` embeds a full implementation plan template; `276-284` embeds status marker snippets.
- `05-review/01-code-review.md:79-90` embeds a finding table template already covered by shared core fields; `98-102` embeds good/bad verification examples.
- `05-review/01-code-review.md:160-173` embeds valid/invalid refactor examples that could be a referenced rubric.
- `05-review/04-website-data-refactoring.md:428` begins an embedded markdown output template and `511` starts a before/after example section.
- `04-documentation/00-doc-templates.md:10-482` is correctly centralized, but `04-documentation/01-create-docs.md:91-94` and `04-documentation/02-sync-documentation.md:10-16` still repeat template rules.
- `00-project-setup/04-track-repos-and-agent-map.md:95-133` embeds templates inline instead of linking a template asset.
- `00-Meta-Workflow/00-meta/naming-conventions.md:31-35` embeds a report header template that should be referenced by review workflows.

### C. Navigation Boilerplate For Router

Repeated `When to Use` / `Related Workflows` sections are a strong candidate for a central router.

Evidence: planning has `01-planning-and-organizing/00-research-and-plan.md:6-20` and `326-331`; review has `05-review/01-code-review.md:186-199`; security has `06-security/01-security-review.md:117-129`; execution has `02-code-build/01-execution.md:107-114`; debugging has `03-debugging/01-bug-description.md:6-15` and `236`; documentation has `04-documentation/01-create-docs.md:6-14` and `466`.

Estimated savings: replacing per-file navigation with a 1-2 line router pointer would likely remove 8-18 lines from most workflow files.

---

## Q2: Agent Role Catalog

Distinct roles mentioned in role menus:

- **Planning/research:** Architecture agent, Code patterns agent, Dependencies agent, Data flow agent, Tech stack agent, API analysis agent, Database agent, UI/UX agent, Testing agent, Performance agent, Library research agent, Pattern research agent, Documentation agent, Community agent. Evidence: `01-planning-and-organizing/00-research-and-plan.md:61-85`.
- **Code review:** bugs/software faults, security/safety, optimization/modularization/refactoring, performance, accessibility, test coverage, documentation, domain specialist, compliance. Evidence: `05-review/01-code-review.md:60-73`.
- **Security review:** auth/authz, input validation/injection, sensitive data/secrets, dependency vulnerabilities, cryptography, misconfiguration/endpoints, API security, frontend security, infrastructure, compliance, supply chain, session management, injection prevention. Evidence: `06-security/01-security-review.md:36-53`.
- **Optimization/refactoring:** rendering optimization, database query, network optimization, bundle analysis, lazy-loading, type safety, error handling, code style, cleanup, domain specialist. Evidence: `05-review/02-code-optimization.md:22-37`, `05-review/03-code-refactoring.md:22-37`.
- **Execution/build:** core implementation, security/risk review, breaking-change review, acceptance validation, performance impact, documentation, test coverage, integration, accessibility, security hardening. Evidence: `02-code-build/01-execution.md:31-41`, `50-72`.
- **Documentation:** project structure, architecture/system design, code organization, APIs/endpoints, data models, UI/UX, tests, deployment, security docs, performance docs, troubleshooting, migration, doc-writing Agents A-M. Evidence: `04-documentation/01-create-docs.md:130-189`.
- **Completion verification:** P0/S0/S1 verifier, security/Electron verifier, bugs/hooks verifier, UX/components verifier, P2/P3 refactor verifier, docs/logs verifier. Evidence: `04-documentation/03-mark-completed.md:93-110`.

### Inconsistencies

- `Documentation agent` means external docs research in planning (`01-planning-and-organizing/00-research-and-plan.md:84`), missing API/public function docs in code review (`05-review/01-code-review.md:71`), security fix docs/runbooks (`06-security/02-security-fix.md:72`, `92`), and changelog/log verification (`04-documentation/03-mark-completed.md:103`).
- `Performance agent` means planning risk analysis (`01-planning-and-organizing/00-research-and-plan.md:74`), code-review bottleneck scan (`05-review/01-code-review.md:68`), security-fix latency risk (`06-security/02-security-fix.md:70`, `90`), and execution benchmarking (`02-code-build/01-execution.md:56`, `69`).
- `Compliance agent` appears in code review, security review, and security fix, but scope shifts between generic regulations, PII/PHI, GDPR/HIPAA, and PCI-DSS: `05-review/01-code-review.md:73`, `06-security/01-security-review.md:48`, `06-security/02-security-fix.md:38`, `89`.
- `Domain specialist` appears as database/API/UI in code review and as platform/architecture specialist in optimization/refactoring: `05-review/01-code-review.md:72`, `05-review/02-code-optimization.md:35`, `05-review/03-code-refactoring.md:35`.

### Missing from most role definitions

- No explicit output contract except `04-documentation/03-mark-completed.md:105-110` and `04-documentation/01-create-docs.md:147-151`.
- No evidence standard per agent; shared review core has evidence rules at `00-Meta-Workflow/00-meta/review-workflow-core.md:38-42`, but role menus rarely require each spawned agent to cite file:line evidence.
- No model-tier guidance for high-risk roles like security, compliance, cryptography, or architecture.
- No tool scoping: roles say "read files" but do not constrain execution, network use, secret handling, package audit commands, or untrusted repo behavior.
- No reconciliation contract beyond "primary reviewer must verify findings" in `00-Meta-Workflow/00-meta/agent-spawning-policy.md:26`.

---

## Highest-Impact Cleanup (survey recommendations)

1. Make review/security workflows contain only purpose, domain focus areas, extra fields, and report filename. Delegate the rest to `review-workflow-core.md`.
2. Replace role menus with role IDs that point to a central role registry: name, trigger, output contract, evidence requirement, allowed tools, model tier.
3. Move markdown templates into `00-Meta-Workflow/00-templates/` or reuse `04-documentation/00-doc-templates.md`.
4. Replace per-file `When to Use` and `Related Workflows` sections with a central router table.

---

## Supplementary metrics (claude-fable-5 direct verification, same session)

- Hand-condensed `11-Skills/*/SKILL.md` files average **~41 lines** (range 34-51) against 100-350-line source workflows — empirical proof that ~60-80% compression preserves operational quality.
- **38 distinct** "Spawn 1 X agent" role names across **55 mentions** in `01-planning-and-organizing`, `02-code-build`, `03-debugging`, `05-review`, `06-security`, with synonym collisions: test agent / testing agent / test coverage agent; security agent / security validation agent; database agent / database query agent; documentation agent / documentation review agent.
- `03-debugging/02-bug-fix-workflow.md` alone carries three separate role menus (investigate / implement / verify, lines 31-100).
- `05-review/05-comprehensive-audit.md` and `05-review/04-website-data-refactoring.md` do not reference `review-workflow-core.md` at all — the library simultaneously over-inlines (defensive repetition) and under-adopts (missing references) its own shared contract.
