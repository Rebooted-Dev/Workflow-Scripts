# Filename Review and Recommendations

Status: historical note. This document reflects an earlier snapshot of the workflows tree and may contain stale filenames/paths. Use it for naming principles, not as an authoritative map of the current directory structure.

## Current Structure

```
workflows/
├── README.md
├── PARALLEL_AGENTS_REVIEW.md
├── 00-initial-setup/
│   └── 01-setup-project.md
├── 00-meta/
│   ├── severity-priority-rubric.md
│   ├── sync-summary-template.md
│   ├── parallel-agents-review.md
│   └── filename-review.md
├── 01-planning/
│   ├── 01-plan-review.md
│   └── 02-finalise-plan.md
├── 02-build-code/
│   ├── 01-execution.md
│   └── 02-confirm-execution.md
├── 03-debug/
│   ├── 01-bug-description.md
│   └── 02-bug-fix-workflow.md
├── 04-documentation/
│   └── sync-documentation.md
├── 05-review-audit/
│   └── 01-code-review.md
└── 06-security/
    ├── 01-security-review.md
    └── 02-security-fix.md
```

## Issues Identified

### 1. Inconsistent Naming Conventions
- Most workflow files use kebab-case: `implementation-plan.md`, `code-review.md`
- One file uses ALL_CAPS: `PARALLEL_AGENTS_REVIEW.md`
- Some files are too generic: `builder.md`, `debug.md`

### 2. Ambiguous Names
- `builder.md` - Doesn't clearly indicate it's a development/implementation workflow
- `debug.md` - Too generic; could be confused with debug logs or tools
- `documentation-sync-summary.md` - Unclear if it's a template, example, or instruction

### 3. Missing Context
- Files in subdirectories rely on directory context, but some names don't make sense standalone
- No clear distinction between workflow instructions and supporting documents

### 4. Organization
- `PARALLEL_AGENTS_REVIEW.md` is a review document but sits at root level
- Could benefit from a `00-meta/` or `05-review-audit/` subdirectory for analysis documents

## Recommendations

### Option A: Minimal Changes (Recommended)
Keep current structure but improve clarity of ambiguous names.

**Changes:**
1. `builder.md` → `execution.md` or `development-workflow.md` (Note: `implementation.md` conflicts with `01-planning/01-plan-review.md`)
2. `debug.md` → `debug-workflow.md` or `bug-fix-workflow.md`
3. `documentation-sync-summary.md` → `sync-summary-template.md` or `documentation-sync-template.md`
4. `PARALLEL_AGENTS_REVIEW.md` → `parallel-agents-review.md` (move to `00-meta/` or keep at root)

**Rationale:** Minimal disruption, improves clarity without major restructuring.

### Option B: Consistent Prefix Pattern
Add `workflow-` prefix to all workflow instruction files for clear identification.

**Changes:**
1. `01-plan-review.md` → `workflow-plan-review.md`
2. `02-finalise-plan.md` → `workflow-finalise-plan.md`
3. `03-code-review.md` → `workflow-code-review.md`
4. `01-execution.md` → `workflow-execution.md`
5. `02-bug-fix-workflow.md` → `workflow-bug-fix.md`
6. `sync-documentation.md` → `workflow-sync-documentation.md`

**Rationale:** Makes it immediately clear which files are workflow instructions vs. supporting docs.

### Option C: Reorganize with Meta Directory
Create a `00-meta/` subdirectory for analysis and review documents.

**New Structure:**
```
workflows/
├── README.md
├── 00-initial-setup/
│   └── 01-setup-project.md
├── 00-meta/
│   ├── severity-priority-rubric.md
│   ├── sync-summary-template.md
│   ├── parallel-agents-review.md
│   └── filename-review.md
├── 01-planning/
│   ├── 01-plan-review.md
│   └── 02-finalise-plan.md
├── 02-build-code/
│   ├── 01-execution.md
│   └── 02-confirm-execution.md
├── 03-debug/
│   ├── 01-bug-description.md
│   └── 02-bug-fix-workflow.md
├── 04-documentation/
│   └── sync-documentation.md
├── 05-review-audit/
│   └── 01-code-review.md
└── 06-security/
    ├── 01-security-review.md
    └── 02-security-fix.md
```

**Rationale:** Better organization, separates workflow instructions from analysis documents.

## Detailed Recommendations

### High Priority (Clarity Issues)

#### 1. `builder.md` → `execution.md`
**Current:** `02-build-code/01-execution.md` (already renamed)
**Proposed:** `02-build-code/01-execution.md`
**Reason:** 
- "Builder" is ambiguous and doesn't clearly indicate it's a development workflow
- "Execution" clearly describes executing/implementing the plan (distinct from `01-planning/01-plan-review.md` which is for planning)
- Creates clear distinction: planning phase vs. execution phase
- Alternative: `development-workflow.md` if you prefer more explicit naming

