# Fully Automated Deployment Tasks

These tasks can be executed automatically via scripts, CI/CD pipelines, or tooling with no human intervention required.

---

## Deployment Readiness

### Build, Test & Artifact Validation

| Check | Command / Evidence | Status |
|-------|--------------------|--------|
| Production install is deterministic | `npm ci` or equivalent | [ ] |
| Production build succeeds | `npm run build` | [ ] |
| Automated tests pass | `npm test` or project equivalent | [ ] |
| Type checks pass | `npm run typecheck` or `tsc --noEmit` | [ ] |
| Lint passes | `npm run lint` | [ ] |
| Dependency audit triaged | `npm audit`, SCA tool, or issue references | [ ] |
| Build output location verified | `{{OUTPUT_DIR}}` exists | [ ] |
| Static assets are compressed/minified | Build report | [ ] |
| Source maps handled intentionally | Disabled or uploaded to error tracker | [ ] |
| Required runtime files included | Artifact inspection | [ ] |

### Runtime Configuration Validation

| Check | Command / Evidence | Status |
|-------|--------------------|--------|
| App validates required env vars at startup | Startup validation output | [ ] |

### CI/CD Controls (Automated Parts)

| Check | Command / Evidence | Status |
|-------|--------------------|--------|
| CI runs install, test, build, and typecheck | workflow file | [ ] |
| Deploy only occurs after successful verification steps | workflow file | [ ] |

### CI Live SEO Smoke Checks

| Check | Command / Evidence | Status |
|-------|--------------------|--------|
| `robots.txt` returns 200 | `npm run check:seo-live -- {{URL}} {{CANONICAL}}` | [ ] |
| `robots.txt` has correct `Sitemap:` line | smoke check output | [ ] |
| `robots.txt` has expected allow/deny blocks | smoke check output | [ ] |
| `sitemap.xml` returns 200 | `npm run check:seo-live -- {{URL}} {{CANONICAL}}` | [ ] |
| `sitemap.xml` is valid XML | smoke check output | [ ] |
| `sitemap.xml` contains expected canonical URLs | smoke check output | [ ] |
| `llms.txt` returns 200 (if maintained) | smoke check output | [ ] |
| `llms.txt` is non-empty (if maintained) | smoke check output | [ ] |
| Schema/JSON-LD present in built HTML | smoke check output | [ ] |
| Metadata smoke checks (title, canonical, OG) | smoke check output | [ ] |

### Automated GitHub Actions Workflows

| Workflow File | Purpose | Status |
|---------------|---------|--------|
| `.github/workflows/seo-lighthouse.yml` | Lighthouse CI with budget assertions | [ ] |
| `.github/workflows/seo-broken-links.yml` | Weekly broken link checker | [ ] |
| `.github/workflows/seo-sitemap.yml` | Auto-generate sitemap from content changes | [ ] |
| `.github/workflows/geo-visibility.yml` | Weekly AI visibility checks (Voyage GEO) | [ ] |
| `.github/workflows/update-llms-txt.yml` | Monthly llms.txt regeneration | [ ] |
| `.github/workflows/deploy-geo-dashboard.yml` | GitHub Pages GEO dashboard deployment | [ ] |

**Reference:** Full workflow specs in `Workflow-Scripts/12-SEO-GEO-checklist/2026-03-18-SEO-Dashboard/2026-03-18-stack-a-seo-dashboard-implementation-plan.md`

### TypeScript SEO Scripts

| Script | Purpose | Status |
|--------|---------|--------|
| `scripts/generate-sitemap.ts` | Generate sitemap.xml from app sections | [ ] |
| `scripts/generate-llms-txt.ts` | Generate llms.txt via Firecrawl | [ ] |
| `scripts/geo-analyzer.ts` | GEO visibility analysis via OpenRouter API | [ ] |
| `scripts/seo-panel-sync.ts` | Sync data from SEO Panel API | [ ] |

**Reference:** Full TypeScript implementations in `Workflow-Scripts/12-SEO-GEO-checklist/2026-03-18-SEO-Dashboard/2026-03-18-stack-a-mvp-poc-implementation-plan.md`

---

## Security Checklist

### HTTP Security Headers (Automated Checks)

| Header / Control | Target | Status |
|------------------|--------|--------|
| `Strict-Transport-Security` | `max-age=31536000; includeSubDomains` where appropriate | [ ] |
| `X-Content-Type-Options` | `nosniff` | [ ] |
| `X-Frame-Options` or CSP `frame-ancestors` | `DENY` / `SAMEORIGIN` as needed | [ ] |
| `Referrer-Policy` | `strict-origin-when-cross-origin` | [ ] |
| `Permissions-Policy` | disable unused browser features | [ ] |
| CSP implemented intentionally | enforced or staged rollout | [ ] |

