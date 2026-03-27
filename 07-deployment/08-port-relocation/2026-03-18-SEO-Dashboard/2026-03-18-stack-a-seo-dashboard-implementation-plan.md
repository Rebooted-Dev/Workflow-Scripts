---
name: stack-a-seo-dashboard-implementation-plan
overview: Detailed implementation plan for Stack A SEO Dashboard MVP with priority-ordered phases, dependencies, and verification steps
status: draft
created: 2026-03-18
updated: 2026-03-18
type: implementation-plan
priority: high
consolidated_from:
  - /Volumes/Skynet/Software Development Projects/Websites/Ai-Mian's-Clinic/project/plans/2026-03-18-SEO-Dashboard/2026-03-18-stack-a-mvp-poc-implementation-plan.md
---

# Stack A SEO Dashboard - Detailed Implementation Plan

**Created:** 2026-03-18 15:45  
**Consolidated From:** `2026-03-18-stack-a-mvp-poc-implementation-plan.md`  
**Status:** 🟡 Draft - Ready for Review  
**Total Estimated Effort:** 28-36 hours  
**Target Completion:** 6 weeks (Week 1-6)

---

## Executive Summary

This plan consolidates the Stack A MVP & Proof of Concept implementation strategy into a priority-ordered roadmap (P0-P3) with clear dependencies, effort estimates, and verification steps. Stack A consolidates 35+ scattered SEO tools into 8 core components at **$12-30/month** cost, achieving **95%+ M-task coverage** with full AI visibility (GEO) capabilities.

### Key Decisions Made

| Decision | Rationale |
|----------|-----------|
| **Priority Order** | P0 = Foundation/blockers, P1 = Core automation, P2 = Enhanced features, P3 = Optimization |
| **No .github directory exists** | Must create all GitHub infrastructure from scratch |
| **SEO files already present** | robots.txt, sitemap.xml, llms.txt exist in website/public/ - leverage existing foundation |
| **TypeScript-first approach** | Aligns with existing React 19 + Express TypeScript stack |
| **Phase-based delivery** | Each phase has clear entry/exit criteria for measurable progress |

---

## Current State Analysis

### What's Already In Place ✅

| Component | Status | Location | Notes |
|-----------|--------|----------|-------|
| **robots.txt** | ✅ Exists | `website/public/robots.txt` | Ready for AI crawler directives |
| **sitemap.xml** | ✅ Exists | `website/public/sitemap.xml` | Ready for auto-generation workflow |
| **llms.txt** | ✅ Exists | `website/public/llms.txt` | Ready for Firecrawl automation |
| **React 19 + TypeScript** | ✅ Ready | `website/` | TypeScript SEO tooling compatible |
| **Express + TypeScript** | ✅ Ready | `server/` | API endpoints ready for SEO data |
| **Git repository** | ✅ Active | Project root | GitHub Actions can be added |

### What Needs to Be Created 🆕

