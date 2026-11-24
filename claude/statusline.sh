#!/usr/bin/env bash
# Claude Code status line: model · directory (git branch) · context bar · cost
# Example: Opus · dotfiles (main) · ▓▓░░░░░░░░ 14% 136k/1M · $0.42
# Claude Code pipes session JSON on stdin; see https://code.claude.com/docs/en/statusline
input=$(cat)

j() { jq -r "$1" <<<"$input"; }

# Compact token counts: 136205 -> 136k, 1000000 -> 1M
human() {
  local n=${1:-0}
  if   (( n >= 1000000 )); then awk -v n="$n" 'BEGIN { s = sprintf("%.1f", n/1e6); sub(/\.0$/, "", s); print s "M" }'
  elif (( n >= 1000 ));    then echo "$(( n / 1000 ))k"
  else echo "$n"; fi
}

model=$(j '.model.display_name // "Claude"')
dir=$(j '.workspace.current_dir // .cwd // empty')
size=$(j '.context_window.context_window_size // 0')
# Tokens in the window: input + cache writes + cache reads (what used_percentage is based on).
used=$(j '(.context_window.current_usage // {}) | ((.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0))')
pct=$(j '.context_window.used_percentage // 0 | floor')
cost=$(j '.cost.total_cost_usd // 0')

dim=$'\e[2m'; reset=$'\e[0m'
if   (( pct >= 80 )); then color=$'\e[31m'   # red: close to auto-compact
elif (( pct >= 50 )); then color=$'\e[33m'   # yellow
else color=$'\e[32m'; fi                     # green

width=10
filled=$(( pct * width / 100 )); (( filled > width )) && filled=$width
bar=""
for (( i = 0; i < width; i++ )); do
  if (( i < filled )); then bar+="▓"; else bar+="░"; fi
done

location=""
if [[ -n "$dir" ]]; then
  location=$(basename "$dir")
  branch=$(git -C "$dir" symbolic-ref --short -q HEAD 2>/dev/null)
  [[ -n "$branch" ]] && location+=" ($branch)"
fi

context="${color}${bar} ${pct}%${reset}"
(( size > 0 )) && context+=" ${dim}$(human "$used")/$(human "$size")${reset}"

printf '%s' "$model"
[[ -n "$location" ]] && printf ' · %s' "$location"
printf ' · %s' "$context"
printf ' · %s$%.2f%s\n' "$dim" "$cost" "$reset"
