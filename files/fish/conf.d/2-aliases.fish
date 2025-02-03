if status is-interactive

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
  alias nv="_EDITOR_OPEN_"
  alias vi="_EDITOR_OPEN_"
  alias v="_EDITOR_OPEN_"
  alias v.="_EDITOR_OPEN_ $(pwd)"

  alias _cat="/bin/cat"
  alias cat="bat"
  alias trw="tmux rename-window"

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

  abbr --add mygit --set-cursor "cd $CODE/github.com/rjschie/%"

end
