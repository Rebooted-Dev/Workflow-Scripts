# Workflow Auto-Trigger Skills Proposal

**Date:** 2026-07-04
**Status:** Proposal (for study — not yet adopted). Reviewed 2026-07-04 — see §14 Review Addendum for required revisions before adoption.
**Author:** sisyphus-glm-5.2
**Scope:** A thin auto-trigger skill layer over Workflow-Scripts `.md` files that eliminates the *"use `<X.md>` to do Y"* drag-and-drop prompt pattern. The developer types a natural-language request plus any required file references; the right workflow(s) load themselves. Includes the verb vocabulary, the trigger-description schema, a disambiguating router skill, the install pipeline that finally wires `11-Skills/` into agent runtimes, and the wrap-the-unwrapped backlog.
**Motivation:** Today every workflow invocation requires (a) recalling which `.md` file owns the procedure, (b) dragging that file into the prompt, and (c) typing *"use `<file>` to…"*. The file reference for code is unavoidable and not in scope to remove, but the coordinating instruction text and the file lookup are pure ceremony. Worse, the existing `11-Skills/` already encode the right procedures but **are not installed anywhere**, so they cannot auto-trigger — which is why the drag-drop pattern persists despite 14 working skills already existing.

---

## 1. Design Principles

1. **Skills reference workflows; they do not copy them.** Each skill is a thin trigger + sequence + overlap-boundary layer. The authoritative procedure stays in the `.md` file under `Workflow-Scripts/`. This keeps workflows editable in one place.
2. **Cognitive load is the primary metric.** The system fails if the developer has to memorise anything. Natural language is the primary interface; the verb vocabulary is a cheat-sheet, not a required incantation.
3. **Install, do not require.** Skills only auto-trigger if they are in the agent's skills directory. The install pipeline is the load-bearing piece — without it, nothing else matters.
4. **No new file types, no new frontmatter fields.** Reuse the existing `SKILL.md` + `agents/openai.yaml` shape. Extend only the `description` field's trigger vocabulary.
5. **One verb per concern, not one verb per file.** Most workflow files cluster into 8–10 human-scale verbs (`plan`, `review`, `debug`, `execute`, `secure`, `document`, `audit`, `bootstrap`, `ship`, `fix`). The system is organised around verbs, not filenames.
6. **Coexist with OpenCode builtins.** OpenCode ships its own `/review-work`, `/debugging`, `/commit`, `/start-work`. New commands must not collide; verbs are documentation labels, slash commands use a distinct prefix.
7. **File references are honoured, not eliminated.** The developer still drops code files into the prompt. What disappears is the *"use `<X.md>` to…"* prefix and the workflow lookup itself.

## 2. What Already Exists (do not reinvent)

| Existing asset | What it already provides | Gap this proposal fills |
|---|---|---|
| `11-Skills/` (14 skills) | SKILL.md + agents/openai.yaml format; thin-orchestrator pattern; explicit overlap boundaries; wraps planning / execution / bug-fix / code-review workflows | **Not installed** in any agent skills dir → cannot auto-trigger; descriptions only mention workflow filenames, not natural-language verbs |
| `2026-05-24-workflow-scripts-skill-candidate-scan.md` | Identified 16 unwrapped workflows ranked P0–P2; recommended "Human aliases" line per skill; recommended an index/README in `11-Skills/` | None of the 16 candidates were built; the "Human aliases" recommendation was never applied; no index exists |
| `00-Meta-Workflow/00-docs/WORKFLOW_TO_SKILLS_MAPPING_REPORT.md` | Concluded workflows stay as workflows, skills stay as skills; removed broken `09-skills/` symlink experiment | Did not address the install-pipeline gap or the cognitive-load problem |
| `00-project-setup/06-skills-setup.md` | Catalogs per-tool skill storage paths; proposes (but never implements) a `skills-manifest.yaml` + `install-curated-skills` script | The proposed manifest+lockfile+installer pattern is unbuilt; this proposal revives a slimmer version scoped to Workflow-Scripts only |
| `agent-skills-update.sh` (Update-AI-Tools repo) | Runs `npx skills add --global --all vercel-labs/agent-skills` → installs into `~/.agents/skills/`; `~/.claude/skills/` then symlinks to it | Targets only the upstream Vercel repo; does not touch `Workflow-Scripts/11-Skills/` |
| `00-Meta-Workflow/00-meta/naming-conventions.md` | Date-prefixed filenames, metadata-root resolution, `<metadata-root>/research/` for proposals | This proposal follows those conventions verbatim |
| `01-planning-and-organizing/03-plan-review-and-finalise.md` and `02-code-build/03-execute-and-confirm.md` | Tiny orchestration stubs that sequence sibling workflows | Pattern to reuse: router skills are the **skill-layer equivalent** of these stubs |

