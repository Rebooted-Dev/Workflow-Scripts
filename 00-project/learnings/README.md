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

---

## Situation
- What happened, in one or two lines.

## Pattern to avoid
- What was done, or what would be wrong to repeat.

## Better approach
- What to do instead.

## Verification
- How this was checked (test, command, user confirmation). Write "unverified" if not.

## Notes
- Links to related troubleshooting or changelog entries. For PROMOTED, the section it moved to.
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

## Statuses

- `ACTIVE` - Verified or recurring. Agents follow it before non-trivial work. The Status cell carries the rule in one line, after `ACTIVE;`.
- `NOTED` - Recorded once. Not yet verified or recurring. No obligation.
- `PROMOTED` - Moved into AGENTS.md or PROJECT.md. Names the section. The entry stays as the record.
- `SUPERSEDED` - Replaced by a later entry. Links the replacement.

## Maintaining the Index

The `index.md` file is the single chronological index. **Newest entries are listed first.**

When adding a new entry:
1. Create the entry file in the appropriate category folder.
2. Add a new row at the **top** of the table in `index.md` with: Date, Category, Title, File, Status.
3. Mark it `ACTIVE` only when it is verified or recurring. Put the rule in one line after `ACTIVE;`.

When promoting or superseding an entry:
- **Promoted:** move the rule into AGENTS.md (or PROJECT.md for a fact), then set the row to `PROMOTED; <file>` naming the section. Do not keep the rule in two places.
- **Superseded:** set `SUPERSEDED; see <newer entry>`.

## For AI Agents / Coding Assistants

- **Before non-trivial work:** read `index.md` and open each entry marked `ACTIVE`.
- **After a mistake, a correction, or a verified non-obvious fact:** create the entry in its category folder, add the index row, and tell the user what you added and where.
- Do not add entries for things the changelog or troubleshooting already records. Link to them.
