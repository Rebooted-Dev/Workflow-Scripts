# Agent learnings: rules did not load from subfolder sessions, and entries made unsupported claims

**Date:** 2026-10-13
**Status:** Implemented on 2026-10-13 (third session, goal run; see section 12). Open items are listed there. The subfolder failure is Claude Code's external-import approval rule, reproduced with canary files. The proposed fix is a `CLAUDE.md` symlink to `AGENTS.md` in place of the `@AGENTS.md` import. The root-start workaround stays in force until the fix is applied.
**Question investigated:** Does the agent learnings system work for NuBible-App and for Workflow-Scripts? What failed, and what has been done about it?
**Method:** Structural checks on both learnings logs and on a sandbox replica of the project layout. Headless `claude -p` sessions, read-only and one write test, started at repo roots and at subfolders. Inspection of the repo files involved. Changes described in section 6.
**Related:** [`../changelog/fixed/2026-10-13-fixed-learnings-subfolder-and-accuracy.md`](../changelog/fixed/2026-10-13-fixed-learnings-subfolder-and-accuracy.md), [`../troubleshooting/workflow/2026-10-13-workflow-rules-not-loaded-from-subfolder.md`](../troubleshooting/workflow/2026-10-13-workflow-rules-not-loaded-from-subfolder.md), [`../plans/agents-patches/agent-learnings-proposal.md`](../plans/agents-patches/agent-learnings-proposal.md), [`../../00-project-setup/11-agent-learnings.md`](../../00-project-setup/11-agent-learnings.md).

---

## 1. Summary

The learnings system has two parts. An agent should read the index and follow the entries marked ACTIVE. It should record new lessons as entries. The test showed:

- **Loading the rules works from a repo root.** In NuBible-App and in Workflow-Scripts, a headless session started at the root quoted the Agent Learnings section, which it could only have got from `AGENTS.md`.
- **Loading the rules fails from a subfolder.** A headless session started in `Workflow-Scripts/00-project-setup/`, or in NuBible-App's `docs/agents/`, did not load the rules. The root `CLAUDE.md` showed only its `@AGENTS.md` line. The same failure occurred with an explicit `@../../AGENTS.md` import and with `--add-dir` in a sandbox.
- **Writing a lesson works structurally, but the content was not checked.** In a sandbox replica, the agent read the seeded ACTIVE rule, did the task, and wrote a correctly named entry with a correct index row. The entry also claimed the developer had confirmed something and that the agent had failed to follow a rule. Neither was in the prompt.

Changes were made to the workflow, the checker, the logs, and the records. Nothing has been committed by this work.

**Follow-up (section 11):** a second session found the cause of the subfolder failure and tested fixes. An `@` import whose target lies outside the session's working directory is an *external import*. Claude Code loads it only after a one-time approval dialog, and a headless session never shows that dialog, so the import is dropped without a message. From a subfolder, the root `AGENTS.md` is outside the working directory. Replacing the import with a `CLAUDE.md` symlink to `AGENTS.md` loaded the rules from the root, from a subfolder, and from a host project that adds the repo with `--add-dir`.

---

## 2. How the system is meant to work

1. `CLAUDE.md` (root of each repo) contains `@AGENTS.md`, which imports the project's agent rules into the session.
2. `AGENTS.md` has an **Agent Learnings** section. It says to read `<log>/index.md` before non-trivial work and to follow each entry marked `ACTIVE`. It also says to record mistakes, corrections, and verified facts as entries, with a row at the top of the index.
3. The log is `project/learnings/` in NuBible-App and `00-project/learnings/` in Workflow-Scripts. Both use the scheme from `00-project-setup/11-agent-learnings.md`: a README, an `index.md` with a Status column (newest first), five category folders, and one file per entry.

Step 2 depends on step 1. If step 1 fails, the rule never reaches the agent.

---

## 3. The problems

### 3.1 Rules did not load from a subfolder session

Observed in headless sessions (`claude -p`, read-only tools):

