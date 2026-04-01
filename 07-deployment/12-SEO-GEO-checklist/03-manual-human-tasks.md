# Manual / Human-Required Tasks

These tasks require human judgment, decision-making, or manual execution that cannot be fully automated.

---

## Deployment Configuration

### Vercel Configuration

| Check | Priority | Status |
|-------|----------|--------|
| `vercel.json` created at project root | P0 | [ ] |
| `buildCommand` set to `npm run build` | P0 | [ ] |
| `outputDirectory` set correctly | P0 | [ ] |
| Security headers configured (X-Content-Type, X-Frame, Referrer-Policy, Permissions-Policy) | P0 | [ ] |
| Asset caching headers set | P1 | [ ] |
| Rewrite rules for `/api/` if needed | P1 | [ ] |
| Region set to `sin1` for Singapore | P1 | [ ] |

### GitHub Actions CI/CD

| Check | Priority | Status |
|-------|----------|--------|
| `.github/workflows/deploy.yml` created | P0 | [ ] |
| Test job runs on push/PR | P0 | [ ] |
| Preview deploy on PR | P1 | [ ] |
| Production deploy on main branch push | P0 | [ ] |
| Vercel secrets configured in GitHub | P0 | [ ] |

### GitHub Issue Templates

| Template | Purpose | Status |
|----------|---------|--------|
| `.github/ISSUE_TEMPLATE/technical-seo-audit.yml` | M1-M3, M5, M12-M14 issues | [ ] |
| `.github/ISSUE_TEMPLATE/local-seo-task.yml` | M4, M7, M10, M15 issues | [ ] |
| `.github/ISSUE_TEMPLATE/geo-visibility-alert.yml` | M16-M17 GEO alerts | [ ] |

### GitHub Project Setup

| Check | Priority | Status |
|-------|----------|--------|
| Create "SEO Operations" project board | P0 | [ ] |
| Configure custom fields (Category, Task Type, Priority, Status, Impact Score) | P0 | [ ] |
| Set up views (Board, Table, Roadmap) | P1 | [ ] |
| Configure auto-add workflow for `seo` labels | P1 | [ ] |

**Reference:** Project configuration in `Workflow-Scripts/07-deployment/08-port-relocation/2026-03-18-SEO-Dashboard/2026-03-18-stack-a-seo-dashboard-implementation-plan.md` Section P0.3

---

## Deployment Readiness

### Scope, Ownership & Environments

| Item | Priority | Evidence | Status |
|------|----------|----------|--------|
| Release owner identified | P0 | Name + contact | [ ] |
| Rollback owner identified | P0 | Name + contact | [ ] |
| Production URL confirmed (`{{DOMAIN}}`) | P0 | Domain record | [ ] |
| Staging/preview environment available | P1 | URL | [ ] |
| Deployment platform confirmed | P0 | Platform/project link | [ ] |
| Release notes / change summary prepared | P1 | Doc or PR link | [ ] |

### Runtime Configuration & Secrets (Manual Setup)

| Variable | Priority | Example | Status |
|----------|----------|---------|--------|
| `NODE_ENV` | P0 | `production` | [ ] |
| `PORT` | P1 | platform-managed or `3000` | [ ] |
| `CORS_ORIGIN` | P0 | `https://{{DOMAIN}}` | [ ] |
| `{{AUTH_SECRET}}` | P0 if auth exists | 32+ random bytes | [ ] |
| `{{DB_CONNECTION}}` | P0 if DB exists | secret connection string | [ ] |
| `{{API_KEY}}` | P0 if provider exists | provider secret | [ ] |
| `{{EMAIL_CONFIG}}` | P1 if email exists | SMTP / API credentials | [ ] |

### Secret Management Controls (Manual)

| Check | Priority | Status |
|-------|----------|--------|
| Secrets stored in platform secret manager, not repo | P0 | [ ] |
| `.env` and secret files ignored by git | P0 | [ ] |
| `.env.example` exists with placeholders only | P1 | [ ] |
| Secret rotation process documented | P1 | [ ] |
| Separate secrets per environment | P0 | [ ] |

