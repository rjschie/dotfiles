if status is-interactive

  set -gx CODE $HOME/code
  set -gx CONFIG $HOME/.config
  set -gx XDG_CONFIG_HOME $HOME/.config
  set -gx XDG_DATA_HOME $HOME/.local/share
  set -gx XDG_STATE_HOME $HOME/.local/state
  set -gx DOTFILES $CODE/github.com/rjschie/dotfiles
  fish_add_path $HOME/.local/bin
  fish_add_path $HOME/.bun/bin

  ## Homebrew setup & env vars
  if command -q /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
  else if command -q /usr/local/bin/brew
    eval (/usr/local/bin/brew shellenv)
  end

  set -gx HOMEBREW_NO_AUTO_UPDATE 1
  set -gx HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK 1
  set -gx EDITOR $HOMEBREW_PREFIX/bin/nvim
  set -gx VISUAL $HOMEBREW_PREFIX/bin/nvim
  fish_add_path $HOMEBREW_PREFIX/opt/ruby/bin

  # Prompts
  set -gx STARSHIP_CONFIG $CONFIG/starship/config.toml
  starship init fish | source

  set -gx RIPGREP_CONFIG_PATH $CONFIG/.ripgreprc
end

