if status is-interactive

  #: Common
  alias l="eza -l"
  alias la="eza -la"
  alias rmrf="rm -rf"
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

  alias _cat="/bin/cat"
  alias cat="ccat"
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
  # alias y="yarn"
  alias pn="pnpm"
  alias mygit="cd $CODE/github.com/rjschie"

  abbr --add sub --set-cursor "cd $CODE/subsplash.io/%"

end
