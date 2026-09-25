#!/usr/bin/env bash
# Phase A/B invariants for active planning/build workflows and skills.
# Checks are phase-scoped so deferred Phase C rules are not enforced early.
set -euo pipefail

if [ "$#" -gt 1 ]; then
  echo "usage: check-planning-build-policy.sh [workflow-scripts-root]" >&2
  exit 2
fi

ROOT_DIR="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
if [ ! -d "$ROOT_DIR" ]; then
  echo "check-planning-build-policy: not a directory: $ROOT_DIR" >&2
  exit 2
fi

PLANNING_DIR="$ROOT_DIR/01-planning-and-organizing"
CODE_BUILD_DIR="$ROOT_DIR/02-code-build"
WORKFLOW_DIRS=( "$PLANNING_DIR" "$CODE_BUILD_DIR" )
PLAN_REVIEW="$PLANNING_DIR/01-plan-review.md"
PLAN_FINALISE="$PLANNING_DIR/02-finalise-plan.md"
PLAN_REVIEW_SKILL="$ROOT_DIR/11-Skills/workflow-plan-review-finalize/SKILL.md"
EXECUTION_SKILL="$ROOT_DIR/11-Skills/execute-and-confirm-plan/SKILL.md"
ENABLING_REFACTOR_SENTENCE='An enabling refactor is in scope when required to make the planned fix correct and verifiable.'

fail() { echo "check-planning-build-policy: $*" >&2; exit 1; }

# --- Phase A: remove overly prescriptive planning/build agent wording ---------
check_phase_a_wording() {
  local token dir matches
  for token in aggressively 'librarian agents'; do
    for dir in "${WORKFLOW_DIRS[@]}"; do
      [ -d "$dir" ] || continue
      if matches="$(grep -RInFi "$token" "$dir" || true)" && [ -n "$matches" ]; then
        printf '%s\n' "$matches" >&2
        fail "planning/build workflows must not contain '$token'"
      fi
    done
  done
}

# --- Phase A: parallel-agent instructions cite the sizing/applicability policy -
check_phase_a_parallel_applicability() {
  local dir files file
  for dir in "${WORKFLOW_DIRS[@]}"; do
    [ -d "$dir" ] || continue
    files="$(grep -RilE 'parallel agents?' "$dir" || true)"
    while IFS= read -r file; do
      [ -n "$file" ] || continue
      grep -qiE ']\([^)]*workflow-applicability\.md[^)]*\)' "$file" \
        || fail "parallel-agent instruction lacks workflow-applicability.md: $file"
    done <<< "$files"
  done
}

# --- Phase B: phase order follows dependency/risk, not priority -----------------
check_phase_b_phase_order() {
  local path matches
  # These directories contain active workflows, not historical plan archives.
  # The two shared active policy surfaces that restate the rule are listed too.
  for path in \
    "$PLANNING_DIR" \
    "$CODE_BUILD_DIR" \
    "$ROOT_DIR/README.md" \
    "$ROOT_DIR/00-Meta-Workflow/00-meta/severity-priority-rubric.md"; do
    [ -e "$path" ] || continue
    if [ -d "$path" ]; then
      matches="$(grep -RIniE 'Phase 1 = P0|phase numbering must follow priority' "$path" || true)"
    else
      matches="$(grep -IniE 'Phase 1 = P0|phase numbering must follow priority' "$path" || true)"
    fi
    if [ -n "$matches" ]; then
      printf '%s\n' "$matches" >&2
      fail "active planning/build material contains retired phase-priority wording"
    fi
  done
}

# --- Phase B: planning guidance preserves the enabling-refactor rule ------------
check_phase_b_enabling_refactor() {
  local file rel
  for file in "$PLAN_REVIEW" "$PLAN_FINALISE"; do
    rel="${file#$ROOT_DIR/}"
    [ -f "$file" ] || fail "$rel is missing"
    grep -Fq "$ENABLING_REFACTOR_SENTENCE" "$file" \
      || fail "$rel is missing the required enabling-refactor sentence"
  done
}

# --- Phase B: both planning/execution skills refer to the plan contract ---------
check_phase_b_skill_tokens() {
  local file rel
  for file in "$PLAN_REVIEW_SKILL" "$EXECUTION_SKILL"; do
    rel="${file#$ROOT_DIR/}"
    [ -f "$file" ] || fail "$rel is missing"
    grep -Fq 'Change Surface' "$file" \
      || fail "$rel is missing Change Surface"
    grep -Fq 'Verify:' "$file" \
      || fail "$rel is missing Verify:"
    grep -qiE ']\([^)]*plan-template\.md[^)]*\)' "$file" \
      || fail "$rel does not link plan-template.md"
  done
}

check_phase_a_wording
check_phase_a_parallel_applicability
check_phase_b_phase_order
check_phase_b_enabling_refactor
check_phase_b_skill_tokens

# Future Phase C invariants belong in a separate phase-scoped check only when
# that phase's standards contract and workflow changes land.
echo "planning/build policy checks OK"
