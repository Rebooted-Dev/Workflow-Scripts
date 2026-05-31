#!/bin/bash
# orchestrator-review.sh
# Launches non-interactive OpenCode plan review with configurable model
#
# Usage:
#   ./orchestrator-review.sh <plan-path> [options]
#
# Options:
#   -m, --model <model>      Model to use (e.g., openai/gpt-4o, anthropic/claude-sonnet)
#   -o, --output <path>      Output file path (default: auto-generated)
#   -t, --timeout <minutes>  Timeout in minutes (default: 30)
#   -f, --focus <area>       Focus area: general, security, architecture, performance
#   -p, --prompt <file>      Custom prompt file (default: uses 01-plan-review.md workflow)
#   -h, --help              Show this help message
#
# Examples:
#   ./orchestrator-review.sh plans/implementation-plan.md
#   ./orchestrator-review.sh plans/implementation-plan.md -m openai/gpt-4o
#   ./orchestrator-review.sh plans/implementation-plan.md -f security -m openai/gpt-4o-mini

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOW_DIR="$(dirname "$SCRIPT_DIR")"
WORKFLOW_ROOT="$(dirname "$WORKFLOW_DIR")"

# Default configuration
MODEL=""
OUTPUT_FILE=""
TIMEOUT_MINUTES=30
FOCUS="general"
CUSTOM_PROMPT=""
VERBOSE=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to show usage
show_help() {
  sed -n '/^# Usage:/,/^# /p' "$0" | sed 's/^# //'
  exit 0
}

# Function to log messages
log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Parse command line arguments
PLAN_PATH=""

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      show_help
      ;;
    -m|--model)
      MODEL="$2"
      shift 2
      ;;
    -o|--output)
      OUTPUT_FILE="$2"
      shift 2
      ;;
    -t|--timeout)
      TIMEOUT_MINUTES="$2"
      shift 2
      ;;
    -f|--focus)
      FOCUS="$2"
      shift 2
      ;;
    -p|--prompt)
      CUSTOM_PROMPT="$2"
      shift 2
      ;;
    -v|--verbose)
      VERBOSE=true
      shift
      ;;
    -*)
      log_error "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
    *)
      if [ -z "$PLAN_PATH" ]; then
        PLAN_PATH="$1"
      else
        log_error "Multiple plan paths specified"
        exit 1
      fi
      shift
      ;;
  esac
done

# Validate required arguments
if [ -z "$PLAN_PATH" ]; then
  log_error "Plan path is required"
  echo "Usage: $0 <plan-path> [options]"
  echo "Use --help for more information"
  exit 1
fi

# Validate plan file exists
if [ ! -f "$PLAN_PATH" ]; then
  log_error "Plan file not found: $PLAN_PATH"
  exit 1
fi

# Check if opencode is available
if ! command -v opencode &> /dev/null; then
  log_error "OpenCode CLI not found. Please install it first."
  echo "Visit: https://opencode.ai"
  exit 1
fi

# Generate output filename if not provided
if [ -z "$OUTPUT_FILE" ]; then
  PLAN_NAME=$(basename "$PLAN_PATH" .md)
  TIMESTAMP=$(date '+%Y%m%d-%H%M%S')
  OUTPUT_DIR="plans/reviews"
  mkdir -p "$OUTPUT_DIR"
  OUTPUT_FILE="${OUTPUT_DIR}/${TIMESTAMP}-${PLAN_NAME}-${FOCUS}-review.md"
fi

# Ensure output directory exists
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Generate status file path
STATUS_FILE="${OUTPUT_FILE%.md}.json"

# Determine workflow path
WORKFLOW_FILE="${WORKFLOW_ROOT}/01-Planning & Organizing/01-plan-review.md"
if [ ! -f "$WORKFLOW_FILE" ]; then
  log_error "Default workflow file not found: $WORKFLOW_FILE"
  exit 1
fi

