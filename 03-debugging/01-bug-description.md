# Workflow: Bug Description Report

## Purpose
Create a comprehensive, structured bug report when a bug persists after initial fix attempts. This workflow synthesizes information from troubleshooting entries, changelog, codebase analysis, and investigation to produce a detailed report that documents the problem, observed behavior, attempted solutions, and recommended next steps.

## When to Use This Workflow

**Use this workflow when:**
- A bug persists after initial fix attempts
- You need to create a comprehensive bug report for complex issues
- Multiple troubleshooting attempts have failed
- You need to document investigation history and attempted solutions
- You want to create a detailed report for escalation or team review

**Use [`02-bug-fix-workflow.md`](./02-bug-fix-workflow.md) instead when:**
- You are investigating a bug for the first time
- You need to fix a bug immediately
- The bug is straightforward and can be fixed quickly
- You don't need comprehensive documentation

**This workflow will:**
- Gather information from troubleshooting history and changelog
- Analyze the codebase context and error evidence
- Create a comprehensive bug description report
- Document all attempted solutions and their outcomes
- Provide root cause hypotheses and recommended next steps

## Inputs
- Bug report or issue description (user-supplied).
- Repository root.
- Additional context: error logs, stack traces, screenshots, reproduction steps, affected users/systems.
- Previous troubleshooting entries in `troubleshooting/`.
- Recent changes documented in `docs/CHANGELOG.md` (preferred) or `CHANGELOG.md`.

## Prioritization Rule
- Classify the bug using severity (S0–S3) and priority (P0–P3) per the shared rubric: `../00-Meta-Workflow/00-meta/severity-priority-rubric.md`.
- Present findings ordered by priority (P0 to P3), then severity within each priority.
- Critical bugs (P0/S0) that cause data loss, security issues, or service outages must be documented immediately with highest detail.

## Steps

### 1. Information Gathering
Use multiple parallel agents to gather comprehensive information about the bug. Each agent should read relevant files in parallel batches (read multiple files concurrently, not sequentially):

- **Agent 1: Review Troubleshooting History**
  - Read all entries in `troubleshooting/` directory (read index.md and category files in parallel)
  - Identify related or similar issues that were previously encountered
  - Extract patterns, attempted fixes, and lessons learned
  - Note any recurring issues or unresolved problems

- **Agent 2: Analyze Changelog and Recent Changes**
  - Read `docs/CHANGELOG.md` if present; otherwise read `CHANGELOG.md`
  - Check `plans-completed/` directory for similar past issues and resolution patterns
  - Identify recent changes that might have introduced or affected the bug
  - Map timeline of changes to bug occurrence
  - Extract context about related features or fixes

- **Agent 3: Examine Codebase Context**
  - Read affected files and related code (read multiple files in parallel batches)
  - Trace the bug through execution paths
  - Identify related components, services, or modules
  - Map dependencies and interactions

- **Agent 4: Review Error Logs and Evidence**
  - Analyze provided error logs, stack traces, and screenshots
  - Extract error messages, line numbers, and stack frames
  - Identify patterns in error occurrences
  - Document reproduction conditions

- **Agent 5: Investigate Similar Patterns**
  - Search codebase for similar code patterns or implementations (read similar files in parallel)
  - Check for related bugs or edge cases
  - Identify potential systemic issues
  - Review error handling and validation logic

Agents should batch read files concurrently to maximize investigation speed.

### 2. Problem Analysis
Synthesize information from all agents to create a comprehensive understanding:

- **Observed Behavior**
  - Document what actually happens (symptoms, errors, unexpected behavior)
  - Include reproduction steps if available
  - Note frequency and conditions of occurrence
  - Capture user impact and affected functionality

- **Expected Behavior**
  - Define what should happen under normal conditions
  - Reference design documents or specifications if available
  - Note any discrepancies between expected and observed

- **Attempted Solutions**
  - List all fixes, workarounds, or mitigations that were tried
  - Check `plans-completed/` for similar past issues and their resolutions
  - Document why each attempt failed or was insufficient
  - Reference troubleshooting entries and changelog entries
  - Note any partial successes or temporary fixes

- **Root Cause Hypotheses**
  - Formulate hypotheses about the underlying cause
  - Rank hypotheses by likelihood based on evidence
  - Identify what additional information is needed to confirm
  - Note any contradictions or gaps in understanding

### 3. Impact Assessment
Assess the full scope and impact of the bug:

- **User Impact**
  - Number of affected users or systems
  - Severity of impact on user experience
  - Workarounds available (if any)
  - Business or operational consequences

- **Technical Impact**
  - Affected components, features, or systems
  - Data integrity or security implications
  - Performance degradation or resource issues
  - Integration or dependency problems

- **Classification**
  - Apply severity (S0–S3) and priority (P0–P3) using the rubric
  - Provide rationale for classification
  - Note any factors that might change priority (e.g., user reports, frequency)

### 4. Report Generation
Create a structured bug description report with the following sections:

