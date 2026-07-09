# ASCII Art Diagram Generation Prompts

## Purpose
This guide provides clear and precise prompts for generating ASCII art diagrams that effectively illustrate documentation content. Use these standardized prompts to create consistent, readable diagrams across all documentation.

## When to Use This Guide

**Use this guide when:**
- Creating documentation that needs visual aids (architecture, flows, hierarchies)
- Generating ASCII art diagrams for documentation sections
- You need standardized prompts for consistent diagram generation
- Working with documentation workflows that reference diagram creation

**How to use:**
1. Identify the type of diagram needed (architecture, flowchart, hierarchy, etc.)
2. Find the appropriate prompt template in this guide
3. Adapt the prompt to your specific content
4. Generate the ASCII art diagram
5. Integrate into your documentation

**This guide provides:**
- Standardized prompt templates for different diagram types
- Character reference for box-drawing and arrows
- Best practices and formatting guidelines
- Quality checklist for diagram generation

---

This guide provides clear and precise prompts for generating ASCII art diagrams that effectively illustrate documentation content.

## Architecture & System Diagrams

### System Architecture Overview
```
Create an ASCII art diagram showing a 3-tier architecture with:
- Client layer (browsers, CLI)
- Server layer (API, services)  
- Data layer (databases, storage)
Use boxes for components and arrows for connections
```

### Component Relationship Diagram
```
Generate an ASCII art diagram showing relationships between:
- API Server, Database, Cache, Message Queue
- Use solid arrows for direct dependencies
- Use dotted arrows for optional/async connections
- Include component names in boxes
```

## Flowcharts & Process Diagrams

### Workflow Process Flow
```
Create a vertical ASCII flowchart showing:
Start → Process A → Decision (Yes/No) → Process B/C → End
Use > for flow arrows and * for decision points
Include 4-6 steps maximum
```

### Data Flow Diagram
```
Draw an ASCII art data flow diagram with:
- Input sources (files, APIs, user input)
- Processing steps (validation, transformation)
- Output destinations (database, UI, logs)
- Use → for data flow and rectangles for processes
```

## Hierarchy & Structure Diagrams

### File System Hierarchy
```
Create an ASCII tree diagram showing directory structure:
project/
├── src/
│   ├── components/
│   └── utils/
├── docs/
└── tests/
Use ├── and └── for branches
```

### Class Hierarchy Diagram
```
Generate an ASCII class inheritance diagram:
BaseClass
├── ChildClassA
│   ├── GrandChild1
│   └── GrandChild2
└── ChildClassB
Use ─── for inheritance relationships
```

### Class Definition with Members
```
Create an ASCII class diagram showing class definitions with:
- Class name in header
- Attributes/properties section (+ public, - private)
- Methods/functions section (+ public, - private)
- Inheritance arrows between classes
Use UML-style notation: + for public, - for private
```

#### Example: Simple Class with Members
```
┌─────────────────────┐
│     Person          │
├─────────────────────┤
│ - name: string      │
│ - age: number       │
│ + email: string     │
├─────────────────────┤
│ + getName(): string │
│ + setName(n): void  │
│ - validate(): bool  │
└─────────────────────┘
```

#### Example: Class Inheritance with Members
```
┌─────────────────────┐         ┌─────────────────────┐
│     Person          │         │     Company         │
├─────────────────────┤         ├─────────────────────┤
│ - name: string      │         │ - name: string      │
│ - age: number       │         │ - employees: []     │
│ + email: string     │         │ + revenue: number   │
├─────────────────────┤         ├─────────────────────┤
│ + getName(): string │         │ + hire(p): void     │
│ + setName(n): void  │         │ + fire(p): void     │
│ - validate(): bool  │         │ - audit(): void     │
└────────┬────────────┘         └─────────────────────┘
         │
         │ extends
         ▼
┌─────────────────────┐
│     Employee        │
├─────────────────────┤
│ - id: number        │
│ - department: str   │
│ + salary: number    │
├─────────────────────┤
│ + work(): void      │
│ + getId(): number   │
│ - logHours(): void  │
└─────────────────────┘
```

