# Semi-Automated Tasks

These tasks involve a combination of automated tooling and human judgment. Automation handles the checking/scan, but human review is needed to interpret results, make decisions, or handle exceptions.

---

## Deployment Readiness

### Dependency Audit

| Check | Priority | Evidence | Status |
|-------|----------|----------|--------|
| Dependency audit triaged | P0 | `npm audit`, SCA tool, or issue references | [ ] |

**Semi-automation note:** `npm audit` runs automatically, but triaging findings (deciding which vulnerabilities are acceptable risk) requires human judgment.

---

## SEO Tool Stack Integration

This checklist supports the **Stack A SEO Dashboard** implementation strategy. See:
- **Tool Integration Strategy:** `Workflow-Scripts/07-deployment/08-port-relocation/2026-03-18-SEO-Dashboard/2026-03-18-seo-tool-integration-strategy.md`
- **Implementation Plan:** `Workflow-Scripts/07-deployment/08-port-relocation/2026-03-18-SEO-Dashboard/2026-03-18-stack-a-seo-dashboard-implementation-plan.md`

### Tool Stack Reference (Stack A - Zero-Cost Consolidation)

| Tool | Purpose | Coverage |
|------|---------|----------|
| **Google Search Console** | Core monitoring, indexing, performance | M2, M3, M5, M8, M9, M10, M12-M14 |
| **Looker Studio + Porter Metrics** | Unified reporting dashboards | M5, M9, M12-M14 |
| **GitHub Actions (Lighthouse CI)** | Automated technical validation | M1, M2, M3, M12-M14 |
| **GitHub Projects** | SEO task management | M1-M17 |
| **SEO Panel** (self-hosted) | Rank tracking, site audits, backlinks | M4, M7, M10, M15 |
| **CookieYes Free** | Consent management (PDPA) | M6 |
| **CrawlerCheck** | AI crawler monitoring | M16 |
| **llmstxt.org** | AI discovery optimization | M17 |
| **Voyage GEO** (OpenRouter API) | AI visibility tracking | GEO-1 to GEO-6 |
| **Canonry** | AI citation monitoring | GEO-3 |

**Cost:** $12-30/month total (hosting + API credits)

### Source Maps Handling

| Check | Priority | Evidence | Status |
|-------|----------|----------|--------|
| Source maps handled intentionally | P0 | Disabled or uploaded to error tracker | [ ] |

**Semi-automation note:** Build process can disable source maps automatically, but human must decide whether to upload to error tracker.

---

## Security Checklist

### CSP Implementation

| Check | Priority | Status |
|-------|----------|--------|
| CSP implemented intentionally | P0 | enforced or staged rollout | [ ] |

**Semi-automation note:** CSP can be generated and deployed automatically, but planning the policy (what to allow/deny) and handling violations requires human review.

### CSP Quality Review

| Check | Priority | Status |
|-------|----------|--------|
| Uses allowlists and nonces/hashes where feasible | P0 | [ ] |
| Avoids `unsafe-eval` in production | P0 | [ ] |
| Any `unsafe-inline` usage is justified and minimized | P1 | [ ] |
| Tested in report-only mode before enforcement when practical | P1 | [ ] |
| Third-party script domains are documented | P1 | [ ] |

**Semi-automation note:** CSP can be validated automatically, but the policy decisions (what's necessary vs. what's risky) require human review.

---

## SEO Checklist

### Sitemap Submission

| Check | Priority | Status |
|-------|----------|--------|
| Sitemap submitted to search tools | P1 | [ ] |

**Semi-automation note:** Sitemap is auto-generated, but submission to search tools requires human action (one-time setup).

### Structured Data Validation

| Check | Priority | Status |
|-------|----------|--------|
| Schema type matches actual page/business type | P0 | [ ] |
| JSON-LD is valid JSON and present in rendered HTML | P0 | [ ] |
| Business/contact data in schema matches on-page content | P0 | [ ] |
| Breadcrumb / FAQ / Article / Product schema used only where appropriate | P1 | [ ] |
| Structured data validated with a schema/rich results tool | P1 | [ ] |

**Semi-automation note:** Validation tools can check schema automatically, but determining which schema types are appropriate requires human judgment.

### Performance Validation

| Check | Priority | Target / Evidence | Status |
|-------|----------|-------------------|--------|
| Largest Contentful Paint is acceptable on key pages | P1 | field/lab data | [ ] |
| Interaction to Next Paint is acceptable on key pages | P1 | field/lab data | [ ] |
| Cumulative Layout Shift is acceptable on key pages | P1 | field/lab data | [ ] |
| Images use modern formats and correct sizing | P1 | audit | [ ] |
| Fonts, CSS, and JS loading are optimized intentionally | P1 | audit | [ ] |
| Broken links and redirect chains checked | P0 | crawler/report | [ ] |

