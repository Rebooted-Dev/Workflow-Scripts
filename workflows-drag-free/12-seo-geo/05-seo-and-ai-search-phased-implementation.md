---
id: seo-and-ai-search-phased-implementation
version: 2.0
category: seo-geo
kind: workflow
triggers:
  - "prepare a site for SEO and AI search"
  - "make a website SEO ready"
  - "submit a site to search engines"
  - "set up Google Search Console and Bing Webmaster Tools"
inputs: [site-url, site-config]
outputs: [seo-readiness-record, search-submission-record]
requires: []
agents: [docs-writer]
prev: []
next: []
---

## Phased Implementation Plan: SEO, AI Search Readiness & Submission

This plan is still **phased (0–9)**, but it’s rewritten as a **single checklist** split by automation level:

- **Human-only**: can’t realistically be automated (decisions, accounts, approvals).
- **Partial automation**: requires a human bootstrap step, then scripts can maintain it.
- **Fully automated**: should happen every build/deploy with no human action.

Use the **Minimal launch-ready checklist** first, then work through the three grouped checklists.

Use the focused companion modules when delegating or repeating work:

- [Fully automated tasks](./01-fully-automated-tasks.md)
- [Semi-automated tasks](./02-semi-automated-tasks.md)
- [Manual human tasks](./03-manual-human-tasks.md)
- [Routine monitoring tasks](./04-routine-monitoring-tasks.md)

---

## Minimal launch-ready checklist (definition of “done”)

- [ ] **(Phase 1)** Staging/non-prod pages cannot be indexed (`noindex,nofollow` guard).
- [ ] **(Phase 2)** `/robots.txt` returns 200 and includes a correct `Sitemap:` line.
- [ ] **(Phase 2)** `/sitemap.xml` returns 200, is valid XML, and contains only canonical-host URLs.
- [ ] **(Phase 3)** Key pages have `<title>`, meta description, canonical, OG/Twitter tags.
- [ ] **(Phase 4)** Site has at least Organization/LocalBusiness schema (plus FAQ where applicable).
- [ ] **(Phase 6)** Site has a single canonical **NAP + key facts** source-of-truth (no drift).
- [ ] **(Phase 6b)** Google Search Console: verified + sitemap submitted + homepage indexing requested.
- [ ] **(Phase 6b)** Bing Webmaster Tools: verified + sitemap submitted.
- [ ] **(Phase 7)** AI crawler posture decided; if using GEO, `llms.txt` exists and is intentional.
- [ ] **(Phase 9)** Monitoring cadence is scheduled (weekly/monthly/quarterly) including AI spot-checks.

---

## Inputs & “single source of truth” (recommended)

- [ ] Create `site-config` (TS/JS/JSON) containing:
  - [ ] Canonical site facts (name, canonical URL, description, contact details, address, hours).
  - [ ] Service list + FAQs (at least for key money pages).
  - [ ] Canonical NAP (Name, Address, Phone) if local business.
  - [ ] Policy flags:
    - [ ] `aiCrawlerPolicy` (deny all vs balanced vs allow all)
    - [ ] `analyticsPolicy` (none vs GA4 vs privacy-first)
    - [ ] `isLocalBusiness` (affects schema + directory tasks)

---

## Master checklist by automation level

### Human-only tasks (must be done by a person)

#### Phase 0 – Project setup & assumptions

- [ ] Decide which search engines/regions are in scope (Google-only vs also Bing/Brave/Yahoo; regional engines like Baidu/Yandex/Naver).
- [ ] Decide AI crawler posture up front (deny all vs balanced vs allow all).
- [ ] Decide if this is a local service business (if yes, Phase 6c becomes mandatory).

#### Phase 1 – Indexing safety & hostname guardrails

- [ ] Decide which hostnames count as production vs staging/playground.
- [ ] Fix DNS/TLS/canonical-host issues discovered by checks (registrar + hosting panels).

#### Phase 2 – Crawlability & static SEO assets

- [ ] Decide which paths must be disallowed (e.g. `/admin/`, `/internal/`, private APIs).

#### Phase 3 – Core head metadata & social cards

- [ ] Write good titles and meta descriptions (human-authored quality matters).
- [ ] Approve OG image design and branding decisions.

#### Phase 4 – Structured data (JSON-LD)

- [ ] Decide which schema types are appropriate for the business/vertical.
- [ ] Validate in schema tools and decide what “good enough” means for this site.

#### Phase 5 – Content structure & freshness (SEO + AI)

