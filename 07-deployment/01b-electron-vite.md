# Electron-Vite Migration Workflow

A generalized workflow for migrating existing Electron apps or TypeScript apps to support **electron-vite** for macOS desktop builds, while maintaining support for web app builds.

**Version:** 1.3 (2026-02-02)  
**Scope:** Build pipeline migration for dual web + desktop distribution  
**Prerequisites:** Node.js 20.19+ or 22.12+, existing web app (Next.js/React/Vite)

---

## When to Use This Workflow

Use this workflow when you need to:
- **Add desktop support** to an existing web application
- **Migrate from esbuild/webpack** to electron-vite for Electron builds
- **Support dual distribution** (web + macOS desktop app)
- **Maintain a single codebase** for both web and desktop
- **Enable hot reload** for desktop development

### Supported Architectures

| Renderer (Web) | Supported | Notes |
|----------------|-----------|-------|
| Next.js | ✅ Yes | This workflow's primary use case |
| Vite + React | ✅ Yes | Adjust paths accordingly |
| Create React App | ✅ Yes | May need ejection for full control |
| Vue/Angular | ✅ Yes | Framework-agnostic main/preload |

---

## Overview

### Goal

Replace or add Electron build tooling using **electron-vite** for the main process and preload script, while:
- Keeping your existing **renderer** (web framework) unchanged
- Supporting both **web builds** (browser) and **macOS app builds** (electron-builder)
- Enabling **hot reload** for desktop development
- Using **electron-builder** exclusively for macOS packaging

### Key Principles

1. **electron-vite builds only main/preload** - Your web framework handles the renderer
2. **electron-builder is the only packager** - Use it exclusively for macOS .app creation
3. **Preserve CJS output** - For maximum compatibility (configurable)
4. **Separate output directories** - Avoid conflicts with web build outputs
5. **Port coordination required** - Dev workflow needs careful port management

---

## Prerequisites

### Node.js Version

**Requirement:** Node.js 20.19.0+ or 22.12.0+

**Action:** Lock Node version with `.nvmrc`:

```bash
# Check current version
node --version

# Create .nvmrc at project root
echo "22.12.0" > .nvmrc

# Verify in CI/build scripts
node --version  # Should fail fast if below minimum
```

### Existing Project Structure

This workflow assumes:

```
project-root/
├── src/                    # Your web app source (Next.js/React)
│   ├── app/               # (Next.js App Router example)
│   └── components/
├── package.json           # Existing web dependencies
└── [existing build tool]  # Web build already configured
```

### Dependencies to Install

```bash
# Core Electron toolchain
npm install -D electron electron-builder electron-vite

# TypeScript types (if using TS)
npm install -D @types/node

# Notarization (optional, for Mac App Store)
npm install -D @electron/notarize
```

---

## Phase 1: Project Structure Setup

### 1.1 Create Desktop Source Directory

Create a dedicated directory for Electron-specific code:

```bash
mkdir -p desktop
```

**Recommended structure:**

```
desktop/
├── main.ts          # Main process entry
├── preload.ts       # Preload script
└── types.ts         # Shared types (optional)
```

**Alternative:** Use `src/main/` and `src/preload/` if you prefer colocating with web source.

### 1.2 Vite renderer: base path for Electron (Vite + React only)

If your **renderer** is built with **Vite** (not Next.js), you must set a relative base path so the packaged app loads correctly. Electron loads the app via `file://`; absolute paths (Vite’s default `/assets/...`) resolve from the filesystem root and cause a **blank screen** in the packaged app.

**In `vite.config.ts` (or `vite.config.mts`):**

```typescript
export default defineConfig({
  base: './',  // CRITICAL for Electron file:// protocol
  // ... rest of config
});
```

**Verify:** After `npm run build`, open `dist/index.html`. Script and link hrefs must be relative (e.g. `./assets/index-xxx.js`), not absolute (`/assets/...`).

**Production load (Vite only):** In `desktop/main.ts`, for production use `mainWindow.loadFile(path.join(__dirname, '..', '..', '..', 'dist', 'index.html'))` instead of `loadURL(PROD_APP_ORIGIN)`.

