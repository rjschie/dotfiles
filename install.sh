mkdir -p ~/.vim
mkdir -p ~/.zprezto
ln -sf ~/dotfiles/gitconfig ~/.gitconfig
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/vim/vimrc ~/.vim/vimrc

rm -rf ~/.vim/scripts
rm -rf ~/.zprezto/runcoms
ln -sfn ~/dotfiles/vim/scripts ~/.vim
ln -sfn ~/dotfiles/zprezto/runcoms ~/.zprezto
