#!/usr/bin/env bash
# Self-test the consumer health-check against disposable fixture copies.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
CHECK="$ROOT_DIR/scripts/validation/health-check.sh"
FIXTURES="$ROOT_DIR/scripts/validation/fixtures/health-check"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

fail() {
  printf 'health-check-selftest: FAIL: %s\n' "$1" >&2
  exit 1
}

make_case() {
  local name="$1" root="$tmp_dir/cases/$1" path workflow_repo_path
  mkdir -p "$tmp_dir/cases"
  if [ "$name" = not-a-project ]; then
    mkdir -p "$root"
    printf '# Not a consumer project\n' > "$root/README.md"
    printf '%s\n' "$root"
    return
  fi
  if [ "$name" = workflow-root ]; then
    mkdir -p "$root/scripts/validation" "$root/00-project/changelog"
    : > "$root/scripts/validation/check-meta-logs.sh"
    printf '%s\n' "$root"
    return
  fi

  rm -rf "$root"
  mkdir -p "$root"
  cp -R "$FIXTURES/healthy/." "$root/"
  rm -f "$root/CLAUDE.md"
  ln -s AGENTS.md "$root/CLAUDE.md"
  workflow_repo_path="$root/Workflow-Scripts"

  case "$name" in
    healthy) ;;
    no-project)
      rm -f "$root/PROJECT.md"
      ;;
    no-agents)
      rm -f "$root/AGENTS.md" "$root/CLAUDE.md"
      ;;
    bad-workflow-repo)
      sed 's#Workflow-Scripts/#Broken-Workflow/#' "$root/PROJECT.md" > "$root/PROJECT.md.new"
      mv "$root/PROJECT.md.new" "$root/PROJECT.md"
      mkdir -p "$root/Broken-Workflow"
      ;;
    symlink-workflow-parent)
      sed 's#Workflow-Scripts/#Shared-Links/Workflow-Scripts/#' "$root/PROJECT.md" > "$root/PROJECT.md.new"
      mv "$root/PROJECT.md.new" "$root/PROJECT.md"
      workflow_repo_path="$tmp_dir/shared-common-$name/Workflow-Scripts"
      rm -rf "$(dirname "$workflow_repo_path")"
      mkdir -p "$(dirname "$workflow_repo_path")"
      mv "$root/Workflow-Scripts" "$workflow_repo_path"
      ln -s "$(dirname "$workflow_repo_path")" "$root/Shared-Links"
      printf 'Shared-Links\n' >> "$root/.gitignore"
      ;;
    bad-gitignore)
      awk '!/^Workflow-Scripts\/$/' "$root/.gitignore" > "$root/.gitignore.new"
      mv "$root/.gitignore.new" "$root/.gitignore"
      ;;
    no-gitignore)
      rm -f "$root/.gitignore"
      ;;
    import-claude)
      rm -f "$root/CLAUDE.md"
      printf '@AGENTS.md\n' > "$root/CLAUDE.md"
      ;;
    custom-claude)
      rm -f "$root/CLAUDE.md"
      printf '@AGENTS.md\n\n## Claude-Specific Instructions\nkeep this content\n' > "$root/CLAUDE.md"
      ;;
    no-project-import)
      awk '$0 != "@PROJECT.md"' "$root/AGENTS.md" > "$root/AGENTS.md.new"
      mv "$root/AGENTS.md.new" "$root/AGENTS.md"
      ;;
    no-rules-dir)
      rm -f "$root/CLAUDE.md" "$root/.claude/rules/claude-code.md"
      printf '## Claude-Specific Instructions\nkeep this content\n' > "$root/CLAUDE.md"
      ;;
    long-agents)
      i=0
      while [ "$i" -lt 40 ]; do
        printf '# Extra rule\n' >> "$root/AGENTS.md"
        i=$((i + 1))
      done
      ;;
    no-learnings)
      rm -rf "$root/project/learnings"
      ;;
    no-project-metadata)
      rm -rf "$root/project"
      ;;
    missing-logs)
      for path in added changed fixed improved docs refactor config plans; do
        rm -rf "$root/project/changelog/$path"
      done
      for path in build runtime data environment security; do
        rm -rf "$root/project/troubleshooting/$path"
      done
      rm -f "$root/project/changelog/index.md" "$root/project/troubleshooting/index.md"
      ;;
    invalid-learnings)
      awk '!/^\*\*Source:\*\*/' \
        "$root/project/learnings/workflow/2026-10-13-workflow-fixture-lesson.md" \
        > "$root/project/learnings/workflow/entry.new"
      mv "$root/project/learnings/workflow/entry.new" \
        "$root/project/learnings/workflow/2026-10-13-workflow-fixture-lesson.md"
      ;;
    skills-incomplete)
      printf '\n## Agent skills\n' >> "$root/.claude/rules/claude-code.md"
      rm -f "$root/docs/agents/domain.md"
      ;;
    legacy-agent-learnings)
      printf '# Legacy agent learnings\n' > "$root/AGENT_LEARNINGS.md"
      ;;
    *) fail "unknown fixture case: $name" ;;
  esac

  git -C "$root" init -q
  if [ "$name" != bad-workflow-repo ]; then
    git -C "$workflow_repo_path" init -q
  fi
  printf '%s\n' "$root"
}

