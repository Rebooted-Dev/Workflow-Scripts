# Revise Claude Code model-routing plan gates and migration rules
**Date:** 2026-09-28
**Type:** docs

---

## Summary

Revised the DRAFT Claude Code model-routing implementation plan to bound both research agents with the documented `Read, Grep, Glob` tool allowlist, add a pre-release scratch compatibility gate, and define safe per-file migration, warning-only frontmatter checks, and an idempotence fixture matrix. Narrowed fallback use to tested configurations, preserved the conditional normal pointer and token-efficiency routing policy, and corrected future implementation Task 10 to require a fixed changelog entry, workflow troubleshooting entry, and both indexes.

This was a plan-only revision: no setup workflow or templates were changed, and no scratch project, Claude Code session, or live compatibility test was run. No troubleshooting entry was created because this revision documents planned work and does not implement a workflow fix.
