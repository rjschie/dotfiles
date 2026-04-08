if status is-interactive

  #: Common
  alias l="eza -l"
  alias la="eza -la"
  alias rmr="rm -rI"
  alias rmrff="rm -rf"
  alias mk="mkdir -p"
  alias g="git"
  alias date="gdate"

  alias _vim="/usr/bin/vim"
  alias vim="nvim"

  alias _cat="/bin/cat"
  alias cat="bat"
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
  alias pn="pnpm"
  alias br="bun run"

  abbr --add github --set-cursor "cd $CODE/github.com/%"
  abbr --add mygit --set-cursor "cd $CODE/github.com/rjschie/%"

end
