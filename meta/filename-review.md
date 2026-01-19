# Filename Review and Recommendations

## Current Structure

```
workflows/
├── README.md
├── PARALLEL_AGENTS_REVIEW.md
├── planning/
│   ├── implementation-plan.md
│   └── plan-review.md
├── review/
│   └── code-review.md
├── development/
│   └── builder.md
├── debug/
│   └── debug.md
├── documentation/
│   ├── sync-documentation.md
│   └── documentation-sync-summary.md
└── reference/
    └── severity-priority-rubric.md
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
- Could benefit from a `meta/` or `reviews/` subdirectory for analysis documents

## Recommendations

### Option A: Minimal Changes (Recommended)
Keep current structure but improve clarity of ambiguous names.

**Changes:**
1. `builder.md` → `execution.md` or `development-workflow.md` (Note: `implementation.md` conflicts with `planning/implementation-plan.md`)
2. `debug.md` → `debug-workflow.md` or `bug-fix-workflow.md`
3. `documentation-sync-summary.md` → `sync-summary-template.md` or `documentation-sync-template.md`
4. `PARALLEL_AGENTS_REVIEW.md` → `parallel-agents-review.md` (move to `meta/` or keep at root)

**Rationale:** Minimal disruption, improves clarity without major restructuring.

### Option B: Consistent Prefix Pattern
Add `workflow-` prefix to all workflow instruction files for clear identification.

**Changes:**
1. `implementation-plan.md` → `workflow-implementation-plan.md`
2. `plan-review.md` → `workflow-plan-review.md`
3. `code-review.md` → `workflow-code-review.md`
4. `builder.md` → `workflow-development.md`
5. `debug.md` → `workflow-debug.md`
6. `sync-documentation.md` → `workflow-sync-documentation.md`

**Rationale:** Makes it immediately clear which files are workflow instructions vs. supporting docs.

### Option C: Reorganize with Meta Directory
Create a `meta/` subdirectory for analysis and review documents.

**New Structure:**
```
workflows/
├── README.md
├── meta/
│   └── parallel-agents-review.md
├── planning/
│   ├── implementation-plan.md
│   └── plan-review.md
├── review/
│   └── code-review.md
├── development/
│   └── execution.md (renamed from builder.md)
├── debug/
│   └── bug-fix-workflow.md (renamed from debug.md)
├── documentation/
│   ├── sync-documentation.md
│   └── sync-summary-template.md (renamed)
└── reference/
    └── severity-priority-rubric.md
```

**Rationale:** Better organization, separates workflow instructions from analysis documents.

## Detailed Recommendations

### High Priority (Clarity Issues)

#### 1. `builder.md` → `execution.md`
**Current:** `development/builder.md`
**Proposed:** `development/execution.md`
**Reason:** 
- "Builder" is ambiguous and doesn't clearly indicate it's a development workflow
- "Execution" clearly describes executing/implementing the plan (distinct from `planning/implementation-plan.md` which is for planning)
- Creates clear distinction: planning phase vs. execution phase
- Alternative: `development-workflow.md` if you prefer more explicit naming

#### 2. `debug.md` → `bug-fix-workflow.md` or `debug-workflow.md`
**Current:** `debug/debug.md`
**Proposed:** `debug/bug-fix-workflow.md` or `debug/debug-workflow.md`
**Reason:**
- "debug.md" is too generic and could refer to many things
- Adding "workflow" or "bug-fix" makes the purpose clear
- When viewed in isolation, the name is self-explanatory

#### 3. `documentation-sync-summary.md` → `sync-summary-template.md`
**Current:** `documentation/documentation-sync-summary.md`
**Proposed:** `documentation/sync-summary-template.md`
**Reason:**
- "documentation-sync-summary" is redundant (it's already in the documentation folder)
- Adding "template" clarifies it's a template, not an instruction
- Shorter and clearer

### Medium Priority (Consistency)

#### 4. `PARALLEL_AGENTS_REVIEW.md` → `parallel-agents-review.md`
**Current:** `workflows/PARALLEL_AGENTS_REVIEW.md`
**Proposed:** `workflows/parallel-agents-review.md` or `workflows/meta/parallel-agents-review.md`
**Reason:**
- Inconsistent ALL_CAPS naming breaks convention
- Should match kebab-case used by other files
- Consider moving to `meta/` subdirectory if creating one

### Low Priority (Nice to Have)

#### 5. Consider adding `workflow-` prefix (Optional)
If you want to make workflow instructions immediately identifiable:
- `implementation-plan.md` → `workflow-implementation-plan.md`
- `code-review.md` → `workflow-code-review.md`
- etc.

**Trade-off:** More verbose but more explicit. Only recommended if you plan to add many non-workflow files to these directories.

## Recommended Final Structure (Option A + Meta Directory)

```
workflows/
├── README.md
├── meta/
│   └── parallel-agents-review.md
├── planning/
│   ├── implementation-plan.md
│   └── plan-review.md
├── review/
│   └── code-review.md
├── development/
│   └── execution.md
├── debug/
│   └── bug-fix-workflow.md
├── documentation/
│   ├── sync-documentation.md
│   └── sync-summary-template.md
└── reference/
    └── severity-priority-rubric.md
```

## Naming Convention Guidelines

Based on this review, here are recommended naming conventions:

1. **Workflow Instructions:** Use descriptive kebab-case
   - ✅ `implementation-plan.md` (planning phase)
   - ✅ `execution.md` (execution phase - distinct from planning)
   - ✅ `code-review.md`
   - ✅ `bug-fix-workflow.md`
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

- [ ] Rename `builder.md` → `execution.md`
- [ ] Rename `debug.md` → `bug-fix-workflow.md`
- [ ] Rename `documentation-sync-summary.md` → `sync-summary-template.md`
- [ ] Rename `PARALLEL_AGENTS_REVIEW.md` → `parallel-agents-review.md`
- [ ] Create `meta/` directory (optional)
- [ ] Move review documents to `meta/` (optional)
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
1. `builder.md` → `execution.md` (High - clarity, avoids conflict with `implementation-plan.md`)
2. `debug.md` → `bug-fix-workflow.md` (High - clarity)
3. `documentation-sync-summary.md` → `sync-summary-template.md` (Medium - clarity)
4. `PARALLEL_AGENTS_REVIEW.md` → `parallel-agents-review.md` (Medium - consistency)

**Optional Improvements:**
- Create `meta/` subdirectory for review/analysis documents
- Consider `workflow-` prefix if adding many non-workflow files

These changes will make the workflow directory more navigable and self-documenting.