The contribution of this proposal is the **glue**: verb vocabulary + install pipeline + router skill + wrap-the-unwrapped. It does not invent a new skill format.

## 3. Architecture Overview

```text
              DEVELOPER PROMPT (today)
   "use 02-code-build/01-execution.md to implement
    Phase 1 of plans/auth-feature.md"
        │                       │
        │  ceremony             │  required (file ref)
        ▼                       ▼
   ┌─────────────────────────────────────────────┐
   │  AGENT RUNTIME (Claude / OpenCode / Codex)  │
   │  - reads workflow file from disk            │
   │  - executes procedure                       │
   └─────────────────────────────────────────────┘


              DEVELOPER PROMPT (proposed)
   "implement Phase 1 of plans/auth-feature.md"
        │                       │
        │  natural-language     │  required (file ref)
        │  verb auto-matched    │
        ▼                       ▼
   ┌─────────────────────────────────────────────┐
   │  AGENT RUNTIME                              │
   │      │                                      │
   │      ▼                                      │
   │  INSTALLED SKILL LAYER (~/.agents/skills/,  │
   │  ~/.codex/skills/, ~/.claude/skills/, etc.) │
   │      │                                      │
   │      │  description-field trigger match     │
   │      ▼                                      │
   │  ┌──────────────────────────────────────┐   │
   │  │ wf-execute  (was execute-and-confirm │   │
   │  │             -plan)                   │   │
   │  │  → references, does not copy:        │   │
   │  │    Workflow-Scripts/                 │   │
   │  │      02-code-build/01-execution.md   │   │
   │  └──────────────────────────────────────┘   │
   │      │                                      │
   │      ▼                                      │
   │  - reads workflow file from disk            │
   │  - executes procedure                       │
   └─────────────────────────────────────────────┘


   INSTALL PIPELINE (the missing piece):
   Workflow-Scripts/11-Skills/<skill>/
        │
        │  scripts/install-workflow-skills.sh
        │  (symlinks, single command, idempotent)
        ▼
   ~/.agents/skills/<skill>/   ← primary
   ~/.codex/skills/<skill>/    ← per-tool targets
   ~/.claude/skills/<skill>/
   ~/.opencode/skills/<skill>/ (optional)
   ~/.config/opencode/skills/  (optional, OpenCode only)


   DISAMBIGUATION (when verb is ambiguous):
   "review"  → wf-review? wf-audit? wf-plan-review?
        │
        ▼
   wf-router (skill) asks: "Review code (wf-review),
                            audit repo (wf-audit), or
                            review a plan (wf-plan-review)?"
```

## 4. The Verb Vocabulary (cognitive-load design)

The developer-facing surface is a small set of **verbs**, each mapping to one or more skills. The verbs are documentation labels — the runtime matches natural language against skill `description` fields, not against the verbs directly.

### 4.1 Core verbs (cover ~90% of daily use)

| Verb | Means | Skills behind it (existing → new) |
|---|---|---|
| **plan** | Research, draft, review, finalise an implementation plan | `workflow-plan-review-finalize` → `wf-research-and-plan` (new) |
| **execute** | Implement an approved plan, phase by phase, with verification | `execute-and-confirm-plan` |
| **review** | Code review, optimisation review, refactoring review | `filed-code-review-to-remediation` → `wf-code-optimization`, `wf-code-refactoring`, `wf-comprehensive-audit` (new) |
| **debug** | Diagnose and fix a bug from evidence | `workflow-bug-fix-plan-and-logs` → `wf-bug-description` (new, for complex bugs) |
| **secure** | Security review and security fix | `wf-security-review`, `wf-security-fix` (new) |
| **document** | Sync docs, mark work completed | `repo-logs-and-docs-sync` → `wf-sync-documentation`, `wf-mark-completed` (new) |
| **audit** | Comprehensive repo audit | `wf-comprehensive-audit` (new) — superset of review |
| **bootstrap** | Project setup, repo map, MCP config, skills install, structure migration | `wf-project-bootstrap`, `wf-repo-map`, `wf-mcp-setup`, `wf-skills-install`, `wf-migrate-structure` (new, all from candidate scan P0/P1) |
| **ship** | Pre-deploy security, port management, Electron packaging, dirty-worktree publish | `dirty-worktree-safe-publish` → `wf-pre-deploy-security`, `wf-port-manager`, `wf-electron-packaging` (new) |
| **fix** | Apply a fix described in a review/report (generic; `secure` is the security specialisation) | `wf-security-fix`, `wf-bug-fix` overlap — router decides |

