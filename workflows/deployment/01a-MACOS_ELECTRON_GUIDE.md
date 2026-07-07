# macOS Electron Desktop App Guide v4.5

How to build and package a macOS Electron desktop app for any project.

This guide covers two common packaged architectures:

- A static renderer bundle, such as Vite + React output loaded with `loadFile()`.
- A local production web server, such as a Next.js standalone server spawned by Electron and loaded with `loadURL('http://127.0.0.1:<port>')`.

For static Vite apps, this guide assumes the renderer is bundled to `renderer/` (NOT `dist/` - see critical note below) and loaded in production via `loadFile()`. For server-backed apps, adapt the packaging and verification steps to the actual server bundle and unpacked runtime payload.

Document version: 4.5 (2026-05-23)

> **Note:** Throughout this guide, you'll see placeholders like `<YOUR_APP_NAME>` and `<YOUR_BUNDLE_ID>`. Replace these with your actual project values before running any commands.

## When to use this

- Building or packaging the Electron macOS app (.app, DMG, ZIP)
- Debugging production-only renderer issues (blank window, missing assets)
- Fixing frameless-window dragging (macOS title bar)
- Understanding what must be included in `electron-builder` `files`
- Packaging server-backed desktop apps that spawn a local production server
- Debugging packaged-only runtime failures across Electron main, renderer, and child server layers

## Project configuration

Before using this guide, configure these values in `electron-builder.config.cjs` and update the commands below with your app name.

| Key | Example Value | Your Value |
|---|---|---|
| App name | `Your App Name` | `<YOUR_APP_NAME>` |
| Bundle ID | `com.yourcompany.yourapp` | `<YOUR_BUNDLE_ID>` |
| Build config | `electron-builder.config.cjs` | `electron-builder.config.cjs` |

## Initial setup and dependency installation

### Installing dependencies

Before building, ensure all dependencies are installed:

```bash
npm install
```

### Security best practices

**Always verify package versions exist** before specifying them in `package.json`. Use `npm view <package> version` to check the latest available version:

```bash
# Check latest version of a package
npm view electron-builder version
npm view electron version
npm view tar version
```

**After installation, run a security audit:**

```bash
npm audit
```

If vulnerabilities are found, `npm audit` will report them. Common issues:

- **Transitive dependency vulnerabilities**: Vulnerabilities in packages you don't directly depend on (e.g., `tar` used by `electron-builder` dependencies)
- **Outdated packages**: Packages with known security issues

### Handling transitive dependency vulnerabilities

If `npm audit` reports vulnerabilities in transitive dependencies (dependencies of your dependencies), you may need to use npm overrides to force secure versions.

**Example:** If `tar` package vulnerabilities are reported (common with `electron-builder`):

1. Check the latest secure version:
   ```bash
   npm view tar version
   ```

2. Add an override in `package.json` (use the version from step 1):
   ```json
   {
     "overrides": {
       "tar": "^X.Y.Z"
     }
   }
   ```
   Replace `X.Y.Z` with the actual latest version from `npm view tar version`.

3. Reinstall dependencies:
   ```bash
   npm install
   ```

4. Verify the fix:
   ```bash
   npm audit
   ```

**Why overrides are needed:** Transitive dependencies (like `@electron/rebuild` used by `electron-builder`) may pull in vulnerable versions. Overrides force all instances of a package to use the secure version you specify.

**Important:** Only override to versions that actually exist. If `npm view <PACKAGE_NAME> version` shows `7.5.6` is latest, don't specify `^8.0.0` (it doesn't exist).

### Verifying installation

After installation, verify everything is set up correctly:

```bash
# Check for vulnerabilities (should show 0 after fixes)
npm audit

# Verify Electron dependencies are installed
npm list electron electron-builder

# Test that build scripts work
npm run build
```

If `npm audit` shows vulnerabilities that can't be resolved with overrides, consider:
- Updating the parent package (e.g., `electron-builder`) to a newer version
- Checking if the vulnerability affects your use case (some vulnerabilities may not be exploitable in your context)
- Consulting the package maintainers or security advisories

## Quick start (preflight)

Commands:

```bash
# Fast local build (.app only)
npm run mac:build:dir

# Distribution build (DMG + ZIP)
npm run mac:build

# Launch a built app (replace <YOUR_APP_NAME> with your actual app name)
open "release/mac-arm64/<YOUR_APP_NAME>.app"

# Watch main process logs (replace <YOUR_APP_NAME> with your actual app name)
tail -f "$HOME/Library/Logs/<YOUR_APP_NAME>/main.log"
```

## Choose the production architecture first

Do this before copying commands from the guide. The most common implementation mistakes come from applying a static-renderer checklist to a server-backed app, or the reverse.

| Architecture | Production loading | Packaging focus | Best fit |
|---|---|---|---|
| Static renderer | `BrowserWindow.loadFile()` points at packaged HTML | Include renderer files in `app.asar`; use relative asset paths | Vite/React apps with no server routes at runtime |
| Local server | Spawn a local server from real files on disk, then `loadURL()` to `127.0.0.1` | Unpack the server bundle and all runtime assets/dependencies | Next.js standalone apps or apps that require API routes in the desktop build |

Architecture rules:

- For static renderers, prefer `loadFile()` and avoid custom protocols unless local packaged `fetch()` requires one.
- For local server apps, do not force `loadFile()` if the app needs API routes, server components, or provider code at runtime. Instead, make the server startup path first-class and test it from the packaged `.app`.
- Child processes cannot use virtual `app.asar` paths as `cwd`. Any spawned server, CLI, worker, model bridge, or helper binary must run from real files, usually under `app.asar.unpacked`.
- Treat packaged architecture as a runtime contract. Source tree success does not prove packaged success.

## The Three Critical Decisions

These choices determine whether your app works correctly:

| Decision | Correct Choice | Why |
|----------|----------------|-----|
| **How to load the UI** | Static app: `loadFile()`. Server-backed app: spawn the packaged local server and load `127.0.0.1`. | The correct loader depends on whether the app needs runtime server behavior. |
| **Window frame on macOS** | `titleBarStyle: 'hiddenInset'` (alone) | Use ONLY this. `frame: false` conflicts with it and breaks dragging. Use `frame: false` only on Windows/Linux. |
| **Where runtime files live** | Spawned runtimes and server bundles live outside `app.asar` in unpacked real paths. | `app.asar` is virtual; child processes and some package resolution flows need real files. |
| **How diagnostics are captured** | Add a modular packaged-runtime logger from the first implementation pass. | The initial port moves much faster when every packaged-only failure leaves durable evidence, and a module can be disabled or reduced later. |

