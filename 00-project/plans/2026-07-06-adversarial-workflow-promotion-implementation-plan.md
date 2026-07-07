---
kind: reference
domain: workflow
status: active
priority: P3
created: 2026-07-06
source_plan: 2026-07-03-multi-model-plan-review-pass-system-implementation-plan.md
---

# Adversarial Workflow Promotion Implementation Plan

## Status

Active. This plan is the Phase 5 deliverable from `2026-07-03-multi-model-plan-review-pass-system-implementation-plan.md`. It records the exact promotion surface for a later approved implementation pass. It does not itself approve or perform promotion into active top-level workflow directories.

## Objective

Promote the validated adversarial multi-model research, planning, and plan-review drafts from `00-project/build/adversarial-multi-model-workflow/` into reusable Workflow-Scripts surfaces after approval, while preserving the shared orchestration contracts and avoiding duplicated rules across profile workflows.

## Promotion Boundary

Do not edit these destination paths until this plan is explicitly accepted for implementation:

- `core/meta/`
- `tools/orchestrator/`
- `workflows/planning/`
- `11-Skills/`
- `README.md`, `ROUTER.md`, or generated `catalog.json` except through the normal build commands after approved edits

Keep pilot evidence and prototype run artifacts under `00-project/build/adversarial-multi-model-workflow/` until a later cleanup decision.

## Evidence Already Available

- Phase 1 contracts: `00-project/build/adversarial-multi-model-workflow/draft-workflows/`
- Phase 2 profiles and dry-runs: `00-project/build/adversarial-multi-model-workflow/profile-drafts/` and `00-project/build/adversarial-multi-model-workflow/synthetic-dry-runs/`
- Phase 3 pilot run: `00-project/build/adversarial-multi-model-workflow/runs/20260706-231500-phase3-manual-pilot/`
- Phase 4 launcher prototype: `00-project/build/adversarial-multi-model-workflow/prototypes/fan-out-adversarial.sh`
- Phase 4 smoke runs:
  - `00-project/build/adversarial-multi-model-workflow/runs/20260706-234000-research-launcher-smoke/`
  - `00-project/build/adversarial-multi-model-workflow/runs/20260706-234500-review-launcher-smoke/`
- Validators:
  - `scripts/validation/check-adversarial-manifest-samples.sh`
  - `scripts/validation/check-adversarial-phase3-pilots.sh`
  - `scripts/validation/check-adversarial-launcher.sh`

## Exact Promotion Map

