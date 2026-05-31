# Workflow: Website Data Refactoring

## Purpose

Perform a structured analysis to identify data organization issues, design a cleaner data architecture, and create a migration plan for website content/data files. This workflow transforms scattered, untyped, or poorly organized website data into a maintainable, type-safe, single-source-of-truth structure.

## When to Use

- Website data is scattered across multiple files or components
- Content is hardcoded in components rather than centralized
- Data lacks TypeScript types or proper interfaces
- Content updates require editing multiple files
- Data structure has grown organically and become unwieldy
- Preparing for content management system (CMS) integration
- Need to support multiple languages or regions
- Data needs to be shared across different pages or components

## Inputs

- Repository root
- Target scope (e.g., `src/data/`, `src/content/`, specific directories)
- Existing data files or hardcoded content locations
- Website requirements (pages, features, content types)

## Prioritization Rule

- Score each finding with severity (S0–S3) and priority (P0–P3)
- Present findings ordered by priority (P0 to P3), then severity within each priority
- Data refactoring typically maps to S2/S3 severity and P2/P3 priority
- Use the shared rubric: `../00-Meta-Workflow/00-meta/severity-priority-rubric.md`

---

## Phase 1: Audit & Discovery

### Step 1.1: Inventory Current State

Scan the codebase using parallel agents to identify:

**Agent 1: Data File Scanner**
- Find all data/content files (JSON, TS/JS exports, markdown, YAML)
- Map file locations and their purposes
- Identify orphaned or duplicate data files

**Agent 2: Hardcoded Content Scanner**
- Search for hardcoded strings in components
- Identify inline content that should be externalized
- Find magic numbers, URLs, and configuration values

**Agent 3: Data Flow Analyzer**
- Trace where data is imported and consumed
- Map component dependencies on data files
- Identify tight coupling between components and data

**Agent 4: Type Coverage Analyzer**
- Check TypeScript interface/type definitions
- Identify untyped or `any`-typed data structures
- Find missing or incomplete type definitions

**Agent 5: Pattern Detection (optional - spawn if codebase >20 components)**
- Identify common data access patterns
- Find data transformation logic in components
- Detect data normalization/denormalization issues

### Step 1.2: Document Current Architecture

Create a data architecture map documenting:

```
📁 Current Data Architecture
├── Data Sources
│   ├── src/data/config.ts (site configuration)
│   ├── src/data/content.ts (page content)
│   └── [other data files]
├── Data Types
│   ├── Typed: [list interfaces/types]
│   └── Untyped: [list untyped data]
├── Data Consumers
│   ├── Components: [list components using data]
│   └── Pages: [list pages using data]
└── Issues Identified
    ├── [Issue 1]
    ├── [Issue 2]
    └── [Issue 3]
```

---

## Phase 2: Design Target Architecture

### Step 2.1: Define Data Categories

Organize data into logical categories based on domain:

| Category | Examples | Typical Contents |
|----------|----------|------------------|
| **Identity** | Site name, brand, tagline | Organization info, branding |
| **Contact** | Phone, email, address | Contact methods, social links |
| **Navigation** | Menu items, footer links | Site structure, routing |
| **Content** | Hero text, about section | Page-specific content |
| **Services/Products** | Service list, pricing | Offerings catalog |
| **Media** | Images, videos, icons | Asset references |
| **Configuration** | Feature flags, settings | App configuration |
| **Localization** | Translations, locale data | i18n content |

### Step 2.2: Design Type System

Create TypeScript interfaces for all data structures:

```typescript
// Example: src/data/types.ts

// ----------------------------------------------------------------------------
// CORE IDENTITY TYPES
// ----------------------------------------------------------------------------

export interface Organization {
  name: string;
  tagline?: string;
  description?: string;
  founded?: string;
}

export interface Contact {
  phone?: ContactMethod;
  email?: string;
  address?: Address;
  social?: SocialLinks;
}

export interface ContactMethod {
  display: string;
  url: string;          // For href (tel:, mailto:, https:)
}

export interface Address {
  full: string;
  short?: string;
  coordinates?: { lat: number; lng: number };
}

// ----------------------------------------------------------------------------
// CONTENT TYPES
// ----------------------------------------------------------------------------

export interface HeroContent {
  headline: string;
  subheadline?: string;
  cta?: CTA;
  images?: MediaAsset[];
}

export interface FAQ {
  question: string;
  answer: string;
  category?: string;
}

export interface Service {
  id: string;
  title: string;
  description: string;
  icon?: string;
  details?: string[];
}

// Add more domain-specific types as needed
```

### Step 2.3: Design File Structure

Choose an organization strategy:

**Option A: Single Source File (Simple Sites)**
```
src/data/
├── site-data.ts        # All data in one file
├── types.ts            # Type definitions
└── index.ts            # Re-exports
```

**Option B: Categorical Files (Medium Sites)**
```
src/data/
├── identity.ts         # Organization, brand
├── contact.ts          # Contact info
├── content/            # Page-specific content
│   ├── home.ts
│   ├── about.ts
│   └── services.ts
├── navigation.ts       # Menu, links
├── media.ts            # Asset references
├── types.ts            # Type definitions
└── index.ts            # Re-exports
```

**Option C: Domain-Driven (Complex Sites)**
```
src/data/
├── core/               # Core domain
│   ├── organization.ts
│   └── contact.ts
├── content/            # Content domain
│   ├── pages/
│   └── components/
├── features/           # Feature-specific data
│   ├── booking.ts
│   └── faq.ts
├── types/              # Type definitions
│   ├── core.ts
│   ├── content.ts
│   └── index.ts
└── index.ts            # Public API
```

### Step 2.4: Design Export Strategy

Decide on export patterns:

```typescript
// Strategy 1: Named Category Exports (Recommended)
export const IDENTITY = { ... };
export const CONTACT = { ... };
export const SERVICES = { ... };

// Strategy 2: Namespace Exports
export const SiteData = {
  identity: { ... },
  contact: { ... },
  services: { ... },
};

// Strategy 3: Legacy Compatibility Layer
// New granular exports
export const IDENTITY = { ... };
export const CONTACT = { ... };

// Legacy aggregated export (deprecated)
/** @deprecated Use individual category exports */
export const SITE_DATA = {
  identity: IDENTITY,
  contact: CONTACT,
  // ...
};

// Default export for convenience
export default SITE_DATA;
```

---

## Phase 3: Migration Planning

### Step 3.1: Create Migration Roadmap

Order migration by priority:

| Phase | Scope | Priority | Risk |
|-------|-------|----------|------|
| **Phase 1** | Create types & structure | P0 | Low |
| **Phase 2** | Migrate core data (identity, contact) | P1 | Low |
| **Phase 3** | Migrate content data | P2 | Medium |
| **Phase 4** | Update component imports | P2 | Medium |
| **Phase 5** | Remove legacy patterns | P3 | Low |

### Step 3.2: Define Migration Steps Per Phase

**Phase 1: Foundation**
1. Create `src/data/types.ts` with all interfaces
2. Create `src/data/index.ts` as public API
3. Add JSDoc comments for documentation
4. Verify types compile without errors

**Phase 2: Core Data Migration**
1. Create categorical data files (e.g., `identity.ts`, `contact.ts`)
2. Move data from old locations to new files
3. Add type annotations (`as TypeName`)
4. Export from `index.ts`
5. Create legacy compatibility layer if needed

**Phase 3: Content Migration**
1. Extract hardcoded content from components
2. Create content data files
3. Add proper typing
4. Export from `index.ts`

**Phase 4: Component Updates**
1. Update component imports to use new data structure
2. Prefer granular imports over aggregated objects
3. Remove inline data transformations (move to utilities)
4. Verify components render correctly

