function conf -d "Edit common config files"
  switch $argv[1]
    case wez
      $EDITOR $CONFIG/wezterm/wezterm.lua --cmd "cd $CONFIG/wezterm"
    case n nvim
      $EDITOR $CONFIG/nvim/ --cmd "cd $CONFIG/nvim"
    case hs hammer hammerspoon
      $EDITOR $HOME/.hammerspoon/init.lua --cmd "cd $HOME/.hammerspoon"
    case ssh
      $EDITOR $HOME/.ssh/config --cmd "cd $HOME/.ssh"
    case starship
      $EDITOR $CONFIG/starship/config.toml --cmd "cd $CONFIG/starship"
    case g git
      $EDITOR $CONFIG/git/config --cmd "cd $CONFIG/git"
    case claude
      $EDITOR $HOME/.claude/settings.json --cmd "cd $HOME/.claude"
    case '*' f fish
      $EDITOR $CONFIG/fish/ --cmd "cd $CONFIG/fish"
  end
end
