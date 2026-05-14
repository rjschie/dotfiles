---
argument-hint: <prd-url>
---

# Coordinate Implementation

**PRD:** `$1` (GitHub issue URL passed as the skill argument, e.g. `https://github.com/rjschie/keepmark/issues/22`)

If `$1` is empty, ask the user for the PRD URL before continuing. Parse `<owner>/<repo>` and the issue number from the URL — you'll need both for every `gh` call.

You are the coordinator for the work in that PRD. You will:
1. Read the PRD + child issues, spot-check against code.
2. Sequence the work into **milestones** (one issue = one milestone).
3. Present the plan + per-issue subagent prompts to the user for approval.
4. Execute milestone-by-milestone: spawn subagents in worktrees, merge their commits back to the user's current branch, pause for validation.

Do NOT implement issue work yourself — delegate every issue to a subagent. Your job is planning, sequencing, spawning, merging, and conflict resolution.

## Phase 1 — Discovery

1. `gh issue view <num> -R <owner/repo> --comments` on the PRD. Extract goal, scope, child issue list, constraints (test commands, ADRs, mock boundaries).
2. For every child issue (and sub-issues): `gh issue view`. Capture title, acceptance criteria, `Blocked by`, out-of-scope notes.
3. Spot-check 2–3 acceptance criteria against current code. Note drift in **Caveats**.
4. Record the user's current branch (`git branch --show-current`) — this is the merge target.

## Phase 2 — Sequencing

1. **DAG**: nodes = issues, edges = `Blocked by`. Topological levels = milestones. Milestone N = issues whose blockers are all in milestones < N.
2. **Parallel vs sequential inside a milestone**: parallel by default. Mark sequential only if two issues co-edit the same file/module in conflicting ways (inspect paths from acceptance criteria). Explain why.
3. **One issue = one milestone breakpoint.** Even if two issues run in parallel within milestone N, the user validates after the whole milestone merges. Each issue may produce one or more commits.
4. **Per-issue subagent prompt** (≤25 lines, self-contained, ready to paste):
   - 1-sentence goal
   - `gh issue view <num> -R <repo>` for full body
   - Working dir: the worktree path you'll create (filled in at spawn time)
   - Key constraints from PRD not repeated in issue (mock boundary, env directive, file conventions, ADR refs)
   - Pointers to prior-art file paths
   - Explicit "do not touch" list if siblings co-edit nearby
   - Definition of done: lint + test commands pass; commit(s) using conventional commits; do **not** open a PR, do **not** push — leave commits on the worktree branch for the coordinator to merge

## Phase 3 — Present plan, await approval

Output the plan in the format below and **stop**. Wait for the user to say go (or to edit prompts).

```
# Kickoff: <PRD title>

Merge target: <user's current branch>

## Milestones

### Milestone 1 (parallel: #a, #b | sequential: #c after #a)
- #<n> <title>
- #<n> <title>

### Milestone 2 (blocked by milestone 1)
- ...

## Caveats
- <PRD-vs-code drift, missing blockers, gaps>

## Subagent prompts

### #<n> <title>
\`\`\`
<self-contained prompt>
\`\`\`

### #<n> <title>
\`\`\`
<self-contained prompt>
\`\`\`
```

## Phase 4 — Execute (one milestone at a time)

For each milestone in order:

1. **Spawn**. For each issue in the milestone:
   - Use the Agent tool with `isolation: "worktree"` so the subagent gets its own worktree off the user's current branch.
   - Paste the prompt from Phase 2, with the assigned worktree path injected.
   - Parallel issues = one message with multiple Agent calls. Sequential pairs = wait for the first before spawning the second.
2. **Wait** for all subagents in the milestone to finish.
3. **Merge** each worktree's branch back to the user's current branch in DAG order:
   - `git merge --no-ff <worktree-branch>` from the user's branch.
   - On conflict: resolve yourself if mechanical (imports, formatting, adjacent edits). If semantic, surface the conflict to the user with both sides and a proposed resolution before committing.
4. **Pause**. Tell the user: which issue(s) merged, the commit SHAs, what to validate/test. Wait for explicit "next" before starting milestone N+1.
5. Clean up merged worktrees once the user confirms.

## Rules

- `gh` for all GitHub reads. No web fetch.
- Missing-but-obvious blocker → flag in Caveats, don't silently add the edge.
- PRD lists more issues than tracker has → flag in Caveats.
- Subagents commit but do not push or open PRs.
- Never proceed past a milestone without user confirmation.
- Each subagent prompt ≤25 lines. Specific > verbose.
