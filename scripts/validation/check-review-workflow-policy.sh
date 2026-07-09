#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

files=(
  "$ROOT_DIR/workflows-drag-free/review/01-code-review.md"
  "$ROOT_DIR/workflows-drag-free/review/02-code-optimization.md"
  "$ROOT_DIR/workflows-drag-free/review/03-code-refactoring.md"
  "$ROOT_DIR/workflows-drag-free/security/01-security-review.md"
)

for file in "${files[@]}"; do
  rel="${file#"$ROOT_DIR"/}"
  grep -Eq 'agent-spawning-policy\.md|core/parallel-agents\.md|\.\./core/parallel-agents\.md' "$file" || {
    echo "$rel does not reference a parallel-agent policy" >&2
    exit 1
  }
  grep -q 'review-workflow-core.md' "$file" || {
    echo "$rel does not reference review-workflow-core.md" >&2
    exit 1
  }
  grep -q '<metadata-root>/research/' "$file" || {
    echo "$rel does not route generated reports to <metadata-root>/research/" >&2
    exit 1
  }
  grep -q 'Untrusted content rule' "$file" || {
    echo "$rel does not include untrusted content guidance" >&2
    exit 1
  }
done

if grep -RInE 'Maximum recommended:|Maximum: [0-9]+ agents|3-5 additional agents' \
  "$ROOT_DIR/workflows-drag-free/review/01-code-review.md" \
  "$ROOT_DIR/workflows-drag-free/review/02-code-optimization.md" \
  "$ROOT_DIR/workflows-drag-free/review/03-code-refactoring.md" \
  "$ROOT_DIR/workflows-drag-free/security/01-security-review.md"; then
  echo "Found conflicting local agent maximum in active review workflows" >&2
  exit 1
fi

if grep -RIn 'plans/security-review' "$ROOT_DIR/05-review" "$ROOT_DIR/06-security"; then
  echo "Found stale root plans/security-review routing" >&2
  exit 1
fi

if grep -RInE '^[[:space:]]*-[[:space:]]*P[0-3]:' \
  "$ROOT_DIR/workflows-drag-free/review/02-code-optimization.md" \
  "$ROOT_DIR/workflows-drag-free/review/03-code-refactoring.md" \
  "$ROOT_DIR/workflows-drag-free/security/01-security-review.md"; then
  echo "Found local priority-band scoring lists in active review workflows" >&2
  exit 1
fi

echo "review workflow policy checks OK"
