function wt -d "Worktree management"
  argparse h/help k/keep g/global f/force n/dry-run -- $argv
  or return

  set -l root (git worktree list --porcelain 2>/dev/null | string match "worktree *" | head -1 | string replace "worktree " "")
  if test -z "$root"
    echo "wt: not in a git repo"
    return 1
  end

  set -l wt_dir (__wt_dir $root)

  set -l cmd $argv[1]

  if set -ql _flag_help; or test -z "$cmd"
    echo "Usage: wt <cmd>"
    echo ""
    echo "  ls                         List worktrees"
    echo "  config [-g]                Edit post-create config (-g for global)"
    echo "  add <name>                 Create worktree & branch"
    echo "  co <name>                  Switch to worktree (no arg or '-' = root/prev)"
    echo "  rm <name>... [-k] [-f]     Remove worktree(s) & branch(es) (-k keeps, -f force)"
    echo "  merge <name> [-k]          Squash-merge into main, removes worktree & branch (-k keeps branch)"
    echo "  migrate [<target>] [-n]    Move worktrees to ~/.local/share/wt/ (-n dry-run)"
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
      else if string match -q "$wt_dir/*" "$PWD"
        set current (basename $PWD)
      end

      mkdir -p $wt_dir

      if git show-ref --verify --quiet refs/heads/$branch; or git show-ref --verify --quiet refs/remotes/origin/$branch
        git worktree add $wt_dir/$branch $branch
      else
        git worktree add -b $branch $wt_dir/$branch
      end
      or return 1

      cd $wt_dir/$branch
      __wt_set_title $root $branch
      set -g __wt_previous $current
      __wt_post_create $root $wt_dir/$branch

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
      else if string match -q "$wt_dir/*" "$PWD"
        set current (basename $PWD)
      end

      if test -z "$name"; or test "$name" = root
        cd $root
        tt (basename $root)
        set -g __wt_previous $current
        return 0
      end

      set -l dir $wt_dir/$name
      if not test -d $dir
        echo "wt: worktree '$name' not found (try: wt ls)"
        return 1
      end

      cd $dir
      __wt_set_title $root $name
      set -g __wt_previous $current

    case rm remove
      set -l names $argv[2..]
      if test (count $names) -eq 0
        echo "wt: worktree name required"
        return 1
      end

      set -l force_flag
      if set -ql _flag_f
        set force_flag --force
      end

      cd $root

      for name in $names
        if test "$name" = root
          echo "wt: cannot remove root worktree"
          continue
        end

        git worktree remove $force_flag $wt_dir/$name
        or continue

        if not set -ql _flag_k
          git branch -D $name
        end
      end
      tt (basename $root)

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

      if not test -d $wt_dir/$name
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
        git worktree remove $wt_dir/$name
        git branch -D $name
      end
      echo "wt: merged and removed '$name'"

    case ls
      echo root
      if test -d $wt_dir
        for d in $wt_dir/*/
          basename $d
        end
      end

      # Find worktrees not at $wt_dir (un-migrated)
      # Resolve to canonical paths since git porcelain uses resolved paths
      set -l porcelain (git worktree list --porcelain 2>/dev/null)
      set -l unmigrated
      set -l cur_path
      set -l cur_branch
      set -l cur_bare false
      set -l root_resolved (path resolve $root)
      set -l wt_dir_resolved (path resolve $wt_dir)
      set -l pwd_resolved (path resolve $PWD)
      for line in $porcelain
        if string match -q "worktree *" $line
          set cur_path (string replace "worktree " "" $line)
          set cur_branch ""
          set cur_bare false
        else if test "$line" = bare
          set cur_bare true
        else if string match -q "branch *" $line
          set cur_branch (string replace "branch refs/heads/" "" $line)
        else if test "$line" = detached
          set cur_branch "(detached)"
        else if test -z "$line"; and test -n "$cur_path"
          # End of block — evaluate
          if test "$cur_bare" = false; and test "$cur_path" != "$root_resolved"
            if test "$cur_path" != "$wt_dir_resolved/"(basename $cur_path)
              set -l display $cur_path
              if string match -q "$pwd_resolved/*" $cur_path
                set display (string replace "$pwd_resolved/" "" $cur_path)
              end
              if test -n "$cur_branch"; and test (basename $cur_path) != "$cur_branch"
                set -a unmigrated "$display ($cur_branch)"
              else
                set -a unmigrated $display
              end
            end
          end
          set cur_path
        end
      end

      if test (count $unmigrated) -gt 0
        echo ""
        echo "not migrated:"
        for l in $unmigrated
          echo $l
        end
      end

    case config
      set -l config_path
      if set -ql _flag_g
        set config_path (__wt_global_wtrc_resolve)
      else
        set config_path $root/.wtrc
      end
      if not test -f $config_path
        printf "[files]\n# .env*\n# node_modules\n\n[commands]\n# npm install\n" > $config_path
      end
      $EDITOR $config_path

    case migrate
      set -l dry_run 0
      set -ql _flag_n; and set dry_run 1
      __wt_migrate $dry_run $argv[2]

    case '*'
      echo "wt: unknown command '$cmd' (try: wt --help)"
      return 1
  end
end

function __wt_post_create -a root wt_path
  # Apply global .wtrc first, then repo-local
  set -l global_wtrc (__wt_global_wtrc_path)
  if test -n "$global_wtrc"
    __wt_apply_wtrc $root $wt_path $global_wtrc --quiet
  end

  set -l local_wtrc $root/.wtrc
  if test -f $local_wtrc
    __wt_apply_wtrc $root $wt_path $local_wtrc
  end
end

function __wt_apply_wtrc -a root wt_path config
  set -l quiet false
  contains -- --quiet $argv; and set quiet true
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
        set -l matches (eval "set -l r $root/$line 2>/dev/null; and printf '%s\\n' \$r")
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
        if test $found -eq 0; and test $quiet = false
          echo "wt: skip copy, no match: $line"
        end
      case commands
        fish -c "cd $wt_path && $line"
        or echo "wt: command failed: $line"
    end
  end
end

function __wt_global_wtrc_path
  # Returns path to existing global .wtrc, empty if none found
  for p in $XDG_CONFIG_HOME/.wtrc $CONFIG/.wtrc ~/.config/.wtrc ~/.wtrc
    if test -n "$p"; and test -f $p
      echo $p
      return
    end
  end
end

function __wt_global_wtrc_resolve
  # Returns path where global .wtrc should live (for creation)
  if set -q XDG_CONFIG_HOME; and test -n "$XDG_CONFIG_HOME"
    echo $XDG_CONFIG_HOME/.wtrc
  else if set -q CONFIG; and test -n "$CONFIG"
    echo $CONFIG/.wtrc
  else if test -d ~/.config
    echo ~/.config/.wtrc
  else
    echo ~/.wtrc
  end
end

function __wt_set_title -a root name
  set -l project (basename $root)
  set -l prefix (string join "" (string sub -l 1 (string split - $project)))
  tt "$prefix-$name"
end

function __wt_migrate -a dry_run target_arg
  # Parse porcelain: collect worktree paths, detect bare from first block
  set -l porcelain (git worktree list --porcelain 2>/dev/null)
  set -l wt_paths
  set -l is_bare false
  set -l in_first true
  for line in $porcelain
    if string match -q "worktree *" $line
      set -a wt_paths (string replace "worktree " "" $line)
    else if test "$in_first" = true; and test "$line" = bare
      set is_bare true
    end
    if test -z "$line"; and test "$in_first" = true
      set in_first false
    end
  end

  if test (count $wt_paths) -eq 0
    echo "wt: no worktrees found"
    return 1
  end

  # Determine current main worktree.
  # Non-bare: wt_paths[1] is the main worktree.
  # Bare: wt_paths[1] is the bare git dir; main = the linked wt we're inside, else wt_paths[2].
  set -l current_main_wt
  set -l resolved_pwd (pwd -P)
  if test "$is_bare" = true
    if test (count $wt_paths) -lt 2
      echo "wt: bare repo has no checked-out worktrees"
      return 1
    end
    for p in $wt_paths[2..]
      if string match -q "$p*" "$resolved_pwd"
        set current_main_wt $p
        break
      end
    end
    test -z "$current_main_wt"; and set current_main_wt $wt_paths[2]
  else
    set current_main_wt $wt_paths[1]
    if not string match -q "$current_main_wt*" "$resolved_pwd"
      echo "wt: must run migrate from the main worktree"
      return 1
    end
  end

  # Resolve target_root (post-migration main worktree dir)
  set -l target_root
  if test -n "$target_arg"
    set target_root (path resolve $target_arg)
    if test -z "$target_root"
      echo "wt: invalid target '$target_arg'"
      return 1
    end
  else
    set target_root $current_main_wt
  end

  if not test -d $target_root; and not test -d (dirname $target_root)
    echo "wt: target '$target_root' (or its parent) is not a directory"
    return 1
  end

  set -l new_wt_dir (__wt_dir $target_root)

  # Linked worktrees that need moving (not already at $new_wt_dir/<basename>)
  set -l to_move
  for p in $wt_paths
    if test "$is_bare" = true; and test "$p" = "$wt_paths[1]"
      continue
    end
    if test "$p" = "$current_main_wt"
      continue
    end
    if test "$p" = "$new_wt_dir/"(basename $p)
      continue
    end
    set -a to_move $p
  end

  # Pre-fetch bare info (needed for both preview and exec)
  set -l bare_path
  set -l current_name
  set -l current_branch
  if test "$is_bare" = true
    set bare_path (realpath (git rev-parse --git-common-dir))
    set current_name (basename $current_main_wt)
    set current_branch (cat $bare_path/worktrees/$current_name/HEAD | string replace "ref: " "")
  end

  # Build command preview
  set -l cmds

  if test "$is_bare" = true
    set -a cmds "rm -rf $bare_path/worktrees/$current_name"
    set -a cmds "rm $current_main_wt/.git"
    if test "$target_root" != "$current_main_wt"; and not test -d $target_root
      set -a cmds "mkdir -p $target_root"
    end
    if test "$bare_path" != "$target_root/.git"
      set -a cmds "mv $bare_path $target_root/.git"
    end
    set -a cmds "git -C $target_root config core.bare false"
    set -a cmds "git -C $target_root symbolic-ref HEAD $current_branch"
    set -a cmds "git -C $target_root reset"
  end

  if test "$target_root" != "$current_main_wt"
    if test "$is_bare" = false; and not test -d $target_root
      set -a cmds "mkdir -p $target_root"
    end
    set -a cmds "(move contents of $current_main_wt/ into $target_root/)"
    set -a cmds "rmdir $current_main_wt"
  end

  if test (count $to_move) -gt 0
    set -a cmds "mkdir -p $new_wt_dir"
    for p in $to_move
      set -a cmds "git worktree move $p $new_wt_dir/"(basename $p)
    end
  end

  # Repair after structural changes
  if test (count $to_move) -gt 0; or test "$target_root" != "$current_main_wt"; or test "$is_bare" = true
    set -l repair_paths
    for p in $to_move
      set -a repair_paths "$new_wt_dir/"(basename $p)
    end
    if test (count $repair_paths) -gt 0
      set -a cmds "git -C $target_root worktree repair $repair_paths"
    else
      set -a cmds "git -C $target_root worktree repair"
    end
  end

  # Preserve .wtrc from old .worktrees/ before cleanup
  if test -f $target_root/.worktrees/.wtrc; and not test -e $target_root/.wtrc
    set -a cmds "mv $target_root/.worktrees/.wtrc $target_root/.wtrc"
  end

  # Cleanup empty old .worktrees
  set -a cmds "rmdir $target_root/.worktrees 2>/dev/null"

  if test (count $cmds) -eq 0
    echo "wt: nothing to migrate, already organized"
    return 0
  end

  if test "$dry_run" = 1
    echo "wt migrate (dry-run): would run:"
  else
    echo "wt migrate: will run the following commands:"
  end
  echo ""
  for c in $cmds
    echo "  $c"
  end
  echo ""
  if test "$dry_run" = 1
    return 0
  end
  read -P "Proceed? [y/N] " confirm
  if not string match -qi y $confirm
    echo "wt: cancelled"
    return 1
  end

  # Execute
  if test "$is_bare" = true
    rm -rf $bare_path/worktrees/$current_name
    rm -f $current_main_wt/.git
    if test "$target_root" != "$current_main_wt"; and not test -d $target_root
      mkdir -p $target_root
    end
    if test "$bare_path" != "$target_root/.git"
      mv $bare_path $target_root/.git
      or begin
        echo "wt: failed to move bare git dir"
        return 1
      end
    end
    git -C $target_root config core.bare false
    git -C $target_root symbolic-ref HEAD $current_branch
    git -C $target_root reset
  end

  if test "$target_root" != "$current_main_wt"
    if test "$is_bare" = false; and not test -d $target_root
      mkdir -p $target_root
    end
    # find avoids fish's unmatched-glob errors and BSD/GNU mv differences
    for entry in (find $current_main_wt -mindepth 1 -maxdepth 1 2>/dev/null)
      mv $entry $target_root/
      or begin
        echo "wt: failed to move $entry"
        return 1
      end
    end
    rmdir $current_main_wt
  end

  if test (count $to_move) -gt 0
    mkdir -p $new_wt_dir
    for p in $to_move
      set -l name (basename $p)
      echo "moving $name..."
      git -C $target_root worktree move $p $new_wt_dir/$name
      or begin
        echo "wt: failed to move $name"
        return 1
      end
    end
  end

  set -l repair_paths
  for p in $to_move
    set -a repair_paths "$new_wt_dir/"(basename $p)
  end
  if test (count $repair_paths) -gt 0
    git -C $target_root worktree repair $repair_paths
  else
    git -C $target_root worktree repair
  end

  if test -f $target_root/.worktrees/.wtrc; and not test -e $target_root/.wtrc
    mv $target_root/.worktrees/.wtrc $target_root/.wtrc
  end
  rmdir $target_root/.worktrees 2>/dev/null

  cd $target_root
  echo "wt: migration complete"
end
