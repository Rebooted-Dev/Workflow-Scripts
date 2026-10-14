#!/usr/bin/env bash
# Read-only-by-default consumer setup check with explicitly confirmed repairs.
set -euo pipefail

usage() {
  printf '%s\n' 'usage: health-check.sh <PROJECT_PATH> [--repair] [--canary]' >&2
}

die_usage() {
  printf 'health-check: %s\n' "$1" >&2
  usage
  exit 2
}

if [ "$#" -lt 1 ]; then
  die_usage 'a consumer project path is required'
fi

project_arg="$1"
shift
repair_requested=0
canary_requested=0
while [ "$#" -gt 0 ]; do
  case "$1" in
    --repair)
      [ "$repair_requested" -eq 0 ] || die_usage 'duplicate --repair flag'
      repair_requested=1
      ;;
    --canary)
      [ "$canary_requested" -eq 0 ] || die_usage 'duplicate --canary flag'
      canary_requested=1
      ;;
    *) die_usage "unknown option '$1'" ;;
  esac
  shift
done

if [ ! -d "$project_arg" ]; then
  printf 'health-check: project directory does not exist: %s\n' "$project_arg" >&2
  exit 2
fi
project_root="$(cd -- "$project_arg" 2>/dev/null && pwd -P)" || {
  printf 'health-check: cannot resolve project directory: %s\n' "$project_arg" >&2
  exit 2
}

if [ -f "$project_root/scripts/validation/check-meta-logs.sh" ] && \
   [ -d "$project_root/00-project/changelog" ]; then
  printf '%s\n' 'health-check: refuses the Workflow-Scripts root; use a consumer project'
  exit 2
fi
if [ ! -e "$project_root/AGENTS.md" ] && [ ! -e "$project_root/PROJECT.md" ]; then
  printf '%s\n' 'health-check: target has neither AGENTS.md nor PROJECT.md; not a consumer project'
  exit 2
fi

case "$project_root" in
  *$'\n'*|*$'\t'*)
    printf '%s\n' 'health-check: project paths containing newlines or tabs are unsupported' >&2
    exit 2
    ;;
esac

run_stamp="$(date '+%Y%m%dT%H%M%S')"
run_id="${run_stamp}-$$"
backup_parent="$project_root/project/build/health-check"
suffix=1
while [ -e "$backup_parent/$run_id" ] || [ -L "$backup_parent/$run_id" ]; do
  run_id="${run_stamp}-$$-$suffix"
  suffix=$((suffix + 1))
done
backup_root="$backup_parent/$run_id"
backup_root_ready=0

