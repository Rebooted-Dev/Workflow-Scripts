# Proposal: agent learnings in `project/learnings/` (index and category scheme)

**Status:** Adopted and implemented in Workflow-Scripts (2026-10-13): `00-project-setup/11-agent-learnings.md` (new) and `00-project-setup/01-setup-project.md` (Steps 1.1–1.4, 2.0, 2.6.1, 2.8.2, 2.8.5, Update, 3.4.2, 4.2, checklist). Not yet applied to NuBible-App; that is a separate plan.
**Filed:** 2026-10-13. **Revised 2026-10-13:** the storage now follows the changelog and troubleshooting scheme (README, `index.md`, category sub-dirs, one file per entry), as the developer directed. The first draft's split `active-rules.md` and `log.md` design is withdrawn.
**Source studied:** `00-project/plans/agents-patches/patch-info.md`
**Also read:** NuBible-App `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `PROJECT.md`, `docs/agents/`, and the live `project/troubleshooting/` (README, index, category folders) and `project/changelog/`; `00-project-setup/01-setup-project.md` (Steps 1.1–1.4, 2.0, 2.4–2.8, 3.4, 4.2, checklist); `00-project/plans/README.md`.

This is a proposal. Once approved, the follow-up work becomes a plan with checkboxes.

---

## 1. Summary

- The patch adds one behaviour: agents check past lessons before non-trivial work, and record new ones when they make a mistake, get a correction, or verify a non-obvious fact.
- **Keep the behaviour. Store it with the scheme the project already uses for its other logs.** That is `project/learnings/`, with a `README.md` (conventions), an `index.md` (one table, newest first), category sub-dirs, and one file per entry.
- **Active rules are index rows, not a separate file.** An entry whose Status is `ACTIVE` is an active rule. Agents read the index, then open those entries.
- AGENTS.md gets a two-bullet section that points there. It holds no learnings.
- **Do not copy the patch's AGENTS.md as written.** Its commands are pnpm (NuBible uses cargo and Flutter), and its critical rules duplicate `docs/agents/`. Only the Agent Learnings behaviour is new.
- Recommended packaging: factor the workflow into `00-project-setup/11-agent-learnings.md`, the same way the cache status line went into file 10. Step 2.8.5 in 01 becomes a pointer.

---

## 2. What each part of `patch-info.md` becomes

| Part of the patch | Verdict | Reason |
|---|---|---|
| **Agent Learnings** behaviour (read before work; record mistakes, corrections, facts; tell the user) | **Integrate** | The only new behaviour. The rule goes in AGENTS.md; the storage goes in `project/learnings/`. |
| **Usage notes** (keep AGENTS short; promote only verified or recurring lessons; one-offs stay recorded) | **Integrate into the README** | They are conventions for the log, so they belong there. |
| **Commands** (`pnpm install`, `pnpm dev`, `pnpm test`, `pnpm lint`, `pnpm typecheck`) | **Do not integrate** | NuBible builds with cargo and Flutter. Commands belong in `docs/agents/development-workflow.md`. |
| **Critical Rules** (never commit secrets; prefer existing patterns; run tests and lint) | **Do not integrate** | Already covered by `docs/agents/security-guidelines.md` (Secrets), `coding-standards.md`, and `testing-strategy.md`. Repeating them breaks the single-source rule (01 Step 1.1). |
| **Working Style** (small focused changes; explain decisions; ask when ambiguous) | **Not in this proposal** | General guidance, not a learnings concern. If wanted, it goes to `coding-standards.md` or the AGENTS Execution section, as a separate decision. |
| **Active Rule** "Prefer `pnpm` over `npm` or `yarn`" | **Do not carry over** | Wrong for this project. A project fact belongs in PROJECT.md, not in a learned rule. |
| **Log entry** "Example entry (delete me)" | **Do not carry over** | Placeholder. |
| **Confirmation prompt** ("Read AGENTS.md and AGENT_LEARNINGS.md… reply with the Active Rules") | **Do not integrate** | A prompt for one agent session, not a file rule. |

---

## 3. Why the troubleshooting scheme fits

- **Same job.** Both hold a growing record of things agents learned, one entry per item, found by scanning one index.
- **Same shape.** Entries are grouped by kind (troubleshooting uses `build/`, `runtime/`, and so on). The index has a Status column (troubleshooting uses RESOLVED, OPEN, WORKAROUND), and the newest entries come first.
- **The "read first" step is a scan.** Agents read `index.md` and open the rows marked ACTIVE. The one-line rule sits in the Status cell, the same way troubleshooting puts its resolution summary there.
- **Learnings and troubleshooting stay separate.** Troubleshooting records bugs and their fixes. Learnings record how to work. A non-trivial bug gets a troubleshooting entry, and a learning may link to it in one line.
- **Trade-off.** One file per entry means more files than a single log. Agents read the index and only the ACTIVE entries. Every project that uses 01 already knows this pattern, so no new pattern has to be learned.

---

## 4. Proposed layout

```
project/learnings/
├── README.md          conventions (same role as project/troubleshooting/README.md)
├── index.md           one table, newest first: Date | Category | Title | File | Status
├── workflow/          how to work: planning, verification, tool use
├── code/              code patterns and pitfalls in this repo
├── tooling/           commands, build, and environment quirks
├── facts/             non-obvious project facts found by checking (promote to PROJECT.md when verified)
└── communication/     how results should be reported and shown
```

**Status values** (mirror the RESOLVED / OPEN / WORKAROUND pattern):

| Status | Meaning |
|---|---|
| `ACTIVE` | Verified or recurring. Agents follow it before non-trivial work. The Status cell carries the rule in one line, after `ACTIVE;`. |
| `NOTED` | Recorded once. Not yet verified or recurring. No obligation. |
| `PROMOTED` | Moved into AGENTS.md or PROJECT.md. Names the section. The entry stays as the record. |
| `SUPERSEDED` | Replaced by a later entry. Links the replacement. |

---

## 5. Proposed file templates

### `project/learnings/README.md`

````markdown
# Agent Learnings

Agents record here what they learn that the repo does not already record. This directory lives under `project/learnings/`.

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
- `2026-10-13-tooling-flutter-test-needs-macos-wrapper.md`
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
````

### `project/learnings/index.md`

```markdown
# Agent Learnings Index