**Phase 5: Cleanup**
1. Remove old data files
2. Remove legacy exports (if safe)
3. Update documentation
4. Run full test suite

### Step 3.3: Create Backwards Compatibility Strategy

If existing code depends on current data structure:

```typescript
// 1. Create new structure alongside old
export const NEW_CONTACT = {
  phone: { display: "...", url: "..." },
  // ...
};

// 2. Keep old export with deprecation notice
/**
 * @deprecated Use NEW_CONTACT instead.
 * Will be removed in version X.X.X
 */
export const OLD_CONTACT = {
  phone: "...",  // Legacy format
  // ...
};

// 3. Create migration guide comment
/*
 * MIGRATION GUIDE:
 * OLD: CONTACT.phone
 * NEW: CONTACT.phone.display
 */
```

---

## Phase 4: Implementation Checklist

### Pre-Implementation

- [ ] Audit complete with findings documented
- [ ] Target architecture designed and reviewed
- [ ] Type definitions created
- [ ] Migration roadmap approved
- [ ] Backwards compatibility strategy defined

### Implementation

- [ ] Phase 1: Foundation (types, structure)
  - [ ] Create types.ts
  - [ ] Create index.ts
  - [ ] Verify compilation
  
- [ ] Phase 2: Core Data Migration
  - [ ] Create categorical files
  - [ ] Migrate data with types
  - [ ] Create legacy layer
  - [ ] Verify exports
  
- [ ] Phase 3: Content Migration
  - [ ] Extract hardcoded content
  - [ ] Create content files
  - [ ] Add typing
  - [ ] Verify exports
  
- [ ] Phase 4: Component Updates
  - [ ] Update imports
  - [ ] Remove transformations
  - [ ] Verify rendering
  - [ ] Test all affected pages
  
- [ ] Phase 5: Cleanup
  - [ ] Remove old files
  - [ ] Remove legacy exports
  - [ ] Update documentation
  - [ ] Run full test suite

### Post-Implementation

- [ ] All TypeScript errors resolved
- [ ] All components render correctly
- [ ] No runtime errors in console
- [ ] Documentation updated
- [ ] Changelog entry created

---

## Phase 5: Verification & Validation

### Step 5.1: Type Safety Verification

```bash
# Run TypeScript compiler
npm run type-check  # or: tsc --noEmit

# Verify no 'any' types introduced
# Check for @ts-ignore or @ts-expect-error
```

### Step 5.2: Runtime Verification

1. Start development server
2. Visit all pages that use migrated data
3. Check browser console for errors
4. Verify all content displays correctly
5. Test all interactive elements (forms, links)

### Step 5.3: Build Verification

```bash
# Production build
npm run build

# Verify build succeeds
# Check bundle size hasn't increased significantly
```

### Step 5.4: Regression Testing

- [ ] All pages load without errors
- [ ] All content displays correctly
- [ ] All links work
- [ ] All forms submit
- [ ] All images load
- [ ] All translations work (if applicable)

---

## Output Requirements

### Refactoring Report

Save to `project/research/website-data-refactoring-YYMMDD-HHMM-{model}.md`:

```markdown
# Website Data Refactoring Report

**Date:** YYMMDD HHMM (24-hour format)
**Model:** {AI model name}
**Scope:** [directories/files analyzed]
**Status:** [Planning/In Progress/Complete]

## Executive Summary

[Brief overview of changes and benefits]

## Current State Analysis

### Data Files
[List existing data files and their purposes]

### Issues Identified
[P0-P3 prioritized list of issues]

## Target Architecture

### File Structure
[Planned file organization]

### Type System
[Key interfaces and their purposes]

### Export Strategy
[Chosen export pattern with rationale]

## Migration Plan

### Phase 1: Foundation
[Tasks, exit criteria, verification]

### Phase 2-N: [Phase Name]
[Tasks, exit criteria, verification]

## Backwards Compatibility

[Strategy for maintaining existing functionality]

## Verification Results

[Type check results, runtime tests, build status]

## Recommendations

[Future improvements, technical debt items]
```