| Start directory | Quoted the Agent Learnings section? | What the session reported |
|---|---|---|
| NuBible-App root | Yes | Quoted from `AGENTS.md` through `CLAUDE.md` |
| Workflow-Scripts root | Yes (before and after the later changes) | Quoted from `AGENTS.md` through `CLAUDE.md` |
| `Workflow-Scripts/00-project-setup/` | **No** | "The only project instruction text I have is … `CLAUDE.md`, and its content is a single import line, `@AGENTS.md`. The imported file wasn't expanded into my context." |
| NuBible-App `docs/agents/` | **No** | `CLAUDE.md` had only the import line; `AGENTS.md` and `PROJECT.md` were "only import lines" in context |
| Sandbox `docs/agents/`, with `CLAUDE.md` containing `@../../AGENTS.md` | **No** | Import line only |
| Sandbox `docs/agents/`, started with `--add-dir` on the sandbox root | **No** | Import line only |

The failed sessions could see that the ancestor `CLAUDE.md` existed. They did not get the body of the imported file.

**Cause (established in the second session, section 11.2):** the import is treated as external. Claude Code's memory documentation says: "An import in a project-level memory file is external when its path resolves outside your working directory … The first time Claude Code encounters external imports in a project, it shows an approval dialog listing the files." A session started in a subfolder has that subfolder as its working directory, so `<root>/AGENTS.md` is outside it. Headless sessions show no dialog, and the import is skipped. This also explains the two sandbox results: `@../../AGENTS.md` points at the same outside file, and `--add-dir` grants file access but does not change the working directory.

*The original text of this paragraph said the cause was not established.*

**Impact:** every AGENTS.md rule is affected, not just the learnings rule. Any session started below the root, in either repo, would miss the Plans rule, the Change Management rule, and the rest.

### 3.2 Entries could state claims the session did not contain

In a sandbox replica, the agent was asked to record a correction the developer had given in the prompt. The entry it wrote contained these statements:

- *"Confirmed by the developer's correction."*
- *"The rule was already written in the README and index header before this correction. This entry records that I failed to follow it."*

The prompt said neither thing. The session had no earlier failure. The entry was therefore partly fabricated. The checker passes it, because the checker tests format and not content.

**Impact:** an entry can be well formed and still misleading. Once read at session start, it could steer later work with claims nobody made.

### 3.3 Errors made during the testing itself

These are recorded so the test results can be judged properly.

- **Headless flags:** the first attempts put the prompt after `--allowedTools`. That flag takes a variable number of arguments, so it consumed the prompt and every run failed before starting. The fix was to put the prompt directly after `-p`.
- **API credit:** the shell has `ANTHROPIC_API_KEY` set, and its credit was exhausted. Runs failed with "Credit balance is too low". The fix was `env -u ANTHROPIC_API_KEY` for those subprocesses only. The shell was not changed. About eleven headless sessions completed in total, using the logged-in account.
- **Sandbox scaffolding:** my construction of the sandbox index duplicated the header row. The first validator did not check for duplicate headers, so it did not catch this. The agent in the sandbox noticed it. I fixed the sandbox and added a duplicate-header check to the checker.
- **A misreading:** I first believed the NuBible-App learnings log was empty. The structural check then found one entry. It was written at 22:33 by another agent session, not by this session. The entry is in the right format and is marked NOTED. It is untracked and has not been committed.

---

## 4. Tests run and results

