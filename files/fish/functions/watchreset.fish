function watchreset -d "Reset watchman just at current dir"
  watchman watch-del $PWD
end