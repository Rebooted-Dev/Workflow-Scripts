# Conceptual Overview

## What Workflow-Scripts Is

Workflow-Scripts is a **repository of Markdown documents** that encode structured development processes for AI agents to execute. It is not a CLI tool, not a framework, and not a library — it is a collection of instructions written in natural language that an AI agent interprets and acts upon.

Each workflow file describes a repeatable process: what problem it solves, when to use it, what steps to follow, and what outputs to produce. An AI agent reads these files and carries out the work against your project's codebase.

## Mental Model

```
┌─────────────────────────────────────────────────────────┐
│                     Your Project                        │
│  (code, configs, docs — the thing you are building)     │
└────────────────────────┬────────────────────────────────┘
                         │ operates on
                         ▲
┌────────────────────────┴────────────────────────────────┐
│                  AI Agent (Claude, etc.)                │
│  reads workflow instructions, interprets, executes      │
└────────────────────────┬────────────────────────────────┘
                         │ reads
                         ▲
┌────────────────────────┴────────────────────────────────┐
│              Workflow-Scripts Repository                │
│  (Markdown files describing what to do and how)         │
└─────────────────────────────────────────────────────────┘
```

The agent is the runtime. The workflows are the program. Your project is the data.

## Core Concepts

### Workflows as Instructions

A workflow is a Markdown file with a standard structure:

- **Purpose** — What this workflow accomplishes
- **When to Use** — Decision criteria for selecting it
- **Steps** — What the agent should do, in order
- **Output** — What files are created or modified

The agent does not "run" these files like scripts. It reads them as instructions and performs the described actions using its own capabilities (file reading, code editing, shell commands).

### Parallel Agents

Many workflows specify "suggested agent roles" for parallel execution. Rather than one agent working sequentially, the workflow instructs the spawning of multiple sub-agents that work concurrently on different aspects of the task.

```
Main Agent (orchestrator)
├── Agent A: Scan authentication code
├── Agent B: Scan API endpoints
├── Agent C: Scan input validation
└── Agent D: Scan dependency vulnerabilities
    │
    ▼ results merged
Main Agent: Compile findings, score, produce report
```

This is a flexible pattern — the workflow suggests roles but the orchestrating agent decides how many to spawn based on task complexity.

### Priority Scoring (P0-P3)

Every finding, task, and recommendation across all workflows is scored on a shared priority scale:

| Priority | Meaning | Action |
|----------|---------|--------|
| P0 | Blocker | Fix before merge |
| P1 | Urgent | Fix before release |
| P2 | Soon | Fix next sprint |
| P3 | Backlog | Track and defer |

Severity (S0-S3) is scored separately to distinguish impact from urgency. The rubric lives in `00-meta/severity-priority-rubric.md` and is referenced by all review and planning workflows.

### Multi-Repo Architecture

Workflow-Scripts is a **separate git repository** cloned into your project directory. It is not installed as a dependency or committed to your project's repo.

```
your-project/                  ← your git repo
├── .git/
├── .gitignore                 ← contains "Workflow-Scripts/"
├── src/
├── Workflow-Scripts/          ← separate git repo
│   ├── .git/                  ← independent history
│   └── (all workflow files)
└── project/                   ← project-specific state
    ├── changelog/
    ├── troubleshooting/
    └── plans/
```

This separation means:
- Workflow updates (`git pull`) do not affect your project history
- Your project changes do not pollute the workflows repository
- Multiple projects can share the same workflows, updated independently

### Workflow Lifecycle

Development follows a predictable lifecycle that workflows map onto:

```
         PLANNING                    BUILDING                 REVIEWING
    ┌──────────────┐           ┌──────────────┐         ┌──────────────┐
    │ 00-research  │           │ 01-execution │         │ 01-code-     │
    │ 02-finalise  │──────────▶│              │────────▶│    review     │
    │ 01-plan-     │           │ 02-confirm   │         │ 02-code-     │
    │    review    │           │    execution  │         │    optimize   │
    └──────────────┘           └──────────────┘         └──────────────┘
           │                         │                         │
           │                         │                         │
           ▼                         ▼                         ▼
    ┌──────────────┐           ┌──────────────┐         ┌──────────────┐
    │ 02-bug-fix   │           │ 02-sync-     │         │ 01-security- │
    │              │           │  docs         │         │    review     │
    │ 02-security- │           │              │         │ 02-security- │
    │    fix       │           │              │         │    fix        │
    └──────────────┘           └──────────────┘         └──────────────┘
        DEBUGGING               DOCUMENTING                SECURITY
```

Workflows are composable. A typical feature might flow through: Research → Plan → Review → Execute → Code Review → Document. A bug fix skips straight to Debug → Review → Document.

### Outputs Are Files

Workflows produce outputs as files in your project directory:

| Output | Location | Format |
|--------|----------|--------|
| Plans | `plans/` | `<type>-YYYY-MM-DD-HH-MM.md` |
| Changelog entries | `project/changelog/<category>/` | `<yyyy-mm-dd>-<type>-<title>.md` |
| Troubleshooting entries | `project/troubleshooting/<category>/` | `<yyyy-mm-dd>-<category>-<title>.md` |
| Reports | `plans/` | `<type>-YYYY-MM-DD-HH-MM.md` |

All outputs are Markdown — human-readable, diffable, and version-controllable.

## How This Differs From Other Approaches

### vs. CLI Tools (e.g., `create-react-app`, `turbo`)

CLI tools execute deterministic operations. Workflow-Scripts provides guidance for non-deterministic AI interpretation. The same workflow file may be executed slightly differently by different agents or in different contexts — this is by design.

### vs. Prompt Libraries

Prompt libraries are typically single-shot: one prompt, one response. Workflows are multi-step processes with branching, verification, and output management. They describe entire workflows, not individual prompts.

### vs. Agent Frameworks (e.g., LangChain, AutoGPT)

Agent frameworks provide runtime infrastructure — memory, tool use, orchestration. Workflow-Scripts provides the *instructions* that run on top of any agent runtime. It is runtime-agnostic.

### vs. Documentation

Documentation describes what exists. Workflows describe what to do. Workflow files are executable knowledge — they encode process, not just information.

## Design Principles

1. **Self-contained** — Each workflow file can be understood and used independently
2. **Composable** — Workflows chain together into larger processes
3. **Evidence-based** — Findings cite file paths and line numbers; no speculation
4. **Priority-ordered** — Everything is scored P0-P3 so agents focus on what matters
5. **Agent-flexible** — Suggested roles, not fixed agent counts; spawn more when needed
6. **Stack-agnostic** — Workflows operate on code, not specific frameworks
7. **File-based outputs** — All results are Markdown files, never side effects

## See Also

- [User Manual](user-manual/README.md) — Getting started and common workflows
- [Developer Guide](developer-guide/README.md) — Architecture and integration details
- [Workflow Reference](workflow-reference/README.md) — Complete list of all workflows