run_case() { # run_case <case> <expected-exit> <output-substring>
  local name="$1" expected="$2" pattern="$3" root before out code
  root="$(make_case "$name")"
  before="$tmp_dir/before-$name"
  cp -RP "$root" "$before"
  set +e
  out="$(bash "$CHECK" "$root" 2>&1)"
  code=$?
  set -e
  if [ "$code" -ne "$expected" ]; then
    fail "$name exit $code, expected $expected: $out"
  fi
  if [ -n "$pattern" ] && ! printf '%s\n' "$out" | grep -Fq -- "$pattern"; then
    fail "$name output lacks '$pattern': $out"
  fi
  if ! diff -qr "$before" "$root" >/dev/null; then
    fail "$name read-only run changed its copied fixture"
  fi
}

run_case healthy 0 'H12 not run'
run_case no-project 1 'FAIL  H01'
run_case no-agents 1 'FAIL  H04'
run_case bad-workflow-repo 1 'FAIL  H02'
run_case symlink-workflow-parent 0 'PASS  H03'
run_case bad-gitignore 1 'FAIL  H03'
global_excludes="$tmp_dir/global-excludes"
global_config="$tmp_dir/global-gitconfig"
printf 'Workflow-Scripts/\n' > "$global_excludes"
git config --file "$global_config" core.excludesFile "$global_excludes"
root="$(make_case bad-gitignore)"
set +e
global_out="$(env GIT_CONFIG_GLOBAL="$global_config" bash "$CHECK" "$root" 2>&1)"
global_code=$?
set -e
[ "$global_code" -eq 1 ] || fail 'global ignore alone must not satisfy H03'
printf '%s\n' "$global_out" | grep -Fq 'FAIL  H03' || fail 'global ignore source was accepted for H03'
run_case import-claude 1 'FAIL  H05'
run_case custom-claude 1 'repair unavailable'
run_case no-project-import 0 'WARN  H06'
run_case no-rules-dir 1 'WARN  H07'
run_case long-agents 0 'WARN  H08'
run_case no-learnings 1 'FAIL  H09'
run_case no-project-metadata 1 'FAIL  H09'
run_case missing-logs 0 'WARN  H10'
run_case invalid-learnings 0 'WARN  H11'
run_case skills-incomplete 0 'WARN  H13'
run_case legacy-agent-learnings 0 'WARN  H14'
run_case not-a-project 2 'not a consumer project'
run_case workflow-root 2 'Workflow-Scripts root'

repeat_answer() { # repeat_answer <answer> <count>
  local answer="$1" count="$2" i=0
  while [ "$i" -lt "$count" ]; do
    printf '%s\n' "$answer"
    i=$((i + 1))
  done
}

pty_run() { # pty_run <project-root> <answers> <output-file>
  local root="$1" answers="$2" output="$3" rc summary
  set +e
  { sleep 1; printf '%s\n' "$answers"; sleep 1; printf '\004' || true; } | \
    script -q /dev/null bash "$CHECK" "$root" --repair > "$output" 2>&1
  rc=$?
  set -e
  summary="$(grep '^summary:' "$output" | tail -1 || true)"
  if [ -z "$summary" ]; then
    printf '%s\n' "$rc"
  elif printf '%s\n' "$summary" | grep -Eq ', [1-9][0-9]* FAIL'; then
    printf '1\n'
  else
    printf '0\n'
  fi
}

stub_bin="$tmp_dir/bin"
mkdir -p "$stub_bin"
cat > "$stub_bin/claude" <<'STUB'
#!/bin/sh
printf 'called\n' >> "$CALL_LOG"
if [ "${STUB_FAIL:-0}" = 1 ]; then
  printf 'simulated model service failure\n' >&2
  exit 2
fi
token="$(sed -n 's/.*\(CANARY-[0-9][0-9]*-[0-9][0-9]*\).*/\1/p' ../../AGENTS.md | head -1)"
printf '%s\n' "$token"
STUB
chmod +x "$stub_bin/claude"