| Priority | Source | Destination | Action |
|---|---|---|---|
| P1 | `00-project/build/adversarial-multi-model-workflow/draft-workflows/multi-agent-artifact-contract.md` | `core/meta/multi-agent-artifact-contract.md` | Promote shared artifact naming and write-boundary contract. |
| P1 | `00-project/build/adversarial-multi-model-workflow/draft-workflows/multi-agent-manifest-contract.md` | `core/meta/multi-agent-manifest-contract.md` | Promote shared manifest schema and status vocabulary. |
| P1 | `00-project/build/adversarial-multi-model-workflow/draft-workflows/multi-agent-source-resolution.md` | `core/meta/multi-agent-source-resolution.md` | Promote shared source/protected-path rules. |
| P1 | `00-project/build/adversarial-multi-model-workflow/draft-workflows/multi-agent-synthesis.md` | `core/meta/multi-agent-synthesis.md` | Promote shared synthesis and reconciliation rules. |
| P1 | `00-project/build/adversarial-multi-model-workflow/draft-workflows/multi-agent-cleanup-policy.md` | `core/meta/multi-agent-cleanup-policy.md` | Promote cleanup/archive policy for run artifacts. |
| P1 | `00-project/build/adversarial-multi-model-workflow/prototypes/fan-out-adversarial.sh` | `tools/orchestrator/fan-out-adversarial.sh` | Promote launcher after replacing prototype-only manual limitations with accepted harness behavior. |
| P2 | `00-project/build/adversarial-multi-model-workflow/profile-drafts/adversarial-research-profile.md` | `workflows/planning/04-adversarial-research.md` | Promote as new numbered research workflow. |
| P2 | `00-project/build/adversarial-multi-model-workflow/profile-drafts/adversarial-planning-profile.md` | `workflows/planning/05-adversarial-planning.md` | Promote as new numbered planning workflow. |
| P2 | `00-project/build/adversarial-multi-model-workflow/profile-drafts/adversarial-plan-review-profile.md` | `workflows/planning/06-adversarial-plan-review.md` | Promote as new numbered plan-review workflow. |
| P2 | `workflows/planning/README.md` | `workflows/planning/README.md` | Add entries for `04`, `05`, and `06`, with usage guidance and overhead warning. |
| P2 | `workflows/planning/00-research-and-plan.md` | `workflows/planning/00-research-and-plan.md` | Cross-link to `04-adversarial-research.md` for high-risk or evidence-heavy research tasks. |
| P2 | `workflows/planning/01-plan-review.md` | `workflows/planning/01-plan-review.md` | Cross-link to `06-adversarial-plan-review.md` without duplicating shared orchestration rules. |
| P2 | `workflows/planning/02-finalise-plan.md` | `workflows/planning/02-finalise-plan.md` | Cross-link to synthesis/reconciliation requirements for adversarial review outputs. |
| P2 | `workflows/planning/03-plan-review-and-finalise.md` | `workflows/planning/03-plan-review-and-finalise.md` | Cross-link to adversarial plan review when a multi-pass review is explicitly selected. |
| P3 | `11-Skills/workflow-plan-review-finalize/SKILL.md` or new skill | `11-Skills/adversarial-workflow-orchestration/SKILL.md` | Add or update skill routing to point at the shared meta layer and promoted profile workflows. |
| P3 | `scripts/validation/check-adversarial-launcher.sh` | `scripts/validation/check-adversarial-launcher.sh` | Keep and update validator to cover promoted launcher path. |
| P3 | `scripts/validation/check-adversarial-manifest-samples.sh` | `scripts/validation/check-adversarial-manifest-samples.sh` | Keep and update any paths that move from draft to promoted locations. |
| P3 | `scripts/validation/check-adversarial-phase3-pilots.sh` | `scripts/validation/check-adversarial-phase3-pilots.sh` | Keep as historical pilot evidence guard until archive cleanup. |

## Implementation Steps

1. Re-run the current validators before editing destination paths:
   - `bash scripts/validation/check-adversarial-manifest-samples.sh`
   - `bash scripts/validation/check-adversarial-phase3-pilots.sh`
   - `bash scripts/validation/check-adversarial-launcher.sh`
2. Copy shared contract docs into `core/meta/` and update `core/meta/README.md`.
3. Copy launcher into `tools/orchestrator/`, then update paths in `scripts/validation/check-adversarial-launcher.sh` so it validates the promoted launcher rather than the prototype copy.
4. Promote the three profile drafts into numbered planning workflows.
5. Update `workflows/planning/README.md` and the four existing planning workflows with short cross-links only.
6. Add or update the relevant `11-Skills/` routing skill.
7. Run `tools/wf build` and `tools/wf build skills`.
8. Mirror accepted changes into `Drag-Free-v2/` if that tree is still retained as the working snapshot.
9. Update `TODO.md`, changelog, and troubleshooting only after validation evidence exists.

## Deferred Extensions

- Role-specialized prompt addenda libraries for research, planning, review, security, scope, test-strategy, and migration-order.
- Embedding-based clustering for review findings.
- CI gating on review exit codes.
- Cross-plan aggregation.
- External provider defaults. Model aliases and provider availability must be refreshed before any non-local default is committed.

## Acceptance Checks

The implementation pass is complete only when all of these pass:

- `tools/wf validate`
- `tools/wf build --check`
- `tools/wf build skills --check`
- `bash scripts/validation/check-active-markdown-links.sh`
- `bash scripts/validation/check-adversarial-manifest-samples.sh`
- `bash scripts/validation/check-adversarial-phase3-pilots.sh`
- `bash scripts/validation/check-adversarial-launcher.sh`
- `find scripts tools 00-Meta-Workflow -name '*.sh' -print0 | xargs -0 shellcheck`
- `shellcheck tools/orchestrator/fan-out-adversarial.sh`
- `git diff --check`

## Current Filing Validation

This plan was filed after Phases 1-4 passed:

- `Validated 244 frontmatter records with 0 warnings`
- `Active markdown links OK`
- `adversarial phase3 pilot checks OK`
- `adversarial launcher checks OK`
- `generated files are fresh`
- `skill bundles are fresh`
