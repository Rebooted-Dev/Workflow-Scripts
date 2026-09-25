# Implementation Plan Contract

Use this shared contract when creating, reviewing, finalising, or executing a new implementation plan. It defines the required structure and tier rule; workflows should link here rather than maintain a separate copy.

## Tier Rule

Declare `**Tier:** T1`, `**Tier:** T2`, or `**Tier:** T3` in every new plan header. Infer the default from the request:

- **T1 — fix / small, localized:** for example, “fix this bug.”
- **T2 — feature or changed boundary:** for example, “add X.”
- **T3 — system, cross-cutting, or greenfield:** for example, “new project” or “re-architect.”

The reviewer may raise the tier when the actual scope warrants it. Existing plans without a Tier are legacy plans: `check-plan.sh` must warn and exit successfully for them; the linter does not require retrofitting a Tier.

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

## Tasks
### Phase 1: <name>
1. [ ] <task> (P1, Effort: S)
   - Files: <paths>
   - Verify: `<command>` → <expected result> (cost/prereqs: <none | details>)

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
```

## Task and Decision Requirements

- Inside `## Tasks`, each top-level task is a numbered or bulleted checkbox (`1. [ ]` or `- [ ]`), optionally grouped under phase headings. Use 0–3 literal spaces before a top-level marker; use 4+ spaces or a different list marker at the parent's content column for a nested child. Avoid same-marker 0–3-space nesting and tab indentation, which the linter rejects as ambiguous.
- Every top-level task has an indented `Files:` line and an indented `Verify:` line. `Verify:` states the expected result and names cost and prerequisites (use `none` when there are none). Parent-level fields may follow a child checkbox; child-level fields do not count for the parent.
- Give each task its own P0–P3 label. Order phases by dependency, then risk; order tasks within each phase by priority.
- A Decision lists at least two `Option` lines, including an explicitly minimal option, then names the choice and its reversibility. Flag a one-way decision for review.
- Checkboxes outside `## Tasks` (for example, in Success Criteria) are criteria, not tasks.

## Change Surface Requirements

List every relevant site that implements, restates, guards, or historically records the behavior. Include `file:line`, the search command used, and a class for each hit: `implements`, `restates`, `guards`, or `historical`. Classify every result; examples and archived text are not silently treated as active rules.

## Workflow and Validation References

- Resolve the owning repository's metadata root and filenames using [`naming-conventions.md`](./naming-conventions.md#metadata-root-resolution).
- Reviewers re-run the listed Change Surface searches. Confirmation re-runs them after the build; unexplained stale hits mean the affected task is incomplete.
- `check-plan.sh` enforces plan structure only. A new plan declaring a Tier opts into linting; a legacy plan without a Tier remains unaffected as described above.
