complete -c cwt --no-files
complete -kc cwt -a 'ls root (git worktree list --porcelain 2>/dev/null | string match "worktree *" | string replace "worktree " "" | tail -n +2 | string replace -r ".*/" "")'
