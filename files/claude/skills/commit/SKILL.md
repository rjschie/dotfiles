---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Create a git commit
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -3`

## Your task

Create a single git commit. Decide **before** doing anything else:

1. Look at `git status` above.
2. **If ANY file is staged**:
   - DO NOT run `git add`. Not even `git add -u`. Not even for "obviously related" unstaged files.
   - Run ONLY `git commit -m "..."` — commit exactly what is staged, nothing more.
   - The user pre-staged on purpose. Unstaged files are intentionally excluded.
3. **If NOTHING is staged**:
   - Stage the relevant files with `git add <paths>`, then `git commit -m "..."`.

Violating rule 2 silently expands the commit beyond what the user intended and is the #1 failure mode of this skill. If you're about to type `git add` when staged files exist, STOP.

Output only the tool calls — no preamble, no summary.
