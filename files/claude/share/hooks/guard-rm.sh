#!/usr/bin/env python3
"""PreToolUse hook: only allow `rm` inside $HOME/code/<subdir>/ or /tmp/.
Blanket-denies `xargs rm`."""

import json
import os
import re
import shlex
import sys

data = json.load(sys.stdin)
if data.get("tool_name") != "Bash":
    sys.exit(0)

cmd = data.get("tool_input", {}).get("command", "")
cwd = os.environ.get("PWD", os.getcwd())
home = os.path.expanduser("~")
code = os.path.join(home, "code")


def deny(reason):
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": reason,
        }
    }))
    sys.exit(0)


def path_allowed(p):
    p = os.path.expandvars(p)
    if p == "~" or p.startswith("~/"):
        p = home + p[1:]
    if not os.path.isabs(p):
        p = os.path.join(cwd, p)
    p = os.path.normpath(p)
    if any(ch in p for ch in "*?["):
        p = os.path.dirname(p) or "/"
    if p.startswith("/tmp/"):
        return True
    if p.startswith(code + "/"):
        return True
    return False


def is_rm(tok):
    return tok == "rm" or tok.endswith("/rm")


# split on shell separators to inspect each sub-command
subcmds = re.split(r";|&&|\|\||\||&", cmd)

for sub in subcmds:
    try:
        tokens = shlex.split(sub, posix=True)
    except ValueError:
        continue
    if not tokens:
        continue

    # blanket deny: xargs ... rm
    for i, t in enumerate(tokens):
        if t == "xargs":
            for t2 in tokens[i + 1:]:
                if is_rm(t2):
                    deny("`xargs rm` is blocked. Find another approach (e.g. loop and rm each path after validating it's under $HOME/code/<subdir>/ or /tmp/).")

    # find the actual command token (skip env assignments and wrappers)
    idx = 0
    while idx < len(tokens) and re.match(r"^[A-Za-z_][A-Za-z0-9_]*=", tokens[idx]):
        idx += 1
    while idx < len(tokens) and tokens[idx] in ("sudo", "time", "nice", "nohup", "env"):
        idx += 1
    if idx >= len(tokens):
        continue

    if is_rm(tokens[idx]):
        for arg in tokens[idx + 1:]:
            if arg.startswith("-"):
                continue
            if not path_allowed(arg):
                deny(f"rm denied: '{arg}' resolves outside allowed paths. Only $HOME/code/<subdir>/ and /tmp/ are allowed.")

sys.exit(0)
