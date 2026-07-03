# Workflow-to-Skills Mapping Analysis Report

**Date:** 2026-02-28  
**Author:** Sisyphus (AI Orchestration Agent)  
**Scope:** Analysis of Workflow-Scripts directory for skill file compatibility

---

## Executive Summary

The Workflow-Scripts directory contains **32 workflow markdown files** organized across **9 categories**. The existing `09-skills/` directory contains **broken symlinks** suggesting a previous, incomplete attempt to integrate skills. This report analyzes whether and how these workflows could map to skill files.

**Key Finding:** Most workflow files are **poor candidates** for conversion to skills because they describe *complete processes* rather than *domain-specific guidance*. However, certain workflow types could spawn useful skills, and the existing broken symlinks indicate a previously envisioned but unfinished approach.

---

## 1. Background: Skills vs. Workflows

### 1.1 What Are Skills?

Skills are markdown files with YAML frontmatter that provide:

```
skill-name/
├── SKILL.md              # Required – main instructions + frontmatter
├── reference.md          # Optional – detailed reference
├── examples.md           # Optional – usage examples
└── scripts/              # Optional – helper scripts
```

**Frontmatter requirements:**
- `name`: lowercase, hyphens, ≤64 chars
- `description`: ≤1024 chars, third-person, includes trigger terms

**Key characteristics:**
- Domain-specific expertise (e.g., "React best practices", "PDF handling", "security review")
- Focused on "how to do X" with trigger phrases for when to invoke
- Under ~500 lines; longer content in reference.md
- Used by AI agents to determine when to apply specialized knowledge

### 1.2 What Are Workflows?

Workflows are comprehensive process documents that provide:

- Multi-phase execution plans (Phase 1, 2, 3...)
- Step-by-step instructions with templates
- Parallel agent spawning guidance
- Priority/severity scoring (P0-P3, S0-S3)
- Output generation (plans/, docs/, troubleshooting/)
- Evidence requirements and verification steps

**Key characteristics:**
- Complete end-to-end processes ("implement feature", "fix bug", "security audit")
- Heavy use of templates and output formats
- Integration with other workflows
- Designed for AI agent execution with human oversight

---

## 2. Current Workflow-Scripts Inventory

### 2.1 File Count by Category

| Category | Directory | Files | Description |
|----------|-----------|-------|-------------|
| Meta | `00-meta/` | 6 | Templates, rubrics, analysis documents |
| Orchestrator | `00-orchestrator/` | 3 | Non-interactive plan review automation |
| Project Setup | `00-project-setup/` | 7 | New project setup, MCP/skills configuration |
| Planning | `01-planning-and-organizing/` | 4 | Research, plan creation, review |
| Build/Code | `02-build-code/` | 5 | Implementation execution, confirmation |
| Debug | `03-debug/` | 3 | Bug description, bug fix workflow |
| Documentation | `04-documentation/` | 7 | Doc creation, sync, templates |
| Review/Audit | `05-review-audit/` | 4 | Code review, optimization, refactoring |
| Security | `06-security/` | 3 | Security review, security fix |
| Deployment | `07-deployment/` | 10+ | Various deployment guides |
| API Integration | `08-API-Integration/` | 5+ | API integration guides |
| Skills | `09-skills/` | 4 (broken symlinks) | Intended skill integrations |

**Total: ~32+ workflow files**

### 2.2 Existing 09-skills Directory

The `09-skills/` directory contains broken symlinks:

```
09-skills/
├── vercel-composition-patterns -> ../.agents/skills/vercel-composition-patterns
├── vercel-react-best-practices -> ../.agents/skills/vercel-react-best-practices
├── vercel-react-native-skills -> ../.agents/skills/vercel-react-native-skills
└── web-design-guidelines -> ../.agents/skills/web-design-guidelines
```

**Status:** All symlinks are broken — target `.agents/skills/` directory does not exist.

---

## 3. Mapping Analysis: Workflow Types to Skills

### 3.1 Categories of Workflow Files

I classify the 32 workflow files into three categories for skill conversion viability:

