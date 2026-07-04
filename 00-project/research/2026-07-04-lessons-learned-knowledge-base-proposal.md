# Lessons-Learned Knowledge Base Proposal

**Date:** 2026-07-04
**Status:** Proposal (for study — not yet adopted)
**Author:** claude-fable-5
**Scope:** A system for periodically and incrementally extracting lessons learned from the operational records this workflow already produces (`changelog/`, `troubleshooting/`, `plans-completed/`, `docs/`), accumulating them into a searchable knowledge base with a global/local hierarchy, and feeding them back into research, planning, review, debugging, and coding.
**Motivation:** The workflow already *captures* experience (every troubleshooting entry has a "Notes / Lessons" section; every completed plan records deviations), but nothing *accumulates* it. Each new session starts with zero recall of past mistakes unless someone happens to grep the right folder. This proposal closes the loop so know-how compounds instead of evaporating.

---

## 1. Design Principles

1. **Ride existing habits, don't create new ones.** The single biggest failure mode of knowledge bases is that upkeep requires a separate deliberate act, and people forget. Every capture step in this proposal is bolted onto a workflow step that already happens (`repo-logs-and-docs-sync`, plan archival, "update the logs").
2. **Extraction is the agent's job, not the developer's.** Developers/agents write the raw records they already write. Distillation into lesson cards is an automated (agent-run) pass — periodic and incremental, with a watermark so nothing is processed twice.
3. **One lesson = one file**, exactly like changelog and troubleshooting entries. Same date-prefixed naming, same index.md convention, same newest-first tables. No new mental model.
4. **A maturity ladder, not a dumping ground.** Raw records → lesson cards → playbooks/checklists → skills/hooks/CLAUDE.md rules. Each rung has explicit promotion criteria, so the knowledge base stays small and high-signal instead of becoming a second changelog.
5. **Local first, promote globally on recurrence.** A lesson is born project-local. It is promoted to the shared tier only when it proves general (seen in ≥2 projects, or self-evidently project-independent).

## 2. What Already Exists (do not reinvent)

| Existing asset | What it already provides | Gap this proposal fills |
|---|---|---|
| `troubleshooting/` entry template | Mandatory **"Notes / Lessons"** section per incident | Lessons stay buried inside individual entries; never aggregated |
| `changelog/` + `plans-completed/` + indexes | Chronological, categorized raw record of all work | No distillation pass reads them |
| `11-Skills/` + skill-candidate-scan (2026-05-24) | Proven top rung of the maturity ladder; precedent for "scan records → propose reusable artifacts" | One-off manual scan; no recurring pipeline, no intermediate lesson tier |
| `repo-logs-and-docs-sync` skill | The universal "finisher" invoked after every piece of work | Doesn't touch lessons; ideal attachment point for incremental capture |
| `SHARING_AND_SYNC.md` / Workflow-Scripts-as-submodule model | Workflow-Scripts is already cloned into consumer projects and synced via git | Natural transport for the **global** knowledge tier — no new infra needed |
| Claude Code memory + CLAUDE.md hierarchy | Machine-global and project-local instruction injection | Not structured for many lessons; used as *pointer* tier only (see §5) |

The contribution of this proposal is the **pipeline and the schema**, not new storage or tooling.

## 3. Architecture Overview

```text
                    RAW RECORDS (already produced today)
   changelog/   troubleshooting/   plans-completed/   review findings   git log
        │              │                  │                 │              │
        └──────────────┴────────┬─────────┴─────────────────┴──────────────┘
                                │  DISTILL pass (agent-run, incremental,
                                │  watermarked — §4)
                                ▼
                 ┌───────────────────────────────────┐
                 │  LOCAL KNOWLEDGE BASE (per project)│
                 │  00-project/knowledge/             │
                 │  ├── lessons/  (one card per file) │
                 │  ├── playbooks/ (merged checklists)│
                 │  ├── index.md  (one line per card) │
                 │  └── .watermark (last processed)   │
                 └───────────────┬───────────────────┘
                                 │  PROMOTE on recurrence / generality (§5)
                                 ▼
                 ┌───────────────────────────────────┐
                 │  GLOBAL KNOWLEDGE BASE (shared)    │
                 │  Workflow-Scripts/09-knowledge/    │
                 │  (synced to every consumer project │
                 │   via existing git sharing model)  │
                 └───────────────┬───────────────────┘
                                 │  PROMOTE when a lesson becomes procedure
                                 ▼
                 ┌───────────────────────────────────┐
                 │  EXECUTABLE TIER                   │
                 │  11-Skills/ · hookify hooks ·      │
                 │  CLAUDE.md rules · workflow-doc    │
                 │  checklist amendments              │
                 └───────────────────────────────────┘

   CONSUMPTION (§6): planning/review/debugging workflow docs gain a
   "consult knowledge index" step; index.md is cheap enough to load whole.
```