---

## Best Practices

### Data Organization

1. **Single Source of Truth**: Each piece of data should exist in exactly one place
2. **Categorical Grouping**: Organize by domain/purpose, not by page
3. **Type Safety**: Every data structure should have a TypeScript interface
4. **Documentation**: Use JSDoc comments for all exported data
5. **Immutability**: Export data as `const`, not mutable objects

### Migration Strategy

1. **Incremental Migration**: Don't try to migrate everything at once
2. **Backwards Compatibility**: Maintain old exports during transition
3. **Deprecation Warnings**: Use JSDoc `@deprecated` for old exports
4. **Parallel Testing**: Test new structure alongside old before removal
5. **Rollback Plan**: Keep ability to revert if issues arise

### Common Anti-Patterns to Avoid

1. **Deeply Nested Objects**: Flatten where possible
2. **Mixed Data Formats**: Standardize on consistent structure
3. **Hardcoded URLs**: Externalize to configuration
4. **Duplicate Data**: Use references, not copies
5. **Untyped Data**: Always define interfaces
6. **Component Data Logic**: Move transformations to utilities

---

## Example: Before & After

### Before (Scattered, Untyped)

```typescript
// component/Navigation.tsx
const siteName = "My Website";
const phone = "+1-555-0199";

// component/Footer.tsx
const address = "123 Main St, City, State 12345";
const email = "contact@example.com";

// component/Hero.tsx
const heroTitle = "Welcome to Our Site";
const heroSubtitle = "We provide great services";

// data/content.json
{
  "services": [
    { "name": "Service 1", "desc": "Description" }
  ]
}
```

### After (Centralized, Typed)

```typescript
// data/types.ts
export interface SiteIdentity {
  name: string;
  tagline: string;
}

export interface Contact {
  phone: ContactMethod;
  email: string;
  address: Address;
}

// data/identity.ts
import type { SiteIdentity } from './types';

export const IDENTITY: SiteIdentity = {
  name: "My Website",
  tagline: "We provide great services",
};

// data/contact.ts
import type { Contact } from './types';

export const CONTACT: Contact = {
  phone: {
    display: "+1-555-0199",
    url: "15550199",
  },
  email: "contact@example.com",
  address: {
    full: "123 Main St, City, State 12345",
    short: "City, State",
  },
};

// data/content/hero.ts
export const HERO = {
  headline: "Welcome to Our Site",
  subheadline: "We provide great services",
};

// data/index.ts (Public API)
export * from './types';
export * from './identity';
export * from './contact';
export * from './content/hero';

// component/Navigation.tsx
import { IDENTITY, CONTACT } from '@/data';
// Use: IDENTITY.name, CONTACT.phone.display
```

---

## Related Workflows

- [Code Refactoring](./03-code-refactoring.md) - General code quality refactoring
- [Sync Documentation](../04-documentation/02-sync-documentation.md) - Update docs after refactoring
- [Execution](../02-build-code/01-execution.md) - Implement the refactoring plan
- [Code Review](./01-code-review.md) - Review refactored code

---

## Acceptance Criteria

- [ ] All data files identified and documented
- [ ] Target architecture designed with rationale
- [ ] TypeScript interfaces created for all data structures
- [ ] Migration plan with phases and exit criteria
- [ ] Backwards compatibility strategy defined
- [ ] Report saved to `project/research/` with dated filename
- [ ] Findings ordered by priority (P0-P3)
- [ ] Each finding includes evidence and rationale
- [ ] Implementation checklist provided

---

## Notes

- This workflow focuses on **planning** the refactoring; use [Execution](../02-build-code/01-execution.md) for implementation
- Adjust phases based on project complexity; simple sites may need fewer phases
- For CMS integration, design data structure to map cleanly to CMS schemas
- Consider future internationalization (i18n) when designing data structure
- Document any decisions that deviate from this workflow
