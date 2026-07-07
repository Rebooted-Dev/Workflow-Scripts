# Deep Review Workflow — Overview & Index

**Date:** 2026-07-03
**Status:** Active (draft workflow set; promote to a numbered workflow directory, e.g. `05-review/05-deep-review.md`, once battle-tested)
**Origin:** Distilled from the Workflow-Scripts deep review of 2026-07-03 (`00-project/plans-completed/review/2026-07-03-workflow-scripts-deep-review-260703-1337-claude.md`) and its independent verification pass (§2.1–2.2 of that report).

## What a Deep Review is

A **Deep Review** is a single, combined audit that runs four lenses over one repository in one session, then survives an independent verification pass:

| Lens | Existing single-lens workflow | What the deep review adds |
|------|------------------------------|---------------------------|
| Defects & risks | `05-review/01-code-review.md` | Same rigor (pre-flight, finding template, dedup) applied to *all* lenses |
| Security | `06-security/01-security-review.md` | Untrusted-content / prompt-injection threat model for agent-executed repos |
| Performance | `05-review/02-code-optimization.md` | Kept proportionate — small tooling repos rarely rise above P3 |
| **Instruction clarity** | *(none existed)* | Treats ambiguity, contradiction, and stale cross-references in agent-executed documents as a first-class defect class |

Use a Deep Review instead of running the three single-lens workflows sequentially when:
- The repo is **instructions-as-code** (workflows, prompts, skills, agent docs) where doc contradictions are functional bugs;
- You want **one consolidated, deduplicated report** rather than three overlapping ones;
- Findings must be **empirically verified** (not just pattern-matched) before anyone acts on them.

## The set

1. **[`2026-07-03-deep-review-01-review-pass.md`](./2026-07-03-deep-review-01-review-pass.md)** — the main review workflow (Phases 0–5): understand → pre-flight → four-lens scan → empirical verification → score & dedup → report.
2. **[`2026-07-03-deep-review-02-verification-pass.md`](./2026-07-03-deep-review-02-verification-pass.md)** — the independent verification pass, ideally run by a **different model or session**, which re-checks every finding against the live worktree and appends a correction addendum to the same report.

## Ground rules (apply to both passes)

- **Read-only.** Neither pass modifies source files. The only writes are the report itself (pass 1) and the addendum appended to it (pass 2).
- **Rubric:** `00-Meta-Workflow/00-meta/severity-priority-rubric.md` is the sole prioritization authority (impact × likelihood matrix). Severity-band shortcuts ("security ⇒ S0/S1") are descriptive expectations only, never rules.
- **Evidence tiers:** every finding is labeled **CONFIRMED** (reproduced/verified empirically in this session) or **PLAUSIBLE** (reasoned from code/docs but not executed). PLAUSIBLE findings must state exactly what command or check would confirm them.
- **Output location:** resolve the report base directory in this order — `project/research/` if `project/` exists → `00-project/research/` (Workflow-Scripts itself) → `<repo-root>/research/` (create). Never create a new `project/` wrapper when an alternate exists.
- **Report name:** `deep-review-YYMMDD-HHMM-{model}.md` per `00-Meta-Workflow/00-meta/naming-conventions.md`.
- **Agent budget:** **3–6 agents total** (including the core roles). One number, one rule. If the trigger table demands more, split into multiple sessions.

## Lifecycle

```
01-review-pass  ──▶  report in research/  ──▶  02-verification-pass (different model)
                                                      │
                                                      ▼
                                     §addendum appended to same report
                                                      │
                                                      ▼
                            01-Planning & Organizing/02-finalise-plan.md
                                (remediation plan from verified findings)
```

When the remediation plan completes, file it per `04-documentation/03-mark-completed.md`.