### 4.2 The "Human aliases" line (resurrecting the candidate-scan recommendation)

Every SKILL.md gains a single line directly under the frontmatter:

```markdown
---
name: wf-execute
description: Implement an approved plan, phase by phase, with build/test verification. Use when the user says: implement, execute the plan, run Phase N, ship this plan, build out the feature, work through the plan, do the implementation, execute the implementation, follow the plan, execute-and-confirm.
aliases: execute, implement, ship-the-plan, run-phase
---
```

- `aliases` is consumed by the router skill and the `/workflows` listing; it is not a runtime field that agents must parse.
- The list is short, lowercase, no compound slugs longer than two words.

### 4.3 The cheat-sheet (lives in `11-Skills/README.md`, the missing index)

The candidate scan recommended an index/README in `11-Skills/`; this proposal revives it. Format:

```markdown
# Workflow Skills — Verb Cheat-Sheet

Type naturally. The right skill loads itself. Use this table only when stuck.

| Verb      | Say things like                          | What it does                          |
|-----------|------------------------------------------|---------------------------------------|
| plan      | "plan this feature", "review the plan"   | Research → review → finalise          |
| execute   | "implement Phase 1", "ship the plan"     | Build with verification               |
| review    | "review this code", "check my changes"   | Code/optimisation/refactoring review  |
| debug     | "this is broken", "why is X failing"     | Hypothesis-driven bug fix             |
| secure    | "security audit", "is this safe"         | Security review + fix                 |
| document  | "update the docs", "mark this complete"  | Sync docs, mark done, archive plan    |
| audit     | "audit the whole repo"                   | Comprehensive cross-cutting audit     |
| bootstrap | "set up the project", "configure MCP"    | Project / repo-map / MCP / skills     |
| ship      | "deploy check", "free this port"         | Pre-deploy, ports, packaging, publish |
| fix       | "fix issue #3 from the review"           | Apply a described fix                 |

Type `/workflows` for the full list with aliases.
```

## 5. The Trigger-Description Schema

The `description` field is the only field the agent runtime uses to auto-match user input. Today's descriptions name workflow **filenames** (e.g. *"Use when the user asks to use plan-review/finalise-plan/research-and-plan workflows"*). That requires the developer to already know the filename — defeating the purpose.

### 5.1 New schema (additive, backwards-compatible)

```text
<One-line purpose.>
Use when the user says: <comma-separated natural-language phrases>.
Wraps: <relative path(s) to source workflow .md files>.
```

### 5.2 Worked example — refactored `wf-execute`

Before (current `execute-and-confirm-plan`):
```yaml
description: Execute an approved implementation plan end to end. Use when the user asks to use execute-and-confirm workflow, run execute-and-confirm-plan, ship a named plan, complete a named plan with code changes plus verification, changelog/troubleshooting/docs updates, accurate plan archival.
```

After (`wf-execute`):
```yaml
description: Implement an approved plan, phase by phase, with build/test verification. Use when the user says: implement, execute the plan, run Phase N, ship this plan, build out the feature, work through the plan, do the implementation, execute the implementation, follow the plan. Wraps: Workflow-Scripts/02-code-build/01-execution.md, 02-confirm-execution.md, 03-execute-and-confirm.md.
```

The change is purely additive — workflow-filename triggers remain valid for backward compatibility, but the new natural-language phrases are what make auto-loading work without file drag-drop.

## 6. The Router Skill (`wf-router`)

When the developer's verb is ambiguous (e.g. *"review this"* could be code review, plan review, or comprehensive audit), the router skill fires and asks one short disambiguation question. This is the skill-layer equivalent of the existing `03-plan-review-and-finalise.md` and `03-execute-and-confirm.md` orchestration stubs.

### 6.1 Router logic

1. Inspect the user prompt for code-file references vs. plan-file references vs. neither.
2. If a code file is referenced and the verb is `review`/`audit` → suggest `wf-review`.
3. If a plan file is referenced → suggest `wf-plan-review`.
4. If neither and the verb is `review` → ask one question with three options.
5. If the verb matches exactly one skill → defer to that skill silently (router does not fire).

### 6.2 Router SKILL.md shape

