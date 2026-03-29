function cwt -d "Navigate git worktrees"
  set -l cmd $argv[1]

  # Get all worktree paths (porcelain for reliable parsing)
  set -l paths (git worktree list --porcelain 2>/dev/null | string match "worktree *" | string replace "worktree " "")
  if test (count $paths) -eq 0
    echo "cwt: not in a git repo"
    return 1
  end

  if test -z "$cmd"
    echo "Usage: cwt <ls|root|name>"
    echo ""
    echo "  ls      list worktree names"
    echo "  root    cd to main worktree"
    echo "  <name>  cd to worktree by directory name"
    return 0
  end

  switch $cmd
    case root
      cd $paths[1]
      tt (basename $paths[1])

    case ls
      echo root
      for p in $paths[2..]
        basename $p
      end

    case '*'
      for p in $paths
        if test (basename $p) = $cmd
          cd $p
          set -l project (basename $paths[1])
          set -l prefix (string join "" (string sub -l 1 (string split - $project)))
          tt "$prefix-$cmd"
          return 0
        end
      end
      echo "cwt: worktree '$cmd' not found (try: cwt ls)"
      return 1
  end
end