- [ ] Draft/refine hero copy, page intros, service content, FAQs.
- [ ] Decide what “Last updated” means (any edit vs only material changes).

#### Phase 6 – Local SEO & entity authority (if local business)

- [ ] Create/claim Google Business Profile and complete verification.
- [ ] Request/respond to real customer reviews (ongoing).

#### Phase 6b – Search submission (webmaster tools)

- [ ] Create/own Google account for site owner (or confirm the owner account).
- [ ] Google Search Console (GSC):
  - [ ] Go to `https://search.google.com/search-console` and add a property.
    - [ ] Prefer a **Domain property** (covers all subdomains + protocols) if you can add DNS TXT records.
    - [ ] Otherwise use a **URL-prefix property** (verify via HTML file, meta tag, or Google Analytics).
  - [ ] Complete verification (DNS TXT / HTML file / meta tag).
  - [ ] Submit sitemap:
    - [ ] Property → `Indexing > Sitemaps` → enter `https://example.com/sitemap.xml` → Submit.
  - [ ] Request indexing for:
    - [ ] Homepage (`https://example.com/`) via `URL inspection` → **Request Indexing**
    - [ ] A few key service/landing pages (optional but recommended).
- [ ] Create/own Microsoft account (or confirm the owner account).
- [ ] Bing Webmaster Tools:
  - [ ] Go to `https://www.bing.com/webmasters/` and add your site.
  - [ ] Verify ownership:
    - [ ] Prefer “Import from GSC” if available (often fastest).
    - [ ] Otherwise verify via DNS TXT / HTML file / meta tag.
  - [ ] Submit sitemap URL (`https://example.com/sitemap.xml`).
  - [ ] Optionally use URL submission for homepage + a handful of key URLs.
- [ ] IndexNow decision:
  - [ ] Decide if IndexNow is in scope (best when you publish/update frequently).
- [ ] Alternative/regional engines decision:
  - [ ] Confirm whether regional engines are in scope (Baidu/Yandex/Naver/etc.).
  - [ ] If in scope: create a separate regional plan (often needs local expertise/constraints).
  - [ ] If out of scope: explicitly document “out of scope” so it doesn’t linger as a vague TODO.

#### Phase 6c – Local directory submissions (entity trust)

- [ ] Decide canonical NAP, canonical URL formatting (`www` vs non-`www`, trailing slash), official descriptions, categories, photo set.
- [ ] Create a NAP reference doc (copy/paste source for all submissions).
- [ ] Submit/claim high-priority directories (market/vertical specific) and complete verification flows.
- [ ] Create a quarterly reminder to re-check NAP consistency.

#### Phase 7 – AI crawler policy & `llms.txt`

- [ ] Approve what personal/professional details can appear in `llms.txt`.
- [ ] Review `llms.txt` for accuracy, sensitivity, and tone before publishing.
- [ ] Choose AI crawler posture (deny all vs balanced vs allow all) and ensure `robots.txt` and `llms.txt` agree.
  - [ ] Recommended default for most businesses: **balanced visibility**
    - [ ] Allow “citation/search” bots
    - [ ] Block “training dataset” crawlers
  - [ ] Allow list examples (may evolve):
    - [ ] ChatGPT-User, OAI-SearchBot (OpenAI)
    - [ ] ClaudeBot, Claude-SearchBot (Anthropic)
    - [ ] PerplexityBot (Perplexity)
    - [ ] Applebot-Extended (Apple)
  - [ ] Block list examples:
    - [ ] GPTBot (OpenAI training)
    - [ ] CCBot (Common Crawl)
    - [ ] Google-Extended (Google training)
    - [ ] anthropic-ai (Anthropic training)
    - [ ] Bytespider (ByteDance)
    - [ ] Diffbot (Diffbot)

#### Phase 8 – Analytics, privacy, compliance

- [ ] Decide whether to use analytics at all, and which tools are acceptable.
- [ ] Draft/approve privacy policy + consent wording (PDPA/GDPR implications).
- [ ] Make final decisions on data sharing/retention.

#### Phase 9 – Monitoring, reporting, AI visibility (ongoing)

- [ ] Interpret GSC/Bing/analytics data and set priorities.
- [ ] Manually test AI tools (ChatGPT/Claude/Perplexity/etc.) and judge citation/fact accuracy.
- [ ] Decide content/schema/`llms.txt` changes when issues are found.

---

### Partial-automation tasks (human bootstrap, then automated maintenance)

