#!/usr/bin/env bash
# Tests for guard-rm.sh hook. Runs without LLM. Exit 0 = all pass.

set -u
HOOK="$(cd "$(dirname "$0")/.." && pwd)/guard-rm.sh"
HOME_DIR="$HOME"
PASS=0
FAIL=0
FAILURES=()

# run_case <expected: allow|deny> <description> <command> [cwd]
run_case() {
  local expected="$1" desc="$2" cmd="$3" test_cwd="${4:-$HOME_DIR}"
  local payload out actual
  payload=$(printf '{"tool_name":"Bash","tool_input":{"command":%s}}' \
    "$(printf '%s' "$cmd" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')")
  out=$(PWD="$test_cwd" printf '%s' "$payload" | PWD="$test_cwd" "$HOOK")
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

run_case allow "rm in ~/code/repo/"                  "rm $HOME_DIR/code/repo/foo.txt"
run_case allow "rm deep in ~/code/"                  "rm $HOME_DIR/code/a/b/c/d.txt"
run_case allow "rm in /tmp"                          "rm /tmp/foo"
run_case allow "rm ~/code/repo/foo (tilde)"          "rm ~/code/repo/foo"
run_case allow "rm \$HOME/code/repo/foo (var)"       'rm $HOME/code/repo/foo'
run_case allow "rm \${HOME}/code/repo/foo (braced)"  'rm ${HOME}/code/repo/foo'
run_case allow "sudo rm in ~/code/repo/"             "sudo rm $HOME_DIR/code/repo/foo"
run_case allow "rm -rf in ~/code/repo/"              "rm -rf $HOME_DIR/code/repo/foo"
run_case allow "relative rm with ~/code/repo/ cwd"   "rm foo.txt" "$HOME_DIR/code/repo"
run_case allow "non-rm command (ls)"                 "ls /etc"
run_case allow "rm env prefix in ~/code/repo/"       "FOO=bar rm $HOME_DIR/code/repo/x"
run_case allow "chained ok in ~/code/repo/"          "echo hi && rm $HOME_DIR/code/repo/foo"

run_case deny  "rm /etc"                             "rm /etc/hosts"
run_case deny  "rm in HOME root"                     "rm $HOME_DIR/foo"
run_case deny  "rm ~/foo"                            "rm ~/foo"
run_case deny  "rm ~/Library/foo"                    "rm ~/Library/foo"
run_case deny  "rm ~/code itself"                    "rm $HOME_DIR/code"
run_case deny  "rm -rf ~/code itself"                "rm -rf $HOME_DIR/code"
run_case deny  "rm ~/code/ (trailing slash)"         "rm $HOME_DIR/code/"
run_case deny  "rm ~ (HOME root)"                    "rm ~"
run_case deny  "rm -rf ~"                            "rm -rf ~"
run_case deny  "rm \$HOME literal path"              "rm $HOME_DIR"
run_case deny  "rm \$HOME (var, root)"               'rm $HOME'
run_case deny  "rm \${HOME} (braced)"                'rm ${HOME}'
run_case deny  "rm -rf \$HOME"                       'rm -rf $HOME'
run_case deny  "rm \$HOME/Library/foo"               'rm $HOME/Library/foo'
run_case deny  "rm \$HOME/code (var)"                'rm $HOME/code'
run_case deny  "rm /tmp itself"                      "rm /tmp"
run_case deny  "xargs rm"                            "find . | xargs rm"
run_case deny  "xargs rm with flags"                 "find . -print0 | xargs -0 rm -f"
run_case deny  "chained ; with bad rm"               "echo hi; rm /etc/foo"
run_case deny  "chained && with bad rm"              "cd / && rm /etc/foo"
run_case deny  "rm * with cwd outside ~/code"        "rm *" "/etc"
run_case deny  "rm * with cwd in HOME root"          "rm *" "$HOME_DIR"
run_case deny  "sudo rm outside ~/code"              "sudo rm /etc/foo"
run_case deny  "relative rm escaping ~/code/repo"    "rm ../../etc/foo" "$HOME_DIR/code/repo"

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