```markdown
---
name: wf-router
description: Disambiguate ambiguous workflow verbs and route to the correct skill. Use when the user says a verb like "review", "fix", "audit", "ship", "bootstrap" without enough context to pick a single skill, or when two skills' trigger phrases both match.
aliases: which-workflow, what-should-i-use
---

# Workflow Router

Use this skill only when the request is genuinely ambiguous between two or more
workflow skills. Do not fire if exactly one skill clearly matches.

## Decision Tree
[file-path reference → skill mapping table]

## Output
Ask at most one short disambiguation question. Never more than three options.
```

The router keeps cognitive load low: the developer never has to know which of three review skills applies — they say *"review"* and the router asks once if needed.

## 7. The Install Pipeline (the critical missing piece)

Without installation, `11-Skills/` remains invisible to agents. This is the single highest-leverage component of the proposal.

### 7.1 Design constraints

- **Idempotent.** Re-running must not duplicate, must update changed skills, must clean removed ones.
- **Cross-tool.** Targets `~/.agents/skills/`, `~/.codex/skills/`, `~/.claude/skills/`, optionally `~/.opencode/skills/` and `~/.config/opencode/skills/` (OpenCode builtin location).
- **Symlink, do not copy.** The source of truth stays in `Workflow-Scripts/11-Skills/`. Edits there propagate on next agent reload. This mirrors the existing `~/.claude/skills/ → ~/.agents/skills/` symlink convention.
- **Single command.** `./Workflow-Scripts/scripts/install-workflow-skills.sh` (or hooked into `agent-skills-update.sh`).

### 7.2 Script shape

```bash
# Workflow-Scripts/scripts/install-workflow-skills.sh
# Usage: ./install-workflow-skills.sh [--target claude|codex|opencode|agents|all]
#                                    [--uninstall]

SOURCE_DIR="$(cd "$(dirname "$0")/.." && pwd)/11-Skills"
TARGETS_DEFAULT=( "$HOME/.agents/skills" "$HOME/.codex/skills" "$HOME/.claude/skills" )

# 1. For each skill folder in $SOURCE_DIR:
#    - For each target dir in $TARGETS:
#      - mkdir -p target
#      - ln -sfn "$SOURCE_DIR/$skill" "$target/$skill"
# 2. Prune: for each entry in target not in source, remove if it is a symlink
#    pointing into $SOURCE_DIR (defensive — never touch foreign skills).
# 3. Print one-line summary: installed N skills into M targets.
```

### 7.3 Integration with existing `agent-skills-update.sh`

The Update-AI-Tools repo already runs `agent-skills-update.sh` to install Vercel skills. The proposal: extend that script (or chain it) to also call `install-workflow-skills.sh` when `Workflow-Scripts/` is present. This means a single `update-ai-tools` invocation keeps everything current.

### 7.4 What this enables

After install:
- `~/.agents/skills/wf-execute/` is a symlink to `Workflow-Scripts/11-Skills/wf-execute/`
- The agent runtime sees the skill, reads its `description`, and auto-triggers on "implement Phase 1"
- The developer never drags a workflow `.md` again

## 8. Skills to Add (wrap-the-unwrapped backlog)

Resurrecting the candidate-scan P0/P1 list, prioritised by daily-use frequency. Each follows the existing `11-Skills/<name>/SKILL.md + agents/openai.yaml` shape with the new trigger-description schema.

### 8.1 Phase 1 — Core verbs (covers every workflow category)

| New skill | Wraps | Verb |
|---|---|---|
| `wf-research-and-plan` | `01-planning-and-organizing/00-research-and-plan.md` | plan |
| `wf-code-optimization` | `05-review/02-code-optimization.md` | review |
| `wf-code-refactoring` | `05-review/03-code-refactoring.md` | review |
| `wf-comprehensive-audit` | `05-review/05-comprehensive-audit.md` | audit |
| `wf-bug-description` | `03-debugging/01-bug-description.md` | debug |
| `wf-security-review` | `06-security/01-security-review.md` | secure |
| `wf-security-fix` | `06-security/02-security-fix.md` | secure, fix |
| `wf-sync-documentation` | `04-documentation/02-sync-documentation.md` | document |
| `wf-mark-completed` | `04-documentation/03-mark-completed.md` | document |
| `wf-create-docs` | `04-documentation/01-create-docs.md` | document |

### 8.2 Phase 2 — Bootstrap/Ship (covers project setup and deployment)

