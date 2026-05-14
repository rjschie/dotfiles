function tt --description "Set tab title"
  if status is-interactive
    wezterm cli set-tab-title $argv[1]
  end
end
