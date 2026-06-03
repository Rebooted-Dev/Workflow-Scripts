# Port Relocation and Management

This directory contains guides for managing development server ports, resolving port conflicts, and configuring browser auto-open functionality.

## Quick Start

**Having port conflicts?** Start here: [Port Management Guide](./port-management-guide.md)

**Want browser to auto-open?** See: [Browser Auto-Open Guide](./browser-auto-open.md)

## Guides

### [Port Management Guide](./port-management-guide.md)

Comprehensive guide covering:
- Simple port conflict resolution (Vite configuration)
- Advanced process management (automatic cleanup)
- Port detection and selection
- Troubleshooting common issues

**When to use:**
- Getting "port already in use" errors
- Multiple dev servers accumulating ports
- Need consistent port usage across projects

### [Browser Auto-Open Guide](./browser-auto-open.md)

Guide for automatically opening browsers when starting development servers:
- Vite configuration
- Other build tools (Webpack, Next.js, etc.)
- Custom browser selection
- Cross-platform compatibility

**When to use:**
- Want browser to open automatically on `npm run dev`
- Need to open specific browsers for testing
- Setting up development workflow

## Common Scenarios

### Scenario 1: Simple Port Conflict

**Problem:** `Error: listen EADDRINUSE: address already in use :::5173`

**Solution:** Add to `vite.config.ts`:
```typescript
server: {
  strictPort: false,  // Automatically finds next available port
}
```

See: [Port Management Guide - Simple Solution](./port-management-guide.md#simple-solution-vite-configuration)

### Scenario 2: Process Accumulation

**Problem:** Ports escalating: 5173 → 5174 → 5175 → 5176...

**Solution:** Use process management script to clean up before starting.

See: [Port Management Guide - Advanced Solution](./port-management-guide.md#advanced-solution-process-management)

### Scenario 3: Browser Auto-Open

**Problem:** Want browser to open automatically when starting dev server.

**Solution:** Add to `vite.config.ts`:
```typescript
server: {
  open: true,  // Auto-open browser
}
```

See: [Browser Auto-Open Guide](./browser-auto-open.md)

## File Structure

```
08-port-relocation/
├── README.md                    # This file - overview and quick start
├── port-management-guide.md    # Comprehensive port management guide
└── browser-auto-open.md        # Browser auto-open configuration
```

## Related Documentation

- [Deployment Index](../../07-deployment/README.md) - Other deployment scenarios
- [Workflow Scripts README](../../README.md) - Complete workflow documentation

---

*For questions or issues, refer to the troubleshooting sections in each guide.*
