# Routine Monitoring Tasks

These tasks require ongoing, periodic attention after deployment to ensure continued health, security, and performance.

---

## Daily Monitoring

### Production Health

| Check | Priority | Evidence | Status |
|-------|----------|----------|--------|
| Homepage loads on production | P0 | browser / curl | [ ] |
| Critical journeys pass | P0 | smoke test result | [ ] |
| Forms, auth, payments, or booking flows tested if present | P0 | smoke test result | [ ] |
| Error tracker receives test event | P1 | dashboard evidence | [ ] |
| Logs show no immediate spike in 4xx/5xx | P0 | dashboard evidence | [ ] |
| Performance is within expected range | P1 | Lighthouse / RUM / APM | [ ] |

### GEO Dashboard

| Check | Priority | Status |
|-------|----------|--------|
| GitHub Pages GEO dashboard accessible | P1 | [ ] |
| Latest Voyage GEO report uploaded | P1 | [ ] |
| Canonry citation data up-to-date | P2 | [ ] |

**Reference:** GEO Dashboard deployment in `Workflow-Scripts/12-SEO-GEO-checklist/2026-03-18-SEO-Dashboard/2026-03-18-stack-a-seo-dashboard-implementation-plan.md` Section P3.3

---

## Weekly Monitoring

### Uptime & Error Review

| Check | Status |
|-------|--------|
| Review uptime, errors, and alert noise | [ ] |
| Review key business flow success rates | [ ] |
| Review new reviews/messages if local business | [ ] |

### Looker Studio Dashboard Review

| Check | Status |
|-------|--------|
| Review Looker Studio Executive Summary (auto-emailed Monday 9 AM) | [ ] |
| Check Lighthouse CI results from Monday run | [ ] |
| Check for new GSC alerts | [ ] |
| GitHub Project board review for blocked items | [ ] |

### Alert Triage

| Check | Priority | Status |
|-------|----------|--------|
| Alerts exist for sustained 5xx/auth abuse/spikes | P1 | [ ] |
| Alert destinations confirmed | P1 | [ ] |

---

## Monthly Monitoring

### SEO Panel Review (If Deployed)

| Check | Status |
|-------|--------|
| Keyword ranking report review | [ ] |
| Site audit review and action items | [ ] |
| Backlink monitoring review | [ ] |
| SEO Panel sync script ran successfully | [ ] |

### Dependency & Security

| Check | Status |
|-------|--------|
| Review dependency/security advisories | [ ] |
| Review crawl/indexing health | [ ] |
| Review Core Web Vitals / performance trends | [ ] |
| Re-check redirects, sitemap, and canonical consistency | [ ] |

### SEO Health

| Check | Priority | Status |
|-------|----------|--------|
| Google Search Console coverage issues | P1 | [ ] |
| Crawl/index coverage issues are monitored after launch | P1 | [ ] |

### Local Business (If Applicable)

| Check | Priority | Status |
|-------|----------|--------|
| Google Business Profile is claimed and accurate | P1 | [ ] |
| Website NAP matches directory and map listings | P0 | [ ] |
| Opening hours are current and timezone-aware | P0 | [ ] |

---

## Quarterly Monitoring

### GEO / AI Citation Monitoring

| Check | Priority | Status |
|-------|----------|--------|
| AI citation spot-check scheduled | P2 | [ ] |
| Branded queries tested (ChatGPT, Claude, Perplexity) | P2 | [ ] |
| Non-branded queries tested in AI tools | P2 | [ ] |
| Incorrect citations documented and remediated | P1 | [ ] |

### Backup & Recovery

| Check | Priority | Status |
|-------|----------|--------|
| Restore from backup in a test path or validate restore drill | P0 | [ ] |
| Backup/restore procedure exists and is periodically tested | P0 | [ ] |

### Security Review

| Check | Priority | Status |
|-------|----------|--------|
| Review secrets, permissions, and stale access | P0 | [ ] |
| Review structured data and local listing accuracy | P0 | [ ] |
| Revisit AI crawler policy and `llms.txt` only if still maintained | P2 | [ ] |

### Performance Audit

| Check | Priority | Status |
|-------|----------|--------|
| Largest Contentful Paint is acceptable on key pages | P1 | [ ] |
| Interaction to Next Paint is acceptable on key pages | P1 | [ ] |
| Cumulative Layout Shift is acceptable on key pages | P1 | [ ] |
| Images use modern formats and correct sizing | P1 | [ ] |
| Broken links and redirect chains checked | P0 | [ ] |

---

## Incident Response

### On-Call Checklist

When alerts fire or issues are reported:

| Check | Priority | Status |
|-------|----------|--------|
| Incident contact and escalation path are documented | P1 | [ ] |
| Rollback method documented and tested | P0 | [ ] |
| Rollback decision threshold agreed | P1 | [ ] |

### Security Incident

| Check | Priority | Status |
|-------|----------|--------|
| Security-relevant events are logged | P1 | [ ] |
| Secrets and PII are not written to logs | P0 | [ ] |
| Incident response plan accessible | P1 | [ ] |

---

## Monitoring Setup Checklist

### Required Monitoring Tools

| Tool | Purpose | Status |
|------|---------|--------|
| Error tracker (e.g., Sentry) | Runtime error monitoring | [ ] |
| Uptime monitor | Availability tracking | [ ] |
| Log aggregator | Log analysis | [ ] |
| Performance monitoring | Core Web Vitals, RUM | [ ] |
| Security alerts | Vulnerability notifications | [ ] |

### Alert Configuration

| Alert | Threshold | Destination | Status |
|-------|-----------|-------------|--------|
| 5xx error spike | > 10/min | {{ALERT_CHANNEL}} | [ ] |
| Auth abuse | > 5 failed/min | {{ALERT_CHANNEL}} | [ ] |
| Uptime down | < 99.9% | {{ALERT_CHANNEL}} | [ ] |
| Performance regression | LCP > 4s | {{ALERT_CHANNEL}} | [ ] |

---

## Monitoring Commands Reference

```bash
# Check HTTPS headers
curl -I https://{{DOMAIN}}

# Check robots.txt
curl https://{{DOMAIN}}/robots.txt

# Check sitemap
curl https://{{DOMAIN}}/sitemap.xml

# DNS verification
dig {{DOMAIN}}

# Error rate check (requires log access)
grep " 5[0-9][0-9] " access.log | wc -l

# SSL certificate check
openssl s_client -connect {{DOMAIN}}:443 -servername {{DOMAIN}} 2>/dev/null | openssl x509 -noout -dates
```

---

## Dashboard Links

| Dashboard | URL | Status |
|-----------|-----|--------|
| Error Tracker | {{ERROR_TRACKER_URL}} | [ ] |
| Uptime Monitor | {{UPTIME_URL}} | [ ] |
| Performance | {{PERFORMANCE_URL}} | [ ] |
| Logs | {{LOGS_URL}} | [ ] |
| Google Search Console | https://search.google.com/search-console | [ ] |
| Looker Studio (Unified Reporting) | https://lookerstudio.google.com | [ ] |
| SEO Panel (Self-Hosted) | https://seo.{{DOMAIN}} | [ ] |
| GEO Visibility Dashboard | https://{{OWNER}}.github.io/{{REPO}}/geo-dashboard | [ ] |

---

*Document auto-generated from: 12-comprehensive-deployment-security-seo-geo-checklist.md*