| Component | Status | Required For | Priority |
|-----------|--------|--------------|----------|
| **.github/workflows/** | ❌ Missing | All automation | P0 |
| **.github/ISSUE_TEMPLATE/** | ❌ Missing | Standardized workflows | P0 |
| **GitHub Project** | ❌ Missing | Task management | P0 |
| **SEO Panel hosting** | ❌ Missing | Rank tracking, audits | P1 |
| **TypeScript SEO scripts** | ❌ Missing | Firecrawl, GEO analyzer | P1 |
| **Looker Studio dashboard** | ❌ Missing | Unified reporting | P0 |

---

## Priority-Ordered Roadmap

### Legend

**Priority Levels:**
- **P0 Blocker:** Critical path, must complete before merge/release
- **P1 Urgent:** High impact, required for full functionality
- **P2 Soon:** Medium impact, next sprint priority
- **P3 Backlog:** Low impact, nice-to-have optimizations

**Effort Labels:**
- **Small:** 30 min - 2 hours
- **Medium:** 2-6 hours
- **Large:** 6-12 hours

**Dependencies:**
- `→` = Must complete before
- `↔` = Can run in parallel

---

## P0: Foundation & Prerequisites (Week 1)

**Goal:** Establish essential infrastructure for all subsequent work  
**Duration:** Week 1 (4-6 hours)  
**Success Criteria:** All P0 items complete → Unblocks P1 work

### P0.1: Google Search Console Setup

**Effort:** Medium (2-3 hours)  
**Dependencies:** None  
**Blocks:** P0.2, P0.3, P1.3

#### Tasks:

- [ ] **P0.1.1** Verify GSC ownership (HTML file or DNS TXT record)
  - **Effort:** Small (30 min)
  - **Exit Criteria:** GSC shows "Ownership verified" status
  - **Notes:** URL prefix: `https://abundantblessings.sg`

- [ ] **P0.1.2** Submit sitemap.xml to GSC
  - **Effort:** Small (15 min)
  - **Exit Criteria:** Sitemap status shows "Success" in GSC
  - **Notes:** Sitemap URL: `https://abundantblessings.sg/sitemap.xml`

- [ ] **P0.1.3** Enable all GSC email alerts
  - **Effort:** Small (15 min)
  - **Exit Criteria:** All notification types enabled
  - **Alerts to Enable:**
    - Critical issues detected
    - Manual actions
    - Indexing issues
    - Mobile usability issues
    - Core Web Vitals issues

- [ ] **P0.1.4** Configure GSC settings
  - **Effort:** Small (30 min)
  - **Exit Criteria:** Settings match clinic requirements
  - **Configuration:**
    - Set preferred domain (www or non-www)
    - Link to GA4 property (if available)
    - Set international targeting (Singapore)

#### Exit Criteria (P0.1):
- [ ] GSC ownership verified
- [ ] Sitemap submitted and validated
- [ ] All alerts enabled
- [ ] Clinic can access GSC dashboard

---

### P0.2: Looker Studio Dashboard Setup

**Effort:** Medium (2-3 hours)  
**Dependencies:** P0.1 (GSC access required)  
**Blocks:** P1.4, P2.1

#### Tasks:

- [ ] **P0.2.1** Create Looker Studio account and new report
  - **Effort:** Small (15 min)
  - **Exit Criteria:** Report created and accessible

- [ ] **P0.2.2** Add Porter Metrics GSC template
  - **Effort:** Small (30 min)
  - **Exit Criteria:** Template imported with clinic branding
  - **Template:** SEO Performance Dashboard (Free) from portermetrics.com

- [ ] **P0.2.3** Connect data sources
  - **Effort:** Small (30 min)
  - **Exit Criteria:** All data sources connected and refreshing
  - **Sources:**
    - Google Search Console (abundantblessings.sg)
    - Google Analytics 4 (if available)
    - PageSpeed Insights (optional)

- [ ] **P0.2.4** Create dashboard views
  - **Effort:** Medium (1 hour)
  - **Exit Criteria:** 3 views created with relevant metrics
  - **Views Required:**
    1. **Executive Summary** (1-page)
       - Total clicks (last 28 days)
       - Total impressions
       - Average CTR
       - Average position
       - Top 5 keywords
    2. **Technical Performance**
       - Core Web Vitals
       - Mobile usability
       - Indexing status
    3. **Monthly Trends**
       - Clicks over time
       - Impressions over time
       - Position trends

- [ ] **P0.2.5** Schedule automated reports
  - **Effort:** Small (15 min)
  - **Exit Criteria:** Reports scheduled and test email received
  - **Schedule:**
    - Weekly: Executive Summary (Monday 9 AM)
    - Monthly: Full Report (1st of month)

#### Exit Criteria (P0.2):
- [ ] Looker Studio dashboard accessible
- [ ] 3 views created with clinic data
- [ ] Scheduled reports configured
- [ ] Clinic owner receives test report

---

### P0.3: GitHub Infrastructure Setup

**Effort:** Medium (2-3 hours)  
**Dependencies:** None  
**Blocks:** P1.1, P1.2, P1.3

#### Tasks:

- [ ] **P0.3.1** Create .github directory structure
  - **Effort:** Small (15 min)
  - **Exit Criteria:** Directory structure exists
  - **Structure:**
    ```
    .github/
    ├── workflows/
    ├── ISSUE_TEMPLATE/
    └── scripts/
    ```

- [ ] **P0.3.2** Create GitHub Project "SEO Operations"
  - **Effort:** Small (30 min)
  - **Exit Criteria:** Project created with custom fields
  - **Configuration:**
    - Template: Team Planning
    - Custom Fields:
      - Category (Technical, Content, Local SEO, Analytics, AI Visibility)
      - Task Type (M1-M17 mapping)
      - Priority (P0-Critical, P1-High, P2-Medium, P3-Low)
      - Status (Backlog, In Progress, Review, Done, Blocked)
      - Impact Score (0-100)
    - Views: Board (Kanban), Table, Roadmap

- [ ] **P0.3.3** Configure auto-add workflow
  - **Effort:** Small (15 min)
  - **Exit Criteria:** Issues labeled 'seo' auto-added to project
  - **Filter:** Label = "seo" OR "technical-seo" OR "local-seo"

- [ ] **P0.3.4** Create issue templates
  - **Effort:** Medium (1 hour)
  - **Exit Criteria:** Templates accessible when creating issues
  - **Templates Required:**
    - technical-seo-audit.yml (M1-M3, M5, M12-M14)
    - local-seo-task.yml (M4, M7, M10, M15)
    - geo-visibility-alert.yml (M16-M17)

- [ ] **P0.3.5** Add initial SEO tasks to project board
  - **Effort:** Small (30 min)
  - **Exit Criteria:** 5+ tasks created in project
  - **Initial Tasks:**
    - M1: DNS/TLS Audit
    - M2: robots.txt/sitemap validation
    - M4: GBP Optimization
    - M5: GSC Setup (mark as Done after P0.1)
    - M12: Monitoring setup

#### Exit Criteria (P0.3):
- [ ] .github/ directory structure created
- [ ] GitHub Project configured with custom fields
- [ ] 3 issue templates created
- [ ] 5+ initial tasks in project board
- [ ] Auto-add workflow active

---

### P0 Phase Summary

| Item | Effort | Status | Exit Criteria |
|------|--------|--------|---------------|
| P0.1 GSC Setup | Medium | ⬜ | Ownership verified, sitemap submitted, alerts enabled |
| P0.2 Looker Studio | Medium | ⬜ | Dashboard with 3 views, scheduled reports |
| P0.3 GitHub Infrastructure | Medium | ⬜ | Project board, issue templates, workflows directory |
| **P0 Total** | **6-9 hours** | | **Foundation ready for P1** |

---

## P1: Core Automation (Week 2)

**Goal:** Implement automated validation and monitoring  
**Duration:** Week 2 (6-8 hours)  
**Success Criteria:** All P1 items complete → Automated validation active

### P1.1: Lighthouse CI Workflow

**Effort:** Medium (2-3 hours)  
**Dependencies:** P0.3 (.github/workflows/ directory)  
**Blocks:** None

#### Tasks:

- [ ] **P1.1.1** Create Lighthouse CI workflow file
  - **Effort:** Small (30 min)
  - **Exit Criteria:** `.github/workflows/seo-lighthouse.yml` created
  - **Triggers:** Push to main, PR to main, weekly schedule (Monday 6 AM), manual

- [ ] **P1.1.2** Create lighthouse-budget.json
  - **Effort:** Small (30 min)
  - **Exit Criteria:** Budget file committed
  - **Budgets:**
    - Document: 50KB
    - Stylesheet: 150KB
    - Image: 500KB
    - Script: 300KB
    - Total: 1500KB
    - LCP: 2500ms
    - FCP: 1800ms
    - CLS: 0.1

- [ ] **P1.1.3** Create lighthouserc.json
  - **Effort:** Small (30 min)
  - **Exit Criteria:** Config file committed
  - **Assertions:**
    - Performance: warn at 0.8
    - Accessibility: error at 0.9
    - Best Practices: warn at 0.9
    - SEO: error at 0.95

- [ ] **P1.1.4** Test workflow
  - **Effort:** Small (30 min)
  - **Exit Criteria:** Workflow runs successfully, artifacts uploaded
  - **Test URLs:**
    - https://abundantblessings.sg/
    - https://abundantblessings.sg/about
    - https://abundantblessings.sg/services
    - https://abundantblessings.sg/contact

#### Exit Criteria (P1.1):
- [ ] Lighthouse CI runs on every PR
- [ ] Weekly scheduled runs active
- [ ] Budget and config files in repo
- [ ] Artifacts uploaded on each run

---

### P1.2: Broken Link Checker Workflow

**Effort:** Small (1-2 hours)  
**Dependencies:** P0.3 (.github/workflows/ directory)  
**Blocks:** None

#### Tasks:

- [ ] **P1.2.1** Create broken link checker workflow
  - **Effort:** Small (30 min)
  - **Exit Criteria:** `.github/workflows/seo-broken-links.yml` created
  - **Schedule:** Weekly (Wednesday 2 AM)
  - **Exclusions:** linkedin.com, facebook.com, twitter.com, wa.me

- [ ] **P1.2.2** Configure issue creation on failure
  - **Effort:** Small (30 min)
  - **Exit Criteria:** Failed runs create GitHub issues
  - **Issue Labels:** seo, broken-links, technical-seo

- [ ] **P1.2.3** Test workflow manually
  - **Effort:** Small (15 min)
  - **Exit Criteria:** Manual trigger works, no false positives

#### Exit Criteria (P1.2):
- [ ] Weekly broken link checks running
- [ ] Issues auto-created for broken links
- [ ] Common exclusions configured

---

### P1.3: Sitemap Auto-Generation Workflow

**Effort:** Medium (2-3 hours)  
**Dependencies:** P0.3 (.github/workflows/ directory)  
**Blocks:** None  
**Architecture Note:** Server-side dynamic generation for SPA with anchor links (see Appendix D)

#### Tasks:

- [ ] **P1.3.1** Create sitemap generation TypeScript script
  - **Effort:** Medium (1 hour)
  - **Exit Criteria:** `scripts/generate-sitemap.ts` generates valid XML
  - **Implementation:**
    ```typescript
    // scripts/generate-sitemap.ts
    // Reads website/src/App.tsx sections
    // Generates XML with section anchors for single-page site
    const routes = [
      { url: 'https://abundantblessings.sg/', priority: 1.0, changefreq: 'monthly' },
      { url: 'https://abundantblessings.sg/#services', priority: 0.8, changefreq: 'monthly' },
      { url: 'https://abundantblessings.sg/#about', priority: 0.8, changefreq: 'monthly' },
      { url: 'https://abundantblessings.sg/#contact', priority: 0.8, changefreq: 'monthly' },
      { url: 'https://abundantblessings.sg/#faq', priority: 0.6, changefreq: 'monthly' },
    ];
    ```
  - **Output:** `server/config/sitemap.xml` (server as source of truth)

- [ ] **P1.3.2** Create sitemap generation workflow
  - **Effort:** Small (30 min)
  - **Exit Criteria:** `.github/workflows/seo-sitemap.yml` created
  - **Triggers:** 
    - Push to main (when `website/src/**` changes)
    - Schedule: Weekly (Sunday 2 AM)
    - Manual dispatch
  - **Strategy:** Server-side generation (see Appendix D)
    ```yaml
    # Generates sitemap to server/config/sitemap.xml
    # Leverages existing Express endpoint: GET /sitemap.xml
    ```

- [ ] **P1.3.3** Configure auto-commit
  - **Effort:** Small (15 min)
  - **Exit Criteria:** Sitemap commits automatically
  - **Path:** `server/config/sitemap.xml`
  - **Note:** Server already serves this at `/sitemap.xml` (404 in staging)

- [ ] **P1.3.4** Test workflow
  - **Effort:** Small (15 min)
  - **Exit Criteria:** 
    - Test push generates updated sitemap
    - `curl https://abundantblessings.sg/sitemap.xml` returns valid XML
    - Contains section anchors (#services, #about, #contact)

#### Exit Criteria (P1.3):
- [ ] TypeScript sitemap generator script created
- [ ] Sitemap auto-generates on content changes to `website/src/`
- [ ] Outputs to `server/config/sitemap.xml` (not website/public/)
- [ ] Commits pushed automatically
- [ ] Express endpoint serves fresh sitemap
- [ ] No manual sitemap updates needed

---

### P1.4: CookieYes Implementation (M6)

**Effort:** Small (1 hour)  
**Dependencies:** P0.1 (site ownership confirmed)  
**Blocks:** None

#### Tasks:

- [ ] **P1.4.1** Sign up for CookieYes Free
  - **Effort:** Small (15 min)
  - **Exit Criteria:** Account created, script provided

- [ ] **P1.4.2** Add CookieYes script to website
  - **Effort:** Small (30 min)
  - **Exit Criteria:** Script in website `<head>`

- [ ] **P1.4.3** Test consent flow
  - **Effort:** Small (15 min)
  - **Exit Criteria:** Banner displays, consent logged

#### Exit Criteria (P1.4):
- [ ] CookieYes banner live on site
- [ ] Consent logging active
- [ ] PDPA compliance achieved

---

### P1.5: AI Crawler Configuration (M16)

**Effort:** Small (1 hour)  
**Dependencies:** None  
**Blocks:** P3.1

#### Tasks:

- [ ] **P1.5.1** Update robots.txt with AI crawler directives
  - **Effort:** Small (30 min)
  - **Exit Criteria:** robots.txt includes AI directives
  - **Directives:**
    - GPTBot
    - ClaudeBot
    - Google-Extended
    - PerplexityBot

- [ ] **P1.5.2** Set up CrawlerCheck monitoring
  - **Effort:** Small (15 min)
  - **Exit Criteria:** Domain registered, monitoring active

- [ ] **P1.5.3** Configure Cloudflare AI Bot Management (optional)
  - **Effort:** Small (15 min)
  - **Exit Criteria:** AI Content Protection enabled

#### Exit Criteria (P1.5):
- [ ] robots.txt has AI crawler directives
- [ ] CrawlerCheck monitoring domain
- [ ] AI bot policy documented

---

### P1 Phase Summary

| Item | Effort | Status | Exit Criteria |
|------|--------|--------|---------------|
| P1.1 Lighthouse CI | Medium | ⬜ | Automated on PR + weekly |
| P1.2 Broken Links | Small | ⬜ | Weekly checks, auto-issues |
| P1.3 Sitemap Generator | Medium | ⬜ | Server-side generation, TypeScript script |
| P1.4 CookieYes | Small | ⬜ | Banner live, consent logging |
| P1.5 AI Crawlers | Small | ⬜ | robots.txt updated, monitoring |
| **P1 Total** | **7-10 hours** | | **Core automation active** |

---

## P2: SEO Panel & TypeScript Tooling (Week 3-4)

**Goal:** Deploy SEO Panel and implement TypeScript-based SEO scripts  
**Duration:** Week 3-4 (8-10 hours)  
**Success Criteria:** SEO Panel operational, custom scripts working

### P2.1: SEO Panel Deployment

**Effort:** Large (6-8 hours)  
**Dependencies:** P0.1 (GSC for data), P0.2 (reporting strategy)  
**Blocks:** P2.2

#### Tasks:

- [ ] **P2.1.1** Select and purchase hosting
  - **Effort:** Small (30 min)
  - **Exit Criteria:** Hosting account active with credentials
  - **Options:** Hostinger ($2.99/mo), Namecheap ($1.98/mo), DigitalOcean ($4/mo)
  - **Requirements:** PHP 7.4+, MySQL 5.7+, SSL

- [ ] **P2.1.2** Create MySQL database
  - **Effort:** Small (30 min)
  - **Exit Criteria:** Database and user created
  - **SQL:**
    ```sql
    CREATE DATABASE seopanel CHARACTER SET utf8mb4;
    CREATE USER 'seopanel_user'@'localhost' IDENTIFIED BY 'strong_password';
    GRANT ALL PRIVILEGES ON seopanel.* TO 'seopanel_user'@'localhost';
    ```

- [ ] **P2.1.3** Download and upload SEO Panel
  - **Effort:** Small (30 min)
  - **Exit Criteria:** Files uploaded to hosting
  - **Source:** github.com/seopanel/Seo-Panel releases

- [ ] **P2.1.4** Run web installer
  - **Effort:** Medium (1 hour)
  - **Exit Criteria:** Installation completes successfully
  - **Steps:**
    1. System requirements check
    2. Database configuration
    3. Admin account creation
    4. Installation complete

- [ ] **P2.1.5** Post-installation security
  - **Effort:** Small (30 min)
  - **Exit Criteria:** Install directory removed, permissions set
  - **Actions:**
    - Delete /install/ directory
    - Set proper file permissions (755 for dirs, 644 for config)

- [ ] **P2.1.6** Add website and configure
  - **Effort:** Small (30 min)
  - **Exit Criteria:** Website added, tracking configured
  - **Settings:**
    - Name: Abundant Blessings Clinic
    - URL: https://abundantblessings.sg
    - Category: Healthcare

- [ ] **P2.1.7** Configure search engines
  - **Effort:** Small (30 min)
  - **Exit Criteria:** 3 search engines configured
  - **Engines:**
    - Google Singapore (google.com.sg)
    - Google Malaysia (google.com.my)
    - Google International (google.com)

- [ ] **P2.1.8** Add keywords for tracking
  - **Effort:** Small (30 min)
  - **Exit Criteria:** 7+ keywords added
  - **Keywords:**
    - clinic novena singapore
    - gp clinic toa payoh
    - family doctor singapore
    - general practitioner novena
    - medical clinic singapore
    - dr chia ai mian
    - abundant blessings clinic

- [ ] **P2.1.9** Set up automated reports
  - **Effort:** Small (30 min)
  - **Exit Criteria:** Reports scheduled
  - **Schedule:**
    - Daily: Keyword position reports
    - Weekly: Site audit reports
    - Monthly: Backlink reports

- [ ] **P2.1.10** Configure site audit
  - **Effort:** Small (30 min)
  - **Exit Criteria:** Site audit running weekly
  - **Settings:**
    - Crawl frequency: Weekly
    - Pages to crawl: 100
    - All checks enabled

#### Exit Criteria (P2.1):
- [ ] SEO Panel accessible at seo.[domain].sg
- [ ] Website added and verified
- [ ] 7+ keywords tracking
- [ ] Automated reports scheduled
- [ ] Site audit configured

---

### P2.2: TypeScript SEO Scripts

**Effort:** Medium (2-3 hours)  
**Dependencies:** P2.1 (SEO Panel for API key)  
**Blocks:** P3.2

#### Tasks:

- [ ] **P2.2.1** Set up TypeScript environment for scripts
  - **Effort:** Small (30 min)
  - **Exit Criteria:** TypeScript compiles successfully
  - **Add to package.json:**
    ```json
    "devDependencies": {
      "@types/node": "^20.0.0",
      "ts-node": "^10.9.0",
      "typescript": "^5.3.0"
    }
    ```

- [ ] **P2.2.2** Install Firecrawl SDK
  - **Effort:** Small (15 min)
  - **Exit Criteria:** @mendable/firecrawl-js installed
  - **Command:** `npm install @mendable/firecrawl-js`

- [ ] **P2.2.3** Create generate-llms-txt.ts script
  - **Effort:** Medium (1 hour)
  - **Exit Criteria:** Script generates llms.txt
  - **Function:** Scrape website, generate llms.txt content

- [ ] **P2.2.4** Create seo-panel-sync.ts script
  - **Effort:** Medium (1 hour)
  - **Exit Criteria:** Script fetches SEO Panel data
  - **Function:** API client for SEO Panel rankings

- [ ] **P2.2.5** Add npm scripts
  - **Effort:** Small (15 min)
  - **Exit Criteria:** Scripts runnable via npm
  - **Scripts:**
    ```json
    "llms:generate": "ts-node scripts/generate-llms-txt.ts",
    "seo:sync": "ts-node scripts/seo-panel-sync.ts"
    ```

#### Exit Criteria (P2.2):
- [ ] TypeScript environment configured
- [ ] Firecrawl SDK installed
- [ ] generate-llms-txt.ts working
- [ ] seo-panel-sync.ts working
- [ ] npm scripts configured

---

### P2.3: Enhanced Workflows

**Effort:** Medium (2-3 hours)  
**Dependencies:** P0.3, P1.x workflows  
**Blocks:** None

#### Tasks:

- [ ] **P2.3.1** Create M4 GBP Optimization checklist
  - **Effort:** Small (1 hour)
  - **Exit Criteria:** Checklist document created
  - **Location:** `docs/gbp-optimization-checklist.md`
  - **Content:** Weekly GBP tasks, photo guidelines, post schedule

- [ ] **P2.3.2** Create M7 Directory Submission tracking
  - **Effort:** Small (1 hour)
  - **Exit Criteria:** Tracking file created
  - **Location:** `project/tracking/directory-submissions.yml`
  - **Content:** Singapore healthcare directories, submission status

- [ ] **P2.3.3** Create M10 Competitor Analysis template
  - **Effort:** Small (1 hour)
  - **Exit Criteria:** Template created
  - **Location:** `project/tracking/competitor-analysis.yml`
  - **Content:** Competitor profiles, keyword overlaps, strengths/weaknesses

#### Exit Criteria (P2.3):
- [ ] GBP checklist in docs/
- [ ] Directory tracking in project/tracking/
- [ ] Competitor template in project/tracking/

---

### P2 Phase Summary

| Item | Effort | Status | Exit Criteria |
|------|--------|--------|---------------|
| P2.1 SEO Panel | Large | ⬜ | Self-hosted, keywords tracking, reports |
| P2.2 TypeScript Scripts | Medium | ⬜ | Firecrawl integration, API sync |
| P2.3 Enhanced Workflows | Medium | ⬜ | M4, M7, M10 documentation |
| **P2 Total** | **10-14 hours** | | **SEO Panel + tooling active** |

---

## P3: GEO Tools & Extended Stack (Week 5-6)

**Goal:** Implement AI visibility monitoring and GEO tools  
**Duration:** Week 5-6 (6-8 hours)  
**Success Criteria:** Full AI visibility tracking active

### P3.1: Voyage GEO Agent Setup

**Effort:** Medium (2-3 hours)  
**Dependencies:** P1.5 (AI crawler setup), P2.2 (TypeScript environment)  
**Blocks:** P3.3

#### Tasks:

- [ ] **P3.1.1** Sign up for OpenRouter API
  - **Effort:** Small (15 min)
  - **Exit Criteria:** Account created, API key generated
  - **Credits:** Add $10-20 to start

- [ ] **P3.1.2** Install Voyage GEO Agent
  - **Effort:** Small (15 min)
  - **Exit Criteria:** voyage-geo installed via pip
  - **Command:** `pip install voyage-geo`

- [ ] **P3.1.3** Create queries.txt for monitoring
  - **Effort:** Small (30 min)
  - **Exit Criteria:** queries.txt with 7+ queries
  - **Queries:**
    - best GP clinic Novena Singapore
    - family doctor Singapore Novena
    - general practitioner near Novena MRT
    - medical clinic Novena area
    - doctor consultation Singapore Novena
    - Abundant Blessings Clinic reviews
    - Dr Chia Ai Mian clinic

- [ ] **P3.1.4** Create geo-analyzer.ts (TypeScript)
  - **Effort:** Medium (1-2 hours)
  - **Exit Criteria:** Custom TypeScript GEO analyzer working
  - **Features:**
    - OpenRouter API integration
    - Multi-engine queries (ChatGPT, Claude, Gemini, Perplexity)
    - HTML report generation
    - JSON export

- [ ] **P3.1.5** Create GEO monitoring workflow
  - **Effort:** Small (30 min)
  - **Exit Criteria:** `.github/workflows/geo-visibility.yml` created
  - **Schedule:** Weekly (Monday 9 AM)
  - **Artifacts:** HTML report, JSON data

- [ ] **P3.1.6** Test GEO analysis
  - **Effort:** Small (30 min)
  - **Exit Criteria:** First report generated successfully
  - **Verification:** Report shows brand mention rates across engines

#### Exit Criteria (P3.1):
- [ ] OpenRouter API key configured
- [ ] Voyage GEO or custom analyzer working
- [ ] Weekly monitoring workflow active
- [ ] First GEO report generated

---

### P3.2: Canonry Setup (AI Citation Monitoring)

**Effort:** Small (1-2 hours)  
**Dependencies:** P2.2 (Node.js environment)  
**Blocks:** P3.3

#### Tasks:

- [ ] **P3.2.1** Install Canonry globally
  - **Effort:** Small (15 min)
  - **Exit Criteria:** Canonry installed
  - **Command:** `npm install -g @ainyc/canonry`

- [ ] **P3.2.2** Initialize Canonry configuration
  - **Effort:** Small (30 min)
  - **Exit Criteria:** canonry.config.yaml created
  - **Configuration:**
    - Domains: abundantblessings.sg, www.abundantblessings.sg
    - Engines: chatgpt, claude, gemini, perplexity
    - Schedule: Weekly

- [ ] **P3.2.3** Run initial monitoring
  - **Effort:** Small (15 min)
  - **Exit Criteria:** Baseline citations recorded
  - **Command:** `canonry monitor --init`

- [ ] **P3.2.4** Set up dashboard (optional)
  - **Effort:** Small (30 min)
  - **Exit Criteria:** Dashboard accessible
  - **Command:** `canonry dashboard --port 3001`

#### Exit Criteria (P3.2):
- [ ] Canonry installed and configured
- [ ] Baseline citation data captured
- [ ] Weekly monitoring scheduled

---

### P3.3: GEO Dashboard & Reporting

**Effort:** Small (1-2 hours)  
**Dependencies:** P3.1 (Voyage GEO), P3.2 (Canonry)  
**Blocks:** None

#### Tasks:

- [ ] **P3.3.1** Create geo-dashboard/ directory
  - **Effort:** Small (15 min)
  - **Exit Criteria:** Directory created with index.html

- [ ] **P3.3.2** Build GEO dashboard HTML
  - **Effort:** Small (1 hour)
  - **Exit Criteria:** Dashboard displays metrics
  - **Sections:**
    - Brand mention rate chart
    - AI engine coverage status
    - Top queries where brand appears
    - Recent reports list

- [ ] **P3.3.3** Create dashboard deployment workflow
  - **Effort:** Small (30 min)
  - **Exit Criteria:** Auto-deployment to GitHub Pages
  - **File:** `.github/workflows/deploy-geo-dashboard.yml`

- [ ] **P3.3.4** Deploy to GitHub Pages
  - **Effort:** Small (15 min)
  - **Exit Criteria:** Dashboard live at github.io

#### Exit Criteria (P3.3):
- [ ] GEO dashboard created
- [ ] Dashboard auto-deploys to GitHub Pages
- [ ] Public URL accessible

---

### P3.4: Update llms.txt Workflow

**Effort:** Small (1 hour)  
**Dependencies:** P2.2.3 (generate-llms-txt.ts)  
**Blocks:** None

#### Tasks:

- [ ] **P3.4.1** Create update-llms-txt.yml workflow
  - **Effort:** Small (30 min)
  - **Exit Criteria:** Workflow using TypeScript script
  - **Schedule:** Monthly (1st of month)
  - **Triggers:** Schedule + manual

- [ ] **P3.4.2** Configure Firecrawl API key in secrets
  - **Effort:** Small (15 min)
  - **Exit Criteria:** FIRECRAWL_API_KEY added to GitHub Secrets

- [ ] **P3.4.3** Test workflow
  - **Effort:** Small (15 min)
  - **Exit Criteria:** llms.txt auto-updates

#### Exit Criteria (P3.4):
- [ ] Monthly llms.txt updates automated
- [ ] Firecrawl API key configured
- [ ] Test run successful

---

### P3 Phase Summary

| Item | Effort | Status | Exit Criteria |
|------|--------|--------|---------------|
| P3.1 Voyage GEO | Medium | ⬜ | Weekly AI visibility reports |
| P3.2 Canonry | Small | ⬜ | AI citation monitoring active |
| P3.3 GEO Dashboard | Small | ⬜ | GitHub Pages dashboard live |
| P3.4 llms.txt Workflow | Small | ⬜ | Monthly auto-updates |
| **P3 Total** | **5-8 hours** | | **Full GEO visibility** |

---

## Dependency Map

```
P0: Foundation (Week 1)
├── P0.1 GSC Setup ───────┬→ P0.2 Looker Studio
│                         ├→ P1.4 CookieYes
│                         └→ P2.1 SEO Panel
├── P0.2 Looker Studio ───┬→ P1.x Automation
│                         └→ P2.1 SEO Panel
└── P0.3 GitHub Infra ────┬→ P1.1 Lighthouse CI
                          ├→ P1.2 Broken Links
                          ├→ P1.3 Sitemap
                          └→ P2.3 Workflows

P1: Core Automation (Week 2)
├── P1.1 Lighthouse CI (independent)
├── P1.2 Broken Links (independent)
├── P1.3 Sitemap (independent)
├── P1.4 CookieYes (independent)
└── P1.5 AI Crawlers ─────→ P3.1 Voyage GEO

P2: SEO Panel & Tooling (Week 3-4)
├── P2.1 SEO Panel ───────┬→ P2.2 TypeScript Scripts
│                         └→ P2.3 Workflows
├── P2.2 TypeScript ──────┬→ P3.1 Voyage GEO
│                         └→ P3.2 Canonry
└── P2.3 Workflows (independent)

P3: GEO Tools (Week 5-6)
├── P3.1 Voyage GEO ──────┬→ P3.3 Dashboard
│                         └→ P3.4 llms.txt
├── P3.2 Canonry ─────────→ P3.3 Dashboard
├── P3.3 Dashboard (needs P3.1, P3.2)
└── P3.4 llms.txt ────────→ (uses P2.2.3)
```

---

## Risk Assessment & Mitigation

| Risk | Likelihood | Impact | Priority | Mitigation |
|------|------------|--------|----------|------------|
| **No .github directory** | High | High | P0 | Must create all infrastructure from scratch |
| **SEO Panel hosting complexity** | Medium | Medium | P2 | Use managed hosting (Hostinger/Namecheap) |
| **OpenRouter API costs** | Low | Low | P3 | Start with $10-20 credit, monitor usage |
| **GSC verification delays** | Medium | Medium | P0 | Use HTML file method (faster than DNS) |
| **GitHub learning curve** | Medium | Medium | P0 | Document workflows, provide video walkthrough |
| **TypeScript setup issues** | Low | Medium | P2 | Project already TypeScript-ready |
| **Firecrawl API limits** | Low | Low | P3 | Monthly updates keep usage low |

---

## Cost Breakdown

### One-Time Costs
| Item | Cost | Notes |
|------|------|-------|
| Initial setup time | $0 | 28-36 hours (your time) |
| Domain (if needed) | $10-15/year | For SEO Panel subdomain |
| **Total One-Time** | **$10-15** | |

### Monthly Costs
| Item | Cost | Phase | Notes |
|------|------|-------|-------|
| Shared hosting (SEO Panel) | $2-5 | P2 | Hostinger/Namecheap |
| OpenRouter API | $5-15 | P3 | Voyage GEO queries |
| Firecrawl API | $5-10 | P3 | llms.txt generation |
| CookieYes | $0 | P1 | Free tier (<5K pageviews) |
| GitHub | $0 | All | Public repos free |
| **Monthly Total** | **$12-30** | | Full Stack A + GEO |

---

## Success Metrics

### Completion Metrics

| Phase | Target | Metric |
|-------|--------|--------|
| P0 | 100% | Foundation infrastructure operational |
| P1 | 100% | Core automation running |
| P2 | 100% | SEO Panel + tooling active |
| P3 | 100% | GEO visibility tracking |

### Efficiency Metrics

| Metric | Before | After (Full Implementation) |
|--------|--------|----------------------------|
| Tools used | 35+ | 12 |
| Monthly cost | $200-500 | $12-30 |
| Context switches/task | 3-5 | 1 |
| Manual validation | 100% | 5% (automated 95%) |
| Reporting time | 3-4 hours/week | 5 min/week (automated) |
| M-task coverage | 0% | 95%+ |
| AI visibility | 0% | Full GEO coverage |

---

## Maintenance Plan

### Daily (Automated)
- Lighthouse CI runs on PRs
- GSC alerts monitored

### Weekly (15 minutes)
- [ ] Review Looker Studio executive summary (auto-emailed)
- [ ] Check GitHub Project board for blocked items
- [ ] Review Lighthouse CI results from Monday run
- [ ] Check for new GSC alerts

### Monthly (1 hour)
- [ ] Full Looker Studio dashboard review
- [ ] SEO Panel keyword ranking report
- [ ] Site audit review and action items
- [ ] Review GEO visibility report
- [ ] Update llms.txt if needed
- [ ] Review and archive completed GitHub issues

### Quarterly (2 hours)
- [ ] Comprehensive SEO audit using all tools
- [ ] Competitor analysis
- [ ] Strategy review and adjustment
- [ ] Tool stack efficiency review

---

## Appendix A: File Structure After Implementation

```
Ai-Mian's-Clinic/
├── .github/
│   ├── workflows/
│   │   ├── seo-lighthouse.yml          # P1.1: Lighthouse CI
│   │   ├── seo-broken-links.yml        # P1.2: Broken link checker
│   │   ├── seo-sitemap.yml             # P1.3: Sitemap generator
│   │   ├── seo-panel-sync.yml          # P2.1: SEO Panel data sync
│   │   ├── geo-visibility.yml          # P3.1: Voyage GEO monitoring
│   │   ├── update-llms-txt.yml         # P3.4: llms.txt auto-update
│   │   └── deploy-geo-dashboard.yml    # P3.3: Dashboard deployment
│   ├── ISSUE_TEMPLATE/
│   │   ├── technical-seo-audit.yml     # P0.3: Technical SEO template
│   │   ├── local-seo-task.yml          # P0.3: Local SEO template
│   │   └── geo-visibility-alert.yml    # P0.3: GEO alert template
│   └── scripts/
│       ├── generate-sitemap.ts         # P1.3: Sitemap generation
│       ├── generate-llms-txt.ts        # P2.2: llms.txt generation
│       ├── geo-analyzer.ts             # P3.1: GEO analysis
│       └── seo-panel-sync.ts           # P2.2: SEO Panel API sync
├── server/
│   └── config/
│       ├── sitemap.xml                 # P1.3: Server-side sitemap (source of truth)
│       ├── robots-production.txt       # Environment-specific robots
│       └── robots-staging.txt          # Environment-specific robots
├── geo-dashboard/                      # P3.3: GEO metrics dashboard
│   ├── index.html
│   ├── charts.js
│   └── styles.css
├── project/
│   └── tracking/
│       ├── directory-submissions.yml   # P2.3: M7 tracking
│       ├── competitor-analysis.yml     # P2.3: M10 tracking
│       └── keyword-strategy.yml        # P2.3: M11 tracking
├── docs/
│   └── gbp-optimization-checklist.md   # P2.3: M4 workflow
├── lighthouse-budget.json              # P1.1: Performance budgets
├── lighthouserc.json                   # P1.1: Lighthouse CI config
├── package.json                        # Updated with SEO scripts
└── tsconfig.json                       # TypeScript config for scripts
```

---

## Appendix B: Quick Commands Reference

### Prerequisites
```bash
# Install TypeScript tooling
npm install -D typescript ts-node @types/node

# Install SEO tool dependencies
npm install @mendable/firecrawl-js dotenv
```

### Core Stack Commands
```bash
# Lighthouse CI (local test)
npm install -g @lhci/cli
lhci autorun

# Generate llms.txt
npm run llms:generate

# Run GEO analysis
npm run geo:analyze

# Sync SEO Panel data
npm run seo:sync

# Type check all scripts
npx tsc --noEmit
```

### SEO Panel Commands
```bash
# Backup database
mysqldump -u seopanel_user -p seopanel > seopanel-backup-$(date +%Y%m%d).sql

# Check broken links locally
npx broken-link-checker https://abundantblessings.sg \
  --exclude "linkedin.com|facebook.com" \
  --timeout 20000
```

---

## Acceptance Criteria (Overall Plan)

- [ ] Plan is ordered by priority (P0 → P3) with explicit rationale
- [ ] Each phase has clear entry/exit criteria
- [ ] Dependencies are explicit (e.g., P0.1 → P0.2)
- [ ] Scope is intentionally bounded
- [ ] P0/P1 items are concrete, directly supported by evidence, and sized to ship
- [ ] Larger redesigns are explicitly deferred to P3
- [ ] No unresolved ambiguity remains about scope or execution order
- [ ] Effort labels (Small/Medium/Large) included for all tasks
- [ ] Risk assessment documented with mitigations
- [ ] Cost breakdown provided

---

## Appendix D: Critical Findings from Codebase Analysis

### ✅ DECISION: Server-Side Sitemap Generation (Option C - Hybrid Dynamic)

**Architecture Context:**
This project is a **Single Page Application (SPA) with static HTML output**:
- React app built with Vite → outputs to `website/dist/`
- Single `index.html` entry point
- No React Router (all content on one page with section anchors)
- Express server serves static files with dynamic sitemap endpoint

**Source of Truth Decision:**
| Factor | Analysis | Decision |
|--------|----------|----------|
| **Site type** | Single-page landing (no routing) | Server-side generation |
| **Update frequency** | Low (clinic info changes rarely) | Weekly auto-generation sufficient |
| **Current infrastructure** | Server already serves dynamic sitemap | Leverage existing endpoint |
| **SEO needs** | Section anchors (#services, #contact) | Server can include anchor links |
| **Automation** | GitHub Actions workflow (P1.3) | Generate → server/config/ → commit |

**Implementation:**
```
GitHub Action (P1.3 workflow)
    ↓
Generate sitemap from website/src/App.tsx sections
    ↓
Write to server/config/sitemap.xml
    ↓
Auto-commit to repository
    ↓
Express serves at /sitemap.xml (production only)
```

**Why NOT Other Options:**

| Option | Why Not Suitable |
|--------|------------------|
| **A: Static file in website/public/** | Would require build step to regenerate; doesn't leverage existing server infrastructure |
| **B: Build-time generation** | Adds complexity to Vite build; single-page site doesn't benefit from build-time route discovery |
| **C: Server dynamic (on-request)** | Viable alternative, but file-based is simpler for this use case; can upgrade later |

**Duplicate Files Resolution:**

| File | Current Location | Decision |
|------|-----------------|----------|
| `sitemap.xml` | `website/public/` | **Remove** (not used by server) |
| `sitemap.xml` | `server/config/` | **Keep** - source of truth for P1.3 |
| `robots.txt` | `website/public/` | **Keep** - used for static hosting fallback |
| `robots-production.txt` | `server/config/` | **Keep** - dynamic env-specific serving |
| `robots-staging.txt` | `server/config/` | **Keep** - dynamic env-specific serving |

**P1.3 Workflow Configuration:**
- **Source:** Parse `website/src/App.tsx` for section components
- **Output:** `server/config/sitemap.xml`
- **Commit:** Auto-commit changes to repository
- **Endpoint:** Server serves at `/sitemap.xml` (404 in staging by design)

### Build-Time SEO Injection

**Finding:** Meta tags and JSON-LD schema are injected at build time via:
- `website/vite-plugins/inject-clinic-data.ts`
- `website/index.html` contains base SEO markup with placeholders

**Implication:** Any SEO workflow that checks on-page meta tags must run **after** build, not against source files.

### Verified Build Status

**Finding:** Background agents verified `npm run build` completes successfully.
- ✅ Website builds without errors
- ✅ Server builds without errors
- ✅ TypeScript compilation passes
- ✅ Ready for CI/CD integration

---

**Next Steps:**
1. Review this plan for approval
2. Begin P0.1 (GSC Setup) once approved
3. Execute phases sequentially, marking tasks complete as you go
4. Update this plan with `- [✅]` for completed items

**Document Version:** 1.1  
**Created:** 2026-03-18 15:45  
**Updated:** 2026-03-18 16:15  
**Status:** 🟡 Draft - Ready for Review  
**Review Date:** 2026-03-18
