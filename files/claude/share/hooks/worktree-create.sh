#!/usr/bin/env bash
# WorktreeCreate hook: delegate to fish `wt add` so worktrees base off parent
# HEAD and run the user's standard post-create setup (.wtrc files/commands).
#
# stdin: { "cwd": "...", "name": "...", ... }
# stdout: absolute path to the created worktree (only line)
# stderr: everything else

set -euo pipefail

INPUT=$(cat)
NAME=$(jq -r '.name' <<<"$INPUT")
CWD=$(jq -r '.cwd' <<<"$INPUT")
BRANCH="subagent-$NAME"

fish -c "
  cd '$CWD'; or exit 1
  wt add '$BRANCH' >&2; or exit 1
  pwd
"