healthy="$(make_case healthy)"
calls="$tmp_dir/canary-calls"
set +e
default_out="$(PATH="$stub_bin:$PATH" CALL_LOG="$calls" bash "$CHECK" "$healthy" 2>&1)"
default_code=$?
set -e
[ "$default_code" -eq 0 ] || fail "default canary-boundary run failed: $default_out"
[ ! -s "$calls" ] || fail 'default path called the claude stub'

set +e
canary_out="$(PATH="$stub_bin:$PATH" CALL_LOG="$calls" bash "$CHECK" "$healthy" --canary 2>&1)"
canary_code=$?
set -e
[ "$canary_code" -eq 0 ] || fail "stub canary should pass: $canary_out"
printf '%s\n' "$canary_out" | grep -Fq 'PASS  H12' || fail "stub canary did not pass H12: $canary_out"
[ "$(wc -l < "$calls" | tr -d '[:space:]')" -eq 1 ] || fail 'opt-in canary did not make exactly one stub call'

: > "$calls"
set +e
env STUB_FAIL=1 PATH="$stub_bin:$PATH" CALL_LOG="$calls" bash "$CHECK" "$healthy" --canary > "$tmp_dir/canary-warn.out" 2>&1
canary_env_code=$?
set -e
[ "$canary_env_code" -eq 0 ] || fail 'unavailable canary environment should be WARN, not exit 1'
grep -Fq 'WARN  H12' "$tmp_dir/canary-warn.out" || fail 'unavailable canary did not map to WARN'

custom="$(make_case custom-claude)"
: > "$calls"
set +e
env PATH="$stub_bin:$PATH" CALL_LOG="$calls" bash "$CHECK" "$custom" --canary > "$tmp_dir/canary-precondition.out" 2>&1
precondition_code=$?
set -e
[ "$precondition_code" -eq 1 ] || fail 'failed canary precondition should keep exit 1'
grep -Fq 'FAIL  H12' "$tmp_dir/canary-precondition.out" || fail 'failed canary precondition did not report H12 FAIL'
[ ! -s "$calls" ] || fail 'canary ran despite a failed H05 precondition'

repair_case() { # repair_case <fixture> <answer> <expected-exit> <output-file>
  local name="$1" answer="$2" expected="$3" output="$4" root code
  root="$(make_case "$name")"
  code="$(pty_run "$root" "$(repeat_answer "$answer" 1)" "$output")"
  [ "$code" -eq "$expected" ] || fail "$name repair exit $code, expected $expected: $(cat "$output")"
  printf '%s\n' "$root"
}

# H03: one target per fixture, both refusal and acceptance.
root="$(make_case bad-gitignore)"
before_gitignore="$tmp_dir/h03-decline-gitignore"
cp "$root/.gitignore" "$before_gitignore"
code="$(pty_run "$root" "$(repeat_answer n 40)" "$tmp_dir/h03-decline.out")"
[ "$code" -eq 1 ] || fail 'H03 decline should keep the original FAIL'
grep -Fq 'declined: H03 .gitignore' "$tmp_dir/h03-decline.out" || fail 'H03 decline was not reported'
cmp -s "$before_gitignore" "$root/.gitignore" || fail 'H03 decline changed .gitignore'
root="$(repair_case bad-gitignore y 0 "$tmp_dir/h03-accept.out")"
grep -Fq 'PASS  H03' "$tmp_dir/h03-accept.out" || fail 'H03 accepted repair did not recheck to PASS'
grep -Fq 'Workflow-Scripts' "$root/.gitignore" || fail 'H03 accepted repair did not add the ignore entry'
grep -Fq 'backup: project/build/health-check/' "$tmp_dir/h03-accept.out" || fail 'H03 preview omitted its backup path'
grep -Fq "command-equivalent: printf '%s\\n'" "$tmp_dir/h03-accept.out" || fail 'H03 preview omitted its command-equivalent'
root="$(repair_case no-gitignore y 0 "$tmp_dir/h03-create.out")"
[ -f "$root/.gitignore" ] || fail 'H03 did not create a missing .gitignore'
grep -Fq 'PASS  H03' "$tmp_dir/h03-create.out" || fail 'H03 created .gitignore but did not recheck to PASS'
grep -Fq "command-equivalent: printf '%s\\n'" "$tmp_dir/h03-create.out" || fail 'H03 creation preview omitted its command-equivalent'
backup="$(sed -n 's/^backup: //p' "$tmp_dir/h03-create.out" | tr -d '\r' | head -1)"
[ -f "$root/$backup" ] || fail 'H03 did not save an absence marker for .gitignore'
root="$(make_case no-gitignore)"
before="$tmp_dir/h03-missing-gitignore-before"
cp -RP "$root" "$before"
code="$(pty_run "$root" "$(repeat_answer n 1)" "$tmp_dir/h03-create-decline.out")"
[ "$code" -eq 1 ] || fail 'H03 missing-file decline should remain FAIL'
diff -qr "$before" "$root" >/dev/null || fail 'H03 missing-file decline created .gitignore or backup data'

