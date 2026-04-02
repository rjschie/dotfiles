function wt -d "Worktree management"
  argparse h/help k/keep -- $argv
  or return

  set -l root (git worktree list --porcelain 2>/dev/null | string match "worktree *" | head -1 | string replace "worktree " "")
  if test -z "$root"
    echo "wt: not in a git repo"
    return 1
  end

  set -l cmd $argv[1]

  if set -ql _flag_help; or test -z "$cmd"
    echo "Usage: wt <cmd>"
    echo ""
    echo "  ls                 List worktrees"
    echo "  config             Edit post-create config (files to copy, commands to run)"
    echo "  add <name>         Create worktree & branch"
    echo "  co <name>          Switch to worktree (no arg or '-' = root/prev)"
    echo "  rm <name> [-k]     Remove worktree & branch (-k keeps branch)"
    echo "  merge <name> [-k]  Squash-merge into main, removes worktree & branch (-k keeps branch)"
    echo "  migrate <path>     Reorganize worktrees into .worktrees/ structure"
    return 0
  end

  switch $cmd
    case add
      set -l branch $argv[2]
      if test -z "$branch"
        echo "wt: branch name required"
        return 1
      end

      # Resolve current worktree name before switching
      set -l current
      if test "$PWD" = "$root"
        set current root
      else if string match -q "$root/.worktrees/*" "$PWD"
        set current (basename $PWD)
      end

      mkdir -p $root/.worktrees

      if git show-ref --verify --quiet refs/heads/$branch; or git show-ref --verify --quiet refs/remotes/origin/$branch
        git worktree add $root/.worktrees/$branch $branch
      else
        git worktree add -b $branch $root/.worktrees/$branch
      end
      or return 1

      cd $root/.worktrees/$branch
      __wt_set_title $root $branch
      set -g __wt_previous $current
      __wt_post_create $root $root/.worktrees/$branch

    case co
      set -l name $argv[2]

      # wt co - : toggle to previous worktree
      if test "$name" = -
        if test -z "$__wt_previous"
          echo "wt: no previous worktree"
          return 1
        end
        set name $__wt_previous
      end

      # Resolve current worktree name before switching
      set -l current
      if test "$PWD" = "$root"
        set current root
      else if string match -q "$root/.worktrees/*" "$PWD"
        set current (basename $PWD)
      end

      if test -z "$name"; or test "$name" = root
        cd $root
        tt (basename $root)
        set -g __wt_previous $current
        return 0
      end

      set -l dir $root/.worktrees/$name
      if not test -d $dir
        echo "wt: worktree '$name' not found (try: wt ls)"
        return 1
      end

      cd $dir
      __wt_set_title $root $name
      set -g __wt_previous $current

    case rm remove
      set -l name $argv[2]
      if test -z "$name"
        echo "wt: worktree name required"
        return 1
      end
      if test "$name" = root
        echo "wt: cannot remove root worktree"
        return 1
      end

      cd $root
      git worktree remove $root/.worktrees/$name
      or return 1
      tt (basename $root)

      if not set -ql _flag_k
        git branch -D $name
      end

    case merge
      set -l name $argv[2]
      if test -z "$name"
        echo "wt: worktree name required"
        return 1
      end
      if test "$name" = root
        echo "wt: cannot merge root into itself"
        return 1
      end

      if not test -d $root/.worktrees/$name
        echo "wt: worktree '$name' not found"
        return 1
      end

      cd $root

      set -l main_branch (git symbolic-ref --short HEAD)
      git merge --squash --ff-only $name
      or begin
        echo "wt: merge failed (branch may not be fast-forwardable)"
        return 1
      end

      rm -f (git rev-parse --git-dir)/SQUASH_MSG
      set -l tmpfile (mktemp)
      set -l commits (git log --format="%s" $main_branch...$name)

      if test (count $commits) -eq 1
        echo $commits[1] > $tmpfile
        git commit -e -F $tmpfile
      else
        printf "\n\nSummary of commits:\n" > $tmpfile
        git log --format="- %s" $main_branch...$name >> $tmpfile
        git commit -t $tmpfile
      end
      set -l commit_status $status
      rm -f $tmpfile

      if test $commit_status -ne 0
        echo "wt: commit aborted, merge still staged"
        return 1
      end

      # Auto-remove worktree & branch unless --keep
      if not set -ql _flag_k
        git worktree remove $root/.worktrees/$name
        git branch -D $name
      end
      echo "wt: merged and removed '$name'"

    case ls
      echo root
      if test -d $root/.worktrees
        for d in $root/.worktrees/*/
          basename $d
        end
      end

    case config
      set -l config_path $root/.worktrees/.wtrc
      if not test -f $config_path
        mkdir -p $root/.worktrees
        printf "[files]\n# .env*\n# node_modules\n\n[commands]\n# npm install\n" > $config_path
      end
      $EDITOR $config_path

    case migrate
      set -l migrate_target $argv[2]
      if test -z "$migrate_target"
        echo "wt: target path required (e.g., wt migrate .)"
        return 1
      end
      __wt_migrate $migrate_target

    case '*'
      echo "wt: unknown command '$cmd' (try: wt --help)"
      return 1
  end
end

function __wt_post_create -a root wt_path
  set -l config $root/.worktrees/.wtrc
  if not test -f $config
    return 0
  end

  set -l section ""
  for line in (cat $config)
    set line (string trim $line)
    if test -z "$line"; or string match -q "#*" $line
      continue
    end
    if string match -qr '^\[(\w+)\]$' $line
      set section (string match -r '^\[(\w+)\]$' $line)[2]
      continue
    end

    switch $section
      case files
        set -l matches (eval "printf '%s\n' $root/$line" 2>/dev/null)
        set -l found 0
        for src in $matches
          if test -e $src
            set -l rel (string replace "$root/" "" $src)
            set -l dest $wt_path/$rel
            mkdir -p (dirname $dest)
            cp -Rc $src $dest
            and set found 1
          end
        end
        if test $found -eq 0
          echo "wt: skip copy, no match: $line"
        end
      case commands
        fish -c "cd $wt_path && $line"
        or echo "wt: command failed: $line"
    end
  end
end

function __wt_set_title -a root name
  set -l project (basename $root)
  set -l prefix (string join "" (string sub -l 1 (string split - $project)))
  tt "$prefix-$name"
end

function __wt_migrate -a target_arg
  if test -z "$target_arg"
    echo "wt: target path required"
    return 1
  end

  set -l target (realpath $target_arg 2>/dev/null)
  if test -z "$target"; or not test -d "$target"
    echo "wt: target '$target_arg' is not a valid directory"
    return 1
  end

  if test -d $target/.worktrees
    echo "wt: $target/.worktrees already exists, already migrated?"
    return 1
  end

  # Parse porcelain output into blocks per worktree
  set -l porcelain (git worktree list --porcelain 2>/dev/null)
  set -l wt_paths
  set -l is_bare false

  # Detect bare from first block & collect all worktree paths
  set -l in_first true
  for line in $porcelain
    if string match -q "worktree *" $line
      set -a wt_paths (string replace "worktree " "" $line)
    else if test "$in_first" = true; and test "$line" = bare
      set is_bare true
    end
    # After first blank line, no longer in first block
    if test -z "$line"; and test "$in_first" = true
      set in_first false
    end
  end

  # pwd -P resolves symlinks (e.g. /tmp → /private/tmp on macOS)
  # so it matches the absolute paths from git worktree list
  set -l resolved_pwd (pwd -P)
  set -l current_wt ""
  for p in $wt_paths
    if string match -q "$p*" "$resolved_pwd"
      set current_wt $p
      break
    end
  end

  if test -z "$current_wt"
    echo "wt: could not determine current worktree"
    return 1
  end

  # Non-bare: git worktree move can't move the main worktree,
  # so we must be in it for it to become the new root
  if test "$is_bare" = false; and test "$current_wt" != "$wt_paths[1]"
    echo "wt: must run migrate from the main worktree"
    return 1
  end

  # Bare: bare repo's HEAD symbolic ref is the best indicator of default branch
  if test "$is_bare" = true
    set -l bare_path (realpath (git rev-parse --git-common-dir))
    set -l default_branch (git -C $bare_path symbolic-ref HEAD | string replace "refs/heads/" "")
    set -l current_branch (git symbolic-ref --short HEAD)
    if test "$current_branch" != "$default_branch"
      echo "wt: must run migrate from the default branch ($default_branch)"
      return 1
    end
  end

  # Build list of worktrees to move
  set -l to_move
  for p in $wt_paths
    if test "$p" != "$current_wt"
      # Skip bare repo path (it's listed but not a real worktree dir)
      if test "$is_bare" = true; and test "$p" = "$wt_paths[1]"
        continue
      end
      set -a to_move $p
    end
  end

  # Build command list for confirmation
  set -l cmds
  set -a cmds "mkdir -p $target/.worktrees"

  for p in $to_move
    set -l name (basename $p)
    set -a cmds "git worktree move $p $target/.worktrees/$name"
  end

  if test "$is_bare" = true
    set -l bare_path (realpath (git rev-parse --git-common-dir))
    set -l current_name (basename $current_wt)
    set -l current_branch (cat $bare_path/worktrees/$current_name/HEAD | string replace "ref: " "")
    set -a cmds "rm -rf $bare_path/worktrees/$current_name"
    set -a cmds "rm $current_wt/.git"
    set -a cmds "mv $bare_path $target/.git"
    set -a cmds "git -C $target config core.bare false"
    set -a cmds "git -C $target symbolic-ref HEAD $current_branch"
    set -a cmds "git -C $target reset"
    set -l repair_paths
    for p in $to_move
      set -a repair_paths "$target/.worktrees/"(basename $p)
    end
    set -a cmds "git -C $target worktree repair $repair_paths"
  end

  # If target != current worktree, move contents up
  if test "$target" != "$current_wt"
    set -a cmds "mv $current_wt/* $current_wt/.* $target/"
    set -a cmds "rmdir $current_wt"
    set -a cmds "git -C $target worktree repair"
  end

  # Show confirmation
  echo "wt migrate: will run the following commands:"
  echo ""
  for cmd in $cmds
    echo "  $cmd"
  end
  echo ""
  read -P "Proceed? [y/N] " confirm
  if not string match -qi y $confirm
    echo "wt: cancelled"
    return 1
  end

  # Execute
  if test "$is_bare" = true
    __wt_migrate_bare $target $current_wt $to_move
  else
    __wt_migrate_nonbare $target $current_wt $to_move
  end
end

function __wt_migrate_nonbare -a target current_wt
  set -l to_move $argv[3..]

  mkdir -p $target/.worktrees

  # Move linked worktrees
  for p in $to_move
    set -l name (basename $p)
    echo "moving $name..."
    git worktree move $p $target/.worktrees/$name
    or begin
      echo "wt: failed to move $name"
      return 1
    end
  end

  # If target != current worktree, move contents up
  if test "$target" != "$current_wt"
    mv $current_wt/* $current_wt/.* $target/
    rmdir $current_wt
    cd $target
    git worktree repair
  end

  echo "wt: migration complete"
end

function __wt_migrate_bare -a target current_wt
  set -l to_move $argv[3..]

  set -l bare_path (realpath (git rev-parse --git-common-dir))
  set -l current_name (basename $current_wt)

  mkdir -p $target/.worktrees

  # Move all non-current linked worktrees
  for p in $to_move
    set -l name (basename $p)
    echo "moving $name..."
    git worktree move $p $target/.worktrees/$name
    or begin
      echo "wt: failed to move $name"
      return 1
    end
  end

  # Save branch ref before removing its entry from bare repo
  set -l current_branch (cat $bare_path/worktrees/$current_name/HEAD | string replace "ref: " "")

  # Current worktree becomes the main working tree, so remove
  # its linked worktree entry — it no longer needs one
  rm -rf $bare_path/worktrees/$current_name

  # Replace the gitdir pointer file with the actual git directory
  rm -f $current_wt/.git
  mv $bare_path $target/.git

  # Convert from bare & point HEAD to the branch we were on
  git -C $target config core.bare false
  git -C $target symbolic-ref HEAD $current_branch
  # Bare repos have no index; reset rebuilds it from HEAD
  git -C $target reset

  # Repair from root with worktree paths fixes both directions:
  # root's worktrees/*/gitdir and each worktree's .git file
  set -l repair_paths
  for d in $target/.worktrees/*/
    set -a repair_paths $d
  end
  git -C $target worktree repair $repair_paths

  # If target != current worktree, move contents up
  if test "$target" != "$current_wt"
    mv $current_wt/* $target/
    rmdir $current_wt
  end

  cd $target
  echo "wt: migration complete (converted from bare)"
end
