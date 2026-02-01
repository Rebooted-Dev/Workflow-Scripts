# Nginx Deployment Guide

This guide covers deploying applications using nginx on macOS for local demos and network access.

## Overview

Nginx is a lightweight, high-performance web server ideal for local demos and small-scale deployments. This guide covers:
- Installing and configuring nginx on macOS
- Serving static sites
- Setting up reverse proxy for Node.js apps
- Local network and remote access options
- Security best practices

## When to Use This Guide

Use this guide when you need to:
- Demo a website to someone on your local network
- Serve a static site built with npm (React, Vue, vanilla JS)
- Proxy requests to a Node.js/Express app
- Set up temporary remote access for demos

## Prerequisites

- **npm project**: Site builds and runs locally without errors
- **Homebrew**: macOS package manager. Install with:
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
- **Admin access**: `sudo` required for some commands
- **Port availability**: Default port 8080 (configurable)

### Supported Project Types

- **Static sites**: HTML/CSS/JS built via `npm run build` (React, Vue, vanilla)
- **Dynamic apps**: Node.js/Express apps running on localhost
- **SPAs**: Single-page apps with client-side routing

---

## Quick Start

```bash
# Install nginx
brew install nginx

# For static sites: Build your project first
npm run build

# Configure nginx (see Step 3 below)
# Start nginx
nginx

# Test locally
open http://localhost:8080
```

---

## Step 1: Install Nginx

1. Update Homebrew and install nginx:
   ```bash
   brew update
   brew install nginx
   ```

2. Verify installation:
   ```bash
   nginx -v
   # Output: nginx/1.25.x
   ```

3. Test default installation:
   ```bash
   nginx
   open http://localhost:8080  # Should show nginx welcome page
   nginx -s stop
   ```

**Installation paths:**
- Apple Silicon: `/opt/homebrew/opt/nginx`
- Intel Macs: `/usr/local/opt/nginx`

---

## Step 2: Build Your Project

### Static Sites

Build your project to create static files:

```bash
cd /path/to/your/project
npm run build
```

This creates a `dist`, `build`, or similar folder with optimized files.

### Dynamic Node.js Apps

Start your app server:

```bash
npm start  # Or: node server.js, npm run dev
```

Keep it running on its port (e.g., localhost:3000).

---

## Step 3: Configure Nginx

### 3.1 Backup Original Config

```bash
cp /opt/homebrew/etc/nginx/nginx.conf /opt/homebrew/etc/nginx/nginx.conf.backup
```

### 3.2 Edit Configuration

Open the nginx config:

```bash
nano /opt/homebrew/etc/nginx/nginx.conf
# Or use your editor:
# code /opt/homebrew/etc/nginx/nginx.conf
```

### 3.3 Choose Your Configuration

**Option A: Static Site Configuration**

Replace the `server` block with:

```nginx
server {
    listen       8080;
    server_name  localhost;

    location / {
        root   /path/to/your/project/dist;  # Change to your build folder
        index  index.html index.htm;
        try_files $uri $uri/ /index.html;   # SPA routing support
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }
}
```

**Option B: Dynamic App (Reverse Proxy)**

Replace the `server` block with:

```nginx
server {
    listen       8080;
    server_name  localhost;

    location / {
        proxy_pass http://localhost:3000;  # Your Node.js port
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### 3.4 Test and Reload

```bash
# Test configuration
nginx -t

# Reload nginx (or start if not running)
nginx -s reload
# Or: nginx (if not running)
```

---

## Step 4: Local Access

### Access on Your Mac

```bash
open http://localhost:8080
```

### Access on Local Network

1. Find your Mac's IP address:
   ```bash
   ifconfig | grep "inet " | grep -v 127.0.0.1
   ```
   (Look for en0/Wi-Fi interface, e.g., 192.168.1.100)

2. On another device on the same network:
   ```
   http://192.168.1.100:8080
   ```

3. **Enable firewall access:**
   - System Settings → Network → Firewall → Options
   - Add nginx or allow port 8080

---

## Step 5: Remote Access (Internet)

For remote demos, use a tunneling service (recommended) rather than direct exposure.

### Option A: ngrok (Recommended)

**Setup:**
```bash
brew install ngrok/ngrok/ngrok
ngrok authtoken <your-token>  # Sign up at ngrok.com
```

**Start tunnel:**
```bash
ngrok http 8080
```

**Share the URL:**
- ngrok provides a public URL (e.g., `https://abc123.ngrok.io`)
- URL is temporary and secure
- Free tier has session limits; paid removes restrictions