# H05: retain a backup of the import before installing the symlink.
root="$(repair_case import-claude n 1 "$tmp_dir/h05-decline.out")"
[ ! -L "$root/CLAUDE.md" ] || fail 'H05 decline replaced CLAUDE.md'
grep -Fxq '@AGENTS.md' "$root/CLAUDE.md" || fail 'H05 decline changed import content'
root="$(repair_case import-claude y 0 "$tmp_dir/h05-accept.out")"
[ -L "$root/CLAUDE.md" ] || fail 'H05 accepted repair did not create a symlink'
[ "$(readlink "$root/CLAUDE.md")" = AGENTS.md ] || fail 'H05 link target is incorrect'
grep -Fq "command-equivalent: ln -s 'AGENTS.md' 'CLAUDE.md'" "$tmp_dir/h05-accept.out" || fail 'H05 preview omitted its command-equivalent'
backup="$(sed -n 's/^backup: //p' "$tmp_dir/h05-accept.out" | tr -d '\r' | head -1)"
[ -f "$root/$backup" ] || fail "H05 backup is missing: $backup"
grep -Fxq '@AGENTS.md' "$root/$backup" || fail 'H05 backup did not preserve the original file'
root="$(make_case healthy)"
rm -f "$root/CLAUDE.md"
printf '  \n\n' > "$root/CLAUDE.md"
code="$(pty_run "$root" "$(repeat_answer y 1)" "$tmp_dir/h05-blank-imports.out")"
[ "$code" -eq 0 ] || fail 'H05 whitespace-only file repair should pass'
[ -L "$root/CLAUDE.md" ] || fail 'H05 did not safely replace a whitespace-only file'
root="$(make_case import-claude)"
mkdir -p "$root/project/build"
printf 'block backup path\n' > "$root/project/build/health-check"
before_claude="$tmp_dir/h05-backup-failure-original"
cp "$root/CLAUDE.md" "$before_claude"
code="$(pty_run "$root" "$(repeat_answer y 1)" "$tmp_dir/h05-backup-failure.out")"
[ "$code" -eq 1 ] || fail 'H05 backup failure should preserve its FAIL'
[ ! -L "$root/CLAUDE.md" ] || fail 'H05 replaced CLAUDE.md despite backup failure'
cmp -s "$before_claude" "$root/CLAUDE.md" || fail 'H05 target changed despite backup failure'

# H05 also creates an absent link, with an absence marker before the write.
root="$(make_case healthy)"
rm -f "$root/CLAUDE.md"
code="$(pty_run "$root" "$(repeat_answer n 1)" "$tmp_dir/h05-absent-decline.out")"
[ "$code" -eq 1 ] || fail 'H05 absent-link decline should retain the FAIL'
[ ! -e "$root/CLAUDE.md" ] && [ ! -L "$root/CLAUDE.md" ] || fail 'H05 decline created the absent link'
root="$(make_case healthy)"
rm -f "$root/CLAUDE.md"
code="$(pty_run "$root" "$(repeat_answer y 1)" "$tmp_dir/h05-absent-accept.out")"
[ "$code" -eq 0 ] || fail 'H05 absent-link acceptance should pass'
[ -L "$root/CLAUDE.md" ] && [ "$(readlink "$root/CLAUDE.md")" = AGENTS.md ] || fail 'H05 did not create the absent link'
grep -Fq "command-equivalent: ln -s 'AGENTS.md' 'CLAUDE.md'" "$tmp_dir/h05-absent-accept.out" || fail 'H05 absent-link preview omitted its command-equivalent'
backup="$(sed -n 's/^backup: //p' "$tmp_dir/h05-absent-accept.out" | tr -d '\r' | head -1)"
[ -f "$root/$backup" ] || fail 'H05 absent-target marker is missing'
grep -Fxq 'absent' "$root/$backup" || fail 'H05 absence marker has incorrect contents'

