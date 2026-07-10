# `wf validate` Warning Inventory

**Date:** 2026-07-10
**Scope:** Warning-only diagnostics emitted by `workflows-drag-free/tools/wf validate` after workflow contract and CLI remediation
**Initial result:** 77 frontmatter records validated, 24 warnings, exit code 0
**Resolution:** All 24 warnings eliminated by context-aware fenced-code handling; genuine prose links and inline contract paths remain validated.

## Executive summary

The 24 warnings do not identify broken active package links. They are produced because the lightweight Markdown-link check in `tools/wf` does not distinguish package documentation from content that a setup workflow tells an agent to generate inside a consumer project. It also scans fenced code as if it were ordinary Markdown.

- **20 consumer-project/template links:** valid in the generated project's root, but incorrectly resolved relative to the declaring workflow file.
- **2 illustrative migration-table links:** deliberately demonstrate old and new consumer-project index paths.
- **1 fenced-code parser artifact reported twice:** a grep pattern containing Markdown-link syntax causes the regular expression to consume text across the code fence, producing two malformed warning targets.
- **0 confirmed broken active package links.** `scripts/validation/check-active-markdown-links.sh` passes.

## Detailed inventory

### 1. `00-setup/01-setup-project.md` — 19 warnings

These links occur inside AGENTS/documentation content that the setup workflow instructs an agent to create in the **consumer project**. Their intended resolution base is that generated project's root, not `workflows-drag-free/00-setup/`.

| Warning target | Count | Source lines | Intended target |
|---|---:|---|---|
| `docs/agents/changelog-and-troubleshooting.md` | 3 | 676, 1060, 1102 | Consumer project documentation |
| `docs/agents/project-structure.md` | 4 | 1065, 1072, 1107, 1114 | Consumer project documentation |
| `docs/agents/development-workflow.md` | 2 | 1073, 1115 | Consumer project documentation |
| `docs/agents/coding-standards.md` | 2 | 1074, 1116 | Consumer project documentation |
| `docs/agents/testing-strategy.md` | 2 | 1075, 1117 | Consumer project documentation |
| `docs/agents/commit-workflow.md` | 2 | 1076, 1118 | Consumer project documentation |
| `docs/agents/documentation-workflow.md` | 2 | 1077, 1119 | Consumer project documentation |
| `docs/agents/security-guidelines.md` | 2 | 1078, 1120 | Consumer project documentation |

**Classification:** false positive caused by resolution-base ambiguity.
**Recommended treatment:** teach validation to exclude fenced/template output or allow a declared consumer-project resolution context. Do not rewrite these links to package-relative paths; that would make the generated consumer documentation incorrect.

### 2. `00-setup/04-track-repos-and-agent-map.md` — 1 warning

- **Line 138:** link label `Repository Map`, target `docs/agents/repository-map.md`.
- The link is part of the repository-map/agent-map material produced in a consumer project.
- `tools/wf` incorrectly tests it as `workflows-drag-free/00-setup/docs/agents/repository-map.md`.

**Classification:** false positive caused by consumer-project template content.
**Recommended treatment:** same template-context handling as the setup-project warnings.

### 3. `00-setup/07-migrate-project-structure.md` — 2 warnings

- **Line 560:** link label `Link`, target `fixed/2026-01-01-bug.md`, demonstrates a changelog row before path migration.
- **Line 563:** link label `Link`, target `project/changelog/fixed/2026-01-01-bug.md`, demonstrates the corresponding row after migration.

These are illustrative paths in a before/after migration example. They are not claims that either example file exists in the workflow package.

**Classification:** expected example links, not active dependencies.
**Recommended treatment:** ignore fenced/example blocks or annotate examples so the validator can distinguish them from active links.

### 4. `00-setup/02-optimize-workflow-scripts.md` — 2 warnings from one parser artifact

The warning targets begin with:

- `" <target-directory> --include="*.md" ...`
- `" <target-directory> ...`

The source is the fenced shell example at **line 36**:

```bash
grep -r "\[.*\](" <target-directory> --include="*.md"
```

The regular expression used by `tools/wf` sees the literal `](` inside the grep pattern as the start of a Markdown link and consumes subsequent text across newlines until it finds `)`. Later fenced examples cause the second malformed match. The very large warning body is therefore parser output, not a filesystem path.

**Classification:** false positive caused by parsing fenced code with a regular expression designed for prose links.
**Recommended treatment:** strip fenced code blocks before calling `markdown_links()`, or use a Markdown parser that exposes actual link nodes.

## Risk assessment

| Question | Assessment |
|---|---|
| Do these warnings weaken the new ID/dependency/graph validation? | No. Those checks pass independently. |
| Is an active package-relative Markdown link confirmed broken? | No. |
| Did redirect integrity regress? | No; all 146 redirect targets pass. |
| Can the warnings hide future real issues? | Yes. Repeated false positives create noise and the multi-line parser artifact makes diagnostics difficult to read. |
| Suggested priority | P2 validator-quality improvement; not a blocker for the completed remediation. |

## Reproduction

From the `Workflow-Scripts` repository root:

```bash
workflows-drag-free/tools/wf validate 2>&1
workflows-drag-free/tools/wf validate 2>&1 \
  | sed -n 's/^warning: //p' \
  | sort \
  | uniq -c
scripts/validation/check-active-markdown-links.sh
```

Observed on 2026-07-10:

- `Validated 77 frontmatter records with 24 warnings`
- `Active markdown links OK`

## Resolution (2026-07-10)

The follow-up was implemented without changing workflow/template examples or adding per-link exceptions:

1. Both validators now strip only well-formed matched backtick or tilde fences, including variable-length fences.
2. Unterminated fences retain the original document so malformed Markdown cannot hide links.
3. Regression fixtures preserve warning-only genuine links in `wf validate` and failure behavior for active prose links, inline contract paths, and retired tokens.
4. Live validation reports zero warnings; no multiline parser diagnostic remains.

This resolves the inventory while leaving workflow graph and runtime contracts unchanged.