workflow_rel=''
workflow_path=''
workflow_ignore_probe=''
workflow_row_valid=0
repo_table_valid=0
if [ -f "$project_root/PROJECT.md" ]; then
  if grep -q '^## Repositories[[:space:]]*$' "$project_root/PROJECT.md" && \
     awk -F '|' '
       /^##[[:space:]]+/ { in_repositories = ($0 ~ /^## Repositories[[:space:]]*$/); next }
       in_repositories && /^\|/ {
         path = $2; repo = $3
         gsub(/^[[:space:]]+|[[:space:]]+$/, "", path)
         gsub(/^[[:space:]]+|[[:space:]]+$/, "", repo)
         if (path == "Path" && repo == "Repository") found = 1
       }
       END { exit !found }
     ' "$project_root/PROJECT.md"; then
    repo_table_valid=1
  fi

  workflow_rows="$(awk -F '|' '
    /^##[[:space:]]+/ { in_repositories = ($0 ~ /^## Repositories[[:space:]]*$/); next }
    in_repositories && /^\|/ {
      path = $2; repo = $3
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", path)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", repo)
      if (repo == "Workflow-Scripts") {
        gsub(/`/, "", path)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", path)
        sub(/\/+$/, "", path)
        print path
      }
    }
  ' "$project_root/PROJECT.md")"
  workflow_row_count="$(printf '%s\n' "$workflow_rows" | awk 'NF { count++ } END { print count + 0 }')"
  if [ "$workflow_row_count" -eq 1 ]; then
    workflow_rel="$workflow_rows"
    case "$workflow_rel" in
      ''|/*|.) workflow_rel='' ;;
    esac
    case "/$workflow_rel/" in
      */../*) workflow_rel='' ;;
    esac
    if [ -n "$workflow_rel" ] && printf '%s\n' "$workflow_rel" | grep -Eq '[^[:alnum:]_./ -]'; then
      workflow_rel=''
    fi
    if [ -n "$workflow_rel" ]; then
      workflow_path="$project_root/$workflow_rel"
      workflow_row_valid=1
      current_rel=''
      IFS=/ read -r -a workflow_components <<< "$workflow_rel"
      for component in "${workflow_components[@]}"; do
        current_rel="${current_rel:+$current_rel/}$component"
        if [ -L "$project_root/$current_rel" ]; then
          workflow_ignore_probe="$current_rel"
          break
        fi
      done
      [ -n "$workflow_ignore_probe" ] || workflow_ignore_probe="$workflow_rel"
    fi
  fi
fi

check_learnings="$project_root/project/learnings"
rules_check="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/check-agent-rules-load.sh"
learnings_check="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/check-learnings.sh"

repair_count=0
repair_ids=()
repair_kinds=()
repair_targets=()
repair_commands=()
repair_backup_paths=()
collect_repairs=0
pass_count=0
warn_count=0
fail_count=0
check_count=0
declined_count=0
repair_skipped_no_tty=0
tmp_file=''
tmp_link=''

# shellcheck disable=SC2329
cleanup() {
  if [ -n "$tmp_file" ]; then rm -f "$tmp_file"; fi
  if [ -n "$tmp_link" ]; then rm -f "$tmp_link"; fi
}
trap cleanup EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

emit() {
  local status="$1" id="$2" message="$3"
  printf '%-4s  %-3s  %s\n' "$status" "$id" "$message"
  check_count=$((check_count + 1))
  case "$status" in
    PASS) pass_count=$((pass_count + 1)) ;;
    WARN) warn_count=$((warn_count + 1)) ;;
    FAIL) fail_count=$((fail_count + 1)) ;;
  esac
}

workflow_path_ignored_by_project() {
  local match source
  [ -n "$workflow_ignore_probe" ] || return 1
  match="$(git -C "$project_root" check-ignore --no-index -v -- "$workflow_ignore_probe" 2>/dev/null)" || return 1
  source="${match%%:*}"
  [ "$source" = .gitignore ]
}

queue_repair() {
  local id="$1" kind="$2" target="$3" command="$4" backup_rel="$5"
  local i
  [ "$collect_repairs" -eq 1 ] || return 0
  for ((i = 0; i < repair_count; i++)); do
    if [ "${repair_ids[$i]}" = "$id" ] && [ "${repair_targets[$i]}" = "$target" ]; then
      return 0
    fi
  done
  repair_ids[repair_count]="$id"
  repair_kinds[repair_count]="$kind"
  repair_targets[repair_count]="$target"
  repair_commands[repair_count]="$command"
  repair_backup_paths[repair_count]="$backup_rel"
  repair_count=$((repair_count + 1))
}

backup_rel_for_target() {
  local target="$1"
  if [ -e "$project_root/$target" ] || [ -L "$project_root/$target" ]; then
    printf 'project/build/health-check/%s/targets/%s' "$run_id" "$target"
  else
    printf 'project/build/health-check/%s/absence/%s.absent' "$run_id" "$target"
  fi
}

queue_directory() {
  local id="$1" target="$2" parent
  # `project/` is the required parent of the durable backup path itself. The
  # first accepted child repair creates it together with the displayed backup
  # hierarchy, so it is not offered as a separate target.
  [ "$target" = project ] && return 0
  parent="${target%/*}"
  if [ "$parent" != "$target" ] && [ ! -d "$project_root/$parent" ]; then
    queue_directory "$id" "$parent"
  fi
  if [ ! -d "$project_root/$target" ]; then
    queue_repair "$id" directory "$target" "mkdir '$target'" "$(backup_rel_for_target "$target")"
  fi
}

queue_header() {
  local id="$1" target="$2" format="$3"
  if [ ! -e "$project_root/$target" ]; then
    queue_repair "$id" "$format-header" "$target" \
      "create canonical $format index header in '$target'" "$(backup_rel_for_target "$target")"
  elif [ -f "$project_root/$target" ] && [ ! -L "$project_root/$target" ]; then
    if ! has_index_header "$target" "$format" && ! has_malformed_index_header "$target" "$format"; then
      queue_repair "$id" "$format-header" "$target" \
        "prepend canonical $format index header to '$target'" "$(backup_rel_for_target "$target")"
    fi
  fi
}

has_index_header() {
  local target="$1" format="$2"
  if [ "$format" = learnings ]; then
    grep -Eq '^\| Date[[:space:]]+\| Category[[:space:]]+\| Title[[:space:]]+\| File[[:space:]]+\| Status[[:space:]]+\|$' "$project_root/$target"
  elif [ "$format" = changelog ]; then
    grep -Eq '^\| Date[[:space:]]+\| Type[[:space:]]+\| Title[[:space:]]+\| File[[:space:]]+\| Notes[[:space:]]+\|$' "$project_root/$target"
  else
    grep -Eq '^\| Date[[:space:]]+\| Category[[:space:]]+\| Title[[:space:]]+\| File[[:space:]]+\| Status[[:space:]]+\|$' "$project_root/$target"
  fi
}

has_malformed_index_header() {
  local target="$1" format="$2"
  if [ "$format" = changelog ]; then
    grep -Eq '^\|.*Date.*\|.*Type.*\|.*Title.*\|.*File.*\|.*Notes.*\|' "$project_root/$target"
  else
    grep -Eq '^\|.*Date.*\|.*Category.*\|.*Title.*\|.*File.*\|.*Status.*\|' "$project_root/$target"
  fi
}

is_import_only_claude() {
  local line
  [ -f "$project_root/CLAUDE.md" ] && [ ! -L "$project_root/CLAUDE.md" ] || return 1
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      *[![:space:]]*)
        case "$line" in
          '@AGENTS.md'|'@PROJECT.md') ;;
          *) return 1 ;;
        esac
        ;;
      *) ;;
    esac
  done < "$project_root/CLAUDE.md"
  return 0
}

check_h01() {
  if [ "$repo_table_valid" -eq 1 ]; then
    emit PASS H01 'PROJECT.md contains a ## Repositories table'
  else
    emit FAIL H01 'PROJECT.md is missing a ## Repositories table'
  fi
}

check_h02() {
  local top prefix physical
  if [ "$workflow_row_valid" -ne 1 ] || [ ! -d "$workflow_path" ]; then
    emit FAIL H02 'Workflow-Scripts repository row is missing, unsafe, or absent'
    return
  fi
  set +e
  top="$(git -C "$workflow_path" rev-parse --show-toplevel 2>/dev/null)"
  prefix="$(git -C "$workflow_path" rev-parse --show-prefix 2>/dev/null)"
  set -e
  physical="$(cd "$workflow_path" 2>/dev/null && pwd -P)" || physical=''
  if [ -n "$top" ] && [ -n "$physical" ] && [ -z "$prefix" ] && [ "$top" = "$physical" ]; then
    emit PASS H02 "Workflow-Scripts path is its own Git root ($workflow_rel)"
  else
    emit FAIL H02 'Workflow-Scripts path does not resolve to its own Git root'
  fi
}

check_h03() {
  if [ "$workflow_row_valid" -ne 1 ]; then
    emit FAIL H03 'cannot check the workflow ignore rule without one safe Workflow-Scripts path'
  elif workflow_path_ignored_by_project; then
    emit PASS H03 "Workflow-Scripts path is ignored ($workflow_rel)"
  else
    emit FAIL H03 "Workflow-Scripts path is not ignored ($workflow_rel)"
    queue_repair H03 ignore .gitignore \
      "printf '%s\\n' '# Workflow-Scripts (separate repo, managed independently)' '$workflow_rel' >> '.gitignore'" \
      "$(backup_rel_for_target .gitignore)"
  fi
}

check_h04() {
  if [ -f "$project_root/AGENTS.md" ] && grep -q 'PROJECT\.md' "$project_root/AGENTS.md"; then
    emit PASS H04 'AGENTS.md exists and points to PROJECT.md'
  else
    emit FAIL H04 'AGENTS.md is missing or has no PROJECT.md pointer'
  fi
}

check_h05() {
  if [ -L "$project_root/CLAUDE.md" ] && \
     [ "$(readlink "$project_root/CLAUDE.md" 2>/dev/null || true)" = AGENTS.md ] && \
     [ -f "$project_root/AGENTS.md" ]; then
    emit PASS H05 'CLAUDE.md is a symlink to AGENTS.md'
  else
    emit FAIL H05 'CLAUDE.md is not a symlink to AGENTS.md'
    if { [ ! -e "$project_root/CLAUDE.md" ] && [ ! -L "$project_root/CLAUDE.md" ]; } || is_import_only_claude; then
      if [ -f "$project_root/AGENTS.md" ]; then
        queue_repair H05 claude-link CLAUDE.md "ln -s 'AGENTS.md' 'CLAUDE.md' (installed atomically)" \
          "$(backup_rel_for_target CLAUDE.md)"
      else
        printf '%s\n' 'INFO  H05  repair unavailable: AGENTS.md must exist before creating the symlink'
      fi
    else
      printf '%s\n' 'INFO  H05  repair unavailable: existing CLAUDE.md is a symlink, unsupported file type, or contains custom content'
    fi
  fi
}

check_h06() {
  local anchor="Read \`PROJECT.md\` before starting work"
  if [ ! -f "$project_root/AGENTS.md" ]; then
    emit WARN H06 'AGENTS.md is unavailable; cannot verify @PROJECT.md'
    return
  fi
  if grep -Fxq '@PROJECT.md' "$project_root/AGENTS.md"; then
    emit PASS H06 'AGENTS.md imports @PROJECT.md'
    return
  fi
  emit WARN H06 'AGENTS.md has no @PROJECT.md import'
  local anchor_count
  anchor_count="$(grep -Fc "$anchor" "$project_root/AGENTS.md" || true)"
  if [ "$anchor_count" -eq 1 ]; then
    queue_repair H06 project-import AGENTS.md \
      "insert '@PROJECT.md' after the unique PROJECT.md read anchor in 'AGENTS.md'" \
      "$(backup_rel_for_target AGENTS.md)"
  else
    printf '%s\n' 'INFO  H06  repair unavailable: the unique Read PROJECT.md anchor was not found'
  fi
}

check_h07() {
  local has_heading=0
  if [ -f "$project_root/CLAUDE.md" ] && [ ! -L "$project_root/CLAUDE.md" ]; then
    if grep -Eq '^## (Claude-Specific Instructions|Agent skills)[[:space:]]*$' "$project_root/CLAUDE.md"; then
      has_heading=1
    fi
  fi
  if [ "$has_heading" -eq 0 ] || [ -f "$project_root/.claude/rules/claude-code.md" ]; then
    emit PASS H07 'Claude-only rules location is present when a recognized heading requires it'
  else
    emit WARN H07 'Claude-specific heading found in CLAUDE.md; move it to .claude/rules/claude-code.md'
  fi
}

check_h08() {
  if [ ! -f "$project_root/AGENTS.md" ]; then
    emit WARN H08 'AGENTS.md is unavailable; cannot check its length'
    return
  fi
  local lines
  lines="$(awk 'END { print NR + 0 }' "$project_root/AGENTS.md")"
  if [ "$lines" -le 40 ]; then
    emit PASS H08 "AGENTS.md is $lines lines (target <= 40)"
  else
    emit WARN H08 "AGENTS.md is $lines lines (target <= 40)"
  fi
}

check_h09() {
  local missing=() path
  local root='project/learnings'
  [ -f "$project_root/$root/README.md" ] || missing+=("$root/README.md")
  if [ ! -f "$project_root/$root/index.md" ]; then
    missing+=("$root/index.md")
  elif ! has_index_header "$root/index.md" learnings; then
    if has_malformed_index_header "$root/index.md" learnings; then
      missing+=("$root/index.md (malformed header; manual repair)")
    else
      missing+=("$root/index.md header")
    fi
  fi
  for path in workflow code tooling facts communication; do
    [ -d "$project_root/$root/$path" ] || missing+=("$root/$path/")
  done
  if [ "${#missing[@]}" -eq 0 ]; then
    emit PASS H09 'project/learnings has its README, index header, and five category folders'
    return
  fi
  local detail item
  detail=''
  for item in "${missing[@]}"; do
    [ -z "$detail" ] && detail="$item" || detail="$detail, $item"
  done
  emit FAIL H09 "project/learnings structure is incomplete: $detail"
  for path in "$root" "$root/workflow" "$root/code" "$root/tooling" "$root/facts" "$root/communication"; do
    queue_directory H09 "$path"
  done
  if [ ! -f "$project_root/$root/index.md" ]; then
    queue_header H09 "$root/index.md" learnings
  elif [ -f "$project_root/$root/index.md" ] && ! has_index_header "$root/index.md" learnings && \
       ! has_malformed_index_header "$root/index.md" learnings; then
    queue_header H09 "$root/index.md" learnings
  fi
}

check_h10() {
  local missing=() path
  local changelog='project/changelog' troubleshooting='project/troubleshooting'
  [ -f "$project_root/$changelog/README.md" ] || missing+=("$changelog/README.md (manual)")
  [ -f "$project_root/$troubleshooting/README.md" ] || missing+=("$troubleshooting/README.md (manual)")
  for path in added changed fixed improved docs refactor config plans; do
    [ -d "$project_root/$changelog/$path" ] || missing+=("$changelog/$path/")
  done
  for path in build runtime data environment security; do
    [ -d "$project_root/$troubleshooting/$path" ] || missing+=("$troubleshooting/$path/")
  done
  if [ ! -f "$project_root/$changelog/index.md" ]; then
    missing+=("$changelog/index.md")
  elif ! has_index_header "$changelog/index.md" changelog; then
    if has_malformed_index_header "$changelog/index.md" changelog; then
      missing+=("$changelog/index.md (malformed header; manual repair)")
    else
      missing+=("$changelog/index.md header")
    fi
  fi
  if [ ! -f "$project_root/$troubleshooting/index.md" ]; then
    missing+=("$troubleshooting/index.md")
  elif ! has_index_header "$troubleshooting/index.md" troubleshooting; then
    if has_malformed_index_header "$troubleshooting/index.md" troubleshooting; then
      missing+=("$troubleshooting/index.md (malformed header; manual repair)")
    else
      missing+=("$troubleshooting/index.md header")
    fi
  fi
  if [ "${#missing[@]}" -eq 0 ]; then
    emit PASS H10 'changelog and troubleshooting indexes, headers, READMEs, and categories are present'
    return
  fi
  local detail item
  detail=''
  for item in "${missing[@]}"; do
    [ -z "$detail" ] && detail="$item" || detail="$detail, $item"
  done
  emit WARN H10 "log structure is incomplete: $detail"
  for path in \
    "$changelog" "$changelog/added" "$changelog/changed" "$changelog/fixed" "$changelog/improved" \
    "$changelog/docs" "$changelog/refactor" "$changelog/config" "$changelog/plans" \
    "$troubleshooting" "$troubleshooting/build" "$troubleshooting/runtime" "$troubleshooting/data" \
    "$troubleshooting/environment" "$troubleshooting/security"; do
    queue_directory H10 "$path"
  done
  queue_header H10 "$changelog/index.md" changelog
  queue_header H10 "$troubleshooting/index.md" troubleshooting
}

check_h11() {
  if [ ! -f "$learnings_check" ]; then
    emit WARN H11 'check-learnings.sh is missing'
    return
  fi
  local out code
  set +e
  out="$(bash "$learnings_check" "$check_learnings" 2>&1)"
  code=$?
  set -e
  if [ "$code" -eq 0 ]; then
    emit PASS H11 'check-learnings.sh passes on project/learnings'
  else
    emit WARN H11 "check-learnings.sh reports a structural/content issue: $out"
  fi
}

check_h13() {
  local rules="$project_root/.claude/rules/claude-code.md" missing=() path
  if [ ! -f "$rules" ] || ! grep -Eq '^## Agent skills[[:space:]]*$' "$rules"; then
    emit PASS H13 'Agent skills block is absent; no skill-owned docs are required by this check'
    return
  fi
  for path in issue-tracker.md triage-labels.md domain.md; do
    [ -f "$project_root/docs/agents/$path" ] || missing+=("docs/agents/$path")
  done
  if [ "${#missing[@]}" -eq 0 ]; then
    emit PASS H13 'Agent skills block has all three docs/agents files'
  else
    local detail item
    detail=''
    for item in "${missing[@]}"; do
      [ -z "$detail" ] && detail="$item" || detail="$detail, $item"
    done
    emit WARN H13 "Agent skills block is missing skill-owned docs: $detail"
  fi
}

check_h14() {
  if [ -e "$project_root/AGENT_LEARNINGS.md" ] || [ -L "$project_root/AGENT_LEARNINGS.md" ]; then
    emit WARN H14 'root AGENT_LEARNINGS.md remains; migrate its content before removing it'
  else
    emit PASS H14 'no root AGENT_LEARNINGS.md remains'
  fi
}

run_checks() {
  check_h01
  check_h02
  check_h03
  check_h04
  check_h05
  check_h06
  check_h07
  check_h08
  check_h09
  check_h10
  check_h11
  check_h13
  check_h14
}

has_symlink_parent() {
  local target="$1" rel_parent component current="$project_root"
  local components
  rel_parent="${target%/*}"
  [ "$rel_parent" != "$target" ] || return 1
  IFS=/ read -r -a components <<< "$rel_parent"
  for component in "${components[@]}"; do
    current="$current/$component"
    [ -L "$current" ] && return 0
  done
  return 1
}

ensure_backup_root() {
  local path
  for path in "$project_root/project" "$project_root/project/build" "$backup_parent"; do
    if [ -L "$path" ]; then
      printf 'health-check: refusing backup through symlink directory: %s\n' "$path" >&2
      return 1
    fi
  done
  if [ "$backup_root_ready" -eq 1 ]; then return 0; fi
  if [ -e "$backup_root" ] || [ -L "$backup_root" ]; then
    printf 'health-check: backup run path already exists: %s\n' "$backup_root" >&2
    return 1
  fi
  mkdir -p "$backup_parent"
  mkdir "$backup_root" || return 1
  backup_root_ready=1
}

backup_target() {
  local target="$1" backup_rel="$2" source destination
  source="$project_root/$target"
  destination="$project_root/$backup_rel"
  if has_symlink_parent "$target"; then
    printf 'health-check: refusing repair through symlink parent: %s\n' "$target" >&2
    return 1
  fi
  ensure_backup_root || return 1
  case "$backup_rel" in
    */absence/*)
      if [ -e "$source" ] || [ -L "$source" ]; then
        printf 'health-check: target appeared after preview; not overwriting it: %s\n' "$target" >&2
        return 1
      fi
      mkdir -p "$(dirname "$destination")"
      printf 'absent\n' > "$destination"
      ;;
    *)
      if [ -L "$source" ] || { [ -e "$source" ] && [ ! -f "$source" ]; }; then
        printf 'health-check: refusing unsupported target type: %s\n' "$target" >&2
        return 1
      fi
      if [ ! -f "$source" ]; then
        printf 'health-check: target disappeared after preview: %s\n' "$target" >&2
        return 1
      fi
      mkdir -p "$(dirname "$destination")"
      cp -p "$source" "$destination" || return 1
      ;;
  esac
}

set_temp_mode() {
  local target="$1" temp="$2" mode
  if [ -f "$project_root/$target" ] && [ ! -L "$project_root/$target" ]; then
    mode="$(stat -f '%Lp' "$project_root/$target")"
    chmod "$mode" "$temp"
  fi
}

write_header_content() {
  local format="$1"
  case "$format" in
    learnings)
      printf '# Agent Learnings Index\n\nChronological index of agent learnings.\n**Newest entries are listed first.**\n\n| Date       | Category | Title | File | Status |\n|-----------|----------|-------|------|--------|\n'
      ;;
    changelog)
      printf '# Changelog Index\n\nChronological index of changelog entries and completed plans.\n**Newest entries are listed first.** Type can be added, changed, fixed, improved, docs, refactor, config, or plan.\n\n| Date       | Type    | Title | File | Notes |\n|-----------|---------|-------|------|-------|\n'
      ;;
    troubleshooting)
      printf '# Troubleshooting Index\n\nChronological index of troubleshooting entries.\n**Newest entries are listed first.**\n\n| Date       | Category    | Title | File | Status   |\n|-----------|-------------|-------|------|----------|\n'
      ;;
  esac
}

apply_repair() {
  local kind="${repair_kinds[$1]}" target="${repair_targets[$1]}"
  local target_abs="$project_root/${repair_targets[$1]}" backup_rel="${repair_backup_paths[$1]}"
  local parent anchor="Read \`PROJECT.md\` before starting work"
  case "$kind" in
    directory)
      backup_target "$target" "$backup_rel" || return 1
      if [ -L "$target_abs" ] || [ -e "$target_abs" ]; then
        printf 'health-check: target is no longer absent: %s\n' "$target" >&2
        return 1
      fi
      mkdir "$target_abs"
      ;;
    claude-link)
      backup_target "$target" "$backup_rel" || return 1
      if [ -e "$target_abs" ] || [ -L "$target_abs" ]; then
        if ! is_import_only_claude; then
          printf 'health-check: CLAUDE.md changed after preview; refusing replacement\n' >&2
          return 1
        fi
      fi
      parent="$(dirname "$target_abs")"
      tmp_link="$parent/.health-check-link.$$"
      if [ -e "$tmp_link" ] || [ -L "$tmp_link" ]; then
        printf 'health-check: temporary symlink path exists: %s\n' "$tmp_link" >&2
        return 1
      fi
      ln -s AGENTS.md "$tmp_link"
      mv -f "$tmp_link" "$target_abs"
      tmp_link=''
      ;;
    ignore|project-import|learnings-header|changelog-header|troubleshooting-header)
      backup_target "$target" "$backup_rel" || return 1
      if [ -L "$target_abs" ] || { [ -e "$target_abs" ] && [ ! -f "$target_abs" ]; }; then
        printf 'health-check: refusing unsupported target type: %s\n' "$target" >&2
        return 1
      fi
      if [ "$kind" = project-import ] && grep -Fxq '@PROJECT.md' "$target_abs"; then
        printf 'health-check: @PROJECT.md appeared after preview; no change made\n' >&2
        return 1
      fi
      if [ "$kind" = ignore ] && workflow_path_ignored_by_project; then
        printf 'health-check: workflow path became ignored after preview; no change made\n'
        return 0
      fi
      parent="$(dirname "$target_abs")"
      if [ ! -d "$parent" ]; then
        printf 'health-check: parent directory is still absent: %s\n' "$parent" >&2
        return 1
      fi
      tmp_file="$(mktemp "$parent/.health-check.XXXXXX")"
      if [ -f "$target_abs" ]; then
        cat "$target_abs" > "$tmp_file"
        set_temp_mode "$target" "$tmp_file"
      fi
      case "$kind" in
        ignore)
          printf '\n# Workflow-Scripts (separate repo, managed independently)\n%s\n' "$workflow_rel" >> "$tmp_file"
          ;;
        project-import)
          local line
          local insert_count=0
          while IFS= read -r line || [ -n "$line" ]; do
            printf '%s\n' "$line" >> "$tmp_file"
            case "$line" in
              *"$anchor"*)
                insert_count=$((insert_count + 1))
                printf '@PROJECT.md\n' >> "$tmp_file"
                ;;
            esac
          done < "$target_abs"
          if [ "$insert_count" -ne 1 ]; then
            rm -f "$tmp_file"
            tmp_file=''
            printf 'health-check: unique PROJECT.md anchor changed after preview\n' >&2
            return 1
          fi
          ;;
        *)
          local format="$kind"
          case "$kind" in
            learnings-header) format=learnings ;;
            changelog-header) format=changelog ;;
            troubleshooting-header) format=troubleshooting ;;
          esac
          write_header_content "$format" > "$tmp_file"
          if [ -f "$target_abs" ]; then
            cat "$target_abs" >> "$tmp_file"
            set_temp_mode "$target" "$tmp_file"
          fi
          ;;
      esac
      mv -f "$tmp_file" "$target_abs"
      tmp_file=''
      ;;
    *)
      printf 'health-check: unknown repair type: %s\n' "$kind" >&2
      return 1
      ;;
  esac
}

recheck_id() {
  local id="$1"
  collect_repairs=0
  case "$id" in
    H03) check_h03 ;;
    H05) check_h05 ;;
    H06) check_h06 ;;
    H09) check_h09 ;;
    H10) check_h10 ;;
    *) printf 'health-check: no recheck handler for %s\n' "$id" >&2; return 1 ;;
  esac
}

printf 'Consumer health check: %s\n' "$project_root"
if [ "$repair_requested" -eq 1 ]; then collect_repairs=1; fi
run_checks
collect_repairs=0

if [ "$repair_requested" -eq 1 ]; then
  if [ ! -t 0 ]; then
    repair_skipped_no_tty=1
    printf '%s\n' 'repairs skipped: no terminal'
  else
    local_i=0
    while [ "$local_i" -lt "$repair_count" ]; do
      printf '\nrepair %s: %s\n' "${repair_ids[$local_i]}" "${repair_targets[$local_i]}"
      printf 'target: %s\n' "${repair_targets[$local_i]}"
      printf 'command-equivalent: %s\n' "${repair_commands[$local_i]}"
      printf 'backup: %s\n' "${repair_backup_paths[$local_i]}"
      printf 'Apply? [y/N] '
      answer=''
      IFS= read -r answer || answer=''
      case "$answer" in
        y|Y)
          if apply_repair "$local_i"; then
            printf 'applied: %s %s\n' "${repair_ids[$local_i]}" "${repair_targets[$local_i]}"
            recheck_id "${repair_ids[$local_i]}"
          else
            printf 'repair failed or was skipped: %s %s\n' "${repair_ids[$local_i]}" "${repair_targets[$local_i]}"
          fi
          ;;
        *)
          declined_count=$((declined_count + 1))
          printf 'declined: %s %s\n' "${repair_ids[$local_i]}" "${repair_targets[$local_i]}"
          ;;
      esac
      local_i=$((local_i + 1))
    done
  fi
  printf '\nFinal report after repair decisions:\n'
  pass_count=0; warn_count=0; fail_count=0; check_count=0
  run_checks
fi

if [ "$canary_requested" -eq 1 ]; then
  if [ ! -f "$project_root/AGENTS.md" ] || ! grep -q 'PROJECT\.md' "$project_root/AGENTS.md" || \
     [ ! -L "$project_root/CLAUDE.md" ] || \
     [ "$(readlink "$project_root/CLAUDE.md" 2>/dev/null || true)" != AGENTS.md ]; then
    emit FAIL H12 'rules-load canary precondition failed; no model call made'
  else
    canary_output=''
    canary_code=0
    set +e
    canary_output="$(bash "$rules_check" "$project_root" 2>&1)"
    canary_code=$?
    set -e
    if [ "$canary_code" -eq 0 ]; then
      emit PASS H12 'rules load from a subfolder (headless canary passed)'
    elif printf '%s\n' "$canary_output" | grep -qF 'canary not seen from a subfolder session'; then
      emit FAIL H12 "rules did not load from a subfolder: $canary_output"
    else
      emit WARN H12 "canary was inconclusive because the Claude environment was unavailable: $canary_output"
    fi
  fi
else
  printf '%s\n' 'SKIP  H12  not run (pass --canary to make the opt-in model call)'
fi

printf 'summary: %s PASS, %s WARN, %s FAIL (%s checks)' \
  "$pass_count" "$warn_count" "$fail_count" "$check_count"
if [ "$canary_requested" -eq 0 ]; then printf '; H12 not run'; fi
if [ "$repair_requested" -eq 1 ]; then
  printf '; declined: %s' "$declined_count"
  [ "$repair_skipped_no_tty" -eq 1 ] && printf '; repairs skipped: no terminal'
fi
printf '\n'

if [ "$fail_count" -gt 0 ]; then exit 1; fi
exit 0
