# Agent Flexibility Review

**Status:** Active - Implementation Complete  
**Created:** 2026-01-26  
**Last Updated:** 2026-01-26  
**Implementation Date:** 2026-01-26

## Summary

This document reviews how workflows specify parallel agent usage and identifies opportunities to make agent usage more flexible and dynamic. While workflows encourage parallel agents, they currently constrain flexibility by specifying fixed agent counts and fixed roles, which may limit the AI's ability to adapt to task complexity and spawn additional agents when beneficial.

---

## Current State Analysis

### Issues Identified

#### 1. Fixed Agent Counts
Many workflows specify exact numbers of agents (e.g., "Agent 1", "Agent 2", "Agent 3", "Agent 4"), creating a rigid structure that doesn't adapt to task complexity.

**Examples:**
- `01-plan-review.md`: Specifies exactly 4 agents for validation (lines 18-21) and 4 agents for issue identification (lines 23-27)
- `02-finalise-plan.md`: Specifies exactly 3 agents for codebase scanning (lines 18-20), 3 for dependency validation (lines 23-25), and 3 for feasibility checking (lines 28-30)
- `01-execution.md`: Specifies exactly 4 agents in preparation (lines 28-31) and 4 agents for implementation (lines 41-44)
- `01-code-review.md`: Specifies exactly 3 agents (lines 17-19)
- `01-security-review.md`: Specifies exactly 6 agents (lines 19-24)
- `02-bug-fix-workflow.md`: Specifies exactly 5 agents for investigation (lines 32-36) and 5 agents for implementation (lines 57-61)
- `02-security-fix.md`: Specifies exactly 5 agents for investigation (lines 26-30) and 5 agents for implementation (lines 50-54)

#### 2. Fixed Roles
Each agent is assigned a specific, predetermined role, which may not always be optimal for the task at hand.

**Example from `01-code-review.md`:**
```markdown
- Agent 1: Scan for bugs and software faults
- Agent 2: Scan for security and safety issues
- Agent 3: Scan for optimization, modularization, and refactoring opportunities
```

This structure assumes these three roles are always needed and sufficient, but:
- Some codebases might need more specialized security analysis (e.g., separate agents for authentication vs. data protection)
- Large codebases might benefit from domain-specific agents (e.g., frontend vs. backend)
- Complex tasks might need additional agents for cross-cutting concerns

#### 3. No Dynamic Spawning Guidance
Workflows don't explicitly encourage spawning additional agents when:
- Task complexity increases
- New concerns are discovered during execution
- Different domains require specialized analysis
- Parallel work could accelerate completion

#### 4. Limited Adaptability
The fixed structure doesn't account for:
- **Task size**: Small tasks might need fewer agents; large tasks might need more
- **Codebase structure**: Monolithic vs. microservices might need different agent strategies
- **Discovery during execution**: New issues found might require additional specialized agents
- **Domain expertise**: Some tasks benefit from domain-specific agents (e.g., database, API, UI)

---

## Recommended Approach

### Principle: Guidance Over Prescription

Instead of prescribing exact agent counts and roles, workflows should:
1. **Provide examples** of useful agent roles (not requirements)
2. **Encourage dynamic spawning** when additional agents would be beneficial
3. **Suggest minimum agent counts** for complex tasks (not maximums)
4. **Allow role adaptation** based on discovered needs

### Proposed Pattern

**Before (Fixed Structure):**
```markdown
Use parallel agents to validate each item:
- Agent 1: Validate API/interface compatibility
- Agent 2: Check file structure and module dependencies
- Agent 3: Verify configuration and environment assumptions
- Agent 4: Cross-reference with existing patterns and conventions
```

**After (Flexible Structure):**
```markdown
Use parallel agents to validate each item. Suggested agent roles (adapt as needed):
- Validate API/interface compatibility and availability
- Check file structure, module dependencies, and imports
- Verify configuration and environment assumptions
- Cross-reference with existing patterns and conventions
- [Spawn additional agents if you discover other validation needs, such as:
  - Performance impact analysis
  - Security implications
  - Testing requirements
  - Documentation gaps]
```

### Benefits of Flexible Approach