## 4. The Lesson Card

### 4.1 Location and naming

- Local tier: `00-project/knowledge/lessons/<yyyy-mm-dd>-<category>-<short-title>.md`
- Global tier: `Workflow-Scripts/09-knowledge/lessons/<same naming>`
- Categories reuse the existing troubleshooting/changelog vocabulary where possible: `build`, `runtime`, `data`, `environment`, `security`, `git`, `planning`, `review`, `tooling`, `process`.

### 4.2 Card schema

```markdown
# <Imperative, actionable title — e.g. "Pin Node version in .nvmrc before any Electron packaging">
**Date:** <YYYY-MM-DD>          (date distilled, not date of incident)
**Category:** <build|runtime|data|environment|security|git|planning|review|tooling|process>
**Scope:** <local|global>
**Status:** <active|superseded|promoted>
**Confidence:** <observed-once|recurring|verified-rule>
**Sources:** <relative links to the troubleshooting/changelog/plan entries this was distilled from>

---

## Lesson
One to three sentences. Written as a rule for "future you": what to do or avoid, and in what situation.

## Trigger
When does this apply? The situational cue an agent or developer should pattern-match on
(e.g. "any plan that touches provider model config", "any PR that edits download scripts").

## Evidence
- <date> <one-line summary of the incident/change that taught this> (link)
- <repeat per occurrence — each recurrence appends a line here and bumps Confidence>

## Applied via (optional)
If promoted: link to the skill / hook / CLAUDE.md rule / workflow-doc line that now enforces it.
```

Rules that keep the base high-signal:

- **Actionable titles only.** "We had a bad time with CSS" is not a card; "Run `npm run build` before committing Tailwind config changes" is. If it can't be phrased as an instruction with a trigger, it stays in the troubleshooting entry.
- **Recurrence is recorded, not duplicated.** When the distill pass finds an incident matching an existing card, it appends to `Evidence` and upgrades `Confidence` rather than creating a near-duplicate. This is the compounding mechanism: cards get *heavier*, the base doesn't get *wider*.
- **Cards die.** `Status: superseded` (with a pointer to what replaced it) when the toolchain changes or a rule is disproven. The distill pass flags cards whose referenced files/paths no longer exist.

### 4.3 Playbooks

When ≥3 active cards share a trigger domain (e.g. "Electron packaging", "provider/model config changes"), the distill pass proposes merging them into a single checklist file under `knowledge/playbooks/`. Cards remain as the evidence trail; the playbook is what gets consulted. This mirrors how `11-Skills/` skills reference deeper workflow docs.

## 5. Global / Local Hierarchy

Three tiers, with clear precedence (most specific wins) and clear transport:

| Tier | Location | Transport / sync | What lives here |
|---|---|---|---|
| **Project-local** | `<project>/00-project/knowledge/` (or the consumer-project equivalent meta dir) | Project's own git repo | Lessons specific to this codebase: its quirks, its stack, its past incidents |
| **Global (shared)** | `Workflow-Scripts/09-knowledge/` | Existing Workflow-Scripts git sharing/sync model (`SHARING_AND_SYNC.md`) — every project that clones Workflow-Scripts gets it automatically | Lessons general to the developer/team: process rules, tool gotchas, review heuristics, cross-project stack lessons |
| **Executable** | `11-Skills/`, hookify hooks, CLAUDE.md (project + `~/.claude`) | Existing mechanisms | Lessons hardened into automation. CLAUDE.md carries only *pointers* ("consult `knowledge/index.md` before planning"), never lesson bodies — keeps context cost flat |

**Promotion rules (local → global):**

