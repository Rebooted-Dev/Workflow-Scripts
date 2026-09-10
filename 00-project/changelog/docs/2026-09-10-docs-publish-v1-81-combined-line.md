# Publish v1.81 combined Workflow-Scripts line

**Date:** 2026-09-10  
**Type:** docs  
**Status:** Complete

## Summary

Published `v1.81` as the active combined line by merging frozen parent branches `v1.8` (July remediation, CI, security, SDK) and `v1.72` (Aug–Sep active workflows, completion-chain gate, dependency workflows). Neither parent was rewritten.

## Preserved from v1.8

- `.github/workflows/validation.yml` and hardened validation scripts
- Comprehensive-audit remediation changelog, license/image-library architecture notes, security troubleshooting
- Embedded `@ai-sdk-image-generation` dependency upgrades (`eslint.config.js`, `tests/setup.ts`)
- Meta-Workflow relocation of `RELEASE_NOTES_v1.0.0.md` and `proj-organisation.md`
- Removal of `fable-like.md` from active planning (no provenance-gated snapshot created)

## Preserved from v1.72

- `check-completion-chain-policy.sh` and completion-chain terminal-gate workflows
- Dependency workflow consolidation, SEO skill setup, review/finalise/commit/execute pipeline
- Umbrella-workspace symlink consumption documentation
- `05-review/briefs/dependency-security-scan.md` and held `11-Skills/README.md` policy

## Reconciliation notes

- Seven content conflicts union-resolved (AGENTS, repository map, changelog index, planning/code-build/review READMEs, root README)
- Active branch guidance now points to `v1.81`; `v1.8` and `v1.72` documented as frozen parents
- `main` not moved in this work
- Live Shared-Common-Library master checkout retargeted to `v1.81` on 2026-09-10; workspace agent/map pins updated
