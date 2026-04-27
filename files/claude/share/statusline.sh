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

model=$(getter '.model.display_name')

input_ts=$(getter '.context_window.current_usage.input_tokens')
cache_create=$(getter '.context_window.current_usage.cache_creation_input_tokens')
cache_read=$(getter '.context_window.current_usage.cache_read_input_tokens')
total_tokens=$((input_ts + cache_create + cache_read))
tokens=$(echo $total_tokens | numfmt --to=si --format=%0.1f)
if (( total_tokens < 100000 )); then
  TOKEN_COLOR=$GREEN
elif (( total_tokens < 150000 )); then
  TOKEN_COLOR=$YELLOW
else
  TOKEN_COLOR=$RED
fi

time=$(duration $(getter '.cost.total_duration_ms'))
usage_percent=$(getter '.context_window.used_percentage // 0')

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
    ok)       TELEM="${GREEN}✓${RESET}" ;;
    degraded) TELEM="${YELLOW}⚠${RESET}" ;;
    *)        TELEM="${RED}✗${RESET}" ;;
  esac
fi

printf "%b (%s) [%s] / ${TOKEN_COLOR}%s${RESET} (%s)" \
  "$TELEM" "$model" "$time" "$tokens" "$usage_percent%"

