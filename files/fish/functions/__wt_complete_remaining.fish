function __wt_complete_remaining
  set -l used (commandline -opc)[3..]
  for n in (__wt_complete_names)
    if not contains $n $used
      echo $n
    end
  end
end