### Option B: Localtunnel

```bash
npm install -g localtunnel
lt --port 8080
```

### Option C: Cloudflare Tunnel

See [Cloudflare Tunnel docs](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/) for persistent tunnels.

### Option D: Router Port Forwarding (Not Recommended)

**Warning:** Exposes your Mac directly to the internet. Use only if necessary.

1. Log into your router (usually `192.168.1.1`)
2. Forward external port 8080 to your Mac's IP:8080
3. Find public IP: Search "what is my IP"
4. Share: `http://public-ip:8080`

**Security precautions:**
- Use strong firewall rules
- Change default ports
- Disable when demo is complete
- Consider dynamic DNS (No-IP, DynDNS) for changing IPs

---

## Advanced Configuration

### HTTPS with Self-Signed Certificate

For secure demos (browsers will warn about self-signed certs):

```bash
# Generate certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /opt/homebrew/etc/nginx/server.key \
  -out /opt/homebrew/etc/nginx/server.crt

# Add to nginx config:
# listen 8443 ssl;
# ssl_certificate /opt/homebrew/etc/nginx/server.crt;
# ssl_certificate_key /opt/homebrew/etc/nginx/server.key;
```

### Custom Domain (Local)

Edit `/etc/hosts`:

```
127.0.0.1  mydemo.local
```

Then set `server_name mydemo.local;` in nginx config.

### Enable Gzip Compression

Add to nginx config for better performance:

```nginx
gzip on;
gzip_types text/plain text/css application/json application/javascript;
```

### WebSocket Support

The reverse proxy config in Step 3 already supports WebSockets for real-time features.

### Large File Uploads

Adjust body size limit:

```nginx
client_max_body_size 10M;  # Or larger as needed
```

---

## Troubleshooting

### Port Conflicts

```bash
# Check what's using port 8080
lsof -i :8080

# Kill process if needed
kill -9 <PID>
```

### Permission Errors

Ensure nginx can read your project files:

```bash
chmod -R 755 /path/to/your/dist
```

### App Not Loading

Check nginx error logs:

```bash
tail -f /opt/homebrew/var/log/nginx/error.log
```

### macOS PATH Issues (M1/M2)

Ensure Homebrew is in your PATH:

```bash
echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Bind Permission Denied

If port 80 binding fails, use port 8080 (default) or run with sudo (not recommended):

```bash
sudo nginx  # Only if necessary
```

---

## Best Practices

### Security
- **Never expose sensitive data** in demos
- **Use HTTPS** for demos involving logins
- **Stop nginx after demos:** `nginx -s stop`
- **Prefer tunnels** (ngrok) over port forwarding

### Performance
- Always build for production (`npm run build`)
- Enable gzip compression for larger sites
- Use nginx caching for static assets

### Maintenance
- Keep nginx updated: `brew upgrade nginx`
- Monitor logs for errors
- Back up your config before changes

### Cleanup

```bash
# Stop nginx
nginx -s stop

# Disable auto-start
brew services stop nginx

# Uninstall if needed
brew uninstall nginx
```

---

## Related Documentation

- [Port Management Guide](./08-port-relocation/port-management-guide.md) - For port conflicts
- [Firebase Hosting](./10-firebase-setup.md) - For cloud deployment alternative
- [Deployment Index](./README.md) - Other deployment options

---

## Quick Reference

| Command | Purpose |
|---------|---------|
| `nginx` | Start nginx |
| `nginx -s stop` | Stop nginx |
| `nginx -s reload` | Reload config |
| `nginx -t` | Test configuration |
| `nginx -v` | Show version |

---

*Last updated: 2026-02-01*