# H05 refuses a wrong symlink and unsupported directory without touching it.
root="$(make_case healthy)"
rm -f "$root/CLAUDE.md"
ln -s PROJECT.md "$root/CLAUDE.md"
set +e
bash "$CHECK" "$root" --repair < /dev/null > "$tmp_dir/h05-wrong-link.out" 2>&1
wrong_link_code=$?
set -e
[ "$wrong_link_code" -eq 1 ] || fail 'H05 wrong symlink should remain a FAIL'
[ "$(readlink "$root/CLAUDE.md")" = PROJECT.md ] || fail 'H05 replaced an existing wrong symlink'
grep -Fq 'repair unavailable' "$tmp_dir/h05-wrong-link.out" || fail 'H05 wrong symlink refusal was not reported'
root="$(make_case healthy)"
rm -f "$root/CLAUDE.md"
mkdir "$root/CLAUDE.md"
set +e
bash "$CHECK" "$root" --repair < /dev/null > "$tmp_dir/h05-directory.out" 2>&1
directory_code=$?
set -e
[ "$directory_code" -eq 1 ] || fail 'H05 directory target should remain a FAIL'
[ -d "$root/CLAUDE.md" ] || fail 'H05 replaced an unsupported directory target'

# H06: insert only the missing import at the known anchor.
root="$(repair_case no-project-import n 0 "$tmp_dir/h06-decline.out")"
if grep -Fxq '@PROJECT.md' "$root/AGENTS.md"; then fail 'H06 decline inserted the import'; fi
root="$(repair_case no-project-import y 0 "$tmp_dir/h06-accept.out")"
grep -Fxq '@PROJECT.md' "$root/AGENTS.md" || fail 'H06 accepted repair did not insert the import'
grep -Fq "command-equivalent: insert '@PROJECT.md'" "$tmp_dir/h06-accept.out" || fail 'H06 preview omitted its command-equivalent'
backup="$(sed -n 's/^backup: //p' "$tmp_dir/h06-accept.out" | tr -d '\r' | head -1)"
[ -f "$root/$backup" ] || fail "H06 backup is missing: $backup"

root="$(make_case no-project-import)"
awk '!/Read `PROJECT.md` before starting work/' "$root/AGENTS.md" > "$root/AGENTS.md.new"
printf '# PROJECT.md pointer requires manual placement\n' >> "$root/AGENTS.md.new"
mv "$root/AGENTS.md.new" "$root/AGENTS.md"
before="$tmp_dir/h06-no-anchor-before"
cp -RP "$root" "$before"
set +e
bash "$CHECK" "$root" --repair < /dev/null > "$tmp_dir/h06-no-anchor.out" 2>&1
no_anchor_code=$?
set -e
[ "$no_anchor_code" -eq 0 ] || fail 'H06 no-anchor case should remain WARN'
grep -Fq 'repair unavailable' "$tmp_dir/h06-no-anchor.out" || fail 'H06 no-anchor reason was not reported'
if tr -d '\r' < "$tmp_dir/h06-no-anchor.out" | grep -Fq 'repair H06:'; then
  fail 'H06 offered a repair without its unique anchor'
fi
diff -qr "$before" "$root" >/dev/null || fail 'H06 no-anchor report changed AGENTS.md'

# H09 prepends a missing canonical header while preserving existing rows.
root="$(make_case healthy)"
index="$root/project/learnings/index.md"
before_index="$tmp_dir/h09-index-original"
awk '!/^\| Date[[:space:]]+\| Category/' "$index" > "$index.new"
mv "$index.new" "$index"
cp "$index" "$before_index"
code="$(pty_run "$root" "$(repeat_answer y 1)" "$tmp_dir/h09-header-accept.out")"
[ "$code" -eq 0 ] || fail 'H09 header repair should pass after preserving existing rows'
grep -Fq 'command-equivalent: prepend canonical learnings index header' "$tmp_dir/h09-header-accept.out" || fail 'H09 header preview omitted its command-equivalent'
grep -Fq '| Date       | Category | Title | File | Status |' "$index" || fail 'H09 canonical header was not added'
grep -Fq '| 2026-10-13 | workflow | Fixture lesson | workflow/2026-10-13-workflow-fixture-lesson.md | NOTED; fixture only |' "$index" || fail 'H09 existing row was not preserved'
backup="$(sed -n 's/^backup: //p' "$tmp_dir/h09-header-accept.out" | tr -d '\r' | head -1)"
cmp -s "$before_index" "$root/$backup" || fail 'H09 index backup does not match its original contents'
root="$(make_case healthy)"
index="$root/project/learnings/index.md"
awk '!/^\| Date[[:space:]]+\| Category/' "$index" > "$index.new"
mv "$index.new" "$index"
before="$tmp_dir/h09-header-decline-before"
cp -RP "$root" "$before"
code="$(pty_run "$root" "$(repeat_answer n 1)" "$tmp_dir/h09-header-decline.out")"
[ "$code" -eq 1 ] || fail 'H09 header decline should remain FAIL'
diff -qr "$before" "$root" >/dev/null || fail 'H09 header decline changed the index or created backup data'

