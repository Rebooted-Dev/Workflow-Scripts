# Agent Learnings Index

Chronological index of agent learnings.
**Newest entries are listed first.**

| Date       | Category | Title | File | Status |
|-----------|----------|-------|------|--------|
| 2026-10-13 | workflow | Rules for the whole repo go in the root AGENTS.md | workflow/2026-10-13-workflow-nested-agents-read-only-in-folder.md | ACTIVE; put any rule that applies to the whole repo in the root AGENTS.md; a nested AGENTS.md is read only for work inside its folder |
| 2026-10-13 | workflow | Reuse the project's existing log scheme for agent-written logs | workflow/2026-10-13-workflow-reuse-existing-log-scheme.md | ACTIVE; for agent-written logs, reuse the index and category layout the project already has |
| 2026-10-13 | workflow | Splice verified text into docs instead of retyping it | workflow/2026-10-13-workflow-splice-verified-text.md | ACTIVE; copy scripts and templates from the verified source with awk or sed, then compare the copy with cmp |
| 2026-10-13 | workflow | Check a template's commands and rules against the project before adopting it | workflow/2026-10-13-workflow-check-template-against-project-docs.md | ACTIVE; before copying a template into AGENTS.md, check each command and rule against the project's docs and drop what is wrong or already covered |
| 2026-10-13 | workflow | Leave untracked drafts you did not write out of commits | workflow/2026-10-13-workflow-leave-others-drafts-untracked.md | ACTIVE; never stage an untracked file you did not write in this session; ask first |
| 2026-10-13 | workflow | Write temporary files to the session scratchpad | workflow/2026-10-13-workflow-use-scratchpad-for-temp-files.md | ACTIVE; scratch files go in the session scratchpad directory, never in /tmp |
| 2026-10-13 | workflow | In a changelog index, the File column names the entry | workflow/2026-10-13-workflow-changelog-file-column.md | ACTIVE; in index.md, File is the changelog entry path relative to the index folder; put any other artifact in Notes |
| 2026-10-13 | workflow | When asked to study and propose, do not change the target files | workflow/2026-10-13-workflow-propose-before-implementing.md | ACTIVE; when a request says study and file a proposal, file the proposal and leave the target files alone until told to implement |
| 2026-10-13 | tooling | check-meta-logs.sh needs a staged or ranged diff | tooling/2026-10-13-tooling-check-meta-logs-needs-staged-diff.md | ACTIVE; run check-meta-logs.sh --staged after git add, then git restore --staged to leave nothing committed |
| 2026-10-13 | tooling | macOS uses BSD userland, so GNU flags fail | tooling/2026-10-13-tooling-macos-bsd-userland.md | ACTIVE; use BSD forms: stat -f, od -c, sed -i with an empty suffix; not ls --time-style or cat -A |
| 2026-10-13 | tooling | check-plan --state passes a plan with no checkboxes | tooling/2026-10-13-tooling-check-plan-passes-without-checkboxes.md | ACTIVE; a passing check-plan --state does not show that AGENTS.md's checkbox rule is met; check the plan for checkboxes yourself |
| 2026-10-13 | tooling | Heading anchors drop punctuation, so Step 2.13 becomes step-213 | tooling/2026-10-13-tooling-heading-anchor-slugs.md | ACTIVE; to predict an anchor, lowercase the heading, drop . : ( ) and apostrophes, then turn spaces into hyphens |
| 2026-10-13 | tooling | Use four-backtick fences around templates that contain code blocks | tooling/2026-10-13-tooling-nested-fence-four-backticks.md | ACTIVE; when a Markdown template contains triple-backtick blocks, wrap it in a four-backtick fence |
| 2026-10-13 | tooling | Write private files back with cat, not mv, to keep their mode | tooling/2026-10-13-tooling-keep-file-mode-on-write-back.md | ACTIVE; to replace a private file's contents, write a temp file and cat it over the original so the mode stays |
| 2026-10-13 | facts | A project's statusLine replaces the user-level one | facts/2026-10-13-facts-project-statusline-replaces-user.md | ACTIVE; when a project is missing the cache line, check its .claude/settings*.json for a statusLine key |
| 2026-10-13 | facts | The cache line has not been confirmed in a live session | facts/2026-10-13-facts-statusline-live-check-pending.md | NOTED; the cache line is verified only with sample input until a new Claude Code session shows it |
