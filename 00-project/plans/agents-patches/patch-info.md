# AGENTS.md

## Commands
- Install: `pnpm install`
- Dev: `pnpm dev`
- Test: `pnpm test`
- Lint: `pnpm lint`
- Typecheck: `pnpm typecheck`

## Critical Rules
- Never commit secrets, `.env` files, or `*.local.*` files.
- Prefer existing patterns and utilities over introducing new ones.
- Run tests and lint before considering a task complete.

## Agent Learnings

Before starting any non-trivial task, read `AGENT_LEARNINGS.md` (especially the Active Rules section).

When you make a mistake, receive a correction, discover a non-obvious project fact, or find a better approach that was verified:
1. Append a new dated entry to the Log section of `AGENT_LEARNINGS.md` using the existing structure.
2. If the lesson is recurring or high-value, also promote a short, imperative rule into the Active Rules section.
3. Briefly tell the user what you added and where.

When the Log grows long or contains duplicates:
- Consolidate related entries.
- Move stable rules into Active Rules.
- Archive or remove outdated entries.
- Keep Active Rules short and actionable.

## Working Style
- Prefer small, focused changes.
- Explain non-obvious decisions in comments or the PR description.
- Ask clarifying questions when requirements are ambiguous rather than guessing.


# Agent Learnings

This file is maintained by agents working on this repository.  
Read the Active Rules before starting work. Append to the Log when you learn something useful.

## Active Rules
- Prefer `pnpm` over `npm` or `yarn`.
- Never commit files matching `*.local.*` or `.env*`.
- Run `pnpm test` and `pnpm lint` before marking a task complete.

## Log

### 2026-10-13 — Example entry (delete me)
- **Mistake / Situation**: Example of a non-obvious failure.
- **Pattern to avoid**: Doing X without first checking Y.
- **Better approach**: Always do Z first. Example: `pnpm test -- --filter=affected`
- **Verified**: Yes (tests passed after the change).


Read AGENTS.md and AGENT_LEARNINGS.md.

Confirm you understand the Agent Learnings workflow:
- Always read AGENT_LEARNINGS.md (especially Active Rules) before non-trivial work.
- Append structured entries to the Log when you learn something useful.
- Promote high-value or recurring lessons into Active Rules.
- Periodically consolidate the file.

Then reply with a short confirmation and the current Active Rules.

Usage notesKeep AGENTS.md short. Move detailed or frequently changing lessons into AGENT_LEARNINGS.md.
Only promote rules that have been verified or that recur. One-off issues stay in the Log.
Both files are plain markdown, so they work with Claude Code, Codex, Cursor, Aider, Gemini CLI, and most other harnesses that honor AGENTS.md.

