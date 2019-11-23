#!/bin/zsh

# Init setup
if [ $SHELL != "/bin/zsh" ]; then
  chsh -s /bin/zsh
fi

# Setup Apple Defaults writes (needs re-login)
defaults write -g ApplePressAndHoldEnabled -bool false

# Install Homebrew
if [ ! -x /usr/local/bin/brew ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install ZSH & ZSH completions
#brew install zsh zsh-completions

# Install Git
#brew install git

# Install Prezto
if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  if [ ! -f "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]; then
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  fi
done

# Install VIM
#brew install vim

# Setup VIM
mkdir -p ~/.vim
mkdir -p ~/.vim/backups
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/tmp

# Install vim-plug (https://github.com/junegunn/vim-plug)
if [ ! -d ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Setup config dotfiles
mkdir -p ~/.zprezto
rm -rf ~/.vim/scripts
rm -rf ~/.zprezto/runcoms
ln -sf ~/dotfiles/gitconfig ~/.gitconfig
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/vim/vimrc ~/.vim/vimrc
ln -sfn ~/dotfiles/vim/scripts ~/.vim
ln -sfn ~/dotfiles/zprezto/runcoms ~/.zprezto

# Link zprezto theme
ln -sf ~/dotfiles/zprezto/modules/prompt/functions/prompt_rygar_setup ~/.zprezto/modules/prompt/functions

# Install Vim plugins after dotfiles copied
vim +PlugInstall +qall