---

### 1.3 Main Process Template

Create `desktop/main.ts`:

```typescript
import { app, BrowserWindow, ipcMain, shell, screen } from 'electron';
import * as path from 'path';
import { spawn } from 'child_process';

const DEV_APP_ORIGIN = 'http://localhost:9002';  // Your dev server port
const PROD_APP_ORIGIN = 'http://localhost:3000'; // Production Next.js port

let mainWindow: BrowserWindow | null = null;
let serverProcess: ReturnType<typeof spawn> | null = null;

function createWindow(): BrowserWindow {
  const isDev = process.env.NODE_ENV === 'development' || !app.isPackaged;

  // Optional: macOS – use full vertical space (excludes menu bar and dock)
  const primaryDisplay = screen.getPrimaryDisplay();
  const workAreaSize = primaryDisplay.workAreaSize;
  const workArea = primaryDisplay.workArea;  // { x, y, width, height } for positioning
  const windowWidth = 1400;
  const windowHeight = process.platform === 'darwin' ? workAreaSize.height : 900;
  // Position at top of work area, centered horizontally (fullest possible height)
  const windowX = Math.round(workArea.x + (workArea.width - windowWidth) / 2);
  const windowY = workArea.y;

  const isMac = process.platform === 'darwin';

  mainWindow = new BrowserWindow({
    width: windowWidth,
    height: windowHeight,
    x: windowX,
    y: windowY,
    minWidth: 800,
    minHeight: 600,
    // CRITICAL (macOS): Use ONLY titleBarStyle. Do NOT use frame:false + titleBarStyle together — they conflict and break dragging. See 01a-MACOS_ELECTRON_GUIDE.
    ...(isMac
      ? { titleBarStyle: 'hiddenInset' }
      : { frame: false }
    ),
    webPreferences: {
      // Path relative to electron-vite output structure
      preload: path.join(__dirname, '..', 'preload', 'preload.js'),
      nodeIntegration: false,
      contextIsolation: true,
      sandbox: true,
    },
    show: false,  // Show when ready
  });

  if (isDev) {
    mainWindow.loadURL(DEV_APP_ORIGIN);
    mainWindow.webContents.openDevTools();
  } else {
    // Production: load from embedded Next.js server (or for Vite: loadFile from dist – see §1.2)
    mainWindow.loadURL(PROD_APP_ORIGIN);
  }

  mainWindow.once('ready-to-show', () => {
    mainWindow?.show();
  });

  // Omit center() when using explicit x,y above; position already aligns with work area.

  return mainWindow;
}
```

**macOS window sizing:** `screen.getPrimaryDisplay().workAreaSize` gives usable dimensions (excluding menu bar and dock). Use `workAreaSize.height` for the window height so the app doesn’t sit under the dock. For **fullest possible height**, also set position from `primaryDisplay.workArea` (x, y, width, height): pass `x` and `y` to `BrowserWindow` (e.g. `y: workArea.y`, `x: workArea.x + (workArea.width - windowWidth) / 2`) so the window is top-aligned in the work area and centered horizontally. Omit `mainWindow.center()` when using this explicit positioning. Use `size` only if you intend to overlap system UI.

---

### 1.4 macOS: Draggable window and traffic lights (optional)

If you use `titleBarStyle: 'hiddenInset'` on macOS (recommended; do **not** add `frame: false` on macOS — the two conflict and break dragging; see 01a-MACOS_ELECTRON_GUIDE), add the following so the window is draggable and content doesn’t overlap the traffic lights.

**1. Drag region (in `index.html` `<head>` or global CSS):**

```css
.window-drag-bar {
  height: 38px;
  -webkit-app-region: drag;
  position: fixed;
  top: 0; left: 0; right: 0;
  z-index: 9999;
}
.window-drag-bar button,
.window-drag-bar a,
.window-drag-bar input,
.window-drag-bar [role="button"],
.window-drag-bar .no-drag {
  -webkit-app-region: no-drag;
}
```

