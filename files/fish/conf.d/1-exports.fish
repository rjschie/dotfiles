if status is-interactive

  set -gx GPG_TTY (tty)

  set -gx EDITOR $HOMEBREW_PREFIX/bin/nvim
  set -gx VISUAL $HOMEBREW_PREFIX/bin/nvim

  set -gx CODE $HOME/code
  set -gx CONFIG $HOME/.config
  set -gx DOTFILES $CODE/github.com/rjschie/dotfiles

  set -gx STARSHIP_CONFIG $CONFIG/starship/config.toml

  fish_add_path $HOMEBREW_PREFIX/opt/ruby/bin

  # Android
  set -gx ANDROID_HOME $HOME/Library/Android/sdk
  fish_add_path $ANDROID_HOME/emulator
  fish_add_path $ANDROID_HOME/platform-tools

  # WINE
  fish_add_path /Applications/Wine Stable.app/Contents/Resources/start/bin
  fish_add_path /Applications/Wine Stable.app/Contents/Resources/wine/bin

end

