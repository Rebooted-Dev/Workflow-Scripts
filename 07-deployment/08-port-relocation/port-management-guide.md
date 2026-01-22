# Port Management Guide for Development Servers

This comprehensive guide covers port conflict resolution, process management, and browser auto-open for Vite-based and other development servers. It provides solutions from simple configuration changes to advanced process management.

## Quick Start

### For Most Projects (Recommended)

Add this to your `vite.config.ts`:

```typescript
export default defineConfig({
  server: {
    host: '0.0.0.0',
    port: 5173,
    strictPort: false, // Automatically finds next available port
    open: true,        // Optional: auto-open browser
  },
})
```

That's it! Vite will automatically handle port conflicts.

---

## Table of Contents

1. [Problem Overview](#problem-overview)
2. [Simple Solution: Vite Configuration](#simple-solution-vite-configuration)
3. [Advanced Solution: Process Management](#advanced-solution-process-management)
4. [Browser Auto-Open](#browser-auto-open)
5. [Troubleshooting](#troubleshooting)
6. [Alternative Approaches](#alternative-approaches)

---

## Problem Overview

### Common Issues

**Port Conflicts:**
```
Error: listen EADDRINUSE: address already in use :::5173
```

**Process Accumulation:**
```
First run:  Port 5173 in use → uses 5174
Second run: Ports 5173, 5174 in use → uses 5175
Third run:  Ports 5173, 5174, 5175 in use → uses 5176
```

### Root Causes

1. **Multiple dev servers running** - Previous instances not terminated
2. **Background processes** - Node.js processes persist after terminal closes
3. **No automatic cleanup** - Each `npm run dev` spawns new process
4. **Port occupation** - Each server binds to a port until explicitly stopped

---

## Simple Solution: Vite Configuration

### Step 1: Update Vite Config

Modify your `vite.config.ts`:

```typescript
// vite.config.ts
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  // ... existing config ...
  server: {
    host: '0.0.0.0',      // Allow network access
    port: 5173,           // Preferred port
    strictPort: false,    // ✅ Enable automatic port finding
    open: false           // Optional: prevent auto-opening browser
  },
  // ... rest of config ...
})
```

**Key Setting:** `strictPort: false` enables automatic port discovery.

### Step 2: Test the Solution

#### Test with Port Conflict

1. **Occupy the default port** (in one terminal):
   ```bash
   # Using netcat
   nc -l 5173
   
   # Or leave another dev server running
   ```

2. **Start your development server** (in another terminal):
   ```bash
   npm run dev
   ```

3. **Expected output:**
   ```
   Port 5173 is in use, trying another one...
   
   VITE v6.3.6  ready in 152 ms
   
   ➜  Local:   http://localhost:5174/
   ➜  Network: http://192.168.1.100:5174/
   ```

#### Test with Available Port

1. **Ensure port 5173 is free**:
   ```bash
   # Kill any processes on 5173
   kill $(lsof -ti:5173) 2>/dev/null || true
   ```

2. **Start development server**:
   ```bash
   npm run dev
   ```

3. **Expected output:**
   ```
   VITE v6.3.6  ready in 152 ms
   
   ➜  Local:   http://localhost:5173/
   ➜  Network: http://192.168.1.100:5173/
   ```

### Step 3: Override Port When Needed

You can still specify a custom port:

```bash
# Using environment variable
PORT=3000 npm run dev

# Or via npm config
npm run dev -- --port 3000
```

### Compatibility

- **Vite**: v4.0+ (strictPort support)
- **Node.js**: v14+
- **Works with**: React, Vue, Svelte, and other Vite-based frameworks

---

## Advanced Solution: Process Management

If you experience process accumulation (ports escalating: 5173 → 5174 → 5175...), use process management to automatically clean up before starting.

### When to Use This

- Multiple dev servers accumulating ports
- Background processes not terminating
- Need consistent port usage
- Working with multiple projects simultaneously

### Implementation

#### Step 1: Create Process Manager Script

Create `scripts/dev-server.js`:

```javascript
#!/usr/bin/env node

import { execSync, spawn } from 'child_process';
import { platform } from 'os';
import { readFileSync } from 'fs';

// Get project name from package.json
const packageJson = JSON.parse(readFileSync('package.json', 'utf8'));
const PROJECT_NAME = packageJson.name || 'my-project';
const VITE_COMMAND = 'vite';

function killExistingProcesses() {
  try {
    if (platform() === 'win32') {
      // Windows: Kill node processes for this project
      execSync(
        `taskkill /f /im node.exe /fi "WINDOWTITLE eq ${PROJECT_NAME}*"`,
        { stdio: 'ignore' }
      );
    } else {
      // macOS/Linux: Kill processes matching project and vite
      execSync(
        `pkill -f "${PROJECT_NAME}.*${VITE_COMMAND}" || true`,
        { stdio: 'ignore' }
      );
    }
    console.log('🧹 Cleaned up existing dev server processes');
  } catch (error) {
    // Ignore errors - processes might not exist
  }
}

function startDevServer() {
  console.log('🚀 Starting development server...');

  const child = spawn(VITE_COMMAND, [], {
    stdio: 'inherit',
    shell: true,
    env: {
      ...process.env,
      FORCE_COLOR: '1'
    }
  });

  // Handle process termination signals
  process.on('SIGINT', () => {
    console.log('\n🛑 Stopping development server...');
    child.kill('SIGINT');
    process.exit(0);
  });

  process.on('SIGTERM', () => {
    console.log('\n🛑 Stopping development server...');
    child.kill('SIGTERM');
    process.exit(0);
  });

  child.on('exit', (code) => {
    console.log(`\n📊 Development server exited with code ${code}`);
    process.exit(code || 0);
  });
}

// Main execution
console.log(`🔧 ${PROJECT_NAME} Development Server Manager`);
killExistingProcesses();
startDevServer();
```

#### Step 2: Update package.json

Modify `package.json` scripts:

```json
{
  "scripts": {
    "dev": "node scripts/dev-server.js",
    "dev:stop": "pkill -f 'my-project.*vite' || true"
  }
}
```

**Note:** Replace `'my-project'` with your actual project name, or the script will auto-detect it.

#### Step 3: Make Script Executable

```bash
chmod +x scripts/dev-server.js
```

#### Step 4: Test Process Management

```bash
# Start dev server
npm run dev

# In another terminal, check processes
ps aux | grep vite

# Run dev again - should kill previous and start fresh
npm run dev

# Verify only one process running
ps aux | grep vite
```

### Process Detection Logic

**Unix-like Systems (macOS, Linux):**
```bash
pkill -f "${PROJECT_NAME}.*${VITE_COMMAND}"
```
- Uses `pkill` with regex pattern matching
- `-f` flag matches full command line
- Targets processes containing both project name and vite command

**Windows Systems:**
```powershell
taskkill /f /im node.exe /fi "WINDOWTITLE eq ${PROJECT_NAME}*"
```
- Uses `taskkill` to kill node processes
- Filters by window title containing project name
- `/f` flag forces termination

---

## Browser Auto-Open

### Simple Method: Vite Configuration

Add `open: true` to your Vite config:

```typescript
// vite.config.ts
export default defineConfig({
  server: {
    port: 5173,
    strictPort: false,
    open: true,  // ✅ Auto-open browser
  },
})
```

### Custom Browser

```typescript
export default defineConfig({
  server: {
    open: {
      browser: 'chrome',  // 'firefox', 'safari', etc.
      url: 'http://localhost:5173/custom-path'
    },
  },
})
```

### Alternative: Using npm Scripts

**macOS/Linux:**
```json
{
  "scripts": {
    "dev": "vite & sleep 2 && open http://localhost:5173"
  }
}
```

**Windows:**
```json
{
  "scripts": {
    "dev": "start http://localhost:5173 && vite"
  }
}
```

### Using open Package

```bash
npm install --save-dev open
```

```javascript
// In your dev server setup script
import open from 'open';

async function startServer() {
  // Start your dev server...
  
  // Auto-open browser
  await open('http://localhost:3000');
}
```

For more detailed browser auto-open configuration, see [browser-auto-open.md](./browser-auto-open.md).

---

## Troubleshooting

### Solution Not Working

**Check 1: Vite Version**
```bash
npm list vite
# Should be v4+ for strictPort support
```

**Check 2: Configuration Syntax**
Ensure `strictPort` is exactly `false` (boolean, not string):
```typescript
server: {
  strictPort: false  // ✅ Correct
  // strictPort: "false"  // ❌ Wrong
}
```

**Check 3: Port Detection**
```bash
# Check what's using the port
lsof -i :5173
netstat -tulpn | grep :5173
```

### Process Cleanup Not Working

**Check 1: Process Detection**
```bash
# See what processes are running
ps aux | grep vite

# Check if project name matches
pgrep -f "my-project"
```

**Check 2: Permission Issues**
```bash
# Test pkill manually
pkill -f "my-project.*vite"

# Check if processes still exist
ps aux | grep vite
```

**Check 3: Platform-Specific Issues**
```bash
# On macOS/Linux
pkill -9 -f "my-project.*vite"

# On Windows (PowerShell)
Get-Process node | Where-Object {$_.MainWindowTitle -like "*my-project*"} | Stop-Process -Force
```

### Port Still Conflicts

**Check 1: Other Applications**
```bash
# See what's using the port
lsof -i :5173

# On Windows
netstat -ano | findstr :5173
```

**Check 2: Vite Configuration**
```typescript
// Ensure strictPort is false
server: {
  strictPort: false
}
```

**Check 3: Environment Variables**
```bash
# Check if PORT is set
echo $PORT

# Unset if interfering
unset PORT
```

### Multiple Vite Processes

```bash
# Kill all Vite processes
pkill -f vite
```

### IPv4/IPv6 Conflicts

Sometimes ports appear free but are bound to different protocols:
```bash
# Check both IPv4 and IPv6
lsof -i :5173
```

### Firewall Issues

```bash
# Check if firewall is interfering
sudo lsof -i :5173
```

### Browser Doesn't Open

1. Check if `open: true` is set in your build tool config
2. Try setting `BROWSER=none npm run dev` to disable auto-open
3. Check if your OS has default browser set
4. On macOS: `sudo spctl developer-mode enable-terminal`

---

## Alternative Approaches

### Environment Variable Port Selection

```typescript
// vite.config.ts
const port = Number(process.env.PORT) || 5173

export default defineConfig({
  server: {
    port,
    strictPort: true // Keep strict when using env vars
  }
})
```

### Custom Port Finding Logic

```typescript
// vite.config.ts
import { createServer } from 'net'

function findAvailablePort(startPort: number): Promise<number> {
  return new Promise((resolve) => {
    const server = createServer()
    server.listen(startPort, () => {
      server.close(() => resolve(startPort))
    })
    server.on('error', () => {
      resolve(findAvailablePort(startPort + 1))
    })
  })
}

// Usage (requires top-level await support)
const port = await findAvailablePort(5173)
```

### Shell Script Approach

```bash
#!/bin/bash
# scripts/dev-server.sh
PROJECT_NAME="my-project"

# Kill existing processes
pkill -f "${PROJECT_NAME}.*vite" || true

# Start new server
exec vite
```

### NPM Pre/Post Scripts

```json
{
  "scripts": {
    "predev": "pkill -f 'my-project.*vite' || true",
    "dev": "vite"
  }
}
```

---

## Best Practices

1. **Always use `npm run dev`** - Let the configuration handle conflicts
2. **Check terminal output** - Note the actual port being used
3. **Use network URLs** - For testing on different devices
4. **Clean up processes periodically** - Avoid port exhaustion
5. **Document your setup** - Add port management notes to README
6. **Test on multiple OS** - Ensure cross-platform compatibility

---

## Summary

### Recommended Approach

1. **Start with simple solution**: Add `strictPort: false` to Vite config
2. **Add process management if needed**: Use process manager script for cleanup
3. **Enable browser auto-open**: Add `open: true` for better DX

### Quick Reference

| Solution | Complexity | When to Use |
|----------|-----------|-------------|
| Vite `strictPort: false` | Simple | Most projects, occasional conflicts |
| Process Management Script | Advanced | Multiple projects, process accumulation |
| Custom Port Finding | Advanced | Special requirements, custom logic |

### File Structure

```
project/
├── vite.config.ts          # Add strictPort: false
├── scripts/
│   └── dev-server.js       # Optional: process manager
└── package.json            # Update scripts
```

---

## Related Guides

- [Browser Auto-Open Guide](./browser-auto-open.md) - Detailed browser configuration
- [Deployment Index](../README.md) - Other deployment scenarios

---

*This guide consolidates port conflict resolution, process management, and browser auto-open into a single comprehensive resource.*

## Status
- **IMPLEMENTED**: Vite config updated with `strictPort: false` and `open: true` in `vite.config.ts`.

---

## Verification Addendum

**Timestamp:** 2026-01-22

**Commands Run:**
- `npm run build` - Passed successfully in 414ms
- `git diff` - Verified changes to vite.config.ts and CHANGELOG.md

**What Was Implemented:**
- ✅ `vite.config.ts:58-61`: Added `server` block with `strictPort: false` and `open: true`
- ✅ `CHANGELOG.md`: Updated with dated entry for port relocation implementation

**Misreporting Correction:**
- ❌ Status section incorrectly claimed: "Process management script created at `scripts/dev-server.js` with npm scripts `dev:manage` and `dev:stop`"
- ✅ Actual state: No `scripts/` directory exists, no process management script was created, no `dev:manage` or `dev:stop` scripts were added to package.json

**Verification of Vite Config:**
```typescript
server: {
  strictPort: false,  // Auto-finds available port on conflict
  open: true,         // Auto-opens browser on npm run dev
}
```

**Build Verification:**
```
vite v6.4.1 building for production...
transforming...
✓ 11 modules transformed.
rendering chunks...
✓ built in 414ms
```

**Next Steps (Optional - Not Implemented):**
- [ ] Create process management script at `scripts/dev-server.js` if process accumulation occurs
- [ ] Add npm scripts `dev:manage` and `dev:stop` to package.json
- [ ] Test port conflict behavior with multiple dev servers running
