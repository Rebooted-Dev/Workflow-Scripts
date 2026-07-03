# Workflow: Orchestrator - Delegated Plan Review

## Purpose
Launch a non-interactive OpenCode process to perform plan review using a different model/agent, capture the output to a file, and manage the review workflow from an orchestrator.

## When to Use This Workflow

**Use this workflow when:**
- You want to perform a plan review using a different model than your orchestrator
- You need to run plan reviews in batch or automated mode
- You want to compare reviews from multiple models
- You need non-interactive plan review for CI/CD integration
- You want the orchestrator to manage multiple review tasks

**Benefits:**
- Use different models for different aspects of review (e.g., lightweight model for initial scan, powerful model for deep analysis)
- Run reviews asynchronously while orchestrator manages other tasks
- Capture structured output for further processing
- Parallelize reviews across multiple models

## Prerequisites

- OpenCode CLI installed (`opencode` command available)
- Target model configured in OpenCode (check with `opencode models`)
- Plan document exists and is readable
- Output directory exists (default: `plans/implementation-plan.reviews/`)

## Inputs

- **Plan document path** (required) - Path to the plan to review
- **Output file path** (optional) - Where to save the review output (default: `plans/implementation-plan.reviews/YYYY-MM-DD-HHMM-<plan-name>-review.md`)
- **Model** (optional) - Model to use for review (default: uses OpenCode default model)
- **Review type** (optional) - `quick` or `deep` (default: `deep`)
- **Timeout** (optional) - Maximum time to wait for review in minutes (default: 30)

## Output

- **Review output file** - Complete review appended to file
- **Exit code** - 0 for success, 1 for errors or critical findings
- **Status file** - JSON file with metadata about the review

## Orchestrator Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      ORCHESTRATOR                            │
│                    (Your Current Session)                    │
└──────────────┬──────────────────────────────────────────────┘
               │
               │ 1. Launch opencode run (non-interactive)
               │    with -m <model> flag
               │
               ▼
┌─────────────────────────────────────────────────────────────┐
│              OPENCODE NON-INTERACTIVE PROCESS                │
│                    (Different Model)                         │
│  - Reads plan document                                       │
│  - Performs review using 01-plan-review.md workflow          │
│  - Writes output to file                                     │
└──────────────┬──────────────────────────────────────────────┘
               │
               │ 2. Write review output
               │
               ▼
┌─────────────────────────────────────────────────────────────┐
│                    OUTPUT FILE                               │
│    plans/implementation-plan.reviews/YYYY-MM-DD-plan-name-review.md              │
└──────────────┬──────────────────────────────────────────────┘
               │
               │ 3. Return control
               │
               ▼
┌─────────────────────────────────────────────────────────────┐
│                      ORCHESTRATOR                            │
│         (Processes output, manages next steps)               │
└─────────────────────────────────────────────────────────────┘
```

## Usage Examples

### Basic Usage
```bash
# Review a plan using default model
./orchestrator-review.sh plans/implementation-plan.md

# Review using specific model
./orchestrator-review.sh plans/implementation-plan.md -m openai/gpt-4o

# Review with custom output path
./orchestrator-review.sh plans/implementation-plan.md -o reviews/my-review.md
```

### From Within a Workflow
```bash
# Launch review as background task
opencode run \
  -m openai/gpt-4o \
  "Review the plan at plans/implementation-plan.md following the workflow at Workflow-Scripts/01-planning-and-organizing/01-plan-review.md. Output to plans/implementation-plan.reviews/review-output.md" \
  > plans/implementation-plan.reviews/review-log.txt 2>&1 &

REVIEW_PID=$!

# Orchestrator continues with other tasks...
echo "Review running in background (PID: $REVIEW_PID)"

# Later, check if review is complete
wait $REVIEW_PID
REVIEW_EXIT_CODE=$?