### CSP Quality Checks (Automated)

| Check | Status |
|-------|--------|
| Uses allowlists and nonces/hashes where feasible | [ ] |
| Avoids `unsafe-eval` in production | [ ] |
| Any `unsafe-inline` usage is justified and minimized | [ ] |
| Tested in report-only mode before enforcement when practical | [ ] |
| Third-party script domains are documented | [ ] |

### Input Validation (Automated Testing)

| Check | Status |
|-------|--------|
| API and form inputs validated with schemas | [ ] |
| Database access uses parameterized queries / ORM protections | [ ] |
| Output encoding prevents XSS in rendered content | [ ] |
| User-supplied HTML is sanitized before render | [ ] |
| File uploads restrict type, size, extension, and content | [ ] |
| Uploaded files are stored outside executable paths | [ ] |
| SSRF protections exist for URL fetch/import features | [ ] |

---

## SEO Checklist

### Indexability & Crawl Control

| Check | Command / Evidence | Status |
|-------|--------------------|--------|
| Production pages intended for search are indexable | browser / curl test | [ ] |
| Staging, preview, and dev are blocked from indexing | robots.txt check | [ ] |
| `robots.txt` exists and matches intent | `curl https://{{DOMAIN}}/robots.txt` | [ ] |
| `sitemap.xml` exists and includes canonical indexable URLs | `curl https://{{DOMAIN}}/sitemap.xml` | [ ] |
| No important pages are blocked by robots accidentally | crawler report | [ ] |

### Metadata & Canonicalization (Automated Validation)

| Check | Status |
|-------|--------|
| Each important page has a unique `<title>` | [ ] |
| Each important page has a useful meta description | [ ] |
| Canonical URL is present and correct | [ ] |
| Open Graph tags exist for shareable pages | [ ] |
| Social preview image exists and is crawlable | [ ] |
| Redirects preserve canonical destination after domain/path changes | [ ] |

### Structured Data (Automated Validation)

| Check | Status |
|-------|--------|
| Schema type matches actual page/business type | [ ] |
| JSON-LD is valid JSON and present in rendered HTML | [ ] |
| Business/contact data in schema matches on-page content | [ ] |
| Breadcrumb / FAQ / Article / Product schema used only where appropriate | [ ] |
| Structured data validated with a schema/rich results tool | [ ] |

### Performance & Technical SEO (Automated)

| Check | Target / Evidence | Status |
|-------|-------------------|--------|
| Largest Contentful Paint is acceptable on key pages | field/lab data | [ ] |
| Interaction to Next Paint is acceptable on key pages | field/lab data | [ ] |
| Cumulative Layout Shift is acceptable on key pages | field/lab data | [ ] |
| Images use modern formats and correct sizing | audit | [ ] |
| Fonts, CSS, and JS loading are optimized intentionally | audit | [ ] |
| Broken links and redirect chains checked | crawler/report | [ ] |

### Search Tooling (Automated Monitoring)

| Check | Status |
|-------|--------|
| Crawl/index coverage issues are monitored after launch | [ ] |

---

## GEO / Local Discoverability (Automated Checks)

| Check | Status |
|-------|--------|
| Map embed or directions link works | [ ] |
| Location page works without the map embed | [ ] |
| CSP allows only required map domains | [ ] |
| Mobile users can tap to call / navigate | [ ] |

---

## Operations & Maintenance (Automated Monitoring)

### Automated Monitoring Checks

| Check | Evidence | Status |
|-------|----------|--------|
| Error tracker receives test event | dashboard evidence | [ ] |
| Logs show no immediate spike in 4xx/5xx | dashboard evidence | [ ] |
| Performance is within expected range | Lighthouse / RUM / APM | [ ] |

### Optional: IndexNow Protocol

| Check | Status |
|-------|--------|
| IndexNow host key file hosted at `/.well-known/indexnow` | [ ] |
| IndexNow ping sent on content publish (optional) | [ ] |

---

## Useful Commands for Automation

```bash
# Build / verification
npm ci
npm run build
npm test
npm run lint
npm run typecheck

# Security / dependencies
npm audit
npm outdated

# DNS / headers / redirects
dig {{DOMAIN}}
curl -I https://{{DOMAIN}}
curl -I http://{{DOMAIN}}

# SEO spot checks
curl https://{{DOMAIN}}/robots.txt
curl https://{{DOMAIN}}/sitemap.xml
curl https://{{DOMAIN}}/llms.txt

# Live SEO smoke check (if available)
npm run check:seo-live -- https://{{DOMAIN}} https://{{DOMAIN}}
```

---

*Document auto-generated from: 12-comprehensive-deployment-security-seo-geo-checklist.md*
