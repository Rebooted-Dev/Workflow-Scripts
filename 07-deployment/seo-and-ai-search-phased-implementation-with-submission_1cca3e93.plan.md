---
name: seo-and-ai-search-phased-implementation-with-submission
overview: Extended phased implementation plan for making a new website SEO-ready and AI-search/chatbot-friendly, including explicit steps for submitting the site to search engines, discovery services, and AI platforms.
todos:
  - id: phase6b-gsc
    content: Set up Google Search Console, verify the site, submit sitemap.xml, and request indexing for key URLs.
    status: pending
  - id: phase6b-bing
    content: Set up Bing Webmaster Tools (importing from GSC if possible), verify the site, and submit sitemap.xml and key URLs.
    status: pending
  - id: phase6b-indexnow
    content: Optionally configure IndexNow (key file + deployment or server hook) to push new/updated URLs to participating engines.
    status: pending
  - id: phase6b-alt-engines
    content: Confirm whether alternative or regional search engines are in scope and either plan their setup or explicitly mark them out of scope.
    status: pending
  - id: phase9-ai-visibility
    content: Add AI-oriented checks to the ongoing monitoring routine, spot-testing ChatGPT/Claude/Perplexity for branded and key non-branded queries once the site is indexed.
    status: pending
isProject: false
---

## Phased Implementation Plan: SEO, AI Search Readiness & Submission

This is an extended version of the phased plan that adds explicit steps for submitting your site to search engines, discovery services, and (where possible) AI search/chatbot ecosystems.

Most phases (0–9) remain the same; the main additions are in a new **Phase 6b – Search & AI Submission** and small tweaks to monitoring.

---

## Automation Architecture vs Manual Work

This plan assumes a small, reusable automation layer that you can copy across projects, plus a clear separation between what scripts can do and what always needs a human.

- **Automation layer (reusable across sites)**
  - A single `site-config` file (TS/JS/JSON) that stores:
    - Site/organization facts (name, URL, description, contact, address, services, FAQs).
    - Policy flags (`aiPolicy`, `hasAnalytics`, `isLocalBusiness`, etc.).
  - A small CLI script (for example `seo/generate-seo-assets.ts`) that:
    - Reads `site-config`.
    - Generates `robots.txt`, `sitemap.xml`, and `llms.txt` into the public/static folder.
    - Outputs JSON-LD schema snippets (Organization, LocalBusiness, FAQPage, etc.) for the app to embed.
  - A shared SEO/layout component that:
    - Uses `site-config` + generated schema to render `<title>`, `<meta>` tags, OG/Twitter tags, canonical links, and `<script type="application/ld+json">` blocks.
    - Applies a runtime `noindex` guard for non-production hostnames.
  - CI/build wiring:
    - `npm run generate:seo` (or similar) hooked into the build pipeline so SEO assets are always regenerated from config.
- **Fully manual tasks (cannot realistically be automated)**
  - Business and policy decisions:
    - Decide analytics policy (GA4 vs none vs privacy-first alternatives).
    - Decide AI crawler policy (block all / allow search-only / allow all).
    - Decide which regions/engines are actually in scope (e.g. whether to care about Baidu/Yandex).
  - Content authoring and editing:
    - Writing and refining hero copy, meta descriptions, FAQs, and detailed service descriptions.
    - Approving what appears in `llms.txt` (especially personal/professional details).
  - Accounts and consoles:
    - Creating and owning accounts for Google Search Console, Bing Webmaster Tools, and other webmaster portals.
    - Initial property creation and verification (DNS TXT, HTML file, or meta tag).
    - Creating/claiming Google Business Profile and other directory profiles, and handling their verification flows.
  - Legal and compliance:
    - Drafting and approving privacy policy text and consent-banner wording.
    - Deciding on PDPA/GDPR implications and acceptable tracking behavior.
  - Strategy and interpretation:
    - Interpreting GSC/Bing/analytics data and setting SEO/AI goals.
    - Manually spot-checking AI answers (ChatGPT, Claude, Perplexity, etc.) and deciding how to respond if they misrepresent the site.

## Phase 0 – Project Setup & Assumptions

*(Same as before — environments, business posture, and a central data source.)*

Key addition:

- Note which search engines and regions matter (Google-only vs also Bing/Brave/Yahoo, etc.), and whether Chinese/Russian engines (Baidu, Yandex) are in scope.

---

## Phase 1 – Indexing Safety & Hostname Guardrails (P0)

*(Same as before — protect staging, verify domain/TLS.)*

