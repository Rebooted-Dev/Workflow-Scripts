# Consumer health check rejected valid layouts and empty categories were not durable
**Date:** 2026-11-20
**Category:** workflow
**Status:** RESOLVED

---

## Symptom
- Live-Feedback's consumer health check failed H02/H03 for an external shared repository and warned H13 for its centralized skills docs, despite those resources existing. Empty learning-category directories also would not survive a Git checkout.

## Root Cause
- The checker rejected all parent-relative repository paths, required an ignore rule even for an external checkout, and hardcoded the root docs layout. Setup created empty directories, which Git does not track.

## Fix
- Verify a single-leading-parent path resolves outside the consumer and is its own Git root; do not offer ignore repair for external paths. Accept either complete skills-docs layout.
- Add empty-category placeholders to the setup procedure and explain the scope of H09 repair and the H12 canary.

## Verification
- The consumer health check reports 13 PASS, 0 WARN, 0 FAIL, without H12. The health-check self-test and ShellCheck pass; a disposable Git tree export retains all five Live-Feedback learning categories.

## Notes / Lessons
- The real Claude subfolder session and optional machine-specific status-line checks are separate from the automated health-check result. See the Live-Feedback `project/research/2026-11-20-agent-learnings-setup-report.md`.
