function __wt_complete_co
  set -l root (git worktree list --porcelain 2>/dev/null | string match "worktree *" | head -1 | string replace "worktree " "")
  test -z "$root"; and return
  set -l wt_dir (__wt_dir $root)

  set -l current
  if test "$PWD" = "$root"
    set current root
  else if string match -q "$wt_dir/*" "$PWD"
    set current (basename $PWD)
  end

  test "$current" != root; and echo root
  for d in $wt_dir/*/
    set -l name (basename $d)
    test "$name" != "$current"; and echo $name
  end
end