Add a top bar element (e.g. `<div class="window-drag-bar" data-drag-region></div>`) so users can drag the window. Give all interactive elements in that bar `no-drag` or the same `-webkit-app-region: no-drag` so clicks work.

**2. Header padding for traffic lights:** On macOS, leave ~70–80px left padding in the header (e.g. `pl-20` / 5rem) when running in Electron so content doesn’t sit under the close/minimize/maximize buttons. Detect Electron via your preload API (e.g. `window.electronAPI?.isElectron()`).

**3. Optional:** Expose IPC handlers for minimize/maximize/close and custom window control buttons; see your project’s **macOS Window Height Fix implementation guide** (or equivalent) for full code.

---

Remainder of `desktop/main.ts` (IPC handlers and app lifecycle):

```typescript
// IPC handlers
ipcMain.handle('minimize-window', () => {
  mainWindow?.minimize();
});

ipcMain.handle('open-external', async (_, url: string) => {
  if (url.startsWith('https://')) {
    await shell.openExternal(url);
    return true;
  }
  return false;
});

// Production: Start embedded Next.js server
async function startNextServer(): Promise<void> {
  // Path: dist/electron/main/ -> dist/electron/ -> dist/ -> project root
  const standaloneDir = path.join(__dirname, '..', '..', '..', '.next', 'standalone');
  const serverScript = path.join(standaloneDir, 'server.js');
  
  serverProcess = spawn(process.execPath, [serverScript], {
    env: { ...process.env, NODE_ENV: 'production', PORT: '3000' },
    cwd: standaloneDir,
  });
  
  // Wait for server to be ready...
}

app.whenReady().then(async () => {
  if (!app.isPackaged) {
    createWindow();  // Dev: Next.js already running externally
  } else {
    await startNextServer();
    createWindow();
  }
});

app.on('window-all-closed', () => {
  serverProcess?.kill();
  if (process.platform !== 'darwin') app.quit();
});
```

### 1.5 Preload Script Template

Create `desktop/preload.ts`:

```typescript
import { contextBridge, ipcRenderer } from 'electron';

// Expose safe APIs to renderer
contextBridge.exposeInMainWorld('electronAPI', {
  minimizeWindow: () => ipcRenderer.invoke('minimize-window'),
  openExternal: (url: string) => ipcRenderer.invoke('open-external', url),
  isElectron: () => true,
});

// Type declarations for TypeScript
export interface ElectronAPI {
  minimizeWindow: () => Promise<void>;
  openExternal: (url: string) => Promise<boolean>;
  isElectron: () => boolean;
}

declare global {
  interface Window {
    electronAPI?: ElectronAPI;
  }
}
```

---

## Phase 2: Configure electron-vite

### 2.1 Create electron.vite.config.ts

Create `electron.vite.config.ts` at project root:

```typescript
import { defineConfig, externalizeDepsPlugin } from 'electron-vite';
import * as path from 'path';

export default defineConfig({
  main: {
    build: {
      outDir: 'dist/electron/main',
      lib: {
        entry: path.resolve(__dirname, 'desktop/main.ts'),
        formats: ['cjs'],  // CommonJS for compatibility
      },
      sourcemap: process.env.NODE_ENV === 'production' ? 'hidden' : true,
      minify: process.env.NODE_ENV === 'production',
    },
    plugins: [externalizeDepsPlugin()],  // Keep node_modules external
  },
  preload: {
    build: {
      outDir: 'dist/electron/preload',
      lib: {
        entry: path.resolve(__dirname, 'desktop/preload.ts'),
        formats: ['cjs'],
      },
      sourcemap: process.env.NODE_ENV === 'production' ? 'hidden' : true,
      minify: process.env.NODE_ENV === 'production',
    },
    plugins: [externalizeDepsPlugin()],
  },
  renderer: null as any,  // We're using Next.js/Vite, not electron-vite's renderer
});
```

**Critical settings explained:**

| Setting | Value | Purpose |
|---------|-------|---------|
| `formats: ['cjs']` | CommonJS | Maximum compatibility with Electron patterns |
| `outDir: 'dist/electron/*'` | Separate directory | Avoid conflict with web build outputs |
| `externalizeDepsPlugin()` | External deps | Don't bundle node_modules |
| `renderer: null` | Disabled | We use Next.js/Vite for renderer |

