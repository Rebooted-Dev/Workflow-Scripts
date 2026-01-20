# Critical React / Next.js Remote Code Execution (RCE) Patch Guide
**CVE-2025-55182** (React) – December 2025

## Why this matters (TL;DR)
A zero-click remote code execution vulnerability was published on December 3, 2025 that affects **any** project using:
- React 19.0.0 → 19.2.0
- Next.js 15.x or 16.x (including canaries)
- Any other framework that bundles `react-server-dom-*` (RSC Flight protocol)

Exploits are public and being actively scanned for.
**Static sites and projects still on React 18 or Next.js 14 (Pages Router) are safe.**

Patched versions were released December 3–4, 2025 and are 100% backwards compatible.

## How to Check if Your Project is Affected

### Quick Version Check
```bash
# Check React versions in package.json
grep '"react"' package.json
grep '"react-dom"' package.json
grep '"next"' package.json

# Or check installed versions
npm list react react-dom next
```

### Affected Versions Table

| Package                    | Vulnerable          | Fixed (use ≥ these) |
|----------------------------|---------------------|---------------------|
| `react` / `react-dom`      | 19.0.0 – 19.2.0     | **19.2.1** or higher |
| `next`                     | 15.x → 16.0.6       | **16.0.7** or higher (or the latest 15.x patch: 15.5.7) |
| `react-server-dom-webpack` etc. | bundled with React 19 | upgraded automatically when you update `react` |

## One-command fix (recommended)

Run **one** of these in the root of every affected project:

### If you use npm
```bash
npm i react@latest react-dom@latest next@latest
```

### If you use yarn
```bash
yarn add react@latest react-dom@latest next@latest
```

### If you use pnpm
```bash
pnpm add react@latest react-dom@latest next@latest
```

## Verification Steps

After applying the patch:

```bash
# Verify versions were updated
npm list react react-dom next

# Build your project to ensure compatibility
npm run build

# Test your application
npm run dev
```

## What to do if the patch fails

### Network Issues
If you get network errors:
```bash
# Clear npm cache
npm cache clean --force

# Try with different registry
npm i react@^19.2.1 react-dom@^19.2.1 --registry https://registry.npmjs.org/
```

### Permission Issues
If you get permission errors:
```bash
# On macOS/Linux with npm
sudo chown -R $(whoami) ~/.npm
npm i react@latest react-dom@latest next@latest

# Or use a Node version manager
nvm use --lts
npm i react@latest react-dom@latest next@latest
```

### Build Failures After Update
If your build fails after the update:
1. Check for TypeScript errors: `npx tsc --noEmit`
2. Clear build cache: `rm -rf node_modules/.cache`
3. Reinstall dependencies: `rm -rf node_modules && npm install`
4. Check React version compatibility in your codebase

## Official Resources
- [React Security Advisory](https://react.dev/blog/2025/12/03/security-advisory)
- [Next.js Security Advisory](https://nextjs.org/blog/security-advisory)
- [CVE-2025-55182 Details](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2025-55182)

## Status
- **PATCHED**: Updated `react` and `react-dom` to `^19.2.1` in `index.html` import map.