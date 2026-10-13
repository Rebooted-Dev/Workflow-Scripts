# Agent Learnings (`project/learnings/`)

Agents record what they learn that the repo does not already record: a mistake, a correction from the user, a non-obvious fact found by checking, or a verified better approach. Later sessions read these first, so the same mistake is not made twice.

The scheme is the same as the changelog and troubleshooting logs: a README, a chronological `index.md` (newest first), category sub-folders, and one file per entry.

This is the procedure that [01-setup-project.md](./01-setup-project.md) calls in **Step 2.8.5**. Use it for a new project, or to add the system to an existing one.

## Where it sits

| Log | Records | Lives in |
|---|---|---|
| Changelog | What changed | `project/changelog/` |
| Troubleshooting | A bug or issue, and how it was fixed | `project/troubleshooting/` |
| Agent learnings | How to work here, and verified non-obvious facts | `project/learnings/` |
| Plans | Progress on a piece of work | `project/plans/` (checkboxes) |

Agent learnings are not changelog or troubleshooting entries. A non-trivial bug gets a troubleshooting entry; a learning may link to it in one line.

---

## Step 1: Create the directory

```bash
mkdir -p project/learnings/{workflow,code,tooling,facts,communication}
```

Then create `README.md` (Step 2) and `index.md` (Step 3) if they are missing. **Never overwrite** an existing index or entry.

## Step 2: Create `project/learnings/README.md`

````markdown
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
````

## Step 3: Create `project/learnings/index.md`

```markdown
# Agent Learnings Index

Chronological index of agent learnings.
**Newest entries are listed first.**

| Date       | Category | Title | File | Status |
|-----------|----------|-------|------|--------|
```

## Step 4: Point AGENTS.md and PROJECT.md at it

Add to AGENTS.md (Step 1.2 of `01-setup-project.md`), between **Execution** and **Change Management**:

```markdown
## Agent Learnings
- **Before non-trivial work:** read `project/learnings/index.md` and follow each entry marked ACTIVE.
- **After a mistake, a correction, or a verified non-obvious fact:** add an entry under `project/learnings/<category>/` and a row at the top of `project/learnings/index.md` (conventions in `project/learnings/README.md`), then tell the user what you added and where. Write new entries as NOTED; mark one ACTIVE only when the developer approves it.
```

Add to PROJECT.md, under Layout (Step 1.4 of `01-setup-project.md`):

```markdown
- **Agent learnings:** `project/learnings/` — `index.md` and category folders; conventions in `README.md`.
```

AGENTS.md holds the rule. The learnings stay in `project/learnings/`. Do not copy entries into AGENTS.md.

## Step 5: Migrate a root `AGENT_LEARNINGS.md` (when present)

Some projects have a root `AGENT_LEARNINGS.md` from an earlier pattern. Migrate it the way Step 2.7 of `01-setup-project.md` migrates troubleshooting backups:

1. **Drop placeholders and copied commands.** Remove entries such as "Example entry (delete me)". Do not copy commands from another project's template (for example `pnpm` commands). Project commands belong in `docs/agents/development-workflow.md`.
2. **Split into entries.** Each lesson becomes one file under its category: `project/learnings/<category>/<yyyy-mm-dd>-<category>-<short-title>.md`, using the date from the old entry.
3. **Set status.** Every migrated lesson is `NOTED`. A lesson from the old Active Rules section becomes `ACTIVE` only when the developer approves it, with an `**Approved:**` date. Give each entry a `**Source:**` line; use `unverified` when the old file does not show one.
4. **Update the index.** Add one row per entry at the top of `project/learnings/index.md` (newest first).
5. **Remove the root file.** Only after step 4 and the Step 6 check pass. Then update the AGENTS.md pointer if it still names the old file.

## Step 6: Verify

```bash
test -f project/learnings/README.md && echo "✓ project/learnings/README.md exists"
test -f project/learnings/index.md && echo "✓ project/learnings/index.md exists"
for d in workflow code tooling facts communication; do test -d "project/learnings/$d" && echo "✓ project/learnings/$d/ exists"; done
test ! -f AGENT_LEARNINGS.md && echo "✓ no root AGENT_LEARNINGS.md"
grep -q 'project/learnings/index.md' AGENTS.md && echo "✓ AGENTS.md points to project/learnings/index.md"
bash <WORKFLOWS_DIR>/scripts/validation/check-learnings.sh project/learnings
```

---

## Maintenance

- **Promotion.** When an ACTIVE rule belongs in every agent's instructions, the developer approves moving it to AGENTS.md. A verified fact moves to PROJECT.md. Set the row to `PROMOTED; <section>`, and do not keep the rule in two places.
- **Supersession.** Set `SUPERSEDED; see <newer entry>`.
- **Review.** At consolidation, check that ACTIVE rows are still true. Remove or supersede stale ones.
- **Growth.** If `index.md` grows large, consider moving NOTED rows out of it. Troubleshooting does not do this today, so keep the scheme the same until there is a reason to change it.
