# File planning and code-build workflow quality review
**Date:** 2026-09-25
**Type:** docs

## Summary

Filed a review of `01-planning-and-organizing/` and `02-code-build/` covering workflow mechanics, research and planning quality, and engineering-quality enforcement (architecture, reuse, abstraction, fault prevention and recovery). It uses the Flash-UI prompt-quality plan as a verified case study. It found three live mechanics defects: stale Not Eligible wording in `04-review-finalise-commit-execute.md`, CI not running on the active `v1.8x` line (4 broken links on `v1.82`), and unsized agent rosters in the planning chain. It proposes a tiered plan template, a host-usable `check-plan.sh` linter (sketch tested on fixtures), a completion-chain invariant, and a single `00-meta/engineering-standards.md` that unblocks the unreviewed July Drag-Free-v2 quality proposal. Recommendations only; no workflow files changed.

## Scope

- [Research report](../../research/planning-and-build-workflow-quality-review-260925-1347-claude.md)

## Verification

Ran all `scripts/validation/check-*.sh`; ran the proposed invariant against `02-code-build/` (flags only `04-review-finalise-commit-execute.md`); tested the `check-plan.sh` sketch on passing and failing fixtures; verified the case-study residual in Flash-UI `lib/style-loader.ts:444, 506`. Checked this report's relative links with `check-active-markdown-links.sh`.