1. **Adapts to complexity**: Simple tasks use fewer agents; complex tasks can spawn more
2. **Responds to discovery**: New concerns found during execution can trigger additional agents
3. **Domain-specific**: Can create specialized agents for specific areas (e.g., database, API, UI)
4. **Efficiency**: Avoids over-provisioning agents for simple tasks
5. **Completeness**: Allows spawning additional agents when initial agents discover related concerns

---

## Specific Recommendations by Workflow

### 1. Plan Review (`01-planning/01-plan-review.md`)

**Current:** Fixed 4 agents for validation, 4 agents for issue identification

**Recommended:**
```markdown
2. Use parallel agents to validate each item for technical feasibility and correctness. 
   Suggested agent roles (spawn additional agents as needed):
   - Validate API/interface compatibility and availability
   - Check file structure, module dependencies, and imports
   - Verify configuration and environment assumptions
   - Cross-reference with existing patterns and conventions
   - [If you discover other validation needs during execution, spawn additional agents]
   Consolidate validation results and flag any conflicts or issues.

3. Use parallel agents to identify issues across different domains. 
   Suggested agent roles (spawn additional agents as needed):
   - Scan for security and safety issues
   - Identify design flaws and architectural concerns
   - Detect potential bugs and software faults
   - Flag scope creep and over-engineering risks
   - [If you discover other concern areas, spawn additional specialized agents]
   Consolidate findings and identify:
   - design flaws in the plan
   - potential bugs and software faults
   - security and safety issues
   - invalid or unverifiable items
   - scope creep / over-engineering risk
   - optimization, modularization, and refactoring opportunities
```

### 2. Implementation Plan (`01-planning/02-finalise-plan.md`)

**Current:** Fixed 3 agents for codebase scanning, 3 for dependency validation, 3 for feasibility checking

**Recommended:**
```markdown
2. Use parallel agents to scan the codebase for context. 
   Suggested agent roles (spawn additional agents as needed):
   - Identify existing implementations or similar patterns
   - Map dependencies and constraints in the codebase
   - Find related code that might be affected by the plan
   - [Spawn additional agents if you discover other areas that need investigation]
   Consolidate ideas into a single coherent plan that removes duplicates and contradictions.

3. Use parallel agents to validate dependencies and ordering constraints. 
   Suggested agent roles (spawn additional agents as needed):
   - Verify dependency claims against actual code structure
   - Check for potential conflicts or circular dependencies
   - Validate ordering constraints are technically sound
   - [Spawn additional agents if you discover other dependency concerns]

4. Use parallel agents to cross-check technical feasibility of each priority bucket. 
   Suggested agent roles (spawn additional agents as needed):
   - Validate P0/P1 items are technically feasible
   - Check for existing solutions or patterns that could be reused
   - Identify potential blockers or risks for each priority level
   - [Spawn additional agents if you discover other feasibility concerns]
```

### 3. Execution (`02-build-code/01-execution.md`)

**Current:** Fixed 4 agents in preparation and implementation phases

**Recommended:**
```markdown
Preparation
- Plan parallel agents for each phase. Suggested agent roles (adapt as needed):
  - Implement core functionality
  - Review for security/risk issues and side effects
  - Check for breaking changes or unintended impacts
  - Validate against acceptance criteria and test cases
  - [Spawn additional agents if the phase complexity requires it, such as:
    - Performance impact analysis
    - Documentation updates
    - Test coverage validation
    - Integration testing]

For Each Phase (Implementation Loop)
- Implement
  - Make the smallest change that satisfies the phase scope.
  - Use parallel agents to:
    - Implement the core change
    - Concurrently review for risks, side effects, and breaking changes
    - Check for unintended impacts on other modules or features
    - Validate code quality and adherence to project conventions
    - [Spawn additional agents if you discover other concerns during implementation]

- Verify (repeat until exit criteria met)
  - Use parallel agents to run checks concurrently:
    - Run `npm run build` and check for build errors
    - Check for TypeScript/ESLint errors and warnings
    - Validate file structure and imports are correct
    - Review git diff for unintended changes or secrets
    - [Spawn additional agents if other verification needs are discovered]
```

### 4. Code Review (`05-review-audit/01-code-review.md`)

**Current:** Fixed 3 agents