1. The same lesson (matched by the distill pass on title/trigger similarity) exists in ≥2 project-local bases, **or**
2. The lesson is self-evidently project-independent (about git, a shared tool, the workflow itself), **and**
3. A human (or a review pass) approves the promotion — global cards affect every project, so promotion is a PR to Workflow-Scripts, reviewed like any other change.

On promotion, the local card gets `Status: promoted` + a link; it is not deleted (the local evidence trail stays local).

**Promotion rules (global → executable):** a card at `Confidence: verified-rule` that is mechanical enough to enforce becomes a hookify hook (for "never do X" rules), a skill (for "when doing Y, follow this procedure" rules), or a one-line amendment to the relevant workflow doc's checklist. The existing skill-candidate-scan process is exactly this step, made recurring.

## 6. Consumption: Making Lessons Actually Get Used

A knowledge base nobody reads is worse than none (it costs upkeep). Consumption is wired into the workflow docs, which agents already follow:

1. **Planning** (`01-planning-and-organizing/`): add one step to plan creation and plan review — "Load `knowledge/index.md` (local, then global). List any cards whose Trigger matches this plan's scope; cite them in the plan's risk section or state 'no applicable lessons'." Forcing the explicit *negative* statement is what makes the step un-skippable.
2. **Debugging** (`03-debugging/`): before root-causing, grep the local + global lesson indexes and `troubleshooting/index.md` for symptom keywords. Past incidents are the cheapest hypothesis generator.
3. **Review** (`05-review/`): reviewer passes receive the matched lesson cards as an explicit checklist input ("verify none of these known failure modes are reintroduced").
4. **Coding**: no per-edit ceremony (too noisy). Coverage comes from CLAUDE.md pointer + playbooks matched at plan time + hooks for the mechanical rules.

The `index.md` format makes this cheap: one line per card — `date | category | scope | confidence | actionable title | file` — so loading the entire index is a few hundred tokens even at hundreds of cards.

## 7. The Distill Pass (capture pipeline)

### 7.1 Incremental mode (the default — "no hassle" path)

Attach to `repo-logs-and-docs-sync` as a final step (that skill is already invoked after every change, fix, and plan completion — this is the zero-new-habits attachment point):

```text
After updating changelog/troubleshooting/docs indexes:
1. Read knowledge/.watermark (last processed index rows / git commit).
2. For each NEW record since the watermark:
   a. Troubleshooting entry → its "Notes / Lessons" section is the primary feed.
      Extract 0–N candidate lessons (0 is a valid answer — most entries yield none).
   b. Completed plan → diff "planned" vs "actually done"; deviations and
      review-addendum findings are lesson candidates.
   c. Changelog fixed/config entries → candidate only if the fix implies a
      preventable class of mistake.
3. For each candidate: match against existing cards (title/trigger similarity).
   Match → append Evidence line, bump Confidence. No match → create card, add index row.
4. Advance the watermark. Report in the session summary: "N lessons captured/updated."
```

Cost per invocation: usually zero or one card. This is what keeps the base current without anyone remembering anything.

### 7.2 Periodic mode (weekly/monthly distillation & gardening)

A scheduled or manually-triggered deeper pass (e.g. Claude Code scheduled agent, or a `/distill-lessons` skill invoked ad hoc):

- Sweep the full record set since the last periodic run, including git log — catches anything the incremental pass missed (work done outside the workflow, direct commits).
- **Dedupe & merge** near-duplicate cards.
- **Propose playbooks** where ≥3 cards cluster.
- **Flag stale cards** (referenced paths gone, superseded tooling) for `Status: superseded`.
- **Propose promotions** local→global and global→executable, as a short report a human approves in one skim.
- Rerun of the skill-candidate-scan is folded in here as the top-rung promotion check.

### 7.3 Bootstrap mode (one-time, for existing projects)

Same engine as §7.2 with no watermark — process everything:

1. **Inventory:** enumerate all entries in `troubleshooting/` (richest source — every entry already has a Lessons section), `changelog/fixed|config|refactor`, `plans-completed/` (+ review addenda), and existing research/audit docs (e.g. the repo-audit remediation records in the main project).
2. **Batch by category**, distill each batch in one pass (keeps related incidents together so recurrence is detected during bootstrap, not after).
3. **Emit candidates to a staging file** (`knowledge/BOOTSTRAP-REVIEW.md`), grouped by category, each with proposed card + confidence. Human skims and strikes out the noise — approval is a 10-minute read, not card-by-card ceremony.
4. Approved candidates become cards; watermark is set; incremental mode takes over.

