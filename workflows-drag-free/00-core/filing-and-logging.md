---
id: filing-and-logging
kind: policy
status: active
---

# Filing and Logging Policy

- File active plans in `<metadata-root>/plans/` and generated review or research reports in `<metadata-root>/research/`.
- Every code or workflow change gets a typed changelog entry and a newest-first row in `<metadata-root>/changelog/index.md`.
- Bugs and non-trivial fixes also get a troubleshooting entry and newest-first index row.
- File a verified completed plan under `<metadata-root>/plans-completed/<category>/`; update its index and add a Type=`plan` changelog row.
- Preserve historical records and use repository-local naming and templates.
