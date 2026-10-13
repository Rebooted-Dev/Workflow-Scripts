# Agent learnings log in project/learnings (file 11 and setup Step 2.8.5)

**Date:** 2026-10-13
**Type:** added

## Summary

Added the agent learnings log to the project setup workflow. It uses the same scheme as the changelog and troubleshooting logs: a `README.md`, a chronological `index.md` (newest first, with a Status column), category sub-folders, and one file per entry. Entries marked `ACTIVE` are the rules agents follow before non-trivial work.

- **New `00-project-setup/11-agent-learnings.md`.** Directory setup, the README and index templates, the AGENTS.md section and PROJECT.md line, migration of a root `AGENT_LEARNINGS.md`, verification, and maintenance (promotion, supersession, review).
- **`00-project-setup/01-setup-project.md`.** Intro item 10; Quick Start directories, index, and check; Step 1.1 row and placement-test item 4; the Agent Learnings section in the Step 1.2 AGENTS.md template; a Layout line in the Step 1.4 PROJECT.md template; Step 2.0 directories and check; Step 2.6.1 directory list and "Interpreting Update the Logs" item 4; the Step 2.8.2 pointer; new **Step 2.8.5**; the Update section; Step 3.4.2; the Step 4.2 migration paragraph; a checklist item.
- **`00-project-setup/README.md`.** Index row and decision-guide entry for file 11.
- **Proposal** `00-project/plans/agents-patches/agent-learnings-proposal.md`: status set to implemented, and the README template fence fixed (its inner code blocks had closed the outer fence early).

NuBible-App was not changed. Applying the layout there is a separate plan.

## Rulings

- Pointer in AGENTS.md only, with no import in CLAUDE.md or GEMINI.md. The proposal recommended pointer-only first.
- Active rules are index rows with Status `ACTIVE`, not a separate file, as the developer directed.
- Kept the five categories from the proposal: workflow, code, tooling, facts, communication.

## Verification

- All 57 non-blank lines of the README template in file 11 match the proposal's README template.
- `check-active-markdown-links.sh` passes.
- `check-meta-logs.sh --staged` passes.

**Troubleshooting:** not needed — new workflow content. The fence fix was in an unadopted proposal, so it is not a workflow defect.
