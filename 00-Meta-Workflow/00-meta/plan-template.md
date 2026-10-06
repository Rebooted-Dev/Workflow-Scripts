# Implementation Plan Contract

Use this shared contract when creating, reviewing, finalising, or executing a new implementation plan. It defines the required structure and tier rule; workflows should link here rather than maintain a separate copy.

## Tier Rule

Declare `**Tier:** T1`, `**Tier:** T2`, or `**Tier:** T3` in every new plan header. Infer the default from the request:

- **T1 — fix / small, localized:** for example, “fix this bug.”
- **T2 — feature or changed boundary:** for example, “add X.”
- **T3 — system, cross-cutting, or greenfield:** for example, “new project” or “re-architect.”

The reviewer may raise the tier when the actual scope warrants it. Existing plans without a Tier are legacy plans: `check-plan.sh` must warn and exit successfully for them; the linter does not require retrofitting a Tier. That leniency is for old documents only: every workflow that creates, reviews, finalises, or starts executing a plan runs the linter with `--require-tier`, which rejects a plan without a Tier header.

## Required Sections by Tier

T1 plans require only these headings:

- `## Goal`
- `## Change Surface`
- `## Tasks`

T2 and T3 plans require those headings plus:

- `## Decision`
- `## Design & Interfaces`
- `## Failure Modes & Recovery`
- `## Test Strategy`
- `## Rollout & Rollback`

T3 also requires a design review before implementation planning; use `01-plan-review.md` to review the Design section. T1 plans may include other sections when they materially help, but they are not required for a localized fix.

The extended T2/T3 scaffold also provides `## Scope and non-goals`, `## Assumptions`, `## Dependencies`, `## Deferred & Debt`, `## Risks`, and `## Success Criteria`. Include these supporting sections when they fit the plan; they are part of the template but are not additional linter-required headings. A T1 plan may omit them unless scope makes one useful.

## Plan Skeleton

Replace placeholders. A T1 plan may use just Goal, Change Surface, and Tasks; omit other sections that do not earn their cost. T2/T3 plans must retain the five additional required headings above and should use the supporting sections where they add useful scope or evidence.

```markdown
# Implementation Plan: <name>

**Created:** YYYY-MM-DD HH:MM
**Status:** DRAFT
**Tier:** <infer T1, T2, or T3 from the request>

## Goal
<observable outcome and success criteria>

## Scope and non-goals
<what is included and explicitly excluded>

## Assumptions
- <assumption> (confirm by: <how>)

## Change Surface
| Behavior | Sites (file:line) | Class | Found with |
|---|---|---|---|
| <behavior> | <path:line; include fallbacks> | implements / restates / guards / historical | `<search command>` |

## Decision
- **Option A (minimal):** <approach, benefits, costs>
- **Option B:** <alternative, benefits, costs>
- **Chosen:** <option and rationale>. **Reversibility:** cheap / expensive / one-way.

## Design & Interfaces
<responsibilities, boundaries, public interfaces, invariants and enforcement>

## Failure Modes & Recovery
| Failure | Detection | User sees | Recovery |
|---|---|---|---|
| <failure> | <signal> | <effect> | <recovery> |

## Test Strategy
<verification commands, automated tests, and acceptance/smoke checks>

## Rollout & Rollback
<release/checkpoints and a reversible rollback path>

## Artifact lifecycle
| Source locator | Owner repository | Relationship | Disposition / exact destination or retained reason | Verification |
|---|---|---|---|---|
| `research/findings-YYMMDD-HHMM-model.md` | this repository | research | move with the completed plan per owner policy | gate filing check |
| `plans/source-plan.md` | this repository | superseded source | move or retain per owner policy; marked superseded | gate filing check |
| `docs/guide.md` | this repository | live product doc | retain in place — canonical live record | retained-link check |

## Tasks
### Phase 1: <name>
1. [ ] <task> (P1, Effort: S)
   - Files: <paths>
   - Verify: `<command>` → <expected result> (cost/prereqs: <none | details>)

### Phase N: close-out
N. [ ] File the completed plan package via the terminal gate (P2, Effort: S)
   - Open: pending — gate-owned terminal filing, excluded with its paired criterion from implementation-entry eligibility
   - Files: this plan; `## Artifact lifecycle` rows
   - Verify: gate filing verified — inventory matches disk, affected links/indexes repaired, `check-plan.sh --require-tier --state` passes at the final path (cost/prereqs: verified implementation, resolved owner archive policy)

## Dependencies
- <dependency and ordering>

## Deferred & Debt
- <shortcut or deferred item> — where — trigger — severity

## Risks
Use the shared [`severity-priority-rubric.md`](./severity-priority-rubric.md) for impact, likelihood, and severity levels.
| Risk | Impact (Low/Medium/High) | Likelihood (Rare/Possible/Likely) | Severity (S0–S3) | Mitigation |
|---|---|---|---|---|
| <risk> | <level> | <level> | <level> | <mitigation> |

