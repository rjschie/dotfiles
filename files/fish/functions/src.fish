function src -d "Reload Fish configs"
  for file in $__fish_config_dir/**.fish
    source $file
  end
end