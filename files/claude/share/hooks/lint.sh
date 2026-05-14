#!/bin/bash
# Stop hook: runs project linter on changed files.

GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
[[ -z "$GIT_ROOT" ]] && exit 0

CHANGED=$(git -C "$GIT_ROOT" status --porcelain | awk '$1 != "D" && $1 != "??D" {print $2}')
[[ -z "$CHANGED" ]] && exit 0

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
echo "$SCRIPTS" | grep -qx "lint" || exit 0

FILES=()
while IFS= read -r f; do
  ABS="$GIT_ROOT/$f"
  [[ -f "$ABS" ]] || continue
  [[ "$ABS" == "$PKG_DIR"/* ]] || continue
  FILES+=("${ABS#$PKG_DIR/}")
done <<< "$CHANGED"

[[ ${#FILES[@]} -eq 0 ]] && exit 0

(cd "$PKG_DIR" && $PM run lint -- "${FILES[@]}" 2>/dev/null)

exit 0