**Never:**
- Use `loadURL('app://...')` in production for a basic static renderer
- Spawn a child process with an `app.asar` path as its working directory
- Combine `frame: false` AND `titleBarStyle: 'hiddenInset'` on macOS

Non-negotiables (these prevent most production-only failures):

1. Build with a wrapper script (e.g., `./scripts/mac-build.sh` or `npm run mac:build`) so the pipeline runs in the correct order.
2. Use `npm` (scripts in this guide assume npm; adapt for yarn/pnpm as needed).
3. Static Vite apps must output relative asset paths for packaged apps (`vite.config.ts: base: './'`).
4. `electron-builder` must include the Electron entrypoint, main/preload bundles, and the chosen renderer/server payload.
5. Every implementation must include a modular packaged-runtime logging mechanism for the Electron main process, renderer, child server, and crash/unhandled-error paths.

## What the build script is responsible for

The build script should be the single source of truth for packaging. At minimum it should:

- Clean build artifacts that commonly cause stale packaging (`desktop/*.cjs`, `renderer/`, `release/`).
- Build Electron main/preload (typically via esbuild into `desktop/*.cjs`).
- Build the web UI (`vite build` into `renderer/`) or the production server bundle.
- Prepare any standalone/server runtime payload after the web build and before `electron-builder`.
- Run `electron-builder` in a way that does not produce noisy dependency scan warnings (optional quality-of-life).
- Handle stubborn generated artifacts defensively. If cleanup fails because files are locked or read-only, fix permissions and remove the generated output before rebuilding instead of packaging stale files.

## Required modular runtime logging

Add packaged-runtime logging during the initial port, not after the first packaged failure. The goal is to make the first `.app` launch debuggable from Finder without attaching a terminal or guessing which layer failed.

Design this as a small module, not as scattered `console.log()` calls. The module should be easy to remove, disable, or reduce once the app is stable.

Minimum behavior:

- Write to the platform app logs directory, with a safe fallback if the app log path cannot be resolved.
- Split logs by runtime layer:
  - `main.log` for Electron main-process startup, window creation, navigation, and lifecycle.
  - `renderer.log` for renderer console messages, load failures, unresponsive/responsive transitions, and renderer process exits.
  - `server.log` for local server or child-process stdout/stderr when the app is server-backed.
  - `crash.log` for uncaught exceptions, unhandled rejections, and fatal startup failures.
  - `session-context.json` or equivalent for non-secret startup metadata.
- Capture the packaged app version, Electron/Node versions, platform, architecture, packaged flag, resource paths, resolved server path, selected port, and active renderer URL.
- Redact likely secrets and cap oversized values before writing to disk.
- Keep logging calls behind a narrow API so production code can call `logger.info(scope, message, data)` without knowing file paths.
- Add a clear control surface for later reduction:
  - environment variable, build flag, config value, or app setting for log level;
  - option to disable renderer console capture;
  - option to disable child-process stdout/stderr capture after launch stabilization;
  - retention or truncation policy so logs cannot grow without bound.

Suggested module boundaries:

```text
desktop/logging
  resolveLogDir(productName)
  createLogger({ enabled, level, logDir, redact })
  writeSessionContext(metadata)
  sanitizeLogValue(value)
```

Do not make the initial implementation depend on the renderer being healthy. The main process must be able to log startup and server failures before the UI loads.

Verification for the logging module:

- Launch the packaged `.app` from Finder or `open`.
- Confirm the expected log files are created.
- Confirm a renderer console message reaches `renderer.log`.
- Confirm child server stdout/stderr reaches `server.log` for server-backed apps.
- Confirm an intentional fake secret value is redacted in logs.
- Confirm the disable/reduce switch works without code changes.

## Architecture (what ends up inside the .app)

Electron packages your app into `app.asar`. In production, `__dirname` from `desktop/main.cjs` points to the packaged `desktop/` directory, not the app root.

Typical structure:

```
<YOUR_APP_NAME>.app/
  Contents/
    Resources/
      app.asar/
        index.cjs
        desktop/
          main.cjs              # __dirname points here in production
          preload.cjs
        renderer/               # Vite output (NOT dist/)
          index.html
          assets/
        package.json
```

Rule of thumb: when resolving sibling paths from `desktop/main.cjs`, start with `path.join(__dirname, '..', ...)`.

### Server-backed packaged apps

If the desktop app starts a local production server, the packaged structure is different. The Electron main bundle can still live in `app.asar`, but the spawned server and its runtime files must be unpacked:

```
<YOUR_APP_NAME>.app/
  Contents/
    Resources/
      app.asar/
        index.cjs
        desktop/
          main.cjs
          preload.cjs
        package.json
      app.asar.unpacked/
        <server-build>/
          server entrypoint
          static assets
          public assets
          node_modules needed at runtime
```

Rules for server-backed apps:

- Resolve packaged server paths from `process.resourcesPath` or another packaged-runtime anchor, not from source-tree assumptions.
- Put the server bundle and assets in `asarUnpack` so child processes can use them as a real `cwd`.
- Start the server on `127.0.0.1`, choose an available port, wait for readiness, then load the renderer URL.
- Log the chosen server path, working directory, port, readiness attempts, and startup failures.
- Inspect the built `.app` payload directly. Do not assume framework tracing included every runtime file.

### Runtime dependencies and standalone tracing

Framework standalone outputs can under-copy packages that behave like CLIs, proxies, bridges, or generated bundles. This is especially likely when a package entrypoint imports sibling chunks, reads files by path, spawns another process, or depends on packages hoisted outside its own package directory.

For these packages:

- Keep an explicit list of runtime escape-hatch packages that must exist in the packaged standalone payload.
- Copy the complete dependency closure from the lockfile, not just the top-level package directory.
- Preserve Node's resolution shape: nested dependencies stay nested, hoisted dependencies go where Node would look for them.
- Add regression tests with a fixture that proves a copied package can require both nested and hoisted dependencies.
- After packaging, run a smoke command against the packaged copy, not only against source `node_modules`.

### Provider and credential initialization

Packaged apps often reveal import-order bugs that development hides. Provider factories and server modules should not read credentials, create SDK clients, or validate unrelated providers at module import time.

Guidelines:

