function p --description "My Project manager"
  set -f command $argv[1]

  set -f SHARE $HOME/.local/share/p

  if ! test $argv[1]
    cd $CODE/github.com/rjschie
  # else if test "$argv[1]" = "--list"
  #   echo "project one" "project two"
  else
    cd $CODE/github.com/rjschie/$argv[1]
  end
end
