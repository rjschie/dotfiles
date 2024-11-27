function watchreset -d "Reset watchman just at current dir"
  switch $argv[1]
  case all
    watchman watch-del-all
  case '*'
    watchman watch-del $PWD
  end
end
