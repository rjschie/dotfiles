function conf -d "Edit common config files"
  switch $argv[1]
    case k kitty
      $EDITOR $CONFIG/kitty/kitty.conf
    case v vim nvim
      $EDITOR $CONFIG/nvim/
    case sk skhd
      $EDITOR $CONFIG/skhd/skhdrc
    case ssh
      $EDITOR ~/.ssh/config
    case starship
      $EDITOR $CONFIG/starship/config.toml
    case g git
      $EDITOR $CONFIG/git/config
    case tm tmux
      $EDITOR $CONFIG/tmux/tmux.conf
    case '*' f fish
      $EDITOR $CONFIG/fish/
  end
end
