# Browser Auto-Open Guide

This guide shows you how to automatically open your browser when running development servers. For port management and conflict resolution, see [port-management-guide.md](./port-management-guide.md).

## Quick Start

### For Vite Projects (Recommended)

Add this to your `vite.config.ts`:

```typescript
export default defineConfig({
  server: {
    open: true,  // Auto-open browser
  },
})
```

That's it! The browser will open automatically when you run `npm run dev`.

---

## Table of Contents

1. [Vite Configuration](#vite-configuration)
2. [Other Build Tools](#other-build-tools)
3. [Custom Browser Selection](#custom-browser-selection)
4. [Multiple Browsers](#multiple-browsers)
5. [Troubleshooting](#troubleshooting)

---

## Vite Configuration

### Basic Setup

```typescript
// vite.config.ts
import { defineConfig } from 'vite'

export default defineConfig({
  server: {
    host: 'localhost',
    port: 5173,
    open: true,  // ✅ Enable auto-open
  },
})
```

### Custom URL

```typescript
export default defineConfig({
  server: {
    open: {
      url: 'http://localhost:5173/custom-path'
    },
  },
})
```

### Custom Browser

```typescript
export default defineConfig({
  server: {
    open: {
      browser: 'chrome',  // 'firefox', 'safari', 'edge', etc.
    },
  },
})
```

### Multiple Browsers

```typescript
export default defineConfig({
  server: {
    open: ['chrome', 'firefox'],  // Opens both browsers
  },
})
```

---

## Other Build Tools

### Webpack

```javascript
// webpack.config.js
module.exports = {
  devServer: {
    open: true,  // Auto-open browser
    port: 3000,
  },
};
```

### Create React App

```json
// package.json
{
  "scripts": {
    "dev": "BROWSER=1 react-scripts start"
  }
}
```

Or disable auto-open:
```json
{
  "scripts": {
    "dev": "BROWSER=none react-scripts start"
  }
}
```

### Next.js

```javascript
// next.config.js
module.exports = {
  devServer: {
    open: true,
  },
}
```

### Parcel

```json
// package.json
{
  "scripts": {
    "dev": "parcel index.html --open"
  }
}
```

### Vue CLI

Auto-open is enabled by default:
```bash
npm run serve
```

### Angular CLI

```bash
ng serve --open
```

Or in `angular.json`:
```json
{
  "serve": {
    "options": {
      "open": true
    }
  }
}
```

### SvelteKit

```javascript
// svelte.config.js
export default {
  kit: {
    adapter: adapter(),
  },
  server: {
    open: true,
  },
};
```

---

## Custom Browser Selection

### Using open Package

Install the `open` package for more control:

```bash
npm install --save-dev open
```

```javascript
// In your dev server setup script
import open from 'open';

async function startServer() {
  // Start your dev server...
  
  // Auto-open browser
  await open('http://localhost:3000', {
    app: {
      name: 'chrome',  // or 'firefox', 'safari', etc.
    }
  });
}
```

### Platform-Specific Commands

**macOS:**
```bash
open -a "Google Chrome" http://localhost:5173
open -a "Firefox" http://localhost:5173
open -a "Safari" http://localhost:5173
```

**Linux:**
```bash
google-chrome http://localhost:5173
firefox http://localhost:5173
```

**Windows:**
```powershell
start chrome http://localhost:5173
start firefox http://localhost:5173
```

---

## Multiple Browsers

### For Cross-Browser Testing

```bash
npm install --save-dev open
```

```javascript
import open from 'open';

async function startServer() {
  // Start your dev server...
  
  // Open multiple browsers
  await Promise.all([
    open('http://localhost:3000', { app: { name: 'chrome' } }),
    open('http://localhost:3000', { app: { name: 'firefox' } }),
  ]);
}
```

---

## Troubleshooting

### Browser Doesn't Open

**Check 1: Configuration**
- Verify `open: true` is set in your build tool config
- Check for typos in configuration

**Check 2: Default Browser**
- Ensure your OS has a default browser set
- macOS: System Settings > Desktop & Dock > Default web browser
- Windows: Settings > Apps > Default apps > Web browser

**Check 3: Disable Auto-Open**
Try disabling to see if the issue is with auto-open or the server:
```bash
BROWSER=none npm run dev
```

**Check 4: macOS Permissions**
On macOS, you may need to allow Terminal to open browsers:
```bash
sudo spctl developer-mode enable-terminal
```

### Permission Issues (macOS)

If Terminal can't open the browser:

1. **System Settings** > **Privacy & Security**
2. Enable **Developer Mode**
3. Allow Terminal to open applications

Or use:
```bash
sudo spctl developer-mode enable-terminal
```

### Windows Issues

- Make sure your default browser is set in Windows Settings
- Try using `start http://localhost:PORT` instead
- Check Windows Firewall isn't blocking the connection

### Browser Opens Wrong URL

**Check 1: Custom Path**
If using a custom path, ensure it's correct:
```typescript
server: {
  open: {
    url: 'http://localhost:5173/correct-path'
  },
}
```

**Check 2: Port Number**
Verify the port matches your server:
```typescript
server: {
  port: 5173,
  open: true,
}
```

### Browser Opens Before Server Ready

Some build tools open the browser immediately. If you need to wait:

```javascript
// Using open package with delay
import open from 'open';

async function startServer() {
  // Start server...
  
  // Wait for server to be ready
  await new Promise(resolve => setTimeout(resolve, 2000));
  
  // Then open browser
  await open('http://localhost:3000');
}
```

---

## Quick Reference

| Build Tool | Config Location | Setting |
|------------|----------------|---------|
| Vite | `vite.config.js` | `server: { open: true }` |
| Webpack | `webpack.config.js` | `devServer: { open: true }` |
| Next.js | `next.config.js` | `devServer: { open: true }` |
| Create React App | `package.json` | `"dev": "BROWSER=1 react-scripts start"` |
| Vue CLI | Auto-enabled | `npm run serve` |
| Angular CLI | Command line | `ng serve --open` |
| Parcel | `package.json` | `"dev": "parcel index.html --open"` |

---

## Best Practices

1. **Use build tool's native option** - Most reliable
2. **Test on multiple OS** - Ensure cross-platform compatibility
3. **Document your setup** - Add to README.md
4. **Handle errors gracefully** - Don't fail if browser can't open
5. **Consider user preference** - Some developers prefer manual opening

---

## Related Guides

- [Port Management Guide](./port-management-guide.md) - Port conflict resolution
- [Deployment Index](../../07-deployment/README.md) - Other deployment scenarios

---

*This guide focuses solely on browser auto-open functionality. For port management, see the port management guide.*