### Infrastructure, DNS & TLS (Manual Configuration)

| Check | Priority | Evidence | Status |
|-------|----------|----------|--------|
| Apex and `www` DNS records correct | P0 | DNS lookup / dashboard | [ ] |
| HTTPS certificate provisioned and valid | P0 | browser / SSL check | [ ] |
| HTTP redirects to HTTPS | P0 | curl/browser test | [ ] |
| Canonical hostname enforced (`www` vs apex) | P0 | redirect test | [ ] |
| TLS settings meet platform defaults or better | P1 | platform config | [ ] |
| CDN / edge caching configured intentionally | P1 | config or dashboard | [ ] |

### Deployment Strategy & Rollback (Human Decisions)

| Check | Priority | Evidence | Status |
|-------|----------|----------|--------|
| Deployment command documented | P0 | runbook | [ ] |
| Rollback method documented | P0 | runbook | [ ] |
| Database migration plan documented | P0 if DB exists | runbook / migration file | [ ] |
| Migrations are backward compatible or paired with release sequencing | P0 if DB exists | review note | [ ] |
| Backups/snapshots verified before risky changes | P0 if DB exists | backup evidence | [ ] |
| Zero-downtime or acceptable maintenance window defined | P1 | runbook | [ ] |
| Health check endpoint exists and is used | P1 | URL / monitor | [ ] |

### CI/CD Controls (Manual Configuration)

| Check | Priority | Evidence | Status |
|-------|----------|----------|--------|
| Production deploy is restricted to protected branches/tags | P0 | repo settings | [ ] |
| CI secrets stored in repository/org secret store | P0 | settings | [ ] |
| Manual approval exists for sensitive production releases | P1 | environment rules | [ ] |
| Deployment notifications sent to team channel | P2 | integration proof | [ ] |

### Post-Deploy Verification (Manual Testing)

| Check | Priority | Evidence | Status |
|-------|----------|----------|--------|
| Homepage loads on production | P0 | browser / curl | [ ] |
| Critical journeys pass | P0 | smoke test result | [ ] |
| Forms, auth, payments, or booking flows tested if present | P0 | smoke test result | [ ] |

---

## Security Checklist

### Baseline Security Gates (Human Review)

| Check | Priority | Status |
|-------|----------|--------|
| No default credentials or sample secrets remain | P0 | [ ] |
| Admin or private routes require authorization | P0 | [ ] |
| Production debug mode is disabled | P0 | [ ] |
| Stack traces and internal errors are not exposed to users | P0 | [ ] |
| Dependency risk review completed and high/critical issues triaged | P0 | [ ] |
| Security-sensitive changes had human review | P0 | [ ] |

### Authentication, Sessions & Access Control (Human Review)

| Check | Priority | Status |
|-------|----------|--------|
| Passwords are hashed with a modern password hasher | P0 | [ ] |
| Session or token expiry is defined | P0 | [ ] |
| Session cookies are `HttpOnly`, `Secure`, and `SameSite` | P0 | [ ] |
| Password reset tokens are short-lived and single-use | P0 | [ ] |
| MFA is available for admins or sensitive actions | P1 | [ ] |
| Failed login throttling / lockout exists | P1 | [ ] |
| Authorization checks enforce tenant/resource ownership | P0 | [ ] |

### Public Site / No Auth (Human Review)

| Check | Priority | Status |
|-------|----------|--------|
| Public forms have server-side validation | P0 | [ ] |
| Public forms are rate-limited | P0 | [ ] |
| CSRF protection exists where cookies/sessions are used | P0 | [ ] |
| Bot/spam mitigation exists where abuse is likely | P1 | [ ] |

### Logging, Monitoring & Recovery (Human Setup)

| Check | Priority | Status |
|-------|----------|--------|
| Security-relevant events are logged | P1 | [ ] |
| Secrets and PII are not written to logs | P0 | [ ] |
| Alerts exist for sustained 5xx/auth abuse/spikes | P1 | [ ] |
| Backup/restore procedure exists and is periodically tested | P0 if stateful | [ ] |
| Incident contact and escalation path are documented | P1 | [ ] |

