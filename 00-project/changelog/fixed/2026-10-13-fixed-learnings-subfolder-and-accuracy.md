# Learnings: root-session check, accuracy rule, and a structural checker

**Date:** 2026-10-13
**Type:** fixed

---

## Summary
- Headless tests showed that rules did not load from a subfolder session. Added a root-session check (01 Step 3.6.1) and a checklist item. The workaround is to start sessions at the repo root.
- Learnings entries could state unsupported claims. Added an **Accuracy** section to the learnings README template (`11-agent-learnings.md`) and to both learnings READMEs.
- Added `scripts/validation/check-learnings.sh` and `check-learnings-selftest.sh`. The root AGENTS.md points to the checker.
- A later session found the cause of the subfolder failure (external-import approval) and added it, with test results and a proposed fix, as section 11 of `research/2026-10-13-agent-learnings-load-and-accuracy-report.md`. It also corrected the Root Cause in the troubleshooting entry and logged `learnings/facts/2026-10-13-facts-imports-outside-cwd-need-approval.md`. The fix itself is not applied.

**Troubleshooting:** [2026-10-13 entry](../../troubleshooting/workflow/2026-10-13-workflow-rules-not-loaded-from-subfolder.md)