#### Phase 6b – Submission maintenance

- [ ] After GSC setup, automatically resubmit `sitemap.xml` from CI/deploy when sitemap changes (API or tooling).
- [ ] After Bing setup, automatically resubmit `sitemap.xml` from CI/deploy when sitemap changes (API or tooling).
- [ ] Add a deploy hook that fetches live `sitemap.xml` and logs/alerts if it fails.

#### Phase 6b – IndexNow (optional)

- [ ] Generate and host the IndexNow key file (human decision + one-time setup).
- [ ] Automatically ping IndexNow for new/updated/deleted URLs from deploy pipeline or CMS webhooks.

#### Phase 9 – Ongoing monitoring automation

- [ ] Scheduled Lighthouse audits for key URLs (store results for trends).
- [ ] (Optional) Pull GSC/Bing/analytics metrics via APIs and generate a monthly summary report.
- [ ] Calendar reminders or a lightweight scheduled script to prompt weekly/biweekly reviews.

---

### Fully automated tasks (should run every build/deploy)

#### Phase 1 – Indexing safety & hostname guardrails (automation)

- [ ] Implement a reusable non-prod `noindex,nofollow` guard driven by `site-config` allowed hosts.
- [ ] Add a check that confirms HTTP → HTTPS redirects and a single canonical hostname.

#### Phase 2 – Crawlability & static SEO assets (automation)

- [ ] Build step generates `/robots.txt` from `site-config` (including AI crawler rules driven by `aiCrawlerPolicy`).
- [ ] Build step generates `/sitemap.xml` (canonical URLs + `<lastmod>` timestamp).
- [ ] Build step generates `/llms.txt` when enabled (from the same source-of-truth).

#### Phase 3 – Head metadata & social tags (automation)

- [ ] Shared SEO/layout component renders canonical, OG/Twitter tags consistently.
- [ ] Default title/description come from `site-config` with per-page overrides.
- [ ] Lint/check: every indexable route has a title + description configured.

#### Phase 4 – Structured data (automation)

- [ ] Schema builder functions exist (Organization/LocalBusiness/FAQPage as applicable).
- [ ] JSON-LD is embedded site-wide via the shared layout/component.
- [ ] `site-config` is typed so invalid schema inputs fail fast in CI.

#### Phase 5 – Content linting (automation)

- [ ] Lint/check: one H1 per page.
- [ ] Lint/check: required sections/components exist (e.g. FAQ on templates where required).
- [ ] “Last updated” is consistently generated (build time or git date, per policy).

#### Phase 6 – NAP consistency (automation)

- [ ] UI uses canonical NAP from `site-config` everywhere (footer/contact blocks).
- [ ] Schema uses canonical NAP from `site-config` (Organization/LocalBusiness).

#### Guardrail CI checks (regression prevention)

- [ ] Fetch `/robots.txt` and verify: status 200, correct `Sitemap:` line, expected allow/deny blocks.
- [ ] Fetch `/sitemap.xml` and verify: status 200, valid XML, canonical-host URLs only.
- [ ] Fetch `/llms.txt` (if enabled) and verify: status 200, non-empty.

---

## Monitoring log template (recommended)

Maintain a single log file (example: `project/seo-monitoring-log.md`) and append entries like:

```markdown
## YYYY-MM-DD - Post-deploy check
- Deploy: <commit/tag>
- robots.txt: OK
- sitemap.xml: OK
- llms.txt: OK (or N/A)
- Lighthouse: P:__ A:__ BP:__ SEO:__
- Schema validation: OK (or list errors)
- Notes: <what changed / what you’ll follow up on>

## YYYY-MM-DD - Weekly GSC review
- Clicks: __ (Δ __)
- Impressions: __ (Δ __)
- Top queries: <...>
- Issues spotted: <...>
- Actions taken: <...>
```

---

## Submission responsibilities (quick reference)

- **Google Search Console**: verify property, submit sitemap, request indexing for key URLs.
- **Bing Webmaster Tools**: verify site, submit sitemap, optionally submit key URLs.
- **IndexNow (optional)**: configure key and automatic URL pings.
- **Alternative engines**: usually covered by clean `robots.txt`, `sitemap.xml`, and some inbound links.
- **Local directories (local businesses)**: submit/claim major listings using canonical NAP; review quarterly.
- **AI platforms**: typically no direct submission; most rely on Google/Bing/Brave indices + your `robots.txt` and (optionally) `llms.txt`.
