function conf -d "Edit common config files"
  switch $argv[1]
    case wez
      $EDITOR $CONFIG/wezterm/wezterm.lua --cmd "cd $CONFIG/wezterm"
    case ghost
      $EDITOR $CONFIG/ghostty/config --cmd "cd $CONFIG/ghostty"
    case k kitty
      $EDITOR $CONFIG/kitty/kitty.conf --cmd "cd $CONFIG/kitty"
    case v n vim nvim
      $EDITOR $CONFIG/nvim/ --cmd "cd $CONFIG/nvim"
    case h hs hammer hammerspoon
      $EDITOR $HOME/.hammerspoon/init.lua --cmd "cd $HOME/.hammerspoon"
    case ssh
      $EDITOR $HOME/.ssh/config --cmd "cd $HOME/.ssh"
    case starship
      $EDITOR $CONFIG/starship/config.toml --cmd "cd $CONFIG/starship"
    case g git
      $EDITOR $CONFIG/git/config --cmd "cd $CONFIG/git"
    case tm tmux
      $EDITOR $CONFIG/tmux/tmux.conf --cmd "cd $CONFIG/tmux"
    case '*' f fish
      $EDITOR $CONFIG/fish/ --cmd "cd $CONFIG/fish"
  end
end
