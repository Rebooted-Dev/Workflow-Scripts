# Claude Code prompt-cache status line: plan checkboxes and install on this computer

**Date:** 2026-10-13
**Type:** changed

## Summary

Gave `00-project/plans/claude-cache.md` the required `## Tasks` and `## Success Criteria` checkboxes and carried it out on this computer at user level, so every Claude Code session on the machine uses it.

- Created `~/.claude/statusline.sh` from plan Step 2. The computer already had a `statusLine` command (cwd, model, output style, context, git branch). It is kept as the "Original segment" and reads `$input`, so line 1 is unchanged. The prompt-cache segment is on line 2.
- Set the user-level `statusLine` in `~/.claude/settings.json` to `bash "$HOME/.claude/statusline.sh"` with `refreshInterval: 30`. No other key changed.
- Only the user-level files were changed. No repository code changed, and nothing was committed.

Live check (plan Step 6, line 2 in a new session) is still open. It needs a session the user starts.

## Rulings

- Kept the existing status line by moving its command into the script, not replacing it. Plan Step 3 and the user's instruction both require keeping the existing output. Cost if wrong: line 1 would need its original command restored, which is in the rollback below.
- Left the plan's `**Tier:**` header unset. Tiers switch on planning gates, so picking one is a policy call. The validator treats the plan as legacy and passes it. Cost if wrong: `--require-tier` fails until a tier is set.
- Did not upgrade Claude Code (2.1.296 already meets the 2.1.251 minimum).

## Verification

- `bash -n` on `~/.claude/statusline.sh` passes.
- Old inline command and new script give byte-identical output on four inputs (git repo with and without context usage, non-git dir, home dir).
- Cache states, with the colour codes checked: warm 25m green (`32m`), about to expire yellow (`33m`), cold red (`31m`). Cold without a recache count and no `prompt_cache` also behave as specified.
- `jq empty ~/.claude/settings.json` passes. Diff against the backup shows only the `statusLine` key changed.
- No project under `~/Development` has its own `statusLine`.
- `check-plan.sh --state` on the plan passes (legacy).

**Troubleshooting:** not needed — planned install and checkbox update; no defect found.

## Rollback

To restore the original status line, set the `statusLine` key in `~/.claude/settings.json` back to the value below and delete `~/.claude/statusline.sh`. The original `command` was:

```bash
input=$(cat); cwd=$(echo "$input" | jq -r '.workspace.current_dir' | sed "s|^$HOME|~|"); model=$(echo "$input" | jq -r '.model.display_name' | sed 's/Claude //'); style=$(echo "$input" | jq -r '.output_style.name'); usage=$(echo "$input" | jq '.context_window.current_usage'); if [ "$usage" != "null" ]; then current=$(echo "$usage" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens'); size=$(echo "$input" | jq '.context_window.context_window_size'); pct=$((current * 100 / size)); ctx_info=$(printf ' | \033[0;33m%dk/%dk ctx (%d%%)\033[0m' $((current / 1000)) $((size / 1000)) "$pct"); else ctx_info=''; fi; git_info=''; if [ -d "$(echo "$input" | jq -r '.workspace.current_dir')/.git" ]; then cd "$(echo "$input" | jq -r '.workspace.current_dir')" 2>/dev/null && branch=$(git --no-optional-locks branch --show-current 2>/dev/null || echo ''); [ -n "$branch" ] && git_info=$(printf ' | \033[0;36m%s\033[0m' "$branch"); fi; printf '\033[0;32m%s@%s\033[0m:\033[0;34m%s\033[0m | \033[0;35m%s\033[0m | %s%s%s' "$(whoami)" "$(hostname -s)" "$cwd" "$model" "$style" "$git_info" "$ctx_info"
```
