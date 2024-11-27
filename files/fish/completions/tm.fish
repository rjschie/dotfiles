# function __myfish_seen_one_subcommand_equal_to
#   set -l cmd (commandline -poc)
#   set -e cmd[1]
#   set -l needle $argv[1]
#
#   # If the count is greater than one, we know there's more than one "subcommand"
#   if test (count $cmd) -gt 1
#     return 1
#   else if test "$cmd[1]" = "$needle"
#     return 0
#   else
#     return 1
#   end
# end
#
# set -l commands n new . l ls at d

complete -c tm --no-files
complete -kc tm -a '(tmux list-sessions -F "#{session_name}") ls attach detach'
# complete -kc tm -n '__myfish_seen_one_subcommand_equal_to .' -a '(tmux list-sessions -F "#{session_name}")'
