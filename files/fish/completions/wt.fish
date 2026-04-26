complete --command wt --exclusive --condition __fish_use_subcommand --arguments add --description "Create worktree"
complete --command wt --exclusive --condition __fish_use_subcommand --arguments co --description "Switch to worktree"
complete --command wt --exclusive --condition __fish_use_subcommand --arguments rm --description "Remove worktree"
complete --command wt --exclusive --condition __fish_use_subcommand --arguments merge --description "Merge worktree into main"
complete --command wt --exclusive --condition __fish_use_subcommand --arguments ls --description "List worktrees"
complete --command wt --exclusive --condition __fish_use_subcommand --arguments config --description "Edit post-create config"
complete --command wt --exclusive --condition __fish_use_subcommand --arguments migrate --description "Move worktrees to ~/.local/share/wt/"
complete --command wt --exclusive --condition "__fish_seen_subcommand_from ls"
complete --command wt --no-files --condition "__fish_seen_subcommand_from config"
complete --command wt --exclusive --condition "__fish_seen_subcommand_from config" --short-option g --long-option global --description "Edit global .wtrc"
complete --command wt --force --condition "__fish_seen_subcommand_from migrate" --arguments "(__fish_complete_directories)"
complete --command wt --condition "__fish_seen_subcommand_from migrate" --short-option n --long-option dry-run --description "Show plan without executing"

complete --command wt --no-files --condition "__fish_seen_subcommand_from co add merge"
complete --command wt --exclusive --condition "__fish_seen_subcommand_from co; and test (count (commandline -opc)) -le 2" --arguments "(__wt_complete_co)"
complete --command wt --exclusive --condition "__fish_seen_subcommand_from merge; and test (count (commandline -opc)) -le 2" --arguments "(__wt_complete_names)"
complete --command wt --exclusive --condition "__fish_seen_subcommand_from rm" --arguments "(__wt_complete_remaining)"

complete --command wt --exclusive --condition "__fish_seen_subcommand_from add; and test (count (commandline -opc)) -le 2" \
  --arguments "(begin; set -l cur (git branch --show-current 2>/dev/null); set -l root_branch (git worktree list --porcelain 2>/dev/null | string match 'branch *' | head -1 | string replace 'branch refs/heads/' ''); git branch -a --format='%(refname:short)' 2>/dev/null | string replace 'origin/' '' | string match -v \$cur | string match -v \$root_branch | sort -u; end)"

complete --command wt --condition "__fish_seen_subcommand_from rm merge" --short-option k --long-option keep --description "Keep branch/worktree"
