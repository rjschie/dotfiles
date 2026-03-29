if test -d $__fish_config_dir/conf.d/no_git
  for file in $__fish_config_dir/conf.d/no_git/*.fish
    source $file
  end
end
