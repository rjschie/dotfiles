#!/bin/bash
# PostToolUse hook: runs project formatter + linter on edited files.
# Skips if no package.json found. Detects package manager automatically.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ -z "$FILE_PATH" ]] || [[ ! -f "$FILE_PATH" ]]; then
  exit 0
fi

# Walk up from the file to find nearest package.json
DIR=$(dirname "$FILE_PATH")
PKG_DIR=""
while [[ "$DIR" != "/" ]]; do
  if [[ -f "$DIR/package.json" ]]; then
    PKG_DIR="$DIR"
    break
  fi
  DIR=$(dirname "$DIR")
done

if [[ -z "$PKG_DIR" ]]; then
  exit 0
fi

# Detect package manager
if [[ -f "$PKG_DIR/bun.lock" ]]; then
  PM="bun"
elif [[ -f "$PKG_DIR/pnpm-lock.yaml" ]]; then
  PM="pnpm"
else
  PM="npm"
fi

SCRIPTS=$(jq -r '.scripts // {} | keys[]' "$PKG_DIR/package.json" 2>/dev/null)

# Format: first match wins
FMT_SCRIPT=""
for s in fmt format format:write; do
  if echo "$SCRIPTS" | grep -qx "$s"; then
    FMT_SCRIPT="$s"
    break
  fi
done

if [[ -n "$FMT_SCRIPT" ]]; then
  $PM run "$FMT_SCRIPT" -- "$FILE_PATH" 2>/dev/null
fi

# Lint
if echo "$SCRIPTS" | grep -qx "lint"; then
  $PM run lint -- "$FILE_PATH" 2>/dev/null
fi

exit 0
