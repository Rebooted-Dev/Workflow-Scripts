# Firebase Hosting Setup Guide

This guide covers deploying static sites and single-page applications (SPAs) to Firebase Hosting. It provides a general workflow that can be adapted to any project.

## Overview

Firebase Hosting provides fast, secure hosting for static websites and SPAs. This guide covers the complete setup and deployment workflow.

## Prerequisites

- Node.js and npm installed
- Firebase CLI installed: `npm install -g firebase-tools`
- A Firebase project (create at [Firebase Console](https://console.firebase.google.com/))

## Initial Setup

### Step 1: Install Dependencies

```bash
npm install
```

### Step 2: Authenticate Firebase CLI

```bash
firebase login
```

This opens your browser for authentication. Sign in with your Google account.

### Step 3: Initialize Firebase in Your Project

```bash
firebase init hosting
```

Follow the prompts:
- Select your Firebase project (or create a new one)
- Set public directory: `dist` (or your build output directory)
- Configure as single-page app: `Yes` (for SPAs)
- Set up automatic builds: `Yes` (optional)
- Overwrite `index.html`: `No` (unless you want to)

### Step 4: Configure firebase.json

Ensure your `firebase.json` includes:

```json
{
  "hosting": {
    "public": "dist",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "predeploy": [
      "npm run build"
    ]
  }
}
```

**Key settings:**
- `public`: Your build output directory (e.g., `dist`, `build`, `out`)
- `rewrites`: SPA routing support (all routes → `index.html`)
- `predeploy`: Build command that runs before deployment

### Step 5: Configure .firebaserc

Your `.firebaserc` should map to your Firebase project:

```json
{
  "projects": {
    "default": "your-project-id"
  }
}
```

## Build Configuration

### For Vite Projects

If using Vite, ensure your build outputs to the correct directory:

```typescript
// vite.config.ts
export default defineConfig({
  build: {
    outDir: 'dist',  // Must match firebase.json "public"
  },
})
```

### For Projects with Additional Assets

If your build needs to copy additional files (e.g., prototypes, static assets):

```typescript
// vite.config.ts
import { copyFileSync, mkdirSync } from 'fs';
import { resolve } from 'path';

export default defineConfig({
  plugins: [
    {
      name: 'copy-assets',
      closeBundle() {
        // Copy additional files to dist
        const srcDir = resolve(__dirname, 'prototypes');
        const destDir = resolve(__dirname, 'dist', 'prototypes');
        // Copy logic here
      },
    },
  ],
})
```

## Local Testing

### Using Firebase Emulator

```bash
# Build your project
npm run build

# Start Firebase emulator
firebase emulators:start --only hosting
```

The emulator will serve your site at `http://127.0.0.1:5000` (or the port shown).

### Manual Testing

```bash
# Build your project
npm run build

# Serve locally (using a simple HTTP server)
cd dist
npx serve
# Or: python3 -m http.server 8000
```

## Deployment

### Deploy to Firebase Hosting

```bash
firebase deploy --only hosting
```

This will:
1. Run the `predeploy` command (`npm run build`)
2. Upload the `dist` directory to Firebase Hosting
3. Provide a deployment URL

### Deploy to Specific Project

```bash
firebase use <project-id>
firebase deploy --only hosting
```

### Preview Deployment

```bash
firebase hosting:channel:deploy preview
```

Creates a preview URL for testing before production deployment.

## Verification

After deployment:

1. **Check the deployment URL** - Firebase provides a URL like `https://your-project.web.app`
2. **Test all routes** - Ensure SPA routing works correctly
3. **Check network panel** - Verify all assets load (200 status codes)
4. **Test on different devices** - Ensure responsive design works

## Troubleshooting

### Issue: "File not found" or SPA fallback showing

**Symptoms:**
- Routes show "File not found (Fallback detected)"
- Assets not loading correctly

**Solutions:**
1. **Check build output:**
   ```bash
   ls -la dist/
   # Verify all expected files exist
   ```

2. **Verify firebase.json rewrites:**
   ```json
   "rewrites": [
     {
       "source": "**",
       "destination": "/index.html"
     }
   ]
   ```

3. **Check file casing:** Firebase Hosting is case-sensitive on some systems

4. **Verify predeploy runs from root:**
   - Ensure `firebase.json` `predeploy` runs from project root
   - Check that build command works: `npm run build`

### Issue: Predeploy fails

**Symptoms:**
- Deployment fails with "predeploy script failed"
- Build errors during deployment

**Solutions:**
1. **Test build locally:**
   ```bash
   npm run build
   ```

2. **Check for missing dependencies:**
   ```bash
   npm install
   ```

3. **Verify build script in package.json:**
   ```json
   {
     "scripts": {
       "build": "vite build"  // Or your build command
     }
   }
   ```

### Issue: Assets missing after deployment

**Symptoms:**
- Some files not appearing on deployed site
- Images or other assets return 404

**Solutions:**
1. **Check build output includes assets:**
   ```bash
   ls -la dist/
   # Verify all assets are present
   ```

2. **Verify asset paths in code:**
   - Use relative paths: `./assets/image.png`
   - Check Vite asset handling configuration

3. **Check build plugin copies assets:**
   - Verify any custom copy plugins run during build
   - Test build locally before deploying

### Issue: CDN warnings in console

**Symptoms:**
- Console warnings about CDN resources
- External resources loading slowly

**Note:** CDN warnings (e.g., Tailwind, Babel from CDN) are expected for some setups but not production best practice. Consider:
- Bundling dependencies instead of CDN
- Using npm packages for libraries
- Self-hosting critical resources

## Best Practices

### Build Optimization

1. **Minify assets** - Enable minification in build config
2. **Code splitting** - Use dynamic imports for large bundles
3. **Asset optimization** - Compress images, optimize fonts
4. **Cache headers** - Configure caching in `firebase.json` (optional)

### Security

1. **Environment variables** - Never commit secrets
2. **API keys** - Use Firebase Functions for server-side operations
3. **CORS** - Configure CORS if using external APIs
4. **HTTPS** - Firebase Hosting provides HTTPS by default

### Performance

1. **Lazy loading** - Load routes/components on demand
2. **Image optimization** - Use modern formats (WebP, AVIF)
3. **CDN usage** - Firebase Hosting uses Google's CDN automatically
4. **Monitoring** - Use Firebase Analytics for performance insights

## Advanced Configuration

### Custom Domain

1. Add domain in Firebase Console
2. Verify domain ownership
3. Update DNS records as instructed
4. Firebase automatically provisions SSL certificate

### Multiple Sites

Configure multiple sites in `firebase.json`:

```json
{
  "hosting": [
    {
      "target": "main-site",
      "public": "dist",
      "rewrites": [...]
    },
    {
      "target": "admin-site",
      "public": "admin-dist",
      "rewrites": [...]
    }
  ]
}
```

### Environment-Specific Deployments

Use different Firebase projects for staging/production:

```bash
# Staging
firebase use staging-project
firebase deploy --only hosting

# Production
firebase use production-project
firebase deploy --only hosting
```

## Checklist

### Setup
- [ ] Firebase CLI installed and authenticated
- [ ] Firebase project created
- [ ] `firebase.json` configured correctly
- [ ] `.firebaserc` maps to correct project
- [ ] Build output directory matches `firebase.json` "public"

### Build
- [ ] `npm run build` completes successfully
- [ ] Build output includes all required files
- [ ] Assets are properly copied to output directory
- [ ] No build errors or warnings

### Local Testing
- [ ] Firebase emulator serves site correctly
- [ ] All routes work (SPA routing)
- [ ] Assets load correctly
- [ ] No console errors

### Deployment
- [ ] `firebase deploy --only hosting` succeeds
- [ ] Deployment URL accessible
- [ ] All routes work on deployed site
- [ ] Assets load correctly
- [ ] No 404 errors in network panel

## Related Guides

- [Port Management Guide](../../deployment/08-port-relocation/port-management-guide.md) - Development server setup
- [Deployment Index](../../deployment/README.md) - Other deployment scenarios
- [Firebase Documentation](https://firebase.google.com/docs/hosting) - Official Firebase docs

---

*This guide provides a general workflow for Firebase Hosting. Adapt the configuration to your specific project structure and requirements.*
