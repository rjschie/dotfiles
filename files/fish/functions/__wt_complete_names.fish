function __wt_complete_names
  set -l root (git worktree list --porcelain 2>/dev/null | string match "worktree *" | head -1 | string replace "worktree " "")
  test -z "$root"; and return
  set -l wt_dir (__wt_dir $root)
  for d in $wt_dir/*/
    basename $d
  end
end
