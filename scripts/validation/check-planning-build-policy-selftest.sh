#!/usr/bin/env bash
# Exercise Phase A-C planning/build policy checks against isolated fixture roots.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CHECK="$ROOT_DIR/scripts/validation/check-planning-build-policy.sh"
FIXTURES="$ROOT_DIR/scripts/validation/fixtures/planning-build-policy"
temp_dir="$(mktemp -d)"
trap 'rm -rf "$temp_dir"' EXIT

make_case() {
  local case_root="$1"
  mkdir -p "$case_root"
  cp -R "$FIXTURES/phase-b-pass/." "$case_root/"
  add_phase_c_baseline "$case_root"
}

add_standard_link() {
  local case_root="$1" relative_file="$2" file="$1/$2"
  mkdir -p "$(dirname "$file")"
  if [ ! -f "$file" ]; then
    printf '# Isolated policy fixture\n' > "$file"
  fi
  printf '\n[engineering-standards.md](../00-Meta-Workflow/00-meta/engineering-standards.md)\n' >> "$file"
}

add_phase_c_baseline() {
  local case_root="$1"
  add_standard_link "$case_root" 02-code-build/01-execution.md
  add_standard_link "$case_root" 02-code-build/02-confirm-execution.md
  add_standard_link "$case_root" 01-planning-and-organizing/01-plan-review.md
  add_standard_link "$case_root" 05-review/01-code-review.md
  add_standard_link "$case_root" 05-review/03-code-refactoring.md
}

expect_root() {
  local expected="$1" case_root="$2" message="$3" out code
  set +e
  out="$(bash "$CHECK" "$case_root" 2>&1)"
  code=$?
  set -e

  if [ "$expected" = pass ] && [ "$code" -ne 0 ]; then
    echo "FAIL: $case_root should pass: $out" >&2
    exit 1
  fi
  if [ "$expected" = fail ] && [ "$code" -eq 0 ]; then
    echo "FAIL: $case_root should fail" >&2
    exit 1
  fi
  if [ -n "$message" ] && ! printf '%s\n' "$out" | grep -Fq "$message"; then
    echo "FAIL: $message missing from output: $out" >&2
    exit 1
  fi
}

expect_phase_a() {
  local expected="$1" fixture="$2" message="$3" case_root="$temp_dir/$2"
  make_case "$case_root"
  cp -R "$FIXTURES/$fixture/." "$case_root/"
  expect_root "$expected" "$case_root" "$message"
}

expect_phase_b() {
  local fixture="$1" target="$2" message="$3" case_root="$temp_dir/$1"
  make_case "$case_root"
  cp "$FIXTURES/phase-b-negative/$fixture" "$case_root/$target"
  add_standard_link "$case_root" "$target"
  expect_root fail "$case_root" "$message"
}

expect_phase_c() {
  local fixture="$1" target="$2" message="$3" case_root="$temp_dir/$1"
  make_case "$case_root"
  cp "$FIXTURES/phase-c-negative/$fixture" "$case_root/$target"
  expect_root fail "$case_root" "$message"
}

expect_phase_a pass pass "planning/build policy checks OK"
expect_phase_a fail fail-aggressively "must not contain 'aggressively'"
expect_phase_a fail fail-librarian-agents "must not contain 'librarian agents'"
expect_phase_a fail fail-parallel-without-applicability "workflow-applicability.md"
expect_phase_a fail fail-parallel-bare-reference "workflow-applicability.md"

expect_phase_b phase-order.md 01-planning-and-organizing/01-plan-review.md \
  "retired phase-priority wording"
expect_phase_b missing-enabling-plan-review.md 01-planning-and-organizing/01-plan-review.md \
  "01-plan-review.md is missing the required enabling-refactor sentence"
expect_phase_b missing-enabling-finalise.md 01-planning-and-organizing/02-finalise-plan.md \
  "02-finalise-plan.md is missing the required enabling-refactor sentence"
expect_phase_b missing-skill-change-surface.md 11-Skills/workflow-plan-review-finalize/SKILL.md \
  "workflow-plan-review-finalize/SKILL.md is missing Change Surface"
expect_phase_b missing-skill-verify.md 11-Skills/execute-and-confirm-plan/SKILL.md \
  "execute-and-confirm-plan/SKILL.md is missing Verify:"
expect_phase_b missing-skill-template-link.md 11-Skills/workflow-plan-review-finalize/SKILL.md \
  "workflow-plan-review-finalize/SKILL.md does not link plan-template.md"

expect_phase_c missing-execution-link.md 02-code-build/01-execution.md \
  "02-code-build/01-execution.md does not reference engineering-standards.md"
expect_phase_c missing-confirm-link.md 02-code-build/02-confirm-execution.md \
  "02-code-build/02-confirm-execution.md does not reference engineering-standards.md"
expect_phase_c missing-plan-review-link.md 01-planning-and-organizing/01-plan-review.md \
  "01-planning-and-organizing/01-plan-review.md does not reference engineering-standards.md"
expect_phase_c missing-code-review-link.md 05-review/01-code-review.md \
  "05-review/01-code-review.md does not reference engineering-standards.md"
expect_phase_c missing-refactoring-link.md 05-review/03-code-refactoring.md \
  "05-review/03-code-refactoring.md does not reference engineering-standards.md"

echo "check-planning-build-policy self-test OK"
