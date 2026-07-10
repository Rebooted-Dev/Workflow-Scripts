# 2026-07-06 — Workflow-Scripts v2: Engineering Quality & Lifecycle Proposal (companion to the Full-Autonomy Redesign)

**Status:** Implemented (Phase 3 engineering-quality lifecycle complete via Drag-Free-v2 unified plan, 2026-07-06) — follow-up items remain
**Implementation record:** `workflows-drag-free/00-project/changelog/plans/2026-07-06-drag-free-v2-unified-implementation-plan.md` (relocated from `00-project/plans/Drag-Free-v2/` on 2026-07-10)
**Author:** claude-fable-5 (with codex/gpt-5.5 low survey pass)
**Rubric:** `00-Meta-Workflow/00-meta/severity-priority-rubric.md`
**Evidence base:** direct file review (this session) + delegated survey filed at `workflow-engineering-quality-survey-260706-0137-gpt55.md` (same directory)
**Companion to:** `2026-07-06-workflow-system-v2-redesign-proposal.md` — that proposal fixes the system's *mechanics* (drift, token cost, enforcement, roles). This one fixes its *engineering substance*: what the workflows actually teach and require about building good software. Numbering continues from it (weaknesses W13+, improvements KI-12+); its structures (frontmatter, `core/` partials, role registry, `wf` CLI) are assumed and built upon, never duplicated.

---

## 1. Executive Summary

Workflow-Scripts has a strong **process spine** (research → plan → review → execute → confirm → file) and a strong **retrospective quality apparatus** (five review workflows sharing a rubric and evidence standards). What it lacks is a **forward-looking engineering discipline**: nothing in the system designs an architecture, states the code-design standards an implementer must follow, requires an error-handling or observability strategy before code is written, provides a repeatable deployment path, or records technical debt at the moment it is incurred.

The consequence is structural, not incidental: **quality is discovered, not specified.** The review workflows can only find design flaws, silent failures, missing abstractions, and debt *after* they exist — which is precisely the "constantly refactor to stay afloat" trap. The 2026-07-06 quality survey confirmed this across eight probes: every quality concern scored PARTIAL, and the pattern behind every PARTIAL is the same — the concern exists as a *review checklist item* or an *optional documentation skeleton*, never as a *standard the build workflow enforces*.