- **Report Header**
  - Timestamp: `YYYY-MM-DD HH:MM`
  - Bug title (concise, descriptive)
  - Severity and priority classification with rationale
  - Status: OPEN, IN_PROGRESS, BLOCKED, or RESOLVED

- **Executive Summary**
  - One-paragraph overview of the bug
  - Key symptoms and impact
  - Current status and recommended action

- **Problem Description**
  - Detailed observed behavior
  - Expected behavior
  - Reproduction steps (if available)
  - Environment details (browser, OS, version, configuration)

- **Investigation History**
  - Timeline of when bug was discovered
  - Related troubleshooting entries (with links/references)
  - Related completed plans in `plans-completed/` that may provide context
  - Recent changes from changelog that might be relevant
  - Investigation steps taken

- **Attempted Solutions**
  - List of all fixes, workarounds, or mitigations attempted
  - Why each attempt failed or was insufficient
  - Any partial successes or learnings
  - References to code changes or configuration updates

- **Root Cause Analysis**
  - Current hypotheses ranked by likelihood
  - Evidence supporting or contradicting each hypothesis
  - Gaps in understanding or missing information
  - Recommended investigation steps to confirm root cause

- **Impact Assessment**
  - User impact (affected users, severity, workarounds)
  - Technical impact (affected systems, data, security)
  - Business or operational consequences
  - Risk assessment if bug remains unfixed

- **Recommended Next Steps**
  - Immediate actions (if any)
  - Investigation priorities (what to check next)
  - Potential fix approaches to explore
  - Testing strategy once fix is identified
  - Dependencies or blockers

- **Evidence and References**
  - Error logs, stack traces, screenshots
  - Links to troubleshooting entries
  - References to changelog entries
  - Code file paths and line numbers
  - Related issues or bugs

### 5. Report Storage
- Save the report to `plans/` (project root) with a dated filename:
  - Format: `bug-description-<YYYY-MM-DD>-<HH-MM>-<short-title>.md`
  - Example: `bug-description-2026-01-20-14-30-image-generation-failure.md`
- Ensure the report is self-contained and includes all necessary context
- Cross-reference related troubleshooting entries and changelog entries

## Output Requirements
- Comprehensive bug description report saved to `plans/` (project root) with dated filename
- Report includes all sections listed in Step 4
- Evidence and references are properly documented
- Severity and priority classification with rationale
- Clear recommended next steps
- Self-contained report that can be understood without additional context

## Acceptance Criteria
- Report is complete with all required sections
- Problem is clearly described with observed vs. expected behavior
- All attempted solutions are documented with outcomes
- Root cause hypotheses are formulated and ranked
- Impact is assessed with severity and priority classification
- Recommended next steps are actionable and prioritized
- Evidence is properly referenced and accessible
- Report is saved to plans directory with proper date
- Report is self-contained and understandable without additional context

## Bug Description Best Practices

### Comprehensive Documentation
- Document everything: symptoms, attempts, evidence, hypotheses
- Include both what worked and what didn't work
- Reference troubleshooting entries and changelog for context
- Capture patterns and recurring issues

### Evidence-Based Analysis
- Base hypotheses on evidence, not assumptions
- Include error logs, stack traces, and screenshots
- Reference specific code locations and line numbers
- Document reproduction steps when available

### Clear Communication
- Use plain language; avoid jargon when possible
- Structure information logically (problem → investigation → analysis → recommendations)
- Highlight critical information (severity, priority, blockers)
- Make recommendations actionable and prioritized

### Root Cause Focus
- Don't just document symptoms; investigate underlying causes
- Formulate and rank hypotheses based on evidence
- Identify gaps in understanding
- Recommend investigation steps to confirm root cause

## Related Workflows

- **[`02-bug-fix-workflow.md`](./02-bug-fix-workflow.md)** - Fix bugs (use this for initial bug investigation and fixes)
- **[`../01-planning-and-organizing/02-finalise-plan.md`](../01-planning-and-organizing/02-finalise-plan.md)** - Create implementation plan for complex bug fixes
- **[`../06-security/02-security-fix.md`](../06-security/02-security-fix.md)** - Fix security-related bugs
- **[`../00-Meta-Workflow/00-meta/severity-priority-rubric.md`](../00-Meta-Workflow/00-meta/severity-priority-rubric.md)** - Reference for severity and priority classification

## Notes
- This workflow is designed for bugs that persist after initial fix attempts. For initial bug investigation, use `02-bug-fix-workflow.md`.
- When reading files, agents should read multiple files concurrently (parallel batch reading) rather than sequentially to maximize speed.
- If information is incomplete or vague, document what is known and clearly identify what additional information is needed.
- Cross-reference related troubleshooting entries to identify patterns or recurring issues.
- Use the severity-priority rubric consistently to ensure proper classification.
- The report should be comprehensive enough that someone new to the bug can understand the full context.
- Consider if the bug indicates a broader architectural issue that should be addressed separately.
- If the bug is blocking critical work, prioritize creating the report and escalate appropriately.
