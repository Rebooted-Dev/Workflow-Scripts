#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../.."

WF_TOOL="workflows-drag-free/tools/wf"

bash scripts/validation/check-moved-targets.sh
"$WF_TOOL" validate
"$WF_TOOL" build --check
"$WF_TOOL" route "review this plan" >/dev/null
if "$WF_TOOL" --help | grep -Eq 'init-frontmatter|init-ledger-frontmatter|prune-skipped-frontmatter'; then
  echo "retired migration command is still advertised" >&2
  exit 1
fi

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

cat >"$tmpdir/workflows/planning/02-finalise-plan.md" <<'MD'
---
id: finalise-plan
version: 2.0
category: planning
kind: workflow
triggers: ["finalise the plan", "finalize the plan", "implementation plan"]
---
# Workflow: Finalise Plan
MD
cat >"$tmpdir/workflows/planning/03-security-fix.md" <<'MD'
---
id: security-fix
version: 2.0
category: planning
kind: workflow
triggers: ["security fix", "fix security finding", "remediate vulnerability"]
---
# Workflow: Security Fix
MD
cat >"$tmpdir/workflows/planning/04-route-alpha-beta.md" <<'MD'
---
id: route-alpha-beta
version: 2.0
category: planning
kind: workflow
triggers: ["alpha beta"]
---
# Workflow: Route Alpha Beta
MD
cat >"$tmpdir/workflows/planning/05-route-alpha-gamma.md" <<'MD'
---
id: route-alpha-gamma
version: 2.0
category: planning
kind: workflow
triggers: ["alpha gamma"]
---
# Workflow: Route Alpha Gamma
MD
WF_ROOT="$tmpdir" "$WF_TOOL" route "finalise the plan" | grep -q '"id": "finalise-plan"'
WF_ROOT="$tmpdir" "$WF_TOOL" route "security fix" | grep -q '"id": "security-fix"'
if WF_ROOT="$tmpdir" "$WF_TOOL" route "no workflow matches this" >/tmp/wf-route-unknown.out 2>&1; then
  echo "expected unknown route to fail" >&2
  exit 1
else
  test "$?" -eq 2
fi
if WF_ROOT="$tmpdir" "$WF_TOOL" route "alpha" >/tmp/wf-route-ambiguous.out 2>&1; then
  echo "expected ambiguous route to fail" >&2
  exit 1
else
  test "$?" -eq 2
fi
! grep -q '"id"' /tmp/wf-route-unknown.out
! grep -q '"id"' /tmp/wf-route-ambiguous.out

cat >"$tmpdir/workflows/planning/02-missing-frontmatter.md" <<'MD'
# Workflow: Missing Frontmatter

This executable workflow intentionally lacks metadata.
MD
if WF_ROOT="$tmpdir" "$WF_TOOL" validate >/tmp/wf-missing-frontmatter.out 2>&1; then
  echo "expected executable workflow without frontmatter to fail" >&2
  exit 1
fi
grep -q "02-missing-frontmatter.md" /tmp/wf-missing-frontmatter.out
rm "$tmpdir/workflows/planning/02-missing-frontmatter.md"

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
id: prose-link-check
version: 2.0
category: planning
kind: reference
---
# Prose Link Check

See [missing prose](missing-prose.md).
MD
WF_ROOT="$tmpdir" "$WF_TOOL" validate >/tmp/wf-prose-link.out
test "$(grep -c '^warning: .*broken markdown link' /tmp/wf-prose-link.out)" -eq 1
grep -q "missing-prose.md" /tmp/wf-prose-link.out

cat >"$tmpdir/workflows/planning/02-duplicate.md" <<'MD'
---
id: fenced-link-check
version: 2.0
category: planning
kind: reference
---
# Fenced Link Check

````markdown
[consumer template](docs/agents/project-structure.md)
```bash
grep -r "\[.*\](" <target-directory> --include="*.md"
```
````

~~~~~markdown
[tilde example](missing-tilde.md)
~~~
~~~~~
MD
WF_ROOT="$tmpdir" "$WF_TOOL" validate >/tmp/wf-fenced-links.out
grep -q "with 0 warnings" /tmp/wf-fenced-links.out
! grep -q "broken markdown link\|target-directory\|consumer template" /tmp/wf-fenced-links.out

