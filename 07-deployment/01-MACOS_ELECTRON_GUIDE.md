# macOS Electron Desktop App Guide v4.0

How to build and package a macOS Electron desktop app for any project.

This guide assumes your project uses a Vite + React renderer that is bundled to `renderer/` (NOT `dist/` - see critical note below) and loaded in production via `loadFile()`.

Document version: 4.0 (2026-01)

> **Note:** Throughout this guide, you'll see placeholders like `<AppName>`, `<YOUR_APP_NAME>`, and `<YOUR_BUNDLE_ID>`. Replace these with your actual project values before running any commands.

## When to use this

- Building or packaging the Electron macOS app (.app, DMG, ZIP)
- Debugging production-only renderer issues (blank window, missing assets)
- Fixing frameless-window dragging (macOS title bar)
- Understanding what must be included in `electron-builder` `files`

## Project configuration

Before using this guide, configure these values in `electron-builder.config.cjs` and update the commands below with your app name.

| Key | Example Value | Your Value |
|---|---|---|
| App name | `Your App Name` | `<YOUR_APP_NAME>` |
| Bundle ID | `com.yourcompany.yourapp` | `<YOUR_BUNDLE_ID>` |
| Build config | `electron-builder.config.cjs` | `electron-builder.config.cjs` |

## Quick start (preflight)

Commands:

```bash
# Fast local build (.app only)
npm run mac:build:dir

# Distribution build (DMG + ZIP)
npm run mac:build

# Launch a built app (replace <AppName> with your actual app name)
open "release/mac-arm64/<AppName>.app"

# Watch main process logs (replace <AppName> with your actual app name)
tail -f "~/Library/Logs/<AppName>/main.log"
```

## The Two Critical Decisions

These two choices determine whether your app works correctly:

| Decision | Correct Choice | Why |
|----------|----------------|-----|
| **How to load the UI** | `loadFile()` | Works out of the box. `loadURL('app://...')` requires a custom protocol handler that commonly fails silently. |
| **Window frame on macOS** | `titleBarStyle: 'hiddenInset'` (alone) | Use ONLY this. `frame: false` conflicts with it and breaks dragging. Use `frame: false` only on Windows/Linux. |

**Never:**
- Use `loadURL('app://...')` in production
- Combine `frame: false` AND `titleBarStyle: 'hiddenInset'` on macOS

Non-negotiables (these prevent most production-only failures):

1. Build with `./scripts/mac-build.sh` (or `npm run mac:build:dir`) so the pipeline runs in the correct order.
2. Use `npm` (repo scripts assume npm).
3. Vite must output relative asset paths for packaged apps (`vite.config.ts: base: './'`).
4. `electron-builder` must include `index.cjs`, `desktop/*.cjs`, and `renderer/**` in `files`.

## What the build script is responsible for

The build script should be the single source of truth for packaging. At minimum it should:

- Clean build artifacts that commonly cause stale packaging (`desktop/*.cjs`, `renderer/`, `release/`).
- Build Electron main/preload (typically via esbuild into `desktop/*.cjs`).
- Build the web UI (`vite build` into `renderer/`).
- Run `electron-builder` in a way that does not produce noisy dependency scan warnings (optional quality-of-life).

## Architecture (what ends up inside the .app)

Electron packages your app into `app.asar`. In production, `__dirname` from `desktop/main.cjs` points to the packaged `desktop/` directory, not the app root.

Typical structure:

```
<AppName>.app/
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

## electron-builder configuration (must-have)

In `electron-builder.config.cjs`, ensure these are true:

- `files` includes `index.cjs`, `desktop/main.cjs`, `desktop/preload.cjs`, and the renderer build directory.
- Local builds should succeed without Apple credentials (ad-hoc signing + notarization disabled).

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
  appId: '<app-id>',
  productName: '<AppName>',
  files: [
    'index.cjs',
    'desktop/main.cjs',
    'desktop/preload.cjs',

    // Vite renderer build (NOT dist/ - that's excluded by default!)
    'renderer/**',

    'package.json'
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

### Use `loadFile()` (Recommended)

**Always use `loadFile()` for production builds.** It is simpler and more reliable than custom protocols.

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
            color: '#1a1a2e',
            symbolColor: '#ffffff',
            height: 38
          }
        }
    ),
    
    backgroundColor: '#1a1a2e',
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

## Build Script Configuration

### esbuild Output Extension

When using esbuild to compile TypeScript to CommonJS, ensure the output files have `.cjs` extension:

```json
// package.json
{
  "scripts": {
    "build:electron": "esbuild desktop/main.ts desktop/preload.ts --platform=node --target=node18.5 --bundle --outdir=desktop --format=cjs --external:electron --out-extension:.js=.cjs"
  }
}
```

**Why:** If your `package.json` has `"type": "module"`, Node.js expects `.js` files to be ESM. The `.cjs` extension forces CommonJS interpretation.

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
tail -f "~/Library/Logs/<AppName>/main.log"
```

Common failures and the single fix that matters:

| Symptom | Usually means | Fix |
|---|---|---|
| App opens but is blank | renderer assets not loading | Use `loadFile()` (not `loadURL`), confirm `vite.config.ts: base: './'`, check path is `path.join(__dirname, '..', 'renderer', 'index.html')` |
| App throws on launch | `renderer/index.html` missing in packaged app | Confirm Vite outputs to `renderer/` (NOT `dist/`), and `electron-builder` includes `renderer/**` |
| `dist/` not in asar | electron-builder excludes `dist/` by default | **Change Vite output to `renderer/`** - the default patterns exclude `!dist{,/**/*}` |
| "Cannot find module index.cjs" | not packaged | Add `index.cjs` to `electron-builder` `files` |
| Stuck on "Loading..." (packaged) | `fetch()` blocked by `file://` | Use `app://` custom protocol (only if using fetch for local files) |
| Window not draggable (macOS) | Wrong frame config or conflicting settings | Use ONLY `titleBarStyle: 'hiddenInset'` on macOS (NOT `frame: false`) |
| Window not draggable (Windows) | Missing drag CSS | Add `.window-drag-bar` with `-webkit-app-region: drag` |
| Buttons don't work in header | Missing no-drag | Add `.no-drag` class to buttons or use CSS selector |
| Content hidden behind drag bar | Missing padding | Add `padding-top: 38px` to app container |
| Header overlaps traffic lights | Missing left padding on macOS | Add `padding-left: 80px` to header when `electron-macos` class is present |
| `electron-builder` dependency scan noise | npm optional deps confusion | Build via the repo wrapper (or pin toolchain) |

**Debugging tip:** Use `npx asar list "<app>.app/Contents/Resources/app.asar"` to verify what's actually packaged.

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

Run and watch logs:

```bash
open "release/mac-arm64/<AppName>.app"
tail -f "~/Library/Logs/<AppName>/main.log"
```

### Critical Checks (must pass)

1. **UI displays correctly** - Not just a colored background (verify `loadFile()` is being used)
2. **Window is draggable** - Click and drag on the title bar area (verify `titleBarStyle: 'hiddenInset'` is set on macOS, NOT `frame: false`)
3. **Traffic lights work (macOS)** - Close/minimize/maximize buttons in top-left
4. **Buttons are clickable** - Theme toggle, other header buttons respond to clicks (verify `-webkit-app-region: no-drag` on interactive elements)
5. **No content hidden** - Header is not overlapped by traffic lights or cut off (verify `padding-left: 80px` on macOS header)

### If UI is blank:
1. Check main log: `tail -f "~/Library/Logs/<AppName>/main.log"`
2. Verify asar contains renderer: `npx asar list "<app>.app/Contents/Resources/app.asar" | grep renderer`
3. Confirm `loadFile()` is used (not `loadURL('app://...')`)

### If window won't drag:
1. Confirm `titleBarStyle: 'hiddenInset'` is set on macOS
2. Verify no `frame: false` on macOS BrowserWindow config
3. Check CSS has `.window-drag-bar` with `-webkit-app-region: drag`
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

## Update logs (after changes)

When this guide is updated or build issues are encountered:

**1. Update CHANGELOG.md** (in project root):
```bash
# Add entry under [Unreleased] section with today's date
# Categories: Added, Changed, Fixed, Security
```

**2. Create troubleshooting entry** (if new issues are encountered):
```bash
# Create file: troubleshooting/build/YYYY-MM-DD-build-<short-title>.md
# Update troubleshooting/index.md with new entry
```

See `troubleshooting/README.md` for entry template and conventions.

---

## Document history

| Version | Date | Notes |
|---|---|---|
| 4.1 | 2026-01-22 | **IMPROVED CLARITY:** Added "Two Critical Decisions" summary table upfront; expanded verification checklist with debugging steps for blank UI and non-draggable window; added .gitignore and update logs sections |
| 4.0 | 2026-01 | **MAJOR REWRITE:** Added explicit "CRITICAL" sections for renderer loading and window dragging; clarified that `loadFile()` is preferred over custom protocols; documented that `frame:false` and `titleBarStyle` conflict; added platform-specific window config pattern; added complete code examples |
| 3.1 | 2026-01 | **GENERALIZED:** Removed project-specific references; replaced with placeholders (`<AppName>`, `<YOUR_APP_NAME>`, etc.) for use with any Electron project |
| 3.0 | 2026-01 | **CRITICAL FIX:** Documented that electron-builder excludes `dist/` by default; changed Vite output to `renderer/` to avoid conflict |
| 2.9 | 2026-01 | Updated build configuration (Vite `dist/` + `loadFile()`); removed Next.js/OAuth content; updated commands, paths, and troubleshooting |
| 2.7 | 2026-01 | Added failure modes for relative Vite assets and macOS frameless dragging |
| 2.6 | 2026-01 | Consolidated prevention checklist into the guide |
| 2.5 | 2026-01 | Documented `fetch()` + `file://` limitation and custom protocol pattern |
| 2.4 | 2026-01 | Documented correct `dist/index.html` path resolution in packaged apps |