### Sensitive / Regulated Data (Human Decisions)

| Check | Priority | Status |
|-------|----------|--------|
| Data classification completed | P0 | [ ] |
| Privacy policy reflects actual collection and use | P0 | [ ] |
| Data retention and deletion policy defined | P0 | [ ] |
| Sensitive data encrypted in transit and at rest | P0 | [ ] |
| Access to sensitive data is least-privilege | P0 | [ ] |
| Audit trail exists for sensitive data access | P1 | [ ] |
| DSAR / consent / regulatory workflows defined where required | P1 | [ ] |

### Healthcare / Singapore PDPA Compliance (If Applicable)

| Check | Priority | Status |
|-------|----------|--------|
| Privacy policy page created (`/privacy-policy`) | P0 | [ ] |
| Terms of service page created (`/terms-of-service`) | P0 | [ ] |
| Data retention policy documented | P0 | [ ] |
| Contact form consent language reviewed/approved | P1 | [ ] |
| DSAR (Data Subject Access Request) process defined | P1 | [ ] |
| PII in submission logs considered for encryption | P1 | [ ] | |

---

## SEO Checklist

### Content Quality & YMYL / E-E-A-T (Human Review)

| Check | Priority | Status |
|-------|----------|--------|
| Critical pages show clear business identity and contact details | P0 | [ ] |
| Expert or organization credentials are visible where trust matters | P1 | [ ] |
| Claims are current, supportable, and not misleading | P0 | [ ] |
| Author, reviewer, or organization attribution exists where relevant | P1 | [ ] |
| Thin, duplicate, or placeholder pages are removed or noindexed | P0 | [ ] |

### Search Tooling (Manual Setup)

| Check | Priority | Status |
|-------|----------|--------|
| Google Search Console property exists and is verified | P1 | [ ] |
| Bing Webmaster property exists where relevant | P2 | [ ] |
| XML sitemap submitted | P1 | [ ] |
| Manual URL inspection performed for launch-critical pages | P1 | [ ] |

### Looker Studio Dashboard Setup

| Check | Priority | Status |
|-------|----------|--------|
| Create Looker Studio account | P0 | [ ] |
| Add Porter Metrics GSC template | P1 | [ ] |
| Connect GSC data source | P0 | [ ] |
| Connect GA4 data source (if implemented) | P2 | [ ] |
| Create Executive Summary view (1-page) | P1 | [ ] |
| Create Technical Performance view | P1 | [ ] |
| Create Monthly Trends view | P1 | [ ] |
| Schedule weekly automated reports | P1 | [ ] |
| Schedule monthly full report | P1 | [ ] |

**Reference:** Detailed setup in `Workflow-Scripts/07-deployment/08-port-relocation/2026-03-18-SEO-Dashboard/2026-03-18-stack-a-seo-dashboard-implementation-plan.md` Section P0.2

### SEO Panel Deployment (Optional - Self-Hosted)

| Check | Priority | Status |
|-------|----------|--------|
| Select and purchase hosting (PHP 7.4+, MySQL 5.7+) | P2 | [ ] |
| Create MySQL database | P2 | [ ] |
| Download and upload SEO Panel | P2 | [ ] |
| Run web installer | P2 | [ ] |
| Post-installation security (remove install dir) | P2 | [ ] |
| Add website and configure | P2 | [ ] |
| Configure search engines (Google SG, MY, COM) | P2 | [ ] |
| Add target keywords (7+) | P2 | [ ] |
| Set up automated reports | P2 | [ ] |
| Configure weekly site audit | P2 | [ ] |

**Reference:** Detailed deployment in `Workflow-Scripts/07-deployment/08-port-relocation/2026-03-18-SEO-Dashboard/2026-03-18-stack-a-seo-dashboard-implementation-plan.md` Section P2.1

### CookieYes Consent Management

| Check | Priority | Status |
|-------|----------|--------|
| Sign up for CookieYes Free | P1 | [ ] |
| Add CookieYes script to website `<head>` | P1 | [ ] |
| Test consent flow | P1 | [ ] |
| Verify PDPA-compliant consent banner | P1 | [ ] |