#### 2. `debug.md` → `bug-fix-workflow.md` or `debug-workflow.md`
**Current:** `03-debug/02-bug-fix-workflow.md` (already renamed)
**Proposed:** `03-debug/02-bug-fix-workflow.md`
**Reason:**
- "debug.md" is too generic and could refer to many things
- Adding "workflow" or "bug-fix" makes the purpose clear
- When viewed in isolation, the name is self-explanatory

#### 3. `documentation-sync-summary.md` → `sync-summary-template.md`
**Current:** `00-meta/sync-summary-template.md` (already moved)
**Proposed:** `00-meta/sync-summary-template.md` (moved to 00-meta/ as it's a template, not a workflow)
**Reason:**
- "documentation-sync-summary" is redundant (it's already in the documentation folder)
- Adding "template" clarifies it's a template, not an instruction
- Shorter and clearer

### Medium Priority (Consistency)

#### 4. `PARALLEL_AGENTS_REVIEW.md` → `parallel-agents-review.md`
**Current:** `00-meta/parallel-agents-review.md` (already renamed and moved)
**Proposed:** `00-meta/parallel-agents-review.md`
**Reason:**
- Inconsistent ALL_CAPS naming breaks convention
- Should match kebab-case used by other files
- Moved to `00-meta/` subdirectory for better organization

### Low Priority (Nice to Have)

#### 5. Consider adding `workflow-` prefix (Optional)
If you want to make workflow instructions immediately identifiable:
- `01-plan-review.md` → `workflow-plan-review.md`
- `03-code-review.md` → `workflow-code-review.md`
- etc.

**Trade-off:** More verbose but more explicit. Only recommended if you plan to add many non-workflow files to these directories.

## Recommended Final Structure (Option A + Meta Directory)

```
workflows/
├── README.md
├── 00-initial-setup/
│   └── 01-setup-project.md
├── 00-meta/
│   ├── severity-priority-rubric.md
│   ├── sync-summary-template.md
│   ├── parallel-agents-review.md
│   └── filename-review.md
├── 01-planning/
│   ├── 01-plan-review.md
│   └── 02-finalise-plan.md
├── 02-build-code/
│   ├── 01-execution.md
│   └── 02-confirm-execution.md
├── 03-debug/
│   ├── 01-bug-description.md
│   └── 02-bug-fix-workflow.md
├── 04-documentation/
│   └── sync-documentation.md
├── 05-review-audit/
│   └── 01-code-review.md
└── 06-security/
    ├── 01-security-review.md
    └── 02-security-fix.md
```

## Naming Convention Guidelines

Based on this review, here are recommended naming conventions:

1. **Workflow Instructions:** Use descriptive kebab-case with numeric prefixes for ordering
   - ✅ `01-plan-review.md` (planning phase)
   - ✅ `01-execution.md` (execution phase - distinct from planning)
   - ✅ `03-code-review.md`
   - ✅ `02-bug-fix-workflow.md`
   - ❌ `builder.md` (too generic)
   - ❌ `debug.md` (too generic)

2. **Templates:** Include "template" in the name
   - ✅ `sync-summary-template.md`
   - ❌ `documentation-sync-summary.md` (unclear if template)

3. **Reference Documents:** Use descriptive names
   - ✅ `severity-priority-rubric.md`
   - ✅ `parallel-agents-review.md`

4. **Consistency:**
   - Use kebab-case throughout (no ALL_CAPS)
   - Avoid redundancy with directory names
   - Make names self-explanatory when viewed in isolation

## Implementation Checklist

If implementing these changes:

- [x] Rename `builder.md` → `execution.md` (completed)
- [x] Rename `debug.md` → `bug-fix-workflow.md` (completed)
- [x] Rename `documentation-sync-summary.md` → `sync-summary-template.md` (completed)
- [x] Rename `PARALLEL_AGENTS_REVIEW.md` → `parallel-agents-review.md` (completed)
- [x] Create `00-meta/` directory (completed)
- [x] Move review documents to `00-meta/` (completed)
- [ ] Update all references in `README.md`
- [ ] Update any cross-references in workflow files
- [ ] Update documentation that references these files

## Impact Assessment

**Files that reference these names:**
- `README.md` - Contains examples and references to workflow files
- Workflow files may cross-reference each other
- Any external documentation or scripts

**Breaking Changes:**
- Any scripts or tools that reference these filenames will need updates
- Bookmarks or links to these files will break
- Git history will show renames (which is fine)

## Summary

**Priority Changes:**
1. `builder.md` → `execution.md` (High - clarity, avoids conflict with `01-plan-review.md`) ✅ Completed
2. `debug.md` → `bug-fix-workflow.md` (High - clarity) ✅ Completed
3. `documentation-sync-summary.md` → `sync-summary-template.md` (Medium - clarity) ✅ Completed
4. `PARALLEL_AGENTS_REVIEW.md` → `parallel-agents-review.md` (Medium - consistency) ✅ Completed

**Completed Improvements:**
- ✅ Created `00-meta/` subdirectory for review/analysis documents
- ✅ Reorganized with numeric prefixes for better ordering (00-initial-setup, 01-planning, 02-build-code, 03-debug, 04-documentation, 05-review-audit)

These changes will make the workflow directory more navigable and self-documenting.