#### Example: Multiple Inheritance Tree
```
                ┌─────────────────┐
                │   BaseEntity    │
                ├─────────────────┤
                │ - id: uuid      │
                │ - created: date │
                ├─────────────────┤
                │ + save(): void  │
                │ + delete(): void│
                └────────┬────────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│    User      │ │   Product    │ │    Order     │
├──────────────┤ ├──────────────┤ ├──────────────┤
│ - username   │ │ - sku: str   │ │ - items: []  │
│ - password   │ │ - price: dec │ │ - total: dec │
│ + isActive   │ │ + inStock    │ │ + status     │
├──────────────┤ ├──────────────┤ ├──────────────┤
│ + login()    │ │ + sell()     │ │ + place()    │
│ + logout()   │ │ + restock()  │ │ + cancel()   │
│ - hashPwd()  │ │ - calcTax()  │ │ - notify()   │
└──────────────┘ └──────────────┘ └──────────────┘
```

### Notation Guide for Class Members
```
Visibility symbols:
+  public (accessible from anywhere)
-  private (accessible only within class)
#  protected (accessible within class and subclasses)
~  package/default (accessible within package/module)

Member syntax:
┌──────────────────────────┐
│        ClassName         │
├──────────────────────────┤
│ + publicAttr: type       │
│ - _privateAttr: type     │
│ # _protectedAttr: type   │
├──────────────────────────┤
│ + publicMethod(): ret    │
│ - _privateMethod(): ret  │
│ # _protectedMethod()     │
└──────────────────────────┘
```

## Network & Integration Diagrams

### API Integration Diagram
```
Create an ASCII diagram showing API relationships:
Client ──HTTP──► API Gateway ──gRPC──► Services
                    │
                    └────WebSocket──► Real-time Service
Use different arrow styles for protocol types
```

### Microservices Architecture
```
Draw an ASCII microservices diagram with:
- Service A, Service B, Service C in boxes
- Load Balancer routing to services
- Database shared between services
- Message queue for async communication
Use clear labels and connection types
```

## UI/UX Flow Diagrams

### User Journey Flow
```
Create an ASCII user flow diagram:
User → Login Page → Dashboard → Feature → Success/Error
Use ──► for navigation and [ ] for pages/screens
Include decision points where relevant
```

### State Machine Diagram
```
Generate an ASCII state diagram:
                    ┌─────────┐
         ┌─────────│ [Idle]  │
         │         └────┬────┘
         │              │ start
         │              ▼
         │         ┌───────────┐
         │         │ [Running] │
         │         └─────┬─────┘
         │               │
         │         ┌─────┴─────┐
         │         │           │
   pause │         ▼           ▼ stop
         │    ┌────────┐   ┌─────────┐
         └────│[Paused]│   │[Stopped]│
              └───┬────┘   └─────────┘
                  │
                  │ resume
                  └───────────┐
                              │
                              ▼
                         ┌───────────┐
                         │ [Running] │
                         └───────────┘
Use [ ] for states and labeled arrows for transitions
```

## Documentation-Specific Diagrams

### Documentation Hub Structure
```
Create an ASCII art showing documentation organization:
┌─────────────────────────────────────────┐
│           DOCUMENTATION HUB            │
├─────────────────────────────────────────┤
│ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐       │
│ │ TUT │ │ API │ │CODE │ │ DEP │       │
│ └─────┘ └─────┘ └─────┘ └─────┘       │
└─────────────────────────────────────────┘
Use boxes for categories and include connections
```