| New skill | Wraps | Verb |
|---|---|---|
| `wf-project-bootstrap` | `00-project-setup/01-setup-project.md`, `07-migrate-project-structure.md` | bootstrap |
| `wf-repo-map` | `00-project-setup/04-track-repos-and-agent-map.md` | bootstrap |
| `wf-mcp-setup` | `00-project-setup/05-mcp-and-config-setup.md` | bootstrap |
| `wf-skills-install` | `00-project-setup/06-skills-setup.md` | bootstrap |
| `wf-pre-deploy-security` | `07-deployment/04-pre-deployment-security-check.md` | ship |
| `wf-port-manager` | `07-deployment/03-port-relocation/port-management-guide.md`, `07-deployment/03-port-relocation/browser-auto-open.md` | ship |
| `wf-electron-packaging` | `07-deployment/01a-MACOS_ELECTRON_GUIDE.md`, `01b-electron-vite.md` | ship |

### 8.3 Phase 3 — Rename existing 14 to `wf-` prefix (optional, debatable)

The existing 14 skills use long compound names (`workflow-plan-review-finalize`). Renaming to the `wf-` prefix would uniform the namespace. **Open Question 9.4** — this is a breaking change for any external reference; the proposal recommends aliasing rather than renaming in Phase 3.

### 8.4 Router + index (cross-cutting)

| New skill | Purpose |
|---|---|
| `wf-router` | Disambiguation (§6) |
| `11-Skills/README.md` | Verb cheat-sheet (§4.3) — the missing index the candidate scan asked for |

## 9. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Symlink-based install breaks on Windows / non-Unix | Low (user is macOS) | High | Phase 1 ships macOS-only (user's platform); a `--copy` fallback mode is a Phase 2 add. Document the platform limit in the script header. |
| `wf-` prefix collides with another tool's skills | Low | Medium | Prefix is intentionally distinctive; install script refuses to overwrite a non-symlink target. |
| Skill descriptions grow too long, hurting trigger accuracy | Medium | Medium | Cap description at ~50 natural-language trigger phrases; push the rest into `aliases` field (router-only). |
| Auto-trigger fires on the wrong skill (overlap collision) | Medium | High | Existing `## Overlap Boundary` sections already address this; the router skill is the second line of defence. Add a CI check (`scripts/validation/check-skill-overlap.sh`) that flags two skills whose trigger phrases overlap >30%. |
| Workflow `.md` file moves/renames and skill points at dead path | Medium | Medium | Skill `Workflow` section uses **search-first, path-second** (existing pattern in `workflow-plan-review-finalize`). Add a markdown-link validator pass to `scripts/validation/`. |
| Renaming existing 14 skills breaks external references | High if renamed | Medium | Recommend **aliasing** (symlink with old name → new name) rather than renaming. Phase 3 only. |
| OpenCode builtins (`/review-work`, `/debugging`, `/commit`) shadow new verbs | High | Low | Verb vocabulary is documentation only; runtime matches via description, not via slash command. No `/review` slash command is introduced. |
| Description-field trigger matching varies by agent runtime | High | Medium | Document per-runtime behaviour in `11-Skills/README.md`; provide explicit slash-command fallbacks (`/wf-execute`, `/wf-plan`, etc.) for runtimes that need them. |
| Developer forgets to re-run installer after pulling new skills | High | Low | Hook installer into existing `agent-skills-update.sh` so any `update-ai-tools` run also refreshes workflow skills. Add a `post-merge` git hook suggestion in `11-Skills/README.md`. |

## 10. Open Questions (for your study)

1. **Rename vs alias for the existing 14?** Renaming uniformises the namespace but breaks external references. Aliasing is safer but leaves two naming schemes coexisting. Recommend alias in Phase 3 — confirm.
2. **Where does `wf-router` live?** It is a skill, so it installs alongside the others. But its trigger is "ambiguous verb" — should it be the **last-resort** match (lowest priority) or an **explicit** call (`/wf-router`)? Recommend last-resort with explicit override.
3. **Should verb vocabulary include `test`?** There is no dedicated testing workflow `.md` today. If added later, `wf-test` would slot in naturally. Defer.
4. **Copy-vs-symlink tradeoff for `~/.codex/skills/`** — Codex may not follow symlinks the way Claude Code does. Need empirical confirmation before Phase 1 ship. If Codex requires copies, the installer gains a `--mode copy|link` flag.
5. **Should `wf-` skills ship their own `references/` with the source workflow `.md` copied in?** Pro: works without `Workflow-Scripts/` present. Con: drift. Recommend **no** — keep single source of truth in `Workflow-Scripts/`.
6. **Is the `aliases` field a new formal field or just convention?** Recommend convention only — frontmatter stays `name` + `description`; aliases live in the body as a tagged line. Avoids frontmatter schema churn.
7. **Per-project skills override?** A consumer project may want to override `wf-execute` with project-specific phases. Out of scope here; future proposal.
8. **Multi-language triggers?** Developer's prompts are English today. If multilingual use grows, trigger phrases need a language tag. Defer.
9. **How does this interact with the proposed Lessons-Learned Knowledge Base (2026-07-04)?** That proposal wires a "consult knowledge index" step into planning/review/debugging workflows. Those workflow `.md` files are what `wf-*` skills wrap — so the integration is automatic. Worth calling out in both proposals' References sections.

