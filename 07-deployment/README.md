# Deployment Workflows

This directory contains comprehensive guides for deploying applications across various platforms and scenarios. Each guide provides step-by-step instructions, troubleshooting, and best practices.

## Quick Decision Tree

**Which deployment guide do I need?**

```
Is your app a desktop application?
├─ Yes → [Electron Desktop App Guide](./01-MACOS_ELECTRON_GUIDE.md)
│   (For new electron-vite migrations: [Electron-Vite Migration](./01b-electron-vite.md))
└─ No → Continue...

Are you deploying to a cloud platform?
├─ Firebase Hosting → [Firebase Setup Guide](./10-firebase-setup.md)
├─ Nginx (local/server) → [Nginx Deployment Guide](./11-nginx.md)
└─ Other → Continue...

Are you migrating from AI Studio?
└─ Yes → [AI Studio to Desktop Migration](./02-ai-studio-to-desktop.md)

Do you need a comprehensive pre-deployment checklist?
├─ Yes, full deployment/security/SEO → [Comprehensive Checklist](./12-comprehensive-deployment-security-seo-geo-checklist.md)
└─ Yes, quick security check → [Pre-deployment Security Check](./08a-pre-deployment-security-check.md)

Do you need to manage development server ports?
└─ Yes → [Port Management Guide](./08-port-relocation/port-management-guide.md)

Do you need to apply security patches?
└─ Yes → [Security Patches Guide](./09-react-bug.md)
```
Is your app a desktop application?
├─ Yes → [Electron Desktop App Guide](./01-MACOS_ELECTRON_GUIDE.md)
│   (For new electron-vite migrations: [Electron-Vite Migration](./01b-electron-vite.md))
└─ No → Continue...

Are you deploying to a cloud platform?
├─ Firebase Hosting → [Firebase Setup Guide](./10-firebase-setup.md)
├─ Nginx (local/server) → [Nginx Deployment Guide](./11-nginx.md)
└─ Other → Continue...

Are you migrating from AI Studio?
└─ Yes → [AI Studio to Desktop Migration](./02-ai-studio-to-desktop.md)

Do you need a comprehensive pre-deployment checklist?
└─ Yes → [Comprehensive Deployment, Security, SEO & GEO Checklist](./12-comprehensive-deployment-security-seo-geo-checklist.md)

Do you need to manage development server ports?
└─ Yes → [Port Management Guide](./08-port-relocation/port-management-guide.md)

Do you need to apply security patches?
└─ Yes → [Security Patches Guide](./09-react-bug.md)

