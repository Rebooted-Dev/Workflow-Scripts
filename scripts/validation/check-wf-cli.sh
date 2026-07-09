#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../.."

WF_TOOL="workflows-drag-free/tools/wf"

bash scripts/validation/check-moved-targets.sh
"$WF_TOOL" validate
"$WF_TOOL" init-frontmatter --check
"$WF_TOOL" init-ledger-frontmatter --check
"$WF_TOOL" prune-skipped-frontmatter --check
"$WF_TOOL" build --check
"$WF_TOOL" route "review this plan" >/dev/null

tmpdir="$(mktemp -d)"
bookdir=""
trap 'rm -rf "$tmpdir" "$bookdir"' EXIT

mkdir -p "$tmpdir/workflows/planning"
cat >"$tmpdir/workflows/planning/01-plan-review.md" <<'MD'
---
id: plan-review
version: 2.0
category: planning
kind: workflow
triggers:
  - "review this plan"
---
# Workflow: Plan Review
MD

WF_ROOT="$tmpdir" "$WF_TOOL" validate >/tmp/wf-valid.out
WF_ROOT="$tmpdir" "$WF_TOOL" build >/tmp/wf-build.out
WF_ROOT="$tmpdir" "$WF_TOOL" build --check >/tmp/wf-build-check.out
WF_ROOT="$tmpdir" "$WF_TOOL" route "review this plan" | grep -q '"id": "plan-review"'

cat >"$tmpdir/workflows/planning/02-duplicate.md" <<'MD'
---
id: plan-review
version: 2.0
category: planning
kind: workflow
---
# Duplicate
MD

if WF_ROOT="$tmpdir" "$WF_TOOL" validate >/tmp/wf-duplicate.out 2>&1; then
  echo "expected duplicate id fixture to fail" >&2
  exit 1
fi
grep -q "duplicate id" /tmp/wf-duplicate.out

cat >"$tmpdir/workflows/planning/02-duplicate.md" <<'MD'
---
id: bad-kind
version: 2.0
category: planning
kind: mystery
---
# Invalid Kind
MD

if WF_ROOT="$tmpdir" "$WF_TOOL" validate >/tmp/wf-invalid-kind.out 2>&1; then
  echo "expected invalid kind fixture to fail" >&2
  exit 1
fi
grep -q "invalid kind" /tmp/wf-invalid-kind.out

cat >"$tmpdir/workflows/planning/02-duplicate.md" <<'MD'
---
id: stale-link
version: 2.0
category: planning
kind: reference
---
# Stale Link

See [old build](../../02-build-code/01-execution.md) and [missing](missing.md).
MD

WF_ROOT="$tmpdir" "$WF_TOOL" validate >/tmp/wf-warnings.out
grep -q "stale path reference" /tmp/wf-warnings.out
grep -q "broken markdown link" /tmp/wf-warnings.out

cat >"$tmpdir/workflows/planning/02-duplicate.md" <<'MD'
---
id: bad-role
version: 2.0
category: planning
kind: workflow
agents: [missing-role]
---
# Bad Role
MD

if WF_ROOT="$tmpdir" "$WF_TOOL" validate >/tmp/wf-bad-role.out 2>&1; then
  echo "expected unresolved role fixture to fail" >&2
  exit 1
fi
grep -q "unresolved role reference" /tmp/wf-bad-role.out

mkdir -p "$tmpdir/core"
cat >"$tmpdir/core/verification-gates.md" <<'MD'
---
id: verification-gates
version: 2.0
category: core
kind: policy
---
# Verification Gates

Completion requires evidence, not intent.
MD

cat >"$tmpdir/workflows/planning/02-duplicate.md" <<'MD'
---
id: duplicate-core-phrase
version: 2.0
category: planning
kind: reference
---
# Duplicate Core Phrase

Completion requires evidence, not intent.
MD

if WF_ROOT="$tmpdir" "$WF_TOOL" validate >/tmp/wf-core-dup.out 2>&1; then
  echo "expected duplicate core phrase fixture to fail" >&2
  exit 1
fi
grep -q "duplicates core phrase" /tmp/wf-core-dup.out

cat >"$tmpdir/workflows/planning/02-duplicate.md" <<'MD'
---
id: second-valid-record
version: 2.0
category: planning
kind: reference
---
# Second Valid Record
MD
WF_ROOT="$tmpdir" "$WF_TOOL" build >/tmp/wf-build-2.out
printf '\nmanual edit\n' >>"$tmpdir/ROUTER.md"
if WF_ROOT="$tmpdir" "$WF_TOOL" build --check >/tmp/wf-stale-build.out 2>&1; then
  echo "expected generated freshness fixture to fail" >&2
  exit 1
