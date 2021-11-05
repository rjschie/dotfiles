#!/bin/zsh

# Setup VIM
mkdir -p ~/.vim
mkdir -p ~/.vim/backups
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/tmp

# Install vim-plug (https://github.com/junegunn/vim-plug)
if [ ! -d ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

rm -rf ~/.vim/scripts
ln -sf "$PWD/files/vim/vimrc" ~/.vim/vimrc
ln -sfn "$PWD/files/vim/scripts" ~/.vim

# Install Vim plugins after dotfiles copied
vim +PlugInstall +qall