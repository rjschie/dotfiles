function __wt_complete_co
  set -l root (git worktree list --porcelain 2>/dev/null | string match "worktree *" | head -1 | string replace "worktree " "")
  test -z "$root"; and return
  set -l wt_dir (__wt_dir $root)
  set -l wt_dir_resolved (path resolve $wt_dir)
  set -l root_resolved (path resolve $root)
  set -l pwd_resolved (path resolve $PWD)

  set -l current
  if test "$pwd_resolved" = "$root_resolved"
    set current root
  else if string match -q "$wt_dir_resolved/*" "$pwd_resolved"
    set current (string replace "$wt_dir_resolved/" "" $pwd_resolved)
  end

  test "$current" != root; and echo root
  for line in (git worktree list --porcelain 2>/dev/null | string match "worktree *")
    set -l p (string replace "worktree " "" $line)
    test "$p" = "$root_resolved"; and continue
    string match -q "$wt_dir_resolved/*" $p; or continue
    set -l name (string replace "$wt_dir_resolved/" "" $p)
    test "$name" != "$current"; and echo $name
  end
end
