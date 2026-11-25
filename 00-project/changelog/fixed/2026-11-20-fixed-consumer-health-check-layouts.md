# Support external repositories and centralized skills docs in consumer health checks
**Date:** 2026-11-20
**Type:** fixed

---

## Summary
- Recognize a verified external `../` Workflow-Scripts repository without requiring an ignore rule, while retaining in-repository ignore and repair safeguards.
- Accept all three skills docs together in either supported agents-docs layout. Explain the limited scope of the rules-load canary.
- Preserve empty agent-learning categories in Git using placeholders in the setup instructions.

## Verification
- `bash scripts/validation/health-check-selftest.sh` passes, including external, invalid, traversal, mixed-layout, and repair-boundary fixtures.
- ShellCheck passes for the health-check and self-test. Live-Feedback consumer health check reports 13 PASS, 0 WARN, 0 FAIL; its H12 canary was not run.

## Related
- See `00-project/troubleshooting/workflow/2026-11-20-workflow-consumer-health-check-layouts.md` and the Live-Feedback `project/research/2026-11-20-agent-learnings-setup-report.md` follow-up.
