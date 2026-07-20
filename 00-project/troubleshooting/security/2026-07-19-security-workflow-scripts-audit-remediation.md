# Workflow-Scripts Audit Remediation
**Date:** 2026-07-19
**Category:** security
**Status:** RESOLVED

---

## Symptom

- A third-party system prompt was tracked in an active instruction directory.
- The embedded image library reported 11 npm vulnerabilities, including critical and high development-tool advisories.
- Validation scripts emitted a Node stack trace for malformed percent-encoded links and used trap definitions that triggered SC2064.
- Package tests could inherit developer API-key environment variables, allowing assertion failures to print credential values.

## Root Cause

- Repository inventories and validation gates did not cover instruction-surface provenance, dependency review, malformed URI decoding, deferred trap expansion, or test credential isolation.
- The embedded library had accumulated incompatible major-version gaps and lacked a working ESLint flat configuration.

## Fix

- Removed the prompt and references, upgraded dependencies in bounded slices, migrated AI SDK image generation to its stable API, and added current lint configuration.
- Added a Vitest setup that removes API-key variables before test modules load and restores them after the run.
- Converted cleanup traps to deferred expansion and converted URI decoding failures into normal broken-link diagnostics.
- Added CI and updated the documentation, branch, licensing, and package-maintenance records.

## Verification

- `npm audit` reports zero vulnerabilities; 107 unit tests, build, type-check, and lint pass.
- All five repository validation gates pass.
- A malformed `%ZZ` Markdown target exits non-zero with a concise diagnostic and no stack trace.
- Temp-directory instrumentation proves cleanup, and ShellCheck reports no SC2064.

## Notes / Lessons

- Unit suites that read environment configuration must clear credential variables before importing test modules, even on developer machines.
- Dependency upgrades should be verified slice by slice; current TypeScript-ESLint compatibility requires TypeScript 5.9.x until its declared range includes TypeScript 7.