fi
grep -q "ROUTER.md" /tmp/wf-stale-build.out

bookdir="$(mktemp -d)"
mkdir -p "$bookdir/workflows/planning" "$bookdir/00-project/plans/demo"
cat >"$bookdir/workflows/planning/01-plan-review.md" <<'MD'
---
id: plan-review
version: 2.0
category: planning
kind: workflow
triggers:
  - "review this plan"
---
# Workflow: Plan Review
MD

WF_ROOT="$bookdir" "$WF_TOOL" build >/tmp/wf-book-build.out
WF_ROOT="$bookdir" "$WF_TOOL" log added "Bookkeeping Command" --notes "created by fixture" >/tmp/wf-book-log.out
test -f "$bookdir/00-project/changelog/added/$(date +%F)-added-bookkeeping-command.md"
grep -q "Bookkeeping Command" "$bookdir/00-project/changelog/index.md"

WF_ROOT="$bookdir" "$WF_TOOL" trouble validation fixture-issue --title "Fixture Issue" --status resolved >/tmp/wf-book-trouble.out
test -f "$bookdir/00-project/troubleshooting/validation/$(date +%F)-validation-fixture-issue.md"
grep -q "Fixture Issue" "$bookdir/00-project/troubleshooting/index.md"

WF_ROOT="$bookdir" "$WF_TOOL" new plan fixture-plan --title "Fixture Plan" >/tmp/wf-book-plan.out
test -f "$bookdir/00-project/plans/fixture-plan/$(date +%F)-fixture-plan.md"

cat >"$bookdir/00-project/plans/demo/$(date +%F)-done.md" <<'MD'
# Done Plan

## Summary

Finished.
MD
WF_ROOT="$bookdir" "$WF_TOOL" file-completed "00-project/plans/demo/$(date +%F)-done.md" review >/tmp/wf-book-completed.out
test ! -f "$bookdir/00-project/plans/demo/$(date +%F)-done.md"
test -f "$bookdir/00-project/plans-completed/review/$(date +%F)-done.md"
grep -q "Done Plan" "$bookdir/00-project/plans-completed/index.md"
grep -q "Done Plan" "$bookdir/00-project/changelog/index.md"

if WF_ROOT="$bookdir" "$WF_TOOL" file-completed "00-project/plans/missing.md" review >/tmp/wf-book-missing.out 2>&1; then
  echo "expected missing completed-plan source to fail" >&2
  exit 1
fi
grep -q "source plan does not exist" /tmp/wf-book-missing.out

WF_ROOT="$bookdir" "$WF_TOOL" debt add architecture "Fixture Debt" --notes "defer cleanup" >/tmp/wf-book-debt.out
test -f "$bookdir/00-project/debt/architecture/$(date +%F)-architecture-fixture-debt.md"
WF_ROOT="$bookdir" "$WF_TOOL" debt list --status open | grep -q "Fixture Debt"
grep -q "Fixture Debt" "$bookdir/00-project/debt/index.md"

mkdir -p "$bookdir/tools/orchestrator" "$bookdir/workflows/planning" "$bookdir/11-Skills/example"
cat >"$bookdir/tools/orchestrator/orchestrator-review.sh" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
plan="$1"
output=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --output)
      output="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done
mkdir -p "$(dirname "$output")"
printf 'reviewed %s\n' "$plan" > "$output"
printf '{"status":"completed","exit_code":0}\n' > "${output%.md}.json"
exit 0
SH
chmod +x "$bookdir/tools/orchestrator/orchestrator-review.sh"
cat >"$bookdir/workflows/planning/01-plan-review.md" <<'MD'
# Workflow: Plan Review
MD
cat >"$bookdir/00-project/plans/demo/run-plan.md" <<'MD'
# Run Plan
MD
WF_ROOT="$bookdir" "$WF_TOOL" run plan-review 00-project/plans/demo/run-plan.md --output 00-project/plans/demo/review.md --timeout 1 >/tmp/wf-run.out
test -f "$bookdir/00-project/plans/demo/_manifest.json"
grep -q '"workflow_id": "plan-review"' "$bookdir/00-project/plans/demo/_manifest.json"
WF_ROOT="$bookdir" "$WF_TOOL" stats runs 00-project/plans/demo | grep -q '"runs": 1'

cat >"$bookdir/11-Skills/example/SKILL.md" <<'MD'
# Example Skill
MD
WF_ROOT="$bookdir" "$WF_TOOL" build skills >/tmp/wf-skills.out
test -f "$bookdir/dist/skills/codex/example/SKILL.md"
WF_ROOT="$bookdir" "$WF_TOOL" build skills --check >/tmp/wf-skills-check.out
