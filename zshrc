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
export ANDROID_HOME=${HOME}/Library/Android/sdk
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/tools/bin
export PATH=${PATH}:${ANDROID_HOME}/platform-tools
export PATH=${HOME}/.npm-global/bin:${PATH}
export PATH="/usr/local/opt/php@5.6/bin:$PATH"
export PATH="/usr/local/opt/php@5.6/sbin:$PATH"
export PATH=${HOME}/.bin:${PATH}

export AWS_SDK_LOAD_CONFIG=1
export HOMEBREW_GITHUB_API_TOKEN=81477ffea61e1cbad6d929516be24326a9f12e68
export GPG_TTY=$(tty)

export GREP_COLORS='mt=01;31:fn=36'

export FZF_DEFAULT_COMMAND='fd --type f'

# Loading Completions
compctl -g '~/.itermocil/*(:t:r)' itermocil

# Custom OPTS
unsetopt correct
unsetopt correct_all

####### USEFUL THINGS #######

# Main Aliases
alias rsrc="source ~/.zshrc"
alias orc="vim ~/.zshrc"
alias vimrc="vim ~/.vim/vimrc"
alias l="ls -lFhH"
alias la="ls -lFAHh"
alias -g G="| ggrep"
alias pwdc="echo -n $(pwd) | pbcopy"


# Helpers
alias rmrf="rm -rf"
alias mk="mkdir -p"
alias grep="nocorrect ggrep --color=auto"
alias grip="nocorrect ggrep --color=auto -riP"
mkd () { mkdir -p $*; cd $* }
trash () { mv $* ~/.Trash/ }
title () { set-tab-title $* }

# Finding
sar () { find $1 -name "*.$2" -type f -exec perl -p -i -e "$3" -- {} + }
sarfd () { fd -t f -x perl -p -i -e "$1" -- {} }
search () { find -L $1 -name "$2" ${*:3} }
alias findlinks="find node_modules -type l -ls -maxdepth 1"

#$(aws ecr get-login --no-include-email --region us-west-2)

# Application Aliases
alias v="vim"
alias -g F="\$(fzf)"
alias fv="vim \$(fzf)"
alias g="git"
alias t="tmux"
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

# Directory Aliases
alias dash="cd /Users/ryanschie/code/Subsplash/dashboard-client"
alias dash2="cd /Users/ryanschie/code/Subsplash/_secondary/dashboard-client-2"
alias db="cd /Users/ryanschie/code/Subsplash/ember/dashboard/application"
alias dbbuilder="cd /Users/ryanschie/code/Subsplash/ember/dashboard/engine-builder"
alias dbgiving="cd /Users/ryanschie/code/Subsplash/ember/dashboard/engine-giving"
alias dbanalytics="cd /Users/ryanschie/code/Subsplash/ember/dashboard/engine-analytics"
alias dblibrary="cd /Users/ryanschie/code/Subsplash/ember/dashboard/engine-library"
alias dbpush="cd /Users/ryanschie/code/Subsplash/ember/dashboard/engine-push"
alias dbsettings="cd /Users/ryanschie/code/Subsplash/ember/dashboard/engine-settings"
alias dblib="cd /Users/ryanschie/code/Subsplash/ember/dashboard/lib"
alias dashboard="cd /Users/ryanschie/code/Subsplash/dashboard"
alias sap="cd /Users/ryanschie/code/Subsplash/dashboard/libraries/sap_core"
alias kit="cd /Users/ryanschie/code/Subsplash/ember-kit"
alias kit2="cd /Users/ryanschie/code/Subsplash/_secondary/ember-kit-2"
alias hub="cd /Users/ryanschie/code/Subsplash/hub"
alias native="cd /Users/ryanschie/code/Subsplash/native-web"
alias sui="cd /Users/ryanschie/code/Subsplash/sui"
alias web="cd /Users/ryanschie/code/Subsplash/web-client"
alias webdev="cd /Users/ryanschie/code/Subsplash/webdev-env-setup"
alias uidocs="cd /Users/ryanschie/code/Subsplash/ui-docs"
alias wallet="cd /Users/ryanschie/code/Subsplash/_wallet/wallet"
alias monaco="cd /Users/ryanschie/code/Subsplash/monaco"
alias promo="cd /Users/ryanschie/code/Subsplash/promo-automation-agent"
alias blank="cd /Users/ryanschie/code/ember-test/blank-app"

alias goaccounts="cd $GOPATH/src/subsplash.io/go/accounts"
alias gobuilder="cd $GOPATH/src/subsplash.io/go/builder"
alias goevents="cd $GOPATH/src/subsplash.io/go/events"
alias gomedia="cd $GOPATH/src/subsplash.io/go/media"

alias walletssh="ssh -L 3306:db.dev.giving.subsplash.net:3306 rschie@bastion.subsplash.net"

# Ember Commands
alias em="ember"
alias es="ember serve"
alias esl="ember start --disable-fastboot --e=local"
alias est="ember start"
alias esm="ember start --disable-fastboot"

alias qunitcodemod="jscodeshift -t https://rawgit.com/rwjblue/ember-qunit-codemod/master/ember-qunit-codemod.js"

alias yarnf="yarn --force"

# Go Commands
alias gosrc="cd $GOPATH/src"
gobin () { var=`basename $(pwd)`; go install ./...; $GOPATH/bin/${var} config/config.json }
gogbin () { var=`basename $(pwd)`; go generate ./...; go install ./...; $GOPATH/bin/${var} config/config.json }

# React Commands
alias rn="react-native"

# OTHER
alias watchreset="watchman watch-del-all"
alias fixn="curl -0 -L https://npmjs.com/install.sh | sudo sh"




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


