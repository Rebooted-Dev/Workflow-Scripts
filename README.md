# Workflows Directory

## Overview

This directory contains structured workflow instructions for common development tasks in the Info-Visualizer project. These workflows provide consistent, repeatable processes for planning, reviewing, implementing, debugging, and documenting code changes.

**Sharing Workflows Across Projects:** See [`SHARING_AND_SYNC.md`](./SHARING_AND_SYNC.md) for instructions on how to share and sync these workflows across multiple projects using Git submodules.

**Why Workflows?**  
Workflows ensure that:
- Tasks are completed systematically and thoroughly
- Quality standards are consistently applied
- Priority and severity are assessed uniformly
- Documentation stays accurate and up-to-date
- Team members can follow the same processes

## Workflow Categories

The workflows are organized into seven categories:

1. **Planning** (`planning/`) - Create structured implementation plans
2. **Review** (`review/`) - Review code and plans for quality and correctness
3. **Development** (`development/`) - Execute implementation with verification
4. **Debug** (`debug/`) - Systematically identify and fix bugs
5. **Security** (`security/`) - Security reviews and vulnerability remediation
6. **Documentation** (`documentation/`) - Keep documentation in sync with code
7. **Reference** (`reference/`) - Shared standards and rubrics

**Note:** The `meta/` directory contains analysis and review documents about the workflows themselves (e.g., parallel agent usage reviews, filename reviews). These are not workflow instructions but rather documentation about workflow design and improvements.

## Quick Start Guide

### When to Use Each Workflow

| Task | Workflow | Location |
|------|----------|----------|
| Starting a new feature | Implementation Plan | `planning/implementation-plan.md` |
| Reviewing code quality | Code Review | `review/code-review.md` |
| Reviewing a plan | Plan Review | `review/plan-review.md` |
| Security audit | Security Review | `review/security-review.md` |
| Implementing changes | Execution | `development/execution.md` |
| Fixing a bug | Bug Fix | `debug/bug-fix-workflow.md` |
| Fixing security issues | Security Fix | `security/security-fix.md` |
| Updating docs | Sync Documentation | `documentation/sync-documentation.md` |

### Typical Workflow Sequence

```
1. Planning → Create implementation plan
2. Review → Review the plan for issues
3. Planning → Refine plan based on feedback
4. Development → Implement changes
5. Review → Code review before merge
6. Documentation → Update docs if needed
```

## Detailed Workflow Descriptions

### 1. Planning Workflows

#### Implementation Plan (`planning/implementation-plan.md`)

**Purpose:** Generate a consolidated, priority-ordered implementation plan from requirements and feedback.

**When to use:**
- Starting a new feature or refactoring
- Consolidating multiple planning documents
- Creating a roadmap for complex changes

**How to use:**
1. Provide the primary plan document path
2. Include any feedback or review comments
3. The workflow will generate a priority-ordered plan (P0 → P3)
4. Plan is saved to `../../plans/` with a timestamp

**Example:**
```
User: "Create an implementation plan for adding user authentication. 
       Review the existing plan at plans/auth-plan.md and incorporate 
       feedback from the team."
       
Workflow will:
- Read plans/auth-plan.md
- Analyze codebase for feasibility
- Generate priority-ordered phases
- Save to plans/implementation-plan-auth-YYYY-MM-DD-HH-MM.md
```

**Key Features:**
- Priority ordering (P0 = blockers, P3 = backlog)
- Dependency mapping
- Effort estimation (Small/Medium/Large)
- Clear exit criteria per phase
- Uses shared rubric from `reference/severity-priority-rubric.md`

---

### 2. Review Workflows

#### Code Review (`review/code-review.md`)

**Purpose:** Perform structured code review identifying defects, risks, and refactoring opportunities.

**When to use:**
- Before merging code changes
- Periodic code quality audits
- After major refactoring

**How to use:**
1. Specify repository root (or specific focus areas)
2. Workflow scans codebase using parallel agents
3. Findings are scored with severity (S0-S3) and priority (P0-P3)
4. Report saved to `../../plans/` with timestamp

**Example:**
```
User: "Perform a code review focusing on security and error handling 
       in the services/ directory."
       
Workflow will:
- Scan services/ directory
- Identify security issues, bugs, and risks
- Score each finding (S0-S3, P0-P3)
- Generate report: plans/code-review-YYYY-MM-DD-HH-MM.md
```

**Output Format:**
- Summary with top P0/P1 risks
- Findings ordered by priority, then severity
- Each finding includes:
  - File path and line reference
  - Observed behavior and impact
  - Severity/priority with rationale
  - Suggested fix
  - Verification steps

#### Plan Review (`review/plan-review.md`)

**Purpose:** Review implementation plans for correctness, risk, feasibility, and completeness.

