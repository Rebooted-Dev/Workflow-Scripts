#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

files=(
  "$ROOT_DIR/05-review/01-code-review.md"
  "$ROOT_DIR/05-review/02-code-optimization.md"
  "$ROOT_DIR/05-review/03-code-refactoring.md"
  "$ROOT_DIR/06-security/01-security-review.md"
)

for file in "${files[@]}"; do
  rel="${file#$ROOT_DIR/}"
  grep -q 'agent-spawning-policy.md' "$file" || {
    echo "$rel does not reference agent-spawning-policy.md" >&2
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
  "$ROOT_DIR/05-review/01-code-review.md" \
  "$ROOT_DIR/05-review/02-code-optimization.md" \
  "$ROOT_DIR/05-review/03-code-refactoring.md" \
  "$ROOT_DIR/06-security/01-security-review.md"; then
  echo "Found conflicting local agent maximum in active review workflows" >&2
  exit 1
fi

if grep -RIn 'plans/security-review' "$ROOT_DIR/05-review" "$ROOT_DIR/06-security"; then
  echo "Found stale root plans/security-review routing" >&2
  exit 1
fi

echo "review workflow policy checks OK"