Expected bootstrap yield for this repo pair, judging by current record volume: on the order of 20–50 cards — small enough to review in one sitting, large enough to be immediately useful.

## 8. Keeping It Honest: Anti-Bloat & Staleness Controls

- **Hard bar for card creation:** actionable + has a trigger + would have changed a real past decision. Everything else stays in troubleshooting.
- **Recurrence-append instead of new-card** (§4.2) bounds growth to genuinely new failure modes.
- **Staleness sweep** in every periodic pass; superseded cards drop out of the "active" section of the index.
- **Index is the only always-loaded artifact.** Card bodies are read on trigger-match only.
- **A metric that matters:** each periodic report states how many active cards were *cited* in plans/reviews since the last run. Cards never cited across, say, 3 periodic cycles and still `observed-once` are candidates for archival. Usage, not accumulation, is the health signal.

## 9. Implementation Plan (phased, each phase independently useful)

**Phase 1 — Structure & bootstrap (½ day)**
- Create `00-project/knowledge/` (lessons/, playbooks/, index.md, README with card template) in Workflow-Scripts, and `Workflow-Scripts/09-knowledge/` as the global tier skeleton.
- Run bootstrap mode (§7.3) over this repo pair; human-review the staging file; land the first cards.

**Phase 2 — Incremental capture (½ day)**
- Add the distill step (§7.1) to the `repo-logs-and-docs-sync` skill and to the "update the logs" convention doc (`docs/agents/changelog-and-troubleshooting.md` in the main repo).
- Add the watermark file and the "N lessons captured" report line.

**Phase 3 — Consumption wiring (½ day)**
- Add the "consult knowledge index / state 'no applicable lessons'" step to `01-plan-review.md`, `03-debugging/02-bug-fix-workflow.md`, and `05-review/01-code-review.md`.
- Add the CLAUDE.md pointer line in both repos.

**Phase 4 — Periodic pass & promotion (1 day)**
- Author a `distill-lessons` skill in `11-Skills/` implementing §7.2 (periodic + gardening + promotion proposals).
- Optionally schedule it (Claude Code scheduled agent, weekly) — but manual monthly invocation is an acceptable floor since incremental mode carries the daily load.

**Phase 5 — Executable-tier promotions (ongoing)**
- As cards reach `verified-rule`, promote via the existing skill/hookify/CLAUDE.md mechanisms. First candidates will be obvious from bootstrap.

## 10. Risks & Open Questions

| Risk / question | Mitigation / decision needed |
|---|---|
| Knowledge base becomes a second, noisier changelog | Hard creation bar (§8); recurrence-append; usage-based archival |
| Lessons distilled by an agent may over-generalize from one incident | `Confidence: observed-once` label; rules only become enforced (executable tier) at `verified-rule` |
| Global tier drifts across consumer projects | Global tier lives only in Workflow-Scripts and moves only by PR; consumer projects treat it as read-only and sync via the existing model |
| Where exactly should the global tier live — `09-knowledge/` in Workflow-Scripts vs. a separate repo? | Proposal says Workflow-Scripts (`09-knowledge/` fits the numbered-domain convention and rides existing sync); a separate repo only pays off if non-Workflow-Scripts projects need it. **Decide at Phase 1.** |
| Does machine-global (`~/.claude` memory / global CLAUDE.md) get its own tier? | No — keep it pointer-only. Two content tiers (local, shared-global) are enough; a third invites divergence. |
| Bootstrap review burden for large legacy projects | Staging-file skim model (§7.3); can bootstrap category-by-category over several sessions |

## 11. Success Criteria

1. **Capture is free:** after Phase 2, lessons accrue with zero additional developer actions beyond today's "update the logs" habit.
2. **Lessons get cited:** within a month of Phase 3, plans and reviews routinely cite cards (or state "no applicable lessons") — measurable from the periodic report.
3. **A repeat is prevented:** the real test — at least one incident class that appears in the pre-bootstrap troubleshooting record does *not* recur after its card/playbook/hook lands, or is caught at plan/review time by a cited card.
4. **The base stays small:** active-card count grows sublinearly with record count (recurrence-append working), and stale cards are actually retired.