# Build focus-specific instructions
case "$FOCUS" in
  security)
    FOCUS_INSTRUCTIONS="Focus heavily on security aspects: identify security vulnerabilities, data exposure risks, authentication/authorization issues, and security best practice violations. Use S0-S3 severity ratings."
    ;;
  architecture)
    FOCUS_INSTRUCTIONS="Focus on architectural concerns: design patterns, system design, scalability, maintainability, and technical debt. Identify architectural risks and provide improvement recommendations."
    ;;
  performance)
    FOCUS_INSTRUCTIONS="Focus on performance aspects: identify bottlenecks, inefficient algorithms, resource usage concerns, and optimization opportunities."
    ;;
  general|*)
    FOCUS_INSTRUCTIONS="Perform a comprehensive review covering all aspects: technical feasibility, risks, dependencies, scope creep, and actionable recommendations."
    ;;
esac

# Build the review prompt
if [ -n "$CUSTOM_PROMPT" ] && [ -f "$CUSTOM_PROMPT" ]; then
  # Use custom prompt file
  REVIEW_PROMPT=$(cat "$CUSTOM_PROMPT")
else
  # Use default prompt based on workflow
  REVIEW_PROMPT="You are an expert software engineer performing a plan review.

PLAN TO REVIEW: $PLAN_PATH

REVIEW WORKFLOW: Follow the workflow defined in $WORKFLOW_FILE

FOCUS AREA: $FOCUS_INSTRUCTIONS

YOUR TASK:
1. Read the plan document at $PLAN_PATH
2. Follow the 01-plan-review.md workflow steps systematically
3. Use parallel agents where appropriate to validate technical claims
4. Score issues with severity (S0-S3) and priority (P0-P3)
5. Provide concrete, actionable feedback with file/line references where applicable
6. Append a review addendum to the plan document with:
   - Header: YYYY-MM-DD HH:MM - Plan Review (Model: ${MODEL:-default})
   - Sections ordered by priority: P0, P1, P2, P3
   - Each item: severity, rationale, actionable fix

OUTPUT FORMAT:
- Write the complete review output (including your analysis process and findings)
- The final review addendum should be appended to: $PLAN_PATH

IMPORTANT:
- Be thorough but concise
- Focus on $FOCUS aspects
- Identify over-engineering and scope creep
- Provide evidence for all claims
- Suggest specific, measurable improvements"
fi

# Print configuration
log_info "Starting OpenCode Plan Review"
echo "  Plan:       $PLAN_PATH"
echo "  Model:      ${MODEL:-default (OpenCode configured model)}"
echo "  Focus:      $FOCUS"
echo "  Output:     $OUTPUT_FILE"
echo "  Status:     $STATUS_FILE"
echo "  Timeout:    ${TIMEOUT_MINUTES} minutes"
echo ""

# Record start time
START_TIME=$(date '+%Y-%m-%d %H:%M:%S')
START_EPOCH=$(date +%s)

# Build opencode command
OPENCODE_ARGS=("run")

if [ -n "$MODEL" ]; then
  OPENCODE_ARGS+=("-m" "$MODEL")
fi

OPENCODE_ARGS+=("--prompt" "$REVIEW_PROMPT")

if [ "$VERBOSE" = true ]; then
  echo "Command: opencode ${OPENCODE_ARGS[*]}"
  echo ""
fi

# Run OpenCode non-interactively
log_info "Launching OpenCode review process..."

# Set timeout (OpenCode run doesn't have built-in timeout, so we use timeout command)
if command -v timeout &> /dev/null; then
  TIMEOUT_CMD="timeout ${TIMEOUT_MINUTES}m"
else
  # macOS doesn't have timeout by default, use gtimeout from coreutils
  if command -v gtimeout &> /dev/null; then
    TIMEOUT_CMD="gtimeout ${TIMEOUT_MINUTES}m"
  else
    log_warning "timeout command not found, running without timeout protection"
    TIMEOUT_CMD=""
  fi
fi

# Execute review
if [ -n "$TIMEOUT_CMD" ]; then
  if $TIMEOUT_CMD opencode "${OPENCODE_ARGS[@]}" > "$OUTPUT_FILE" 2>&1; then
    EXIT_CODE=0
  else
    EXIT_CODE=$?
  fi
else
  if opencode "${OPENCODE_ARGS[@]}" > "$OUTPUT_FILE" 2>&1; then
    EXIT_CODE=0
  else
    EXIT_CODE=$?
  fi