| Category | Count | Description | Skill Viability |
|----------|-------|-------------|-----------------|
| **Process Workflows** | ~25 | Complete end-to-end processes (plan, execute, review) | LOW |
| **Guidance Workflows** | ~5 | Domain-specific guidance (setup, config) | MEDIUM |
| **Reference Documents** | ~6 | Rubrics, templates, analysis | NONE |

### 3.2 Detailed Assessment

#### Process Workflows (LOW Skill Viability)

These workflows describe complete processes that span multiple phases, involve multiple agents, and produce specific outputs. They are poor skill candidates because:

1. **Too complex** — Skills should be focused, under 500 lines
2. **Not domain-specific** — They apply to any feature/bug/refactor
3. **Already work well** — Current workflow format is appropriate

**Examples:**
- `01-planning-and-organizing/00-research-and-plan.md` — 341 lines, 3 phases, research → plan → output
- `02-build-code/01-execution.md` — Implementation with verification
- `03-debug/02-bug-fix-workflow.md` — 8-step bug fix process
- `05-review-audit/01-code-review.md` — Parallel agent scanning with finding templates
- `06-security/01-security-review.md` — 6-agent security scan

**Verdict:** Keep as workflows. Do NOT convert to skills.

#### Guidance Workflows (MEDIUM Skill Viability)

These workflows provide domain-specific guidance that could work as skills, but are currently too long or complex. They could be split into smaller skills.

**Examples:**
- `00-project-setup/06-skills-setup.md` — 301 lines about setting up skills
  - Could spawn: `skill-setup`, `cursor-skills`, `codex-skills`
- `00-project-setup/05-mcp-and-config-setup.md` — MCP configuration
  - Could spawn: `mcp-setup`, `google-developer-knowledge-mcp`
- `04-documentation/02-sync-documentation.md` — Documentation sync process
  - Could spawn: `doc-sync` (though this is quite specific to this project)

**Verdict:** Could be refactored into skills, but currently serve their purpose as workflows.

#### Reference Documents (NO Skill Viability)

These are meta-documents, templates, and rubrics — not actionable workflows.

**Examples:**
- `00-meta/severity-priority-rubric.md` — Scoring standard (referenced by workflows)
- `00-meta/sync-summary-template.md` — Template for sync documentation
- `00-meta/parallel-agents-review.md` — Historical analysis

**Verdict:** Keep as reference documents, not skills.

---

## 4. Gap Analysis: What Skills Are Missing?

### 4.1 Current Skill Coverage (from AGENTS.md)

The project currently has these skills loaded:
- `vercel-react-native-skills` — React Native/Expo
- `web-design-guidelines` — Web Interface Guidelines
- `vercel-react-best-practices` — React/Next.js performance
- `vercel-composition-patterns` — React composition patterns

### 4.2 Potential Skills from Workflows

Based on the workflow content, these domain-specific skills could be extracted:

| Potential Skill | Source Workflow(s) | Rationale |
|-----------------|-------------------|-----------|
| `commit-style` | Referenced in workflows | Consistent commit message format |
| `changelog-workflow` | `04-documentation/` | Changelog entry creation |
| `troubleshooting-entry` | `03-debug/` | Troubleshooting log format |
| `plan-review` | `01-planning-and-organizing/01-plan-review.md` | Plan validation |
| `code-review-process` | `05-review-audit/01-code-review.md` | Structured review |

### 4.3 Observations

1. **The existing skills** (`vercel-react-*`, `web-design-guidelines`) are external/domain-specific
2. **The workflows** are internal process documents
3. **There's minimal overlap** — skills cover what the AI should know; workflows cover what the AI should do

---

## 5. The Broken Symlinks Mystery

### 5.1 What Was Intended

The `09-skills/` directory with symlinks suggests someone intended to:
1. Create skill files for common workflows
2. Place them in `.agents/skills/` (external to Workflow-Scripts)
3. Reference them from the workflows directory

### 5.2 Why They Failed

1. **Target directory doesn't exist:** `.agents/skills/` was never created
2. **No skill files exist:** The actual skill files from AGENTS.md are managed by OpenCode, not local markdown
3. **Conceptual mismatch:** The workflow-to-skill mapping was likely attempted but abandoned