**Recommended:**
```markdown
1. Scan the codebase using parallel agents. 
   Suggested agent roles (spawn additional agents as needed):
   - Scan for bugs and software faults
   - Scan for security and safety issues
   - Scan for optimization, modularization, and refactoring opportunities
   - [Spawn additional agents if you discover other concern areas, such as:
     - Performance bottlenecks
     - Accessibility issues
     - Test coverage gaps
     - Documentation inconsistencies
     - Domain-specific concerns (database, API, UI, etc.)]
   Agents should batch read files (e.g., read 5-10 files concurrently per agent) to maximize throughput.
```

### 5. Security Review (`06-security/01-security-review.md`)

**Current:** Fixed 6 agents

**Recommended:**
```markdown
1. Scan the codebase using parallel agents focused on security. 
   Suggested agent roles (spawn additional agents as needed):
   - Scan for authentication and authorization vulnerabilities
   - Scan for input validation and injection risks
   - Scan for sensitive data exposure and secrets management
   - Scan for dependency vulnerabilities and outdated packages
   - Scan for cryptographic issues and weak implementations
   - Scan for security misconfigurations and exposed endpoints
   - [Spawn additional agents if you discover other security concerns, such as:
     - API-specific security issues
     - Frontend security vulnerabilities
     - Infrastructure security misconfigurations
     - Compliance and regulatory concerns
     - Supply chain security risks]
   Agents should batch read files (e.g., read 5-10 files concurrently per agent) to maximize throughput.
```

### 6. Bug Fix (`03-debug/02-bug-fix-workflow.md`)

**Current:** Fixed 5 agents for investigation and implementation

**Recommended:**
```markdown
### 2. Investigation
Use multiple parallel agents to investigate the bug. Suggested agent roles (spawn additional agents as needed):
- Trace the bug through the codebase
- Analyze error logs and stack traces
- Check for similar bugs or related issues in the codebase
- Review recent changes that might have introduced the bug
- Examine data flow and state management around the bug
- [Spawn additional agents if you discover other investigation needs, such as:
  - Performance impact analysis
  - Security implications
  - Related code patterns that might have the same issue
  - Integration points that might be affected]
Agents should batch read files concurrently to maximize investigation speed.

### 5. Implementation
Use multiple parallel agents to implement the fix. Suggested agent roles (spawn additional agents as needed):
- Implement the primary bug fix
- Add or update tests to verify the fix and prevent regression
- Review for unintended side effects or new bugs introduced
- Check for similar issues in related code that should be fixed
- Update related documentation if the fix changes behavior
- [Spawn additional agents if you discover other implementation needs, such as:
  - Performance optimizations related to the fix
  - Additional test coverage
  - Documentation updates
  - Related code cleanup]
Each agent should read related files in parallel batches during implementation.
```

### 7. Security Fix (`06-security/02-security-fix.md`)

**Current:** Fixed 5 agents for investigation and implementation

**Recommended:**
```markdown
### 2. Investigation
Use multiple parallel agents to investigate the security issue. Suggested agent roles (spawn additional agents as needed):
- Trace the vulnerability through the codebase
- Identify all entry points and attack surfaces
- Check for similar vulnerabilities in related code
- Review security controls and existing mitigations
- Analyze data flow and sensitive data handling
- [Spawn additional agents if you discover other investigation needs, such as:
  - Related attack vectors
  - Additional entry points
  - Similar patterns in other modules
  - Compliance implications]
Agents should batch read files concurrently to maximize investigation speed.

### 5. Implementation
Use multiple parallel agents to implement the fix. Suggested agent roles (spawn additional agents as needed):
- Implement the primary security fix
- Add defense-in-depth measures (input validation, output encoding, etc.)
- Update security tests and add regression tests
- Review for unintended side effects or new vulnerabilities
- Update security documentation and logging
- [Spawn additional agents if you discover other implementation needs, such as:
  - Additional security hardening
  - Performance impact analysis
  - Related code that needs similar fixes
  - Documentation and training materials]
Each agent should read related files in parallel batches during implementation.
```

### 8. Sync Documentation (`04-documentation/02-sync-documentation.md`)

**Current:** Fixed 3 agents