- Load required environment or credential sources before initializing providers.
- Initialize provider clients lazily when that provider is selected or called.
- Make provider-selection tests prove that an unrelated missing credential does not break a different provider.
- Treat OAuth/cache state as separate from packaging correctness. Tool discovery may work with stale credentials while the first real generation or write action still fails.
- For OAuth-backed local bridges, provide a probe or reauth flow with enough callback timeout for first-run packaged use.

### Environment variables in packaged apps

Do not assume a packaged macOS app inherits the same environment as a terminal-launched development server. Finder-launched GUI apps commonly miss shell-initialized variables, and server-backed Electron apps can have more than one runtime that needs configuration.

Recommended pattern:

- Decide which process owns each secret or setting: Electron main, preload, renderer, local server, child CLI, or bridge.
- Load environment files or credential stores before importing modules that initialize providers.
- Pass only the variables a child process needs through its `env` option. Do not blindly forward secrets to unrelated children.
- Keep renderer access explicit and minimal. Prefer server/main-process calls over exposing provider keys to browser code.
- Log which sources were checked and which required keys were present, but never log secret values.
- Add a packaged-mode smoke test or launch check that proves the relevant runtime sees the required variables.

Good logging shape:

```text
env.load checked=["$HOME/.env","app/.env.local"] present=["PROVIDER_API_KEY"] missing=[]
```

Bad logging shape:

```text
PROVIDER_API_KEY=sk-...
```

### MCP and external tool bridges

MCP-backed features add two extra packaged-app risks: the bridge package must be complete in the packaged payload, and the user's auth/cache state must be valid at action time.

Checklist:

- Treat MCP bridge packages as runtime escape-hatch packages. Verify the packaged app contains the bridge entrypoint, sibling generated chunks, and transitive dependencies.
- If framework tracing creates a standalone server bundle, copy MCP bridge dependencies from the lockfile dependency graph rather than a hardcoded package folder.
- Preserve hoisted dependency layout so Node resolution in the packaged server matches development.
- Start MCP bridges from the same working directory they will use in the packaged app.
- Give first-run OAuth flows enough callback time for a browser authorization round trip.
- Provide a no-spend probe when the upstream service supports it. Tool discovery alone is not a complete readiness check.
- Distinguish packaging failures from auth failures: missing modules, missing files, and spawn errors are packaging issues; expired tokens and denied scopes are auth/cache issues.
- Log bridge command, cwd, endpoint, exit code, stderr summary, tool-list success, action request IDs, and auth/cache remediation hints. Redact tokens and authorization headers.

## electron-builder configuration (must-have)

In `electron-builder.config.cjs`, ensure these are true:

- `files` includes `index.cjs`, `desktop/main.cjs`, `desktop/preload.cjs`, and the renderer build directory.
- Server-backed apps include or unpack the server bundle, static assets, public assets, and runtime dependency directories needed by the child server.
- Local builds should succeed without Apple credentials (ad-hoc signing + notarization disabled).