### 5.3 Recommendation

**Option A: Remove the broken directory**
- Delete `09-skills/` entirely
- Document that skills and workflows serve different purposes

**Option B: Create actual skill files**
- Create `.agents/skills/` directory (or appropriate location)
- Convert selected workflows to skills
- Update symlinks to point to correct locations

**Recommended: Option A** (see Section 6)

---

## 6. Recommendations

### 6.1 Do NOT Convert Most Workflows to Skills

**Reason:** The workflow files are well-designed for their purpose:
- Process-oriented, not domain-oriented
- Already appropriately scoped for complex tasks
- Integrate with each other and with output directories
- Include templates, phases, and verification steps

Converting them to skills would:
- Lose the multi-phase structure
- Make them too generic (skills expect domain specificity)
- Break existing workflow chains

### 6.2 Keep Skills and Workflows Separate

**Skills should provide:**
- Domain expertise (React, security, deployment)
- Trigger-based invocation ("use X when Y")
- Knowledge and patterns

**Workflows should provide:**
- Process execution (plan → implement → verify)
- Templates and output formats
- Integration with project systems

### 6.3 Clean Up Broken Symlinks

**Recommended action:**

```bash
# Remove broken 09-skills directory
rm -rf Workflow-Scripts/09-skills/
```

**Rationale:**
- Broken symlinks cause confusion
- No current benefit from the directory
- Skills are managed separately (via AGENTS.md + OpenCode)

### 6.4 Future: Extract Domain Skills If Needed

If specific domain skills are needed in the future (beyond what's in AGENTS.md):

1. Create skills in appropriate location (`~/.cursor/skills/` or project `.cursor/skills/`)
2. Keep workflows as-is for process execution
3. Reference skills from within workflows where appropriate

---

## 7. Conclusion

The Workflow-Scripts directory contains **excellent process workflows** that are appropriately designed for their purpose. The attempt to map them to skill files was misguided — skills and workflows serve fundamentally different purposes:

- **Skills** = Domain knowledge (what the AI should know)
- **Workflows** = Process execution (what the AI should do)

The existing broken symlinks in `09-skills/` should be removed. The workflows should remain as markdown files in their current form.

**Action Items:**
1. ✅ Analysis complete — this report
2. 🗑️ Remove broken `09-skills/` directory
3. ✅ Keep workflows as-is
4. ✅ Maintain skills via AGENTS.md + OpenCode

---

## Appendix A: File Inventory

### Process Workflows (Keep as-Is)

| File | Lines | Purpose |
|------|-------|---------|
| `01-planning-and-organizing/00-research-and-plan.md` | 341 | Research + create implementation plan |
| `01-planning-and-organizing/01-plan-review.md` | ~100 | Review implementation plans |
| `01-planning-and-organizing/02-finalise-plan.md` | ~120 | Consolidate into priority-ordered plan |
| `02-build-code/01-execution.md` | ~180 | Execute implementation phases |
| `02-build-code/02-confirm-execution.md` | ~130 | Verify implementation |
| `03-debug/02-bug-fix-workflow.md` | ~280 | Systematic bug fixing |
| `05-review-audit/01-code-review.md` | 183 | Code review with findings |
| `05-review-audit/02-code-optimization.md` | ~140 | Performance analysis |
| `05-review-audit/03-code-refactoring.md` | ~150 | Code quality analysis |
| `06-security/01-security-review.md` | ~160 | Security audit |
| `06-security/02-security-fix.md` | ~230 | Security vulnerability fix |

### Reference Documents (Keep as-Is)

| File | Purpose |
|------|---------|
| `00-meta/severity-priority-rubric.md` | Shared scoring standard |
| `00-meta/sync-summary-template.md` | Template for sync docs |
| `00-meta/parallel-agents-review.md` | Historical analysis |
| `00-meta/filename-review.md` | Historical analysis |
| `00-meta/agent-flexibility-review.md` | Historical analysis |

### Broken/To Be Removed

| File | Status |
|------|--------|
| `09-skills/` directory | Broken symlinks → Remove |

---

*End of Report*