**When to use:**
- Before starting implementation
- When a plan seems incomplete or risky
- After receiving a plan from another team member

**How to use:**
1. Provide the plan document path
2. Workflow analyzes the plan against the codebase
3. Feedback is appended to the plan document
4. Findings are priority-ordered (P0 → P3)

**Example:**
```
User: "Review the plan at plans/feature-x-2026-01-18.md"
       
Workflow will:
- Read and analyze the plan
- Validate technical feasibility
- Identify design flaws, risks, missing steps
- Append feedback section to the plan file
```

**Output Format:**
- Addendum appended to plan with timestamp
- Sections: P0, P1, P2, P3
- Each item includes:
  - Severity and priority
  - Rationale with evidence
  - Actionable fix or alternative
  - File/line references when applicable

---

### 3. Development Workflow

#### Execution (`development/execution.md`)

**Purpose:** Execute implementation in phases with verification and documentation.

**When to use:**
- Implementing features from a plan
- Making code changes that need verification
- Ensuring changes are properly documented

**How to use:**
1. Confirm goal and acceptance criteria
2. Check repository state (`git status`)
3. Break work into phases with exit criteria
4. For each phase:
   - Implement smallest change
   - Verify (`npm run build`, `npm run dev`)
   - Update task list and changelog
5. Final verification before completion

**Example:**
```
User: "Implement the user authentication feature from the plan. 
       Start with Phase 1: API integration."
       
Workflow will:
- Read the implementation plan
- Implement Phase 1 changes
- Run npm run build
- Test in dev server
- Update CHANGELOG.md
- Update task list with ✅/⏳
- Proceed to next phase
```

**Phase Structure:**
- **Phase Definition:** Scope, out-of-scope, exit criteria
- **Implement:** Smallest change that satisfies scope
- **Verify:** Build, test, fix if needed
- **Report:** Update changelog, troubleshooting log, task list

**Task List Format:**
- ✅ Completed items
- ⏳ Pending items

**Documentation Updates:**
- `CHANGELOG.md`: `YYYY-MM-DD HH:MM - Description`
- `TROUBLESHOOTING.md`: Bug fixes with problem, observation, detection, fix

---

### 4. Debug Workflow

#### Bug Fix (`debug/bug-fix-workflow.md`)

**Purpose:** Systematically identify and fix bugs using hypothesis-driven investigation.

**When to use:**
- When a bug is reported or discovered
- When tests are failing
- When unexpected behavior occurs

**How to use:**
1. Gather information: logs, screenshots, reproduction steps
2. Formulate hypotheses about root cause
3. Investigate using parallel agents
4. Identify problem and root cause
5. Create implementation and testing plan
6. Implement fix
7. Verify with tests
8. Update changelog and troubleshooting log

**Example:**
```
User: "The image generation is failing with error 'API key invalid'. 
       Here are the logs: [logs]"
       
Workflow will:
- Analyze logs and error message
- Form hypotheses (key format, env var, service config)
- Investigate codebase with parallel agents
- Identify root cause
- Create fix plan
- Implement fix
- Test verification
- Update TROUBLESHOOTING.md
```

**Process:**
1. **Intake:** Gather logs, screenshots, reproduction steps
2. **Hypothesis:** Formulate likely causes
3. **Investigation:** Use parallel agents to test hypotheses
4. **Identification:** Determine root cause
5. **Planning:** Create fix and test plan
6. **Implementation:** Apply fix
7. **Verification:** Test until bug is resolved
8. **Documentation:** Update logs

---

### 5. Security Workflows

#### Security Review (`review/security-review.md`)

**Purpose:** Perform a structured security review identifying vulnerabilities, security risks, and compliance issues.

**When to use:**
- Before releases or deployments
- After major code changes
- Periodic security audits
- When security requirements change
- After security incidents

**How to use:**
1. Specify repository root (or focus areas)
2. Workflow scans codebase using 6 parallel agents focused on different security domains
3. Findings are scored with severity (S0-S3) and priority (P0-P3)
4. Report saved to `../../plans/` with timestamp

**Example:**
```
User: "Perform a security review focusing on authentication and API endpoints."
       
Workflow will:
- Scan auth files, API endpoints, and related code
- Identify vulnerabilities (injection, XSS, auth bypass, etc.)
- Score each finding (S0-S3, P0-P3)
- Generate report: plans/security-review-YYYY-MM-DD-HH-MM.md
```

**Security Focus Areas:**
- Authentication and session management
- Authorization and access control
- Input validation and injection risks
- Sensitive data exposure
- Dependency vulnerabilities
- Cryptographic issues
- Security misconfigurations
- And more (OWASP Top 10 coverage)

**Output Format:**
- Summary with top P0/P1 security risks
- Findings ordered by priority, then severity
- Each finding includes:
  - Vulnerability type and classification
  - Attack vector and exploitability
  - Security impact assessment
  - Suggested fix with security best practices
  - Verification steps