**Recommended:**
```markdown
1. Scan the codebase using parallel agents. Suggested agent roles (spawn additional agents as needed):
   - Scan codebase for current behavior
   - Understand architecture and structure
   - Identify documentation gaps
   - [Spawn additional agents if you discover other documentation needs, such as:
     - API documentation gaps
     - Architecture diagram needs
     - Code example requirements
     - Migration guide needs]
   Agents should batch read files concurrently to maximize scanning speed.
```

---

## Implementation Status

**Status:** ✅ **COMPLETE** (2026-01-26)

All workflows have been successfully updated to use the flexible agent pattern. The following files were updated:

### Phase 1: Core Workflows ✅
1. ✅ `01-planning/01-plan-review.md` - Updated with flexible agent guidance
2. ✅ `01-planning/02-finalise-plan.md` - Updated with flexible agent guidance
3. ✅ `02-build-code/01-execution.md` - Updated with flexible agent guidance

### Phase 2: Review Workflows ✅
4. ✅ `05-review-audit/01-code-review.md` - Updated with flexible agent guidance
5. ✅ `06-security/01-security-review.md` - Updated with flexible agent guidance
6. ✅ `05-review-audit/02-code-optimization.md` - Updated with flexible agent guidance
7. ✅ `05-review-audit/03-code-refactoring.md` - Updated with flexible agent guidance

### Phase 3: Fix Workflows ✅
8. ✅ `03-debug/02-bug-fix-workflow.md` - Updated with flexible agent guidance
9. ✅ `06-security/02-security-fix.md` - Updated with flexible agent guidance

### Phase 4: Documentation Workflows ✅
10. ✅ `04-documentation/02-sync-documentation.md` - Updated with flexible agent guidance
11. ✅ `04-documentation/01-create-docs.md` - Updated with flexible agent guidance (bonus)

### Phase 5: Additional Workflows ✅
12. ✅ `02-build-code/02-confirm-execution.md` - Updated with flexible agent guidance (bonus)

### Phase 6: Meta Documentation ✅
13. ✅ `00-meta/parallel-agents-review.md` - Updated to note new flexible approach
14. ✅ `README.md` - Updated to explain flexible agent pattern

## Implementation Strategy (Historical)

The following strategy was used to implement the changes:

---

## Key Principles for Updated Workflows

### 1. Use "Suggested" Language
- Replace "Agent 1:", "Agent 2:" with "Suggested agent roles:"
- Make it clear these are examples, not requirements

### 2. Encourage Dynamic Spawning
- Add explicit guidance: "[Spawn additional agents if you discover other needs]"
- Provide examples of when additional agents might be beneficial

### 3. Maintain Minimum Guidance
- For complex tasks, suggest minimum agent counts (e.g., "Use at least 3-4 parallel agents")
- Don't specify maximums

### 4. Allow Role Adaptation
- Let agents adapt their roles based on discovered needs
- Encourage specialization when beneficial (e.g., domain-specific agents)

### 5. Preserve Batch Reading Guidance
- Keep the instruction about parallel batch reading (read multiple files concurrently)
- This is about efficiency, not agent count

---

## Expected Benefits

1. **Better Adaptation**: Workflows adapt to task complexity automatically
2. **More Complete Coverage**: Additional agents can be spawned when new concerns are discovered
3. **Domain Expertise**: Specialized agents can be created for specific domains
4. **Efficiency**: Simple tasks don't require unnecessary agents
5. **Discovery-Driven**: Agents can be spawned in response to findings during execution

---

## Testing the Changes

After updating workflows, test with:
1. **Simple tasks**: Verify fewer agents are used appropriately
2. **Complex tasks**: Verify additional agents are spawned when needed
3. **Discovery scenarios**: Verify agents are spawned when new concerns are found
4. **Domain-specific tasks**: Verify specialized agents are created when beneficial

---

## Related Documents

- **[`parallel-agents-review.md`](./parallel-agents-review.md)** - Historical review of parallel agent usage (archived)
- **[`../README.md`](../README.md)** - Main workflow documentation

---

## Notes

- This review focuses on making agent usage more flexible while maintaining clear guidance
- The goal is to provide examples and suggestions rather than rigid requirements
- Workflows should still provide enough structure to be useful, but allow adaptation
- Dynamic agent spawning should be encouraged when it would improve completeness or efficiency
