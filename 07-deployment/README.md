# Deployment Workflows

This directory contains deployment guides for desktop apps, web hosting, pre-deployment checks, and development-server setup.

## Quick Decision Tree

```text
Is your app a desktop application?
├─ Yes → macOS Electron Desktop App Guide
│        ./01a-MACOS_ELECTRON_GUIDE.md
│        For electron-vite migrations: ./01b-electron-vite.md
└─ No → Continue

Are you migrating from AI Studio?
└─ Yes → ./02-ai-studio-to-desktop.md

Are you deploying to a cloud platform or server?
├─ Firebase Hosting → ../09-11 Misc/10-firebase-setup.md
├─ Nginx → ../09-11 Misc/11-nginx.md
└─ Other → Continue

Do you need a deployment/security/SEO/GEO checklist?
├─ Full checklist → ../12-SEO-GEO-checklist/
└─ Quick security check → ./08a-pre-deployment-security-check.md

Do you need to manage development server ports?
└─ Yes → ./08-port-relocation/port-management-guide.md

Do you need to apply Next.js/React updates?
└─ Yes → ../09-11 Misc/09-nextjs-react-update.md
```

## Deployment Guides

### Desktop Applications

#### [macOS Electron Desktop App Guide](./01a-MACOS_ELECTRON_GUIDE.md)
Use when building and distributing macOS desktop applications with Electron.

#### [Electron-Vite Migration Workflow](./01b-electron-vite.md)
Use when migrating existing Electron apps or TypeScript apps to electron-vite for dual web and desktop distribution.

### Migration And Setup

#### [AI Studio to Desktop Migration](./02-ai-studio-to-desktop.md)
Use when migrating projects from Google AI Studio or Colab to local desktop development.

### Development Tools

#### [Port Management Guide](./08-port-relocation/port-management-guide.md)
Use when resolving port conflicts, managing multiple dev servers, or configuring browser auto-open.

#### [Browser Auto-Open Guide](./08-port-relocation/browser-auto-open.md)
Use when setting up automatic browser opening for local development servers.

### Cloud Hosting

#### [Firebase Hosting Setup](../09-11%20Misc/10-firebase-setup.md)
Use when deploying static sites or SPAs to Firebase Hosting.

#### [Nginx Deployment Guide](../09-11%20Misc/11-nginx.md)
Use when deploying applications with nginx on macOS, Linux, or a server.

### Pre-Deployment Checklists

#### [SEO/GEO Checklist](../12-SEO-GEO-checklist/)
Use before first production deployment, major releases, or recurring search/AI visibility audits.

#### [Pre-deployment Security Check](./08a-pre-deployment-security-check.md)
Use for quick validation before deployment.

### Framework Updates

#### [Next.js / React Update Guide](../09-11%20Misc/09-nextjs-react-update.md)
Use when applying React, React DOM, Next.js, or eslint-config-next updates.

## Common Scenarios

### Static Site To Firebase

1. Build your site: `npm run build`
2. Follow [Firebase Hosting Setup](../09-11%20Misc/10-firebase-setup.md)
3. Deploy: `firebase deploy --only hosting`

### Local Development With Port Conflicts

1. Follow [Port Management Guide](./08-port-relocation/port-management-guide.md)
2. Configure your dev server to use an available port.
3. Run the project dev command.

### Desktop App Distribution

1. Follow [macOS Electron Desktop App Guide](./01a-MACOS_ELECTRON_GUIDE.md)
2. Build with the project's desktop build script.
3. Code sign and notarize when distributing outside local testing.

### Adding Desktop Support To A Web App

1. Follow [Electron-Vite Migration Workflow](./01b-electron-vite.md)
2. Set up electron-vite for main and preload builds.
3. Configure dual dev workflow for web and desktop.
4. Verify packaged app behavior.

### Comprehensive Production Readiness

1. Follow [SEO/GEO Checklist](../12-SEO-GEO-checklist/)
2. Run [Pre-deployment Security Check](./08a-pre-deployment-security-check.md)
3. Deploy to production.
4. Set up monitoring and repeat the routine review tasks.

## Best Practices

1. Test locally before deployment.
2. Run the project build, lint, and type-check commands.
3. Verify dependency and security status.
4. Validate environment variables without printing secret values.
5. Update project-specific deployment notes after any non-trivial deployment issue.