**Automation potential**

- Implement a generic `useNoindexGuard` (or equivalent) once and reuse it across projects:
  - Reads `window.location.hostname`.
  - Compares against the allowed production host(s) from `site-config`.
  - Injects `<meta name="robots" content="noindex, nofollow">` for all non-production hosts.
- Add a small script or CI check that:
  - `curl`s the production domain over HTTP and HTTPS.
  - Confirms HTTP → HTTPS redirection and a single canonical hostname.

**Fully manual for this phase**

- Deciding which hostnames count as “production” vs “staging/playground”.
- Fixing DNS/TLS issues flagged by the checks (domain registrar and hosting control panels).

---

## Phase 2 – Crawlability & Static SEO Assets (P0)

*(Same as before — `robots.txt`, `sitemap.xml`, build/deploy verification.)*

**Automation potential**

- Use the SEO CLI script to:
  - Generate `robots.txt` from `site-config`, including AI crawler rules driven by an `aiPolicy` flag.
  - Generate `sitemap.xml` from a list of canonical URLs (or routes) plus a build timestamp for `<lastmod>`.
- Wire the script into the build:
  - For example: `"build": "npm run generate:seo && vite build"`.

**Fully manual for this phase**

- Deciding which paths are sensitive and must be disallowed (e.g. `/admin/`, `/internal/`, custom APIs).

These are prerequisites for submission in later phases.

---

## Phase 3 – Core Head Metadata & Social Cards (P1)

*(Same as before — titles, descriptions, canonical links, OG/Twitter, icons.)*

**Automation potential**

- Centralize default `<title>` and `<meta name="description">` in `site-config`.
- Use a shared SEO/layout component to:
  - Build page titles from a base site title + per-page suffix.
  - Render canonical links, OG/Twitter tags, and default images consistently.
- Add a simple lint/check to ensure:
  - Every route that should be indexable has a title and description defined in config.

**Fully manual for this phase**

- Writing good titles and descriptions the first time.
- Approving final OG image designs (even if a placeholder is wired by default).

---

## Phase 4 – Structured Data (JSON-LD) (P1)

*(Same as before — Organization/WebSite/LocalBusiness/etc. schemas.)*

**Automation potential**

- Define schema builder functions in the CLI or a shared module:
  - `buildOrganizationSchema(siteConfig)`, `buildLocalBusinessSchema(siteConfig)`, `buildFaqSchema(siteConfig)`.
- Generate JSON files during the SEO build step and import them into your layout component as JSON-LD.
- Use TypeScript types for `site-config` so invalid fields are caught at compile time.

**Fully manual for this phase**

- Choosing which schema types make sense for a brand-new vertical.
- Occasionally validating in Google’s Rich Results Test and deciding how much schema detail is “enough” for the project.

---

## Phase 5 – Content Structure & Freshness for SEO + AI (P1–P2)

*(Same as before — answer-first intros, headings, FAQs, freshness labels.)*

**Automation potential**

- Add basic content “linting”:
  - One H1 per page.
  - Required sections (e.g. FAQ component present on certain templates).
  - Presence of a “Last updated” element on key pages.
- Optionally derive “Last updated” from:
  - Build timestamp, or
  - Git commit date for the file/route.

**Fully manual for this phase**

- Drafting and refining hero copy, FAQs, and long-form content.
- Deciding whether “Last updated” should reflect any change vs only material changes.

---

## Phase 6 – Local SEO & Entity Authority (If Applicable) (P1–P2)

*(Same as before — NAP, Google Business Profile, citations.)*

These also help search and AI engines trust your site when they encounter it.

**Automation potential**

- Store canonical NAP (Name, Address, Phone) in `site-config` and:
  - Use it everywhere in the UI (contact sections, footer).
  - Use it in schema builders (Organization/LocalBusiness).

**Fully manual for this phase**

- Creating/claiming Google Business Profile and other directory listings.
- Handling their verification flows (postcards, phone calls, or emails).
- Requesting and responding to real customer reviews.

---

## Phase 6b – Search Engine & AI-Oriented Submission (P1–P2)

**Goal:** Proactively tell major search engines (and, indirectly, AI systems that rely on them) about your site and sitemap once the technical basics are in place.

**Automation potential**

- After initial manual setup and verification in GSC/Bing:
  - Use their APIs (or ecosystem tools) to resubmit `sitemap.xml` automatically from CI/deploy when the sitemap changes.
  - Add a small deploy hook that `curl`s the live `sitemap.xml` and logs errors if it fails.