fi

# Record end time
END_TIME=$(date '+%Y-%m-%d %H:%M:%S')
END_EPOCH=$(date +%s)
DURATION=$((END_EPOCH - START_EPOCH))
DURATION_MIN=$((DURATION / 60))
DURATION_SEC=$((DURATION % 60))

# Determine status
if [ $EXIT_CODE -eq 0 ]; then
  STATUS="completed"
  log_success "Review completed successfully"
elif [ $EXIT_CODE -eq 124 ] || [ $EXIT_CODE -eq 137 ]; then
  STATUS="timeout"
  log_warning "Review timed out after ${TIMEOUT_MINUTES} minutes"
else
  STATUS="failed"
  log_error "Review failed with exit code $EXIT_CODE"
fi

# Create status file (use jq for safe JSON generation — prevents injection from paths with special chars)
if command -v jq &> /dev/null; then
  jq -n \
    --arg plan_path "$PLAN_PATH" \
    --arg output_file "$OUTPUT_FILE" \
    --arg model "${MODEL:-default}" \
    --arg focus "$FOCUS" \
    --arg start_time "$START_TIME" \
    --arg end_time "$END_TIME" \
    --argjson duration "$DURATION" \
    --arg duration_fmt "${DURATION_MIN}m ${DURATION_SEC}s" \
    --argjson exit_code "$EXIT_CODE" \
    --arg status "$STATUS" \
    --arg workflow "$WORKFLOW_FILE" \
    '{
      plan_path: $plan_path,
      output_file: $output_file,
      model: $model,
      focus: $focus,
      start_time: $start_time,
      end_time: $end_time,
      duration_seconds: $duration,
      duration_formatted: $duration_fmt,
      exit_code: $exit_code,
      status: $status,
      workflow_file: $workflow
    }' > "$STATUS_FILE"
else
  # Fallback: sanitize variables for heredoc (basic escaping)
  _sanitize() { echo "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }
  cat > "$STATUS_FILE" << EOF
{
  "plan_path": "$(_sanitize "$PLAN_PATH")",
  "output_file": "$(_sanitize "$OUTPUT_FILE")",
  "model": "$(_sanitize "${MODEL:-default}")",
  "focus": "$(_sanitize "$FOCUS")",
  "start_time": "$(_sanitize "$START_TIME")",
  "end_time": "$(_sanitize "$END_TIME")",
  "duration_seconds": $DURATION,
  "duration_formatted": "$(_sanitize "${DURATION_MIN}m ${DURATION_SEC}s")",
  "exit_code": $EXIT_CODE,
  "status": "$(_sanitize "$STATUS")",
  "workflow_file": "$(_sanitize "$WORKFLOW_FILE")"
}
EOF
  log_warning "jq not found — status JSON uses basic escaping. Install jq for robust JSON generation."
fi

# Print summary
echo ""
echo "=========================================="
echo "Review Summary"
echo "=========================================="
echo "Status:       $STATUS"
echo "Duration:     ${DURATION_MIN}m ${DURATION_SEC}s"
echo "Exit Code:    $EXIT_CODE"
echo "Output File:  $OUTPUT_FILE"
echo "Status File:  $STATUS_FILE"
echo ""

if [ "$STATUS" = "completed" ]; then
  log_success "Review output saved to: $OUTPUT_FILE"
  
  # Show preview of output
  if [ -f "$OUTPUT_FILE" ]; then
    FILE_SIZE=$(stat -f%z "$OUTPUT_FILE" 2>/dev/null || stat -c%s "$OUTPUT_FILE" 2>/dev/null || echo "unknown")
    echo "Output size:  $FILE_SIZE bytes"
    echo ""
    
    # Show first 20 lines of output
    echo "Preview (first 20 lines):"
    echo "---"
    head -20 "$OUTPUT_FILE"
    echo "---"
    echo ""
    echo "Full output available at: $OUTPUT_FILE"
  fi
else
  log_error "Review did not complete successfully"
  echo "Check output file for details: $OUTPUT_FILE"
fi

echo ""
log_info "Orchestrator review process finished"

exit $EXIT_CODE
