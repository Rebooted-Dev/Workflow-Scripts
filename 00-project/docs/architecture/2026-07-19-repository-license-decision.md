# Repository License Decision

**Date:** 2026-07-19
**Status:** No root license asserted
**Scope:** Workflow-Scripts repository

## Decision

The repository does not currently publish a root `LICENSE`. No explicit repository-owner authorization for a root MIT license was available during the v1.8 comprehensive-audit remediation, so this work does not assert one.

Until the owner selects and authorizes a license, the absence of a root license is intentional. Dependency license metadata remains attributable to those dependencies and does not license this repository as a whole.

## Evidence and package reconciliation

- No root `LICENSE`, `COPYING`, or `NOTICE` file was tracked when this decision was recorded.
- The embedded package at `08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/` previously claimed MIT without a corresponding license file.
- The remediation reconciled that package to `"license": "UNLICENSED"`, removed `LICENSE` from its published-file list, and corrected its README. It no longer makes an unsupported license claim.
- Dependency license metadata remains attributable to those dependencies and is not treated as authorization to license Workflow-Scripts.

## Follow-up trigger

If the repository owner explicitly authorizes a license, add the authorized root license text and a matching README notice in one reviewed change. Revisit the embedded package at the same time so its manifest, README, published-file list, and any actual license file continue to make one evidenced claim.