### Tutorial Learning Path
```
Create an ASCII diagram showing learning progression:
Beginner ──► Intermediate ──► Advanced
    │             │             │
   ┌─▼─┐        ┌─▼─┐        ┌─▼─┐
   │B1 │        │I1 │        │A1 │
   │B2 │        │I2 │        │A2 │
   └───┘        └───┘        └───┘
Use vertical progression and connecting arrows
```

## Code & Development Diagrams

### Git Workflow
```
Create an ASCII Git workflow diagram:
┌─────────┐  git add   ┌─────────┐ git commit ┌───────────┐
│ Working │──────────▶│ Staging │───────────▶│Repository │
└────┬────┘            └────┬────┘            └─────┬─────┘
     │                      │                      │
     │                      │ git checkout         │
     │                      ▼                      │
     │                 ┌───────────┐               │
     │                 │  Working  │               │
     │                 │ Directory │               │
     │                 └───────────┘               │
     │                      │                      │
     └──────────────────────┴──────────────────────┘
                    git checkout
```

### CI/CD Pipeline
```
Draw an ASCII CI/CD pipeline:
Code → Build → Test → Deploy → Monitor
  │      │      │      │        │
  X      X      X      X        X
 fail  fail  fail  fail     alerts
Use X marks for failure points and logs
```

## Best Practices for ASCII Art

### Formatting Guidelines
- Use monospaced characters: ─ │ ┌ ┐ └ ┘ ┬ ┴ ├ ┤
- Keep diagrams compact (max 20-25 lines)
- Use consistent spacing and alignment
- Label all components clearly

### Alignment Review Checklist
Review diagrams for these common alignment quirks before committing:

- [ ] **Label positioning** - Ensure transition labels (e.g., `pause`, `resume`) align with their connecting lines and don't overlap with boxes
- [ ] **Line connections** - Verify lines meet box corners cleanly (no gaps or overlaps)
- [ ] **Branch alignment** - Check that split branches (e.g., from `Running` to `Paused`/`Stopped`) are evenly spaced
- [ ] **Arrow consistency** - Confirm all arrowheads point in the correct direction and are consistent (use `▶` or `►`, not mixed)
- [ ] **Vertical spacing** - Ensure consistent line height between diagram rows
- [ ] **Horizontal centering** - Box contents should appear centered; adjust padding with spaces
- [ ] **Loop-back lines** - Curved return paths (e.g., `Paused` → `Running`) should connect cleanly without crossing other elements

### Character Reference
```
Boxes and Lines:
┌─────┐   ───   │    ┬    ┴   ├   ┤   └   ┘
│ Box │   →    ↑    ↓    ↔   ═   ║   ╗   ╝
└─────┘   ◄    ↔    ◐    ◑   └─┘  ╓   ╖

Arrows:
→ ← ↑ ↓ ↔ ↕ ↖ ↗ ↘ ↙ 
===> <=== =>> <<= ► ◄

Special:
★ * • ○ ● ◇ ◆ □ ■ △ ▽
```

## General Prompt Template

### Standard Format
```
Create an ASCII art diagram showing [TOPIC]:
- [Component 1]: [description]
- [Component 2]: [description]  
- [Component 3]: [description]
Use [STYLE] for [PURPOSE] with [ORIENTATION] orientation
Include [SPECIFIC FEATURES]
Keep it to [LINE LIMIT] lines maximum
```

### Example Complete Prompt
```
Create an ASCII art flowchart showing the CI/CD pipeline:
- Code Commit: Source code changes
- Build: Compile and package
- Test: Automated testing
- Deploy: Release to production
- Monitor: Performance tracking
Use → for flow and include failure paths with X marks
Keep it to 3-4 lines maximum
```

## Usage Instructions

### When to Use These Prompts
- Creating new documentation sections
- Enhancing existing documentation with visual aids
- Explaining complex processes or architectures
- Providing quick reference guides

### Integration with Documentation Workflows
1. Identify documentation section that needs visual aid
2. Select appropriate diagram type from categories above
3. Adapt the prompt template to your specific content
4. Generate ASCII art and integrate into documentation
5. Test rendering in different terminal/display contexts