### 2.2 Update package.json Scripts

Add to `package.json`:

```json
{
  "main": "dist/electron/main/main.js",
  "scripts": {
    "build:desktop": "electron-vite build",
    "dev:electron": "node scripts/dev-electron.js"
  }
}
```

### 2.3 Create Dev Workflow Script

Create `scripts/dev-electron.js`:

```javascript
#!/usr/bin/env node
/**
 * Dev workflow: Next.js dev server + Electron with hot reload
 * Port Strategy: Fixed port 9002 (simpler approach)
 */

const { spawn } = require('child_process');

const DEV_PORT = 9002;

let nextProcess = null;
let electronProcess = null;
let electronViteProcess = null;

function cleanup() {
  nextProcess?.kill();
  electronViteProcess?.kill();
  electronProcess?.kill();
  process.exit(0);
}

process.on('SIGINT', cleanup);
process.on('SIGTERM', cleanup);

async function startNextDev() {
  return new Promise((resolve, reject) => {
    nextProcess = spawn('npx', ['next', 'dev', '-p', DEV_PORT.toString()], {
      stdio: 'pipe',
      env: { ...process.env, PORT: DEV_PORT.toString() }
    });

    let ready = false;
    nextProcess.stdout.on('data', (data) => {
      const output = data.toString();
      process.stdout.write(`[Next.js] ${output}`);
      if (!ready && (output.includes('Ready') || output.includes('ready'))) {
        ready = true;
        resolve();
      }
    });

    setTimeout(() => {
      if (!ready) reject(new Error('Timeout waiting for Next.js'));
    }, 60000);
  });
}

async function startElectronViteWatch() {
  return new Promise((resolve, reject) => {
    electronViteProcess = spawn('npx', ['electron-vite', 'build', '--watch'], {
      stdio: 'pipe'
    });

    let ready = false;
    electronViteProcess.stdout.on('data', (data) => {
      const output = data.toString();
      process.stdout.write(`[electron-vite] ${output}`);
      if (!ready && output.includes('built in')) {
        ready = true;
        resolve();
      }
    });

    setTimeout(() => {
      if (!ready) reject(new Error('Timeout waiting for electron-vite'));
    }, 30000);
  });
}

async function startElectron() {
  return new Promise((resolve) => {
    electronProcess = spawn('npx', ['electron', '.'], {
      stdio: 'inherit',
      env: { 
        ...process.env, 
        NODE_ENV: 'development',
        NEXT_DEV_PORT: DEV_PORT.toString()
      }
    });
    electronProcess.on('exit', cleanup);
    resolve();
  });
}

async function main() {
  try {
    await startNextDev();           // Step 1: Start web dev server
    await startElectronViteWatch(); // Step 2: Build main/preload with watch
    await startElectron();          // Step 3: Launch Electron
    console.log('Dev workflow running. Press Ctrl+C to stop.');
  } catch (error) {
    console.error('Error:', error.message);
    cleanup();
    process.exit(1);
  }
}

main();
```

### 2.4 Handle Port Coordination (Critical)

**Choose one strategy:**

#### Option A: Fixed Port (Recommended for initial setup)

- Use port 9002 (or your preference) consistently
- Fail with clear error if port is occupied
- Simpler, fewer moving parts

```javascript
// In desktop/main.ts
const DEV_APP_ORIGIN = 'http://localhost:9002';

// In scripts/dev-electron.js
const DEV_PORT = 9002;
```

#### Option B: Dynamic Port (More robust)

- Let Next.js find available port
- Pass port to Electron via environment variable
- More complex but handles port conflicts gracefully