**Reference:** Setup in `Workflow-Scripts/07-deployment/08-port-relocation/2026-03-18-SEO-Dashboard/2026-03-18-stack-a-seo-dashboard-implementation-plan.md` Section P1.4 |

### SEO/GEO Policy Decisions

| Check | Priority | Status |
|-------|----------|--------|
| Analytics posture decided (none vs GA4 vs privacy-first) | P1 | [ ] |
| Privacy/consent policy approved | P1 | [ ] |
| `llms.txt` content formally approved (factual + privacy reviewed) | P1 | [ ] |
| Markets/engines scope defined (Google-only vs Bing + regional) | P2 | [ ] |
| Brand "official description" (short + long) approved | P1 | [ ] |
| Page copy approved (factual, unambiguous, reduces AI hallucination) | P0 | [ ] |
| FAQs approved (answer real user questions for SEO + GEO) | P1 | [ ] | |

---

## GEO / Local Discoverability (Human Decisions)

### Canonical Business Data (Human Verification)

| Check | Priority | Status |
|-------|----------|--------|
| Business name is standardized everywhere | P0 | [ ] |
| Address is standardized everywhere | P0 | [ ] |
| Primary phone is standardized everywhere | P0 | [ ] |
| Opening hours are current and timezone-aware | P0 | [ ] |
| Latitude/longitude are correct if maps/schema use them | P1 | [ ] |
| Location data has a single source of truth in code/content | P1 | [ ] |

### Local SEO Essentials (Human Setup)

| Check | Priority | Status |
|-------|----------|--------|
| Google Business Profile is claimed and accurate | P1 | [ ] |
| Website NAP matches directory and map listings | P0 | [ ] |
| LocalBusiness or relevant business schema is implemented | P1 | [ ] |
| Contact/location page includes address, hours, phone, and directions | P0 | [ ] |
| Service area / multiple locations are clearly separated | P1 | [ ] |

### Singapore Healthcare Directory Submissions

| Directory | Priority | Status |
|-----------|----------|--------|
| Google Business Profile | CRITICAL | [ ] |
| HealthHub.sg | HIGH | [ ] |
| SingHealth Directory | MEDIUM | [ ] |
| Yellow Pages Singapore | MEDIUM | [ ] |
| DoctorXDentist | MEDIUM | [ ] |
| Practo Singapore | LOW | [ ] |

### Google Business Profile Attributes

| Attribute | Status |
|-----------|--------|
| Wheelchair accessible | [ ] |
| Accepts new patients | [ ] |
| CHAS accredited | [ ] |
| Medisave accredited | [ ] |
| Languages spoken | [ ] | |

### AI Search / Citation Readiness (Human Decisions)

| Check | Priority | Status |
|-------|----------|--------|
| High-value pages clearly state who you are, what you do, where you are, and how to contact you | P0 | [ ] |
| FAQ / service / location content is concise and citation-friendly | P1 | [ ] |
| Structured data aligns with visible page content | P0 | [ ] |
| AI crawler policy in `robots.txt` is an explicit business decision | P1 | [ ] |
| `/llms.txt` is added only if the team will maintain it | P2 | [ ] |

### `robots.txt` Policy Note

Do not copy a bot allow/block list blindly. Document the business decision first:

- allow all compliant crawlers
- allow citation/search crawlers but block training crawlers where supported
- block all AI-specific crawlers where supported

Record the chosen policy, rationale, and date reviewed.

---

## Operations & Maintenance

### Day-0 / Launch-Day Checks (Human Decisions)

| Check | Priority | Status |
|-------|----------|--------|
| Production analytics / monitoring verified | P1 | [ ] |
| Error budget / alert destinations confirmed | P1 | [ ] |
| Support/contact team informed of launch | P2 | [ ] |
| Rollback decision threshold agreed | P1 | [ ] |

---

*Document auto-generated from: 12-comprehensive-deployment-security-seo-geo-checklist.md*