if [ $REVIEW_EXIT_CODE -eq 0 ]; then
  echo "Review completed successfully"
  # Process the review output
else
  echo "Review failed or found critical issues"
fi
```

## Implementation

### Option 1: Shell Script Orchestrator

Create `Workflow-Scripts/orchestrator/orchestrator-review.sh`:

```bash
#!/bin/bash
# orchestrator-review.sh
# Launches non-interactive OpenCode plan review

set -euo pipefail

# Configuration
PLAN_PATH="${1:-}"
MODEL="${2:-${REVIEW_MODEL:-""}}"
OUTPUT_DIR="${OUTPUT_DIR:-"$(dirname "$PLAN_PATH")/$(basename "$PLAN_PATH" .md).reviews"}"
TIMEOUT_MINUTES="${TIMEOUT_MINUTES:-30}"

# Validate inputs
if [ -z "$PLAN_PATH" ]; then
  echo "Error: Plan path required"
  echo "Usage: $0 <plan-path> [model]"
  exit 1
fi

if [ ! -f "$PLAN_PATH" ]; then
  echo "Error: Plan not found: $PLAN_PATH"
  exit 1
fi

# Generate output filename
PLAN_NAME=$(basename "$PLAN_PATH" .md)
TIMESTAMP=$(date '+%Y%m%d-%H%M%S')
OUTPUT_FILE="${OUTPUT_DIR}/${TIMESTAMP}-${PLAN_NAME}-review.md"
STATUS_FILE="${OUTPUT_FILE%.md}.json"

mkdir -p "$OUTPUT_DIR"

# Build the review prompt
REVIEW_PROMPT="
You are performing a plan review following the workflow at Workflow-Scripts/01-planning-and-organizing/01-plan-review.md.

Plan to review: $PLAN_PATH

Please:
1. Read the plan document at $PLAN_PATH
2. Follow the 01-plan-review.md workflow steps
3. Append the review addendum to the plan document
4. Provide a summary of findings

Focus on:
- Technical feasibility
- Risk assessment (S0-S3, P0-P3)
- Missing dependencies
- Scope creep detection
- Actionable recommendations
"

# Launch non-interactive review
echo "Starting plan review..."
echo "  Plan: $PLAN_PATH"
echo "  Model: ${MODEL:-default}"
echo "  Output: $OUTPUT_FILE"
echo ""

# Record start time
START_TIME=$(date '+%Y-%m-%d %H:%M:%S')

# Run OpenCode non-interactively
if [ -n "$MODEL" ]; then
  opencode run \
    -m "$MODEL" \
    "$REVIEW_PROMPT" \
    > "$OUTPUT_FILE" 2>&1
else
  opencode run \
    "$REVIEW_PROMPT" \
    > "$OUTPUT_FILE" 2>&1
fi

EXIT_CODE=$?

# Record completion
END_TIME=$(date '+%Y-%m-%d %H:%M:%S')

# Create status file
cat > "$STATUS_FILE" << EOF
{
  "plan_path": "$PLAN_PATH",
  "output_file": "$OUTPUT_FILE",
  "model": "${MODEL:-default}",
  "start_time": "$START_TIME",
  "end_time": "$END_TIME",
  "exit_code": $EXIT_CODE,
  "status": "$([ $EXIT_CODE -eq 0 ] && echo 'completed' || echo 'failed')"
}
EOF

# Summary
echo ""
echo "Review completed!"
echo "  Exit code: $EXIT_CODE"
echo "  Output: $OUTPUT_FILE"
echo "  Status: $STATUS_FILE"

exit $EXIT_CODE
```

### Option 2: Parallel Multi-Model Review

Create `Workflow-Scripts/orchestrator/parallel-review.sh`:

```bash
#!/bin/bash
# parallel-review.sh
# Launches multiple reviews with different models in parallel

set -euo pipefail

