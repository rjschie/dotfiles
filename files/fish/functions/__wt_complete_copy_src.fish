function __wt_complete_copy_src
  set -l root (git worktree list --porcelain 2>/dev/null | string match "worktree *" | head -1 | string replace "worktree " "")
  test -z "$root"; and return
  set -l wt_dir (__wt_dir $root)
  set -l token (commandline -ct)

  # Resolve the worktree we're currently in, to exclude it from suggestions
  set -l wt_dir_resolved (path resolve $wt_dir)
  set -l root_resolved (path resolve $root)
  set -l pwd_resolved (path resolve $PWD)
  set -l current
  if test "$pwd_resolved" = "$root_resolved"
    set current root
  else if string match -q "$wt_dir_resolved/*" "$pwd_resolved"
    set current (string replace "$wt_dir_resolved/" "" $pwd_resolved | string split -m1 / )[1]
  end

  if not string match -q "*:*" $token
    # Stage 1: complete worktree prefixes (root: and each migrated worktree), minus current
    test "$current" != root; and echo "root:"
    for n in (__wt_complete_names)
      test "$n" != "$current"; and echo "$n:"
    end
    return
  end

  # Stage 2: complete file paths inside the chosen worktree
  set -l wt_name (string split -m1 ":" $token)[1]
  set -l partial (string split -m1 ":" $token)[2]
  set -l src_dir
  if test "$wt_name" = root
    set src_dir $root
  else
    set src_dir $wt_dir/$wt_name
  end
  test -d $src_dir; or return

  set -l matches
  eval "set matches $src_dir/$partial*" 2>/dev/null
  for p in $matches
    set -l rel (string replace "$src_dir/" "" $p)
    if test -d $p
      echo "$wt_name:$rel/"
    else
      echo "$wt_name:$rel"
    end
  end
end