## 11. Proposed Phasing (if adopted later)

### Phase 1 — Make existing skills actually load (P0, ~1 day)

1. Write `scripts/install-workflow-skills.sh` (symlink mode, macOS-only).
2. Run it once. Confirm `~/.agents/skills/`, `~/.codex/skills/`, `~/.claude/skills/` now contain the existing 14 skills.
3. Verify auto-trigger works for at least one existing skill (`workflow-plan-review-finalize`).
4. Add `11-Skills/README.md` with the verb cheat-sheet (§4.3).
5. Hook installer into `agent-skills-update.sh` (Update-AI-Tools repo).

**Acceptance:** Developer can type *"review and finalise the plan at plans/X.md"* with no file drag-drop and the skill fires.

### Phase 2 — Refactor descriptions + add router (P1, ~2 days)

1. Refactor all 14 existing SKILL.md `description` fields to the new schema (§5).
2. Add `aliases:` body line to each.
3. Add `wf-router` skill.
4. Add `scripts/validation/check-skill-overlap.sh`.

**Acceptance:** Developer can type *"plan this feature"* or *"review this code"* (no filename) and the correct skill fires or the router asks one question.

### Phase 3 — Wrap the unwrapped (P1, ~3 days)

1. Build the 10 Phase-1 new skills (§8.1) using the new schema.
2. Run installer. Verify coverage across all 6 core workflow categories (01–06).
3. Update verb cheat-sheet.

**Acceptance:** Every workflow `.md` in categories 01–06 has a corresponding `wf-*` skill that auto-triggers.

### Phase 4 — Bootstrap/Ship coverage (P2, ~2 days)

1. Build the 7 Phase-2 new skills (§8.2).
2. Cover categories 00-project-setup and 07-deployment.

**Acceptance:** Project bootstrap and ship workflows are skill-driven end to end.

### Phase 5 — Polish (P3, as needed)

- Optional rename/alias of the original 14 to `wf-` prefix.
- `--mode copy` installer flag for runtimes that need it.
- Multi-language trigger phrases if needed.
- Per-project override mechanism (separate proposal).

## 12. Out of Scope

- **Rewriting workflow `.md` files themselves.** The proposal adds a skill layer above them; the workflows stay authoritative.
- **Changing the existing `SKILL.md` + `agents/openai.yaml` format.** Reused as-is.
- **A new manifest+lockfile system.** The `06-skills-setup.md` proposal for `skills-manifest.yaml` remains unrejected but is not required here; a single installer script suffices.
- **Replacing OpenCode builtins** (`/review-work`, `/debugging`, `/commit`, `/start-work`). Coexist, do not replace.
- **Per-project skill overrides, multi-language triggers, copy-mode default.** All deferred (Open Questions 7, 8, 4).
- **The Lessons-Learned Knowledge Base** (separate 2026-07-04 proposal). This proposal is compatible with it but does not depend on it.
- **Categories 08-API-Integration, 10-technical-docs, 12-SEO-GEO-checklist.** These are reference material and checklists, not procedures — not candidates for verb skills. Specialist skills for them already exist or were proposed separately in the candidate scan.

## 13. References

- `Workflow-Scripts/11-Skills/2026-05-24-workflow-scripts-skill-candidate-scan.md` — prior art; identified 16 unwrapped candidates (none built)
- `Workflow-Scripts/00-Meta-Workflow/00-docs/WORKFLOW_TO_SKILLS_MAPPING_REPORT.md` — workflows vs skills boundary decision
- `Workflow-Scripts/00-project-setup/06-skills-setup.md` — skill storage paths per tool; proposed (unbuilt) manifest+installer
- `Workflow-Scripts/00-Meta-Workflow/00-meta/naming-conventions.md` — naming conventions this proposal follows
- `Workflow-Scripts/00-Meta-Workflow/00-meta/glossary.md` — term definitions (Workflow, Skill, Review pass, etc.)
- `Workflow-Scripts/11-Skills/workflow-plan-review-finalize/SKILL.md` — canonical example of the existing thin-orchestrator skill shape
- `Workflow-Scripts/01-planning-and-organizing/03-plan-review-and-finalise.md` and `02-code-build/03-execute-and-confirm.md` — orchestration-stub pattern reused for the router skill
- `Update-AI-Tools/scripts/setup/agent-skills-update.sh` — existing skill installer; integration target
- `Workflow-Scripts/00-project/research/2026-07-04-lessons-learned-knowledge-base-proposal.md` — sibling proposal; auto-integrates via workflow `.md` files this proposal wraps
- `Workflow-Scripts/00-project/research/2026-06-03-multi-model-plan-review-pass-system-proposal.md` — sibling proposal; the `wf-plan-review` skill would be the natural trigger for invoking multi-model review passes once that system is built

