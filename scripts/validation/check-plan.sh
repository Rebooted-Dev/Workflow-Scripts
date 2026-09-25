#!/usr/bin/env bash
# Structural plan linter. Plans opt in with **Tier:** T1/T2/T3; unmarked plans
# remain compatible as legacy documents.
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "check-plan: usage: check-plan.sh <plan>" >&2
  exit 2
fi

plan="$1"
if [ ! -f "$plan" ] || [ ! -r "$plan" ]; then
  echo "check-plan: $plan: file is missing or unreadable" >&2
  exit 1
fi

tier_state="$(awk '
  /^[[:space:]]*(```|~~~)/ {
    fence_line = $0
    sub(/^[[:space:]]*/, "", fence_line)
    fence_marker = substr(fence_line, 1, 1)
    if (!in_fence) {
      in_fence = 1
      fence_char = fence_marker
    } else if (fence_marker == fence_char) {
      in_fence = 0
    }
    next
  }
  !in_fence && /^[[:space:]]*\*\*Tier/ {
    if ($0 ~ /^[[:space:]]*\*\*Tier:\*\*[[:space:]]+T[123][[:space:]]*$/) {
      count++
      tier = $0
      sub(/^[[:space:]]*\*\*Tier:\*\*[[:space:]]+/, "", tier)
      sub(/[[:space:]]*$/, "", tier)
    } else {
      malformed++
    }
  }
  END {
    if (malformed > 0 || count > 1) print "MALFORMED"
    else if (count == 0) print "LEGACY"
    else print tier
  }
' "$plan")"

case "$tier_state" in
  MALFORMED)
    echo "check-plan: $plan: malformed Tier header; expected exactly one **Tier:** T1, T2, or T3" >&2
    exit 1
    ;;
  LEGACY)
    echo "check-plan: $plan: warning: no **Tier:** header; treating as legacy" >&2
    exit 0
    ;;
esac

errors="$(awk -v tier="$tier_state" '
  function add_error(reason) {
    print reason
    error_count++
  }

  function finish_task() {
    if (in_task) {
      if (!task_has_files) add_error("task " task_number " is missing Files:")
      if (!task_has_verify) add_error("task " task_number " is missing Verify:")
      in_task = 0
      child_active = 0
    }
  }

  function is_checkbox_line(line, remainder, close_bracket, marker) {
    indent_prefix = line
    sub(/[^[:space:]].*$/, "", indent_prefix)
    checkbox_indent = length(indent_prefix)
    checkbox_has_tab = indent_prefix ~ /\t/

    remainder = line
    sub(/^[[:space:]]*/, "", remainder)
    if (remainder ~ /^[-*+][[:space:]]+\[/) {
      checkbox_prefix = remainder
      sub(/\[.*$/, "", checkbox_prefix)
      checkbox_content_indent = checkbox_indent + length(checkbox_prefix)
      if (checkbox_prefix ~ /\t/) checkbox_has_tab = 1
      checkbox_kind = "bullet"
      sub(/^[-*+][[:space:]]+\[/, "", remainder)
    } else if (remainder ~ /^[0-9]+[.)][[:space:]]+\[/) {
      checkbox_prefix = remainder
      sub(/\[.*$/, "", checkbox_prefix)
      checkbox_content_indent = checkbox_indent + length(checkbox_prefix)
      if (checkbox_prefix ~ /\t/) checkbox_has_tab = 1
      checkbox_kind = "ordered"
      sub(/^[0-9]+[.)][[:space:]]+\[/, "", remainder)
    } else {
      return 0
    }

    close_bracket = index(remainder, "]")
    if (close_bracket == 0) return 0
    marker = substr(remainder, 1, close_bracket - 1)
    if (marker != " " && marker != "x" && marker != "X" && marker != "✅") return 0

    task_tail = substr(remainder, close_bracket + 1)
    return task_tail ~ /^[[:space:]]+[^[:space:]]/
  }

  function is_task_checkbox(line) {
    checkbox_ambiguous = 0
    if (checkbox_indent > 3 || !in_task) return checkbox_indent <= 3

    # Same/lower indentation and indentation before the current content
    # column are top-level siblings. At a deeper content column, a different
    # list kind is a child; same-kind 0-3-space nesting is ambiguous and fails
    # closed instead of silently choosing parent or child ownership.
    if (checkbox_indent <= task_indent || checkbox_indent < task_content_indent) return 1
    if (checkbox_kind != task_kind) return 0
    checkbox_ambiguous = 1
    return 0
  }

  function has_field(line, name, text) {
    text = line
    sub(/^[[:space:]]*/, "", text)
    if (text ~ /^[-*+][[:space:]]+/) sub(/^[-*+][[:space:]]+/, "", text)
    return text ~ ("(^|[[:space:]])" name ":[[:space:]]*[^[:space:]]")
  }

  function record_task_field(line, name, prefix, indent, key) {
    if (!has_field(line, name)) return

    prefix = line
    sub(/[^[:space:]].*$/, "", prefix)
    indent = length(prefix)
    if (prefix ~ /\t/) {
      add_error("task " task_number " uses a tab-indented " name ": field; use spaces")
      return
    }

    key = task_number SUBSEP indent
    if (child_active && !(key in parent_field_indents)) {
      # After a child begins, only an already-established parent field indent,
      # or a field shallower than the child content column, can belong upward.
      # Deeper/unanchored fields are child-level or ambiguous and never satisfy
      # the parent, which fails closed if its own evidence is absent.
      if (indent >= child_content_indent) return
    }

    parent_field_indents[key] = 1
    if (indent > parent_field_max_indent) parent_field_max_indent = indent
    if (name == "Files") task_has_files = 1
    if (name == "Verify") task_has_verify = 1
  }

  function heading_text(line, text) {
    text = line
    sub(/^##[[:space:]]+/, "", text)
    sub(/[[:space:]]+#+[[:space:]]*$/, "", text)
    sub(/[[:space:]]+$/, "", text)
    return text
  }

  function option_line(line, text) {
    text = line
    sub(/^[[:space:]]*/, "", text)
    if (text ~ /^[-*+][[:space:]]+/) {
      sub(/^[-*+][[:space:]]+/, "", text)
    } else if (text ~ /^[0-9]+[.)][[:space:]]+/) {
      sub(/^[0-9]+[.)][[:space:]]+/, "", text)
    }
    sub(/^\*\*/, "", text)
    return tolower(text) ~ /^option[[:space:]]+[a-z0-9]/
  }

  /^[[:space:]]*(```|~~~)/ {
    fence_line = $0
    sub(/^[[:space:]]*/, "", fence_line)
    fence_marker = substr(fence_line, 1, 1)
    if (!in_fence) {
      in_fence = 1
      fence_char = fence_marker
    } else if (fence_marker == fence_char) {
      in_fence = 0
    }
    next
  }

  !in_fence && /^###[#]*[[:space:]]+/ {
    if (in_tasks) finish_task()
    next
  }

  !in_fence && /^#[[:space:]]+/ {
    if (in_tasks) finish_task()
    next
  }

  !in_fence && /^##[[:space:]]+/ {
    finish_task()
    heading = heading_text($0)
    in_tasks = (heading == "Tasks")
    in_decision = (heading == "Decision")

    if (heading == "Goal") has_goal = 1
    if (heading == "Change Surface") has_change_surface = 1
    if (heading == "Tasks") has_tasks_heading = 1
    if (heading == "Decision") has_decision = 1
    if (heading == "Design & Interfaces") has_design = 1
    if (heading == "Failure Modes & Recovery") has_failure_modes = 1
    if (heading == "Test Strategy") has_test_strategy = 1
    if (heading == "Rollout & Rollback") has_rollout = 1
    next
  }

  {
    if (in_fence) next

    if (in_decision && option_line($0)) {
      option_count++
      if (tolower($0) ~ /minimal/) has_minimal_option = 1
    }

    if (in_tasks && is_checkbox_line($0)) {
      if (checkbox_has_tab) {
        finish_task()
        add_error("checkbox at line " NR " uses tab indentation; use 0-3 spaces for top-level tasks and 4+ spaces for nested children")
        next
      }

      if (is_task_checkbox($0)) {
        finish_task()
        task_number++
        in_task = 1
        task_indent = checkbox_indent
        task_content_indent = checkbox_content_indent
        task_kind = checkbox_kind
        task_has_files = 0
        task_has_verify = 0
        child_active = 0
        child_checkbox_indent = -1
        child_content_indent = -1
        parent_field_max_indent = -1
        if (has_field(task_tail, "Files")) {
          task_has_files = 1
          parent_field_indents[task_number SUBSEP task_indent] = 1
          parent_field_max_indent = task_indent
        }
        if (has_field(task_tail, "Verify")) {
          task_has_verify = 1
          parent_field_indents[task_number SUBSEP task_indent] = 1
          parent_field_max_indent = task_indent
        }
      } else if (in_task) {
        if (checkbox_ambiguous) {
          add_error("checkbox at line " NR " has ambiguous 0-3-space nesting; use same/lower indent for a sibling, a different marker at the content column, or 4+ spaces for a child")
          next
        }
        # Supported Markdown profile: top-level checkboxes use 0-3 literal
        # spaces. Same/lower-indent items and items before the parent list
        # content column are siblings; a different list kind at/after that
        # column, or any 4+ space checkbox, is a nested child. Same-kind items
        # at an ambiguous 0-3-space nested position are rejected. Tabs and
        # orphan 4+ items are rejected, never silently ignored.
        child_active = 1
        child_checkbox_indent = checkbox_indent
        # Keep the outermost child boundary for the top-level parent. Deeper
        # grandchildren have larger content indents and must not reclassify
        # their child-level fields as parent evidence.
        if (child_content_indent < 0 || checkbox_content_indent < child_content_indent) {
          child_content_indent = checkbox_content_indent
        }
        # If prior parent evidence reaches into child content column,
        # indentation alone cannot distinguish the owners; reject that layout.
        if (parent_field_max_indent >= child_content_indent) {
          add_error("task " task_number " has ambiguous parent/child field indentation; keep parent fields shallower than child content")
        }
      } else {
        add_error("checkbox at line " NR " is indented " checkbox_indent " spaces without an active parent task; top-level tasks allow 0-3 spaces")
      }
      next
    }

    if (in_tasks && in_task) {
      record_task_field($0, "Files")
      record_task_field($0, "Verify")
    }
  }

  END {
    finish_task()
    if (!has_goal) add_error("missing required section ## Goal")
    if (!has_change_surface) add_error("missing required section ## Change Surface")
    if (!has_tasks_heading) add_error("missing required section ## Tasks")
    if (task_number == 0) add_error("## Tasks contains no top-level checkbox task")

    if (tier == "T2" || tier == "T3") {
      if (!has_decision) add_error("missing required section ## Decision")
      if (!has_design) add_error("missing required section ## Design & Interfaces")
      if (!has_failure_modes) add_error("missing required section ## Failure Modes & Recovery")
      if (!has_test_strategy) add_error("missing required section ## Test Strategy")
      if (!has_rollout) add_error("missing required section ## Rollout & Rollback")
      if (option_count < 2) add_error("## Decision must contain at least two Option lines")
      if (!has_minimal_option) add_error("## Decision options must include a minimal Option")
    }
  }
' "$plan")"

if [ -n "$errors" ]; then
  while IFS= read -r reason; do
    [ -n "$reason" ] || continue
    printf 'check-plan: %s: %s\n' "$plan" "$reason" >&2
  done <<< "$errors"
  exit 1
fi

echo "check-plan: $plan: OK ($tier_state)"