Do you need a quick security check before deploy?
└─ Yes → [Pre-deployment Security Check](./08a-pre-deployment-security-check.md)
```

## Deployment Guides

### Desktop Applications

#### [macOS Electron Desktop App Guide](./01-MACOS_ELECTRON_GUIDE.md)
**When to use:** Building and distributing macOS desktop applications using Electron with Next.js.

**Covers:**
- Building and packaging Electron apps
- Code signing and notarization
- OAuth/authentication in Electron
- Window management and custom protocols
- Troubleshooting common Electron issues

**Quick start:**
```bash
./scripts/mac-build.sh --dir
```

#### [Electron-Vite Migration Workflow](./01b-electron-vite.md)
**When to use:** Migrating existing Electron apps or TypeScript apps to support electron-vite for macOS builds with dual web + desktop distribution.

**Covers:**
- Migrating from esbuild/webpack to electron-vite
- Configuring electron-vite for main/preload processes
- Setting up dev workflow with hot reload
- Dual build support (web + desktop)
- Path resolution in packaged apps
- electron-builder integration

**Quick start:**
```bash
# Follow the 5-phase workflow in the guide
# Phase 1: Project setup and electron-vite config
# Phase 2: Dev workflow with port coordination
# Phase 3: electron-builder configuration
# Phase 4: Path resolution
# Phase 5: Verification
```

---

### Cloud Hosting

#### [Firebase Hosting Setup](./10-firebase-setup.md)
**When to use:** Deploying static sites or SPAs to Firebase Hosting.

**Covers:**
- Initial Firebase setup and authentication
- Build configuration for static sites
- Local emulator testing
- Deployment workflow
- Troubleshooting deployment issues

**Quick start:**
```bash
firebase login
firebase use <project-id>
npm run build
firebase deploy --only hosting
```

#### [Nginx Deployment Guide](./11-nginx.md)
**When to use:** Deploying applications using nginx on macOS, Linux, or servers.

**Covers:**
- Installing and configuring nginx
- Serving static sites
- Reverse proxy for Node.js apps
- SSL/HTTPS setup
- Local network and remote access
- Security best practices

**Quick start:**
```bash
brew install nginx
# Configure nginx.conf
nginx
```

---

### Migration & Setup

#### [AI Studio to Desktop Migration](./02-ai-studio-to-desktop.md)
**When to use:** Migrating projects from Google AI Studio (Colab) to local desktop development.

**Covers:**
- Automated project extraction from notebooks
- Dependency resolution and environment setup
- Configuration migration
- Validation and testing
- Comprehensive migration framework

**Note:** This is a comprehensive reference guide (2100+ lines) covering the complete migration framework.

---

### Development Tools

#### [Port Management Guide](./08-port-relocation/port-management-guide.md)
**When to use:** Resolving port conflicts, managing multiple dev servers, or configuring browser auto-open.

**Covers:**
- Simple port conflict resolution (Vite config)
- Advanced process management
- Browser auto-open configuration
- Cross-platform compatibility
- Troubleshooting port issues

**Quick start:**
```typescript
// vite.config.ts
server: {
  strictPort: false,  // Auto-find available ports
  open: true,         // Auto-open browser
}
```

#### [Browser Auto-Open Guide](./08-port-relocation/browser-auto-open.md)
**When to use:** Setting up automatic browser opening for development servers.

**Covers:**
- Vite, Webpack, Next.js configuration
- Custom browser selection
- Multiple browser support
- Cross-platform setup

---

### Pre-Deployment Checklists

#### [Comprehensive Deployment, Security, SEO & GEO Checklist](./12-comprehensive-deployment-security-seo-geo-checklist.md)
**When to use:** Before first production deployment, major releases, or quarterly audits for any web application.

**Covers:**
- Part 1: Deployment - Build validation, environment variables, platform configuration, CI/CD
- Part 2: Security - OWASP Top 10, security headers, authentication, input validation, cookie security
- Part 3: SEO - Meta tags, structured data, crawlability, Core Web Vitals, local SEO, E-E-A-T signals
- Part 4: GEO - Location data, map integration, AI search optimization, monitoring

**Quick start:**
```
1. Fill in project placeholders ({{DOMAIN}}, {{PROJECT_NAME}}, etc.)
2. Work through Phase 1-4 checklists
3. Use the implementation roadmap for phased rollout
```

#### [Pre-deployment Security Check](./08a-pre-deployment-security-check.md)
**When to use:** Quick security validation before any deployment.

**Covers:**
- Dependency vulnerability scanning
- Outdated package identification
- Environment and secrets validation
- Build and lint verification
- Optional static/runtime security checks

**Quick start:**
```bash
npm audit && npm outdated && npm run build && npm run lint
```

---

### Security

#### [Security Patches Guide](./09-react-bug.md)
**When to use:** Applying critical security patches for React/Next.js vulnerabilities.

**Covers:**
- React RCE vulnerability (CVE-2025-55182)
- Version checking and patching
- Verification steps
- Troubleshooting patch failures

**Quick start:**
```bash
npm i react@latest react-dom@latest next@latest
```

---

## Common Deployment Scenarios

### Scenario 1: Static Site to Firebase

1. Build your site: `npm run build`
2. Follow [Firebase Hosting Setup](./10-firebase-setup.md)
3. Deploy: `firebase deploy --only hosting`

### Scenario 2: Local Development with Port Conflicts

1. Follow [Port Management Guide](./08-port-relocation/port-management-guide.md)
2. Add `strictPort: false` to Vite config
3. Run: `npm run dev`

### Scenario 3: Desktop App Distribution

1. Follow [Electron Desktop App Guide](./01-MACOS_ELECTRON_GUIDE.md)
2. Build: `./scripts/mac-build.sh`
3. Code sign and notarize (optional)

### Scenario 4: Adding Desktop Support to Web App

1. Follow [Electron-Vite Migration Workflow](./01b-electron-vite.md)
2. Set up electron-vite for main/preload builds
3. Configure dual dev workflow (web + desktop)
4. Build with: `./scripts/mac-build.sh`

### Scenario 6: Comprehensive Production Readyness

1. Follow [Comprehensive Deployment, Security, SEO & GEO Checklist](./12-comprehensive-deployment-security-seo-geo-checklist.md)
2. Complete Phase 1 (Pre-Deployment) security and build checks
3. Deploy to production
4. Complete Phase 2 (SEO Setup) search engine submissions
5. Set up Phase 3 (CI/CD) automation

---

### Scenario 6: Comprehensive Deployment Planning

Use [Comprehensive Checklist](./12-comprehensive-deployment-security-seo-geo-checklist.md):

1. **Production deployment** - Complete Phase 1 tasks (Security & Build)
2. **Deploy to production** - Complete Phase 2 tasks (SEO setup)
3. **Set up CI/CD and monitoring** - Complete Phase 3 tasks
4. **Ongoing maintenance** - Follow monthly checklist

---

## File Structure
├── 12-comprehensive-deployment-security-seo-geo-checklist.md  # Master checklist
└── 08-port-relocation/

---

## Best Practices

### Before Deployment

1. **Test locally** - Ensure your app works in development
2. **Build successfully** - Run `npm run build` without errors
3. **Check dependencies** - Verify all required packages are installed
4. **Environment variables** - Configure production environment variables
5. **Security patches** - Apply latest security updates

### During Deployment

1. **Follow the guide** - Use the appropriate deployment guide
2. **Check logs** - Monitor deployment logs for errors
3. **Verify configuration** - Double-check configuration files
4. **Test incrementally** - Test each step before proceeding

### After Deployment

1. **Verify functionality** - Test all features on deployed site
2. **Check performance** - Monitor load times and resource usage
3. **Monitor errors** - Set up error tracking and monitoring
4. **Update documentation** - Document any deployment-specific notes

---

## Troubleshooting

### Common Issues

**Port conflicts:**
- See [Port Management Guide](./08-port-relocation/port-management-guide.md)

**Build failures:**
- Check Node.js version compatibility
- Clear build cache: `rm -rf node_modules/.cache`
- Reinstall dependencies: `rm -rf node_modules && npm install`

**Deployment errors:**
- Check platform-specific guides for troubleshooting sections
- Verify configuration files
- Review deployment logs

**Security vulnerabilities:**
- See [Security Patches Guide](./09-react-bug.md)
- Run `npm audit` regularly
- Keep dependencies updated

---

## Related Documentation

- [Workflow Scripts README](../README.md) - Complete workflow documentation
- [Planning Workflows](../01-planning/) - Implementation planning
- [Security Workflows](../06-security/) - Security reviews and fixes

---

## Contributing

When adding new deployment guides:

1. Follow the structure of existing guides
2. Include quick start section
3. Add troubleshooting section
4. Update this README with new guide
5. Test all steps before documenting

---

*Last updated: 2026-03-24*
