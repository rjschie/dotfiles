function conf -d "Edit common config files"
  switch $argv[1]
    case k kitty
      $EDITOR $CONFIG/kitty/kitty.conf
    case n nvim
      $EDITOR $CONFIG/nvim/
    case sk skhd
      $EDITOR $CONFIG/skhd/skhdrc
    case g git
      $EDITOR $CONFIG/git/config
    case '*' f fish
      $EDITOR $CONFIG/fish/
  end
end
