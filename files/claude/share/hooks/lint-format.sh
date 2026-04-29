#!/bin/bash
# Stop hook: runs project formatter + linter on the whole project.

DIR=$(pwd)
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

if [[ -n "$FMT_SCRIPT" ]]; then
  (cd "$PKG_DIR" && $PM run "$FMT_SCRIPT" 2>/dev/null)
fi

if echo "$SCRIPTS" | grep -qx "lint"; then
  (cd "$PKG_DIR" && $PM run lint 2>/dev/null)
fi

exit 0
