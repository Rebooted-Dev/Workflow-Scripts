# Workflow Contract and CLI Remediation Plan

Date: 2026-07-10  
Status: completed

## Objective

Remediate the six confirmed deep-review findings and dangling-`requires` regression while preserving the numbered `workflows-drag-free` package, its redirect inventory, and the single-master architecture.

## Scope and contract

- Restore the missing core policy records and catalog every executable workflow named by the review.
- Require workflow `id`, `version`, `category`, `kind: workflow`, and one or more triggers; resolve every dependency and workflow graph edge exactly once.
- Route by exact ID, exact normalized trigger, then unique highest whole-token score; fail unknown or tied queries with exit 2.
- Keep `wf run` review-only: accept only `plan-review`, fail all other IDs before subprocess launch or manifest creation.
- Remove the unimplemented one-time migration commands `init-frontmatter`, `init-ledger-frontmatter`, and `prune-skipped-frontmatter`.
- Repair active core/setup/security paths and validate relative Markdown paths written in backticks.

## Implementation phases

1. Repair canonical contracts and paths under `00-core/` and active workflow files.
2. Add workflow discovery metadata and complete `prev`/`next`/`requires` graph integrity.
3. Harden `tools/wf` validation, routing, and execution behavior; extend CLI regression fixtures.
4. Regenerate `catalog.json` and `ROUTER.md`, correct touched README terminology, log the fix, and file this plan plus the two source reports after verification.

## Verification

Run from the `Workflow-Scripts` repository root:

```bash
workflows-drag-free/tools/wf validate
workflows-drag-free/tools/wf build --check
workflows-drag-free/tools/wf route "finalise the plan"
workflows-drag-free/tools/wf route "security fix"
scripts/validation/check-wf-cli.sh
scripts/validation/check-active-markdown-links.sh
scripts/validation/check-moved-targets.sh
scripts/validation/check-review-workflow-policy.sh
scripts/validation/check-orchestrator-review.sh
scripts/validation/check-workflow-skills.sh
git diff --check -- <files touched by this remediation>
```

## Closure

After every check passes, move this plan to `plans-completed/remediation/`, update the completed-plan index and plans README/TODO, add changelog and troubleshooting records, then move both source reports to `research-completed/review/` and record their research rows.

## Assumptions

- Preserve all existing dirty work and do not pull, reset, or recreate the retired second tree.
- Keep existing role-count, token-reduction, numbered-layout, and deferred skills-nesting deviations out of scope.
- Do not add a new security audit.
- Do not silently repair the known trailing whitespace in the dual-tree comparison report unless an authorized filing edit overlaps it.