Chronological index of agent learnings.
**Newest entries are listed first.**

| Date       | Category | Title | File | Status |
|-----------|----------|-------|------|--------|
```

---

## 6. Proposed AGENTS.md section

Add between **Execution** and **Change Management** in the Step 1.2 template. The wording follows the existing Change Management bullets:

```markdown
## Agent Learnings
- **Before non-trivial work:** read `project/learnings/index.md` and follow each entry marked ACTIVE.
- **After a mistake, a correction, or a verified non-obvious fact:** add an entry under `project/learnings/<category>/` and a row at the top of `project/learnings/index.md` (conventions in `project/learnings/README.md`), then tell the user what you added and where. Mark an entry ACTIVE only when it is verified or recurring.
```

Line budget: this adds about five lines. NuBible-App's AGENTS.md is 34 lines today, so it would reach about 40, the Step 1.1 target. Trim elsewhere if the limit matters.

---

## 7. Proposed PROJECT.md line (Layout)

```markdown
- **Agent learnings:** `project/learnings/` — `index.md` and category folders; conventions in `README.md`.
```

---

## 8. Integration into `01-setup-project.md`

| Where in 01 | Change | Why |
|---|---|---|
| Intro list | Add an item for agent learnings (`project/learnings/`, same scheme as troubleshooting). | The workflow should list every structure it creates. |
| Quick Start, step 4 | Add `mkdir -p project/learnings/{workflow,code,tooling,facts,communication}` and create `index.md` with the table header, the same way the troubleshooting lines are already written. | New projects get the structure from day one. |
| Step 1.1 table | Add a row for `project/learnings/`: the agent learnings index and categories, read by pointer from AGENTS.md. Extend the placement test: learned lessons go to `project/learnings/`, not into AGENTS.md. Rules reach AGENTS.md only through PROMOTED. | Keeps the single-source rule explicit. |
| Step 1.2 AGENTS.md template | Insert the section from §6. | The rule lives in AGENTS.md; the storage does not. |
| Step 1.4 PROJECT.md template | Add the Layout line from §7. | Layout is a project fact. |
| Step 2.0 directories | Add the five category folders. | Other workflows expect the project dirs. |
| **New Step 2.8.5** | Create `project/learnings/`: README (§5), `index.md` (§5), and category folders. The same shape as Steps 2.4 and 2.5 for troubleshooting. Or a pointer to `00-project-setup/11-agent-learnings.md` if factored (recommended). | One scheme, same steps as the other logs. |
| Step 2.8.2 "Where to put things" | Add: **Agent learning** → `project/learnings/<category>/` + row in `project/learnings/index.md`. | Matches the existing pattern. |
| Step 2.6.1 (`docs/agents/changelog-and-troubleshooting.md` template) | Add `project/learnings/index.md` to "Documentation, Plans & Project Directories". Under "Interpreting Update the Logs", add learnings as a third log with its triggers (mistake, correction, verified fact). State that learnings are not changelog or troubleshooting entries. | Stops the three from being confused, and makes "update the logs" cover all three. |
| "Updating an existing project" → What to update | Create `project/learnings/` only if missing. Never overwrite an existing `index.md` or entry. | Same rule as the other indexes. |
| Step 4.2 "Migrating single-file or ad-hoc logs" | If a root `AGENT_LEARNINGS.md` exists, follow the Step 2.7 migration procedure: one file per entry under its category, one index row per entry (newest first, dates kept). Drop placeholders and template commands. Delete the root file only after the migration is verified. Update the AGENTS.md pointer. | Reuses the procedure the project already has. |
| Step 3, new **3.4.2** | Check that `README.md` and `index.md` exist, that the five category folders exist, that no root `AGENT_LEARNINGS.md` remains, and that AGENTS.md mentions `project/learnings/index.md`. | Verification, like 3.4.1. |
| Complete Setup Checklist | Add: learnings directory and index created; AGENTS.md section present and pointing there; no root `AGENT_LEARNINGS.md` left. | Makes the work checkable. |

---

## 9. Risks and open questions

1. **The index is the only read-first surface.** If it grows, each session reads more. Mitigation: keep ACTIVE rows few. An agent can list them without reading the whole table: `grep '| ACTIVE' project/learnings/index.md`. Open question: should old NOTED rows move out of the index? Troubleshooting does not archive today, so the default is to keep the scheme as it is.
2. **Status discipline.** A stale ACTIVE row misleads. Mitigation: the promote and supersede steps in the README, and a review of ACTIVE rows at each consolidation.
3. **Agents skip the index.** The AGENTS.md section is a pointer, not an import. Importing `index.md` into CLAUDE.md or GEMINI.md would load the whole table into every session, which gets costly as the index grows. Recommendation: pointer only, and reconsider if agents are seen skipping it.
4. **Five categories.** Chosen to mirror troubleshooting's five categories. They are a judgment and can change after the first few entries.
5. **Who promotes.** Recommendation: the developer approves every move from ACTIVE into AGENTS.md or PROJECT.md. Agents propose; people decide.
6. **Overlap with troubleshooting.** A bug that needed debugging belongs in troubleshooting. The learning links to it and does not repeat it.

---

## 10. Decisions requested

| Decision | Recommendation |
|---|---|
| Use the troubleshooting scheme (README, index, category folders) | Yes, as directed. |
| Five categories: workflow, code, tooling, facts, communication | Yes. Adjust after the first entries. |
| Factor the workflow into `00-project-setup/11-agent-learnings.md` | Yes. 01 is already about 1,470 lines. |
| Add learnings to "Interpreting Update the Logs" as a third log | Yes, with its triggers (§8). |
| Pointer only in AGENTS.md, not an import in CLAUDE.md and GEMINI.md | Yes, first (§9.3). |

## 11. Proposed next steps (after approval)

1. Create `00-project-setup/11-agent-learnings.md` with the templates from §5, and make the 01 changes from §8 (with a Workflow-Scripts changelog entry).
2. Apply the result to NuBible-App as a plan: create `project/learnings/` with the README, index, and category folders; add the AGENTS.md section (§6) and the PROJECT.md line (§7). Keep AGENTS.md readable.
3. Confirm with a short session that an agent reads the index and follows an ACTIVE entry before a non-trivial task, and that a new mistake lands as an entry with an index row.
