# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/ryanschie/.zshrc'

# Load FZF completion
export FZF_COMPLETION_TRIGGER="**"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Loading files
source ~/.zprezto/init.zsh

# Use VIM Mode
bindkey -v
set -o vi
export KEYTIMEOUT=1

# PATHS
export EDITOR=/usr/local/bin/vim
export VISUAL=/usr/local/bin/vim
export PATH=${HOME}/.bin:${PATH}
export PATH=${HOME}/.npm-global/bin:${PATH}
export ANDROID_HOME=${HOME}/Library/Android/sdk
export PATH=${PATH}:${ANDROID_HOME}/emulator
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/tools/bin
export PATH=${PATH}:${ANDROID_HOME}/platform-tools
export PATH="/usr/local/opt/php@5.6/bin:$PATH"
export PATH="/usr/local/opt/php@5.6/sbin:$PATH"

export AWS_SDK_LOAD_CONFIG=1
export HOMEBREW_GITHUB_API_TOKEN=c269e5df57576afbca9b4054e8bcd9446f7a55c9
export GPG_TTY=$(tty)

export CLICOLOR_FORCE=''
export GREP_COLORS='mt=01;31:fn=36'

export FZF_DEFAULT_COMMAND='fd --type f'

export ECR="576546042567.dkr.ecr.us-west-2.amazonaws.com"

export GOPATH="/Users/ryanschie/go"
export GOBIN="/Users/ryanschie/go/bin"

# Loading Completions
compctl -g '~/.itermocil/*(:t:r)' itermocil

# Custom OPTS
unsetopt correct
unsetopt correct_all

####### USEFUL THINGS #######

# Main Aliases
alias src="source ~/.zshrc"
alias orc="vim ~/.zshrc"
alias vimrc="vim ~/.vim/vimrc"
alias l="ls -lFhH"
alias la="ls -lFAHh"
alias -g G="| ggrep"
alias -g LS="| less -r"
alias pwdc="echo -n $(pwd) | pbcopy"

# Helpers
alias rmrf="rm -rf"
alias mk="mkdir -p"
alias grep="nocorrect ggrep --color=auto"
alias grip="nocorrect ggrep --color=auto -riP"
tch () { mkdir -p $(dirname $*); touch $* }
mkd () { mkdir -p $*; cd $* }
trash () { mv $* ~/.Trash/ }
title () { set-tab-title $* }

# Finding
sar () { find $1 -name "*.$2" -type f -exec perl -p -i -e "$3" -- {} + }
sarfd () { fd -t f -x perl -p -i -e "$1" -- {} }
search () { find -L $1 -name "$2" ${*:3} }
alias findlinks="find node_modules -type l -ls -maxdepth 10"

ecrlogin () { 
  aws ecr get-login-password \
    --region us-west-2 \
    | docker login \
    --username AWS \
    --password-stdin "$ECR"
}

# Application Aliases
alias v="vim"
# alias -g F="\$(fzf)"
# alias fv="vim \$(fzf)"
alias g="git"
alias t="tmux"
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

alias gconf="git config --global -e"

# Docker aliases
alias dk="docker"
alias dki="docker image"
alias dkc="docker container"

#Docker compose
alias dkk="docker compose"
alias dkku="docker compose up"
alias dkkb="docker compose build"
alias dkkd="docker compose down"

dkrun () { docker run -it $@ /bin/bash }
dkconn () { docker exec -it $@ /bin/bash }

# Directory Aliases
alias sub="cd /Users/ryanschie/code/Subsplash"
alias phpdash="cd /Users/ryanschie/code/Subsplash/php/dashboard && title php-dash"
alias wallet="cd /Users/ryanschie/code/Subsplash/php/wallet && title wallet"
alias monaco="cd /Users/ryanschie/code/Subsplash/php/monaco && title monaco"
alias webdev="cd /Users/ryanschie/code/Subsplash/webdev-env-setup"

alias subrschie="cd /Users/ryanschie/code/rschie"
alias subem="cd /Users/ryanschie/code/Subsplash/ember"

alias jsinfra="cd /Users/ryanschie/code/Subsplash/javascript/infrastructure && title infrastructure"

alias jsdash="cd /Users/ryanschie/code/Subsplash/javascript/dashboard && title jsdash"
alias jsdash2="cd /Users/ryanschie/code/Subsplash/_secondary/javascript/dashboard && title jsdash 2"
alias kit="cd /Users/ryanschie/code/Subsplash/ember/kit && title kit"
alias waves="cd /Users/ryanschie/code/Subsplash/javascript/waves && title waves"
alias dash="cd /Users/ryanschie/code/Subsplash/ember/dashboard-client && title dash"
alias giving="cd /Users/ryanschie/code/Subsplash/ember/giving && title giving"
alias blueprints="cd /Users/ryanschie/code/Subsplash/ember/blueprints && title blueprints"
alias web="cd /Users/ryanschie/code/Subsplash/ember/web-client && title web-client"
alias native="cd /Users/ryanschie/code/Subsplash/ember/native-web && title native-web"
alias signup="cd /Users/ryanschie/code/Subsplash/ember/signup && title signup"
alias ci="cd /Users/ryanschie/code/Subsplash/ember/ci && title ci"
alias hub="cd /Users/ryanschie/code/Subsplash/ember/hub && title hub"
alias sui="cd /Users/ryanschie/code/Subsplash/ember/sui && title sui"

