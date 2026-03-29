## Features
# - wt init: turns a git repo into a worktree ready repo
#   - create new `main` dir and move everything except ./.git into it
#   - rename .git to .bare
#   - git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
# - wt add branch-name
#   - Check if setup for worktrees
#   - cd to git_root
#   - determine if branch-name already exists (cd if so)
#   - also see if branch-name exists remotely
#   - git worktree add ../{branch-name}
#     - or git worktree add -b {branch-name} ../{dirname} {remote}/{branch-name}
#   - Get worktree.syncdirs (default: node_modules, .env*)
#   - cp -Rc those files/dirs
#   - cd into directory
# - wt co branch-name
#   - Check if setup for worktrees
#   - cd to git_root
#   - determine if branch-name already exists
#   - cd to it if so, otherwise exit with error
# - wt rm branch-name
# - wt ls

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
