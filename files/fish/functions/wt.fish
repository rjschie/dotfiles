function wt -d "Worktree management"
  argparse h/help u/untracked -- $argv
  or return

  if test ! (__wt_check_git)
    echo "You must be in a git repo to use worktrees"
    return 1
  end

  set -f cmd $argv[1]

  echo $_flag_untracked

  function __wt_usage
    echo "Usage: wt [-u] <cmd>"
    echo ""
    echo "Arguments:"
    echo "  clone     Clone a repo and set up for worktrees"
    echo "  add       Add a new worktree"
    echo "  remove    Remove a worktree"
    echo "  list      List worktrees"
    echo ""
    echo "Flags:"
    echo "  -u        Run command affecting untracked files"
    echo "            Only used with add, remove, list commands"
  end

  function __wt_check_git
    git -C $PWD rev-parse 2>/dev/null && echo $status
  end

  function __wt_add
    if set -ql _flag_untracked
      echo "untracked add $argv"
    else
      echo "git worktree add $argv"
    end
  end

  function __wt_list
    echo "list"
  end

  function __wt_remove
    echo "remove"
  end

  ##
  #  Main
  ##

  if set -ql _flag_help
    __wt_usage
    return 0
  end

  if set -ql _flag_untracked
    echo "flag: -u"
    set is_affecting_untracked true
  end

  if test -n "$cmd"
    switch $cmd
      case add
        __wt_add $argv[2..-1]
      case rm remove
        __wt_remove
      case ls lst list
        __wt_list
    end
  end
end
