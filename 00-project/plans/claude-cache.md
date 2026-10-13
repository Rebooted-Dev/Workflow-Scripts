# Claude Code status line: prompt-cache countdown

A second status line that shows when Claude Code's prompt cache expires, how much of the cache has been used, and how many tokens the next message will re-cache if the cache has gone cold.

## Tasks

- [✅] Task 1: Check prerequisites. `jq` is on PATH (jq-1.8.2) and Claude Code is 2.1.296, which is at least 2.1.251 (section 1).
- [✅] Task 2: Keep the existing status line. This computer already had a `statusLine` command (cwd, model, output style, context, git branch). Back up `~/.claude/settings.json` and move that command into the script as the "Original segment" (Step 3).
- [✅] Task 3: Create `~/.claude/statusline.sh` from Step 2, with the original segment replaced as Step 3 describes. Syntax check passes.
- [✅] Task 4: Point the user-level `statusLine` at the script with `refreshInterval: 30` (Step 3). Other keys are unchanged.
- [✅] Task 5: Validate `~/.claude/settings.json` with `jq empty` (Step 4).
- [✅] Task 6: Test the script without Claude Code: warm, about to expire, cold, and no `prompt_cache` (Step 5 and section 3).
- [ ] Task 7: Check line 2 in a new Claude Code session (Step 6). Open: pending — needs a user-started session; it cannot be run from the agent.
- [✅] Task 8: Check for project-level `statusLine` overrides under `~/Development` (Step 7). None found.

## Success Criteria

- [✅] Line 1 is unchanged. Four sample inputs give output byte-identical to the old inline command.
- [✅] The cache segment shows the right text and colour: green when warm, yellow under 20% of the TTL, red when cold, and absent without `prompt_cache`.
- [✅] `settings.json` is valid JSON, and only the `statusLine` key changed.
- [✅] Every Claude Code session on this computer uses the script, because no project overrides `statusLine`.
- [ ] Open: pending — line 2 appears in a live Claude Code session and the countdown ticks. This needs a new session started by the user.

Contents:

1. [Requirements](#1-requirements)
2. [Setup on a new computer](#2-setup-on-a-new-computer)
3. [What the states look like](#3-what-the-states-look-like)
4. [Troubleshooting](#4-troubleshooting)
5. [Reference: input fields](#5-reference-input-fields)
6. [Reference: cache behaviour](#6-reference-cache-behaviour)
7. [Reference: which settings file wins](#7-reference-which-settings-file-wins)
8. [Original note](#8-original-note)

---

## 1. Requirements

- **Claude Code 2.1.251 or later** (the threshold given in the original note). The input fields in section 5 were checked against Claude Code 2.1.296. Check your version with `claude --version`.
- **macOS or Linux.** The script is bash. Windows is not covered; WSL or Git Bash are untested.
- **bash.** macOS's built-in bash 3.2 works (tested).
- **jq.** Install with `brew install jq` on macOS or `sudo apt install jq` on Debian or Ubuntu.

---

## 2. Setup on a new computer

Do these steps on the computer you want to set up. The paths are the same on macOS and Linux.

### Step 1: Install jq

```bash
jq --version
```

If this prints a version, go to step 2. If not, install jq using the command in section 1.

### Step 2: Create the script

Run this in a terminal. It creates `~/.claude/statusline.sh`:

```bash
mkdir -p ~/.claude
cat > ~/.claude/statusline.sh <<'EOF'
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
EOF
```

What the script does:

- Line 1 is your original status line (`user@host:folder`), unchanged.
- Line 2 is the cache segment. It appears only when Claude Code's input contains `prompt_cache`.
- It reads stdin once, so both lines use the same input.

### Step 3: Point Claude Code at the script

Open `~/.claude/settings.json`.

- If the file does not exist, create it with the JSON below.
- If the file exists, add or replace only the `statusLine` key. Keep the other keys (`model`, `theme`, and so on).

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash \"$HOME/.claude/statusline.sh\"",
    "refreshInterval": 30
  }
}
```

`refreshInterval` makes Claude Code re-run the script on a timer, so the countdown keeps moving. The value must be at least 1.

**If this computer already has a different status line:** keep `input=$(cat)` at the top of the script. Replace the two "Original segment" lines (lines 8 and 9 of the script, the `dir=...` and `printf ...` lines) with your existing command's logic. Make it read from `$input`, not from stdin again. Leave the cache segment as it is.

### Step 4: Check the settings file is valid JSON

```bash
jq empty ~/.claude/settings.json && echo "settings OK"
```

### Step 5: Test the script without Claude Code

Warm cache with 25 minutes left. Expect a green line 2:

```bash
NOW=$(date +%s)
jq -nc --arg d "$HOME" --argjson e $((NOW+1500)) \
  '{workspace:{current_dir:$d}, prompt_cache:{warm:true, ttl:"1h", expires_at:$e, hit_ratio:0.9, misses:0}}' \
  | bash ~/.claude/statusline.sh; echo
```

Expected output:

```
yourname@yourhost:yourfolder
cache ● 1h ███░░░ 25m left · hit 90% · misses 0
```

Cold cache. Expect a red line 2:

```bash
jq -nc --arg d "$HOME" \
  '{workspace:{current_dir:$d}, prompt_cache:{warm:false, expires_at:null, hit_ratio:0.5, misses:2, last_miss_cause:{causes:["ttl_expired_1h"]}, recache_tokens_if_cold:82000}}' \
  | bash ~/.claude/statusline.sh; echo
```

Expected output:

```
yourname@yourhost:yourfolder
cache ○ cold · next message re-caches 82k tokens · ttl_expired_1h
```

### Step 6: Check it in Claude Code

Start a new Claude Code session and look at the status line. Line 1 should be your original status line. Line 2 appears when Claude Code includes `prompt_cache` in its input. If line 2 doesn't appear, see section 4.

### Step 7: Check for project overrides

A project's own `statusLine` replaces the global one in that project (section 7). If a project shows no cache line, check its `.claude/settings.json` and `.claude/settings.local.json` for a `statusLine` key.

---

## 3. What the states look like

| State | Example line 2 | Colour |
|---|---|---|
| Warm, more than 20% of the TTL left | `cache ● 1h ████░░ 38m left · hit 91% · misses 0` | green |
| Warm, under 20% of the TTL left | `cache ● 1h █░░░░░ 10m left · hit 88% · misses 1` | yellow |
| Cold, with a recache count and a miss cause | `cache ○ cold · next message re-caches 82k tokens · ttl_expired_1h` | red |
| Cold, no recache count | `cache ○ cold` | red |
| No `prompt_cache` in the input | (line 2 omitted) | n/a |

- The bar has six cells and shows the share of the TTL that is left. The TTL is 1h or 5m, depending on what the last request wrote.
- `hit` is the share of input tokens read from cache. It is omitted when `hit_ratio` is null.
- The miss cause appears only in the cold state, and only when Claude Code reports one.

---

## 4. Troubleshooting

**Line 2 never appears.**
Capture the raw input to see what Claude Code sends. Add this line directly after `input=$(cat)` in `~/.claude/statusline.sh`:

```bash
printf '%s' "$input" > "$HOME/.claude/statusline-last-input.json"
```

Start a session, then inspect the file:

```bash
jq . ~/.claude/statusline-last-input.json
```

If there is no `prompt_cache` key, your Claude Code version may be too old (`claude --version`). Remove the capture line afterwards.

**`jq: command not found`.**
Install jq (section 1). Without it, the script can't read its input.

**Line 1 is different from before.**
You probably edited the "Original segment" lines. Restore them to your original command.

**The countdown doesn't tick.**
Check that `statusLine` has `refreshInterval` set to at least 1.

**One project shows no cache line.**
That project has its own `statusLine` (section 7). Remove it, or point it at `~/.claude/statusline.sh`.

**Remove the status line.**
Delete the `statusLine` key from `~/.claude/settings.json` and delete `~/.claude/statusline.sh`.

---

## 5. Reference: input fields

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

---

## 6. Reference: cache behaviour

From the original note. These were not re-checked against the live docs while writing this guide.

- **Lifetime.** On a subscription, within your plan's usage, the main conversation's cache lasts 1 hour. Subagents and workflows get 5 minutes. On an API key, or once you're past your limit and on usage credits, the main conversation gets 5 minutes.
- **Model switches.** Switching models mid-session recomputes the cache. With `opusplan`, every move into or out of plan mode counts as a switch.
- **CLAUDE.md edits.** Editing CLAUDE.md mid-session doesn't break the cache, but the edit doesn't apply until `/clear`, `/compact`, or a restart.
- **Redoing work.** `/rewind` can pick up the cache you already had. `/compact` builds a new one.
- **Practical tip.** If the cache is about to expire and you still have something to ask, ask it now. The next message after expiry re-caches the whole conversation.

---

## 7. Reference: which settings file wins

From the official settings documentation. Highest precedence first:

1. **Managed settings.** Set by your organisation, through `managed-settings.json`, MDM, or the claude.ai console.
2. **Command line.** `claude --settings <file-or-json>`, for that session only.
3. **Project local.** `.claude/settings.local.json`. You, in this project only.
4. **Shared project.** `.claude/settings.json`. Everyone in the project.
5. **User.** `~/.claude/settings.json`. You, in every project.

- A key set at a higher level replaces the value from a lower level.
- Arrays merge across levels. `statusLine` is an object, not an array, so a project's `statusLine` **replaces this whole block**. The project does not inherit `refreshInterval` or the script.
- On the original computer, I checked for managed settings and for project-level `statusLine` keys under the home directory and the Skynet project folder. I found none. Other folders weren't checked.

---

## 8. Original note

The original tip and prompt, saved verbatim:

Highly recommend adding a 𝗰𝗮𝗰𝗵𝗲 𝗰𝗼𝘂𝗻𝘁𝗱𝗼𝘄𝗻 to your Claude Code status line.

Simply put, every time you send a message, Claude Code sends the whole conversation to the model again. The cache lets it skip reprocessing everything that came before, so replies come back faster and count less against your usage limits. But the cache expires, and the first message after that makes it process 𝘁𝗵𝗲 𝘄𝗵𝗼𝗹𝗲 𝗰𝗼𝗻𝘃𝗲𝗿𝘀𝗮𝘁𝗶𝗼𝗻 𝗳𝗿𝗼𝗺 𝘀𝗰𝗿𝗮𝘁𝗰𝗵. Normally you can't see how much time it has left. With this, your status line always shows the minutes left, and once the cache expires, it tells you how many tokens your next message will re-cache. If it's about to run out and you still have something to ask, ask it now.

The official docs have a few more things I didn't know:
→ On a subscription, within your plan's usage, the main conversation's cache lasts 1 hour, while subagents and workflows get 5 minutes. On an API key, or once you're past your limit and on usage credits, the main conversation gets 5 minutes too
→ Switching models mid-session recomputes everything, and with opusplan, every move into or out of plan mode counts as a switch
→ Editing CLAUDE.md mid-session doesn't break the cache, but the edit doesn't apply either until /clear, /compact or a restart
→ Went down the wrong path and want a redo? /rewind back and it can pick up the cache you already had; /compact builds a new one

Send this prompt and the link below to Opus 5.5 👇

"Read this doc, plus the status line field reference it links to, and add a cache segment to my Claude Code status line.
1. If I already have a status line, don't replace it. Save stdin first so the original command and the cache segment read the same input, leave the original output as is, and put the cache segment on its own line after it. If I don't have one, create one.
2. Get the data from prompt_cache in the input: warm, ttl, expires_at, hit_ratio, misses, last_miss_cause, recache_tokens_if_cold. Show nothing until prompt_cache appears, and skip any field my version doesn't have.
3. While the cache is warm, show it in green with a progress bar and the time left, like "cache ● 1h ████░░ 38m left · hit 91% · misses 0". Turn it yellow when less than 20% of the time is left.
4. When it's cold, show it in red as "cache ○ cold · next message re-caches 82k tokens", with the token count rounded to k. Add the miss cause only when there is one.
5. In the settings file where my statusLine already lives, add "refreshInterval": 30 inside the statusLine object, next to command, so the countdown keeps moving.
If my Claude Code is older than 2.1.251, tell me. Don't upgrade it yourself. When you're done, run sample JSON for warm, about to expire, and cold, and show me the output."