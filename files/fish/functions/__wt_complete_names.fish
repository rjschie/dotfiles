function __wt_complete_names
  set -l root (git worktree list --porcelain 2>/dev/null | string match "worktree *" | head -1 | string replace "worktree " "")
  test -z "$root"; and return
  set -l wt_dir (__wt_dir $root)
  set -l wt_dir_resolved (path resolve $wt_dir)
  set -l root_resolved (path resolve $root)
  for line in (git worktree list --porcelain 2>/dev/null | string match "worktree *")
    set -l p (string replace "worktree " "" $line)
    test "$p" = "$root_resolved"; and continue
    string match -q "$wt_dir_resolved/*" $p; and string replace "$wt_dir_resolved/" "" $p
  end
end