| # | Test | Setup | Result |
|---|---|---|---|
| 1 | Structure, NuBible-App | Structural checker on `project/learnings/` | Pass: 1 row, 1 entry (the other session's entry) |
| 2 | Structure, Workflow-Scripts | Checker on `00-project/learnings/` | Pass: 16 entries at the first run, 18 after the later additions |
| 3 | Structure, sandbox | Checker on the replica | Fail on duplicate header (my scaffolding), then pass after the fix |
| 4 | Discovery, NuBible root | Headless, read-only, "quote the section" | Pass |
| 5 | Discovery, Workflow-Scripts root | Same | Pass |
| 6 | Discovery, `00-project-setup/` | Same | **Fail** (section 3.1) |
| 7 | Discovery, NuBible `docs/agents/` | Same | **Fail** (section 3.1) |
| 8 | Index read, Workflow-Scripts root | Count the ACTIVE rows, name the first | Pass: 15 counted, matching the index at that time. The first named file was the newest entry. |
| 9 | Subfolder, explicit import (sandbox) | `docs/agents/CLAUDE.md` with `@../../AGENTS.md` | **Fail** |
| 10 | Subfolder, `--add-dir` (sandbox) | Start in `docs/agents/`, add the root | **Fail** |
| 11 | Write loop (sandbox, from root) | Seeded ACTIVE tooling rule; task plus correction | Read and quoted the rule: pass. Created `notes/summary.txt`: pass. Entry in the right folder, correct name, sections, index row on top: pass. Entry claims not in the prompt: **fail** (section 3.2). |
| 12 | Checker selftest after the changes | Eight failure cases on a throwaway tree | Pass (all eight produced their expected message) |
| 13 | Checker after the changes | Both real logs | Pass: Workflow-Scripts 18 entries, NuBible-App 1 entry |
| 14 | Link check and meta-log check | Staged logging files (then unstaged) | Pass |
| 15 | Headless root quote after the changes | Workflow-Scripts root | Pass, and the quoted section includes the new checker bullet |

---

## 5. Evidence (excerpts)

Test 6, from the `00-project-setup/` session:

> The only project instruction text I have is `/Users/jesse/Development/Shared-Common-Library/Workflow-Scripts/CLAUDE.md`, and its content is a single import line, `@AGENTS.md`. The imported file wasn't expanded into my context.

Test 10, sandbox subfolder with `--add-dir`:

> The two CLAUDE.md files I have contain only import lines: `@AGENTS.md` in `sandbox/CLAUDE.md`, and `@../../AGENTS.md` in `sandbox/docs/agents/CLAUDE.md`. Both point to `sandbox/AGENTS.md`, but that file's text isn't in my context.

Test 11, the sandbox entry (excerpts):

> ## Verification
> - Confirmed by the developer's correction.
> ## Notes
> - The rule was already written in the README and index header before this correction. This entry records that I failed to follow it.

Test 8, the index read, named the newest entry first, which matches the index's ordering rule.

The scratchpad holds the full transcripts for these tests (`disc-*.txt`, `diag-*.txt`, `sub-*.txt`, `write-sandbox.txt`). The sandbox is session-scoped and is not kept.

---

## 6. What was done

### 6.1 Before this round (same session)

- The Agent Learnings rule was moved from `00-project/AGENTS.md` to the root `AGENTS.md`, because root `CLAUDE.md` imports only the root file. `00-project/AGENTS.md` keeps a one-line pointer. This is recorded in `troubleshooting/workflow/2026-10-13-workflow-learnings-rule-only-in-nested-agents.md` and `changelog/fixed/2026-10-13-fixed-agent-learnings-rule-in-root-agents.md`.

### 6.2 This round

These follow the recommendations the developer accepted: start sessions at the root, add an accuracy rule, and add the checker to `scripts/validation`.

- **`00-project-setup/01-setup-project.md`:** new Step 3.6.1, a headless check that the rules load from the repo root, with the command and the expected result. It also notes that an interactive check is still needed. Added a checklist item for it.
- **`00-project-setup/11-agent-learnings.md`:** an **Accuracy** section in the README template, with three rules: write only what happened and cite the source; do not claim confirmation the conversation does not show; do not claim a mistake the session does not show. Step 6 now runs the checker.
- **Both learnings READMEs** (Workflow-Scripts and NuBible-App) were regenerated from file 11. The only difference is the Accuracy section.
- **`scripts/validation/check-learnings.sh`** (new): checks one header row; newest-first rows; valid categories; the file exists and sits in the category folder; the status is valid; ACTIVE rows have rule text; the entry's Status and Category match its row; required sections; file-name pattern; no orphan entries; and the row count matches the entry count. It defaults to `00-project/learnings`.
- **`scripts/validation/check-learnings-selftest.sh`** (new): builds a throwaway tree and checks eight failures: duplicate header, rows out of order, status mismatch, orphan entry, category mismatch with folder, missing section, ACTIVE without rule text, and bad file name.
- **Root `AGENTS.md`:** one bullet under Agent Learnings pointing to the checker and its selftest.
- **Learnings log (Workflow-Scripts):** two ACTIVE entries, `workflow/2026-10-13-workflow-start-sessions-at-repo-root.md` and `workflow/2026-10-13-workflow-log-only-what-happened.md`. Index rows added at the top.
- **Troubleshooting:** `troubleshooting/workflow/2026-10-13-workflow-rules-not-loaded-from-subfolder.md`, with status *workaround; interactive check open*. Index row added.
- **Changelog:** `changelog/fixed/2026-10-13-fixed-learnings-subfolder-and-accuracy.md`, linked to the troubleshooting entry. Index row added.
- **NuBible-App:** only the learnings README changed (the Accuracy section). Nothing else in NuBible-App was changed by this round.

---

## 7. Verification of the changes

- Selftest: all eight cases pass.
- Checker: passes on the Workflow-Scripts log (18 entries) and on the NuBible-App log (1 entry).
- Link check: passes.
- Meta-log check on the staged logging files: passes. The files were then unstaged.
- Headless root session after the changes: still quotes the Agent Learnings section, including the new checker bullet.

What these checks do **not** show:

- They do not show that the subfolder problem is fixed. Only the workaround is documented.
- They do not show that an entry's claims are true. The checker tests format, and the Accuracy rule is text that agents must follow.
- The interactive behaviour is untested.

---

## 8. Open items

1. **Interactive check.** Still open, but narrower. The documentation says an interactive session shows the approval dialog the first time it meets an external import, so an interactive subfolder session should ask once per start directory. This needs the developer; the agent cannot run it. It stops mattering once the symlink fix is applied, because no import is left to approve.
2. **Subfolder cause.** Closed: see section 11.2. The troubleshooting entry moves to `resolved` when the fix in section 11.4 is applied and its checks pass.
3. **NuBible-App's AGENTS.md** has no note about starting sessions at the root. With the symlink fix the note is not needed, because the rules load from any start directory. Until then the gap remains.
4. **Content review.** The Accuracy rule is text only. Decide whether ACTIVE entries need a human review before they steer work.
5. **Pre-commit coverage.** `check-learnings.sh` is a manual script. `check-meta-logs` does not check the learnings log, and the pre-commit hook does not run the checker. Decide whether it should.
6. **Entries from other sessions.** The NuBible-App learnings entry (written at 22:33 by another session) is untracked. Decide whether it is committed.
7. **`patch-info.md`.** Commit `fc079d3` (made by another session) tracked the unreviewed draft `00-project/plans/agents-patches/patch-info.md`. The draft is now in history. Decide whether to keep it, and whether the agents-patches folder should hold drafts that are not ours.

---

## 9. Reproduction

**Start a headless session, read-only (run from the repo root, or from a subfolder to see the failure):**

```bash
cd <directory>
env -u ANTHROPIC_API_KEY claude -p "Do not read any files. From your loaded instructions only: quote the bullets under the 'Agent Learnings' heading verbatim, and name the file they came from." --output-format text --allowedTools "Read,Glob,Grep"
```

Keep the prompt directly after `-p`. Flags that take several values, such as `--allowedTools`, must come after it.

**Structural checks:**

```bash
bash scripts/validation/check-learnings.sh [DIR]     # DIR defaults to 00-project/learnings
bash scripts/validation/check-learnings-selftest.sh
```

**Sandbox replica:** copy the NuBible-App layout (`project/learnings/` with README, index, and the category folders), add a `CLAUDE.md` containing `@AGENTS.md`, and copy the Agent Learnings section into `AGENTS.md`. Seed one ACTIVE entry and its index row. Run the write test from the sandbox root with `--permission-mode acceptEdits --allowedTools "Read,Write,Edit,Glob,Grep"`.

---

## 10. Commit state

Workflow-Scripts, branch `v1.82`:

- Commits made earlier in this session: `e325235` (cache setup), `1e657ba` (learnings log and root rule).
- Commit `fc079d3` was made by another session and is not part of this work.
- Uncommitted from this work: modified `00-project-setup/01-setup-project.md`, `00-project-setup/11-agent-learnings.md`, `AGENTS.md`, `00-project/changelog/index.md`, `00-project/learnings/README.md`, `00-project/learnings/index.md`, and `00-project/troubleshooting/index.md`. New: the two learnings entries, the troubleshooting entry, the fixed changelog entry, and `scripts/validation/check-learnings.sh` and its selftest. This report is also new.

NuBible-App: uncommitted changes from the learnings setup (`AGENTS.md`, `PROJECT.md`, `docs/agents/changelog-and-troubleshooting.md`, `project/changelog/index.md`, the setup changelog entry, and the `project/learnings/` directory). Its other modified files come from other work and were not touched here.

---

## 11. Follow-up investigation and proposed solution (second session, 2026-10-13)

This section was added by a later session that was asked to study the report, investigate, and propose a solution. That session changed no workflow file, rule file, or `CLAUDE.md`. It edited this report, corrected the cause in the troubleshooting entry, and logged one learnings entry.

### 11.1 Method

- Read Claude Code's memory documentation (`https://code.claude.com/docs/en/memory`), sections *Import additional files*, *Load from additional directories*, *Share rules across projects with symlinks*, and *AGENTS.md*.
- Built eleven small git repositories in the session scratchpad. Each instruction file held a unique canary string, for example `CANARY-AGENTS-V1`. A headless session was asked to list every canary in its loaded context without using tools. A canary is either present or absent, so the result does not depend on the model describing its own context.
- Command, run from the repo root and from `sub/deep/`:

  ```bash
  env -u ANTHROPIC_API_KEY claude -p "Do not use any tools. List every token of the form CANARY-<something> that appears anywhere in your loaded instructions or context. Output only the tokens, one per line, or NONE." --model haiku --output-format text </dev/null
  ```

- Claude Code version 2.1.296. About twenty headless sessions, nearly all on the small model.
- An attempt to read the approval logic out of the installed binary was blocked by the permission system and was not retried. The cause therefore rests on the documentation plus the canary results, not on the source code.

### 11.2 Cause

The documentation states the rule quoted in section 3.1. It adds two points that matter here:

- For an `AGENTS.md` that Claude Code reads directly, an import of a file outside the working directory "loads only if you already approved external imports for this project, with no prompt".
- A symlink in `.claude/rules/` whose target is outside the working directory is treated "like an external import".

The approval is stored per start directory. `~/.claude.json` holds a `hasClaudeMdExternalIncludesApproved` flag under each project path; the entry for the NuBible-App root is `false`. Approving once in an interactive subfolder session would therefore cover only that one subfolder.

The same rule was visible in the investigating session itself. It started at the NuBible-App root, where the root `CLAUDE.md` imports arrived expanded. When its working directory moved into Workflow-Scripts, that repo's `CLAUDE.md` arrived as the single unexpanded line `@AGENTS.md`.

### 11.3 Test results

"Root" means the session started at the repo root. "Sub" means it started in `sub/deep/`. "Add-dir" means it started in an unrelated repo with `--add-dir <repo>` and `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1`.

| # | Layout at the repo root | Root | Sub | Add-dir |
|---|---|---|---|---|
| V1 | `CLAUDE.md` = `@AGENTS.md` (the current layout) | Loaded | **Not loaded** | **Not loaded** |
| V2 | `AGENTS.md` only, no `CLAUDE.md` | not run | Loaded | **Not loaded** |
| V3 | `CLAUDE.md` is a symlink to `AGENTS.md` | not run | Loaded | Loaded |
| V4 | `AGENTS.md` only, and it contains `@PROJECT.md` | Both loaded | `AGENTS.md` loaded, `PROJECT.md` **not** | not run |
| V5 | `CLAUDE.md` with inline text, plus a real file in `.claude/rules/` | not run | Both loaded | not run |
| V6 | V1 plus a `SessionStart` hook in the root `.claude/settings.json` that prints `AGENTS.md` | not run | **Not loaded** | not run |
| V7 | V1 plus a sentence in `CLAUDE.md` telling the agent to read the two files if only the import lines are visible (Read tool allowed) | not run | Loaded by reading, on the small model and on the default model | not run |
| V9 | `.claude/rules/project.md` is a symlink to `../../PROJECT.md` | Loaded | **Not loaded** | not run |
| V10 | `CLAUDE.md` symlink to `AGENTS.md`; real file `.claude/rules/project.md`; `PROJECT.md` is a symlink to it | Both loaded | Both loaded | not run |
| V11 | `CLAUDE.md` symlink to `AGENTS.md`; `AGENTS.md` contains `@PROJECT.md` and a sentence saying to read `PROJECT.md` | Both loaded | `AGENTS.md` loaded. `PROJECT.md` not loaded without tools; read by the agent when Read was allowed | `AGENTS.md` loaded |

What the results show:

- V1 reproduces section 3.1 with canaries.
- Content that sits in the instruction file itself, or that is reached through a `CLAUDE.md` symlink, loads from every start directory tested (V3, V5, V10, V11). Content reached through an `@` import, or through a `.claude/rules/` symlink, loads only when the target is inside the working directory (V1, V4, V9).
- Deleting `CLAUDE.md` so that `AGENTS.md` is read directly fixes the subfolder case (V2) but not the add-dir case, which is how a host project reaches Workflow-Scripts.
- V6 is inconclusive. The hook did not run, and the reason was not investigated. A project-level hook is not a candidate fix on this evidence.
- V7 and the `PROJECT.md` half of V11 depend on the agent choosing to read a file. They worked in three runs out of three. That is a small sample.

### 11.4 Proposed solution for the loading problem

The rule that follows from 11.3: **no agent rule may reach Claude Code through an `@` import.** Rules must be in the file Claude Code loads, or behind a `CLAUDE.md` symlink.

**Workflow-Scripts**

1. Replace the root `CLAUDE.md` (its whole content is `@AGENTS.md`) with a symlink: `ln -sf AGENTS.md CLAUDE.md`. This is layout V3. It loads from the root, from subfolders, and from a host project with add-dir.

**Consumer projects (NuBible-App, and the template in `00-project-setup/01-setup-project.md` Step 2.10)**

The current `CLAUDE.md` holds two imports and a Claude-only *Agent skills* block. Proposed layout, which is V11 plus V5:

1. `CLAUDE.md` becomes a symlink to `AGENTS.md`.
2. The Claude-only content moves to a real file, `.claude/rules/claude-code.md`. A real file in the root `.claude/rules/` loaded from a subfolder in V5.
3. `AGENTS.md` keeps its sentence "Read `PROJECT.md` before starting work" and gains a line `@PROJECT.md`. Root sessions then get `PROJECT.md` loaded for certain, as they do today. Subfolder sessions get the rules for certain and are told in words to read the facts.
4. If the project facts must also load for certain from a subfolder, use layout V10 instead of step 3: the real file lives at `.claude/rules/project.md` and `PROJECT.md` is a symlink to it. This costs an odd home for the facts file, so it is the stricter option and not the default.

**Workflow changes that go with it**

- `01-setup-project.md`: rewrite Step 2.10 (thin `CLAUDE.md`) and the Step 1.1 table for the symlink layout. Extend Step 3.6.1 to run the headless check from a subfolder as well as from the root. Six other files mention the `@AGENTS.md` import and need the same wording change: `04-track-repos-and-agent-map.md`, `07-migrate-project-structure.md`, `skills/02-project-scan.md`, `skills/03-project-scaffold.md`, `skills/stubs/claude-agent-skills-block.md`, and `03-debugging/02-bug-fix-workflow.md`.
- Add a canary check to `scripts/validation/`: write a temporary canary line into `AGENTS.md`, run the headless command from a subfolder, and restore the file. This turns Step 3.6.1 into a pass or fail result.
- When the fix is in: mark the learnings entry `workflow/2026-10-13-workflow-start-sessions-at-repo-root.md` as `SUPERSEDED`, and move the troubleshooting entry to `resolved`.

**Costs and limits of the symlink**

- The Edit and Write tools refuse to write through a symlink. Agents must edit `AGENTS.md`, not `CLAUDE.md`.
- Git on Windows checks a symlink out as a one-line text file unless `core.symlinks` is on. All current clones are on macOS.
- The results come from one Claude Code version (2.1.296) and from throwaway repos, not from the two real repos. The first step of implementation is to rerun V3 and V11 in the real repos.
- `GEMINI.md` uses the same thin import form. Gemini's import handling was not tested.

**Rejected alternatives**

- *Approve the dialog once.* The approval is per start directory and needs an interactive session, so it cannot cover headless runs or every subfolder.
- *Delete `CLAUDE.md` and rely on direct `AGENTS.md` reading.* It fails with add-dir (V2), needs version 2.1.277 or later, and leaves no place for the import of `PROJECT.md`.
- *Keep the imports and add a fallback sentence* (V7). It worked, but every rule would then depend on the agent choosing to read a file. It is acceptable for facts and too weak for rules.

### 11.5 Proposed solution for the accuracy problem

This part is analysis and proposal. The write test from section 3.2 was not rerun, so none of it is verified.

A likely contributor to the fabricated lines is the entry template. It has five sections, and `check-learnings.sh` fails an entry that lacks any of them. The *Verification* prompt offers "user confirmation" as an example, and *Pattern to avoid* asks "what was done". An agent recording a plain correction has no true content for those slots and no permitted way to leave them empty. The two fabricated lines in test 11 sat in exactly such slots, *Verification* and *Notes*.

Proposed changes, in order of value:

1. **Let a section say nothing.** In the template in `11-agent-learnings.md`, state that a section with no content from the session is written as `- None.` Remove "user confirmation" from the *Verification* prompt.
2. **Make the source a field.** Add a header line `**Source:**` with one of `developer message`, `command`, `file`, or `unverified`, followed by the quoted message, the command and its result, or the path. Have `check-learnings.sh` fail an entry without it, and fail an `ACTIVE` row whose source is `unverified`. The checker still cannot test truth, but a named source can be checked by a reader in seconds.
3. **Gate ACTIVE on the developer.** Agents write new entries as `NOTED`. An entry becomes `ACTIVE` only when the developer says so, recorded as `**Approved:** <date>`, and the checker requires that field on `ACTIVE` rows. This answers open item 4. The eighteen existing Workflow-Scripts entries would need one review pass, since seventeen of them are already `ACTIVE`.
4. **Run the checker before commit.** Have the pre-commit hook run `check-learnings.sh` when a staged path is under the learnings folder. This answers open item 5.
5. **Retest.** Rerun test 11 several times with the old and the new template and compare the entries against the prompt. One run cannot show that the change works.

### 11.6 What is still open after this section

- Nothing in 11.4 or 11.5 is implemented. Both need the developer's decision.
- The choice between step 3 and step 4 in 11.4 for `PROJECT.md`.
- Whether `ACTIVE` should need developer approval (11.5, item 3).
- Open items 6 and 7 in section 8 are unchanged.

## 12. Implementation (third session, 2026-10-13)

The developer chose the recommendations in the session before this one: `PROJECT.md` through `@PROJECT.md` in `AGENTS.md` (option A), `ACTIVE` gated on developer approval, both repos in one pass, `GEMINI.md` left as an import, and local commits without a push.

**Verified in the real repos (headless; the installed Claude Code version was not checked):**
- Workflow-Scripts, session in `00-project-setup/`. Before: the rules were not loaded (`NONE`). After `CLAUDE.md` became a symlink: the Agent Learnings bullets were quoted from `CLAUDE.md`.
- NuBible-App, session in `docs/agents/`. The Agent Learnings bullets loaded. `PROJECT.md` did not load without a Read, which is the trade-off accepted under option A.
- `scripts/validation/check-agent-rules-load.sh` passes on both repos. Run against the old `@AGENTS.md` layout, it fails.
- The Edit tool refuses to write through a symlink and names the target path.
- Write test (proposal step 5): two headless runs per template, `haiku`, the test 11 setup with a developer correction in the prompt and no claim of confirmation or failure. Old template (the README from `fc079d3`): both entries were written `ACTIVE` with no approval, and neither invented a confirmation or a failure. New template: both entries are `NOTED`, the `Source` line quotes the developer's message, `Notes` is `- None.`, and the checker passes. The old template did not reproduce the test 11 fabrication in this sample, so the sample cannot show that the fabrication is fixed. What it does show is the status and source gating.

**Changed:**
- Workflow-Scripts: `CLAUDE.md` symlink; `check-agent-rules-load.sh` (new); `check-learnings.sh` and its selftest check `**Source:**` and `**Approved:**`; the pre-commit hook runs the learnings check; the learnings template and both READMEs; the learnings entries (15 ACTIVE demoted to NOTED, one SUPERSEDED, three new NOTED); the setup docs. The report's list of six files was incomplete. A grep found about fifteen. The setup doc changes are the 01, 04, 07, 08, 03-debugging and skills files.
- NuBible-App (commit `8046ef8`): `CLAUDE.md` symlink; `.claude/rules/claude-code.md`; `@PROJECT.md` in `AGENTS.md`; changelog and troubleshooting entries.

**Not verified, or open:**
- An interactive session in a subfolder has not been run. The headless canary is the automated check.
- `/setup-matt-pocock-skills` (outside these repos) writes its `## Agent skills` block to `CLAUDE.md` when that file exists. With the symlink, that block would land in the shared `AGENTS.md`. The external skill has not been changed.
- `GEMINI.md` keeps the import form and has not been tested from a subfolder.
- Under option A, a subfolder session reads `PROJECT.md` only when it reads the file.
- NuBible-App `project/learnings/workflow/2026-10-13-workflow-read-learning-index-before-work.md` is another session's untracked entry. It has no `**Source:**` line, so `check-learnings.sh` fails on that project's log until its author fixes it. It was left unchanged (open item 6).

