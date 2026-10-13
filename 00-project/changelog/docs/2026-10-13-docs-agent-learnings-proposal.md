# Proposal: agent learnings in project/learnings/ (index and category scheme)

**Date:** 2026-10-13
**Type:** docs

## Summary

Filed `00-project/plans/agents-patches/agent-learnings-proposal.md`, a proposal (not adopted) for the agent learnings pattern in `agents-patches/patch-info.md`.

- Keep the pattern: agents check past lessons before non-trivial work and record new ones.
- Store it with the scheme the project already uses for changelog and troubleshooting: `project/learnings/` with a README, an `index.md` (newest first, with a Status column), category sub-dirs, and one file per entry. Entries marked `ACTIVE` are the active rules.
- AGENTS.md gets a two-bullet section that points there. The patch's commands (pnpm), its duplicated critical rules, and its example entry are not carried over.
- Recommends factoring the workflow into `00-project-setup/11-agent-learnings.md`, with a Step 2.8.5 in file 01 as a pointer, and adding learnings to "Interpreting Update the Logs" as a third log.

No files in `00-project-setup/` or in NuBible-App changed.

## Rulings

- Proposal, not a plan: no checkboxes, because nothing is approved. The follow-up work will be a plan.
- Revised the first draft's split `active-rules.md` and `log.md` design to the index and category scheme, as the developer directed.
- Left `agents-patches/` untracked and uncommitted, as before.

**Troubleshooting:** not needed — proposal filing; no defect found.