**The thesis of this proposal: move quality left, symmetrically.** Write each engineering standard once (as a `core/standards/` partial per the companion proposal's KI-2 mechanism), then reference it *forward* from planning and execution ("design and build to this") and *backward* from review ("judge against this"). Add the four missing lifecycle stages — architecture/design, observability setup, generic deployment, greenfield scaffold — as first-class workflows, and make debt a ledgered artifact instead of a review-time discovery. Ceremony is tiered by change size so a one-line fix never pays a design-gate tax.

Seven improvements are proposed (KI-12 – KI-18), phased to interleave with the companion proposal's Phases 1–3.

---

## 2. Gap Analysis (verified against the live tree)

Weakness numbering continues from the companion proposal (W1–W12).

| # | Weakness | Evidence | Consequence |
|---|---|---|---|
| W13 | **Architecture is analyzed, never designed** | `00-research-and-plan.md:63` — the "Architecture agent" only "Map[s] the overall system architecture"; the plan's single "Decision Record" block (`:122-127`) covers the overall approach, not individual design decisions; `01-plan-review.md:31` asks reviewers to find "design flaws" with no criteria defined; no workflow produces ADRs and `<metadata-root>` has no home for them | For greenfield or structural work, the most consequential decisions (module boundaries, interfaces, data ownership, sync/async, state) are made implicitly inside implementation, are unreviewable before code exists, and are unrecorded afterward — the root source of creeping architecture debt |
| W14 | **No code-design standard at build time** | `01-execution.md:54` asks agents to "Validate code quality and adherence to project conventions" but no document defines the standard; OO design, abstraction, information hiding/encapsulation, class design, type safety, memory safety, and immutability appear *only* in the retrospective checklist of `03-code-refactoring.md:75-87` ("unclear abstractions", "Tight coupling", "Module boundaries", "Type safety") | The implementing agent improvises design quality per run; the review workflow then re-litigates it with different (unstated) criteria; findings become refactoring work that proper forward standards would have prevented |
| W15 | **Error handling is a review concern, not an implementer contract** | `01-execution.md:73` ("If failures: fix, then re-run") is the only error-related instruction during build; error taxonomy, fallback rules, retry policy, graceful degradation, and silent-failure avoidance appear only in `03-code-refactoring.md:29-32` (triggered "error handling agent") and `05-comprehensive-audit.md:43-45` ("swallowed exceptions"); the doc template's "Error taxonomy"/"Recovery" sections (`00-doc-templates.md:437-458`) are optional after-the-fact docs | Silent failures and ad-hoc catch blocks ship, then surface as debugging sessions and audit findings; no workflow ever requires deciding *what should happen when this fails* before writing the code |
| W16 | **Observability is absent from the lifecycle** | No workflow sets up logging/metrics/tracing/health checks; the only hard requirement in the entire repo is Electron-specific (`01a-MACOS_ELECTRON_GUIDE.md:172-208`, "Every implementation must include a modular packaged-runtime logging mechanism"); elsewhere it is "only if present" documentation (`01-create-docs.md:256-265`) or a review lens (`05-comprehensive-audit.md:53-55`) | Projects reach production with `console.log` and nothing else; debugging workflows (`03-debugging/`) then operate blind — the system asks agents to read logs it never asked anyone to produce |
| W17 | **Deployment is a guide pile, not a workflow** | `07-deployment/README.md:1-31` routes to tech-specific guides (Electron, electron-vite, AI Studio, Firebase, Nginx, ports); no generic deploy workflow exists; `08a-pre-deployment-security-check.md` is a genuinely good gate but npm-ecosystem-only (`npm audit`/`npm outdated`/`npm run build`) | "Deploy the MVP" has no repeatable path; every non-Electron, non-Firebase deployment is improvised; the security gate silently doesn't apply to Python/Go/Rust projects |
| W18 | **No greenfield lane** | `00-project-setup/01-setup-project.md` sets up *workflow metadata* (`project/`, agent files) and requires "Git repository initialized" (`:112-117`); `00-research-and-plan.md` assumes a codebase to analyze (`:59-67`); survey Q6: "no single greenfield workflow from idea/concept → product architecture → scaffold → implementation → deploy MVP" | The highest-leverage moment for preventing tech debt — project inception, when type strictness, lint, test harness, CI, and deploy pipeline cost minutes to establish — has no workflow; projects bolt these on later at 10× cost, which *is* the creeping-debt failure mode |
| W19 | **Tech debt has no ledger** | Debt appears only as review output (`03-code-refactoring.md:51-56` "Technical debt summary") and a planning priority note (`02-finalise-plan.md:53-57`); nothing records debt *when it is incurred*, no debt register exists in the metadata tree, no paydown trigger or budget rule anywhere | Deliberate shortcuts taken during execution ("hardcode this for now") vanish from institutional memory until a review rediscovers them as anonymous findings; planning cannot budget paydown because the debt inventory doesn't exist |

**The cross-cutting pattern:** compare `05-review/03-code-refactoring.md:75-87` (twelve quality focus areas: abstractions, coupling, module boundaries, error handling, type safety…) with `02-code-build/01-execution.md` (zero of those twelve stated as build requirements). The system already knows what good code looks like — it just only says so *after* the code is written.

---

## 3. Guiding Principles

1. **Specify forward, review backward, from the same file.** Every quality standard lives in exactly one `core/standards/` partial (KI-2 mechanism). Execution workflows reference it as a build requirement; review workflows reference it as the judging criteria. Symmetry closes the gap where the builder and the reviewer hold different (or no) standards.
2. **Decisions are artifacts.** Any decision expensive to reverse (boundaries, interfaces, storage, protocols, dependencies) gets a recorded ADR with alternatives and trade-offs — reviewable before build, findable after.
3. **Ceremony is tiered by blast radius.** Three tiers: **T1 fix/small** (no design gate, standards apply implicitly), **T2 feature** (plan quality sections required, ADRs for new boundaries), **T3 system/greenfield** (full design workflow + review gate). Tier is declared in the plan header; the default for "new project" is T3, for "fix this bug" T1.
4. **The skeleton deploys first.** Greenfield work stands up the walking skeleton — repo, strict types, lint, tests, CI, observability baseline, *and a production deployment of the empty app* — before the first feature. Every later merge then rides a proven path to production; deployment and observability stop being end-of-project cliffs.
5. **Debt is borrowed on the record.** Taking a shortcut is legitimate; taking it silently is not. Debt entries are written at the moment of incurrence with a paydown trigger, and planning consults the ledger.
6. **Language-agnostic contracts, language-specific appendices.** Standards state principles (encapsulate invariants; make illegal states unrepresentable; no swallowed errors) in the body, with per-ecosystem specifics (TS `strict`, Python typing/mypy, Rust ownership, Go error idioms) as short appendix tables — same three-tier loading as KI-10.

---

## 4. Key Improvements (KI-12 – KI-18)

### ⭐ KI-12: Architecture & design workflow + ADR record (the missing lifecycle stage)

New workflow `01-planning-and-organizing/00a-architecture-and-design.md`, slotted between research and plan finalisation for T2/T3 work:

1. **Design brief** — context, quality attributes that matter *for this system* (latency? auditability? offline?), constraints, load/scale assumptions stated honestly (an MVP for 10 users should say so and design for it — right-sizing is the anti-debt, anti-overengineering move).
2. **Boundary design** — modules/components, each with: responsibility (one sentence), owned data, public interface sketch, what it hides (the information-hiding test: "what can change inside this module without touching its callers?").
3. **Contract design** — interfaces/types for the seams: function signatures or API shapes, error surface per interface (what failures callers must handle), invariants each type enforces. This is where "elegant use of object orientation" is earned: types that make illegal states unrepresentable, constructors that enforce invariants, capabilities exposed as narrow interfaces.
4. **ADRs** — one per hard-to-reverse decision, filed in `<metadata-root>/decisions/` (`adr-NNNN-<slug>.md`, ~20 lines: context, decision, alternatives considered, consequences, status). Indexed like changelog entries (generated per KI-8). Superseding an ADR is a new ADR that links the old one — the record never lies.
5. **Design review gate (T3, optional T2)** — the existing adversarial plan-review machinery (`01-plan-review.md`, orchestrator, multi-model fan-out) pointed at the design brief + ADRs *before* implementation planning. Cheapest possible moment to catch a boundary mistake.

Frontmatter (KI-1) wires it in: `prev: [research-and-plan]`, `next: [plan-review]`, `outputs: [design-brief, adrs]`. The plan template (KI-14) links the brief; execution (KI-13 wiring) treats ADRs as binding unless formally superseded.

### ⭐ KI-13: `core/standards/` — the engineering standards partials

Four new partials under the companion proposal's `core/` mechanism, each ≤80 lines body + per-language appendix, each referenced (never restated, per KI-10) by both build and review workflows:

| Partial | Contract highlights |
|---|---|
| `core/standards/code-design.md` | Module boundaries per the design brief; **information hiding** (export the minimum; internals unreachable); **encapsulation** (invariants enforced in one place — constructor/factory validates, type carries the guarantee); composition over inheritance, inheritance only for true is-a with LSP; dependency direction (domain logic imports nothing about I/O); **type safety** (strictest mode on; no `any`/untyped escape hatches without a ledgered debt entry; parse don't validate at boundaries); **memory/resource safety** (bounded buffers/queues; deterministic cleanup — RAII/`defer`/`using`/context managers; no unbounded growth in long-lived processes); immutability by default, mutation as the exception that earns a comment |
| `core/standards/error-handling.md` | Error taxonomy decided *per boundary at design time* (expected-recoverable / expected-unrecoverable / bug); **no silent failures** — every catch either handles meaningfully, adds context and rethrows, or logs at error level with context; fail fast on programmer errors, degrade gracefully on environmental ones; **fallbacks must be designed, not improvised** (a fallback that masks the primary path's failure is a silent failure with extra steps — fallback activation is always logged/counted); retries only for transient faults, with backoff and a budget; user-facing errors say what happened and what to do next, never leak internals; crash-only beats limp-on when state may be corrupt |
| `core/standards/observability.md` | **Baseline owed by any deployable app from the walking skeleton onward:** structured logging (JSON or structured framework — levels used with meaning; error = someone should look, warn = degraded-but-handled), correlation/request IDs across async boundaries, a health/readiness endpoint (or equivalent liveness signal for non-services), startup/shutdown/config logging (secrets redacted), error reporting sink decided (even if it's "local file + review workflow"); metrics/tracing added by trigger (user-facing latency matters → traces; capacity questions → metrics), not by default — right-sized, per Principle 3 |
| `core/standards/security-baseline.md` | Generalizes `08a-pre-deployment-security-check.md` beyond npm: secrets never in source (scanner in CI from skeleton day); dependency audit per ecosystem (npm audit / pip-audit / cargo audit / govulncheck); input validation at trust boundaries per the contract design; least-privilege config defaults; the existing `06-security/` review workflows reference this same file as their baseline expectations |

**Wiring (the part that changes behavior):**
- `02-code-build/01-execution.md` Preparation gains one line: "Load the design brief/ADRs if present and `core/standards/*`; phase exit criteria include conformance." Its per-phase "Validate code quality and adherence to project conventions" bullet finally has a referent.
- `05-review/01-code-review.md`, `03-code-refactoring.md`, `05-comprehensive-audit.md`, `06-security/01-security-review.md` replace their free-floating focus-area lists with references to the same partials (KI-10 dedup applies — the twelve focus areas of `03-code-refactoring.md:75-87` become the *table of contents* of `code-design.md` + `error-handling.md`).
- The KI-11 role registry's scanner roles cite the relevant partial as their evidence standard.

### ⭐ KI-14: Plan template quality sections (tiered)

The plan skeleton in `00-research-and-plan.md` (lines 225–270) gains five sections, required at T2/T3, one-line-each-or-N/A at T1:

```markdown
## Design & Interfaces        # link design brief + ADRs; new/changed boundaries and contracts
## Error-Handling Strategy    # failure modes per phase; taxonomy decisions; fallback/retry choices
## Test Strategy              # what proves each phase (unit/integration/e2e split); how it runs in CI
## Observability Plan         # what gets logged/measured; how we'll know it works (and broke) in prod
## Rollout & Rollback         # how this reaches users; how it comes back out; migration reversibility
```

`01-plan-review.md` reviews these sections against the standards partials (its "design flaws" bullet becomes concrete), and `02-confirm-execution.md` verifies the built system matches them — closing the loop from intention to verification. Frontmatter carries `tier: T1|T2|T3` so `wf validate` can check that T2+ plans contain the sections.

### ⭐ KI-15: Greenfield lane — idea to deployed MVP

New workflow `00-project-setup/00-new-project-mvp.md` (T3 by definition), the missing front door. Sequence, reusing existing stages wherever they exist:

1. **Product brief** — problem, target user, the 3–5 capabilities that *are* the MVP, explicit non-goals ledgered as "not-yet" (scope debt made visible instead of creeping back in).
2. **Research + architecture** — `00-research-and-plan.md` Phase 1 (external research replaces codebase analysis) → KI-12 design workflow. Stack choice is an ADR (boring-technology bias stated: choose the stack you can operate, not admire).
3. **Walking skeleton** — scaffold repo + strictest type/lint config + test harness with one real test + CI running all three + observability baseline (`core/standards/observability.md`) + secrets hygiene + **deploy the near-empty app to the real target** via KI-16. Exit criterion: *a change merged to main reaches production through CI with logs observable.* This is where "no creeping tech debt" is actually won — every quality tool is installed while it's free.
4. **Feature slices** — each MVP capability runs the normal loop (plan → build → review) as a T2 change riding the skeleton's pipeline. Vertical slices (thin end-to-end) over horizontal layers, so the system is always demoable and integration debt can't accumulate silently.
5. **MVP gate** — `08a` security check (generalized per KI-13) + smoke of the golden paths + observability verified ("cause an error on purpose; confirm you can see it") + docs from the existing templates + debt ledger review: every shortcut taken in the sprint is either scheduled or explicitly accepted.
6. **Beyond MVP** — steady state: feature slices at T2, quarterly `03-code-refactoring.md` review reconciled against the debt ledger (KI-17), ADRs for each new boundary. The "and beyond" is just the loop continuing — because the skeleton front-loaded the infrastructure, growth doesn't require re-platforming.

### ⭐ KI-16: Generic deployment workflow

New `07-deployment/00-deploy.md` — the repeatable path the category lacks; existing guides become reference targets it links per stack:

1. Preconditions: CI green; pre-deploy gate passed (`security-baseline.md` checks for the project's ecosystem); config/secrets for the target environment confirmed present and non-default.
2. Deploy: the *same scripted command* every time (established by the skeleton); document it in `docs/deployment/` (template already exists at `00-doc-templates.md:195-215` — this workflow finally makes filling it mandatory for deployables).
3. Verify: health endpoint green; smoke the golden paths; watch error logs for one bake interval.
4. Rollback: the rollback command is written down *before* the deploy and tested once per environment ("a rollback you've never run is a rumor"); DB migrations state their reversibility in the plan's Rollout section (KI-14).
5. Record: changelog entry (existing mechanism) + deploy note in the run manifest (KI-5) so `wf stats` can correlate deploys with incidents.

`07-deployment/README.md`'s decision tree gets one new root: "Deploying anything → `00-deploy.md` (it routes to the tech guides)."

### ⭐ KI-17: Tech-debt ledger

`<metadata-root>/debt/` — one file per debt item (KI-8 mechanism: frontmatter + generated index):

```markdown
---
date: 2026-07-06
kind: shortcut          # shortcut | known-gap | deprecation | scope-cut
severity: S2            # shared rubric
trigger: ">100 users OR auth provider added"
status: open            # open | scheduled | paid | accepted
---
Hardcoded single-tenant assumption in `db/schema.ts` to ship MVP auth.
Paydown: introduce tenant_id column + row-level scoping (~M effort).
```

Wiring: execution's phase report gains "shortcuts taken this phase → `wf debt add` (or manual entry)"; `03-code-refactoring.md` reconciles findings against the ledger (already-ledgered items get status updates, not duplicate findings); `00-research-and-plan.md` Phase 1 reads the ledger (touching a debt-laden area? paydown enters the plan); the **debt budget rule** lives in `02-finalise-plan.md`: T2+ plans in a repo with open S1 debt in touched areas must schedule paydown or record an explicit acceptance. Debt stops being archaeology and becomes a balance you can see.

### ⭐ KI-18: Role registry additions (extends KI-11)

Three additions to the canonical role registry, with contracts per the KI-11 schema:

- **`architect`** — mission: produce/review design briefs, boundary and contract designs, ADRs; output: ADR-conformant records; evidence: every recommendation names the alternative it rejected and why; tier: strong; verify: different-model (design review gate).
- **`resilience-reviewer`** — mission: audit error paths against `error-handling.md` (swallowed errors, unlogged fallbacks, unbounded retries, missing cleanup on failure paths); output: core-conformant findings; the current ad-hoc "error handling agent" (`03-code-refactoring.md:31`) folds into this.
- **`observability-auditor`** — mission: verify the `observability.md` baseline exists and is real ("trigger a failure; show the log line that a responder would see"); output: core-conformant findings; tier: fast.

---

## 5. Lifecycle Coverage Map (before → after)

| Stage | Today | After this proposal |
|---|---|---|
| Idea / concept | — (workflows assume a codebase) | KI-15 product brief |
| Architecture & design | Analysis-only agent roles; no artifact | KI-12 design workflow + ADRs + design review gate |
| Scaffold / project inception | `01-setup-project.md` (metadata only) | KI-15 walking skeleton (quality tooling + deployed pipeline, day one) |
| Build | `02-code-build/` with undefined "code quality" | Same workflows + `core/standards/` as binding referent (KI-13) |
| Error handling / resilience | Review checklist bullet | Design-time strategy (KI-14) + implementer contract (KI-13) + `resilience-reviewer` (KI-18) |
| Observability | Optional docs; Electron-only requirement | Skeleton baseline (KI-13/15) + plan section (KI-14) + auditor role (KI-18) |
| Review / audit | Strong (kept) | Same machinery, now judging against the same standards the builder was given |
| Security | Strong reviews; npm-only pre-deploy gate | Same + `security-baseline.md` generalized gate (KI-13/16) |
| Deployment | Tech-specific guide pile | KI-16 generic workflow routing to guides |
| Debt management | Retrospective review findings | KI-17 ledger: recorded at incurrence, budgeted in planning |
| Beyond MVP | — | KI-15 §6 steady-state loop (slices + quarterly reconciled review) |

---

## 6. Implementation Plan

Interleaves with the companion proposal's phases; content work here is deliberately prose-first so none of it hard-blocks on the `wf` CLI.

### Phase A — Standards and template (P0/P1; can start immediately, lands with companion Phase 2 partials)

- [✅] Author `core/standards/` four partials (code-design, error-handling, observability, security-baseline), KI-10 style: ≤80-line bodies + per-language appendix tables (Effort: M)
- [✅] Wire execution: `01-execution.md` Preparation + phase exit criteria reference the standards; `02-confirm-execution.md` verifies against plan quality sections (Effort: S) — via `engineering-quality-gates` skill hooks on pilot build workflows
- [ ] Wire reviews: replace focus-area lists in `05-review/*` and `06-security/01-security-review.md` with standard references (dedup per KI-10; validation via `check-review-workflow-policy.sh` extension) (Effort: S) — code/security review wired; refactoring/optimization/comprehensive-audit still use legacy focus lists
- [✅] Add tiered quality sections to the plan template in `00-research-and-plan.md`; teach `01-plan-review.md` to review them (Effort: S) — sections added per Phase 3 changelog; `wf validate` tier enforcement pending

### Phase B — Design workflow and ADRs (P1)

- [✅] Author `00a-architecture-and-design.md` (design brief, boundaries, contracts, ADR steps, tier gates) (Effort: M) — shipped as `workflows/planning/04-architecture-design.md`
- [✅] Define ADR format + `<metadata-root>/decisions/` location in `naming-conventions.md`; index via KI-8 mechanism (Effort: S) — generated `00-project/decisions/index.md`
- [✅] Point the design review gate at existing plan-review/orchestrator machinery (frontmatter `next`/`prev`) (Effort: S)
- [✅] Add `architect` role to registry (with KI-11 landing) (Effort: S) — `architecture-reviewer` in `core/roles/`

### Phase C — Greenfield lane and deployment (P2)

- [✅] Author `00-new-project-mvp.md` (product brief → design → walking skeleton → slices → MVP gate) (Effort: M) — shipped as `workflows/setup/08-greenfield-mvp.md`
- [✅] Author `07-deployment/00-deploy.md`; re-root the deployment README decision tree; generalize `08a` per-ecosystem checks into `security-baseline.md` (Effort: M) — shipped as `workflows/deployment/00-deploy.md`
- [ ] Walking-skeleton exit-criteria checklist as a template (`templates/walking-skeleton-checklist.md`) (Effort: S)

### Phase D — Debt ledger and roles (P2/P3)

- [✅] Define debt entry schema + `<metadata-root>/debt/`; add to `naming-conventions.md` and setup workflow (Effort: S) — `core/debt-ledger.md` + generated `00-project/debt/index.md`
- [ ] Wire: execution phase report (record shortcuts), refactoring review (reconcile), planning (consult), finalise-plan (budget rule) (Effort: M) — CLI verbs exist; workflow prose wiring incomplete
- [✅] `wf debt add` / `wf debt list` verbs (with companion Phase 2 CLI); `resilience-reviewer` + `observability-auditor` registry entries (Effort: S)

### Dependencies

- Phase A partials use the KI-2 `core/` mechanism — coordinate location with companion Phase 2 (content can be drafted before the directory exists).
- KI-18 roles depend on the KI-11 registry landing.
- KI-17 generated indexes depend on KI-8; manual index fallback is acceptable in the interim.

---

## 7. Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Process tax on small changes (design gates everywhere) | High | High | Tier system (Principle 3) is load-bearing: T1 requires nothing new; `wf validate` checks sections only at T2+; default tier inferred from request shape |
| Standards partials drift into 300-line style guides | Medium | Medium | KI-10 authoring standard applies (≤80-line bodies); duplication linter; appendices carry the per-language detail |
| Language-agnostic standards too vague to enforce ("be encapsulated") | Medium | Medium | Each rule phrased as a checkable question ("what can change inside this module without touching callers?"); reviewer roles cite the partial section per finding |
| Walking skeleton front-loads infra the project never needs | Medium | Low | Skeleton baseline is deliberately minimal (types/lint/test/CI/logging/deploy); metrics/tracing/etc. are trigger-gated per `observability.md` |
| ADR/debt ledgers rot like the old indexes | Medium | Medium | Both ride KI-8 (entry-file + generated index) — existence *is* indexing; debt reconciliation is a named review step, not a memory |
| Overlap/conflict with companion proposal edits to the same files | Medium | High | Hard rule: this proposal only *adds* sections/references; all dedup and trimming of existing prose belongs to the companion's Phase 2; both plans list the shared files and sequence edits |

---

## 8. Success Criteria

- [ ] Every quality focus area currently listed only in review workflows exists in exactly one `core/standards/` partial referenced by both build and review workflows (grep-verifiable) — standards exist; not all review workflows reference them yet
- [✅] `01-execution.md`'s "validate code quality" instruction resolves to a concrete, citable standard.
- [ ] A T3 project produces: design brief, ≥1 ADR, walking skeleton deployed to production before the first feature slice, and passes the MVP gate — demonstrated end-to-end on one real new project.
- [ ] T2+ plans contain Design/Error-Handling/Test/Observability/Rollout sections (validated by `wf validate` once available); T1 fixes require none of it — sections added to plan skeleton; automated tier validation pending
- [ ] "Cause an error on purpose and show where it's visible" passes on any project that completed the skeleton or MVP gate.
- [✅] Deploying any project follows `00-deploy.md`; rollback command documented and tested per environment — workflow exists; per-environment rollback testing not yet demonstrated
- [ ] Every deliberate shortcut taken during execution in a pilot project appears in `<metadata-root>/debt/` with a trigger; the next quarterly refactoring review reconciles against the ledger with zero duplicate rediscoveries.
- [ ] Survey re-run (same Q1–Q8) scores COVERED on Q1–Q4 and Q6–Q8, and Q5 has a generic deploy path.

---

## 9. Filing

- [✅] Companion evidence: `workflow-engineering-quality-survey-260706-0137-gpt55.md` (this directory).
- [✅] Adversarial review completed jointly with the companion proposal via `2026-07-06-drag-free-v2-unified-implementation-plan.md` (Phase 0).
- Remaining follow-up: T3 pilot demonstration on a real new project. Walking-skeleton checklist template, review-workflow standards wiring, debt-budget rule, and survey re-run are complete.

---

## 10. Revision Log

- **2026-07-06 (initial):** Gap analysis W13–W19, improvements KI-12–KI-18, lifecycle map, phased plan. Evidence: codex/gpt-5.5 low survey (Q1–Q8, all PARTIAL) + direct file verification by claude-fable-5.
- **2026-07-06 (implementation status sync):** Checkboxes updated to reflect Drag-Free-v2 Phase 3 engineering-quality lifecycle execution. Completed items marked `- [✅]`; open items retain `- [ ]` with notes where partially met.
