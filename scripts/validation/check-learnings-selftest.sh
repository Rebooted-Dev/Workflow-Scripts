#!/usr/bin/env bash
# Self-test for check-learnings.sh against a throwaway learnings tree.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CHECK="$ROOT_DIR/scripts/validation/check-learnings.sh"
temp_dir="$(mktemp -d)"
trap 'rm -rf "$temp_dir"' EXIT
base="$temp_dir/learnings"

entry() { # entry <file> <status> <category>
  local approved=""
  [ "$2" = ACTIVE ] && approved="**Approved:** 2026-10-13"
  cat > "$1" <<E
# Lesson

**Date:** 2026-10-13
**Category:** $3
**Status:** $2
**Source:** file: selftest fixture
$approved

---

## Situation
- x

## Pattern to avoid
- x

## Better approach
- x

## Verification
- x

## Notes
- x
E
}

make_base() {
  rm -rf "$base"; mkdir -p "$base"/{workflow,code,tooling,facts,communication}
  printf '# Learnings\n' > "$base/README.md"
  cat > "$base/index.md" <<'IDX'
# Agent Learnings Index

| Date | Category | Title | File | Status |
|------|----------|-------|------|--------|
| 2026-10-13 | workflow | Newer lesson | workflow/2026-10-13-workflow-newer-lesson.md | ACTIVE; keep the rule short |
| 2026-10-12 | workflow | Older lesson | workflow/2026-10-12-workflow-older-lesson.md | NOTED; one-off |
IDX
  entry "$base/workflow/2026-10-13-workflow-newer-lesson.md" ACTIVE workflow
  entry "$base/workflow/2026-10-12-workflow-older-lesson.md" NOTED workflow
}

run() { # run <expect pass|fail> <description> [output pattern]
  local out code
  set +e; out="$(bash "$CHECK" "$base" 2>&1)"; code=$?; set -e
  if [ "$1" = pass ] && [ "$code" -ne 0 ]; then echo "FAIL: $2 should pass: $out" >&2; exit 1; fi
  if [ "$1" = fail ] && [ "$code" -eq 0 ]; then echo "FAIL: $2 should fail" >&2; exit 1; fi
  if [ "$1" = fail ] && ! printf '%s' "$out" | grep -q -- "$3"; then
    echo "FAIL: $2 output lacks '$3': $out" >&2; exit 1
  fi
}

make_base; run pass "valid tree"

make_base; sed -i.bak '3p' "$base/index.md"; rm -f "$base/index.md.bak"
run fail "duplicate header row" "header rows"

make_base; sed -i.bak '5{h;d;}; 6{G;}' "$base/index.md"; rm -f "$base/index.md.bak"
run fail "rows not newest first" "newest must be first"

make_base; sed -i.bak 's/^\*\*Status:\*\* ACTIVE/**Status:** NOTED/' "$base/workflow/2026-10-13-workflow-newer-lesson.md"; rm -f "$base/workflow/2026-10-13-workflow-newer-lesson.md.bak"
run fail "entry status differs from index" "index says 'ACTIVE'"

make_base; entry "$base/workflow/2026-10-11-workflow-orphan.md" NOTED workflow
run fail "entry without index row" "orphan entry"

make_base; sed -i.bak 's/| workflow | Older lesson/| code | Older lesson/' "$base/index.md"; rm -f "$base/index.md.bak"
run fail "row category differs from folder" "but file is in"

make_base; sed -i.bak '/^## Notes$/d' "$base/workflow/2026-10-12-workflow-older-lesson.md"; rm -f "$base/workflow/2026-10-12-workflow-older-lesson.md.bak"
run fail "missing required section" "missing section '## Notes'"

make_base; sed -i.bak 's/ACTIVE; keep the rule short/ACTIVE;/' "$base/index.md"; rm -f "$base/index.md.bak"
run fail "ACTIVE row without rule text" "no rule text"

make_base; entry "$base/workflow/Bad_Name.md" NOTED workflow
printf '| 2026-10-01 | workflow | Bad name | workflow/Bad_Name.md | NOTED; x |\n' >> "$base/index.md"
run fail "file name pattern" "name must be"

make_base; sed -i.bak '/^\*\*Source:\*\*/d' "$base/workflow/2026-10-13-workflow-newer-lesson.md"; rm -f "$base/workflow/2026-10-13-workflow-newer-lesson.md.bak"
run fail "entry without Source" "Source must start"

make_base; sed -i.bak 's/^\*\*Source:\*\* .*/**Source:** unverified: not checked/' "$base/workflow/2026-10-13-workflow-newer-lesson.md"; rm -f "$base/workflow/2026-10-13-workflow-newer-lesson.md.bak"
run fail "ACTIVE entry with unverified Source" "not unverified"

make_base; sed -i.bak '/^\*\*Approved:\*\*/d' "$base/workflow/2026-10-13-workflow-newer-lesson.md"; rm -f "$base/workflow/2026-10-13-workflow-newer-lesson.md.bak"
run fail "ACTIVE entry without Approved" "needs an"

echo "check-learnings-selftest: OK"
