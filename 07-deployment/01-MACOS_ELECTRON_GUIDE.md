# macOS Electron Desktop App Guide v2.7

This comprehensive guide covers building, configuring, distributing, and troubleshooting a macOS desktop app using Electron with a Next.js application.

> **Document Version**: 2.7 (January 2026)
> **Consolidates**: v2.6 Prevention Checklist + Electron Guide into unified documentation
> **v2.7 Update**: Combined macOS build prevention checklist with comprehensive Electron guide; integrated troubleshooting sections; updated references to current project implementation

---

## When to Use This Guide

**Use this guide when:**
- Building a macOS desktop application with Electron
- Integrating Next.js with Electron
- Setting up OAuth/authentication in Electron apps
- Troubleshooting Electron build or runtime issues
- Configuring code signing and notarization for macOS

**This guide covers:**
- ✅ Complete build and packaging workflow
- ✅ Next.js integration with Electron
- ✅ OAuth/authentication patterns
- ✅ Window management and custom protocols
- ✅ Code signing and notarization
- ✅ Common issues and solutions

**Quick navigation:**
- **Getting started?** → [Quick Start (Preflight)](#quick-start-preflight)
- **Having build issues?** → [Failure Modes & Prevention](#failure-modes--prevention)
- **Troubleshooting?** → [Troubleshooting](#troubleshooting)
- **Need reference?** → [Technical Reference](#technical-reference)

---

## Placeholders

Throughout this document, replace these placeholders with your actual values:

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `<AppName>` | Your application's display name | "YouTube Updater" |
| `<app-id>` | Your application's bundle identifier | `com.youtubepdater.app` |
| `<APP_ENV_VAR>` | Environment variable prefix for your app | `YOUTUBE_UPDATER` |

---

## Table of Contents

1. [Quick Start (Preflight)](#quick-start-preflight)
2. [Preflight Checklist](#preflight-checklist)
3. [Failure Modes & Prevention](#failure-modes--prevention)
4. [Prerequisites](#prerequisites)
5. [Architecture](#architecture)
6. [Build Commands](#build-commands)
7. [Configuration](#configuration)
8. [Loading the Frontend](#loading-the-frontend)
9. [Loading Local Resources in Production](#loading-local-resources-in-production)
10. [Window Dragging](#window-dragging)
11. [Application Icon](#application-icon)
12. [Code Signing & Notarization](#code-signing--notarization)
13. [OAuth / Authentication Flow](#oauth--authentication-flow)
14. [Troubleshooting](#troubleshooting)
15. [Verification & Debugging](#verification--debugging)
16. [Technical Reference](#technical-reference)

---

## Quick Start (Preflight)

### Essential Commands

```bash
# Build for development (fast .app only)
./scripts/mac-build.sh --dir

# Build for distribution (DMG + ZIP)
./scripts/mac-build.sh

# Launch and monitor logs
open "release/mac-arm64/<AppName>.app"
tail -f ~/Library/Logs/<AppName>/main.log
```

### Critical Rules

1. **Always build via `./scripts/mac-build.sh --dir`** so it:
   - Cleans `desktop/*.cjs` and `dist`
   - Builds desktop TS (`npm run build:desktop`)
   - Builds Next.js (`npm run build`)
   - Copies `.next/static` and `public` into `.next/standalone`
   - Wraps `npm list` to suppress electron-builder dependency scan warnings
2. **Use npm** (project `packageManager` is `npm@11.6.2`)
3. **Verify logs** at `~/Library/Logs/<AppName>/main.log`

---

## Preflight Checklist

### Build System

- [ ] Run the build via `./scripts/mac-build.sh --dir` for proper pipeline execution
- [ ] Ensure `scripts/npm` is executable (used by the build script)

### Electron Builder Config

`electron-builder.config.cjs` must include:
- `files` includes `index.cjs` and `.next/standalone`
- `asarUnpack` includes `.next/standalone/**` so the Next.js server can be spawned
- `mac.identity` uses ad-hoc signing when no credentials are present
- `mac.notarize` is `false` when Apple credentials are not configured

### Next.js Standalone Output

- [ ] `next.config.ts` must keep `output: 'standalone'`
- [ ] `scripts/mac-build.sh` must copy `.next/static` and `public` into `.next/standalone`

### OAuth / Auth Flow

- [ ] Use external browser OAuth in Electron (embedded browser is blocked by Google)
- [ ] Use the localhost-only credential handoff endpoint for Electron:
  - `/auth/callback` POSTs `{ accessToken, idToken }` to `/api/auth/electron`
  - Electron polls `/api/auth/electron` and signs in with `signInWithCredential`

---

## Failure Modes & Prevention

### 1) "Waiting for sign-in..." after external browser login

**Cause:** Electron storage is not shared with Safari/Chrome; OAuth tokens set in the browser are invisible to Electron.

**Prevention:**
- Keep the credential handoff flow in place:
  - `src/app/auth/callback/page.tsx` posts tokens to `/api/auth/electron`
  - `src/app/api/auth/electron/route.ts` stores/serves tokens (short-lived)
  - `src/components/auth-button.tsx` polls and calls `signInWithCredential`
- Keep renderer log forwarding enabled to track milestones in `main.log`

**Verification:**
`main.log` shows:
```
[Next.js] [ELECTRON AUTH] Stored credential handoff sessionId=...
[Next.js] [ELECTRON AUTH] Consumed credential handoff sessionId=...
[Renderer] [AUTH] Signed into Firebase via credential handoff
```

### 2) OAuth popup blocked / missing accounts / "browser not secure"

**Cause:** Google blocks OAuth in non-standard browsers (Electron).

**Prevention:**
- Always open OAuth in the system browser via `open-external`
- Only allow external URLs for HTTPS or localhost origins

### 3) App launches but no window appears

**Cause:** Navigation allowlist blocked the app's own origin or the window never reached `ready-to-show`.

**Prevention:**
- Allowlist the correct origin (dev: `http://localhost:9002`, prod: `http://localhost:3000`)
- Provide a fallback window show timeout + `did-fail-load` logging

### 4) App launches but shows a blank white window

**Cause 1:** Wrong path to `dist/index.html` in production builds.
**Cause 2:** Next.js server not starting inside packaged app or running under Electron instead of Node.

**Prevention:**
- **Path Issue**: Use `path.join(__dirname, '..', 'dist', 'index.html')` (not `path.join(__dirname, 'dist/index.html')`)
- **Server Issue**: Spawn the server with `ELECTRON_RUN_AS_NODE=1`
- Use the unpacked standalone output and set `cwd` to app root
- Confirm the app loads `http://localhost:3000`

### 5) "Cannot find module index.cjs" on launch

**Cause:** `index.cjs` missing from `electron-builder` `files` list.

**Prevention:**
- Keep `index.cjs` in `electron-builder.config.cjs` `files`
- Verify the asar contents if this ever regresses

### 6) electron-builder dependency scan warnings

**Symptom:** `cannot find path for dependency ... reference=undefined`

**Cause:** npm 11 returns optional platform deps without versions; electron-builder tries to resolve them.

**Prevention:**
- Build via `./scripts/mac-build.sh --dir` (uses `scripts/npm` wrapper)
- If running manually, add:
  ```bash
  ELECTRON_BUILDER_REAL_NPM="$(command -v npm)"
  PATH="$(pwd)/scripts:$PATH"
  ```

### 7) Notarization / signing warnings during local builds

**Cause:** Apple credentials are not set for local builds.

**Prevention:**
- Keep `mac.identity` set to `-` when no signing credentials
- Keep `mac.notarize` set to `false` unless Apple env vars are present

### 8) App stuck on "Loading..." screen

**Cause 1:** `fetch()` blocked with `file://` protocol (Chromium security restriction).
**Cause 2:** Missing HTML element (null reference in JavaScript).

**Prevention:**
- Implement custom `app://` protocol handler (see [Loading Local Resources in Production](#loading-local-resources-in-production))
- Verify all element IDs exist in `index.html`

---

## Prerequisites

### Required Dependencies

```bash
npm install --legacy-peer-deps
```

This installs:
- `electron` - Desktop application framework
- `electron-builder` - Packaging and distribution
- `@electron/notarize` - Apple code signing
- `@electron/remote` - Renderer-to-main process communication
- `tsx` - TypeScript execution for build scripts
- `esbuild` - Fast TypeScript bundler

**Critical**: `@electron/remote` must be installed as a regular `dependency` (not `devDependency`) so it gets bundled into the packaged app.

### Project Files Required

| File | Purpose | Notes |
|------|---------|-------|
| `desktop/main.ts` | Electron main process - creates BrowserWindow, spawns Next.js | Required |
| `desktop/preload.ts` | Preload script exposing minimal `electronAPI` bridge | Required |
| `index.cjs` | Application entry point for electron-builder (CommonJS) | Required |
| `electron-builder.config.cjs` | electron-builder configuration for macOS | Required |
| `next.config.ts` | Next.js config with `output: 'standalone'` | Required |
| `build-resources/entitlements.plist` | macOS entitlements (network, file access) | Required |
| `build-resources/notarize.cjs` | Notarization script for Apple signing | Optional - only for distribution |
| `build-resources/icon.icns` | Application icon (macOS format) | Generate with `scripts/create-icns.sh` |
| `scripts/build-desktop.ts` | esbuild bundler for desktop scripts | Required |
| `scripts/mac-build.sh` | Build helper script | Required |
| `scripts/create-icns.sh` | Icon conversion script (PNG → ICNS) | Required for icon generation |
| `config.json` | Runtime configuration (API keys, etc.) | Required |

---

## Architecture

### App Bundle Structure

```
<AppName>.app/
  Contents/
    Resources/
      app.asar
        index.cjs               # Entry point (CommonJS)
        desktop/                # Main + preload (bundled as .cjs)
          main.cjs              # __dirname points HERE at runtime
          preload.cjs
        .next/                  # Next.js standalone output
          standalone/
            server.js           # Next.js server
            node_modules/
            .next/static/       # Static assets
        config.json             # Runtime configuration
      icon.icns                 # Application icon
```

> **IMPORTANT**: Note that `desktop/` and `.next/` are siblings, not nested. When loading the frontend or Next.js server from `desktop/main.cjs`, you must use `path.join(__dirname, '..')` to go up one level from `desktop/` to reach sibling directories.

### Runtime Behavior

| Build Type | Behavior |
|------------|----------|
| **Development** | Loads from Next.js dev server (`http://localhost:9002`), opens devtools |
| **Production** | Loads `http://localhost:3000` (spawns embedded Next.js server from `.next/standalone`) |

**Key Points:**
- Asset paths must be relative for packaged builds
- Main process logs are written to `~/Library/Logs/<AppName>/main.log`
- API base URL is injected from main process (relative `/api` paths don't work under Next.js embedded server)

---

## Build Commands

### Quick Start

```bash
# Fast .app build (no DMG/ZIP) - for development testing
./scripts/mac-build.sh --dir

# Full build with DMG/ZIP - for distribution
./scripts/mac-build.sh

# Skip rebuild (use existing artifacts)
./scripts/mac-build.sh --no-build

# Skip cleanup (faster iteration)
./scripts/mac-build.sh --no-clean
```

### Build Outputs

| Command | Output |
|---------|--------|
| `--dir` | `release/mac-arm64/<AppName>.app` |
| (default) | `release/<AppName>-<version>-arm64.dmg` + `release/<AppName>-<version>-mac.zip` |

---

## Configuration

### electron-builder.config.cjs

Key settings:

```javascript
module.exports = {
    appId: '<app-id>',           // e.g., 'com.youtubepdater.app'
    productName: '<AppName>',     // e.g., 'YouTube Updater'
    files: [
        'index.cjs',
        'desktop/main.cjs',
        'desktop/preload.cjs',
        '.next/standalone/**',
        '.next/static/**',
        'public/**',
        'config.json'
    ],
    asarUnpack: [
        '.next/standalone/**',
        '.next/static/**'
    ],
    mac: {
        icon: 'build-resources/icon.icns',
        hardenedRuntime: true,    // Required for notarization
        gatekeeperAssess: false,  // Faster local testing
        identity: '-',            // Ad-hoc signing when no credentials
        notarize: false,          // Disable without Apple credentials
    }
};
```

### Environment Variables

**For Notarization** (choose one):
- `APPLE_ID` + `APPLE_ID_PASSWORD`, or
- `APPLE_API_KEY` + `APPLE_API_KEY_ID` + `APPLE_API_ISSUER`

**Runtime**:
- API key via `config.json` (e.g., `GEMINI_API_KEY`)
- `<APP_ENV_VAR>_SERVERLESS_BASE_URL` to override embedded server with remote endpoint

---

## Loading the Frontend

> **WARNING**: This is a common source of "blank white window" issues. Read carefully!

In the packaged app, `__dirname` resolves to the `desktop/` directory inside `app.asar`, NOT the root. You must account for this when referencing sibling directories.

```typescript
// desktop/main.ts - Loading the Next.js server

const isDev = !app.isPackaged;

if (isDev) {
    // Development: Next.js dev server handles everything
    mainWindow.loadURL('http://localhost:9002');
    mainWindow.webContents.openDevTools();
} else {
    // Production: Spawn embedded Next.js server from .next/standalone
    spawnNextJsServer();

    // Load after server starts
    setTimeout(() => {
        mainWindow.loadURL('http://localhost:3000');
    }, 2000);
}

function spawnNextJsServer() {
    const serverPath = path.join(__dirname, '..', '.next', 'standalone', 'server.js');

    const serverProcess = spawn('node', [serverPath], {
        cwd: path.join(__dirname, '..'),
        env: {
            ...process.env,
            ELECTRON_RUN_AS_NODE: '1',  // Critical: Run as Node, not Electron
            PORT: '3000',
            HOSTNAME: 'localhost'
        },
        stdio: 'inherit'
    });
}
```

**Why this matters:**

```
app.asar structure:
├── index.cjs               # Entry point
├── desktop/
│   ├── main.cjs            # __dirname points HERE in production
│   └── preload.cjs
├── .next/
│   ├── standalone/
│   │   ├── server.js       # Next.js server - sibling, not child of desktop/
│   │   └── node_modules/
│   └── static/
└── config.json
```

| Code | Resolves To | Result |
|------|-------------|--------|
| `path.join(__dirname, '.next/standalone/server.js')` | `/desktop/.next/standalone/server.js` | **WRONG** - File not found, blank white window |
| `path.join(__dirname, '..', '.next/standalone/server.js')` | `/.next/standalone/server.js` | **CORRECT** - Server starts successfully |

---

## Loading Local Resources in Production

This section covers a **critical Electron limitation** that causes apps to get stuck on "Loading..." screens in production builds. If your app uses `fetch()` to load local resources (prompts, metadata, config files), you MUST implement the custom protocol handler pattern described below.

### The Problem: fetch() with file:// Protocol

When you load your app using `mainWindow.loadFile(path)`, Electron uses the `file://` protocol. **Chromium blocks `fetch()` API calls with relative paths when the page is loaded via `file://`** for security reasons.

This affects any code like:
```typescript
// These will FAIL silently in production builds
const prompts = await fetch('prompts/prompt_translate_subtitles_base.txt');
const metadata = await fetch('/metadata.json');
const config = await fetch('./config.json');
```

**Result**: Your app hangs on "Loading..." forever because the prompt loader throws an error that isn't visible.

### Why This Happens

| Protocol | fetch() Behavior |
|----------|-----------------|
| `http://` or `https://` | ✅ Works normally |
| `file://` | ❌ Blocked by Chromium security policy |

The browser treats `file://` as an untrusted origin and refuses to allow cross-origin requests, even for relative paths pointing to files in the same directory.

### The Solution: Custom Protocol Handler

Implement a custom protocol (e.g., `app://`) that serves local files while supporting the `fetch()` API. This is the standard pattern for Electron apps that need to load local resources.

#### Step 1: Register Privileged Protocol BEFORE App Ready

```typescript
// desktop/main.ts
import { app, protocol, BrowserWindow } from 'electron';
import path from 'path';
import { pathToFileURL } from 'url';

// @ts-ignore - net.fetch may not be in older Electron type definitions
const { net } = require('electron');

protocol.registerSchemesAsPrivileged([
    {
        scheme: 'app',
        privileges: {
            standard: true,      // Treat like http:// or https://
            secure: true,        // Considered secure origin
            supportFetchAPI: true, // Enable fetch() for this protocol
            corsEnabled: true,   // Allow cross-origin requests
        },
    },
]);
```

#### Step 2: Implement Protocol Handler

```typescript
app.whenReady().then(() => {
    if (app.isPackaged) {
        const distPath = path.join(__dirname, '..', 'public');

        protocol.handle('app', (request) => {
            const url = new URL(request.url);
            let filePath = decodeURIComponent(url.pathname);

            // Remove leading slash on Windows
            if (process.platform === 'win32' && filePath.startsWith('/')) {
                filePath = filePath.substring(1);
            }

            // Resolve to absolute path in public directory
            const absolutePath = path.join(distPath, filePath);

            // Use net.fetch to serve the file
            const fileUrl = pathToFileURL(absolutePath).href;
            return net.fetch(fileUrl);
        });
    }

    createWindow();
});
```

#### Step 3: Load App via Custom Protocol

```typescript
function createWindow() {
    const mainWindow = new BrowserWindow({ /* ... */ });

    if (app.isPackaged) {
        // Load via custom app:// protocol - NOT with file://
        mainWindow.loadURL('app://localhost/index.html');
    } else {
        // Development: Load from Next.js dev server
        mainWindow.loadURL('http://localhost:9002');
    }
}
```

### Complete Working Example

```typescript
// desktop/main.ts
import { app, BrowserWindow, protocol } from 'electron';
import path from 'path';
import { pathToFileURL } from 'url';

const { net } = require('electron');

protocol.registerSchemesAsPrivileged([
    {
        scheme: 'app',
        privileges: {
            standard: true,
            secure: true,
            supportFetchAPI: true,
            corsEnabled: true,
        },
    },
]);

function createWindow() {
    const mainWindow = new BrowserWindow({
        width: 1400,
        height: 900,
        webPreferences: {
            preload: path.join(__dirname, 'preload.cjs'),
            contextIsolation: true,
            nodeIntegration: false,
        },
    });

    if (app.isPackaged) {
        mainWindow.loadURL('app://localhost/index.html');
    } else {
        mainWindow.loadURL('http://localhost:9002');
        mainWindow.webContents.openDevTools();
    }
}

app.whenReady().then(() => {
    if (app.isPackaged) {
        const distPath = path.join(__dirname, '..', 'public');

        protocol.handle('app', (request) => {
            const url = new URL(request.url);
            let filePath = decodeURIComponent(url.pathname);

            if (process.platform === 'win32' && filePath.startsWith('/')) {
                filePath = filePath.substring(1);
            }

            const absolutePath = path.join(distPath, filePath);
            const fileUrl = pathToFileURL(absolutePath).href;
            return net.fetch(fileUrl);
        });
    }

    createWindow();

    app.on('activate', () => {
        if (BrowserWindow.getAllWindows().length === 0) {
            createWindow();
        }
    });
});

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
        app.quit();
    }
});
```

### How It Works

1. **Protocol Registration**: `app://` is registered as a "privileged" scheme with `supportFetchAPI: true`
2. **Request Interception**: When the renderer requests `app://localhost/prompts/file.txt`, the handler intercepts it
3. **Path Mapping**: Extracts the path and maps it to the local `public/` directory
4. **File Serving**: Uses `net.fetch()` to read the file and return it as a response
5. **Fetch Success**: The renderer `fetch()` completes successfully and the app loads

### Troubleshooting: Stuck on "Loading..." Screen

If your app is stuck on "Loading..." in production:

#### Step 1: Check for Renderer Errors

Add console logging to detect errors:

```typescript
mainWindow.webContents.on('console-message', (_event, level, message) => {
    const levelStr = ['verbose', 'info', 'warning', 'error'][level];
    console.log(`[Renderer ${levelStr}] ${message}`);
});
```

Look for errors like:
- `TypeError: Cannot read properties of null (reading 'querySelector')` - Missing HTML element
- `Failed to load resource` - fetch() failure
- `Fetch API cannot load file://...` - Protocol issue

#### Step 2: Verify Protocol Handler Is Running

Check your logs for `app://` requests:

```bash
tail -f ~/Library/Logs/<AppName>/main.log
```

You should see requests being handled by the protocol handler. If you DON'T see these requests, your protocol handler isn't being triggered.

#### Step 3: Verify All HTML Elements Exist

A common crash occurs when JavaScript tries to access elements that don't exist. Ensure all element IDs referenced in your TypeScript code exist in your HTML files.

---

## Window Dragging

This section covers implementing draggable windows for frameless Electron apps.

### Critical Requirements Checklist

All of these must be true for window dragging to work:

| # | Requirement | Status |
|---|-------------|--------|
| 1 | Drag region has `pointer-events: auto` (NOT `none`) | Required |
| 2 | Drag region has `-webkit-app-region: drag` as CSS property | Required |
| 3 | Interactive elements have `-webkit-app-region: no-drag` | Required |
| 4 | Drag region exists at top edge of window (0-32px) | Recommended |
| 5 | BrowserWindow has `frame: false` and `titleBarStyle: 'hidden'` | Required |

### CSS Implementation

```css
/* Invisible drag bar at top edge of window */
.window-drag-bar {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    height: 32px;
    z-index: 999;
    pointer-events: auto;        /* CRITICAL: must be auto, not none */
    -webkit-app-region: drag;
    background: transparent;
}

/* For navigation/title bar areas */
.app-drag-region {
    pointer-events: auto;        /* CRITICAL: must be auto, not none */
    -webkit-app-region: drag;
}

/* For buttons, links, inputs inside drag regions */
.app-no-drag {
    -webkit-app-region: no-drag;
}
```

### Component Implementation

```jsx
const TopNavigation = () => {
    const handleDoubleClick = () => {
        // Standard macOS behavior: double-click title bar to maximize
        if (window.electronAPI?.maximizeWindow) {
            window.electronAPI.maximizeWindow();
        }
    };

    return (
        <>
            {/* Invisible drag bar at very top of window */}
            <div className="window-drag-bar" onDoubleClick={handleDoubleClick} />

            {/* Navigation bar (also draggable) */}
            <nav className="app-drag-region" onDoubleClick={handleDoubleClick}>
                <button className="app-no-drag">Clickable Button</button>
                <a href="#" className="app-no-drag">Clickable Link</a>
            </nav>
        </>
    );
};
```

### Main Process Setup

```typescript
// desktop/main.ts
import { BrowserWindow } from 'electron';

const mainWindow = new BrowserWindow({
    width: 1400,
    height: 900,
    frame: false,              // Required for custom title bar
    titleBarStyle: 'hidden',   // Required for frameless window
    webPreferences: {
        preload: path.join(__dirname, 'preload.cjs'),
        contextIsolation: true,
    },
});
```

---

## Application Icon

### Overview

macOS requires icons in `.icns` format - a container for multiple resolutions (16x16 to 1024x1024).

### Quick Method (Script)

Save as `scripts/create-icns.sh`:

```bash
#!/bin/bash
# Usage: ./create-icns.sh icon.png
set -e

INPUT="${1:-icon.png}"
ICONSET="icon.iconset"

mkdir -p "$ICONSET"

sips -z 16 16     "$INPUT" --out "$ICONSET/icon_16x16.png"
sips -z 32 32     "$INPUT" --out "$ICONSET/icon_16x16@2x.png"
sips -z 32 32     "$INPUT" --out "$ICONSET/icon_32x32.png"
sips -z 64 64     "$INPUT" --out "$ICONSET/icon_32x32@2x.png"
sips -z 128 128   "$INPUT" --out "$ICONSET/icon_128x128.png"
sips -z 256 256   "$INPUT" --out "$ICONSET/icon_128x128@2x.png"
sips -z 256 256   "$INPUT" --out "$ICONSET/icon_256x256.png"
sips -z 512 512   "$INPUT" --out "$ICONSET/icon_256x256@2x.png"
sips -z 512 512   "$INPUT" --out "$ICONSET/icon_512x512.png"
sips -z 1024 1024 "$INPUT" --out "$ICONSET/icon_512x512@2x.png"

iconutil -c icns "$ICONSET"
mv icon.icns build-resources/
rm -rf "$ICONSET"

echo "Created build-resources/icon.icns"
```

Run:
```bash
chmod +x scripts/create-icns.sh
./scripts/create-icns.sh path/to/your/icon.png
```

### Manual Method

1. **Prepare source** - Export SVG to 1024x1024 PNG with transparent background
2. **Create iconset**:
   ```bash
   mkdir icon.iconset
   sips -z 16 16     icon.png --out icon.iconset/icon_16x16.png
   sips -z 32 32     icon.png --out icon.iconset/icon_16x16@2x.png
   # ... (see script above for all sizes)
   ```
3. **Convert to .icns**:
   ```bash
   iconutil -c icns icon.iconset
   mv icon.icns build-resources/
   ```

---

## Code Signing & Notarization

### For Development

Unsigned builds work but trigger Gatekeeper warnings. This is normal during development.

### For Distribution

**Note**: Code signing and notarization are **optional** for local testing but **required** for public distribution via the Mac App Store or direct download.

1. **Create `build-resources/notarize.cjs`** (if not present):
   ```javascript
   const { notarize } = require('@electron/notarize');

   exports.default = async function notarizing(context) {
       const { electronPlatformName, appOutDir } = context;
       if (electronPlatformName !== 'darwin') return;

       const appName = context.packager.appInfo.productFilename;

       return await notarize({
           appBundleId: '<app-id>',
           appPath: `${appOutDir}/${appName}.app`,
           appleId: process.env.APPLE_ID,
           appleIdPassword: process.env.APPLE_ID_PASSWORD,
           teamId: process.env.APPLE_TEAM_ID,
       });
   };
   ```

2. **Add afterSign hook** to `electron-builder.config.cjs`:
   ```javascript
   afterSign: 'build-resources/notarize.cjs',
   ```

3. **Export credentials**:
   ```bash
   export APPLE_ID="your@email.com"
   export APPLE_ID_PASSWORD="app-specific-password"
   export APPLE_TEAM_ID="your-team-id"
   ```

4. **Build with signing**:
   ```bash
   ./scripts/mac-build.sh
   ```

The `notarize.cjs` script will automatically submit for notarization after signing.

---

## OAuth / Authentication Flow

### The Problem: Embedded Browser Blocked by Google

Google blocks OAuth in non-standard browsers (Electron's embedded browser). Attempting to use `signInWithPopup()` inside Electron will fail with errors like:
- "Browser not secure"
- "Authentication failed"
- Missing accounts on sign-in screen

### The Solution: External Browser + Credential Handoff

#### Architecture

```
1. User clicks "Sign in with Google" in Electron app
2. Electron opens system default browser (Safari/Chrome)
3. OAuth flow completes in browser → redirects to /auth/callback
4. Next.js /auth/callback page POSTs tokens to /api/auth/electron
5. Electron polls /api/auth/electron and receives tokens
6. Firebase signs in via signInWithCredential with the tokens
```

#### Implementation

**Step 1: Callback Page Posts Tokens to Handoff Endpoint**

```typescript
// src/app/auth/callback/page.tsx
'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';

export default function AuthCallbackPage() {
    const router = useRouter();

    useEffect(() => {
        const handleCredentialHandoff = async () => {
            try {
                const urlParams = new URLSearchParams(window.location.hash.slice(1));
                const accessToken = urlParams.get('access_token');
                const idToken = urlParams.get('id_token');

                if (accessToken && idToken) {
                    // Post tokens to handoff endpoint for Electron
                    await fetch('/api/auth/electron', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ accessToken, idToken }),
                    });

                    console.log('[AUTH] Credentials posted for Electron handoff');
                }
            } catch (error) {
                console.error('[AUTH] Failed to post credentials for handoff:', error);
            }
        };

        handleCredentialHandoff();
    }, []);

    return <div>Authentication complete. You can close this tab.</div>;
}
```

**Step 2: Handoff Endpoint Stores Tokens Temporarily**

```typescript
// src/app/api/auth/electron/route.ts
import { NextRequest, NextResponse } from 'next/server';

const authStore = new Map<string, { accessToken: string; idToken: string; expiresAt: number }>();

export async function POST(request: NextRequest) {
    const { accessToken, idToken } = await request.json();

    const sessionId = Math.random().toString(36).substring(2, 15);
    const expiresAt = Date.now() + 5 * 60 * 1000; // 5 minutes

    authStore.set(sessionId, { accessToken, idToken, expiresAt });

    console.log(`[API AUTH] Stored credential handoff sessionId=${sessionId}`);

    return NextResponse.json({ success: true, sessionId });
}

export async function GET(request: NextRequest) {
    const searchParams = request.nextUrl.searchParams;
    const sessionId = searchParams.get('sessionId');

    if (!sessionId) {
        return NextResponse.json({ error: 'Missing sessionId' }, { status: 400 });
    }

    const credentials = authStore.get(sessionId);

    if (!credentials) {
        return NextResponse.json({ error: 'Credentials not found or expired' }, { status: 404 });
    }

    if (credentials.expiresAt < Date.now()) {
        authStore.delete(sessionId);
        return NextResponse.json({ error: 'Credentials expired' }, { status: 410 });
    }

    authStore.delete(sessionId);

    return NextResponse.json({
        accessToken: credentials.accessToken,
        idToken: credentials.idToken,
    });
}
```

**Step 3: Electron Polls Handoff Endpoint**

```typescript
// desktop/main.ts
import { session } from 'electron';

app.whenReady().then(() => {
    // Generate unique sessionId for this session
    const sessionId = crypto.randomUUID();

    // Store sessionId in session for renderer access
    session.defaultSession.webRequest.onBeforeSendHeaders((details, callback) => {
        details.requestHeaders['X-Session-Id'] = sessionId;
        callback({ requestHeaders: details.requestHeaders });
    });
});
```

```typescript
// desktop/preload.ts
import { contextBridge, ipcRenderer, session } from 'electron';

contextBridge.exposeInMainWorld('electronAPI', {
    getSessionId: () => {
        return new Promise((resolve) => {
            session.defaultSession.webRequest.onBeforeSendHeaders((details) => {
                const sessionId = details.requestHeaders['X-Session-Id'];
                if (sessionId) {
                    resolve(sessionId);
                }
            });
        });
    }
});
```

```typescript
// src/components/auth-button.tsx
'use client';

import { useState, useEffect } from 'react';
import { getAuth, signInWithCredential, GoogleAuthProvider } from 'firebase/auth';

export default function AuthButton() {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        const pollCredentialHandoff = async () => {
            try {
                // Get sessionId from main process
                const sessionId = await window.electronAPI?.getSessionId();

                if (!sessionId) return;

                // Poll handoff endpoint
                const response = await fetch(`/api/auth/electron?sessionId=${sessionId}`);

                if (response.ok) {
                    const { accessToken, idToken } = await response.json();

                    // Sign into Firebase with credentials
                    const auth = getAuth();
                    const credential = GoogleAuthProvider.credential(idToken, accessToken);
                    await signInWithCredential(auth, credential);

                    console.log('[AUTH] Signed into Firebase via credential handoff');
                }
            } catch (error) {
                console.error('[AUTH] Failed to poll credential handoff:', error);
            }
        };

        // Poll every 2 seconds for up to 60 seconds
        const interval = setInterval(pollCredentialHandoff, 2000);
        const timeout = setTimeout(() => clearInterval(interval), 60000);

        return () => {
            clearInterval(interval);
            clearTimeout(timeout);
        };
    }, []);

    const handleSignIn = () => {
        setLoading(true);
        const auth = getAuth();
        const provider = new GoogleAuthProvider();

        auth.signInWithPopup(provider)
            .then((result) => {
                setUser(result.user);
                setLoading(false);
            })
            .catch((error) => {
                if (error.code === 'auth/popup-blocked') {
                    // Fall back to external browser redirect
                    window.location.href = `https://accounts.google.com/o/oauth2/v2/auth?...`;
                }
                setLoading(false);
            });
    };

    return (
        <button onClick={handleSignIn} disabled={loading}>
            {loading ? 'Signing in...' : user ? `Signed in as ${user.email}` : 'Sign in with Google'}
        </button>
    );
}
```

---

## Troubleshooting

### Module & Build Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `Cannot find module '@electron/remote/main'` | Package in `devDependencies` | Move to `dependencies` in `package.json` |
| `Dynamic require of "events" is not supported` | Main process using ESM format | Build as CommonJS (`.cjs`) |
| `Directory import is not supported` | `@electron/remote` is CJS-only | Use CJS format for main process |
| `require is not defined` | Entry point using ESM | Use `.cjs` extension |
| `__dirname is not defined` | Using ESM in main process | CJS has `__dirname` built-in |
| `index.js not found in archive` | Wrong entry point | Create `index.cjs` with `require('./desktop/main.cjs')` |

### OAuth Issues

| Symptom | Cause | Fix |
|---------|-------|-----|
| "Waiting for sign-in..." after browser login | Electron storage not shared with browser | Implement credential handoff flow |
| OAuth popup blocked | Embedded browser blocked by Google | Use system browser via `open-external` |
| Missing accounts on sign-in screen | Non-standard browser detected | External browser only |

### App Launch Issues

| Symptom | Cause | Fix |
|---------|-------|-----|
| App launches but no window | Navigation allowlist blocked | Allowlist correct origin; add fallback timeout |
| **Blank white window** | **Wrong path to dist/index.html** | **Use `path.join(__dirname, '..', 'dist', 'index.html')`** |
| **Blank white window** | **Next.js server not starting** | **Spawn with `ELECTRON_RUN_AS_NODE=1`** |
| **App stuck on "Loading..."** | **`fetch()` blocked with `file://` protocol** | **Implement custom `app://` protocol handler** |
| **App stuck on "Loading..."** | **Missing HTML element (null reference)** | **Verify all element IDs exist in HTML** |

### Window Dragging Issues

| Symptom | Cause | Fix |
|---------|-------|-----|
| Can't drag window at all | `pointer-events: none` on drag region | Change to `pointer-events: auto` |
| Can't drag from top edge | No drag region at 0-32px | Add `.window-drag-bar` element |
| Buttons don't click | Missing `no-drag` on elements | Add `-webkit-app-region: no-drag` |
| Drag works but not double-click maximize | Missing handler | Add `onDoubleClick={handleMaximize}` |

---

## Verification & Debugging

### Build Validation

```bash
# Build the app
./scripts/mac-build.sh --dir

# Check app bundle contents
ls -la release/mac-arm64/<AppName>.app/Contents/Resources/

# List files in app.asar
npx asar list release/mac-arm64/<AppName>.app/Contents/Resources/app.asar

# Verify icon
sips -g pixelHeight -g pixelWidth release/mac-arm64/<AppName>.app/Contents/Resources/icon.icns
```

### Test Launch

```bash
# Launch the app
open "release/mac-arm64/<AppName>.app"

# Launch with API key
GEMINI_API_KEY="your-key" open "release/mac-arm64/<AppName>.app"
```

### Check Logs

```bash
# Watch logs in real-time
tail -f ~/Library/Logs/<AppName>/main.log

# View entire log
cat ~/Library/Logs/<AppName>/main.log
```

### OAuth Validation

1. Click "Sign In with Google" in the app
2. Safari/Chrome opens `/auth/callback`
3. Check logs for handoff messages
4. Return to the app and confirm sign-in completes

---

## Technical Reference

### Module Format: CommonJS for Main Process

**Why CommonJS?**

The Electron main process must use CommonJS (`.cjs`) because `@electron/remote`:
- Is a CJS-only package (no ES module exports)
- Uses `require('events')` internally
- Depends on Node.js built-ins loaded at runtime

**Build Configuration** (`scripts/build-desktop.ts`):

```typescript
await esbuild.build({
    entryPoints: ['desktop/main.ts', 'desktop/preload.ts'],
    bundle: true,
    platform: 'node',
    format: 'cjs',
    outExtension: { '.js': '.cjs' },
    external: ['electron', '@electron/remote', '@electron/remote/main'],
    outdir: 'desktop',
});
```

**Entry Point** (`index.cjs`):

```javascript
require('./desktop/main.cjs');
```

### Known Limitations

1. **API keys required** - The packaged app needs API keys configured in `~/.env` or environment variables
2. **Unsigned builds** - Gatekeeper warning appears without code signing
3. **Apple Silicon only** - Default builds are `arm64`

### Notes

- Apple Silicon builds are the default (`arm64`)
- Intel builds require running on Intel Mac or cross-compilation
- Main process logs go to `~/Library/Logs/<AppName>/main.log`
- Use custom `app://` protocol for local resource loading
- OAuth must use external browser with credential handoff

---

## Changelog

### v2.7 (January 2026)
- **MAJOR CONSOLIDATION**: Merged v2.6 prevention checklist with comprehensive Electron guide
- Added complete section on OAuth / Authentication Flow with external browser pattern
- Integrated failure modes and prevention as standalone section
- Combined troubleshooting sections from both documents
- Updated architecture for Next.js standalone output pattern
- Fixed dev server port reference (9002 for Next.js, 5173 for Vite)
- Clarified external browser OAuth requirement and credential handoff
- Added comprehensive verification steps for each major component
- Integrated Quick Start Preflight for rapid onboarding

### v2.6 (January 2026)
- Accuracy review of documentation against project implementation
- Fixed port references and clarified optional files
- Verified project files compliance

### v2.5 (January 2026)
- Added comprehensive "Loading Local Resources in Production" section
- Documents the `fetch()` API limitation with `file://` protocol

### v2.4 (January 2026)
- Added detailed documentation for `dist/index.html` path issue
- Explains blank white window troubleshooting

---