---

## 14. Review Addendum — 2026-07-04 (Claude, second-pass critique)

**Verdict:** The diagnosis is right and the install pipeline (§7) is the correct highest-leverage move. But the design has one structural flaw (skill granularity), one component that cannot work as specified (`wf-router`), and several claims contradicted by the live filesystem. The revisions below shrink the proposal to roughly a third of its build cost while keeping every acceptance criterion.

### 14.1 Confirmed against the live repo

- `11-Skills/` contains exactly 14 skills; none appear in `~/.agents/skills/`, `~/.claude/skills/`, or `~/.codex/skills/`. The "not installed anywhere" premise is accurate.
- Existing descriptions are filename-oriented (verified in `workflow-plan-review-finalize/SKILL.md`), so §5's premise is accurate.
- `agent-skills-update.sh` exists at `Update-AI-Tools/scripts/setup/`, uses `update-utils.sh` exit-code conventions (0/10/20/1), and is a clean chaining target for §7.3.

### 14.2 Contradicted against the live filesystem (fix before Phase 1)

1. **`~/.codex/skills/` contains real directories, not symlinks** — including a `.system/` directory the pruner must never touch. The "symlink, do not copy" constraint (§7.1) already fails on one of the three primary targets. Open Question 4 is answered empirically: the installer needs `--mode copy|link` **in Phase 1**, defaulting to copy for Codex, link elsewhere. Copy mode implies staleness, which is exactly why the §7.3 chaining into `agent-skills-update.sh` stops being a convenience and becomes a requirement.
2. **`~/.claude/skills/` is mixed**: some entries are per-skill relative symlinks into `../../.agents/skills/`, others are real directories. The claimed convention "`~/.claude/skills/` then symlinks to it" (§2 table) is only partially true. Consequence for the installer: prune logic must check each entry individually (`readlink` resolves into `$SOURCE_DIR`) and never assume the directory is homogeneous. §7.2's defensive-prune note survives; the mental model behind it doesn't.

### 14.3 Structural flaw: one skill per workflow is the wrong granularity

Every installed skill's `name` + `description` is loaded into **every agent session's context, in every project, always**. The proposal installs ~32 skills (14 existing + 17 new + router) globally, each with descriptions "capped" at ~50 trigger phrases (§9). That is thousands of tokens of permanent context tax, and — worse for the proposal's own goal — trigger accuracy *degrades* as the candidate set grows: more near-duplicate descriptions means more overlap collisions, which the proposal then patches with a CI overlap checker and a router. Both patches treat a symptom of the granularity choice.

**Revision: one skill per verb, not per workflow.** §4.1 already did the hard work — 10 verbs cover the whole surface. Make each verb one skill (`wf-plan`, `wf-execute`, `wf-review`, `wf-debug`, `wf-secure`, `wf-document`, `wf-bootstrap`, `wf-ship` — `audit` folds into `review`, `fix` folds into `debug`/`secure`). The SKILL.md **body** carries the routing table from user intent to the specific workflow `.md` file(s), plus the overlap boundaries. This:

- cuts installed surface from ~32 skills to **~8**, with short descriptions;
- makes disambiguation happen *after* the skill loads, where the full body is in context and asking one clarifying question is natural — eliminating `wf-router` entirely (see 14.4);
- eliminates the >30%-overlap CI checker by construction (verbs are disjoint by design);
- cuts the wrap-the-unwrapped backlog (§8) from 17 new skills to edits inside ~8 bodies;
- makes Phase 3/4 "coverage" a matter of adding table rows, not authoring skills.

The existing 14 skills are **not** renamed or deleted: the verb skills' routing tables point at them the same way they point at workflow `.md` files ("for X, invoke `execute-and-confirm-plan`"). Phase 3's rename question (§8.3, Open Q1) dissolves — the 14 become internal implementation detail behind the verb layer.

### 14.4 `wf-router` cannot work as specified — delete it

