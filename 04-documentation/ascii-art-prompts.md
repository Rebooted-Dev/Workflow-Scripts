# ASCII Art Diagram Generation Prompts

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
[Idle] ──start──► [Running] ──pause──► [Paused]
    ▲                │                     │
    └────resume──────┘                     │
                     └─────stop────────────┘
                                           ▼
                                        [Stopped]
Use [ ] for states and labeled arrows for transitions
```

## Documentation-Specific Diagrams

### Documentation Hub Structure
```
Create an ASCII art showing documentation organization:
┌─────────────────────────────────────────┐
│           DOCUMENTATION HUB            │
├─────────────────────────────────────────┤
│  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐   │
│  │TUT  │  │API  │  │CODE │  │DEP  │   │
│  └─────┘  └─────┘  └─────┘  └─────┘   │
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
Working ──git add──► Staging ──git commit──► Repository
   │                                  │
   └──────git checkout───────┬──────┘
                            ▼
                       Working Directory
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

---

**File Location**: `Workflow-Scripts/04-documentation/ascii-art-prompts.md`  
**Purpose**: Standardized prompts for generating consistent ASCII art diagrams across documentation  
**Last Updated**: 2026-01-21