**Semi-automation note:** Tools like Lighthouse can measure performance automatically, but defining "acceptable" thresholds and prioritizing fixes require human judgment.

---

## GEO / Local Discoverability

### Map Integration

| Check | Priority | Status |
|-------|----------|--------|
| Map embed or directions link works | P1 | [ ] |
| Location page works without the map embed | P1 | [ ] |
| CSP allows only required map domains | P1 | [ ] |
| Mobile users can tap to call / navigate | P1 | [ ] |

**Semi-automation note:** Links can be tested automatically, but verifying user experience on mobile devices requires human testing.

---

## Operations & Maintenance

### Weekly Checks (Human + Automated Monitoring)

| Check | Status |
|-------|--------|
| Review uptime, errors, and alert noise | [ ] |
| Review key business flow success rates | [ ] |
| Review new reviews/messages if local business | [ ] |

**Semi-automation note:** Monitoring tools collect data automatically, but human must review and interpret the data.

### Monthly Checks (Human Review of Automated Reports)

| Check | Status |
|-------|--------|
| Review dependency/security advisories | [ ] |
| Review crawl/indexing health | [ ] |
| Review Core Web Vitals / performance trends | [ ] |
| Re-check redirects, sitemap, and canonical consistency | [ ] |

**Semi-automation note:** Reports can be generated automatically, but human must review and act on findings.

### Quarterly Checks (Human + Automated)

| Check | Status |
|-------|--------|
| Restore from backup in a test path or validate restore drill | [ ] |
| Review secrets, permissions, and stale access | [ ] |
| Review structured data and local listing accuracy | [ ] |
| Revisit AI crawler policy and `llms.txt` only if still maintained | [ ] |

**Semi-automation note:** Backups can be automated, but validating restore procedures and reviewing access requires human involvement.

### GEO Spot-Checks (Quarterly)

| Check | Tool | Status |
|-------|------|--------|
| Test branded prompts in ChatGPT/Claude/Perplexity | Voyage GEO (CLI) | [ ] |
| Test non-branded prompts in AI tools | Voyage GEO (CLI) | [ ] |
| Verify citations are accurate (NAP, hours, services) | Manual review | [ ] |
| Track AI citations of domain | Canonry (self-hosted) | [ ] |
| Document any incorrect information found | GitHub Issue | [ ] |

**Semi-automation note:** Voyage GEO automates querying multiple AI engines; human must verify citation accuracy and create issues for incorrect information.

### GEO AI Visibility Monitoring (Monthly)

| Check | Tool | Status |
|-------|------|--------|
| Brand mention rate across AI engines | Voyage GEO HTML report | [ ] |
| Citation context analysis | Canonry dashboard | [ ] |
| Sentiment analysis of mentions | Voyage GEO JSON export | [ ] |
| Competitor AI visibility comparison | Voyage GEO (manual comparison) | [ ] |
| AI answer position tracking | Voyage GEO | [ ] |

**Reference:** Full GEO tool setup in `Workflow-Scripts/07-deployment/08-port-relocation/2026-03-18-SEO-Dashboard/2026-03-18-seo-tool-integration-strategy.md` Section "Extended Stack A: Zero-Cost + GEO"

### Content Refresh Workflow

| Check | Status |
|-------|--------|
| "Last updated" convention defined (any change vs material) | [ ] |
| Key pages refresh schedule defined (hours, services, doctor info) | [ ] |
| Policy pages reviewed for accuracy | [ ] |

**Semi-automation note:** Automation can flag stale content, but human must review and approve updates.

---

## Example Automation Scripts

### Semi-Automated Dependency Review

```bash
#!/bin/bash
# Run npm audit and generate report
npm audit --json > dependency-audit-$(date +%Y%m%d).json

# Automated: Check for critical/high vulnerabilities
if grep -q '"severity":"critical"' dependency-audit-$(date +%Y%m%d).json; then
  echo "⚠️  Critical vulnerabilities found - manual review required"
  # Human must triage: are these exploitable? can we accept risk?
fi
```

### Semi-Automated Performance Check

```bash
#!/bin/bash
# Run Lighthouse CI (automated)
npx lighthouse https://{{DOMAIN}} --output=json --output-path=lighthouse-report-$(date +%Y%m%d).json

# Automated: Check thresholds
LCP=$(cat lighthouse-report-$(date +%Y%m%d).json | jq '.audits["largest-contentful-paint"].numericValue')
if [ "$LCP" -gt 2500 ]; then
  echo "⚠️  LCP exceeds 2.5s - human review needed to prioritize fixes"
fi
```

---

*Document auto-generated from: 12-comprehensive-deployment-security-seo-geo-checklist.md*
