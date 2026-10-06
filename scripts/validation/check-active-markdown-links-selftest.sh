#!/usr/bin/env bash
# Self-test for check-active-markdown-links.sh default and scoped modes.
#
# Builds throwaway fixture roots under mktemp (no writes to this repository)
# and drives the checker CLI: default archive-dir skipping, explicit archive
# scopes (good/bad file and directory), incoming-reference repair after a
# move, scope dedup, and fail-closed handling of missing/escaped/unknown
# root/scope arguments and symlink escapes. Anchors are intentionally not
# checked (documented checker behavior); the fixtures rely on that.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CHECK="$ROOT_DIR/scripts/validation/check-active-markdown-links.sh"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

run() { # run <pass|fail> <description> <required-output-substring> [checker args...]
  local expect="$1" desc="$2" pattern="$3"
  shift 3
  local out code
  set +e
  out="$(bash "$CHECK" "$@" 2>&1)"
  code=$?
  set -e
  if [ "$expect" = pass ] && [ "$code" -ne 0 ]; then
    echo "FAIL: $desc should pass: $out" >&2
    exit 1
  fi
  if [ "$expect" = fail ] && [ "$code" -eq 0 ]; then
    echo "FAIL: $desc should fail (exit 0)" >&2
    exit 1
  fi
  if [ -n "$pattern" ] && ! printf '%s\n' "$out" | grep -qF -- "$pattern"; then
    echo "FAIL: $desc output lacks '$pattern': $out" >&2
    exit 1
  fi
}

# Waits at most <seconds> for the checker; a hang (e.g. a symlink directory
# cycle) is killed and reported as a failure instead of hanging the self-test.
timed_run() { # timed_run <seconds> <expect> <description> <pattern> [checker args...]
  local seconds="$1" expect="$2" desc="$3" pattern="$4"
  shift 4
  local out_file="$tmp/timed-output.txt" pid watchdog rc out
  : > "$out_file"
  bash "$CHECK" "$@" > "$out_file" 2>&1 &
  pid=$!
  (
    sleep "$seconds"
    kill -9 "$pid" 2>/dev/null
  ) &
  watchdog=$!
  set +e
  wait "$pid"
  rc=$?
  set -e
  kill "$watchdog" 2>/dev/null || true
  wait "$watchdog" 2>/dev/null || true
  out="$(cat "$out_file")"
  if [ "$rc" -eq 137 ] || [ "$rc" -eq 143 ]; then
    echo "FAIL: $desc timed out after ${seconds}s (hang): $out" >&2
    exit 1
  fi
  if [ "$expect" = pass ] && [ "$rc" -ne 0 ]; then
    echo "FAIL: $desc should pass: $out" >&2
    exit 1
  fi
  if [ "$expect" = fail ] && [ "$rc" -eq 0 ]; then
    echo "FAIL: $desc should fail (exit 0)" >&2
    exit 1
  fi
  if [ -n "$pattern" ] && ! printf '%s\n' "$out" | grep -qF -- "$pattern"; then
    echo "FAIL: $desc output lacks '$pattern': $out" >&2
    exit 1
  fi
}

# --- Fixture root 1: archive dir (good + broken files), live plan, incoming ---
t1="$tmp/repo-one"
mkdir -p "$t1/changelog" "$t1/00-project/plans" \
  "$t1/00-project/plans-completed/implementation" "$t1/incoming"
printf '# Changelog index\n' > "$t1/changelog/index.md"
printf '# Active plan\n' > "$t1/00-project/plans/plan-a.md"
cat > "$t1/00-project/plans-completed/implementation/2026-01-01-plan-a.md" <<'EOF'
# Archived plan (good)

