if status is-interactive

  alias d_short="cd ~/.local/share/nvim"
  alias d_long="cd ~/Library/Application\ Support/Google\ Chrome/no-secure-data-dir/AutofillStates/2020.11.2.164946"
  alias d_bare="cd ~/code/github.com/rjschie/keepmark"
  alias d_wt="cd ~/code/github.com/rjschie/keepmark/bookmark-mgmt"
  alias d_wez="cd ~/code/github.com/wezterm/wezterm"
  alias d_wezin="cd ~/code/github.com/wezterm/wezterm/wezterm-ssh/src"

  #: Common
  alias l="eza -l"
  alias la="eza -la"
  alias rmr="rm -rI"
  alias rmrff="rm -rf"
  alias mk="mkdir -p"
  alias g="git"
  alias psa="ps -a"
  alias date="gdate"

  alias _vim="/usr/bin/vim"
  alias _nvim="/opt/homebrew/bin/nvim"
  alias nvim="_EDITOR_OPEN_"
  alias vim="_EDITOR_OPEN_"

  alias _cat="/bin/cat"
  alias cat="bat"
  alias trw="tmux rename-window"
  alias lg="lazygit"

  #: Docker
  alias dk="docker"
  alias dki="docker image"
  alias dkc="docker container"
  alias dkk="docker compose"
  alias dkku="docker compose up"
  alias dkkb="docker compose build"
  alias dkkd="docker compose down"

  #: Dev
  alias y="yarn"
  alias pn="pnpm"
  alias br="bun run"

  alias dotfiles="cd $DOTFILES"
  abbr --add github --set-cursor "cd $CODE/github.com/%"
  abbr --add mygit --set-cursor "cd $CODE/github.com/rjschie/%"

end
