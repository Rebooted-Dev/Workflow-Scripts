# Agent Learnings

Agents record here what they learn that the repo does not already record. This directory is the project's agent learnings log: `project/learnings/` in a consumer project, `00-project/learnings/` in Workflow-Scripts.

## Directory Structure

- `workflow/` - How to work: planning, verification, tool use
- `code/` - Code patterns and pitfalls in this repo
- `tooling/` - Commands, build, and environment quirks
- `facts/` - Non-obvious project facts found by checking; promote to PROJECT.md when verified
- `communication/` - How results should be reported and shown
- `index.md` - Chronological index of all entries, with status

## File Naming Convention

Each learning entry uses this pattern:

```
<yyyy-mm-dd>-<category>-<short-title>.md
```

Examples:
- `2026-10-13-tooling-test-command-needs-env-var.md`
- `2026-10-13-workflow-verify-line-counts-before-reporting.md`

## Entry Template

```markdown
# <Short Title>
**Date:** <YYYY-MM-DD>
**Category:** <workflow|code|tooling|facts|communication>
**Status:** <ACTIVE|NOTED|PROMOTED|SUPERSEDED>
**Source:** <developer message|command|file|unverified>: <the developer's words, the command and its result, or the file path>
**Approved:** <YYYY-MM-DD, the developer's approval; required for ACTIVE, omit otherwise>

---

## Situation
- What happened, in one or two lines.

## Pattern to avoid
- What was done, or what would be wrong to repeat. Write `- None.` if the session shows no mistake.

## Better approach
- What to do instead. Write `- None.` if there is nothing to add.

## Verification
- How this was checked: a test, a command and its result, or a file. Write `- None.` if it was not checked, and set Source to `unverified`.

## Notes
- Links to related troubleshooting or changelog entries. For PROMOTED, the section it moved to. Write `- None.` if there are none.
```

## What Belongs Here

- A mistake you made, or a correction the user gave you.
- A non-obvious fact you found by checking the code or docs.
- A better approach you verified.

## What Does Not Belong Here

- Anything the code, git history, `project/changelog/`, or `project/troubleshooting/` already records. Link to those instead.
- Bug write-ups. A non-trivial bug gets a troubleshooting entry.
- Plan progress. Plans keep their checkboxes.
- Secrets, tokens, or personal data.

## Accuracy

- Write only what happened in the session, and cite its source in the `**Source:**` line: the developer's message (quoted), a command and its result, or a file path. Use `unverified` when none applies.
- Do not write that the developer confirmed or corrected something unless the conversation shows it.
- Do not write that you made a mistake unless the session shows the mistake.
- A section with nothing to say is written as `- None.`. Do not fill it with guesses.
- Agents write new entries as `NOTED`. An entry becomes `ACTIVE` only when the developer approves it; the developer's approval date goes in `**Approved:**`.

## Statuses

- `ACTIVE` - Verified or recurring, and approved by the developer (`**Approved:**` date). Its Source is not `unverified`. Agents follow it before non-trivial work. The Status cell carries the rule in one line, after `ACTIVE;`.
- `NOTED` - Recorded once. Not yet verified or recurring. No obligation.
- `PROMOTED` - Moved into AGENTS.md or PROJECT.md. Names the section. The entry stays as the record.
- `SUPERSEDED` - Replaced by a later entry. Links the replacement.

## Maintaining the Index

The `index.md` file is the single chronological index. **Newest entries are listed first.**

When adding a new entry:
1. Create the entry file in the appropriate category folder.
2. Add a new row at the **top** of the table in `index.md` with: Date, Category, Title, File, Status.
3. Write it as `NOTED`. Mark it `ACTIVE` only when the developer approves it: add the `**Approved:**` date to the entry and put the rule in one line after `ACTIVE;`.

When promoting or superseding an entry:
- **Promoted:** move the rule into AGENTS.md (or PROJECT.md for a fact), then set the row to `PROMOTED; <file>` naming the section. Do not keep the rule in two places.
- **Superseded:** set `SUPERSEDED; see <newer entry>`.

## For AI Agents / Coding Assistants

- **Before non-trivial work:** read `index.md` and open each entry marked `ACTIVE`.
- **After a mistake, a correction, or a verified non-obvious fact:** create the entry in its category folder, add the index row, and tell the user what you added and where.
- Do not add entries for things the changelog or troubleshooting already records. Link to them.
