# Factor Claude cache status line setup into its own setup doc (Step 2.13)

**Date:** 2026-10-13
**Type:** docs

## Summary

Moved the prompt-cache status line instructions out of the plan and into a standalone setup file, and added a Step 2.13 to the project setup workflow that calls it.

- **New `00-project-setup/10-claude-cache-statusline.md`.** Scope (user-level, applies to every session, project `statusLine` replaces it), a permission gate, a read-only local check with a decision table (version, `jq`, existing `statusLine`, already installed, another owner), an ask-first install, variant A (no existing status line) and variant B (keep the existing one), tests, project override check, states, troubleshooting, reference, removal, and an appendix with the existing status line logic from the first computer.
- **`01-setup-project.md`.** Intro item 9, a Quick Start entry, **Step 2.13** (check, ask, install only after a yes, project override check, verify), Step 3.7.2 verification, two checklist items, the "update an existing project" steps, and the AI agent note now covers Step 2.13.
- **`00-project-setup/README.md`.** Index row and a decision-guide entry for file 10.
- The plan `00-project/plans/claude-cache.md` keeps its own copy of the script and its checkboxes as the build record.

No code, settings, or repository files were changed by this entry. The machine's status line was already installed and checked earlier.

## Rulings

- Kept the plan's copy of the instructions as the build record instead of trimming it to a pointer. Cost if wrong: the two copies can drift; trim the plan to a link to file 10 if one source is wanted.
- Step 2.13 asks before any write. A declined install is recorded in the setup notes and the workflow continues.

## Verification

- The variant A script block in file 10 is byte-identical to the plan's canonical script. The appendix block is byte-identical to the logic used on this computer.
- `check-active-markdown-links.sh` passes.
- All 15 table-of-contents anchors in file 10 resolve to headings. The Step 2.13 anchor in file 01 matches its heading.

**Troubleshooting:** not needed — documentation restructuring; no defect found.
