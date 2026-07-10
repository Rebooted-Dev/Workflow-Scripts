# `wf validate` Warning Remediation Plan

Date: 2026-07-10
Status: completed

## Objective

Eliminate the 24 false-positive Markdown-link warnings by ignoring well-formed fenced examples while preserving validation of genuine prose links and inline contract paths.

## Implementation

1. Add a dependency-free fenced-code stripping helper to `tools/wf` for matched backtick/tilde fences and variable fence lengths; retain the original document when a fence is unterminated.
2. Apply the same semantics in `check-active-markdown-links.sh` so prose Markdown links and inline relative contract paths remain enforced outside fences.
3. Extend `check-wf-cli.sh` with regression fixtures for prose links, both fence types, variable lengths, consumer-project templates, the literal grep pattern, unterminated fences, inline paths, and retired tokens.
4. Log the validator bug and fix, regenerate `catalog.json` and `ROUTER.md`, and run the complete validation suite.

## Acceptance

- `wf validate` reports zero warnings and no multiline fence content.
- All CLI, active-link, redirect, review-policy, orchestrator, skill, build-freshness, and scoped diff checks pass.
- No workflow or template content is rewritten merely to satisfy validation.

## Closure

After verification, file this plan under `plans-completed/remediation/`, file the warning inventory under `research-completed/investigation/`, and update the plan, research, changelog, README, and TODO indexes.

## Result

Completed. Context-aware parsing eliminated all 24 false positives while the regression suite retained warning-only prose-link validation and failure behavior for active prose links, inline contract paths, and retired inline tokens.