PLAN_PATH="${1:-}"
OUTPUT_DIR="${OUTPUT_DIR:-"$(dirname "$PLAN_PATH")/$(basename "$PLAN_PATH" .md).reviews"}"

if [ -z "$PLAN_PATH" ]; then
  echo "Usage: $0 <plan-path>"
  exit 1
fi

# Define models to use for different review aspects
MODELS=(
  "openai/gpt-4o:architecture"      # Focus on architecture
  "openai/gpt-4o-mini:security"     # Focus on security  
  "anthropic/claude-sonnet:general" # General review
)

PLAN_NAME=$(basename "$PLAN_PATH" .md)
TIMESTAMP=$(date '+%Y%m%d-%H%M%S')
mkdir -p "$OUTPUT_DIR"

PIDS=()

# Launch reviews in parallel
for MODEL_CONFIG in "${MODELS[@]}"; do
  IFS=':' read -r MODEL FOCUS <<< "$MODEL_CONFIG"
  
  OUTPUT_FILE="${OUTPUT_DIR}/${TIMESTAMP}-${PLAN_NAME}-review-${FOCUS}.md"
  
  echo "Launching $FOCUS review with $MODEL..."
  
  opencode run \
    -m "$MODEL" \
    "Review plan at $PLAN_PATH focusing on $FOCUS. Follow Workflow-Scripts/01-planning-and-organizing/01-plan-review.md workflow." \
    > "$OUTPUT_FILE" 2>&1 &
  
  PIDS+=($!)
done

echo ""
echo "Launched ${#PIDS[@]} parallel reviews"
echo "Waiting for completion..."

# Wait for all reviews
for PID in "${PIDS[@]}"; do
  wait $PID
done

echo ""
echo "All reviews completed!"
echo "Output directory: $OUTPUT_DIR"
ls -la "$OUTPUT_DIR/${TIMESTAMP}-${PLAN_NAME}"-review-*.md
```

### Option 3: Node.js/TypeScript Orchestrator

For more complex orchestration, create `orchestrator.ts`:

```typescript
#!/usr/bin/env tsx
import { spawn } from 'child_process';
import { writeFile, mkdir } from 'fs/promises';
import { dirname } from 'path';

interface ReviewConfig {
  planPath: string;
  model?: string;
  outputPath: string;
  timeout?: number;
}

interface ReviewResult {
  planPath: string;
  outputPath: string;
  model: string;
  startTime: string;
  endTime: string;
  exitCode: number;
  status: 'completed' | 'failed' | 'timeout';
}

async function runReview(config: ReviewConfig): Promise<ReviewResult> {
  const startTime = new Date().toISOString();
  
  const prompt = `
    Review the plan at ${config.planPath} following the workflow at 
    Workflow-Scripts/01-planning-and-organizing/01-plan-review.md.
    Append findings to the plan document.
  `;
  
  const args = ['run'];
  if (config.model) args.push('-m', config.model);
  args.push(prompt);
  
  return new Promise((resolve) => {
    const proc = spawn('opencode', args, {
      timeout: (config.timeout || 30) * 60 * 1000, // Convert minutes to ms
    });
    
    let output = '';
    proc.stdout?.on('data', (data) => { output += data; });
    proc.stderr?.on('data', (data) => { output += data; });
    
    proc.on('close', async (exitCode) => {
      await mkdir(dirname(config.outputPath), { recursive: true });
      await writeFile(config.outputPath, output);
      
      const result: ReviewResult = {
        planPath: config.planPath,
        outputPath: config.outputPath,
        model: config.model || 'default',
        startTime,
        endTime: new Date().toISOString(),
        exitCode: exitCode || 0,
        status: exitCode === 0 ? 'completed' : 'failed',
      };
      
      resolve(result);
    });
    
    proc.on('error', async (error) => {
      await mkdir(dirname(config.outputPath), { recursive: true });
      await writeFile(config.outputPath, `Error: ${error.message}`);
      
      resolve({
        planPath: config.planPath,
        outputPath: config.outputPath,
        model: config.model || 'default',
        startTime,
        endTime: new Date().toISOString(),
        exitCode: 1,
        status: 'failed',
      });
    });
  });
}