#### Security Fix (`security/security-fix.md`)

**Purpose:** Systematically identify, fix, and verify security vulnerabilities.

**When to use:**
- When a security vulnerability is discovered
- After receiving a security review report
- When addressing security advisories
- When fixing reported security issues

**How to use:**
1. Provide security review report or vulnerability description
2. Workflow investigates using parallel agents
3. Implements fix following security best practices
4. Verifies fix and tests for regression
5. Updates documentation

**Example:**
```
User: "Fix the SQL injection vulnerability identified in the security review 
       at plans/security-review-2026-01-18-14-00.md, issue #3."
       
Workflow will:
- Read security review report
- Investigate the vulnerability
- Implement fix (parameterized queries, input validation)
- Add security tests
- Verify fix works and doesn't break functionality
- Update TROUBLESHOOTING.md
```

**Process:**
1. **Intake:** Read security report, understand vulnerability
2. **Investigation:** Use parallel agents to trace vulnerability
3. **Root Cause:** Identify exact cause and attack vector
4. **Planning:** Create security fix plan with defense-in-depth
5. **Implementation:** Fix with multiple agents (fix, tests, validation)
6. **Verification:** Test fix, check for regression, verify no new issues
7. **Documentation:** Update CHANGELOG and TROUBLESHOOTING

**Security Fix Best Practices:**
- Strong authentication and authorization
- Input validation and output encoding
- Secure secrets management
- Updated dependencies
- Defense in depth measures

---

### 6. Documentation Workflows

#### Sync Documentation (`documentation/sync-documentation.md`)

**Purpose:** Review code and update documentation to match the codebase accurately.

**When to use:**
- After major code changes
- When documentation seems outdated
- Periodic documentation maintenance
- Before releases

**How to use:**
1. Workflow scans codebase to understand current behavior
2. Inventories existing docs and tags issues (P0-P3)
3. Fixes in priority order:
   - P0: Incorrect docs causing wrong usage
   - P1: Missing critical docs
   - P2: Reorganization and consolidation
   - P3: Diagrams and polish
4. Reorganizes `../../docs/` if needed
5. Adds file maps and diagrams

**Example:**
```
User: "Sync documentation after the authentication feature was added."
       
Workflow will:
- Scan codebase for auth-related code
- Check docs/ for auth documentation
- Identify missing/incorrect docs
- Update or create docs in priority order
- Add file maps if needed
- Cross-link related docs
```

**Priority Buckets:**
- **P0:** Incorrect docs causing wrong usage, broken setup, unsafe behavior
- **P1:** Missing docs for critical flows (setup, run, build, architecture)
- **P2:** Reorganization, consolidation, cross-links, reference completeness
- **P3:** Diagrams, polish, deep examples

**Output:**
- Organized `docs/` directory
- Accurate, up-to-date documentation
- File maps for navigation
- Cross-linked related docs

---

### 7. Reference Materials

#### Severity & Priority Rubric (`reference/severity-priority-rubric.md`)

**Purpose:** Shared standard for scoring issues across all workflows.

**When to use:**
- Referenced automatically by all review and planning workflows
- Use when manually prioritizing issues
- Use when creating reports or plans

**Severity Levels:**
- **S0 Critical:** Security breach, data loss, total outage
- **S1 High:** Major functionality broken, wide user impact
- **S2 Medium:** Partial failure, workaround exists
- **S3 Low:** Minor UX, cosmetic, maintainability

**Priority Mapping:**
- **P0 Blocker:** High impact + Likely/Possible → Fix before merge
- **P1 Urgent:** High impact + Rare, or Medium + Likely → Fix before release
- **P2 Soon:** Medium + Possible/Rare, or Low + Likely → Fix next sprint
- **P3 Backlog:** Low + Possible/Rare → Track and defer

**Ordering Rule:**
- Present items: P0 → P1 → P2 → P3
- Within same priority: S0 → S1 → S2 → S3

---

## Workflow Integration Examples

### Example 1: Adding a New Feature

```
Step 1: Planning
→ Use "Implementation Plan" workflow
→ Input: Feature requirements
→ Output: plans/feature-auth-2026-01-18-14-30.md

Step 2: Review
→ Use "Plan Review" workflow  
→ Input: plans/feature-auth-2026-01-18-14-30.md
→ Output: Feedback appended to plan

Step 3: Refine Plan
→ Use "Implementation Plan" workflow again
→ Input: Original plan + review feedback
→ Output: Updated plan

Step 4: Development
→ Use "Execution" workflow
→ Input: Refined plan
→ Output: Implemented code, updated CHANGELOG.md

Step 5: Code Review
→ Use "Code Review" workflow
→ Input: Repository root
→ Output: plans/code-review-2026-01-18-16-00.md

Step 6: Documentation
→ Use "Sync Documentation" workflow
→ Input: Repository root
→ Output: Updated docs/
```

