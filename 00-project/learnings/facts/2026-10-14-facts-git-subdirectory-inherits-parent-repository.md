# `git -C` can resolve an ancestor repository for a subdirectory

**Date:** 2026-10-14
**Category:** facts
**Status:** NOTED
**Source:** command: `git -C scripts/validation/fixtures/health-check/healthy/Workflow-Scripts rev-parse --show-toplevel` returned the Workflow-Scripts root; `--show-prefix` returned `scripts/validation/fixtures/health-check/healthy/Workflow-Scripts/`

---

## Situation
- The health-check's nested-repository fixture is a directory inside the current Workflow-Scripts checkout without its own `.git` directory.

## Pattern to avoid
- Treating a successful `git -C <path> rev-parse --show-toplevel` as proof that `<path>` itself is a repository root.

## Better approach
- Also require `git -C <path> rev-parse --show-prefix` to be empty and the reported top-level path to equal the resolved target path.

## Verification
- The two commands in Source returned a parent repository root and a non-empty prefix for the fixture subdirectory.

## Notes
- The health-check H02 test now rejects a subdirectory that only inherits its consumer's parent repository.