```javascript
// In desktop/main.ts
const devPort = process.env.NEXT_DEV_PORT || '9002';
const DEV_APP_ORIGIN = `http://localhost:${devPort}`;
```

---

## Phase 3: Configure electron-builder

### 3.1 Create electron-builder.config.cjs

Create `electron-builder.config.cjs`:

```javascript
// macOS packaging: electron-builder is the only packager used for .app
const hasNotarizeEnv =
    !!(process.env.APPLE_ID && process.env.APPLE_APP_SPECIFIC_PASSWORD && process.env.APPLE_TEAM_ID) ||
    !!(process.env.APPLE_API_KEY && process.env.APPLE_API_KEY_ID && process.env.APPLE_API_ISSUER);

const hasSigningCredentials = !!(process.env.CSC_NAME || process.env.CSC_LINK);

module.exports = {
  appId: 'com.yourcompany.your-app',
  productName: 'Your App Name',
  mac: {
    icon: 'build-resources/icon.icns',  // Create this file
    hardenedRuntime: true,
    gatekeeperAssess: false,
    // Use ad-hoc signing when no credentials configured
    identity: hasSigningCredentials ? undefined : '-',
    // Disable notarization for local builds
    notarize: hasNotarizeEnv ? {} : false,
  },
  directories: {
    output: 'release',
  },
  asarUnpack: [
    '**/*.node',           // Native modules
    '**/*.wasm',           // WASM files
    '.next/standalone/**/*', // Next.js server must be unpacked
  ],
  files: [
    // electron-vite build output
    'dist/electron/**/*',
    // Next.js standalone output
    '.next/standalone/**/*',
    '.next/standalone/.next/static/**/*',
    '.next/standalone/public/**/*',
    'package.json',
  ],
  extraResources: [],
};
```

**CRITICAL (Vite renderer only):** electron-builder **excludes `dist/` by default** (built-in pattern `!dist{,/**/*}`). If your renderer is built with Vite using the default `outDir: 'dist'`, the packaged app will **not** contain `dist/index.html` or `dist/assets/`, causing a **blank window**. Either:

1. **Explicitly include the renderer output** in `files`, e.g. `'dist/index.html'`, `'dist/assets/**'` (or `'dist/**'` if you want the whole tree), or  
2. **Change Vite’s output directory** (e.g. `build: { outDir: 'renderer' }`) and include `'renderer/**'` in `files`.

See **01a-MACOS_ELECTRON_GUIDE** (“electron-builder configuration”, “CRITICAL: Loading the Renderer”) for the same rule and verification steps.

### 3.2 Create Build Script

Create `scripts/mac-build.sh`:

```bash
#!/bin/bash
# macOS app build: electron-vite → Next.js → electron-builder
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

DO_BUILD=true
DO_CLEAN=true

# Parse arguments
for arg in "$@"; do
  case $arg in
    --no-build) DO_BUILD=false; shift ;;
    --no-clean) DO_CLEAN=false; shift ;;
    --dir) shift ;;
  esac
done

if [ "$DO_CLEAN" = true ]; then
  echo "Cleaning build artifacts..."
  # Only remove dist/electron when building
  if [ "$DO_BUILD" = true ]; then
    rm -rf dist/electron
  fi
  rm -rf release 2>/dev/null || true
fi