An anchor-only link is ignored by design: [section](#goal).
The changelog still resolves from the archive: [changelog](../../../changelog/index.md).
EOF
cat > "$t1/00-project/plans-completed/implementation/2026-01-02-broken.md" <<'EOF'
# Archived plan (broken)

[missing target](../../../changelog/nope.md)
EOF
cat > "$t1/incoming/incoming.md" <<'EOF'
# Incoming reference

[active plan](../00-project/plans/plan-a.md)
EOF

# 1. Default scan keeps skipping archive dirs (broken.md is not reported).
run pass "default scan skips archived dirs by default" "" \
  --root "$t1"

# 2. Explicit archive scope overrides the default skip; good archive passes.
run pass "explicit good archived file scope passes" "" \
  --root "$t1" --scope 00-project/plans-completed/implementation/2026-01-01-plan-a.md

# 3. Absolute scope path inside the root behaves like the relative form.
run pass "absolute scope path inside root passes" "" \
  --root "$t1" --scope "$t1/00-project/plans-completed/implementation/2026-01-01-plan-a.md"

# 4. Explicit broken archived file scope fails.
run fail "explicit broken archived file scope fails" \
  "2026-01-02-broken.md:3 -> ../../../changelog/nope.md" \
  --root "$t1" --scope 00-project/plans-completed/implementation/2026-01-02-broken.md

# 5. Directory scope walks archived markdown and finds the broken file.
run fail "archive directory scope reports the broken archived file" \
  "2026-01-02-broken.md:3 -> ../../../changelog/nope.md" \
  --root "$t1" --scope 00-project/plans-completed

# 6. Overlapping scopes dedup: the broken file is reported exactly once.
dedup_out="$(bash "$CHECK" --root "$t1" \
  --scope 00-project/plans-completed \
  --scope 00-project/plans-completed/implementation/2026-01-02-broken.md 2>&1 || true)"
dedup_count="$(printf '%s\n' "$dedup_out" | grep -cF '2026-01-02-broken.md:3 ->' || true)"
if [ "${dedup_count:-0}" -ne 1 ]; then
  echo "FAIL: overlapping scopes should report the problem exactly once (got $dedup_count): $dedup_out" >&2
  exit 1
fi

# 7. A good non-archive directory scope passes.
run pass "good directory scope passes" "" \
  --root "$t1" --scope incoming

# --- Fixture root 2: incoming doc still pointing at the pre-move path -------
t2="$tmp/repo-two"
mkdir -p "$t2/changelog" "$t2/00-project/plans-completed/implementation" "$t2/incoming"
printf '# Changelog index\n' > "$t2/changelog/index.md"
cat > "$t2/00-project/plans-completed/implementation/2026-02-01-plan-b.md" <<'EOF'
# Archived plan (moved from plans/)

[changelog](../../../changelog/index.md)
EOF
cat > "$t2/incoming/incoming.md" <<'EOF'
# Incoming reference (stale)

[moved plan](../00-project/plans/plan-b.md)
EOF

# 8. Scoped archive + incoming check fails on the stale pre-move path.
run fail "incoming reference to old pre-move path fails" \
  "incoming.md:3 -> ../00-project/plans/plan-b.md" \
  --root "$t2" --scope incoming --scope 00-project/plans-completed

# 9. Repairing the incoming reference makes the same scoped check pass.
cat > "$t2/incoming/incoming.md" <<'EOF'
# Incoming reference (repaired)

[moved plan](../00-project/plans-completed/implementation/2026-02-01-plan-b.md)
EOF
run pass "repaired incoming reference passes" "" \
  --root "$t2" --scope incoming --scope 00-project/plans-completed

# --- Fixture root 3: escapes, symlinks, CLI misuse --------------------------
t3="$tmp/repo-three"
outside="$tmp/outside"
mkdir -p "$t3" "$outside"
printf '# Outside target\n' > "$outside/outside-target.md"
printf '# Escape target\n' > "$outside/escape-target.md"
printf '# Inner target\n' > "$t3/inner-target.md"
ln -s inner-target.md "$t3/inner-link.md"
ln -s "$outside/escape-target.md" "$t3/escape.md"
ln -s "$outside" "$t3/escape-dir"
cat > "$t3/doc-good.md" <<'EOF'
# Good links

[inner direct](inner-target.md) and [inner via symlink](inner-link.md)
EOF
cat > "$t3/doc-symlink-escape.md" <<'EOF'
# Symlink escape link

[outer symlink](escape.md)
EOF
cat > "$t3/doc-lex-escape.md" <<'EOF'
# Lexical escape link

[lex escape](../../outside-target.md)
EOF

# 10. A symlinked link target that stays inside the root is not a failure.
run pass "symlink target inside root passes" "" \
  --root "$t3" --scope doc-good.md

# 11. A link target symlink pointing outside the root is detected (scoped).
run fail "symlink link target outside root detected (scoped)" \
  "(escapes repository root via symlink)" \
  --root "$t3" --scope doc-symlink-escape.md

# 12. The same detection holds in a default root scan.
run fail "symlink link target outside root detected (default scan)" \
  "(escapes repository root via symlink)" \
  --root "$t3"

# 13. Lexical root escapes keep failing with the original message.
run fail "lexical link escape still fails" \
  "doc-lex-escape.md:3 -> ../../outside-target.md (escapes repository root)" \
  --root "$t3" --scope doc-lex-escape.md

# --- Fixture root 4: in-root symlink directory cycles ------------------------
t4="$tmp/repo-cycle"
mkdir -p "$t4/docs" "$t4/sub"
printf '# T\n' > "$t4/docs/target.md"
printf '# Doc\n\n[target](target.md)\n' > "$t4/docs/doc.md"
ln -s . "$t4/loop-self"                 # directory symlink to its own parent
ln -s "$t4" "$t4/loop-abs"              # absolute symlink back to the root
ln -s "$t4" "$t4/sub/up"                # nested parent cycle
ln -s "$t4/docs" "$t4/alias"            # legitimate in-root directory alias

# 13b. Walking scoped directory symlinks that form self/parent cycles must
# terminate (visited-directory guard), not hang, and dedup files by realpath.
timed_run 5 pass "in-root symlink dir cycles terminate under scoped walk" \
  "Active markdown links OK" \
  --root "$t4" --scope docs --scope loop-self --scope loop-abs --scope sub

# 13c. A legitimate in-root directory alias scans the aliased tree once and passes.
timed_run 5 pass "in-root directory alias scope passes" \
  "Active markdown links OK" \
  --root "$t4" --scope alias

# 13d. Default scans never follow directory symlinks, so cycles cannot hang them.
timed_run 5 pass "default scan unaffected by dir-symlink cycles" \
  "Active markdown links OK" \
  --root "$t4"

# 13e. A broken link inside a cyclic scoped tree is still reported exactly once.
printf '# Bad\n\n[missing](docs/nope.md)\n' > "$t4/docs/bad.md"
cycle_out="$(bash "$CHECK" --root "$t4" --scope loop-self --scope docs 2>&1 || true)"
cycle_count="$(printf '%s\n' "$cycle_out" | grep -cF 'docs/bad.md:3 ->' || true)"
if [ "${cycle_count:-0}" -ne 1 ]; then
  echo "FAIL: cyclic scopes should report the broken link exactly once (got $cycle_count): $cycle_out" >&2
  exit 1
fi
rm "$t4/docs/bad.md"

# 14/15. Scopes outside the selected root are rejected (relative + absolute).
run fail "relative scope outside root rejected" \
  "scope escapes selected root" \
  --root "$t3" --scope ../outside
run fail "absolute scope outside root rejected" \
  "scope escapes selected root" \
  --root "$t3" --scope "$outside/outside-target.md"

# 16/17. Symlinked scopes pointing outside the root are rejected.
run fail "symlink scope outside root rejected" \
  "symlink escapes selected root" \
  --root "$t3" --scope escape.md
run fail "symlinked directory scope outside root rejected" \
  "symlink escapes selected root" \
  --root "$t3" --scope escape-dir

# 18/19. Missing scope and missing root fail closed.
run fail "missing scope rejected" \
  "scope is missing or unreadable" \
  --root "$t3" --scope nope.md
run fail "missing root rejected" \
  "root is missing or unreadable" \
  --root "$t3/absent-root"
run fail "file as root rejected" \
  "root is not a directory" \
  --root "$t3/doc-good.md"

# 20-23. Unknown/malformed CLI usage fails.
run fail "unknown option rejected" "unknown option" --bogus
run fail "stray positional rejected" "unexpected argument" "$t1"
run fail "--scope without value rejected" "requires a value" --root "$t1" --scope
run fail "--self-test combined with --scope rejected" "--self-test takes no other arguments" \
  --self-test --scope x

# 20b. Empty flag values must fail closed, not fall back to the default root
# or widen into a whole-root scan.
run fail "--root empty value rejected" "--root requires a non-empty value" --root ""
run fail "--scope empty value rejected" "--scope requires a non-empty value" --root "$t1" --scope ""
run fail "--root empty value never scans the live repo" "requires a non-empty value" --root "" --scope x

# 24. Backwards compatibility: the built-in --self-test still works.
run pass "built-in --self-test still detects the escaped-root fixture" \
  "Escaped-root fixture detection OK" \
  --self-test

echo "check-active-markdown-links self-test OK"