cat >"$tmpdir/workflows/planning/02-duplicate.md" <<'MD'
---
id: unterminated-fence-check
version: 2.0
category: planning
kind: reference
---
# Unterminated Fence Check

```markdown
[still validated](missing-inside-unterminated.md)
MD
WF_ROOT="$tmpdir" "$WF_TOOL" validate >/tmp/wf-unterminated-fence.out
test "$(grep -c '^warning: .*broken markdown link' /tmp/wf-unterminated-fence.out)" -eq 1
grep -q "missing-inside-unterminated.md" /tmp/wf-unterminated-fence.out

cat >"$tmpdir/workflows/planning/02-duplicate.md" <<'MD'
---
id: bad-role
version: 2.0
category: planning
kind: workflow
triggers: ["bad role"]
agents: [missing-role]
---
# Bad Role
MD

if WF_ROOT="$tmpdir" "$WF_TOOL" validate >/tmp/wf-bad-role.out 2>&1; then
  echo "expected unresolved role fixture to fail" >&2
  exit 1
fi
grep -q "unresolved role reference" /tmp/wf-bad-role.out

mkdir -p "$tmpdir/00-core"
cat >"$tmpdir/00-core/verification-gates.md" <<'MD'
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
id: bad-references
version: 2.0
category: planning
kind: workflow
triggers: ["bad references"]
requires: [missing-policy]
prev: missing-prev
next: [missing-next]
---
# Bad References
MD
if WF_ROOT="$tmpdir" "$WF_TOOL" validate >/tmp/wf-bad-references.out 2>&1; then
  echo "expected unresolved dependency and graph references to fail" >&2
  exit 1
fi
grep -q "02-duplicate.md" /tmp/wf-bad-references.out
grep -q "missing-policy" /tmp/wf-bad-references.out
grep -q "missing-prev" /tmp/wf-bad-references.out
grep -q "missing-next" /tmp/wf-bad-references.out

cat >"$tmpdir/workflows/planning/02-duplicate.md" <<'MD'
---
id: policy-graph-target
version: 2.0
category: planning
kind: workflow
triggers: ["policy graph target"]
next: [verification-gates]
---
# Policy Graph Target
MD
if WF_ROOT="$tmpdir" "$WF_TOOL" validate >/tmp/wf-policy-edge.out 2>&1; then
  echo "expected graph edge targeting a policy to fail" >&2
  exit 1
fi
grep -q "verification-gates" /tmp/wf-policy-edge.out
grep -Eq "non-workflow|kind.*policy|workflow target" /tmp/wf-policy-edge.out

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

mkdir -p "$tmpdir/inline-fixture/01-planning"
cat >"$tmpdir/inline-fixture/01-planning/broken.md" <<'MD'
# Broken Inline Contract

Read [missing prose](missing-prose.md), `../missing-contract.md`, and `00-Meta-Workflow/00-meta/rubric.md`.

````markdown
[ignored fenced link](missing-fenced.md)
`../missing-fenced-contract.md`
```bash
grep -r "\[.*\](" <target-directory> --include="*.md"
```
````

~~~~~markdown
[ignored tilde link](missing-tilde.md)
`00-Meta-Workflow/00-meta/ignored.md`
~~~~~
MD
if ACTIVE_MARKDOWN_ROOT="$tmpdir/inline-fixture" scripts/validation/check-active-markdown-links.sh >/tmp/wf-inline-path.out 2>&1; then
  echo "expected broken and retired inline paths to fail" >&2
  exit 1
fi
grep -q "missing-contract.md" /tmp/wf-inline-path.out
grep -q "missing-prose.md" /tmp/wf-inline-path.out
grep -q "retired inline path" /tmp/wf-inline-path.out
! grep -q "missing-fenced\|missing-tilde\|ignored.md\|target-directory" /tmp/wf-inline-path.out

mkdir -p "$tmpdir/escaped-fixture/01-planning" "$tmpdir/escaped-sibling"
touch "$tmpdir/escaped-sibling/existing.md"
cat >"$tmpdir/escaped-fixture/01-planning/check.md" <<'MD'
# Escaped Relative Links

[missing escaped](../../missing-escaped.md)
[valid escaped](../../escaped-sibling/existing.md)
MD
if ACTIVE_MARKDOWN_ROOT="$tmpdir/escaped-fixture" scripts/validation/check-active-markdown-links.sh >/tmp/wf-escaped-path.out 2>&1; then
  echo "expected missing escaped relative link to fail" >&2
  exit 1
fi
grep -q "missing-escaped.md" /tmp/wf-escaped-path.out
! grep -q "escaped-sibling/existing.md" /tmp/wf-escaped-path.out

if grep -Eq '09-11 Misc|reference/api-integration' workflows-drag-free/07-deployment/README.md; then
  echo "deployment README contains a retired API integration path" >&2
  exit 1
fi

mkdir -p "$tmpdir/template-fixture/01-planning"
cat >"$tmpdir/template-fixture/01-planning/template.md" <<'MD'
# Consumer Template

```bash
cat > README.md << 'EOF'
[consumer-only link](missing-consumer-doc.md)
EOF
```
MD
ACTIVE_MARKDOWN_ROOT="$tmpdir/template-fixture" scripts/validation/check-active-markdown-links.sh >/tmp/wf-inline-template.out 2>&1 || {
  cat /tmp/wf-inline-template.out >&2
  exit 1
}

cat >"$tmpdir/inline-fixture/01-planning/broken.md" <<'MD'
# Unterminated Active Fence

```markdown
[still validated](missing-unterminated.md)
MD
if ACTIVE_MARKDOWN_ROOT="$tmpdir/inline-fixture" scripts/validation/check-active-markdown-links.sh >/tmp/wf-inline-unterminated.out 2>&1; then
  echo "expected link in unterminated fence to fail" >&2
  exit 1