### Quality Checklist
- [ ] Diagram renders clearly in monospace font
- [ ] All components are labeled and readable
- [ ] Connections flow logically (left-to-right, top-to-bottom)
- [ ] Diagram fits within reasonable line limits
- [ ] ASCII characters display consistently across platforms
- [ ] Diagram serves clear purpose for the documentation section

## Example Diagrams

### System Architecture Example

```
┌─────────────┐      HTTP       ┌─────────────┐      SQL      ┌─────────────┐
│   Client    │ ───────────────▶│  API Server │──────────────▶│  Database   │
│  (Browser)  │                 │             │               │             │
└─────────────┘                 └──────┬──────┘               └─────────────┘
                                       │
                                       │ Cache
                                       ▼
                                ┌─────────────┐
                                │    Redis    │
                                │    Cache    │
                                └─────────────┘
```

### Component Relationship Example

```
┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│   Auth      │────────▶│   API       │────────▶│   Database  │
│   Service   │         │   Gateway   │         │             │
└─────────────┘         └──────┬──────┘         └─────────────┘
                               │
              ┌────────────────┼────────────────┐
              │                │                │
              ▼                ▼                ▼
        ┌─────────┐      ┌─────────┐      ┌─────────┐
        │Service A│      │Service B│      │Service C│
        └─────────┘      └─────────┘      └─────────┘
```

### Workflow Process Example

```
    ┌──────┐
    │ Start│
    └──┬───┘
       │
       ▼
┌──────────────┐    No    ┌────────┐
│  Validate    │─────────▶│ Error  │
│   Input?     │          │  Exit  │
└──────┬───────┘          └────────┘
       │ Yes
       │
       ▼
┌──────────────┐
│   Process    │
│    Data      │
└──────┬───────┘
       │
       ▼
┌────────────┐
│   Output   │
│   Result   │
└─────┬──────┘
      │
      ▼
┌────────┐
│  End   │
└────────┘
```

### Data Flow Example

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│  Input   │───▶│ Validate │───▶│Transform │───▶│  Store   │
│  (JSON)  │    │   Data   │    │  Data    │    │ (DB)     │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
     │                                              │
     │                                              │
     └──────────────────┐   ┌───────────────────────┘
                        │   │
                        ▼   ▼
                   ┌──────────┐
                   │  Logs    │
                   │ (Audit)  │
                   └──────────┘
```

### File System Hierarchy Example

```
project/
├── docs/
│   ├── README.md
│   └── architecture/
│       ├── systems.md
│       └── code.md
├── src/
│   ├── components/
│   │   ├── Header.tsx
│   │   └── Footer.tsx
│   ├── utils/
│   │   └── helpers.ts
│   └── main.ts
├── tests/
│   ├── unit/
│   └── integration/
└── package.json
```

### State Machine Example

```
              ┌─────────┐
         ┌────│  Idle   │
         │    └────┬────┘
         │         │ start
         │         ▼
         │    ┌─────────┐
         │    │ Running │
         │    └────┬────┘
         │         │
   pause │    ┌────┴────┐     stop
         │    │         │
         │    ▼         ▼
         └───│ Paused │  │Stopped│
              └───┬────┘  └────────┘
                  │
                  │ resume
                  │
                  ▼
             ┌─────────┐
             │ Running │
             └─────────┘
```

### User Journey Example

```
[Home] ──► [Login] ──► [Dashboard] ──► [Feature] ──► [Success]
                              │
                              ▼
                         [Settings]
                              │
                              ▼
                         [Profile]
```

---

**File Location**: `Workflow-Scripts/04-documentation/ascii-art-prompts.md`  
**Purpose**: Standardized prompts for generating consistent ASCII art diagrams across documentation  
**Last Updated**: 2026-01-21