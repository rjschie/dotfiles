#!/bin/bash
# PostToolUse (Edit|Write) hook: runs project formatter on the edited file.

PAYLOAD=$(cat)
FILE=$(echo "$PAYLOAD" | jq -r '.tool_input.file_path // empty')
[[ -z "$FILE" || ! -f "$FILE" ]] && exit 0

DIR=$(dirname "$FILE")
PKG_DIR=""
while [[ "$DIR" != "/" ]]; do
  if [[ -f "$DIR/package.json" ]]; then
    PKG_DIR="$DIR"
    break
  fi
  DIR=$(dirname "$DIR")
done

[[ -z "$PKG_DIR" ]] && exit 0

if [[ -f "$PKG_DIR/bun.lock" ]]; then
  PM="bun"
elif [[ -f "$PKG_DIR/pnpm-lock.yaml" ]]; then
  PM="pnpm"
else
  PM="npm"
fi

SCRIPTS=$(jq -r '.scripts // {} | keys[]' "$PKG_DIR/package.json" 2>/dev/null)

FMT_SCRIPT=""
for s in fmt format format:write; do
  if echo "$SCRIPTS" | grep -qx "$s"; then
    FMT_SCRIPT="$s"
    break
  fi
done

[[ -z "$FMT_SCRIPT" ]] && exit 0

REL="${FILE#$PKG_DIR/}"
(cd "$PKG_DIR" && $PM run "$FMT_SCRIPT" -- "$REL" 2>/dev/null)

exit 0
