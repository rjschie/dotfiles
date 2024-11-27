function y -d "Yarn alias"
  if test -e "$PWD/yarn.lock"
    # set -f run_yarn true
    yarn $argv
  else
    echo "No Yarn lockfile present, use yarn command directly"
    # read --nchars 1 -l response --prompt-str="Are you sure? (y/N)"
    #
    # switch $response
    # case y Y
    #   set -f run_yarn true
    # case n N '*'
    #   set -f run_yarn false
    # end
  end

  # if $run_yarn
  #   yarn $argv
  # end
end
