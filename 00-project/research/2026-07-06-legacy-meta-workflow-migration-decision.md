---
date: 2026-07-06
kind: reference
status: complete
---

# Legacy Meta-Workflow Migration Decision

## Decision

Retain `00-Meta-Workflow/` as a compatibility source during the redirect-stub transition, but migrate all retained legacy meta content that is still needed to the canonical paths declared in `MOVED.md`.

The canonical content homes are not `00-project/`:

- reusable meta policy content -> `core/meta/`
- orchestrator content -> `tools/orchestrator/`
- historical docs, plans, and token-efficiency references -> `reference/meta-workflow/`

`00-project/` remains the Workflow-Scripts project metadata root for plans, research, changelog, troubleshooting, build artifacts, and measurement records.

## Evidence

Before migration, all 22 `00-Meta-Workflow/` redirect rows existed as legacy source files. Sixteen of those rows had missing canonical targets. Those targets were copied from the legacy source files.

After migration, every `00-Meta-Workflow/` row in `MOVED.md` has an existing canonical target.

## Migrated Target Groups

- `reference/meta-workflow/docs/`
- `reference/meta-workflow/plans/`
- `reference/meta-workflow/token-efficiency/`
- `core/meta/`
- `tools/orchestrator/`

## Follow-up

Do not delete `00-Meta-Workflow/` in this step. Root redirect stubs and compatibility directories are already tracked separately for removal after the next release cycle following archive remediation.
