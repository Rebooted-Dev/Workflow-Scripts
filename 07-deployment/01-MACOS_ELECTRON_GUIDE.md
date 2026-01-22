# macOS Electron Desktop App Guide v3.0

How this repo builds and packages the macOS Electron app.

This project uses a Vite + React renderer that is bundled to `renderer/` (NOT `dist/` - see critical note below) and loaded in production via custom `app://` protocol.

Document version: 3.0 (2026-01)

## When to use this

- Building or packaging the Electron macOS app (.app, DMG, ZIP)
- Debugging production-only renderer issues (blank window, missing assets)
- Fixing frameless-window dragging (macOS title bar)
- Understanding what must be included in `electron-builder` `files`

## Project defaults (PDF-to-PNG)

If you fork this project, update these in `electron-builder.config.cjs` and the commands below.

| Key | Value |
|---|---|
| App name | `PDF to PNG Converter` |
| Bundle ID | `com.pdftopngconverter.app` |
| Build config | `electron-builder.config.cjs` |

## Quick start (preflight)

Commands:

```bash
# Fast local build (.app only)
npm run mac:build:dir

# Distribution build (DMG + ZIP)
npm run mac:build

# Launch a built app
open "release/mac-arm64/PDF to PNG Converter.app"

# Watch main process logs
tail -f "~/Library/Logs/PDF to PNG Converter/main.log"
```

Non-negotiables (these prevent most production-only failures):

1. Build with `./scripts/mac-build.sh` (or `npm run mac:build:dir`) so the pipeline runs in the correct order.
2. Use `npm` (repo scripts assume npm).
3. Vite must output relative asset paths for packaged apps (`vite.config.ts: base: './'`).
4. `electron-builder` must include `index.cjs`, `desktop/*.cjs`, and `dist/**/*` in `files`.

## What the build script is responsible for

The build script should be the single source of truth for packaging. At minimum it should:

- Clean build artifacts that commonly cause stale packaging (`desktop/*.cjs`, `dist`, `release/`).
- Build Electron main/preload (typically via esbuild into `desktop/*.cjs`).
- Build the web UI (`vite build` into `dist/`).
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
        dist/                   # if using a static renderer build
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

## Renderer build (Vite + `renderer/`)

If you load `renderer/index.html` via `loadFile()`, a Vite build MUST use relative asset paths.

In `vite.config.ts`:

```ts
export default defineConfig(() => ({
  base: './',
  build: {
    outDir: 'renderer',
  },
}));
```

In `desktop/main.ts`:

```ts
const indexPath = path.join(__dirname, '..', 'renderer', 'index.html');
await win.loadFile(indexPath);
```

If `renderer/index.html` contains `/assets/...` (absolute) paths, the window will show blank in packaged builds.

## Loading packaged local files (optional)

This project currently loads the UI via `file://` + `loadFile()`. That works well as long as the renderer does not rely on `fetch()` to read packaged local files.

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

## Window dragging (frameless windows on macOS)

If you use `frame: false` / `titleBarStyle: 'hiddenInset'`, dragging only works when the drag region and "no-drag" regions are set correctly.

Rules:

- Drag region height should match macOS title bar height (38px is the practical value).
- Interactive elements inside a drag region must be `no-drag`.
- Add left padding to avoid traffic lights overlap when using `hiddenInset`.

CSS:

```css
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

.app-drag-region {
  -webkit-app-region: drag;
}

.app-drag-region button,
.app-drag-region a,
.app-drag-region input,
.app-drag-region select,
.app-drag-region textarea,
.app-drag-region [role="button"] {
  -webkit-app-region: no-drag;
}

.app-no-drag {
  -webkit-app-region: no-drag;
}
```

Header layout (traffic lights spacing):

```tsx
const isElectron = typeof window !== 'undefined' && !!window.electronAPI;

return (
  <>
    {isElectron && <div className="window-drag-bar" />}
    <header className="app-drag-region">
      <div className={`max-w-7xl mx-auto px-4 ${isElectron ? 'pl-20' : ''}`}>
        {/* header contents */}
      </div>
    </header>
  </>
);
```

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

## Troubleshooting (high-signal)

When in doubt, start by tailing the main log:

```bash
tail -f "~/Library/Logs/<AppName>/main.log"
```

Common failures and the single fix that matters:

| Symptom | Usually means | Fix |
|---|---|---|
| App opens but is blank | renderer assets not loading | confirm `vite.config.ts: base: './'`, then inspect `renderer/index.html` for `./assets/...` |
| App throws on launch | `renderer/index.html` missing in packaged app | confirm Vite outputs to `renderer/` (NOT `dist/`), and `electron-builder` includes `renderer/**` |
| `dist/` not in asar | electron-builder excludes `dist/` by default | **Change Vite output to `renderer/`** - the default patterns exclude `!dist{,/**/*}` |
| "Cannot find module index.cjs" | not packaged | add `index.cjs` to `electron-builder` `files` |
| Stuck on "Loading..." (packaged) | `fetch()` blocked by `file://` | use `app://` custom protocol (or serve over `http://`) |
| Window not draggable | drag region/no-drag wrong | use 38px drag bar + global no-drag rule + traffic lights padding |
| `electron-builder` dependency scan noise | npm optional deps confusion | build via the repo wrapper (or pin toolchain) |

**Debugging tip:** Use `npx asar list "<app>.app/Contents/Resources/app.asar"` to verify what's actually packaged.

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

## Document history

| Version | Date | Notes |
|---|---|---|
| 3.0 | 2026-01 | **CRITICAL FIX:** Documented that electron-builder excludes `dist/` by default; changed Vite output to `renderer/` to avoid conflict |
| 2.9 | 2026-01 | Updated to match PDF-to-PNG build (Vite `dist/` + `loadFile()`); removed Next.js/OAuth content; updated commands, paths, and troubleshooting |
| 2.7 | 2026-01 | Added failure modes for relative Vite assets and macOS frameless dragging |
| 2.6 | 2026-01 | Consolidated prevention checklist into the guide |
| 2.5 | 2026-01 | Documented `fetch()` + `file://` limitation and custom protocol pattern |
| 2.4 | 2026-01 | Documented correct `dist/index.html` path resolution in packaged apps |