// Example usage
async function main() {
  const planPath = process.argv[2];
  if (!planPath) {
    console.error('Usage: orchestrator.ts <plan-path>');
    process.exit(1);
  }
  
  // Run reviews with multiple models
  const configs: ReviewConfig[] = [
    { planPath, model: 'openai/gpt-4o', outputPath: 'plans/implementation-plan.reviews/architecture-review.md' },
    { planPath, model: 'openai/gpt-4o-mini', outputPath: 'plans/implementation-plan.reviews/security-review.md' },
  ];
  
  const results = await Promise.all(configs.map(runReview));
  
  console.log('Review Results:');
  for (const result of results) {
    console.log(`  ${result.model}: ${result.status} (exit: ${result.exitCode})`);
  }
  
  // Aggregate findings
  const allCompleted = results.every(r => r.status === 'completed');
  process.exit(allCompleted ? 0 : 1);
}

main().catch(console.error);
```

## Workflow Integration

### From 00-research-and-plan.md

After creating an initial plan, automatically launch reviews:

```markdown
### 3.3 Automated Review Launch

Once the plan is written, the orchestrator can automatically launch reviews:

**Option A: Single Review**
```bash
# From within the research workflow
opencode run \
  -m openai/gpt-4o \
  "Review the plan at plans/implementation-plan.md following 01-plan-review.md workflow" \
  > plans/implementation-plan.reviews/auto-review.md 2>&1
```

**Option B: Parallel Reviews**
Launch multiple reviews with different focus areas:
- Architecture review (heavy model)
- Security review (security-focused model)  
- General review (fast model)

The orchestrator collects all outputs and synthesizes findings.

### 3.4 Review Synthesis

After reviews complete, the orchestrator:
1. Reads all review output files
2. Aggregates findings by priority (P0, P1, P2, P3)
3. Deduplicates similar issues
4. Appends consolidated feedback to the plan
5. Proceeds to 02-finalise-plan.md
```

## Best Practices

1. **Model Selection:**
   - Use lighter models for initial/quick reviews
   - Use powerful models for deep/complex reviews
   - Consider cost vs. benefit when selecting models

2. **Timeout Management:**
   - Set reasonable timeouts (30-60 minutes for deep reviews)
   - Handle timeout gracefully in orchestrator
   - Allow async processing for long reviews

3. **Output Management:**
   - Use consistent naming conventions
   - Store metadata alongside outputs
   - Archive old reviews periodically

4. **Error Handling:**
   - Check exit codes
   - Review logs on failure
   - Have fallback models ready

5. **Security:**
   - Don't expose API keys in scripts
   - Use environment variables or secure vaults
   - Validate plan paths before processing

## Limitations

- OpenCode `run` command may not support all interactive features
- Complex workflows requiring user input may need adaptation
- Model availability depends on OpenCode configuration
- Review quality depends on model capabilities

## Related Workflows

- **[`01-planning-and-organizing/01-plan-review.md`](../../01-planning-and-organizing/01-plan-review.md)** - The actual review workflow being executed
- **[`01-planning-and-organizing/02-finalise-plan.md`](../../01-planning-and-organizing/02-finalise-plan.md)** - Process review feedback into final plan
- **[`01-planning-and-organizing/00-research-and-plan.md`](../../01-planning-and-organizing/00-research-and-plan.md)** - Create initial plans to be reviewed

## Notes

- This orchestrator pattern can be applied to any workflow, not just plan review
- Consider creating a generic `orchestrator-run.sh` that can execute any workflow file
- The non-interactive OpenCode process runs independently - the orchestrator manages it
- Output files can be processed by the orchestrator or other workflows
