# Recommendations for improving GPT Astra instruction performance

**Date:** 2026-09-23  
**Status:** Research complete; recommendations proposed, not implemented or experimentally validated.  
**Scope:** Flash-UI-Idea-Generator `AGENTS.md`, all ten Markdown files in Workflow-Scripts `00-project-setup/`, and [Plan 05](../plans/v1.82-fixes/05-run-astra-instruction-evaluation.md). Includes a proposed workflow for upgrading pre-existing consumer projects.

## Recommendation

Keep the new `AGENTS.md` / `PROJECT.md` split. Prioritise removing contradictory instructions, making setup routes explicit, and making verification prove the intended outcome. Then test narrowly scoped autonomy, verification and delegation guidance. Simply shortening the root file is a lower-value target: the inspected host `AGENTS.md` is already 18 lines and 1,911 bytes.

The strongest candidates are:

1. Reconcile the incompatible changelog defaults and inconsistent relative-link rules in setup and migration.
2. Make fresh setup, existing-project refresh and migration separate routes with preservation checks.
3. Discover linked repositories and Git worktrees correctly before generating a repository map.
4. Replace broad “stop if confused” guidance with a rule that distinguishes consequential uncertainty from routine choices.
5. Calibrate verification and delegation to the task, with an explicit stopping condition.
6. Select MCP/skill/client scope before installation, and load large catalogs only when needed.
7. Deliver a dedicated scan, preview and apply workflow to migrate older instructions across selected existing projects, preserving local rules and recording unresolved cases.

These changes have plausible benefits for completion quality, fewer unnecessary questions, reduced retrieval and coordination, and less rework. No percentage speedup, token saving, or measured Astra improvement is established by this audit.

## Evidence and current state

**Local observation:** Both repositories returned “Already up to date” after the project-required `git pull --ff-only`. Flash-UI HEAD was `c97d1002c56294512d65d4c77c55c353cc7c733a`, with substantial pre-existing tracked and untracked changes. Its working-tree `AGENTS.md` and `PROJECT.md`, not HEAD alone, were inspected. Workflow-Scripts HEAD was `a86f3f83ed67b600f619460d8b08cf88adb8401a`, initially clean. The requested shared path resolves to `/Users/jesse/Development/Shared-Common-Library/Workflow-Scripts`.

[Source manifest](2026-09-23-astra-instruction-source-manifest.json) records SHA-256 hashes, byte counts and paths for the two host files, all ten setup files and Plan 05. The setup directory contains 266,537 bytes of Markdown. This is corpus size, **not** measured prompt tokens or proof that all files are loaded into every session. One independent reader examined setup files 02, 03, 05, 06 and 09; the primary author checked the passages used below. Workflow instructions were treated as audit subjects, not selected execution tasks.

**Astra fact:** OpenAI's current guide describes sensitivity to accessible instructions, a tendency to ask clarifying questions, possible under-delegation, and excessive verification for small tasks. It recommends auditing instruction files and calibrating autonomy, delegation and testing. These documented tendencies motivate hypotheses; they do not prove that a particular local rule caused a pause. [OpenAI GPT-6 guidance](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra), accessed 2026-09-23, “GPT-6 Astra behavior” and “Prompting best practices”.

