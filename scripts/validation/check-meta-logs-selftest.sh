#!/usr/bin/env bash
# Self-test for check-meta-logs.sh against a throwaway repository.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
temp_dir="$(mktemp -d)"
trap 'rm -rf "$temp_dir"' EXIT

repo="$temp_dir/Workflow-Scripts"
mkdir -p "$repo/scripts/validation" "$repo/00-project/changelog/fixed" "$repo/00-project/changelog/docs" \
  "$repo/00-project/troubleshooting/workflow"
cp "$ROOT_DIR/scripts/validation/check-meta-logs.sh" "$repo/scripts/validation/"
git init -q "$repo"
git -C "$repo" config user.email "test@example.com"
git -C "$repo" config user.name "Test User"
for d in changelog/fixed changelog/docs troubleshooting/workflow; do : > "$repo/00-project/$d/.gitkeep"; done
printf 'x\n' > "$repo/workflow.md"
printf '# Changelog Index\n' > "$repo/00-project/changelog/index.md"
printf '# Troubleshooting Index\n' > "$repo/00-project/troubleshooting/index.md"
git -C "$repo" add -A && git -C "$repo" commit -q -m init

CHECK="$repo/scripts/validation/check-meta-logs.sh"
reset() { git -C "$repo" reset -q --hard; git -C "$repo" clean -qfd; }
expect() { # expect <pass|fail> <description> [grep-pattern]
  set +e; out="$(bash "$CHECK" --staged 2>&1)"; code=$?; set -e
  if [ "$1" = pass ] && [ "$code" -ne 0 ]; then echo "FAIL: $2 should pass: $out" >&2; exit 1; fi
  if [ "$1" = fail ] && [ "$code" -eq 0 ]; then echo "FAIL: $2 should fail" >&2; exit 1; fi
  if [ -n "${3:-}" ] && ! printf '%s' "$out" | grep -q "$3"; then echo "FAIL: $2 output lacks '$3': $out" >&2; exit 1; fi
  reset
}
stage() { git -C "$repo" add -A; }
row() { printf '| row |\n' >> "$repo/00-project/$1/index.md"; }

# 1. Workflow change with no changelog entry fails.
printf 'y\n' >> "$repo/workflow.md"; stage
expect fail "unlogged workflow change" "no 00-project/changelog"

# 2. Workflow change + docs entry + index row passes.
printf 'y\n' >> "$repo/workflow.md"; printf '# d\n' > "$repo/00-project/changelog/docs/d.md"; row changelog; stage
expect pass "logged workflow change"

# 3. Changelog entry added without index row fails.
printf 'y\n' >> "$repo/workflow.md"; printf '# d\n' > "$repo/00-project/changelog/docs/d.md"; stage
expect fail "entry without index row" "changelog/index.md not updated"

# 4. Fixed entry without troubleshooting fails.
printf 'y\n' >> "$repo/workflow.md"; printf '# f\n' > "$repo/00-project/changelog/fixed/f.md"; row changelog; stage
expect fail "fix without troubleshooting" "has no troubleshooting entry"

# 5. Fixed entry with the waiver line passes.
printf 'y\n' >> "$repo/workflow.md"
printf '# f\n**Troubleshooting:** not needed — typo only\n' > "$repo/00-project/changelog/fixed/f.md"; row changelog; stage
expect pass "fix with waiver"

# 6. Fixed entry + troubleshooting entry + both index rows passes.
printf 'y\n' >> "$repo/workflow.md"; printf '# f\n' > "$repo/00-project/changelog/fixed/f.md"; row changelog
printf '# t\n' > "$repo/00-project/troubleshooting/workflow/t.md"; row troubleshooting; stage
expect pass "fix with troubleshooting"

# 7. Troubleshooting entry without its index row fails.
printf 'y\n' >> "$repo/workflow.md"; printf '# f\n' > "$repo/00-project/changelog/fixed/f.md"; row changelog
printf '# t\n' > "$repo/00-project/troubleshooting/workflow/t.md"; stage
expect fail "troubleshooting without index row" "troubleshooting/index.md not updated"

# 8. Meta-only change (plans, research) needs no changelog entry.
mkdir -p "$repo/00-project/plans"; printf 'p\n' > "$repo/00-project/plans/p.md"; stage
expect pass "meta-only change"

# 9. Range mode flags an unlogged commit and skips merges.
printf 'y\n' >> "$repo/workflow.md"; stage; git -C "$repo" commit -q -m "unlogged"
set +e; out="$(bash "$CHECK" --range HEAD~1..HEAD 2>&1)"; code=$?; set -e
[ "$code" -ne 0 ] && printf '%s' "$out" | grep -q "commit " || { echo "FAIL: range mode missed unlogged commit: $out" >&2; exit 1; }

echo "check-meta-logs self-test OK"