> **⚠️ SECURITY WARNING**: Ad-hoc signing (`identity: '-'`) and disabled notarization are for **local development only**. Production builds MUST use a valid Apple Developer identity and enable notarization. See [Code signing and notarization (macOS)](#code-signing-and-notarization-macos) for proper production signing configuration.

**CRITICAL: electron-builder excludes `dist/` by default.** The default file patterns include `!dist{,/**/*}` which excludes any directory named `dist`. If you use Vite's default output directory (`dist/`), your renderer will NOT be packaged.

**Solution:** Configure Vite to output to a different directory (e.g., `renderer/`):

```ts
// vite.config.ts
export default defineConfig(() => ({
  base: './',
  build: {
    outDir: 'renderer',
  },
}));
```

Example electron-builder config (trim to what you actually ship):

```js
module.exports = {
  appId: '<YOUR_BUNDLE_ID>',
  productName: '<YOUR_APP_NAME>',
  files: [
    'index.cjs',
    'desktop/main.cjs',
    'desktop/preload.cjs',

    // Vite renderer build (NOT dist/ - that's excluded by default!)
    'renderer/**',

    'package.json'
  ],
  asarUnpack: [
    // Add server/runtime payloads here when the app spawns local child processes.
    // Examples: standalone server output, static assets, public assets, helper binaries.
  ],
  mac: {
    icon: 'build-resources/icon.icns',
    hardenedRuntime: true,
    gatekeeperAssess: false,
    identity: '-',
    notarize: false
  }
};
```

---

## CRITICAL: Loading the Renderer in Production

This section explains how to load the renderer UI in packaged Electron apps. **This is the #1 cause of "blank window" bugs.**

### Static apps: use `loadFile()` (Recommended)

**Use `loadFile()` for production static-renderer builds.** It is simpler and more reliable than custom protocols.

```ts
// desktop/main.ts
import { app, BrowserWindow } from 'electron';
import path from 'path';

function createWindow() {
  const mainWindow = new BrowserWindow({
    // ... window options
  });

  if (app.isPackaged) {
    // PRODUCTION: Load from packaged renderer directory
    // __dirname is desktop/, so go up one level to find renderer/
    mainWindow.loadFile(path.join(__dirname, '..', 'renderer', 'index.html'));
  } else {
    // DEVELOPMENT: Load from Vite dev server
    mainWindow.loadURL('http://localhost:5173');
  }
}
```

### DO NOT use `loadURL()` with custom protocols for basic apps

Custom protocols (`app://`) require additional setup and are a common source of bugs. Only use them if you need `fetch()` to access packaged files.

**Common mistake:**
```ts
// BAD: This requires a protocol handler that may not be set up correctly
mainWindow.loadURL('app://localhost/index.html');
```

**Correct approach:**
```ts
// GOOD: Direct file loading - simple and reliable
mainWindow.loadFile(path.join(__dirname, '..', 'renderer', 'index.html'));
```

### Vite Configuration Requirements

For `loadFile()` to work, Vite MUST output relative asset paths:

```ts
// vite.config.ts
export default defineConfig(() => ({
  base: './',  // CRITICAL: Use relative paths, not absolute
  build: {
    outDir: 'renderer',  // CRITICAL: NOT 'dist' (excluded by electron-builder)
  },
}));
```

**Verification:** After building, check `renderer/index.html`. Asset paths must start with `./`:
```html
<!-- GOOD -->
<script type="module" src="./assets/index-abc123.js"></script>

<!-- BAD - will fail in packaged app -->
<script type="module" src="/assets/index-abc123.js"></script>
```

### When to use custom `app://` protocol

Only use custom protocols if your app needs to `fetch()` packaged local files (e.g., JSON data files). For most apps, `loadFile()` is sufficient.

If you do need custom protocols, see the "Loading packaged local files" section below.

### Server-backed apps: use a local server URL

If the packaged app requires server routes at runtime, do not rewrite it into a static `loadFile()` app just to match this guide. Start the packaged server from an unpacked real directory, wait for readiness, then load the local URL:

```ts
// Pseudocode only: adapt paths and commands to your framework.
const appUrl = await startPackagedServerFromUnpackedPayload();
await mainWindow.loadURL(appUrl);
```

Server-backed rules:

- Bind to `127.0.0.1`, not a public interface.
- Pick an available port; if the preferred port is busy, fall back to an ephemeral port and log it.
- Wait for a health check before loading the BrowserWindow.
- Pipe child-process stdout/stderr into persistent logs.
- Kill the child process during app quit.
- Verify packaged server startup through the final `.app`, not only through `npm run build`.

---

## CRITICAL: Window Dragging on macOS

This section explains how to create draggable frameless windows on macOS. **This is the #2 cause of bugs.**

### Platform-Specific Window Configuration

**NEVER use `frame: false` and `titleBarStyle: 'hiddenInset'` together.** They conflict on macOS.

| Setting | What it does | Use for |
|---------|--------------|---------|
| `titleBarStyle: 'hiddenInset'` | Hides title bar but keeps native traffic lights (close/minimize/maximize) | macOS apps with native feel |
| `frame: false` | Completely removes the native window frame | Windows/Linux apps with custom title bar |

**Correct pattern - platform-specific configuration:**

```ts
// desktop/main.ts
import { app, BrowserWindow } from 'electron';
import path from 'path';

function createWindow() {
  const isMac = process.platform === 'darwin';

  const mainWindow = new BrowserWindow({
    width: 1400,
    height: 900,
    
    // Platform-specific window frame configuration
    // CRITICAL: Do NOT use both frame:false AND titleBarStyle together!
    ...(isMac
      ? { 
          // macOS: Keep native traffic lights, hide title bar text
          titleBarStyle: 'hiddenInset'
        }
      : { 
          // Windows/Linux: Fully custom title bar
          frame: false,
          titleBarOverlay: {
            color: '#1a1a2e',      // Customize to match your app's theme
            symbolColor: '#ffffff', // Customize to match your app's theme
            height: 38
          }
        }
    ),
    
    backgroundColor: '#1a1a2e',  // Customize to match your app's background
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      preload: path.join(__dirname, 'preload.cjs')
    }
  });

  // Load renderer (see previous section)
  if (app.isPackaged) {
    mainWindow.loadFile(path.join(__dirname, '..', 'renderer', 'index.html'));
  } else {
    mainWindow.loadURL('http://localhost:5173');
  }
}
```

### Expose Platform to Renderer

The renderer needs to know the platform to apply correct styling:

```ts
// desktop/preload.ts
import { contextBridge, ipcRenderer } from 'electron';

contextBridge.exposeInMainWorld('electronAPI', {
  minimize: () => ipcRenderer.send('minimize-window'),
  maximize: () => ipcRenderer.send('maximize-window'),
  close: () => ipcRenderer.send('close-window'),
  platform: process.platform  // 'darwin', 'win32', or 'linux'
});
```

### CSS for Drag Regions

Add these styles to your CSS:

```css
/* Invisible drag bar at top of window - enables dragging */
.window-drag-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 38px;
  z-index: 9999;
  background: transparent;
  -webkit-app-region: drag;
}

/* Make the app container draggable */
.app-drag-region {
  -webkit-app-region: drag;
}

/* CRITICAL: All interactive elements must be no-drag */
.app-drag-region button,
.app-drag-region a,
.app-drag-region input,
.app-drag-region select,
.app-drag-region textarea,
.app-drag-region [role="button"],
.no-drag {
  -webkit-app-region: no-drag;
}

/* Add padding for content below the drag bar */
.app-container {
  padding-top: 38px;
}

/* macOS: Add left padding to header for traffic lights (close/min/max buttons) */
body.electron-macos .app-header {
  padding-left: 80px;
}

/* macOS: Hide custom window controls (use native traffic lights instead) */
body.electron-macos .window-controls {
  display: none;
}

/* Custom window controls for Windows/Linux */
.window-controls {
  position: fixed;
  top: 0;
  right: 0;
  display: flex;
  z-index: 10000;
  -webkit-app-region: no-drag;
}

.window-btn {
  width: 46px;
  height: 38px;
  border: none;
  background: transparent;
  color: var(--text-secondary);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.window-btn:hover {
  background: var(--bg-surface-hover);
}

.window-btn.close-btn:hover {
  background: #e81123;
  color: white;
}
```

### HTML Structure

```html
<body class="light-mode">
  <!-- Invisible drag bar at top -->
  <div class="window-drag-bar"></div>
  
  <div class="app-container app-drag-region">
    <!-- Custom window controls (hidden on macOS via CSS) -->
    <div class="window-controls no-drag">
      <button id="minimizeBtn" class="window-btn"><i class="fas fa-minus"></i></button>
      <button id="maximizeBtn" class="window-btn"><i class="fas fa-expand"></i></button>
      <button id="closeBtn" class="window-btn close-btn"><i class="fas fa-times"></i></button>
    </div>
    
    <!-- Header with no-drag to allow button clicks -->
    <header class="app-header no-drag">
      <!-- header content -->
    </header>
    
    <!-- Rest of app -->
  </div>
</body>
```

### JavaScript: Detect Platform and Wire Controls

```ts
// In your main app initialization
document.addEventListener('DOMContentLoaded', () => {
  // Detect macOS Electron environment for platform-specific CSS
  if (typeof window.electronAPI !== 'undefined') {
    const platform = (window.electronAPI as any).platform;
    if (platform === 'darwin') {
      document.body.classList.add('electron-macos');
    }
  }

  // Wire up window controls (only used on Windows/Linux)
  const minimizeBtn = document.getElementById('minimizeBtn');
  const maximizeBtn = document.getElementById('maximizeBtn');
  const closeBtn = document.getElementById('closeBtn');

  if (minimizeBtn && typeof window.electronAPI !== 'undefined') {
    minimizeBtn.addEventListener('click', () => window.electronAPI.minimize());
  }
  if (maximizeBtn && typeof window.electronAPI !== 'undefined') {
    maximizeBtn.addEventListener('click', () => window.electronAPI.maximize());
  }
  if (closeBtn && typeof window.electronAPI !== 'undefined') {
    closeBtn.addEventListener('click', () => window.electronAPI.close());
  }
});
```

### Common Dragging Mistakes

| Mistake | Result | Fix |
|---------|--------|-----|
| Using `frame: false` on macOS | No traffic lights, inconsistent drag behavior | Use `titleBarStyle: 'hiddenInset'` on macOS |
| Using both `frame: false` AND `titleBarStyle` | Conflicting settings, drag doesn't work | Use one or the other based on platform |
| Missing `no-drag` on buttons | Buttons don't respond to clicks | Add `.no-drag` class or use CSS selector |
| No `padding-top` on app container | Content hidden behind drag bar | Add `padding-top: 38px` |
| No `padding-left` on header (macOS) | Header content overlaps traffic lights | Add `padding-left: 80px` when on macOS |

---

## Window Sizing Considerations

Default window dimensions can cause UI cropping on modern high-resolution displays. This section explains how to size windows appropriately.

### The Problem

A fixed window height (e.g., `height: 900`) may appear cropped on displays where:
- The available vertical space (minus menu bar and dock) is less than the window height
- The app's UI requires more vertical space than anticipated
- Users have large dock sizes or multiple menu bars

**Symptom:** UI appears vertically cut off, with content or controls hidden at the bottom of the window.

### Recommended Approach

1. **Set reasonable fallback dimensions** that fit most displays:

```ts
const mainWindow = new BrowserWindow({
  width: 1400,
  height: 1100,  // Increased from 900 to accommodate more displays
  minWidth: 1200,
  minHeight: 800,
  // ...
});
```

2. **Center non-maximized windows** after creation to ensure they're positioned correctly:

```ts
mainWindow.center();
```

3. **Use screen dimensions** for dynamic fallback sizing:

```ts
import { screen } from 'electron';

function createWindow() {
  const { width: screenWidth, height: screenHeight } = screen.getPrimaryDisplay().workAreaSize;
  
  // Use percentage of screen, with min/max constraints
  const windowWidth = Math.min(Math.max(screenWidth * 0.8, 1200), 1600);
  const windowHeight = Math.min(Math.max(screenHeight * 0.85, 800), 1200);
  
  const mainWindow = new BrowserWindow({
    width: windowWidth,
    height: windowHeight,
    minWidth: 1200,
    minHeight: 800,
    // ...
  });
  
  mainWindow.center();
}
```

4. **Use native maximize when that is the intended startup state.**

On macOS, if the desired behavior is "open maximized but not fullscreen," prefer Electron's native maximize flow over a larger fixed height:

```ts
mainWindow.once('ready-to-show', () => {
  if (process.platform === 'darwin') {
    mainWindow.maximize();
  } else {
    mainWindow.center();
  }

  mainWindow.show();
});
```

This keeps the window in the available work area and preserves native traffic lights. Do not call `center()` in the same presentation path after maximizing.

### Common Sizing Mistakes

| Mistake | Result | Fix |
|---------|--------|-----|
| Fixed height too tall for display | Window extends below screen, content cut off | Use `screen.getPrimaryDisplay().workAreaSize` or reduce default height |
| Fixed max height too short for large displays | App opens with unused vertical space | Use native maximize for macOS when maximized startup is desired |
| No `minWidth`/`minHeight` | Window can be resized to unusable dimensions | Set minimum constraints |
| Not calling `center()` | Window positioned at (0,0), may be partially off-screen | Call `mainWindow.center()` after creation |
| Centering after maximize | Native maximized state can be disturbed or made ambiguous | Choose either maximize or center for a given startup path |
| Ignoring `workAreaSize` vs `size` | Window overlaps dock/taskbar | Use `workAreaSize` (excludes system UI) not `size` |

### Testing Window Sizing

Test your app on displays with different characteristics:
- Standard laptop displays (13-15")
- High-resolution external monitors
- Displays with large dock/taskbar configurations
- Multiple monitor setups
- Native maximize startup, if supported by the app

Log the presentation path (`center` vs `maximize`) and final bounds during packaged startup. This makes it clear whether a screenshot or user report reflects the intended native state.

---

## CRITICAL: Build Script Configuration

This section explains how to correctly configure esbuild for Electron. **This is the #3 cause of launch crashes.**

### The Module Format Problem

When your `package.json` has `"type": "module"`, Node.js treats all `.js` files as ES modules. This creates conflicts with Electron's main process, which often works better with CommonJS.

**The solution:** Use CommonJS format (`.cjs` files) for all Electron main process code.

### Entry Point Configuration

Your project needs a CommonJS entry point that Electron can load:

```javascript
// index.cjs - CommonJS entry point
require('./desktop/main.cjs');
```

**CRITICAL:** The entry point must use `require()`, not `import`. If `package.json` has `"type": "module"`, an ES module entry point (`index.js` with `import`) cannot import CommonJS files.

Update `package.json`:
```json
{
  "type": "module",
  "main": "index.cjs"  // NOT index.js
}
```

### esbuild Configuration (Programmatic)

When using esbuild programmatically to compile TypeScript:

```typescript
// scripts/build-desktop.ts
import * as esbuild from 'esbuild';

const commonOptions: esbuild.BuildOptions = {
    bundle: true,
    platform: 'node',
    target: 'node20',        // Match your Electron's Node.js version (check with `npx electron -v`)
    format: 'cjs',           // CRITICAL: Use CommonJS for Electron
    sourcemap: true,
    external: ['electron'],
    outdir: 'desktop',       // Or your preferred output directory for Electron files
    // NOTE: Do NOT add a banner for __dirname - see warning below
};

// Build main process
await esbuild.build({
    ...commonOptions,
    entryPoints: ['desktop/main.ts'],
    outExtension: { '.js': '.cjs' },  // CRITICAL: .cjs extension
});

// Build preload script
await esbuild.build({
    ...commonOptions,
    entryPoints: ['desktop/preload.ts'],
    outExtension: { '.js': '.cjs' },  // CRITICAL: .cjs extension
});
```

### esbuild Configuration (CLI)

If using esbuild via CLI in `package.json`:

```json
{
  "scripts": {
    "build:electron": "esbuild desktop/main.ts desktop/preload.ts --platform=node --target=node20 --bundle --outdir=desktop --format=cjs --external:electron --out-extension:.js=.cjs"
  }
}
```

> **Note:** Adjust `--target=node20` to match your Electron's Node.js version. Check with `npx electron --version` and refer to [Electron releases](https://releases.electronjs.org/) to find the bundled Node.js version.

### WARNING: Do NOT Use __dirname Banner with CommonJS

**NEVER add a banner to inject `__dirname` when using `format: 'cjs'`:**

```typescript
// BAD - This will crash with "Identifier '__dirname' has already been declared"
const commonOptions = {
    format: 'cjs',
    banner: {
        js: 'const __dirname = require("path").dirname(__filename);',  // WRONG!
    },
};
```

**Why this crashes:** In CommonJS, `__dirname` and `__filename` are already global variables provided by Node.js. Attempting to redeclare them with `const` causes a SyntaxError.

**When to use the banner:** Only when building ESM output (`format: 'esm'`) that needs `__dirname`:

```typescript
// ONLY for ESM builds (not recommended for Electron main process)
const esmOptions = {
    format: 'esm',
    banner: {
        js: 'import { dirname } from "path"; import { fileURLToPath } from "url"; const __filename = fileURLToPath(import.meta.url); const __dirname = dirname(__filename);',
    },
};
```

### electron-builder Files Array

Ensure `electron-builder.config.cjs` includes the correct files:

```javascript
module.exports = {
    files: [
        'index.cjs',           // Entry point (CommonJS)
        'desktop/main.cjs',    // Main process (CommonJS)
        'desktop/preload.cjs', // Preload script (CommonJS)
        'renderer/**',         // Vite output (NOT dist/)
        'package.json',
        
        // Exclude old .js files if migrating from ESM
        '!desktop/**/*.js',
    ],
};
```

### Complete Module Chain

For a working Electron app with `"type": "module"` in `package.json`:

```
package.json ("main": "index.cjs")
    └── index.cjs (CommonJS: require('./desktop/main.cjs'))
        └── desktop/main.cjs (esbuild output, format: 'cjs')
            └── desktop/preload.cjs (esbuild output, format: 'cjs')
```

All files in the chain use CommonJS, avoiding ESM/CJS interop issues.

---

## Loading packaged local files (optional)

Many projects load the UI via `file://` + `loadFile()`. That works well as long as the renderer does not rely on `fetch()` to read packaged local files.

If you later add code that does `fetch('./some-file.json')` (or similar) and it fails only in packaged builds, switch to a custom `app://` protocol in production.

Minimal pattern:

```ts
// desktop/main.ts
import { app, protocol } from 'electron';
import path from 'path';
import { pathToFileURL } from 'url';

// eslint-disable-next-line @typescript-eslint/no-var-requires
const { net } = require('electron');

protocol.registerSchemesAsPrivileged([
  {
    scheme: 'app',
    privileges: {
      standard: true,
      secure: true,
      supportFetchAPI: true,
      corsEnabled: true
    }
  }
]);

app.whenReady().then(() => {
  if (app.isPackaged) {
    const publicDir = path.join(__dirname, '..', 'public');

    protocol.handle('app', (request) => {
      const url = new URL(request.url);
      const pathname = decodeURIComponent(url.pathname);
      const absolutePath = path.join(publicDir, pathname);
      return net.fetch(pathToFileURL(absolutePath).href);
    });
  }
});
```

Then load your UI from `app://` (packaged builds only):

```ts
await win.loadURL('app://localhost/index.html');
```

---

## Code signing and notarization (macOS)

Local development:

- Expect Gatekeeper warnings.
- Keep `mac.identity: '-'` and `mac.notarize: false` so local builds succeed without Apple credentials.

Distribution:

- Use Developer ID signing + notarization.
- Add an `afterSign` hook and provide Apple credentials via environment variables.

Minimal `afterSign` hook wiring:

```js
// electron-builder.config.cjs
module.exports = {
  // ...
  afterSign: 'build-resources/notarize.cjs'
};
```

Credentials (choose one approach; keep it consistent in CI):

- `APPLE_ID` + `APPLE_ID_PASSWORD` + `APPLE_TEAM_ID`, or
- `APPLE_API_KEY` + `APPLE_API_KEY_ID` + `APPLE_API_ISSUER`

---

## Troubleshooting (high-signal)

When in doubt, start by tailing the main log (replace `<AppName>` with your actual app name):

```bash
tail -f "$HOME/Library/Logs/<AppName>/main.log"
```

For server-backed apps, tail all runtime layers:

```bash
tail -f "$HOME/Library/Logs/<AppName>/main.log"
tail -f "$HOME/Library/Logs/<AppName>/renderer.log"
tail -f "$HOME/Library/Logs/<AppName>/server.log"
tail -f "$HOME/Library/Logs/<AppName>/crash.log"
```

If the app does not create these files yet, add logging before continuing deep debugging. Packaged Electron failures need durable evidence from the main process, renderer process, child server, and crash/unhandled-error paths. Console-only output is not enough once the app is launched from Finder.

The logger should be modular and controllable. If a stable production release does not need full verbose capture, reduce log level or disable noisy streams through the logging module's switch rather than deleting diagnostics from unrelated runtime code.

Common failures and the single fix that matters:

| Symptom | Usually means | Fix |
|---|---|---|
| No log files after packaged launch | Logging was skipped or tied to a healthy renderer | Add the required main-process logging module before deeper debugging |
| Logs contain secrets | Redaction is missing or values are logged too broadly | Redact likely secret keys/headers and log presence/shape instead of raw values |
| Logs grow too large | No retention, truncation, or log-level control | Add size caps, rotation/truncation, and a disable/reduce switch |
| Static app opens but is blank | renderer assets not loading | Use `loadFile()` (not `loadURL`), confirm `vite.config.ts: base: './'`, check path is `path.join(__dirname, '..', 'renderer', 'index.html')` |
| Server-backed app quits before showing UI | Child server path or `cwd` points inside `app.asar` | Unpack the server payload and spawn it from a real path under `app.asar.unpacked` |
| Server-backed app opens but routes/API fail | Packaged server did not start or is on a different port | Log port selection, readiness attempts, server stdout/stderr, and load the resolved `127.0.0.1` URL |
| App throws on launch | `renderer/index.html` missing in packaged app | Confirm Vite outputs to `renderer/` (NOT `dist/`), and `electron-builder` includes `renderer/**` |
| `dist/` not in asar | electron-builder excludes `dist/` by default | **Change Vite output to `renderer/`** - the default patterns exclude `!dist{,/**/*}` |
| "Cannot find module index.cjs" | not packaged | Add `index.cjs` to `electron-builder` `files` |
| `ERR_MODULE_NOT_FOUND` from a packaged bridge/CLI/helper package | Standalone tracing copied only part of a runtime package | Copy the full lockfile dependency closure for explicit runtime packages into the standalone payload |
| Missing module only in packaged app, not dev | Dependency was hoisted in source `node_modules` but absent from packaged runtime tree | Preserve Node's package resolution layout when copying runtime dependencies; verify with a packaged require/import smoke |
| **ERR_MODULE_NOT_FOUND: Cannot find module desktop/main.js** | Entry point is ESM but importing CommonJS | Use CommonJS entry point (`index.cjs` with `require()`) - see "Build Script Configuration" section |
| **SyntaxError: Identifier '__dirname' has already been declared** | esbuild banner redeclaring CommonJS global | Remove `banner` from esbuild config when using `format: 'cjs'` - CommonJS provides `__dirname` automatically |
| Stuck on "Loading..." (packaged) | `fetch()` blocked by `file://` | Use `app://` custom protocol (only if using fetch for local files) |
| "Provider gemini is not available" (packaged) | API key not present at runtime in Electron main process | Load `.env` in the **main process** before provider initialization (GUI apps often don't inherit shell env); verify main logs show providers registered |
| Unselected provider breaks selected provider | Provider module reads credentials or creates clients at import time | Initialize providers lazily and test provider selection with unrelated credentials absent |
| MCP/OAuth tool list works but generation fails | Stale local OAuth cache or action-specific auth failure | Run a no-spend action preflight when available, support reauth/cache reset, and log upstream request IDs |
| Window not draggable (macOS) | Wrong frame config or conflicting settings | Use ONLY `titleBarStyle: 'hiddenInset'` on macOS (NOT `frame: false`) |
| Window not draggable (Windows) | Missing drag CSS | Add `.window-drag-bar` with `-webkit-app-region: drag` |
| Buttons don't work in header | Missing no-drag | Add `.no-drag` class to buttons or use CSS selector |
| Content hidden behind drag bar | Missing padding | Add `padding-top: 38px` to app container |
| Header overlaps traffic lights | Missing left padding on macOS | Add `padding-left: 80px` to header when `electron-macos` class is present |
| UI appears vertically cropped | Window height exceeds available display space | Reduce default height (e.g., 1100 instead of 900), use `screen.getPrimaryDisplay().workAreaSize`, call `mainWindow.center()` |
| macOS app opens with unused vertical space | Fixed fallback height is being used where native maximize was intended | Call `maximize()` before `show()` for the macOS startup path and skip `center()` there |
| Rebuild keeps old behavior | Stale generated output survived cleanup | Remove stale `release/`, Electron bundles, framework build output, and standalone payloads before packaging |
| `electron-builder` dependency scan noise | npm optional deps confusion | Build via the repo wrapper (or pin toolchain) |

### Provider/API key errors in packaged apps

If your renderer routes AI calls through IPC (keys kept in the main process), a packaged macOS app can fail with provider-not-available errors even though things work in dev.

Most common cause:

- The main process never loads `.env` files, and macOS GUI apps often **do not inherit your terminal environment**.

Fix pattern:

- In Electron **main process startup**, load `.env` from one or more known locations (for example: `~/.env`, app working dir `.env`, `.env.local`, `/etc/<app>/.env`) and copy values into `process.env`.
- Initialize providers only *after* this env load.
- If the app spawns a local server or bridge, explicitly pass the required env keys into that child process.
- Keep renderer exposure minimal; do not bridge raw API keys into browser globals.
- Verify via `$HOME/Library/Logs/<AppName>/main.log` that the env loader ran and the provider(s) registered.

**Debugging tip:** Use `npx asar list "<app>.app/Contents/Resources/app.asar"` to verify what's actually packaged.

### MCP failures in packaged apps

When an MCP-backed feature fails only in the packaged app, separate the investigation into three layers:

1. **Packaging:** Is the MCP bridge entrypoint and full dependency closure present in `app.asar.unpacked` or the standalone server payload?
2. **Process startup:** Does the packaged bridge launch from the same `cwd`, endpoint, and environment the app will use?
3. **Auth/action readiness:** Does a real or no-spend action work, not just `tools/list`?

Use logs to classify the failure:

- `Cannot find module`, missing sibling chunks, `ENOENT`, `ENOTDIR`, or immediate bridge exit usually means packaging/runtime layout.
- `401`, expired token, denied scope, or browser login timeout usually means OAuth/cache state.
- Tool discovery success with action failure means the bridge is reachable, but auth, payload shape, quota, or upstream action behavior still needs verification.

---

## Verification checklist

Build and inspect:

```bash
npm run mac:build:dir
ls -la "release/mac-arm64/<AppName>.app/Contents/Resources/"
npx asar list "release/mac-arm64/<AppName>.app/Contents/Resources/app.asar"

# Verify renderer is packaged (CRITICAL - must see renderer/ directory):
npx asar list "release/mac-arm64/<AppName>.app/Contents/Resources/app.asar" | grep renderer
```

For server-backed apps, also inspect the unpacked payload:

```bash
find "release/mac-arm64/<AppName>.app/Contents/Resources/app.asar.unpacked" -maxdepth 4 -type f | head -100

# Verify the server entrypoint and runtime escape-hatch packages exist in the packaged payload.
# Replace the paths with your actual server output and package names.
test -f "release/mac-arm64/<AppName>.app/Contents/Resources/app.asar.unpacked/<server-build>/<server-entrypoint>"
test -d "release/mac-arm64/<AppName>.app/Contents/Resources/app.asar.unpacked/<server-build>/node_modules/<runtime-package>"
```

Run and watch logs:

```bash
open "release/mac-arm64/<AppName>.app"
tail -f "$HOME/Library/Logs/<AppName>/main.log"
```

### Critical Checks (must pass)

1. **Architecture is correct** - Static apps load packaged files; server-backed apps start the packaged local server from unpacked real files
2. **UI displays correctly** - Not just a colored background
3. **Modular runtime logger exists** - Diagnostics are implemented through a reusable logging module, not scattered one-off console writes
4. **Runtime logs exist** - Main, renderer, server if applicable, crash/unhandled-error, and startup context logs are written to the macOS app logs directory
5. **Logging controls work** - Log level, noisy stream capture, or full diagnostics can be disabled/reduced without deleting instrumentation code
6. **Log output is safe** - Secret values are redacted and oversized payloads are capped
7. **Packaged payload is complete** - Inspect `app.asar` and `app.asar.unpacked`; do not rely only on source tree or build success
8. **Server-backed routes work (if applicable)** - API routes/provider calls succeed from the packaged app, not only from dev
9. **Runtime package bridges work (if applicable)** - Packaged CLI/proxy/helper packages can run and load their transitive dependencies
10. **Environment variables are proven in the right process** - Main, child server, bridge, and renderer each receive only the configuration they need
11. **Credentials/auth are proven separately** - Provider selection, env loading, OAuth/cache state, and real action calls are each verified
12. **MCP flows are verified beyond discovery (if applicable)** - Bridge startup, auth/cache, no-spend probe where available, and real action behavior are checked separately
13. **Window startup state is intended** - Centered fallback or native maximize is logged and visually verified; maximized is not fullscreen
14. **Window is draggable** - Click and drag on the title bar area (verify `titleBarStyle: 'hiddenInset'` is set on macOS, NOT `frame: false`)
15. **Traffic lights work (macOS)** - Close/minimize/maximize buttons in top-left
16. **Buttons are clickable** - Theme toggle, other header buttons respond to clicks (verify `-webkit-app-region: no-drag` on interactive elements)
17. **No content hidden** - Header is not overlapped by traffic lights or cut off (verify spacing around native controls)
18. **Generated artifacts are ignored** - `release/`, unpacked `.app`, packaged archives, and compiled Electron bundles are not accidentally staged

### If UI is blank:
1. Check main log: `tail -f "$HOME/Library/Logs/<AppName>/main.log"`
2. Verify asar contains renderer: `npx asar list "<app>.app/Contents/Resources/app.asar" | grep renderer`
3. For static apps, confirm `loadFile()` is used (not `loadURL('app://...')`)
4. For server-backed apps, confirm the local server started, passed readiness, and the BrowserWindow loaded the resolved local URL

### If window won't drag:
1. Confirm `titleBarStyle: 'hiddenInset'` is set on macOS
2. Verify no `frame: false` on macOS BrowserWindow config
3. Check CSS has `.window-drag-bar` with `-webkit-app-region: drag`

### If a packaged-only module is missing:

1. Search the app logs for the first missing module and require stack.
2. Inspect `app.asar.unpacked` to see whether the package and its transitive dependencies are actually present.
3. Check whether the dependency is hoisted in source `node_modules`.
4. Update the standalone/runtime copy step to use the lockfile dependency graph.
5. Add a regression test that reproduces the missing nested or hoisted dependency shape.

---

## Prevent committing binaries (required)

Built Electron artifacts are large and must not be committed. Verify these entries exist in `.gitignore`:

```gitignore
# Electron builds
release/
*.app
*.dmg
*.zip
*.asar
```

**Verification:** After running a build, confirm `release/` is not staged:

```bash
git status
# release/mac-arm64/<AppName>.app should NOT appear
```

If `release/` appears, remove it:
```bash
git rm --cached -r release/
echo "release/" >> .gitignore
```

---

## Update logs (after code changes)

**Important:** Only update logs for completed tasks that change or affect the project's code.

When build configuration changes or build issues are encountered and fixed:

**1. Update the changelog** with a dated entry: `- YYYY-MM-DD: [description of changes]`.
  - Use your project's changelog location (commonly `CHANGELOG.md` or `docs/CHANGELOG.md`)

**2. Add a troubleshooting entry** (if bugs or issues were encountered):
  - Document the issue in your project's troubleshooting system
  - Include: Date, Category, Status, Symptom, Root Cause, Fix, Verification, Notes/Lessons

> **Note:** The specific file locations and formats depend on your project's documentation conventions. Adapt the above to match your project's structure.

---

## Document history

| Version | Date | Notes |
|---|---|---|
| 4.5 | 2026-05-23 | **SERVER-BACKED PACKAGING & RUNTIME DEBUGGING:** Generalized the guide beyond static Vite apps to include local-server packaged apps; documented `app.asar.unpacked` child-process requirements, standalone runtime dependency closure checks, required modular runtime logging with disable/reduce controls, packaged environment-variable handling, MCP bridge/OAuth verification, native maximize startup, and packaged-payload inspection |
| 4.4 | 2026-01-24 | **WINDOW SIZING:** Added new "Window Sizing Considerations" section; documented common issue where fixed window height causes UI cropping on displays with limited vertical space; added recommendations for dynamic sizing using `screen.getPrimaryDisplay().workAreaSize`; added common sizing mistakes table |
| 4.3 | 2026-01-23 | **CRITICAL BUILD CONFIG & PACKAGED ENV:** Completely rewrote "Build Script Configuration" section; added detailed explanation of CommonJS entry point requirements; documented the `__dirname` banner trap (causes crash when used with `format: 'cjs'`); added complete module chain diagram; added two new troubleshooting entries for ERR_MODULE_NOT_FOUND and __dirname redeclaration errors; documented macOS packaged-app env loading requirement for IPC-based providers; added provider-not-available troubleshooting and verification checks |
| 4.2 | 2026-01-23 | **SECURITY & SETUP:** Added "Initial setup and dependency installation" section with security best practices; documented npm audit workflow; explained how to handle transitive dependency vulnerabilities using npm overrides; added version verification steps |
| 4.1 | 2026-01-22 | **IMPROVED CLARITY:** Added "Two Critical Decisions" summary table upfront; expanded verification checklist with debugging steps for blank UI and non-draggable window; added .gitignore and update logs sections |
| 4.0 | 2026-01 | **MAJOR REWRITE:** Added explicit "CRITICAL" sections for renderer loading and window dragging; clarified that `loadFile()` is preferred over custom protocols; documented that `frame:false` and `titleBarStyle` conflict; added platform-specific window config pattern; added complete code examples |
| 3.1 | 2026-01 | **GENERALIZED:** Removed project-specific references; replaced with placeholders (`<AppName>`, `<YOUR_APP_NAME>`, etc.) for use with any Electron project |
| 3.0 | 2026-01 | **CRITICAL FIX:** Documented that electron-builder excludes `dist/` by default; changed Vite output to `renderer/` to avoid conflict |
| 2.9 | 2026-01 | Updated build configuration (Vite `dist/` + `loadFile()`); removed Next.js/OAuth content; updated commands, paths, and troubleshooting |
| 2.7 | 2026-01 | Added failure modes for relative Vite assets and macOS frameless dragging |
| 2.6 | 2026-01 | Consolidated prevention checklist into the guide |
| 2.5 | 2026-01 | Documented `fetch()` + `file://` limitation and custom protocol pattern |
| 2.4 | 2026-01 | Documented correct `dist/index.html` path resolution in packaged apps |