if [ "$DO_BUILD" = true ]; then
  echo "Building desktop files with electron-vite..."
  npm run build:desktop

  echo "Building Next.js with standalone output..."
  NODE_ENV=production npm run build

  echo "Copying static assets to standalone directory..."
  if [ -d ".next/static" ]; then
    mkdir -p ".next/standalone/.next/static"
    cp -R .next/static/* ".next/standalone/.next/static/"
  fi

  if [ -d "public" ]; then
    mkdir -p ".next/standalone/public"
    cp -R public/* ".next/standalone/public/"
  fi
fi

echo "Packaging with electron-builder..."
npx electron-builder --mac --dir --config electron-builder.config.cjs

echo "Build complete! Output: release/mac-arm64/"
```

Make executable:

```bash
chmod +x scripts/mac-build.sh
```

---

## Phase 4: Path Resolution in Packaged App

### 4.1 Understand the Asar Layout

When packaged, your app structure is:

```
YourApp.app/Contents/Resources/app.asar/
├── dist/electron/
│   ├── main/
│   │   └── main.js       # package.json "main" points here
│   └── preload/
│       └── preload.js    # Load via relative path
└── .next/standalone/     # Unpacked for child process spawn
```

### 4.2 Update Main Process Paths

In `desktop/main.ts`, use paths relative to `__dirname`:

```typescript
// Preload: from main/ to preload/
const preloadPath = path.join(__dirname, '..', 'preload', 'preload.js');

// Next.js standalone: 3 levels up from main/
// main/ → electron/ → dist/ → asar root
const standaloneDir = path.join(__dirname, '..', '..', '..', '.next', 'standalone');

// Handle unpacked asar in production
let serverScript = path.join(standaloneDir, 'server.js');
if (app.isPackaged) {
  const unpackedDir = standaloneDir.replace('app.asar', 'app.asar.unpacked');
  if (fs.existsSync(path.join(unpackedDir, 'server.js'))) {
    serverScript = path.join(unpackedDir, 'server.js');
  }
}
```

---

## Phase 5: Verification Checklist

### 5.1 Phase 1 Verification (electron-vite build)

- [ ] `npm run build:desktop` completes without errors
- [ ] `dist/electron/main/main.js` exists and is CommonJS
- [ ] `dist/electron/preload/preload.js` exists and is CommonJS
- [ ] Source maps generated (`.js.map` files)
- [ ] `electron` and Node built-ins are external (not bundled)

### 5.2 Phase 2 Verification (Dev workflow)

- [ ] `npm run dev:electron` starts Next.js dev server
- [ ] Electron launches and loads from `http://localhost:9002`
- [ ] Hot reload works for main.ts changes (watch mode rebuilds)
- [ ] Port conflict is handled (or fails gracefully with clear error)

### 5.3 Phase 3 Verification (Packaged app)

- [ ] `./scripts/mac-build.sh --dir` completes successfully
- [ ] `.app` bundle created in `release/mac-arm64/`
- [ ] App launches without errors
- [ ] Window loads and displays content
- [ ] IPC communication works (if implemented)
- [ ] `./scripts/mac-build.sh --no-build` preserves `dist/electron`
- [ ] **macOS (Vite):** No blank screen (check `base: './'` in Vite config)
- [ ] **macOS frameless:** Window uses full vertical space (work area), is draggable by title bar, traffic lights visible, header content does not overlap traffic lights

### 5.4 Path Verification

Add logging to verify paths resolve correctly:

```typescript
// In main.ts during testing
console.log('__dirname:', __dirname);
console.log('Preload path:', preloadPath);
console.log('Standalone dir:', standaloneDir);
console.log('Server script:', serverScript);
console.log('Exists:', fs.existsSync(serverScript));
```

---

## Common Issues and Solutions

### Issue: Port mismatch in development

**Symptom:** Blank window or "Unable to connect" in Electron  
**Cause:** Next.js dev server moved to different port, Electron still targets 9002  
**Fix:** Use fixed port strategy with error handling:

```javascript
// scripts/dev-electron.js
if (error.message.includes('Port') || error.message.includes('in use')) {
  console.error('Port 9002 is required. Run: npm run dev:stop');
}
```

### Issue: Preload script not found in packaged app

**Symptom:** `Unable to load preload script` error  
**Cause:** Wrong relative path in main.ts  
**Fix:** Verify path calculation:

```typescript
// Correct: from dist/electron/main/ to dist/electron/preload/
path.join(__dirname, '..', 'preload', 'preload.js')
```

### Issue: Next.js server won't start in packaged app

**Symptom:** Infinite loading or connection refused  
**Cause:** `asarUnpack` not configured or wrong path  
**Fix:**

```javascript
// electron-builder.config.cjs
asarUnpack: ['.next/standalone/**/*']
```

And verify path resolution with `app.asar.unpacked` fallback.

### Issue: mac-build cleans dist/electron on --no-build

**Symptom:** Packaging fails after successful build  
**Cause:** Clean step removes dist/electron unconditionally  
**Fix:** Modify clean logic:

```bash
# scripts/mac-build.sh
if [ "$DO_BUILD" = true ]; then
  rm -rf dist/electron
