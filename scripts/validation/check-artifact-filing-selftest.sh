#!/usr/bin/env bash
# Private archived-fixture filing rehearsal for the terminal-gate contract.
#
# Builds a throwaway repository containing a valid T1 plan generated from the
# shared template contract (inventory + gate-owned filing pair), then models
# the gate's filing state machine with explicit fixture states and verifies
# each state with the REAL tools the gate cites:
#   - check-plan.sh --require-tier --state (pre-move, final, post-tick)
#   - check-active-markdown-links.sh --root ... --scope ... (scoped moves)
#
# Modeled states:
#   S1 pre-move pending pair      S2 happy filing (research first, plan last,
#                                 retained shared row, rebased links/index,
#                                 tick only after effects verify)
#   S3 destination collision      S4 blocked archive policy (no move)
#   S5 post-move wrong path       (scoped link check detects; lint alone cannot)
#
# LIMITATIONS (explicit): this rehearsal models explicit fixture states and
# proves the checkers support the contract's verification steps. It does NOT
# execute the gate's natural-language workflow and does NOT prove an agent
# will follow it; actual filing of a real plan remains the gate's evidence.
# It is test-only and never moves anything outside its mktemp root.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CHECK_PLAN="$ROOT_DIR/scripts/validation/check-plan.sh"
CHECK_LINKS="$ROOT_DIR/scripts/validation/check-active-markdown-links.sh"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

expect() { # expect <pass|fail> <description> <required-output-substring> <cmd...>
  local want="$1" desc="$2" pattern="$3"
  shift 3
  local out code
  set +e
  out="$("$@" 2>&1)"
  code=$?
  set -e
  if [ "$want" = pass ] && [ "$code" -ne 0 ]; then
    echo "FAIL: $desc should pass: $out" >&2
    exit 1
  fi
  if [ "$want" = fail ] && [ "$code" -eq 0 ]; then
    echo "FAIL: $desc should fail (exit 0)" >&2
    exit 1
  fi
  if [ -n "$pattern" ] && ! printf '%s\n' "$out" | grep -qF -- "$pattern"; then
    echo "FAIL: $desc output lacks '$pattern': $out" >&2
    exit 1
  fi
}

build_repo() { # build_repo <root> — fresh fixture repo with a pending T1 plan
  local r="$1"
  mkdir -p "$r/plans" "$r/research" "$r/docs" "$r/src" \
    "$r/00-project/plans-completed/implementation"
  printf 'fixed\n' > "$r/src/a.txt"
  printf '# Research findings (task-exclusive)\n' > "$r/research/research.md"
  printf '# Shared live doc (retained row)\n' > "$r/docs/shared.md"
  printf '# Completed plans index\n\n| Date | Category | Title | File | Notes |\n|---|---|---|---|---|\n' \
    > "$r/00-project/plans-completed/index.md"
  printf '# Incoming reference\n\n[fixture plan](plans/2026-10-06-fixture.md) and [shared doc](docs/shared.md)\n' \
    > "$r/incoming.md"
  cat > "$r/plans/2026-10-06-fixture.md" <<'EOF'
# Implementation Plan: fixture tool fix

**Created:** 2026-10-06 12:00
**Status:** IN PROGRESS
**Tier:** T1

## Goal

Fix the fixture using [research](../research/research.md) and the [shared doc](../docs/shared.md).

## Change Surface

| Behavior | Sites | Class | Found with |
|---|---|---|---|
| fixture fix | src/a.txt | implements | `cat src/a.txt` |

## Artifact lifecycle

| Source locator | Owner repository | Relationship | Disposition / exact destination or retained reason | Verification |
|---|---|---|---|---|
| research/research.md | fixture repo | research | move to 00-project/plans-completed/implementation/2026-10-06-fixture-research.md | pending — terminal gate |
| docs/shared.md | fixture repo | live shared doc | retain in place — canonical live record | retained-link check |

## Tasks

### Phase 1: fix

1. [✅] Fix the fixture (P1, Effort: S)
   - Files: src/a.txt
   - Verify: `cat src/a.txt` → fixed (cost/prereqs: none)
2. [ ] File the completed plan package via the terminal gate (P2, Effort: S)
   - Open: pending — gate-owned terminal filing, excluded with its paired criterion from implementation-entry eligibility
   - Files: this plan; `## Artifact lifecycle` rows
   - Verify: gate filing verified — inventory matches disk, affected links/indexes repaired, `check-plan.sh --require-tier --state` passes at the final path (cost/prereqs: verified implementation, resolved owner archive policy)

## Success Criteria

- [✅] Fixture fixed and observable
- [ ] Completed plan package filed and verified at its recorded destination — Open: pending — gate-owned filing criterion paired with the terminal filing task
EOF
}

lint() { bash "$CHECK_PLAN" --require-tier --state "$1"; }
links() { bash "$CHECK_LINKS" --root "$1" ${2+"${@:2}"}; }

