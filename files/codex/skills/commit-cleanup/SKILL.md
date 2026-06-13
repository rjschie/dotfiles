---
allowed-tools: Agent, Bash(git status:*), Bash(git rebase:*)
description: Analyze branch commits and suggest a rebase ordering that groups like-work together
---

## Your task

1. **Abort** if working tree has uncommitted changes (`git status --porcelain` non-empty) — tell the user, stop. Do not stash.
2. Spawn ONE subagent (subagent_type=general-purpose, model=sonnet) to analyze and propose the cleanup plan. Do not run git inspection yourself — let the subagent do it.

Pass this prompt to the subagent:

---

You are analyzing commits on the current branch to suggest a `git rebase -i` cleanup. Why: the user wants like-work grouped together (squash/fixup/reorder) without burning main agent context on commit inspection. Be terse.

Steps:

1. `git log origin/HEAD..HEAD --format='%h %s'` — list commits to consider. If zero, return "nothing to clean up" and stop.
2. Inspect commits as needed: `git show --stat <sha>` for overview, `git show <sha> -- <path>` for specifics. Lazy — only enough to understand intent. Do not dump full diffs.
3. Propose a plan:
   - Group commits that touch the same area / are obvious follow-ups / fixups.
   - Choose `pick` / `squash` / `fixup` / `reword` / reorder per commit.
   - Preserve genuinely separate logical changes — do not collapse them just because files overlap.
4. Return a visual diff of the current vs proposed ordering, top/bottom. Each end-result group gets a colored-circle emoji marker; carry that same marker back onto the corresponding commits in the "current" view so the user can see how things move/merge.

   Use this palette in order, one per group: 🟦 🟩 🟨 🟧 🟪 🟫 🟥 ⬜. If there are more groups than colors, reuse from the start.

   Format exactly:
   ```
   ## Current
   🟦 abc1234 feat: foo
   🟩 def5678 fix: typo in unrelated thing
   🟦 ghi9012 wip on foo
   🟦 jkl3456 more foo

   ## Proposed
   🟦 pick   abc1234 feat: foo
   🟦 fixup  ghi9012 wip on foo
   🟦 fixup  jkl3456 more foo
   🟩 pick   def5678 fix: typo in unrelated thing
   ```

   Then:
   - 1–3 sentences on grouping rationale.
   - Any new commit messages for `reword`/`squash` entries.
   - The base sha for the rebase (i.e. `git merge-base origin/HEAD HEAD`).

Do not run `git rebase`. Suggestion only.

---

3. Print the subagent's output verbatim and **stop**. Wait for the user to approve, edit, or reject.
4. On approval: execute the rebase non-interactively by writing the approved todo to a file and using `GIT_SEQUENCE_EDITOR='cp <todofile>'` with `git rebase -i <base>`. If a conflict occurs, run `git rebase --abort` and tell the user which commit conflicted — do not try to resolve.