fi
```

### Issue: electron-builder can't find main entry

**Symptom:** `Cannot find entry point` error  
**Cause:** package.json "main" doesn't match actual path  
**Fix:** Verify alignment:

```json
// package.json
"main": "dist/electron/main/main.js"
```

Must match electron-vite `outDir` + lib entry structure.

### Issue: Blank screen in packaged app (Vite renderer)

**Symptom:** Window opens but shows blank/empty content.  
**Causes:** (1) Vite emits absolute asset paths (`/assets/...`); under Electron’s `file://` protocol those resolve from the filesystem root and fail. (2) **electron-builder excludes `dist/` by default** — renderer (`dist/index.html`, `dist/assets/`) may not be packaged.  
**Fix:** (1) Set `base: './'` in `vite.config.ts` so script/link hrefs are relative (see §1.2). After `npm run build`, confirm `dist/index.html` uses `./assets/...`, not `/assets/...`. (2) Include the renderer output in electron-builder `files` (e.g. `'dist/index.html'`, `'dist/assets/**'`) or use a different Vite `outDir` (e.g. `renderer/`) and include `'renderer/**'` (see §3.1). See 01a-MACOS_ELECTRON_GUIDE “CRITICAL: Loading the Renderer”.

### Issue: Window not draggable (macOS)

**Symptom:** Cannot move the window by dragging the header.  
**Causes:** (1) Using **both** `frame: false` and `titleBarStyle: 'hiddenInset'` on macOS — they conflict and break dragging. (2) No drag region or interactive elements capturing the drag.  
**Fix:** (1) On macOS use **only** `titleBarStyle: 'hiddenInset'`; use `frame: false` only on Windows/Linux (see §1.3). (2) Add a top bar with `-webkit-app-region: drag` and give all buttons/links in that bar `-webkit-app-region: no-drag` (see §1.4). See 01a-MACOS_ELECTRON_GUIDE “CRITICAL: Window Dragging on macOS”.

### Issue: Content overlaps macOS traffic lights

**Symptom:** Header content sits under the close/minimize/maximize buttons.  
**Cause:** No left padding for the traffic lights area.  
**Fix:** Add ~70–80px left padding (e.g. `pl-20`) to the header when running in Electron (see §1.4).

### Issue: Window not opening to fullest possible height

**Symptom:** Window comes close to full height but leaves a small gap (e.g. 98% of work area).  
**Cause:** Using a percentage of work area height or using `mainWindow.center()` so the window doesn't align with the work area top.  
**Fix:** Use 100% of `workAreaSize.height` for window height and set position from `primaryDisplay.workArea`: pass `x` and `y` to `BrowserWindow` (e.g. `y: workArea.y`, `x: workArea.x + (workArea.width - windowWidth) / 2`) so the window is top-aligned and centered horizontally. Omit `mainWindow.center()` when using explicit positioning (see §1.3).

### Issue: Window too tall (under dock)

**Symptom:** Bottom of window goes under the dock or off-screen.  
**Cause:** Using full display `size` instead of usable area.  
**Fix:** Use `screen.getPrimaryDisplay().workAreaSize` for height; `workAreaSize` excludes menu bar and dock (see §1.3).

---

## Advanced Configuration

### Bytecode Protection (Optional)

Enable V8 bytecode compilation for source protection:

```typescript
// electron.vite.config.ts
import { bytecodePlugin } from 'electron-vite';

export default defineConfig({
  main: {
    plugins: [bytecodePlugin()],
    // ... rest of config
  },
  preload: {
    plugins: [bytecodePlugin()],
    // ... rest of config
  },
});
```

### Multi-Platform Builds

For Windows/Linux builds, extend `electron-builder.config.cjs`:

```javascript
module.exports = {
  // ... existing mac config
  win: {
    target: 'nsis',
    icon: 'build-resources/icon.ico',
  },
  linux: {
    target: 'AppImage',
    icon: 'build-resources/icons',
  },
};
```

### Environment-Specific Configs

Use different configs for dev/prod:

