# Next.js & React Version Update Procedure

Keeping Next.js and React up to date ensures you have the latest security patches, performance improvements, and bug fixes. This guide covers the general update process for any project using Next.js with React.

## When to Update

- **Security advisories** are published for Next.js or React (check [Next.js blog](https://nextjs.org/blog) and [React blog](https://react.dev/blog)).
- A new **patch or minor release** is available.
- Before **deploying to production** to ensure no known vulnerabilities.
- After changing **branch policy** or onboarding a new team member.

## Pre-Flight Check

```bash
# Check current versions
npm list next react react-dom

# Check what's outdated
npm outdated next react react-dom eslint-config-next
```

Review the [Next.js changelog](https://github.com/vercel/next.js/releases) and [React changelog](https://github.com/facebook/react/blob/main/CHANGELOG.md) for any breaking changes relevant to your version jump.

## Update Procedure

### 1. Update packages

**npm:**
```bash
npm install next@latest react@latest react-dom@latest
```

**Yarn:**
```bash
yarn add next@latest react@latest react-dom@latest
```

**pnpm:**
```bash
pnpm add next@latest react@latest react-dom@latest
```

If you use `eslint-config-next`, update it too:
```bash
npm install eslint-config-next@latest
```

### 2. Run the built-in upgrade tool (Next.js 16.1+)

```bash
npx next upgrade
```

This handles codemods and config migrations automatically. Skip this step if you're on an older version or prefer manual control.

### 3. Verify and test

```bash
# Clear caches
rm -rf .next node_modules/.cache

# Run TypeScript checks
npx tsc --noEmit

# Build the project
npm run build

# Start the dev server and test
npm run dev
```

Test these areas specifically after an update:
- Server Components and RSC boundaries
- Middleware and routing
- Caching behavior
- API routes and server actions
- Any custom configuration in `next.config.js`

## Troubleshooting

### Build failures after update

```bash
# Full clean reinstall
rm -rf node_modules package-lock.json
npm install
npm run build
```

### Version conflicts

If you see peer dependency warnings:
```bash
# Check for mismatched versions
npm ls react react-dom next

# Force resolution if needed
npm install next@latest react@latest react-dom@latest --legacy-peer-deps
```

### Network or registry issues

```bash
npm cache clean --force
npm install next@latest react@latest react-dom@latest --registry https://registry.npmjs.org/
```

## Pinning Versions

For production stability, consider pinning exact versions in `package.json` rather than using ranges:

```json
{
  "dependencies": {
    "next": "16.2.6",
    "react": "19.2.1",
    "react-dom": "19.2.1"
  }
}
```

This prevents unexpected updates from `npm install` while still allowing intentional upgrades.

## Official Resources

- [Next.js Releases](https://github.com/vercel/next.js/releases)
- [React Releases](https://github.com/facebook/react/releases)
- [Next.js Upgrade Guide](https://nextjs.org/docs/app/building-your-application/upgrading)
- [Next.js Security Advisories](https://nextjs.org/blog)