### Example 2: Fixing a Critical Bug

```
Step 1: Debug
→ Use "Debug" workflow
→ Input: Bug report, logs, screenshots
→ Output: Fixed code, updated TROUBLESHOOTING.md

Step 2: Code Review
→ Use "Code Review" workflow
→ Input: Repository root (focus on fix area)
→ Output: Verification that fix is correct

Step 3: Documentation (if needed)
→ Use "Sync Documentation" workflow
→ Input: Repository root
→ Output: Updated docs if bug affected user-facing behavior
```

### Example 3: Periodic Maintenance

```
Step 1: Code Review
→ Use "Code Review" workflow
→ Input: Repository root
→ Output: plans/code-review-2026-01-18-10-00.md

Step 2: Planning
→ Use "Implementation Plan" workflow
→ Input: Code review findings
→ Output: plans/tech-debt-2026-01-18-11-00.md

Step 3: Development
→ Use "Execution" workflow
→ Input: Tech debt plan
→ Output: Refactored code

Step 4: Documentation
→ Use "Sync Documentation" workflow
→ Input: Repository root
→ Output: Updated docs/
```

### Example 4: Security Audit and Remediation

```
Step 1: Security Review
→ Use "Security Review" workflow
→ Input: Repository root
→ Output: plans/security-review-2026-01-18-14-00.md

Step 2: Security Fix (for critical issues)
→ Use "Security Fix" workflow
→ Input: Security review report, P0/S0 vulnerabilities
→ Output: Fixed code, updated TROUBLESHOOTING.md

Step 3: Code Review
→ Use "Code Review" workflow
→ Input: Repository root (focus on security fixes)
→ Output: Verification that fixes are correct

Step 4: Documentation (if needed)
→ Use "Sync Documentation" workflow
→ Input: Repository root
→ Output: Updated security documentation
```

---

## Best Practices

### 1. Always Use Priority Ordering
- All workflows use P0 → P3 priority ordering
- Focus on P0/P1 items first
- Defer P3 items unless they unblock higher priorities

### 2. Verify Before Proceeding
- Use `npm run build` to verify changes
- Test in dev server (`npm run dev`) when applicable
- Don't skip verification steps

### 3. Document as You Go
- Update `CHANGELOG.md` after each phase
- Update `TROUBLESHOOTING.md` for bug fixes
- Keep documentation in sync with code

### 4. Use Parallel Agents
- Many workflows support parallel agents
- Use them to accelerate scanning and investigation
- Verify findings directly before acting

### 5. Keep Changes Small
- Prefer smallest viable change
- Break large features into phases
- Each phase should have clear exit criteria

### 6. Evidence-Based Decisions
- Always include evidence for findings
- Cite file paths and line numbers
- Avoid unverified claims or assumptions

### 7. Scope Management
- Avoid over-engineering
- Push speculative refactors to P3
- Focus on concrete, measurable goals

---

## Workflow File Structure

```
workflows/
├── README.md (this file)
├── SHARING_AND_SYNC.md (guide for sharing workflows across projects)
├── update-workflows.sh (helper script for updating workflows)
├── pull-workflows.sh (helper script for pulling workflow updates)
├── meta/
│   ├── parallel-agents-review.md (analysis document)
│   └── filename-review.md (analysis document)
├── planning/
│   ├── implementation-plan.md
│   └── plan-review.md
├── review/
│   ├── code-review.md
│   └── security-review.md
├── development/
│   └── execution.md
├── debug/
│   └── bug-fix-workflow.md
├── security/
│   └── security-fix.md
├── documentation/
│   ├── sync-documentation.md
│   └── sync-summary-template.md
└── reference/
    └── severity-priority-rubric.md
```

**Note:** Files in `meta/` are analysis/review documents about the workflows, not workflow instructions themselves. Workflow instruction files do not reference these meta documents.

---

## Getting Help

If you're unsure which workflow to use:

1. **Starting new work?** → Use Planning workflow
2. **Reviewing something?** → Use Review workflows
3. **Security audit needed?** → Use Security Review workflow
4. **Writing code?** → Use Execution workflow
5. **Fixing a bug?** → Use Bug Fix workflow
6. **Fixing security issues?** → Use Security Fix workflow
7. **Docs out of date?** → Use Documentation workflow

All workflows reference the shared rubric in `reference/severity-priority-rubric.md` for consistent priority and severity scoring.

---

## Notes

- Workflows are designed to be used with AI agents that can execute them
- Each workflow is self-contained but designed to work together
- Priority ordering (P0-P3) is consistent across all workflows
- All workflows produce timestamped outputs in `../../plans/` or update existing files
- Documentation updates go to `../../docs/` and `../../CHANGELOG.md`