# --- S1: pre-move state — pending pair, both tools verify ---------------------
s1="$tmp/s1"
build_repo "$s1"
expect pass "S1 combined lint at active path (pending pair carries Open reasons)" \
  "OK (T1, state)" lint "$s1/plans/2026-10-06-fixture.md"
expect pass "S1 scoped links at active path" "" \
  links "$s1" --scope plans --scope incoming.md

# --- S2: happy filing — research first, plan last, tick after effects ---------
s2="$tmp/s2"
build_repo "$s2"
# Task-exclusive research moves first; main plan file moves last.
mv "$s2/research/research.md" \
  "$s2/00-project/plans-completed/implementation/2026-10-06-fixture-research.md"
mv "$s2/plans/2026-10-06-fixture.md" \
  "$s2/00-project/plans-completed/implementation/2026-10-06-fixture.md"
# Rebase the moved plan's working links; retained shared row stays linked.
sed -e 's#(\.\./research/research\.md)#(2026-10-06-fixture-research.md)#' \
  -e 's#(\.\./docs/shared\.md)#(../../../docs/shared.md)#' \
  "$s2/00-project/plans-completed/implementation/2026-10-06-fixture.md" > "$s2/p.tmp" \
  && mv "$s2/p.tmp" "$s2/00-project/plans-completed/implementation/2026-10-06-fixture.md"
# Rebase the inbound reference and add the index row.
sed 's#(plans/2026-10-06-fixture\.md)#(00-project/plans-completed/implementation/2026-10-06-fixture.md)#' \
  "$s2/incoming.md" > "$s2/i.tmp" && mv "$s2/i.tmp" "$s2/incoming.md"
printf '| 2026-10-06 | implementation | Fixture tool fix | 00-project/plans-completed/implementation/2026-10-06-fixture.md | rehearsal |\n' \
  >> "$s2/00-project/plans-completed/index.md"
[ -f "$s2/docs/shared.md" ] || { echo "FAIL: S2 retained shared doc must stay in place" >&2; exit 1; }
# Filing effects verify first: scoped links over the moved archive, the
# rebased inbound reference, and the updated index.
expect pass "S2 scoped links after moves (archive + incoming + index)" "" \
  links "$s2" --scope 00-project/plans-completed/implementation \
  --scope incoming.md --scope 00-project/plans-completed/index.md
# Before final marking: combined lint at the ACTUAL current path with the
# filing pair still unchecked and explained (pre-effects lint).
expect pass "S2 pre-marking combined lint at actual path (pair still pending)" \
  "OK (T1, state)" \
  lint "$s2/00-project/plans-completed/implementation/2026-10-06-fixture.md"
# Only after that check passes: record Package filing: VERIFIED (status
# evidence first; boxes untouched).
awk '/^\*\*Status:\*\* IN PROGRESS/ && !ins {
  print; print ""; print "Implementation verification: VERIFIED"; print "Package filing: VERIFIED"; ins = 1; next
} { print }' \
  "$s2/00-project/plans-completed/implementation/2026-10-06-fixture.md" > "$s2/p.tmp" \
  && mv "$s2/p.tmp" "$s2/00-project/plans-completed/implementation/2026-10-06-fixture.md"
# Then tick the pair and apply the completion marker.
sed -e 's/^2\. \[ \] File the completed plan package/2. [✅] File the completed plan package/' \
  -e 's/^- \[ \] Completed plan package filed/- [✅] Completed plan package filed/' \
  -e 's/^\*\*Status:\*\* IN PROGRESS/**Status:** ✅ COMPLETED/' \
  "$s2/00-project/plans-completed/implementation/2026-10-06-fixture.md" > "$s2/p.tmp" \
  && mv "$s2/p.tmp" "$s2/00-project/plans-completed/implementation/2026-10-06-fixture.md"
# After final marking: the same combined check re-run on the actual current
# path validates the status/tick edits; publish only after it passes.
expect pass "S2 post-edit combined lint after VERIFIED/tick/marker" "OK (T1, state)" \
  lint "$s2/00-project/plans-completed/implementation/2026-10-06-fixture.md"
expect pass "S2 scoped links stay clean after final marking" "" \
  links "$s2" --scope 00-project/plans-completed/implementation \
  --scope incoming.md --scope 00-project/plans-completed/index.md

# --- S2b: failed post-edit check triggers the modeled rollback ----------------
# A deliberately bad edit (criterion silently open, no Open: reason) must fail
# the post-edit lint; the modeled rollback restores the pre-marking state and
# the same lint passes again. LIMITATION: models the contract's failure rule
# with a real lint, not an executing workflow.
s2b="$tmp/s2b"
build_repo "$s2b"
mv "$s2b/research/research.md" \
  "$s2b/00-project/plans-completed/implementation/2026-10-06-fixture-research.md"
mv "$s2b/plans/2026-10-06-fixture.md" \
  "$s2b/00-project/plans-completed/implementation/2026-10-06-fixture.md"
