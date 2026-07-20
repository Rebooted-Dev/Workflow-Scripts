# Repository License Decision

**Date:** 2026-07-19
**Status:** No root license asserted
**Scope:** Workflow-Scripts repository

## Decision

The repository does not currently publish a root `LICENSE`. No explicit repository-owner authorization for a root MIT license was available during the v1.8 comprehensive-audit remediation, so this work does not assert one.

Until the owner selects and authorizes a license, the absence of a root license is intentional. Dependency license metadata remains attributable to those dependencies and does not license this repository as a whole.

## Evidence and inconsistency noted

- No root `LICENSE`, `COPYING`, or `NOTICE` file was tracked when this decision was recorded.
- The embedded package at `08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/` declares `"license": "MIT"` in `package.json`.
- That package's README says to see a `LICENSE` file, and its published-file list includes `LICENSE`, but no such package file is present.
- Those embedded-package statements are not treated as authorization to license the Workflow-Scripts repository.

## Follow-up trigger

If the repository owner explicitly authorizes a license, add the authorized root license text and a matching README notice in one reviewed change. Separately reconcile the embedded package's manifest, README, published-file list, and actual license file so they make one evidenced claim.