fi
grep -q "missing-unterminated.md" /tmp/wf-inline-unterminated.out

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
---
id: plan-review
version: 2.0
category: planning
kind: workflow
triggers: ["review this plan"]
---
# Workflow: Plan Review
MD
cat >"$bookdir/workflows/planning/02-plan-review-extended.md" <<'MD'
---
id: plan-review-extended
version: 2.0
category: planning
kind: workflow
triggers: ["extended plan review"]
---
# Workflow: Extended Plan Review
MD
WF_ROOT="$bookdir" "$WF_TOOL" build >/tmp/wf-book-rebuild.out
cat >"$bookdir/00-project/plans/demo/run-plan.md" <<'MD'
# Run Plan
MD
WF_ROOT="$bookdir" "$WF_TOOL" run plan-review 00-project/plans/demo/run-plan.md --output 00-project/plans/demo/review.md --timeout 1 >/tmp/wf-run.out
test -f "$bookdir/00-project/plans/demo/_manifest.json"
grep -q '"workflow_id": "plan-review"' "$bookdir/00-project/plans/demo/_manifest.json"
WF_ROOT="$bookdir" "$WF_TOOL" stats runs 00-project/plans/demo | grep -q '"runs": 1'

manifest_before="$(shasum "$bookdir/00-project/plans/demo/_manifest.json")"
if WF_ROOT="$bookdir" "$WF_TOOL" run plan-review-extended 00-project/plans/demo/run-plan.md --output 00-project/plans/demo/unsupported.md >/tmp/wf-run-unsupported.out 2>&1; then
  echo "expected known non-review workflow run to fail" >&2
  exit 1
fi
test ! -f "$bookdir/00-project/plans/demo/unsupported.md"
test "$manifest_before" = "$(shasum "$bookdir/00-project/plans/demo/_manifest.json")"
if WF_ROOT="$bookdir" "$WF_TOOL" run unknown-workflow 00-project/plans/demo/run-plan.md --output 00-project/plans/demo/unknown.md >/tmp/wf-run-unknown.out 2>&1; then
  echo "expected unknown workflow run to fail" >&2
  exit 1
fi
test ! -f "$bookdir/00-project/plans/demo/unknown.md"
test "$manifest_before" = "$(shasum "$bookdir/00-project/plans/demo/_manifest.json")"

cat >"$bookdir/11-Skills/example/SKILL.md" <<'MD'
# Example Skill
MD
WF_ROOT="$bookdir" "$WF_TOOL" build skills >/tmp/wf-skills.out
test -f "$bookdir/dist/skills/codex/example/SKILL.md"
WF_ROOT="$bookdir" "$WF_TOOL" build skills --check >/tmp/wf-skills-check.out