- For IndexNow:
  - Automate pings to the IndexNow endpoint for new/updated URLs from your build/deploy pipeline or CMS webhooks.

**Fully manual for this phase**

- Creating and owning Google and Microsoft accounts for webmaster tools.
- Adding properties in GSC and Bing Webmaster Tools for each new domain.
- Performing the actual verification step (DNS TXT, HTML file upload, or meta tag).
- Deciding whether IndexNow and alternative/regional engines (Baidu, Yandex, etc.) are in scope at all.

### 6b.1 Google Search Console (GSC)

- **Tasks**
  - Create a Google account for the site owner (or use an existing one).
  - Go to `https://search.google.com/search-console` and **Add Property**.
    - Prefer a **Domain property** (covers all subdomains and protocols) if you can add DNS TXT records.
    - Alternatively, use a URL-prefix property and verify via HTML file, meta tag, or Google Analytics.
  - Complete **verification** using one of:
    - DNS TXT record at your domain registrar.
    - Uploading an HTML verification file to your web root.
    - Adding a `<meta name="google-site-verification">` tag.
  - In GSC, **submit your sitemap**:
    - Open the property → `Indexing > Sitemaps` → enter `https://example.com/sitemap.xml` → Submit.
  - For the homepage and any especially important URLs:
    - Open `URL inspection` in GSC.
    - Paste `https://example.com/` and click **Request Indexing**.
- **Exit Criteria**
  - Site is verified in GSC.
  - Sitemap is submitted with no errors.
  - At least the homepage has an indexing request submitted.

### 6b.2 Microsoft Bing / Yahoo / DuckDuckGo (via Bing Webmaster Tools)

*(Bing powers Bing, Yahoo, DuckDuckGo, and some other search experiences.)*

- **Tasks**
  - Create or sign in to a Microsoft account.
  - Go to `https://www.bing.com/webmasters/`.
  - Add your site and verify ownership.
    - Easiest: import settings from GSC if available.
    - Or use HTML file/meta tag/DNS TXT verification similar to GSC.
  - Submit your sitemap URL (`https://example.com/sitemap.xml`).
  - Optionally, use **URL submission** to submit your homepage and a handful of key URLs.
- **Exit Criteria**
  - Site is verified in Bing Webmaster Tools.
  - Sitemap is submitted successfully.

### 6b.3 IndexNow (Optional but Helpful for Fast Discovery)

IndexNow is a protocol (supported by Bing, Yandex, some others) to push URL changes directly to participating engines.

- **Tasks**
  - Decide if IndexNow is in scope (most useful for frequently updated content).
  - If yes:
    - Generate an IndexNow key and host the key file at your site root as per documentation.
    - Integrate an IndexNow client (server-side or via a build/deploy hook) to ping the API whenever you:
      - Publish new content.
      - Update or delete important URLs.
- **Exit Criteria**
  - IndexNow key is valid and discoverable.
  - New/updated URLs are pinged as part of your deployment/content workflow.

### 6b.4 Brave, Ecosia, and Other Alternative Engines

Most alternative engines either roll their own crawlers and also ingest sitemaps and signals from GSC/Bing, or rely largely on existing indices.

- **Tasks**
  - Optional: review whether your audience is likely to use Brave, Ecosia, or others.
  - For Brave in particular:
    - Brave Search crawls the open web and reads `robots.txt` and sitemaps.
    - There’s no separate manual submission form required if your site is linked from the broader web and has a sitemap.
  - Ensure your `robots.txt` and `sitemap.xml` are clean and your site is linked from at least a few other pages on the public web.
- **Exit Criteria**
  - You’ve confirmed that no extra engine-specific steps are needed beyond Google/Bing + good sitemaps and links.

### 6b.5 Country- or Region-Specific Engines (Optional)

Only if your audience is in those markets:

- **Baidu (China), Yandex (Russia), Naver (Korea), etc.**
  - Each has its own webmaster tools and verification processes.
  - Requires regional expertise and, often, local hosting/legal requirements.
- **Exit Criteria**
  - Either: documented as out of scope, or a separate plan exists for the relevant engines.

---

## Phase 7 – AI Crawler Policy & `llms.txt` (P2–P3)

*(Same conceptual content as before, but now explicitly tied to Phase 6b.)*

- Ensure **Phases 2–6b** are complete first so AI systems have search-indexed content and sitemaps to rely on.
- Then:
  - Decide AI crawler posture (Options A/B/C).
  - Update `robots.txt` to allow/deny specific AI user-agents accordingly.
  - Add `llms.txt` with curated, factual content and important URLs.
  - Recognize that most AI platforms rely on existing search indices (Google/Bing/Brave), so strong execution of **Phase 6b** is crucial.

