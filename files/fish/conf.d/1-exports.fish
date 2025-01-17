if status is-interactive

  set -gx GPG_TTY (tty)

  set -gx EDITOR $HOMEBREW_PREFIX/bin/nvim
  set -gx VISUAL $HOMEBREW_PREFIX/bin/nvim

  set -gx CODE $HOME/code
  set -gx CONFIG $HOME/.config
  set -gx XDG_CONFIG_HOME $HOME/.config
  set -gx DOTFILES $CODE/github.com/rjschie/dotfiles

  set -gx STARSHIP_CONFIG $CONFIG/starship/config.toml

  fish_add_path $HOMEBREW_PREFIX/opt/ruby/bin

end

