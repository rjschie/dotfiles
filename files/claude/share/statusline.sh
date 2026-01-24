#!/bin/bash

GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[39m'

input=$(cat)

getter() { echo "$input" | jq -r "$1"; }

duration() {
  local ms=$1
  local s=$((ms/1000%60))
  local m=$((ms/1000/60%60))
  local h=$((ms/1000/60/60%24))
  local d=$((ms/1000/60/60/24))
  if (( ms < 1000 )); then
    printf '%dms' $ms
  elif (( d > 0 )); then
    printf '%dd %02dh %02dm %02ds' $d $h $m $s
  elif (( h > 0 )); then
    printf '%dh %02dm %02ds' $h $m $s
  elif (( m > 0 )); then
    printf '%dm %02ds' $m $s
  else
    printf '%ds' $s
  fi
}

# Usage: progress_bar 23  # outputs [██▒       |░░]
# Which includes the autocompact buffer cap of 22.5%
progress_bar() {
  local total=$((100-23))
  local percent=$1 width=10
  local orig_percent=$percent
  [[ (( $percent -lt $total )) ]] && percent=$percent || percent=$total
  local filled=$((percent * width / $total))
  local partial=$(((percent * width % $total) * 4 / $total))
  local empty=$((width - filled - (partial > 0 ? 1 : 0)))
  local chars=(" " "▒" "▓" "█")

  # color based on usage: 0-40% default, 40-60% yellow, 60%+ red
  local color=""
  if (( orig_percent >= 55 )); then
    color=$RED
  elif (( orig_percent >= 35 )); then
    color=$YELLOW
  fi

  printf '%s%% [' $orig_percent
  if [[ -n "$color" ]]; then
    printf '%b' "$color"
  fi
  (( filled > 0 )) && printf '█%.0s' $(seq 1 $filled)
  (( partial > 0 )) && printf '%s' "${chars[$partial]}"
  if [[ -n "$color" ]]; then
    printf '%b' "$RESET"
  fi
  (( empty > 0 )) && printf ' %.0s' $(seq 1 $empty)
  printf '|░░]'
}

model=$(getter '.model.display_name')
cost=$(printf "%.3f" $(getter '.cost.total_cost_usd'))
total_input=$(getter '.context_window.total_input_tokens' | numfmt --to=si)
total_output=$(getter '.context_window.total_output_tokens' | numfmt --to=si)
time=$(duration $(getter '.cost.total_duration_ms'))
api_time=$(duration $(getter '.cost.total_api_duration_ms'))
ctx_usage_percent=$(getter '.context_window.used_percentage // 0')

# cc-telemetry health check (cached 60s)
CC_TELEM_BIN="$HOME/.local/bin/cc-telemetry"
TELEM=""
if [ -x "$CC_TELEM_BIN" ]; then
  CACHE_FILE="/tmp/cc-telemetry-health.cache"
  CACHE_AGE=999
  [ -f "$CACHE_FILE" ] && CACHE_AGE=$(($(date +%s) - $(stat -f%m "$CACHE_FILE" 2>/dev/null || echo 0)))

  if [ $CACHE_AGE -gt 60 ]; then
    STATUS=$("$CC_TELEM_BIN" heartbeat 2>/dev/null || echo "down")
    echo "$STATUS" > "$CACHE_FILE"
  else
    STATUS=$(cat "$CACHE_FILE" 2>/dev/null || echo "down")
  fi

  case "$STATUS" in
    ok)       TELEM="${GREEN} ✓ ${RESET}" ;;
    degraded) TELEM="${YELLOW} ⚠ ${RESET}" ;;
    *)        TELEM="${RED} ✗ ${RESET}" ;;
  esac
fi

version_changed="$VERSION_CHANGED_FROM"
if [ -n "$VERSION_CHANGED_FROM" ]; then
  version_changed=" -- CH -- "
fi

printf ' %b %b (%s) [%s] [api: %s]  /  $%s  /  ↑ %s ↓ %s  /  %s\n' "$version_changed" "$TELEM" "$model" "$time" "$api_time" "$cost" "$total_input" "$total_output" "$(progress_bar $ctx_usage_percent)"

