function conf -d "Edit common config files"
  switch $argv[1]
    case k kitty
      _EDITOR_OPEN_ $CONFIG/kitty/kitty.conf
    case v n vim nvim
      _EDITOR_OPEN_ $CONFIG/nvim/
    # case sk skhd
    #   _EDITOR_OPEN_ $CONFIG/skhd/skhdrc
    case h hs hammer hammerspoon
      _EDITOR_OPEN_ $HOME/.hammerspoon/init.lua
    case ssh
      _EDITOR_OPEN_ $HOME/.ssh/config
    case starship
      _EDITOR_OPEN_ $CONFIG/starship/config.toml
    case g git
      _EDITOR_OPEN_ $CONFIG/git/config
    case tm tmux
      _EDITOR_OPEN_ $CONFIG/tmux/tmux.conf
    case '*' f fish
      _EDITOR_OPEN_ $CONFIG/fish/
  end
end
