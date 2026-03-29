function p --description "My Project manager"
  argparse 'u/user=' -- $argv
  or return

  set -f user (string length -q -- "$_flag_user" && echo "$_flag_user" || echo "rjschie")

  if test (count $argv) -eq 0
    cd $CODE/github.com/$user
  else
    cd $CODE/github.com/$user/$argv[1]
    tt $argv[1]
  end
end
