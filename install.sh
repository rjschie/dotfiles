#!/bin/zsh

if [ $SHELL != "/bin/zsh" ]; then
  chsh -s /bin/zsh
fi

/bin/zsh "./scripts/install-brew.sh"
/bin/zsh "./scripts/install-zsh.sh"
/bin/zsh "./scripts/install-vim.sh"

# Setup Press and hold. Allows holding Vim keys in VSCode
# Use `-g` in place of `com.microsoft.VSCode` if desired globally
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# Setup misc dotfiles
ln -sf "$PWD/files/gitconfig" ~/.gitconfig

if [ ! -f ~/.zshrc-override ]; then
  cp "$PWD/templates/zshrc-override" ~/.zshrc-override;
fi

if [ ! -f ~/.gitconfig-override ]; then
  cp "$PWD/templates/gitconfig-override" ~/.gitconfig-override;
fi

/bin/zsh "./scripts/install-keys.sh"