**Automation potential**

- Drive AI crawler rules entirely from an `aiPolicy` flag in `site-config`:
  - The SEO CLI script uses this flag to generate consistent allow/deny blocks for all known AI user-agents.
- Generate `llms.txt` from the same `site-config` and core content structures (contact, services, FAQs, key links) so it stays in sync with the site.

**Fully manual for this phase**

- Choosing the AI crawler policy itself (risk/benefit trade-off per project).
- Approving which personal/professional details are allowed to appear in `llms.txt`.
- Reviewing the first versions of `llms.txt` content for tone, sensitivity, and accuracy.

---

## Phase 8 – Analytics, Privacy, and Compliance (Parallel)

*(Same as before — analytics decision, consent, CSP.)*

When submitting to GSC/Bing (Phase 6b), double-check that your privacy policy accurately describes any analytics and tracking you’ve implemented.

**Automation potential**

- Once a consent component exists:
  - Reuse it across projects, driven by config (e.g. which tools are in use).
  - Load analytics scripts dynamically only when consent is granted.
- Centralize CSP snippets in configuration so adding GA4 or similar becomes:
  - Updating a small CSP config object.
  - Regenerating meta headers or server config fragments from that object.

**Fully manual for this phase**

- Deciding whether to use analytics at all, and which tools are acceptable.
- Drafting and approving privacy policy and consent-banner copy (especially for PDPA/GDPR).
- Making final decisions about acceptable data-sharing and retention practices.

---

## Phase 9 – Monitoring, Reporting, and AI Visibility (Ongoing)

**Goal:** Monitor not just SEO but also how well submission and AI discoverability efforts are working.

- **Tasks**
  - **9.1 Search Console monitoring**
    - Weekly/biweekly:
      - Check **Coverage/Pages** for indexing issues.
      - Check **Sitemaps** for errors and index counts.
      - Look at **Search results** for queries, impressions, clicks, and CTR.
  - **9.2 Bing Webmaster monitoring**
    - Periodically review crawl stats and indexing coverage.
  - **9.3 AI visibility spot-checks**
    - Once your site has been indexed for a while:
      - Try queries in ChatGPT (with web/search enabled), Perplexity, Claude, and others such as:
        - Branded: “`<Your Brand>`” or “`<Your Brand> <city>`”.
        - Non-branded: “best `<your category>` in `<city>`” or similar.
      - Check whether your site appears as a citation, and whether descriptions are accurate.
  - **9.4 Adjustments based on findings**
    - If search engines show indexing issues, fix coverage problems and resubmit sitemaps.
    - If AI tools misrepresent key facts, tighten on-site content clarity and FAQ/schema; optionally refine `llms.txt`.
- **Exit Criteria**
  - GSC and Bing show sitemaps accepted and URLs indexed over time.
  - At least occasional AI citations appear for branded or strongly relevant queries (if AI crawlers are allowed).
  - Any misrepresentations spotted in AI answers are tracked and corrected via content/schema improvements.

**Automation potential**

- Scheduled jobs or lightweight scripts that:
  - Pull GSC/Bing/analytics data via their APIs to produce simple monthly reports (top queries, pages, coverage issues).
  - Run Lighthouse (or similar) audits on a schedule for key URLs and log trends.
- Simple reminders:
  - Use calendar tasks or a small CLI/cron job to prompt weekly/biweekly checks.

**Fully manual for this phase**

- Interpreting the data, spotting patterns, and deciding priorities for changes.
- Manually testing AI tools with natural-language queries and judging the quality/accuracy of citations.
- Choosing content/schema/`llms.txt` adjustments when issues are found.

---

## Summary of Submission-Specific Responsibilities

- **Google Search Console**: verify property, submit sitemap, request indexing for key URLs.
- **Bing Webmaster Tools**: verify site, submit sitemap, optionally submit key URLs.
- **IndexNow (optional)**: configure key and automatic URL pings.
- **Alternative engines**: rely on clean `robots.txt`, `sitemap.xml`, and some inbound links.
- **AI platforms**: cannot usually submit directly, but they rely on Google/Bing/Brave indices + your `robots.txt` and (optionally) `llms.txt`.

Use these steps as an overlay on top of the original phases: after technical SEO is in place, run Phase 6b to actively tell the main discovery systems about your site, then Phase 7 to fine-tune AI access and hints.