# H10 prepends both missing canonical headers without changing existing rows.
root="$(make_case healthy)"
change_index="$root/project/changelog/index.md"
trouble_index="$root/project/troubleshooting/index.md"
printf '| 2026-10-14 | added | Existing changelog row | added/existing.md | preserve me |\n' >> "$change_index"
printf '| 2026-10-14 | runtime | Existing issue row | runtime/existing.md | OPEN |\n' >> "$trouble_index"
awk '!/^\| Date[[:space:]]+\| Type/' "$change_index" > "$change_index.new"
awk '!/^\| Date[[:space:]]+\| Category/' "$trouble_index" > "$trouble_index.new"
mv "$change_index.new" "$change_index"
mv "$trouble_index.new" "$trouble_index"
before_change="$tmp_dir/h10-changelog-original"
before_trouble="$tmp_dir/h10-troubleshooting-original"
cp "$change_index" "$before_change"
cp "$trouble_index" "$before_trouble"
code="$(pty_run "$root" "$(repeat_answer y 2)" "$tmp_dir/h10-header-accept.out")"
[ "$code" -eq 0 ] || fail 'H10 header repairs should pass after preserving existing rows'
grep -Fq 'command-equivalent: prepend canonical changelog index header' "$tmp_dir/h10-header-accept.out" || fail 'H10 changelog-header preview omitted its command-equivalent'
grep -Fq 'command-equivalent: prepend canonical troubleshooting index header' "$tmp_dir/h10-header-accept.out" || fail 'H10 troubleshooting-header preview omitted its command-equivalent'
grep -Fq '| 2026-10-14 | added | Existing changelog row | added/existing.md | preserve me |' "$change_index" || fail 'H10 changelog row was not preserved'
grep -Fq '| 2026-10-14 | runtime | Existing issue row | runtime/existing.md | OPEN |' "$trouble_index" || fail 'H10 troubleshooting row was not preserved'
backup_paths="$(sed -n 's/^backup: //p' "$tmp_dir/h10-header-accept.out" | tr -d '\r')"
first_backup="$(printf '%s\n' "$backup_paths" | sed -n '1p')"
second_backup="$(printf '%s\n' "$backup_paths" | sed -n '2p')"
if cmp -s "$before_change" "$root/$first_backup"; then
  cmp -s "$before_trouble" "$root/$second_backup" || fail 'H10 troubleshooting backup differs from its original'
else
  cmp -s "$before_trouble" "$root/$first_backup" || fail 'H10 first backup does not match either original index'
  cmp -s "$before_change" "$root/$second_backup" || fail 'H10 changelog backup differs from its original'
fi
root="$(make_case healthy)"
change_index="$root/project/changelog/index.md"
trouble_index="$root/project/troubleshooting/index.md"
printf '| 2026-10-14 | added | Existing changelog row | added/existing.md | preserve me |\n' >> "$change_index"
printf '| 2026-10-14 | runtime | Existing issue row | runtime/existing.md | OPEN |\n' >> "$trouble_index"
awk '!/^\| Date[[:space:]]+\| Type/' "$change_index" > "$change_index.new"
awk '!/^\| Date[[:space:]]+\| Category/' "$trouble_index" > "$trouble_index.new"
mv "$change_index.new" "$change_index"
mv "$trouble_index.new" "$trouble_index"
before="$tmp_dir/h10-header-decline-before"
cp -RP "$root" "$before"
code="$(pty_run "$root" "$(repeat_answer n 2)" "$tmp_dir/h10-header-decline.out")"
[ "$code" -eq 0 ] || fail 'H10 header declines should remain WARN and exit 0'
diff -qr "$before" "$root" >/dev/null || fail 'H10 header declines changed an index or created backup data'

make_h09_missing() {
  local name="$1" root="$tmp_dir/h09-$1" category
  mkdir -p "$root"
  cp -R "$FIXTURES/healthy/." "$root/"
  rm -f "$root/CLAUDE.md"; ln -s AGENTS.md "$root/CLAUDE.md"
  for category in workflow code tooling facts communication; do
    rm -rf "$root/project/learnings/$category"
  done
  rm -f "$root/project/learnings/index.md"
  git -C "$root" init -q
  git -C "$root/Workflow-Scripts" init -q
  printf '%s\n' "$root"
}