```typescript
// electron.vite.config.ts
export default defineConfig(({ mode }) => ({
  main: {
    build: {
      sourcemap: mode === 'production' ? 'hidden' : true,
      minify: mode === 'production',
    },
  },
  // ...
}));
```

---

## File Summary

| File | Purpose | Status |
|------|---------|--------|
| `.nvmrc` | Lock Node version | Required |
| `desktop/main.ts` | Main process entry | Required |
| `desktop/preload.ts` | Preload script | Required |
| `electron.vite.config.ts` | electron-vite configuration | Required |
| `electron-builder.config.cjs` | Packaging configuration | Required |
| `scripts/dev-electron.js` | Dev workflow script | Required |
| `scripts/mac-build.sh` | macOS build script | Required |
| `build-resources/icon.icns` | App icon | Recommended |
| `src/types/electron-api.d.ts` | TypeScript types | Recommended |

---

## References

- [electron-vite Documentation](https://electron-vite.org/)
- [electron-builder Configuration](https://www.electron.build/configuration.html)
- [Electron Documentation](https://www.electronjs.org/docs/latest/)
- **01a-MACOS_ELECTRON_GUIDE** (same `07-deployment/` folder): Authoritative guide for **UI not displaying** (blank window) and **windowing/dragging** on macOS. Covers: `loadFile()` vs custom protocols; electron-builder **excluding `dist/` by default** and using `renderer/` or explicit `files`; **never** using `frame: false` and `titleBarStyle: 'hiddenInset'` together on macOS (use only `titleBarStyle` on macOS); drag regions and traffic-light padding; verification and troubleshooting. Use 01a when debugging blank window or non-draggable window.
- **Project-specific:** If your repo has a **macOS Window Height Fix** (or similar) implementation guide (e.g. `plans/macos-window-height-fix-implementation-guide.md`), use it for full steps on Vite `base` path, frameless window, `workAreaSize`, drag regions, traffic-light padding, and optional window-control IPC.

---

## Document History

- **2026-02-02 (v1.3):** §1.3 updated for fullest possible height: use `primaryDisplay.workArea` for position (x, y); set `x` and `y` on BrowserWindow so window is top-aligned and centered horizontally; omit `mainWindow.center()` when using explicit positioning; added Common Issue "Window not opening to fullest possible height" and clarified `workAreaSize` vs `workArea` in prose.
- **2026-02-02 (v1.2):** Aligned with 01a-MACOS_ELECTRON_GUIDE: macOS use only `titleBarStyle: 'hiddenInset'` (do not use `frame: false` with it — breaks dragging); added electron-builder `dist/` exclusion warning and Vite renderer `files` guidance (§3.1); added `mainWindow.center()`; expanded blank-screen and window-not-draggable common issues; cross-referenced 01a for UI not displaying and windowing.
- **2026-02-02 (v1.1):** Added Vite base path (§1.2), macOS window sizing and frameless/drag/traffic-lights (§1.3–1.4), verification and common-issues from macOS Window Height Fix implementation guide; reference to project implementation guide.
- **2026-02-01 (v1.0):** Initial generalized workflow based on completed migration

---

## Notes

### Dual Build Support

This workflow enables both:

1. **Web builds:** `npm run build` (Next.js/Vite standard build)
2. **Desktop builds:** `./scripts/mac-build.sh` (electron-vite + electron-builder)

### Development vs Production

| Aspect | Development | Production |
|--------|-------------|------------|
| Renderer | Next.js dev server (`npm run dev`) | Embedded Next.js standalone |
| Main/Preload | electron-vite watch mode | electron-vite build |
| Port | 9002 (or dynamic) | 3000 (embedded server) |
| Hot reload | ✅ Yes | ❌ No |
| DevTools | ✅ Open | ❌ Closed |

### Packaging Policy

**Critical:** Whenever building the macOS app, use **only electron-builder** for packaging. electron-vite is compile-only; it does not package the .app bundle.

Build order:
1. electron-vite builds main/preload → `dist/electron/`
2. Next.js builds with standalone → `.next/standalone/`
3. Copy static assets to standalone
4. electron-builder packages everything → `release/mac-arm64/YourApp.app`
