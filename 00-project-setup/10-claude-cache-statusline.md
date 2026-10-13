# Claude Code Prompt-Cache Status Line

A second status line for Claude Code. Line 2 shows when the prompt cache expires, how much of the cache has been used, and how many tokens the next message will re-cache if the cache has gone cold.

This is a **per-computer** setup. [01-setup-project.md](./01-setup-project.md) calls it in **Step 2.13**. You can also run it on its own.

Contents:

1. [Scope](#1-scope)
2. [Permission gate](#2-permission-gate)
3. [Step 1: Check the local install (read-only)](#3-step-1-check-the-local-install-read-only)
4. [Step 2: Ask before changing anything](#4-step-2-ask-before-changing-anything)
5. [Step 3: Install (after a yes)](#5-step-3-install-after-a-yes)
6. [Step 4: Test](#6-step-4-test)
7. [Step 5: Check in Claude Code](#7-step-5-check-in-claude-code)
8. [Step 6: Check for project overrides](#8-step-6-check-for-project-overrides)
9. [States](#9-states)
10. [Troubleshooting](#10-troubleshooting)
11. [Reference: input fields](#11-reference-input-fields)
12. [Reference: cache behaviour](#12-reference-cache-behaviour)
13. [Reference: which settings file wins](#13-reference-which-settings-file-wins)
14. [Removing it](#14-removing-it)
15. [Appendix: an existing status line's logic](#15-appendix-an-existing-status-lines-logic)

---

## 1. Scope

- The files are **user-level**: `~/.claude/settings.json` and `~/.claude/statusline.sh`. They apply to every Claude Code session on the computer.
- A project's own `statusLine` (in `.claude/settings.json` or `.claude/settings.local.json`) replaces the whole block in that project. The project does not inherit the script or `refreshInterval`. Step 6 checks for this.
- Nothing here changes a repository. Nothing is committed.

Requirements:

- **Claude Code 2.1.251 or later.** The input fields in section 11 were checked against Claude Code 2.1.296. Check your version with `claude --version`.
- **macOS or Linux.** The script is bash. Windows is not covered; WSL and Git Bash are untested.
- **bash.** macOS's built-in bash 3.2 works (tested).
- **jq.** `brew install jq` on macOS, `sudo apt install jq` on Debian or Ubuntu.

## 2. Permission gate

Only Step 1 runs without asking. Before you write under `~/.claude/`, install a package such as `jq`, or change a project's settings, get a clear **yes from the user for that specific change**. A yes to one change does not cover another. If the user says no, record that in the setup notes and stop here.

## 3. Step 1: Check the local install (read-only)

```bash
claude --version
command -v jq && jq --version
ls -l ~/.claude/statusline.sh 2>/dev/null || echo "no ~/.claude/statusline.sh"
jq '.statusLine // "none"' ~/.claude/settings.json
```

Then find the row that matches what you saw:

| What you found | What it means | Next |
|---|---|---|
| Claude Code older than 2.1.251 | Too old for `prompt_cache` | Tell the user. Do not upgrade it yourself. Stop here. |
| `jq` not found | The script cannot read its input | Ask permission to install it (Step 2). |
| `statusLine` is `"none"` | No status line yet | Step 3, **variant A**. |
| `statusLine` is a command, and there is no `statusline.sh` | The computer already has its own status line | Step 3, **variant B**. Keep the existing output. |
| `statusline.sh` exists and `statusLine` runs it | Already installed | No change. Run Steps 4 and 5 to confirm. |
| `statusLine` runs some other script | Another tool owns it | Ask whether to replace it. Do not replace it without a yes. |

## 4. Step 2: Ask before changing anything

Show the user the change set, then ask for a yes or no:

- Create `~/.claude/statusline.sh` (variant A or B).
- Back up `~/.claude/settings.json`, then set its `statusLine` key to `bash "$HOME/.claude/statusline.sh"` with `refreshInterval: 30`. The other keys stay as they are.

Ask: **"Install the prompt-cache status line on this computer with these changes?"**

## 5. Step 3: Install (after a yes)

### 3.1 Back up

```bash
cp ~/.claude/settings.json ~/.claude/settings.json.bak-$(date +%Y-%m-%d-%H%M%S)
[ -f ~/.claude/statusline.sh ] && cp ~/.claude/statusline.sh ~/.claude/statusline.sh.bak-$(date +%Y-%m-%d-%H%M%S)
```

### 3.2 Create the script

**Variant A (no existing status line).** Save this as `~/.claude/statusline.sh`:

```bash
#!/usr/bin/env bash
# Claude Code status line: user@host:dir on line 1, prompt-cache segment on line 2.
# Stdin is read once so both segments see the same JSON.

input=$(cat)

# Original segment, unchanged.
dir=$(echo "$input" | jq -r '.workspace.current_dir')
printf "$(whoami)@$(hostname -s):$(basename "$dir")"

# Cache segment: shown only once prompt_cache appears in the input.
cache=$(echo "$input" | jq -c '.prompt_cache // empty' 2>/dev/null)
[ -z "$cache" ] && exit 0

# "|" rather than a tab: tab is whitespace in IFS, so empty fields would collapse.
IFS='|' read -r warm ttl expires hit misses cause recache <<< "$(echo "$cache" | jq -r '[
  (.warm // false),
  (.ttl // "1h"),
  (.expires_at // 0),
  (.hit_ratio // -1),
  (.misses // 0),
  (.last_miss_cause.causes[0] // ""),
  (.recache_tokens_if_cold // -1)
] | map(tostring) | join("|")')"

now=$(date +%s)
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

if [ "$warm" = "true" ] && [ "$expires" -gt 0 ]; then
  total=3600
  [ "$ttl" = "5m" ] && total=300

  remaining=$(( expires - now ))
  [ "$remaining" -lt 0 ] && remaining=0

  # Progress bar: six cells, rounded to the nearest cell.
  filled=$(( (remaining * 6 + total / 2) / total ))
  [ "$filled" -gt 6 ] && filled=6
  bar=""
  for ((i = 0; i < 6; i++)); do
    if [ "$i" -lt "$filled" ]; then bar+="█"; else bar+="░"; fi
  done

  if [ "$remaining" -ge 60 ]; then
    left="$(( remaining / 60 ))m left"
  else
    left="${remaining}s left"
  fi

  color=$GREEN
  [ $(( remaining * 5 )) -lt "$total" ] && color=$YELLOW

  line="cache ● ${ttl} ${bar} ${left}"
  if awk -v h="$hit" 'BEGIN { exit !(h >= 0) }'; then
    hit_pct=$(awk -v h="$hit" 'BEGIN { printf "%d", h * 100 + 0.5 }')
    line+=" · hit ${hit_pct}%"
  fi
  line+=" · misses ${misses}"
  printf '\n%b%s%b' "$color" "$line" "$RESET"
else
  line="cache ○ cold"
  if [ "$recache" -ge 0 ] 2>/dev/null; then
    line+=" · next message re-caches $(( (recache + 500) / 1000 ))k tokens"
  fi
  [ -n "$cause" ] && line+=" · ${cause}"
  printf '\n%b%s%b' "$RED" "$line" "$RESET"
fi
```

What the script does:

- Line 1 is the original status line (`user@host:folder`). The "Original segment" lines are the placeholder for it.
- Line 2 is the cache segment. It appears only when Claude Code's input contains `prompt_cache`.
- It reads stdin once, so both lines use the same input.

**Variant B (keep an existing status line).** Save the same file, but replace the two "Original segment" lines (the `dir=` and `printf` lines) with your existing command's logic. Keep `input=$(cat)` at the top. The logic must read `$input`, not stdin, because the script has already read stdin. Leave the cache segment as it is. The Appendix shows the logic from the first computer this was installed on.

### 3.3 Point the settings at the script

```bash
tmp=$(mktemp)
jq --arg cmd 'bash "$HOME/.claude/statusline.sh"' \
  '.statusLine = {type:"command", command:$cmd, refreshInterval:30}' \
  ~/.claude/settings.json > "$tmp" && jq empty "$tmp" && cat "$tmp" > ~/.claude/settings.json
rm -f "$tmp"
```

Use `cat "$tmp" > ~/.claude/settings.json`, not `mv`. It keeps the file's permissions (`0600`).

### 3.4 Check that only `statusLine` changed

```bash
BAK=$(ls -t ~/.claude/settings.json.bak-* | head -1)
diff <(jq 'del(.statusLine)' "$BAK") <(jq 'del(.statusLine)' ~/.claude/settings.json) && echo "✓ only statusLine changed"
```

## 6. Step 4: Test

### 4.1 Syntax

```bash
bash -n ~/.claude/statusline.sh && echo "✓ syntax OK"
```

### 4.2 Variant B only: line 1 must match the old command

```bash
BAK=$(ls -t ~/.claude/settings.json.bak-* | head -1)
OLD_CMD=$(jq -r '.statusLine.command' "$BAK")
IN=$(mktemp); OLD=$(mktemp); NEW=$(mktemp)
jq -nc --arg d "$HOME" '{workspace:{current_dir:$d}, model:{display_name:"Claude Haiku 5.5"}, output_style:{name:"default"}, context_window:{current_usage:null, context_window_size:200000}}' > "$IN"
bash -c "$OLD_CMD" < "$IN" > "$OLD"
bash ~/.claude/statusline.sh < "$IN" > "$NEW"
cmp "$OLD" "$NEW" && echo "✓ line 1 unchanged"
rm -f "$IN" "$OLD" "$NEW"
```

Run it with a git repository and a non-git folder as `workspace.current_dir` as well, because the existing logic may branch on them.

### 4.3 Cache states

Run each sample. Each one should match the state in section 9.

```bash
NOW=$(date +%s)

# Warm, 25 minutes left (green)
jq -nc --arg d "$HOME" --argjson e $((NOW+1500)) '{workspace:{current_dir:$d}, prompt_cache:{warm:true, ttl:"1h", expires_at:$e, hit_ratio:0.9, misses:0}}' | bash ~/.claude/statusline.sh; echo

# About to expire, 10 minutes left (yellow; shows 9m or 10m because a few seconds pass)
jq -nc --arg d "$HOME" --argjson e $((NOW+600)) '{workspace:{current_dir:$d}, prompt_cache:{warm:true, ttl:"1h", expires_at:$e, hit_ratio:0.88, misses:1}}' | bash ~/.claude/statusline.sh; echo

# Cold, with a re-cache count and a miss cause (red)
jq -nc --arg d "$HOME" '{workspace:{current_dir:$d}, prompt_cache:{warm:false, expires_at:null, hit_ratio:0.5, misses:2, last_miss_cause:{causes:["ttl_expired_1h"]}, recache_tokens_if_cold:82000}}' | bash ~/.claude/statusline.sh; echo

# No prompt_cache: line 1 only
jq -nc --arg d "$HOME" '{workspace:{current_dir:$d}}' | bash ~/.claude/statusline.sh; echo
```

## 7. Step 5: Check in Claude Code

Start a **new** Claude Code session. Settings are read when a session starts, so a session that was already open will not show the change.

- Line 1 is the same as before.
- Line 2 appears once Claude Code includes `prompt_cache` in its input. If it does not, see [Troubleshooting](#10-troubleshooting).

## 8. Step 6: Check for project overrides

A project's own `statusLine` replaces the user-level one in that project. Run this from the project root:

```bash
for f in .claude/settings.json .claude/settings.local.json; do
  [ -f "$f" ] && jq -e 'has("statusLine")' "$f" >/dev/null 2>&1 && echo "⚠ $f sets its own statusLine (it replaces the user-level one here)"
done
```

To scan every project on the computer once (adjust the folder to yours):

```bash
find ~/Development -path '*/.claude/settings*.json' -not -path '*/node_modules/*' 2>/dev/null | while read -r f; do
  jq -e 'has("statusLine")' "$f" >/dev/null 2>&1 && echo "OVERRIDE: $f"
done
```

Report any override to the user. Change a project's settings only with a yes.

## 9. States

| State | Example line 2 | Colour |
|---|---|---|
| Warm, more than 20% of the TTL left | `cache ● 1h ████░░ 38m left · hit 91% · misses 0` | green |
| Warm, under 20% of the TTL left | `cache ● 1h █░░░░░ 10m left · hit 88% · misses 1` | yellow |
| Cold, with a re-cache count and a miss cause | `cache ○ cold · next message re-caches 82k tokens · ttl_expired_1h` | red |
| Cold, no re-cache count | `cache ○ cold` | red |
| No `prompt_cache` in the input | (line 2 omitted) | n/a |

- The bar has six cells and shows the share of the TTL that is left. The TTL is 1h or 5m, depending on what the last request wrote.
- `hit` is the share of input tokens read from cache. It is omitted when `hit_ratio` is null.
- The miss cause appears only in the cold state, and only when Claude Code reports one.

## 10. Troubleshooting

**Line 2 never appears.**
Capture the raw input to see what Claude Code sends. Add this line directly after `input=$(cat)` in `~/.claude/statusline.sh`:

```bash
printf '%s' "$input" > "$HOME/.claude/statusline-last-input.json"
```

Start a session, then inspect the file with `jq . ~/.claude/statusline-last-input.json`. If there is no `prompt_cache` key, your Claude Code version may be too old (`claude --version`). Remove the capture line afterwards.

**`jq: command not found`.**
Install jq (section 1). Without it, the script cannot read its input.

**Line 1 is different from before.**
In variant B, the logic in the "Original segment" lines has drifted from the old command. Run the test in Step 4.2 and compare with the backup from Step 3.1. In variant A, you probably edited the "Original segment" lines; restore them.

**The countdown does not tick.**
Check that `statusLine` has `refreshInterval` set to at least 1.

**One project shows no cache line.**
That project has its own `statusLine` (section 8). Remove it, or point it at `~/.claude/statusline.sh` with a yes from the user.

## 11. Reference: input fields

These are the fields of the `prompt_cache` object, from the schema in Claude Code 2.1.296. The script uses `warm`, `ttl`, `expires_at`, `hit_ratio`, `misses`, `last_miss_cause`, and `recache_tokens_if_cold`. The rest are available if you want to extend it.

| Field | Type | Meaning |
|---|---|---|
| `warm` | boolean | The cached prefix is still inside its TTL. False when the last response reported no cache tokens. |
| `caching_observed` | boolean | Some response reported cache tokens. False means caching is off or not reported by the provider. |
| `ttl` | `"5m"` or `"1h"` | The TTL the last request wrote. |
| `expires_at` | number or null | Unix epoch **seconds** when the prefix goes cold. Null when the last response reported no cache tokens. |
| `requests` | number | Main-conversation requests this session. |
| `misses` | number | Requests whose cached prefix shrank without a compaction explaining it. |
| `expected_rebuilds` | number | Prefix rebuilds announced by a compaction or tool-result clearing. |
| `hit_ratio` | number or null | `cache_read / (cache_read + cache_creation + uncached input)`, from 0 to 1. |
| `cache_write_tokens` | number | All cache-creation tokens written this session. |
| `miss_recache_tokens` | number | Cache-creation tokens written by requests counted as misses. |
| `last_miss_at` | number or null | Unix epoch seconds of the last miss. |
| `last_miss_cause` | object or null | Likely cause of the most recent miss (a client-side heuristic). Has a `causes` array from a closed set, plus optional `tools_added`, `tools_removed`, and `system_char_delta`. |
| `miss_causes` | object | Misses per cause this session, e.g. `{"ttl_expired_1h": 2}`. |
| `recache_tokens_if_cold` | number or null | Tokens the next request re-caches if the cache is cold by then. Null right after a compaction. |

Cause names in `last_miss_cause.causes` include `ttl_expired_5m`, `ttl_expired_1h`, `system_prompt_changed`, `tools_changed`, `model_changed`, `messages_rewritten`, `likely_server_side`, and `unknown`.

Also in the input, `workspace.current_dir` is the project folder. The original status line uses it.

## 12. Reference: cache behaviour

Taken from the original tip. These were not re-checked against the live docs when this file was written.

- **Lifetime.** On a subscription, within your plan's usage, the main conversation's cache lasts 1 hour. Subagents and workflows get 5 minutes. On an API key, or once you're past your limit and on usage credits, the main conversation gets 5 minutes.
- **Model switches.** Switching models mid-session recomputes the cache. With `opusplan`, every move into or out of plan mode counts as a switch.
- **CLAUDE.md edits.** Editing CLAUDE.md mid-session does not break the cache, but the edit does not apply until `/clear`, `/compact`, or a restart.
- **Redoing work.** `/rewind` can pick up the cache you already had. `/compact` builds a new one.
- **Practical tip.** If the cache is about to expire and you still have something to ask, ask it now. The next message after expiry re-caches the whole conversation.

## 13. Reference: which settings file wins

From the official settings documentation. Highest precedence first:

1. **Managed settings.** Set by your organisation, through `managed-settings.json`, MDM, or the claude.ai console.
2. **Command line.** `claude --settings <file-or-json>`, for that session only.
3. **Project local.** `.claude/settings.local.json`. You, in this project only.
4. **Shared project.** `.claude/settings.json`. Everyone in the project.
5. **User.** `~/.claude/settings.json`. You, in every project.

- A key set at a higher level replaces the value from a lower level.
- Arrays merge across levels. `statusLine` is an object, not an array, so a project's `statusLine` **replaces this whole block**. The project does not inherit `refreshInterval` or the script.
- When this was first set up, managed settings and project-level `statusLine` keys were checked under the home directory and the Skynet project folder, and none were found. Other folders were not checked. Step 6 covers the rest.

## 14. Removing it

Restore the backup from Step 3.1 (variant B: restore the earlier command), or delete the `statusLine` key from `~/.claude/settings.json`. Then delete `~/.claude/statusline.sh` if you do not want the script.

## 15. Appendix: an existing status line's logic

This is the logic that replaced the "Original segment" lines on the first computer this was installed on (variant B). It shows user@host, the folder, the model, the output style, context usage, and the git branch. It is a fragment, not a full script: it goes where the two "Original segment" lines were. Your computer's logic will differ, so use this only as a model.

```bash
# Original segment: the statusLine command this computer already had, moved here
# with the same output. It reads $input, not stdin.
model=$(echo "$input" | jq -r '.model.display_name' | sed 's/Claude //')
style=$(echo "$input" | jq -r '.output_style.name')
cwd=$(echo "$input" | jq -r '.workspace.current_dir' | sed "s|^$HOME|~|")

usage=$(echo "$input" | jq '.context_window.current_usage')
if [ "$usage" != "null" ]; then
  current=$(echo "$usage" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
  size=$(echo "$input" | jq '.context_window.context_window_size')
  pct=$((current * 100 / size))
  ctx_info=$(printf ' | \033[0;33m%dk/%dk ctx (%d%%)\033[0m' $((current / 1000)) $((size / 1000)) "$pct")
else
  ctx_info=''
fi

git_info=''
if [ -d "$(echo "$input" | jq -r '.workspace.current_dir')/.git" ]; then
  cd "$(echo "$input" | jq -r '.workspace.current_dir')" 2>/dev/null && branch=$(git --no-optional-locks branch --show-current 2>/dev/null || echo '')
  [ -n "$branch" ] && git_info=$(printf ' | \033[0;36m%s\033[0m' "$branch")
fi

printf '\033[0;32m%s@%s\033[0m:\033[0;34m%s\033[0m | \033[0;35m%s\033[0m | %s%s%s' "$(whoami)" "$(hostname -s)" "$cwd" "$model" "$style" "$git_info" "$ctx_info"
```
