# Embedded Image Library Maintenance Decision

**Date:** 2026-07-19
**Status:** Active
**Next review:** 2026-10-19, or earlier if a new advisory is published

## Decision

Maintain `08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/` in this repository. Extraction into another repository is outside the v1.8 remediation scope.

The library now follows the current AI SDK 7 provider line and requires Node.js 22 or newer. Its direct runtime, peer, and development dependencies were reviewed against the npm registry on 2026-07-19. The package gate passes and `npm audit` reports zero vulnerabilities.

## Compatibility constraint

TypeScript remains on 5.9.x even though 7.0.x is available. `@typescript-eslint` 8.64 supports TypeScript versions below 6.1, so TypeScript 5.9.3 is the latest compatible release for the current lint stack. Re-evaluate this pin on the next review date after TypeScript-ESLint declares TypeScript 7 support.

No other direct dependency has an unreviewed newer release as of this decision.

## Verification contract

Run from the embedded package directory:

```bash
npm audit
npm outdated
npm run test:run
npm run build
npm run type-check
npm run lint
```

Generated `dist/` output is ignored and is not part of the repository change.
