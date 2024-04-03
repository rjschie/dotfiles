function conf -d "Edit common config files"
  switch $argv[1]
    case k kitty
      $EDITOR $CONFIG/kitty/kitty.conf
    case f fish
      $EDITOR $CONFIG/fish/config.fish
    case nvim
      $EDITOR $CONFIG/nvim/
    case sk skhd
      $EDITOR $CONFIG/skhd/skhdrc
  end
end