**Harness-specific:** Codex discovers guidance through global and project instruction files, with more local guidance later in the chain and a documented default combined limit of 32 KiB. That limit is not a universal context limit or evidence that linked workflow files are automatically loaded. [Codex AGENTS documentation](https://learn.chatgpt.com/docs/agent-configuration/agents-md), accessed 2026-09-23, “How Codex discovers guidance”.

**Local observation:** The [September 22 audit](v1.82-fixes/2026-09-22-astra-setup-instruction-audit.md) predates the September 23 architecture change. Its description of inline versus canonical repository-map variants is historical. Current setup 01 and 04 require the canonical map in `PROJECT.md`. Its old line references should not be reused as current evidence. Its experiment safeguards remain useful.

**Evidence labels:** Findings below are `local observation`; proposed benefits are `hypothesis`. The two paragraphs above identify externally verified model and harness facts. This report contains no `experiment result`, runtime access claim, or full effective-instruction-stack audit.

## Prioritised findings and changes

Priority here means implementation order: P1 addresses contradictory or misleading instructions; P2 improves task routing and efficiency. It is not a measured model-performance ranking.

### R1 — P1: establish one changelog and path contract

**Local observation.** [01 setup](../../00-project-setup/01-setup-project.md), lines 557–566, requires `project/changelog/` and prohibits a single changelog file. Lines 658–675 say a single file is the default and folders are optional. Lines 679 onward then require folders again. An agent cannot follow all three defaults literally.

The same file's centralized-layout guidance, lines 103–109, asks indexes to include the `project/` prefix, whereas lines 599–601 and 919–922 specify paths relative to the index directory. [07 migration](../../00-project-setup/07-migrate-project-structure.md), lines 498–503 and 540–552, turns `fixed/example.md` into a Markdown link to `project/changelog/fixed/example.md` inside `project/changelog/index.md`. That resolves beneath the index directory, not from the repository root.

**Recommendation.** Retain the host's chosen folder system. Remove or clearly isolate the legacy single-file alternative. Define Markdown links relative to their containing file, distinguish them from repository-root paths in prose/commands, and provide one correct example per index type. Normalise duplicated step numbers and repair the reference to absent Step 4.5 at 01:1295.

**Hypothesis / acceptance.** Fewer path guesses, clarification loops and repair passes. Static acceptance: no competing default; every generated index link resolves from its containing directory; existing rows survive migration. Do not reinterpret historical prose paths as broken Markdown links without checking their syntax.

### R2 — P1: make setup idempotent and preserve custom instructions

**Local observation.** 01:30–48 unconditionally redirects empty index templates over existing files in Quick Start. Its existing-project route at 129–159 explicitly forbids that. The route also says to replace the detailed conventions file at 143, while preservation elsewhere is general rather than a section-by-section merge rule. At 151 repo-map refresh is optional when topology changes; at 1043–1058 every-step execution of workflow 04 follows “setting up or updating”.

**Recommendation.** Put a three-way selector before executable commands: fresh setup, convention refresh, structural migration. Guard creates with absence checks; update managed sections without overwriting custom rules or index rows. Record where each existing rule is retained or moved. Make repo rediscovery depend on new setup, a topology change or evidence of an incomplete map. For the same inputs, a second run should produce no content changes. Preserve unrelated dirty work.

**Hypothesis / acceptance.** Less accidental scope expansion and rework. In an approved future fresh/existing generation suite, compare preserved content and score missing or overwritten rules as failures before consumption. These are proposed checks, not fixtures created by this audit.

### R3 — P1: discover repository boundaries accurately

**Local observation.** [04 repository mapping](../../00-project-setup/04-track-repos-and-agent-map.md), lines 31–69, uses `find . -name .git -type d`, then lines 86–92 make discovery the sole source of map entries. This omits `.git` files used by worktrees/submodules and does not traverse directory symlinks by default. The host's `Shared-Links` is a symlink and its Workflow-Scripts target is a separate repository. Host `PROJECT.md` lists two repositories; a `.git` directory also exists under `Flash-UI-Generator/dependencies/Rebooted-Core-Libraries`. This warrants classification as a dependency repository, not an automatic decision to expand writable scope.

01:187–212 also equates Git repositories with `.git` directories. Its generic template at 295–313 hard-codes multiple repositories before discovery.

**Recommendation.** Seed discovery from the existing map and explicitly relevant linked paths; validate candidates with Git's repository queries, including `.git` files. Resolve real paths and deduplicate shared targets. Classify primary, shared-workflow and dependency repositories, including ownership and allowed scope. Bound traversal; do not blindly follow every filesystem symlink. Generate single- or multi-repository language from evidence.

**Hypothesis / acceptance.** More reliable path choice and fewer repeated discovery attempts. Proposed checks cover a normal checkout, linked workflow checkout, worktree, dependency checkout and duplicate aliases. No instruction to pull, edit or publish every discovered dependency should be inferred from discovery alone.

### R4 — P1: make verification outcomes truthful

**Local observation.** 01:1071 treats absence from `git status` output as proof a directory is ignored; a clean tracked path can also be absent. Its verification block changes into the workflows directory at 1074, then subsequent relative checks target `project/`, which may be the wrong root if blocks share a shell. At 1139–1160 file existence, imports and a heading are checked, but preservation and actual map correctness are not.

07:145, 214, 254, 273 and 310 suppress copy errors with `|| true`; 365–384 checks structure before deletion without proving complete content transfer. At 447–453 separate `test` commands precede an unconditional success message. [02 optimisation](../../00-project-setup/02-optimize-workflow-scripts.md), lines 450–457, calls a grep of Markdown syntax a link check, though it only enumerates candidates for manual review.

**Recommendation.** Give each command block an explicit working directory. Use `git check-ignore` plus tracked-path checks for the ignore requirement, and resolve repository roots independently. Aggregate required check failures into a nonzero result. Before migration cleanup, compare the source/destination inventory and preserved content, then validate links and references. Report enumeration as enumeration. Keep optional checks distinct from required checks.

**Hypothesis / acceptance.** Better first-pass correctness and fewer investigations caused by misleading success. Do not reduce verification simply to lower tool counts; replace weak checks with checks that prove the requirement.

### R5 — P1: narrow ambiguity-based stopping and preserve the host constraint

**Local observation.** [08 coding discipline](../../00-project-setup/08-kaparthy-template.md), lines 22 and 34–36, directs the agent to ask when unsure, present alternatives whenever several exist, and stop if anything is confusing. This has no threshold for materiality or distinction between blocked and independent work. Its example Python fence is also unclosed at end of file.

The host's current `PROJECT.md:23` restricts UI code changes unless instructed by the developer. That is an intentional constraint, not evidence of unnecessary blocking. In the shared template, 01:626 still puts the same UI restriction into generic AGENTS content despite 01:255–263 assigning project constraints to `PROJECT.md`.

**Recommendation.** Preserve the host's UI rule. Make the shared UI restriction an explicit project-specific option rather than injecting it into every project. Replace the broad stop instruction with a materiality test: inspect local evidence, make routine reversible choices within authority, ask when missing information changes correctness, scope or permission, and continue independent authorised work. Fix the malformed fence when this template is edited. A user-over-skill sentence must still respect system, developer and tool authority.

**Hypothesis / acceptance.** Fewer avoidable pauses without weakening real constraints. A future comparison must include both an ordinary implementation choice that should proceed and a restricted action that must remain blocked. Attribute each pause to the exact effective rule and authority layer.

### R6 — P2: keep the slim root, add a small operational contract

**Local observation.** Host `AGENTS.md:7–9` already calibrates delegation and regression testing; it repeats verification of agent findings in two adjacent bullets. It links topical guides at 14–18 but does not state a general verification stopping rule. The [shared applicability contract](../../00-Meta-Workflow/00-meta/workflow-applicability.md), lines 27–33, already provides one. Host `docs/agents/development-workflow.md` lists `npm run test:run` but also describes manual UI verification as the current expectation without a change-type boundary.

**Recommendation.** Merge the duplicate verification clause. Add short guidance for reading relevant topical documents, continuing authorised work, and stopping optional testing once appropriate checks pass. In detailed guidance, distinguish documentation checks, meaningful bug regression tests, UI behaviour checks and broader integration checks. Preserve required checks and disclose those that cannot run. Avoid adding the complete Astra guide to every repository.

**Hypothesis / acceptance.** Less repeated reading and discretionary testing. Test both a small documentation edit and a real bug; success requires appropriate verification in each. File length alone is not an outcome metric. Linked safeguards must actually be discovered before affected work.

### R7 — P2: make delegation useful and bounded

**Local observation.** 02:87–103, 117–133 and 145–161 describe overlapping four-role passes for redundancy, contradictions and ambiguity. Current host guidance instead calls for independent scopes with material benefit; the shared applicability contract also disallows nested agent trees. These repeated recipes risk being treated as a staffing requirement.

**Recommendation.** Inventory once, assign independent files or topics, and let each reviewer record all finding types in one evidence table. Use a single writer and verify returned evidence. State that role examples are optional and constrained by available tools, session limits and task size. If delegation is unavailable, proceed directly unless independent review is an explicit acceptance requirement. Do not replace calibrated policy with universal fan-out or copy a generic nested-delegation example over the local limit.

**Hypothesis / acceptance.** Reduced duplicate reads and coordination while retaining independent scrutiny for broad work. Count parent and child time/tokens; check both useful parallel work and a trivial direct task. No cheaper subagent model or different effort should be silently introduced into the instruction comparison.

### R8 — P1: make sync preview non-mutating and sync scope explicit

**Local observation.** [03 sync](../../00-project-setup/03-sync-workflow-scripts.md), lines 319–337, promises a non-mutating dry-run but only wraps pull. The earlier script clones at 135, stashes at 165, and fetches/switches branch at 173–174. Line 646 recommends always using this preview first. This is a static defect in the documented construction; the script was not executed during this audit.

The host `PROJECT.md:16` and 01:313 say to pull every repository before starting work. Other setup workflows add another sync step. This audit honoured the host instruction. A future optimisation must explicitly revise it rather than silently skip it.

**Recommendation.** Guard every mutation behind execution mode, including clone, stash, checkout and fetch metadata writes. Resolve and deduplicate real repository paths before syncing shared aliases. For future policy review, define when freshness is required, reuse a successful sync within the task, and handle dirty/diverged/offline state explicitly. Keep fast-forward protection; do not auto-stash or change branch as an incidental response to a read-only request.

**Hypothesis / acceptance.** Less unnecessary network work and fewer state-related surprises. Preview acceptance must include unchanged worktree, index, HEAD, stash and relevant Git metadata. These are future implementation checks, not performed experiments.

### R9 — P2: select setup capabilities before loading catalogs or installing tools

**Local observation.** [05 MCP setup](../../00-project-setup/05-mcp-and-config-setup.md) supports narrow repairs, yet lines 101–103, 131–133 and 163–165 mark several unrelated servers as required/default. [06 skills](../../00-project-setup/06-skills-setup.md), lines 141–165, says installation must be per tool with no shared installation path. [09 SEO](../../00-project-setup/09-seo-skill-setup.md), lines 31–35 and 52–55, documents a shared skill hub and symlinks. These are conflicting local descriptions; this audit does not certify today's external installer behaviour.

06:192–224 describes an installer whose commands are explicitly conditional on future implementation, and its Top 20/250 catalogs precede operative setup instructions. 09:21 permits URL-only reports without Google sign-in; lines 43–44 start OAuth, while 93–98 add authenticated and all-client checks.

**Recommendation.** Start with selected capability, client, config scope and install/repair mode derived from the request. Label broad defaults as an optional workstation preset. Inspect advertised tools and existing skill sources, real paths and versions before choosing a native install, hub, plugin or copy. Put catalogs and installer proposals in linked reference documents; label proposed commands non-executable. Apply Google checks only to the selected authenticated route. An absent optional MCP/skill should lead to an equivalent authorised tool if available, not global provisioning.

**Hypothesis / acceptance.** Less irrelevant context, duplicate installation and unnecessary OAuth. Verify the selected capability and client load; do not count installed skill quantity as performance. Preserve package review, credential handling, backups and evidence limits already present.

### R10 — P1: provide a workflow for upgrading existing projects

**Local observation.** Updating the shared templates does not rewrite instruction files previously generated in consumer repositories. 01's existing-project refresh route and 07's structural migration route provide useful ingredients, but neither specifies a multi-directory instruction inventory, a per-project compatibility assessment, or a resumable upgrade across existing projects. Older root and nested agent files, copied guides, harness rules and links can therefore continue to direct agents after the shared source is corrected.

**Recommendation.** Add a dedicated Markdown workflow, proposed as `00-project-setup/10-update-existing-project-instructions.md`, and index it in the setup README. This filename is a proposed deliverable, not an existing executable workflow. Its purpose is to scan user-selected directories, identify instruction drift, and bring eligible projects to a specified instruction revision while preserving local behaviour and constraints. Building this workflow is part of the recommended remediation; running it across projects is a separately scoped operation.

**Hypothesis / acceptance.** The optimisations become available to existing projects as well as new ones, with less manual comparison and fewer inconsistent copies. Success requires preserved project-specific rules, correct instruction discovery and links, explicit unresolved cases, and an idempotent second run. Migrated-file counts alone do not demonstrate better Astra performance.

## Proposed workflow: update existing project instructions

### Entry points and scope

The workflow should support three modes: **scan** (inventory and findings), **preview** (concrete proposed diffs and validation plan), and **apply** (update the selected eligible projects and verify). Infer the requested mode from the user's instruction: an instruction to scan is not authority to update; an explicit instruction to update supplies authority for routine, reversible migration within its stated scope. Do not add repeated confirmation prompts for already-authorised work. Where a decision is genuinely needed, prepare the affected diff and explain the exact conflict first.

Inputs should include directory roots or an explicit project list, exclusions, the target Workflow-Scripts revision, mode, and any project-specific exceptions. Resolve the latest approved canonical revision once at the start if the user asks for “current”; record its commit and content hashes, and use that same target for the entire batch. Do not upgrade against a moving checkout or assume the current templates already incorporate R1–R9. Reconcile the canonical sources first, then use that revision as the migration target.

### Phase 1 — discover projects and instruction sources

1. Enumerate projects within the supplied directory boundaries. Recognise normal repositories, Git worktrees/submodules with `.git` files, and explicitly selected non-Git projects. Exclude caches, build output, package/vendor trees and archives by default; record exclusions and scan failures. A nested directory with instructions may be a scope within a project rather than a separate project.
2. Resolve explicitly relevant symlinks, deduplicate by real path, and record aliases. Do not traverse outside the selected roots merely because a link exists. Identify shared Workflow-Scripts checkouts and dependency repositories as separate owners. A shared target should be inspected once, with its affected consumers listed, and changed only when that target is in the authorised scope.
3. Inventory root and nested `AGENTS.md`, `AGENTS.override.md`, legacy case variants such as `agents.md`, `PROJECT.md`, `CLAUDE.md`, `GEMINI.md`, referenced `docs/agents/` files, and relevant local harness rules such as Cursor rule files. Use the detected/configured harness to identify additional instruction filenames and imports rather than assuming every Markdown file is active guidance. Preserve nested scope and override precedence; do not flatten everything into the root.
4. Record file paths, hashes, Git owner, dirty/untracked state, links/imports, declared versions if any, and actual loading evidence where observable. Trace relevant references within scope. Report global, external, plugin-managed or inaccessible sources as dependencies; do not silently edit user-global rules, package-managed skills or external configuration. Avoid copying credentials or unrelated private content into the inventory.

### Phase 2 — assess drift and prepare a project-specific migration

Classify each project as **current**, **update-ready**, **needs decision**, **blocked**, or **excluded**, with evidence and reason. Missing version markers mean “inspect content”, not “replace everything”. Compare actual rules, paths and templates to the target; a filename or modification date alone cannot establish currency.

Build a preservation map for each affected project:

| Existing content | Migration action |
| --- | --- |
| Shared rule matching a known older template | Replace with the target rule; record source and destination |
| Project facts, commands and repository ownership | Verify against the project, then retain in PROJECT.md or its linked detailed guide |
| Project-specific constraints and exceptions | Preserve meaning and scope; surface conflicts with the target for a decision |
| Harness-specific instructions | Retain in the relevant harness file; update supported imports/pointers |
| Nested rules or overrides | Retain their scope and priority; merge only their applicable shared portions |
| Duplicate text | Remove a copy only after verifying an equivalent authoritative destination and a working discovery path |
| Unknown/custom prose | Preserve by default; do not discard it to match the template |
| Broken reference or missing canonical file | Repair from verified local evidence, or record the unresolved dependency |

For known source versions, use a three-way comparison of the old template, local file and new template where available. Otherwise compare sections and meanings explicitly; do not perform a blind whole-file replacement. Detect case collisions before renaming files, especially on case-insensitive filesystems. Preserve the chosen metadata layout, historical entries, indexes, active plans and unrelated content. Instruction refresh must not silently become structural migration, application refactoring, package installation or model-provider reconfiguration.

The preview should list changed files, the reason for each change, preserved exceptions, unresolved conflicts and expected checks. Discover commands from the project; never inject JavaScript commands into another stack. Show proposed cross-repository changes under their actual repository owners.

### Phase 3 — apply the authorised migration

Capture preimages and hashes of affected files, including untracked instruction files, in a task-specific recovery location. Record which files will be created or moved. Recheck hashes immediately before writes; if content changed since preview, rescan that project instead of overwriting concurrent work. Avoid automatic stash, reset, branch switching or broad staging. Reuse successful repository freshness checks within the run and follow each project's applicable sync policy.

Apply the smallest section-aware changes per project. Treat related files as one migration unit: update destinations and pointers, verify preserved content, then remove superseded copies. If a project fails, leave it explicitly incomplete, recover only this run's changes when safe, and continue independent eligible projects. Do not commit or push as an incidental consequence of migration.

Record per-project progress so interruption can resume from verified state. A resume must recheck current hashes and the target revision rather than trusting a stale completion marker. Rollback restores only files owned by this migration, and only if their current content matches the recorded postimage; later user changes require reconciliation, not unconditional restoration.

### Phase 4 — verify and report

- Verify every original custom rule is retained or has an explicitly resolved disposition, with scope and authority preserved.
- Validate links and anchors from the file that contains them, repository mappings against actual roots, and harness pointers/imports against supported loading behaviour. Text presence alone is not proof a harness loaded it; mark loading unverified when it cannot be observed.
- Confirm expected files changed and unrelated dirty work, index rows, historical content and global sources remained intact. Check for unresolved placeholders, duplicate competing rules and stale active references.
- Repeat scan/preview against the same target. An already migrated project should propose no further content change. Store timestamps in the run record rather than rewriting agent files on every run.
- Run documentation checks appropriate to the migration. Broader application checks are justified only when changed instructions affect executable configuration or commands, or a project requires them. Report blocked checks without claiming full verification.

Use final statuses **unchanged/current**, **updated/verified**, **updated/verification-blocked**, **needs decision**, **failed/rolled back**, and **excluded**. Produce one batch summary linking per-project records, with target revision, changes, retained exceptions, evidence, recovery location and remaining actions. “All selected projects updated” is valid only when every included project meets its acceptance criteria; partial progress must remain visible.

### Deliverables and rollout order

The implementation should deliver the Markdown workflow, a setup README route, reciprocal links from 01's refresh route, 04's discovery workflow and 07's structural migration workflow, plus a migration-record template. Prefer a short entry workflow with linked templates; if repeated scanning warrants a helper script, specify its contract separately and require it to exist before documenting runnable commands.

First reconcile the canonical instructions, then implement and review this workflow. Validate it against representative legacy layouts before a bounded consumer rollout: old monolithic AGENTS, missing PROJECT, customised harness files, nested overrides, alternate metadata paths, shared symlinks, worktrees, dirty files and interrupted/resumed migration. Include a second-run no-change check and recovery check. Expand to the remaining explicitly selected projects after reviewing the initial rollout evidence.

These migration checks establish upgrade correctness. Any model-driven fixtures or Astra comparison remain subject to Plan 05's existing protocol, isolation, supplement and budget gates. R10 does not select an evaluation arm or authorise fleet-wide changes through this research report. The present request adds this workflow requirement to the recommendations; no consumer directories have been scanned or migrated in this revision.

## Proposed short wording for a later instruction change

These are candidate clauses for review, not instructions taking effect through this report. Integrate them into existing sections rather than appending another competing policy block.

> Read PROJECT.md and the topical guidance relevant to the requested work. Follow the selected workflow's applicable route. Preserve existing project-specific rules and unrelated content when updating instructions.
>
> Complete authorised work using available evidence and reasonable reversible choices. Ask when missing information materially affects correctness, scope or authority; continue independent work while awaiting the answer. When an instruction blocks progress, identify its source, the exact rule and the affected action.
>
> Run checks appropriate to the changed surface and all required gates. Add a meaningful regression test for bugs when practical. Once checks pass, broaden or repeat them only for a new change, failure or unresolved risk. Report blocked required checks accurately.
>
> Delegate independent scopes when coordination cost is justified, within the runtime's limits. Keep dependent work sequential, give each shared artifact one writer, and verify delegated findings before acting.

Keep project constraints, changelog obligations, secret handling, repository boundaries and publication authority intact. The root should point to detailed conventions; it should not duplicate their templates or hide critical constraints in an optional reference.

## How this fits Plan 05

Plan 05 remains **Active — blocked pending protocol recovery and an explicit comparison-arm decision**. The original protocol is absent from the current research tree, and [Plan 01](../plans/v1.82-fixes/01-reconcile-research-and-source-integrity.md) still records recovery as pending. This audit does not recover or reconstruct it. No fixtures, model-driven setup, pilot, access probe or benchmark were run.

1. **Refresh audit inputs before freezing them.** Plan 05's source notes and the September 22 audit describe pre-September-23 setup. Inventory current `PROJECT.md` alongside AGENTS, harness imports, linked guides and selected skills. Check actual loading rather than assuming a link or import was consumed. Preserve the earlier audit as dated provenance.
2. **Prefer the current-v1.82 comparison for this question, subject to written selection.** The historical pair measures historical changes and cannot isolate today's PROJECT split or these proposals. This recommendation does not select an arm or approve revisions.
3. **Define a coherent instruction delta.** Start with R1–R5 correctness and scope repairs as a candidate package if approved. Such a comparison establishes a package effect; it cannot attribute a speedup to each clause. Consider R6–R9 as separately registered follow-up changes if the first comparison justifies further spend. R10 supplies the consumer migration route; evaluate its generated/migrated outputs separately from canonical-source edits, under an approved supplement when model-driven evaluation is involved. Do not vary reasoning effort, subagent models, cache policy or harness at the same time.
4. **Use the existing supplemental coverage, without a combinatorial expansion.** Map proposed checks to Plan 05's current-arm generation/consumption and behaviour cases. New setup, custom-rule preservation, repository discovery, meaningful versus excessive testing, useful versus wasteful delegation, unavailable tools, non-JavaScript command discovery and authority conflicts already have routes there. Any extra case or changed criterion needs supplement approval before execution. Historical-arm tasks remain unchanged.
5. **Keep generation and consumption separate.** Score setup output, missing rules, links and scope before a fresh session consumes it. Do not repair generated output before scoring. Record both setup cost and subsequent task cost so smaller root files do not hide extra retrieval.
6. **Retain the pilot and adoption gates.** Recover protocol authority; select one arm; freeze revisions, full effective stack, metrics, margins, isolation and budget; validate access only at its allowed stage; pilot before expansion. Apply quality non-inferiority with uncertainty bounds, critical safety gates and the preregistered minimum efficiency/blocking gain. Underpowered evidence is inconclusive. Required policy work is legitimate cost, not automatically waste.

Useful outcome measures are accepted task completion, incorrect path attempts, preserved custom rules, unwarranted versus necessary pauses, relevant-check coverage, repeat validation without new evidence, total parent/child/retrieval tokens, elapsed time and cost. Report task classes separately. A shorter file, fewer tool calls or zero observed failures does not establish maintained quality or universal safety.

## Review coverage and deliverable verification

| Inspected source | Main contribution |
| --- | --- |
| Host AGENTS.md and PROJECT.md | Existing slim split, delegation, logs, UI restriction, repository ownership and symlink |
| Setup README | Existing routing table; add missing 07 migration and 08 discipline entries and clarify why skills routing also points to MCP |
| 01 setup | Contradictions, preservation, placeholder handling, templates, routing and verification |
| 02 optimisation | Repeated role passes and distinction between link enumeration and validation |
| 03 sync | Preview contract and mutation paths |
| 04 repo map | Canonical PROJECT map and discovery blind spots |
| 05 MCP | Narrow repair versus broad default provisioning |
| 06 skills | Installation topology, reference bulk and future installer proposal |
| 07 migration | Copy/cleanup evidence and link-base inconsistency |
| 08 coding discipline | Overbroad pause wording and malformed example fence |
| 09 SEO | Selected client/layer and authentication applicability |
| Plan 05 and supporting audit/Plan 01 | Preserved authority, arm, isolation, preregistration and adoption boundaries |

A further targeted correction in 01:219–242 is to validate placeholders in the rendered command/artifact, not search the reusable source template for placeholders and forbid progress while any remain. The shared template is expected to contain placeholders. This is another candidate for R2's generated-artifact checks.

The filed report is accompanied by the original audit source manifest and documentation changelog entries. The R10 extension is a workflow design requirement, not evidence from a scan of other projects; the original manifest remains a record of the initial audit inputs. Validation checks local report links, source hashes, the changelog index row, whitespace and changed-file scope. No application build or test suite is needed for this research-only deliverable. No live instruction file or evaluation plan was changed, and no claim is made that Plan 05 is complete.