alias tcarn="cd /Users/ryanschie/code/Subsplash/tca/tca-react-native && title tca react native"
alias tcaios="cd /Users/ryanschie/code/Subsplash/tca/tca-ios && title tca ios"
alias omni="cd /Users/ryanschie/code/Subsplash/omni/app && title omni"

alias waves2="cd /Users/ryanschie/code/Subsplash/_secondary/waves-2 && title waves-2"
alias hub2="cd /Users/ryanschie/code/Subsplash/_secondary/hub2 && title hub-2"
alias wallet2="cd /Users/ryanschie/code/Subsplash/_secondary/wallet && title wallet2"
alias kit2="cd /Users/ryanschie/code/Subsplash/_secondary/ember-kit-2 && title kit2"
alias kit3="cd /Users/ryanschie/code/Subsplash/_secondary/ember-kit-3 && title kit3"
alias lts4="cd /Users/ryanschie/code/Subsplash/_secondary/kit/lts-4 && title kit lts 4"
alias lts5="cd /Users/ryanschie/code/Subsplash/_secondary/kit/lts-5 && title kit lts 5"
alias dash2="cd /Users/ryanschie/code/Subsplash/_secondary/dashboard-client-2 && title dash2"
alias dash3="cd /Users/ryanschie/code/Subsplash/_secondary/dashboard-client-3 && title dash3"
alias giving2="cd /Users/ryanschie/code/Subsplash/_secondary/giving2 && title giving2"

alias glimmer="cd $GOPATH/src/subsplash.io/go/donor-ux/glimmer && title glimmer"

alias mydash="cd /Users/ryanschie/code/rschie/ember/dashboard-client && title my-dash"
alias mykit="cd /Users/ryanschie/code/rschie/ember/kit && title my-kit"

alias mfe="cd /Users/ryanschie/code/rschie/microfrontend/single-spa && title mfe"

# FE Commands
alias ys="yarn start"
alias ysn="yarn start:no-mirage"
alias yl="yarn local"
alias y="yarn"
alias yf="yarn --force"
alias yup="yarn upgrade-interactive"
yp() {
  yarn packages/$1 $@[2,-1]
}

alias em="ember"
alias tf="terraform"

# Go Commands
alias gosub="cd $GOPATH/src/subsplash.io/go"
gobin () { var=`basename $(pwd)`; go install ./...; $GOPATH/bin/${var} config/$1.json }
gogbin () { var=`basename $(pwd)`; go generate ./...; go install ./...; $GOPATH/bin/${var} config/config.json }
gotest () { go test ./... | grep -v '\[no test files\]' }

alias go-run-dev='export SERVICE=$(basename $(pwd)); go install ./... && aws-vault exec default -- $GOBIN/$SERVICE ./config/$SERVICE.dev.json'
alias go-run-stage='export SERVICE=$(basename $(pwd)); go install ./... && aws-vault exec default -- $GOBIN/$SERVICE ./config/$SERVICE.stage.json'

# React Commands
alias rn="react-native"

# OTHER
alias watchreset="watchman watch-del-all"
alias fixn="curl -0 -L https://npmjs.com/install.sh | sudo sh"

nodeinspect() { node --inspect-brk node_modules/.bin/"$@" }

# Gitlab Runner
grun() { gitlab-runner exec docker "$@" }
grunssh() { gitlab-runner exec docker --env "SSH_KEY=$(cat ~/.ssh/id_rsa)" --env "SSH_KNOWN_HOSTS=$(cat ~/.ssh/known_hosts)" "$@" }

# My helper functions
,,mymrs() { open "https://subsplash.io/dashboard/merge_requests?assignee_username=rschie" }
,,omrs() { open "https://subsplash.io/dashboard/merge_requests?author_username=$1" }

,,git() { 
  open "$(g remote get-url origin | sed 's git@ https:// g; s io: io/ g')"
}
,,gitm() {
  open "$(g remote get-url origin | sed 's git@ https:// g; s io: io/ g')/-/merge_requests"
}
,,gitp() { 
  open "$(g remote get-url origin | sed 's git@ https:// g; s io: io/ g')/pipelines"
}

nodeKitSetup() {
  git init
  git remote add origin git@subsplash.io:ember/kit
  git fetch --depth 1
  git checkout origin/5.x -ft
}

####### NOT NORMALLY USEFUL #######

# ZLE VIM Cursor

# function zle-keymap-select zle-line-init
# {
#   # change in iterm2
#   case $KEYMAP in
#     vicmd)      print -n -- "\E]50;CursorShape=0\C-G";; # block
#     viins|main) print -n -- "\E]50;CursorShape=1\C-G";; # line
#   esac

#   zle reset-prompt
#   zle -R
# }

function zle-line-finish
{
  print -n -- "\E]50;CursorShape=0\C-G" # block
}

# zle -N zle-line-init
zle -N zle-line-finish
# zle -N zle-keymap-select

fkill() {
    local pid 
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi  
}


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
