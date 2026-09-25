# Size planning and code-build agent use
**Date:** 2026-09-25
**Type:** fixed

---

## Summary
- Replaced rigid planning/build agent rosters with applicability-sized delegation and role menus, removed the prohibited wording, and linked parallel-agent guidance to `workflow-applicability.md`.
- Added the Phase A planning/build policy validator, negative fixtures/self-test, and CI steps to prevent the wording and applicability-link defects from returning.

## Verification
- Parent reports the planning/build policy validator and self-test passed, and `rg 'aggressively|librarian agents'` over planning/build returned no matches.

## Related
- Troubleshooting: [Planning/build agent sizing](../../troubleshooting/workflow/2026-09-25-workflow-planning-build-agent-sizing.md)
