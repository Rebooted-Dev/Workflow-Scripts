# Orchestrator Workflows

This directory contains orchestrator workflows that manage and coordinate other workflows by launching non-interactive OpenCode processes.

## Overview

The orchestrator pattern allows you to:
- **Use different models** for different tasks while maintaining control
- **Run workflows asynchronously** while managing other tasks
- **Parallelize reviews** across multiple models
- **Integrate with CI/CD** for automated plan reviews
- **Capture structured output** for further processing

## Key Concept

```
┌──────────────┐         ┌──────────────────────┐         ┌─────────────┐
│ Orchestrator │ ──────▶ │ OpenCode (different │ ──────▶ │ Output File │
│ (you)        │ launches│ model, headless)     │ writes  │ (captured)  │
└──────────────┘         └──────────────────────┘         └─────────────┘
       │                                                        │
       │         manages and processes                          │
       └────────────────────────────────────────────────────────┘
```

The orchestrator (you or a script) launches OpenCode in non-interactive mode with:
- A specific model (`-m provider/model`)
- A workflow prompt (e.g., plan review)
- Output redirection to a file
- The orchestrator then manages the results

## Available Workflows

| File | Purpose | When to Use |
|------|---------|-------------|
| [`orchestrator-plan-review.md`](./orchestrator-plan-review.md) | Complete guide for orchestrated plan reviews | When you need documentation and examples |
| [`orchestrator-review.sh`](./orchestrator-review.sh) | Shell script implementation | Ready-to-use script for plan reviews |

## Quick Start

### Basic Usage

```bash
# Review a plan using default model
./00-Meta-Workflow/00-orchestrator/orchestrator-review.sh plans/my-plan.md

# Review using specific model
./00-Meta-Workflow/00-orchestrator/orchestrator-review.sh plans/my-plan.md -m openai/gpt-4o

# Security-focused review with lightweight model
./00-Meta-Workflow/00-orchestrator/orchestrator-review.sh plans/my-plan.md -f security -m openai/gpt-4o-mini
```

### From Another Workflow

```bash
# Launch review as background task
./00-Meta-Workflow/00-orchestrator/orchestrator-review.sh \
  plans/implementation-plan.md \
  -m openai/gpt-4o \
  -o plans/implementation-plan.reviews/review-output.md &

REVIEW_PID=$!

# Do other work while review runs...

# Wait for completion
wait $REVIEW_PID
if [ $? -eq 0 ]; then
  echo "Review complete, processing results..."
fi
```

## Use Cases

### 1. Model-Specific Reviews
Use different models for different review aspects:
- **Fast model** (GPT-4o-mini) for initial scan
- **Powerful model** (GPT-4o) for deep analysis
- **Specialized focus** (Claude) for security review

### 2. Parallel Reviews
Launch multiple reviews simultaneously:
```bash
# Architecture review
./orchestrator-review.sh plan.md -m openai/gpt-4o -f architecture -o reviews/arch.md &

# Security review
./orchestrator-review.sh plan.md -m openai/gpt-4o-mini -f security -o reviews/sec.md &

# Wait for all
wait
```

### 3. CI/CD Integration
Automate plan reviews in your pipeline:
```yaml
# .github/workflows/plan-review.yml
- name: Review Implementation Plan
  run: |
    ./Workflow-Scripts/00-Meta-Workflow/00-orchestrator/orchestrator-review.sh \
      plans/implementation-plan.md \
      -m openai/gpt-4o

    # Check if review found critical issues
    if grep -q "P0" plans/implementation-plan.reviews/*.md; then
      echo "Critical issues found in plan"
      exit 1
    fi
```

## Architecture

### Shell Script Orchestrator
The [`orchestrator-review.sh`](./orchestrator-review.sh) script:
1. Validates inputs (plan exists, OpenCode available)
2. Builds appropriate prompt based on focus area
3. Launches `opencode run` with specified model
4. Captures output to file
5. Creates JSON status file with metadata
6. Returns exit code for further processing

### Workflow Integration
Orchestrators work with existing workflows:
- **Input:** Plan document (from `00-research-and-plan.md`)
- **Process:** Launches `01-plan-review.md` workflow
- **Output:** Review addendum appended to plan
- **Next:** Can feed into `02-finalise-plan.md`

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `REVIEW_MODEL` | Default model to use | OpenCode configured model |
| `OUTPUT_DIR` | Directory for review outputs | `plans/implementation-plan.reviews` |
| `TIMEOUT_MINUTES` | Default timeout | 30 |

### Output Files

Each review creates two files:
1. **Review output** (`*.md`) - Complete review text
2. **Status file** (`*.json`) - Metadata about the review

Example status file:
```json
{
  "plan_path": "plans/implementation-plan.md",
  "output_file": "plans/implementation-plan.reviews/20240210-143022-implementation-plan-general-review.md",
  "model": "openai/gpt-4o",
  "focus": "general",
  "start_time": "2024-02-10 14:30:22",
  "end_time": "2024-02-10 14:35:45",
  "duration_formatted": "5m 23s",
  "exit_code": 0,
  "status": "completed"
}
```

## Best Practices

1. **Use appropriate models:**
   - Quick scan → lightweight model
   - Deep analysis → powerful model
   - Specialized focus → model with that strength

2. **Set reasonable timeouts:**
   - Complex plans: 30-60 minutes
   - Quick reviews: 10-15 minutes
   - Adjust based on plan complexity

3. **Organize outputs:**
   - Use consistent naming
   - Archive old reviews
   - Link reviews to plans

4. **Handle failures gracefully:**
   - Check exit codes
   - Review logs on failure
   - Have fallback strategies

5. **Monitor costs:**
   - Different models have different costs
   - Use cheaper models for initial scans
   - Reserve expensive models for critical reviews

## Limitations

- Requires OpenCode CLI to be installed and configured
- Model must be configured in OpenCode (`opencode models` to check)
- Non-interactive mode may not support all interactive features
- Review quality depends on model capabilities and prompt quality

## Future Enhancements

Potential additions to the orchestrator:
- [ ] Parallel multi-model reviews with aggregation
- [ ] Review comparison and conflict resolution
- [ ] Automated review scheduling
- [ ] Integration with plan workflow (auto-launch after plan creation)
- [ ] Review templates for different project types

## Related Workflows

- **[`01-planning-and-organizing/01-plan-review.md`](../../planning/01-plan-review.md)** - The actual review workflow being executed
- **[`01-planning-and-organizing/00-research-and-plan.md`](../../planning/00-research-and-plan.md)** - Create plans that can be reviewed
- **[`01-planning-and-organizing/02-finalise-plan.md`](../../planning/02-finalise-plan.md)** - Process review feedback

## Getting Help

```bash
# Show usage information
./orchestrator-review.sh --help

# Check if OpenCode is available
opencode --version

# List available models
opencode models
```
