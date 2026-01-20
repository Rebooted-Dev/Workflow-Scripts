# Changelog

All notable changes to this repository are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- 2026-01-20: Renamed workflow mapping in README.md - swapped Implementation Plan and Plan Review file references to match actual workflow titles and purposes
- 2026-01-20: Fixed planning workflow file titles to match their actual purpose (Plan Review vs Implementation Plan)
- 2026-01-20: Updated parallel-agents-review.md to reference correct workflow file paths
- 2026-01-20: Fixed bug-description workflow to reference correct bug-fix workflow filename
- 2026-01-20: Added "historical note" status to filename-review.md to prevent confusion from stale structure references

### Changed
- 2026-01-20: Unified repository model in SHARING_AND_SYNC.md - nested repo model is now recommended, with git submodule as an advanced alternative
- 2026-01-20: Standardized documentation paths - workflows now point to `docs/CHANGELOG.md` (preferred) or `CHANGELOG.md`
- 2026-01-20: Standardized troubleshooting paths - workflows now point to `troubleshooting/<category>/...` and `troubleshooting/index.md`
- 2026-01-20: Standardized output paths - reports now saved to `plans/` (project root) instead of `../../plans/`
- 2026-01-20: Unified timestamp format - changelog entries now use `- YYYY-MM-DD: Description` (date-only), reports use `YYYY-MM-DD HH:MM` in headers
- 2026-01-20: Normalized terminology - replaced "timestamp" with "dated" where appropriate across all workflow documents
- 2026-01-20: Updated README.md to clarify workflows are for "host project" not specifically "Info-Visualizer"
- 2026-01-20: Added missing category listing in README.md to fix "seven categories" count

### Added
- 2026-01-20: Added comprehensive confirm-execution workflow with verification criteria and marking convention (`- [x]` / `- [ ]`)
- 2026-01-20: Added "seven categories" enumeration including `00-meta/` in README.md
- 2026-01-20: Added helper script documentation to README.md with corrected descriptions

### Deprecated
- 2026-01-20: Removed Option B from SHARING_AND_SYNC.md - the mixed submodule/copy approach was mechanically incorrect and confusing

### Removed
- 2026-01-20: Removed references to `../../TROUBLESHOOTING.md` as canonical troubleshooting target
- 2026-01-20: Removed misleading relative paths (`../../plans/`, `../../docs/`) from workflow instructions
- 2026-01-20: Removed emoji task list examples (`✅` / `⏳`) from execution workflow

### Security
- 2026-01-20: Updated helper scripts to detect detached HEAD state and refuse pull if repo has uncommitted changes
- 2026-01-20: Removed dangerous `git submodule update --remote` as default recommendation in SHARING_AND_SYNC.md

### Refactor
- 2026-01-20: Rewrote pull-workflows.sh to properly handle nested repo model (ff-only, dirty-check, detached HEAD handling)
- 2026-01-20: Rewrote update-workflows.sh to be a maintainer-only helper that commits staged changes and pushes (no parent repo interaction)
- 2026-01-20: Replaced misleading submodule assumptions in helper scripts with explicit nested-repo behavior
- 2026-01-20: Rewrote SHARING_AND_SYNC.md to clearly document nested repo model with safe update procedures