sed -e 's#(\.\./research/research\.md)#(2026-10-06-fixture-research.md)#' \
  -e 's#(\.\./docs/shared\.md)#(../../../docs/shared.md)#' \
  "$s2b/00-project/plans-completed/implementation/2026-10-06-fixture.md" > "$s2b/p.tmp" \
  && mv "$s2b/p.tmp" "$s2b/00-project/plans-completed/implementation/2026-10-06-fixture.md"
# Bad marking edit: criterion left silently open (Open: reason stripped).
sed 's/ — Open: pending — gate-owned filing criterion paired with the terminal filing task//' \
  "$s2b/00-project/plans-completed/implementation/2026-10-06-fixture.md" > "$s2b/p.tmp" \
  && mv "$s2b/p.tmp" "$s2b/00-project/plans-completed/implementation/2026-10-06-fixture.md"
expect fail "S2b post-edit lint catches a silently open filing criterion" \
  "unticked criterion has no Open: reason" \
  lint "$s2b/00-project/plans-completed/implementation/2026-10-06-fixture.md"
# Modeled rollback: restore the explained (still-unticked) criterion; the
# same check passes again.
sed 's/^- \[ \] Completed plan package filed and verified at its recorded destination$/- [ ] Completed plan package filed and verified at its recorded destination — Open: pending — gate-owned filing criterion paired with the terminal filing task/' \
  "$s2b/00-project/plans-completed/implementation/2026-10-06-fixture.md" > "$s2b/p.tmp" \
  && mv "$s2b/p.tmp" "$s2b/00-project/plans-completed/implementation/2026-10-06-fixture.md"
expect pass "S2b modeled rollback restores a passing state check" "OK (T1, state)" \
  lint "$s2b/00-project/plans-completed/implementation/2026-10-06-fixture.md"

# --- S3: destination collision — modeled no-overwrite stop --------------------
# LIMITATION: models the contract decision (both source and destination
# present -> stop and investigate); the checker cannot enforce it.
s3="$tmp/s3"
build_repo "$s3"
printf 'SENTINEL-EXISTING-DESTINATION\n' \
  > "$s3/00-project/plans-completed/implementation/2026-10-06-fixture-research.md"
# Modeled stop: no move happens; the pre-existing destination is never
# overwritten and the pair stays pending.
grep -q 'SENTINEL-EXISTING-DESTINATION' \
  "$s3/00-project/plans-completed/implementation/2026-10-06-fixture-research.md" \
  || { echo "FAIL: S3 collision overwrote the existing destination" >&2; exit 1; }
[ -f "$s3/research/research.md" ] \
  || { echo "FAIL: S3 source must remain present on a modeled collision stop" >&2; exit 1; }
expect pass "S3 pair stays pending on collision (lint still OK at active path)" \
  "OK (T1, state)" lint "$s3/plans/2026-10-06-fixture.md"

# --- S4: blocked archive policy — no move, pair blocked, plan stays active ----
s4="$tmp/s4"
build_repo "$s4"
rm -rf "$s4/00-project/plans-completed"
# Modeled BLOCKED outcome: no moves, pair Open: blocked, plan stays active.
sed 's/^   - Open: pending — gate-owned terminal filing/   - Open: blocked — archive policy unresolved in fixture/' \
  "$s4/plans/2026-10-06-fixture.md" > "$s4/p.tmp" \
  && mv "$s4/p.tmp" "$s4/plans/2026-10-06-fixture.md"
[ -f "$s4/plans/2026-10-06-fixture.md" ] \
  || { echo "FAIL: S4 plan must stay at its active path when policy blocks" >&2; exit 1; }
expect pass "S4 blocked filing keeps the plan lintable with Open: blocked" \
  "OK (T1, state)" lint "$s4/plans/2026-10-06-fixture.md"

# --- S5: post-move wrong path — scoped link check detects, lint alone cannot --
s5="$tmp/s5"
build_repo "$s5"
mkdir -p "$s5/00-project/plans-completed/elsewhere"
mv "$s5/plans/2026-10-06-fixture.md" \
  "$s5/00-project/plans-completed/elsewhere/2026-10-06-fixture.md"
# Inbound reference follows the RECORDED mapping, not the wrong actual path.
sed 's#(plans/2026-10-06-fixture\.md)#(00-project/plans-completed/implementation/2026-10-06-fixture.md)#' \
  "$s5/incoming.md" > "$s5/i.tmp" && mv "$s5/i.tmp" "$s5/incoming.md"
expect fail "S5 scoped link check detects the wrong-path move (recorded target missing)" \
  "incoming.md:3 -> 00-project/plans-completed/implementation/2026-10-06-fixture.md" \
  links "$s5" --scope 00-project/plans-completed --scope incoming.md
# LIMITATION (recorded by assertion): the structural lint passes at the wrong
# path, so lint alone cannot certify the final location — the scoped link
# check above is the detection mechanism the contract relies on.
expect pass "S5 limitation proven: lint alone passes at the wrong path" \
  "OK (T1, state)" \
  lint "$s5/00-project/plans-completed/elsewhere/2026-10-06-fixture.md"

echo "check-artifact-filing self-test OK (fixture-model rehearsal; limitations labeled in header)"
