---
allowed-tools: Agent
description: Push current branch and open a PR with title + body
---

## Your task

Spawn ONE subagent (subagent_type=general-purpose, model=sonnet) to do the entire job. Do not run any git/gh commands yourself. After it returns, print only what it reports.

If the user passed extra text after `/pr` (arguments), include it verbatim in the subagent prompt under a `## User context` section. It may contain framing/why for the PR, or a specific title to use — treat it as authoritative (e.g. honor a user-supplied title verbatim).

Pass this prompt to the subagent:

---

You are pushing the current branch and opening a GitHub PR. Why: the user wants this offloaded so it doesn't bloat the main agent's context. Be terse.

Steps:

1. Run `git status --porcelain` and `git branch --show-current`. **Abort** (return an error message, no PR) if:
   - branch equals the repo default branch (`gh repo view --json defaultBranchRef -q .defaultBranchRef.name`), or
   - working tree has uncommitted changes.
2. `git push -u origin <branch>` — idempotent, just run it.
3. `gh pr view --json url -q .url` — if a PR already exists, print the URL and stop.
4. Gather context to draft the PR:
   - `git log origin/HEAD..HEAD --format='%h %s%n%b'`
   - `git diff --stat origin/HEAD...HEAD`
   - If commit messages explain the change well, stop there. Otherwise pull specific file diffs with `git diff origin/HEAD...HEAD -- <path>` for the files needed to understand intent. Never dump the full diff.
5. Draft:
   - **Title**: conventional-commit style, <70 chars.
   - **Body**:
     - `## Problem` — 1–3 sentences on what this PR solves.
     - `## Solution` — terse bullets on what changed and why.
     - `## Notes for reviewer` — only if real callouts exist (tricky bits, follow-ups, migration order, manual testing). Omit the section entirely otherwise.
   - No filler, no emojis, no "Generated with Claude" footer.
6. **Do not create the PR yet.** Return the drafted title and body for the user to validate. Format:
   ```
   TITLE: <title>

   BODY:
   <body>
   ```
   (Or the abort reason / existing PR URL.)
