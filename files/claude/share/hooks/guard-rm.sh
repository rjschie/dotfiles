#!/usr/bin/env python3
"""PreToolUse hook: only allow `rm`/`rmdir` inside ALLOWED_DIRS below.
Blanket-denies `xargs rm` / `xargs rmdir`.

Entries support ~ and $VAR expansion. A path is allowed if it resolves
strictly under one of the dirs (the dir itself is denied). Mirror any
edits to ALLOWED_DIRS in __tests__/guard-rm.test.sh."""

import json
import os
import re
import shlex
import sys

# Mirror ALLOWED_DIRS in __tests__/guard-rm.sh
ALLOWED_DIRS = [
    "/tmp",
    "~/code",
    "~/.claude",
    "~/.local/share/wt"
]

data = json.load(sys.stdin)
if data.get("tool_name") != "Bash":
    sys.exit(0)

cmd = data.get("tool_input", {}).get("command", "")
cwd = data.get("cwd") or os.environ.get("PWD") or os.getcwd()
home = os.path.expanduser("~")


def expand(p):
    p = os.path.expandvars(p)
    if p == "~" or p.startswith("~/"):
        p = home + p[1:]
    return p


allowed_roots = [os.path.normpath(expand(d)) for d in ALLOWED_DIRS]
allowed_pretty = ", ".join(d + "/<subdir>/" for d in ALLOWED_DIRS)


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
    p = expand(p)
    if not os.path.isabs(p):
        p = os.path.join(cwd, p)
    p = os.path.normpath(p)
    if any(ch in p for ch in "*?["):
        p = os.path.dirname(p) or "/"
    for root in allowed_roots:
        if p.startswith(root + "/"):
            return True
    return False


def is_rm(tok):
    return tok in ("rm", "rmdir") or tok.endswith("/rm") or tok.endswith("/rmdir")


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
                    deny(f"`xargs {t2}` is blocked. Find another approach that uses rm or rmdir directly (e.g. loop and {t2} each path).")

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
                deny(f"{tokens[idx]} denied: '{arg}' resolves outside user-allowed paths.")

sys.exit(0)