Open Question 2 asks whether the router should be the "last-resort match (lowest priority)". **No such mechanism exists.** Skill selection is not a priority-ordered matcher; the model reads all descriptions in parallel and picks. A skill whose trigger is "use when the verb is ambiguous" describes a *meta-condition the model can only evaluate after already doing the disambiguation* — so it will either never fire or fire in competition with the very skills it is meant to arbitrate. §6.1's router logic (inspect file references, ask one question) is good logic in the wrong place: move it into each verb skill's body as a "Routing" section. `wf-review`'s body says: code file referenced → code-review path; plan file → plan-review path; neither → ask one question, max three options. Same behaviour, zero extra skills, no trigger-priority fiction.

### 14.5 The trigger-description schema over-indexes on phrase count

Description matching is semantic, not keyword lookup. Fifty trigger phrases (§9 cap) doesn't buy 50× the recall of eight well-chosen ones — it buys dilution, and several runtimes cap description length (Claude Code truncates around ~1024 chars). Revised schema:

```text
<One-line purpose.>
Use when the user wants to <intent stated abstractly>,
e.g. "<5–8 representative phrasings>".
Do NOT use for <the adjacent verb(s) this skill excludes>.
```

Two changes from §5.1: (a) 5–8 examples, not a phrase dump; (b) a **negative trigger** line — with only ~8 verb skills installed, the boundaries between them do more disambiguation work than any number of additional positive phrases. Drop `Wraps:` from the description entirely: the description is trigger surface, and file paths spend that budget on strings no user will ever type. Paths live in the body's routing table.

Also resolve the internal contradiction: §4.2 shows `aliases:` **in frontmatter** while Open Question 6 recommends a body-line convention. With the router gone, aliases have no remaining consumer except the cheat-sheet — put them in the README table (§4.3) and drop the field from skills altogether.

### 14.6 Missing: global-install scope leakage

Skills installed to `~/.agents/skills/` etc. fire in **every project**, including ones with no `Workflow-Scripts/` checkout. "Implement Phase 1 of the plan" typed in an unrelated repo would load `wf-execute`, which then references workflow files that don't exist from that cwd. Two mitigations, both cheap:

1. Each verb skill's body opens with a scope guard: *"Resolve the Workflow-Scripts root (search upward from cwd; else `~/Development/Personal/Update-AI-Tools/Workflow-Scripts/`). If not found, say so and proceed with best judgment instead of pretending to follow the workflow."* The absolute fallback path matters — relative `Workflow-Scripts/...` references only resolve from the two tracked repos.
2. The description's intent line stays workflow-flavoured ("following the repository's workflow procedures") so bare "fix this bug" in a foreign project doesn't hijack.

### 14.7 Missing: an acceptance test that isn't vibes

Every phase's acceptance criterion is "type X and the right skill fires" — a one-shot manual check of a stochastic system. Add a fixture file, `11-Skills/trigger-eval.md`: ~20 canonical prompts → expected skill (including ~5 negative cases that should trigger *nothing*). Run it manually after any description edit; it doubles as documentation of intended trigger behaviour. No harness needed — pasting five prompts into a fresh session is enough — but the fixture makes the check repeatable and reviewable.

### 14.8 Revised phasing (supersedes §11)

- **Phase 1 (~1 day):** Installer with `--mode copy|link` (link default; copy for Codex), individual-entry prune, `.system/`-safe. Install the existing 14 as-is. Chain into `agent-skills-update.sh`. Add `11-Skills/README.md` cheat-sheet + `trigger-eval.md`. *Acceptance unchanged from §11 Phase 1.*
- **Phase 2 (~2 days):** Author the ~8 verb skills (description schema of 14.5, scope guard of 14.6, routing tables covering categories 00–07 — this absorbs old Phases 2–4). Existing 14 skills' descriptions get one added line pointing users at the verb layer; otherwise untouched.
- **Phase 3 (as needed):** Run trigger-eval, tune descriptions, decide whether any of the original 14 should be retired into pure routing-table entries.

Net effect: the same end state (natural-language prompt → correct workflow, no drag-drop) at ~3 days instead of ~8, with ~8 installed skills instead of ~32, and no router, no overlap CI, no rename debate.

### 14.9 Open Questions resolved by this addendum

- Q1 (rename vs alias): **moot** — the 14 become internal targets of verb-skill routing tables (14.3).
- Q2 (router priority): **moot** — router deleted; no priority mechanism exists (14.4).
- Q4 (Codex symlinks): **answered empirically** — Codex skills are real directories today; ship `--mode copy` for Codex in Phase 1 (14.2).
- Q6 (aliases field): **drop the field**; aliases live only in the README cheat-sheet (14.5).
