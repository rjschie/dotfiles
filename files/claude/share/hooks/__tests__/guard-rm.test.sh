#!/usr/bin/env bash
# Tests for guard-rm.sh hook. Runs without LLM. Exit 0 = all pass.
# Mirror ALLOWED_DIRS from guard-rm.sh in ALLOWED_DIRS below.

set -u
HOOK="$(cd "$(dirname "$0")/.." && pwd)/guard-rm.sh"
HOME_DIR="$HOME"
PASS=0
FAIL=0
FAILURES=()

# Mirror of ALLOWED_DIRS in guard-rm.sh (post tilde/var expansion).
ALLOWED_DIRS=(
  "/tmp"
  "$HOME_DIR/code"
  "$HOME_DIR/.claude"
  "$HOME_DIR/.local/share/wt"
)

# run_case <expected: allow|deny> <description> <command> [cwd]
run_case() {
  local expected="$1" desc="$2" cmd="$3" test_cwd="${4:-$HOME_DIR}"
  local payload out actual
  payload=$(CMD="$cmd" CWD="$test_cwd" python3 -c '
import json, os
print(json.dumps({"tool_name":"Bash","cwd":os.environ["CWD"],"tool_input":{"command":os.environ["CMD"]}}))
')
  out=$(printf '%s' "$payload" | "$HOOK")
  if [[ -z "$out" ]]; then
    actual="allow"
  elif printf '%s' "$out" | grep -q '"permissionDecision": *"deny"'; then
    actual="deny"
  else
    actual="unknown:$out"
  fi
  if [[ "$actual" == "$expected" ]]; then
    PASS=$((PASS + 1))
    printf '  \033[32mok\033[0m   %s\n' "$desc"
  else
    FAIL=$((FAIL + 1))
    FAILURES+=("$desc | expected=$expected got=$actual | cmd=$cmd")
    printf '  \033[31mFAIL\033[0m %s (expected %s, got %s)\n' "$desc" "$expected" "$actual"
  fi
}

echo "guard-rm.sh tests"
echo "  hook: $HOOK"
echo

# Per-allowed-dir coverage: each entry should permit subpaths and deny the
# bare root. Adding a dir to ALLOWED_DIRS above gives it full coverage.
for dir in "${ALLOWED_DIRS[@]}"; do
  run_case allow "rm in $dir/sub"             "rm $dir/sub/foo.txt"
  run_case allow "rm deep in $dir/"           "rm $dir/a/b/c/d.txt"
  run_case allow "rm -rf in $dir/sub"         "rm -rf $dir/sub/foo"
  run_case allow "sudo rm in $dir/sub"        "sudo rm $dir/sub/foo"
  run_case allow "rmdir in $dir/sub"          "rmdir $dir/sub/foo"
  run_case deny  "rm $dir itself"             "rm $dir"
  run_case deny  "rm -rf $dir itself"         "rm -rf $dir"
  run_case deny  "rm $dir/ (trailing slash)"  "rm $dir/"
  run_case deny  "rmdir $dir itself"          "rmdir $dir"
done

# General allow cases (path forms / wrappers / chaining).
run_case allow "rm ~/code/repo/foo (tilde)"          "rm ~/code/repo/foo"
run_case allow "rm \$HOME/code/repo/foo (var)"       'rm $HOME/code/repo/foo'
run_case allow "rm \${HOME}/code/repo/foo (braced)"  'rm ${HOME}/code/repo/foo'
run_case allow "relative rm with ~/code/repo/ cwd"   "rm foo.txt" "$HOME_DIR/code/repo"
run_case allow "relative rm src/file in ~/code/repo" "rm src/shared/app-config.ts" "$HOME_DIR/code/repo"
run_case allow "non-rm command (ls)"                 "ls /etc"
run_case allow "rm env prefix in ~/code/repo/"       "FOO=bar rm $HOME_DIR/code/repo/x"
run_case allow "chained ok in ~/code/repo/"          "echo hi && rm $HOME_DIR/code/repo/foo"
run_case allow "sudo rmdir in ~/code/repo/"          "sudo rmdir $HOME_DIR/code/repo/foo"

# General deny cases.
run_case deny  "rm /etc"                             "rm /etc/hosts"
run_case deny  "rm in HOME root"                     "rm $HOME_DIR/foo"
run_case deny  "rm ~/foo"                            "rm ~/foo"
run_case deny  "rm ~/Library/foo"                    "rm ~/Library/foo"
run_case deny  "rm ~ (HOME root)"                    "rm ~"
run_case deny  "rm -rf ~"                            "rm -rf ~"
run_case deny  "rm \$HOME literal path"              "rm $HOME_DIR"
run_case deny  "rm \$HOME (var, root)"               'rm $HOME'
run_case deny  "rm \${HOME} (braced)"                'rm ${HOME}'
run_case deny  "rm -rf \$HOME"                       'rm -rf $HOME'
run_case deny  "rm \$HOME/Library/foo"               'rm $HOME/Library/foo'
run_case deny  "rm \$HOME/code (var)"                'rm $HOME/code'
run_case deny  "xargs rm"                            "find . | xargs rm"
run_case deny  "xargs rm with flags"                 "find . -print0 | xargs -0 rm -f"
run_case deny  "chained ; with bad rm"               "echo hi; rm /etc/foo"
run_case deny  "chained && with bad rm"              "cd / && rm /etc/foo"
run_case deny  "rm * with cwd outside ~/code"        "rm *" "/etc"
run_case deny  "rm * with cwd in HOME root"          "rm *" "$HOME_DIR"
run_case deny  "sudo rm outside ~/code"              "sudo rm /etc/foo"
run_case deny  "relative rm escaping ~/code/repo"    "rm ../../etc/foo" "$HOME_DIR/code/repo"
run_case deny  "rmdir /etc"                          "rmdir /etc/foo"
run_case deny  "rmdir ~/Library/foo"                 "rmdir ~/Library/foo"
run_case deny  "xargs rmdir"                         "find . | xargs rmdir"
run_case deny  "chained && with bad rmdir"           "cd / && rmdir /etc/foo"

# Special case: non-Bash tool should be ignored regardless of command.
# We test this directly since it doesn't go through run_case's Bash payload.
NON_BASH_OUT=$(echo '{"tool_name":"Edit","tool_input":{"command":"rm /etc/foo"}}' | "$HOOK")
if [[ -z "$NON_BASH_OUT" ]]; then
  PASS=$((PASS + 1))
  printf '  \033[32mok\033[0m   non-Bash tool ignored (override)\n'
else
  FAIL=$((FAIL + 1))
  FAILURES+=("non-Bash tool should be ignored | got=$NON_BASH_OUT")
  printf '  \033[31mFAIL\033[0m non-Bash tool ignored (override)\n'
fi

echo
if (( FAIL == 0 )); then
  printf '\033[32m%d passed, 0 failed\033[0m\n' "$PASS"
  exit 0
else
  printf '\033[31m%d passed, %d failed\033[0m\n' "$PASS" "$FAIL"
  printf '\nfailures:\n'
  for f in "${FAILURES[@]}"; do printf '  - %s\n' "$f"; done
  exit 1
fi