# H09: every missing directory/index target is individually declined or accepted.
root="$(make_h09_missing accept)"
code="$(pty_run "$root" "$(repeat_answer y 6)" "$tmp_dir/h09-accept.out")"
[ "$code" -eq 0 ] || fail "H09 accepted repairs should clear its structural failure: $(cat "$tmp_dir/h09-accept.out")"
grep -Fq 'PASS  H09' "$tmp_dir/h09-accept.out" || fail 'H09 accepted repairs did not recheck to PASS'
[ "$(grep -Fc "command-equivalent: mkdir 'project/learnings/" "$tmp_dir/h09-accept.out")" -ge 5 ] || fail 'H09 directory previews omitted command-equivalents'
[ "$(grep -c '^backup: ' "$tmp_dir/h09-accept.out")" -eq 6 ] || fail 'H09 did not preview/back up all six missing targets'

root="$(make_h09_missing decline)"
before="$tmp_dir/h09-before"
  cp -RP "$root" "$before"
code="$(pty_run "$root" "$(repeat_answer n 6)" "$tmp_dir/h09-decline.out")"
[ "$code" -eq 1 ] || fail 'H09 declines should leave the structural FAIL'
diff -qr "$before" "$root" >/dev/null || fail 'H09 declines changed a target or created backup data'

# The backup path creates its missing project/build parents only after consent.
root="$(make_case no-project-metadata)"
answers="$(printf 'y\n'; repeat_answer n 40)"
code="$(pty_run "$root" "$answers" "$tmp_dir/missing-project-parent.out")"
[ "$code" -eq 1 ] || fail 'incomplete metadata should remain a FAIL after one accepted structural repair'
grep -Fq 'repair H09: project/learnings' "$tmp_dir/missing-project-parent.out" || fail 'health-check offered the wrong first target when project/ was absent'
if tr -d '\r' < "$tmp_dir/missing-project-parent.out" | grep -Fqx 'repair H09: project/'; then
  fail 'project/ should be backup infrastructure, not a separate repair target'
fi
[ -d "$root/project/build/health-check" ] || fail 'accepted repair did not create its displayed backup hierarchy'
backup="$(sed -n 's/^backup: //p' "$tmp_dir/missing-project-parent.out" | tr -d '\r' | head -1)"
[ -f "$root/$backup" ] || fail 'accepted metadata repair did not leave its absence marker'

make_h10_missing() {
  local name="$1" root="$tmp_dir/h10-$1" path
  mkdir -p "$root"
  cp -R "$FIXTURES/healthy/." "$root/"
  rm -f "$root/CLAUDE.md"; ln -s AGENTS.md "$root/CLAUDE.md"
  for path in added changed fixed improved docs refactor config plans; do
    rm -rf "$root/project/changelog/$path"
  done
  for path in build runtime data environment security; do
    rm -rf "$root/project/troubleshooting/$path"
  done
  rm -f "$root/project/changelog/index.md" "$root/project/troubleshooting/index.md"
  git -C "$root" init -q
  git -C "$root/Workflow-Scripts" init -q
  printf '%s\n' "$root"
}

# H10: all 13 folders and both missing index files are separate offers.
root="$(make_h10_missing accept)"
code="$(pty_run "$root" "$(repeat_answer y 15)" "$tmp_dir/h10-accept.out")"
[ "$code" -eq 0 ] || fail "H10 accepted repairs should clear its structural warning: $(cat "$tmp_dir/h10-accept.out")"
grep -Fq 'PASS  H10' "$tmp_dir/h10-accept.out" || fail 'H10 accepted repairs did not recheck to PASS'
[ "$(grep -Fc "command-equivalent: mkdir 'project/changelog/" "$tmp_dir/h10-accept.out")" -ge 8 ] || fail 'H10 directory previews omitted command-equivalents'
[ "$(grep -c '^backup: ' "$tmp_dir/h10-accept.out")" -eq 15 ] || fail 'H10 did not offer all 15 missing folder/index targets'

root="$(make_h10_missing decline)"
before="$tmp_dir/h10-before"
  cp -RP "$root" "$before"
code="$(pty_run "$root" "$(repeat_answer n 15)" "$tmp_dir/h10-decline.out")"
[ "$code" -eq 0 ] || fail 'H10 declines should remain WARN and exit 0'
diff -qr "$before" "$root" >/dev/null || fail 'H10 declines changed a target or created backup data'

# Malformed headers and missing README content are always manual findings.
root="$(make_case healthy)"
awk '/^\| Date/ { print "| Date | Category | Title | File | Status | Extra |"; next } { print }' \
  "$root/project/learnings/index.md" > "$root/project/learnings/index.new"
mv "$root/project/learnings/index.new" "$root/project/learnings/index.md"
before="$tmp_dir/h09-malformed-before"
cp -RP "$root" "$before"
code="$(pty_run "$root" '' "$tmp_dir/h09-malformed.out")"
[ "$code" -eq 1 ] || fail 'H09 malformed header should remain FAIL'
grep -Fq 'malformed header; manual repair' "$tmp_dir/h09-malformed.out" || fail 'H09 malformed header was not identified'
if tr -d '\r' < "$tmp_dir/h09-malformed.out" | grep -Fq 'repair H09:'; then
  fail 'H09 offered to rewrite a malformed header'
fi
diff -qr "$before" "$root" >/dev/null || fail 'H09 malformed-header check changed the index'

root="$(make_case healthy)"
awk '/^\| Date/ { print "| Date | Type | Title | File | Notes | Extra |"; next } { print }' \
  "$root/project/changelog/index.md" > "$root/project/changelog/index.new"
mv "$root/project/changelog/index.new" "$root/project/changelog/index.md"
code="$(pty_run "$root" '' "$tmp_dir/h10-malformed.out")"
[ "$code" -eq 0 ] || fail 'H10 malformed header should remain WARN'
grep -Fq 'malformed header; manual repair' "$tmp_dir/h10-malformed.out" || fail 'H10 malformed header was not identified'
if tr -d '\r' < "$tmp_dir/h10-malformed.out" | grep -Fq 'repair H10:'; then
  fail 'H10 offered to rewrite a malformed header'
fi

root="$(make_case healthy)"
rm -f "$root/project/learnings/README.md"
code="$(pty_run "$root" '' "$tmp_dir/h09-missing-readme.out")"
[ "$code" -eq 1 ] || fail 'H09 missing README should remain FAIL'
if tr -d '\r' < "$tmp_dir/h09-missing-readme.out" | grep -Fq 'repair H09:'; then
  fail 'H09 offered to synthesize missing README content'
fi

root="$(make_case healthy)"
rm -f "$root/project/troubleshooting/README.md"
code="$(pty_run "$root" '' "$tmp_dir/h10-missing-readme.out")"
[ "$code" -eq 0 ] || fail 'H10 missing README should remain WARN'
if tr -d '\r' < "$tmp_dir/h10-missing-readme.out" | grep -Fq 'repair H10:'; then
  fail 'H10 offered to synthesize missing README content'
fi

# No terminal: piped answers must never authorize a write.
root="$(make_case bad-gitignore)"
before="$tmp_dir/no-tty-before"
cp -R "$root" "$before"
set +e
printf 'y\n' | bash "$CHECK" "$root" --repair > "$tmp_dir/no-tty.out" 2>&1
no_tty_code=$?
set -e
[ "$no_tty_code" -eq 1 ] || fail 'no-terminal repair run should keep the original H03 FAIL'
grep -Fq 'repairs skipped: no terminal' "$tmp_dir/no-tty.out" || fail 'no-terminal repair message is missing'
diff -qr "$before" "$root" >/dev/null || fail 'no-terminal run changed a target or created backup data'

# Backup failure: preserve the target and report the repair as skipped.
root="$(make_case bad-gitignore)"
mkdir -p "$root/project/build"
printf 'block backup path\n' > "$root/project/build/health-check"
before_gitignore="$tmp_dir/gitignore-before"
cp "$root/.gitignore" "$before_gitignore"
code="$(pty_run "$root" "$(repeat_answer y 1)" "$tmp_dir/backup-failure.out")"
[ "$code" -eq 1 ] || fail 'backup failure should preserve the H03 FAIL'
cmp -s "$before_gitignore" "$root/.gitignore" || fail 'target changed despite backup-path failure'
grep -Fq 'repair failed or was skipped: H03 .gitignore' "$tmp_dir/backup-failure.out" || fail 'backup failure was not reported'

# Usage errors have a deterministic exit code.
set +e
bash "$CHECK" >/dev/null 2>&1
missing_arg_code=$?
bash "$CHECK" "$healthy" --unknown >/dev/null 2>&1
unknown_flag_code=$?
bash "$CHECK" "$healthy" --repair --repair >/dev/null 2>&1
duplicate_flag_code=$?
set -e
[ "$missing_arg_code" -eq 2 ] || fail 'missing path should exit 2'
[ "$unknown_flag_code" -eq 2 ] || fail 'unknown flag should exit 2'
[ "$duplicate_flag_code" -eq 2 ] || fail 'duplicate flag should exit 2'

echo 'health-check-selftest: OK'