## Success Criteria
- [ ] <observable criterion>
- [ ] Completed plan package filed and verified at its recorded destination — Open: pending — gate-owned filing criterion paired with the terminal filing task
```

## Task and Decision Requirements

- Inside `## Tasks`, each top-level task is a numbered or bulleted checkbox (`1. [ ]` or `- [ ]`), optionally grouped under phase headings. Use 0–3 literal spaces before a top-level marker; use 4+ spaces or a different list marker at the parent's content column for a nested child. Avoid same-marker 0–3-space nesting and tab indentation, which the linter rejects as ambiguous.
- Every top-level task has an indented `Files:` line and an indented `Verify:` line. `Verify:` states the expected result and names cost and prerequisites (use `none` when there are none). Parent-level fields may follow a child checkbox; child-level fields do not count for the parent.
- Give each task its own P0–P3 label. Order phases by dependency, then risk; order tasks within each phase by priority.
- A Decision lists at least two `Option` lines, including an explicitly minimal option, then names the choice and its reversibility. Flag a one-way decision for review.
- Checkboxes in `## Success Criteria` are criteria, not tasks: they need no `Files:` or `Verify:` lines, but their status is tracked under the [Marking Contract](#marking-contract).

## Artifact Lifecycle and Terminal Filing

This is the single source for how a plan accounts for its associated artifacts and closes its lifecycle; workflows link here and do not restate it.

- **Artifact inventory.** Every generated or finalised plan carries an `## Artifact lifecycle` section with one row per associated artifact: Source locator | Owner repository | Relationship | Disposition / exact destination or retained reason | Verification. Source locators are code-form provenance; working final references are Markdown links, rebased after any move. A finalised plan keeps rows for its superseded source plan, review archives, research, and evidence. Live product docs, changelog/troubleshooting entries, and shared or cross-repository records are listed as **retained** with their reason — another repository's records are never moved by this plan's filing. No separate manifest file or parser is required; the table is agent-checked evidence.
- **Terminal filing pair.** The final top-level task is exactly one explicitly designated gate-owned filing task, marked as gate-owned terminal filing in its `Open:` line, with the normal priority, Effort, `Files:`, and `Verify:` fields (its `Verify:` may cite the terminal gate's scoped link check). It is paired with exactly one filing criterion under `## Success Criteria`. Only the terminal gate ticks either box, and only after the filing effects verify. All other tasks — including tests, docs, acceptance obligations, and accepted deferred work — are implementation obligations.
- **Eligibility exclusion.** Entry into the gate's Full completion mode requires every **committed in-scope** task and Success Criterion verified **except** the designated filing pair, which is excluded from implementation-entry eligibility so a plan is not blocked by its own pending bookkeeping. The exclusion applies to that pair only: deferred work committed inside the plan's scope keeps the plan `Not Eligible`, while separately documented external or non-goal debt simply stays open and routed (Deferred & Debt / host tracker) without blocking. No `closed with deferred` mode exists.
- **Proportionality and legacy plans.** A T1 plan may use a single-row inventory and a short filing task; add only the proportional `## Artifact lifecycle` section and the paired filing criterion that filing requires — never raise a tier for filing and never pull in unrelated T2/T3 sections. Older active plans without the section get a proportional inventory and filing pair added where they are executed or at the gate, using what can be verified from the plan's own outputs — no tier upgrade, no history rewrite.

## Marking Contract

This is the single source for how plan boxes are marked. Other workflows link here and do not restate it.

- **Every task, sub-task, and Success Criteria item is a checkbox.** A plan that arrives without them (prose steps, or YAML `todos:` from another tool) gets a `## Tasks` checkbox list and a `**Tier:**` header before it is executed or archived. The conversion is additive: one checkbox per step or todo, with the original text left in place. A step the source calls done starts as `[ ]` and is ticked only when verified.
- **Two states.** `[✅]` means verified complete. `[ ]` means not complete. `[x]`, `[X]`, and `[✓]` are not valid ticks; the linter rejects them in a tiered plan.
- **Tick when verified.** The agent that ran the verification changes `[ ]` to `[✅]` in the same step, for tasks and for criteria. When work is delegated, the orchestrator is the only writer of the plan file and sub-agents return evidence.
- **No silent open box once execution has started.** Each box left `[ ]` carries an `Open:` reason that begins with `pending`, `blocked`, `deferred`, or `retired`, for example `- Open: blocked — hosted CI authority missing`. Put it on an indented line directly under the box (before any sub-tasks) or at the end of the box's own line. A parent's reason covers its sub-tasks. An `Open:` line directly under a phase heading or under `## Success Criteria`, before the first box, covers every unticked box in that section.
- **Parents.** A parent is `[✅]` only when every sub-task is.
- **Retired or deferred work stays `[ ]`** with its reason. Do not tick it and do not delete it.

## Change Surface Requirements

List every relevant site that implements, restates, guards, or historically records the behavior. Include `file:line`, the search command used, and a class for each hit: `implements`, `restates`, `guards`, or `historical`. Classify every result; examples and archived text are not silently treated as active rules.

## Workflow and Validation References

- Resolve the owning repository's metadata root and filenames using [`naming-conventions.md`](./naming-conventions.md#metadata-root-resolution).
- Reviewers re-run the listed Change Surface searches. Confirmation re-runs them after the build; unexplained stale hits mean the affected task is incomplete.
- `check-plan.sh` enforces plan structure and the Marking Contract; it does not judge whether a tick is true. Run it from the Workflow-Scripts checkout ([`naming-conventions.md`](./naming-conventions.md#workflow-scripts-checkout)):
  - `check-plan.sh <plan>` — structure and canonical ticks. Run after any edit to a tiered plan.
  - `check-plan.sh --require-tier <plan>` — also rejects a missing Tier. Run when creating, reviewing, finalising, or starting to execute a plan.
  - `check-plan.sh --state <plan>` — also rejects a silent open box. Run at each phase report, at confirmation, and at the terminal gate. Do not run it on a draft: every task is open before execution starts.
- The artifact inventory is agent-checked evidence at the terminal gate; `check-plan.sh` does not parse it. The gate's scoped `check-active-markdown-links.sh --root … --scope …` run verifies moved links only, never inventory coverage.
