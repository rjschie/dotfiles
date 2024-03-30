#!/bin/zsh

# Install Brew
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
fi

brew update

# Install commons
brew install git vim gpg neovim tree n jq zsh zsh-completions

# Install Neovim helpers
brew install ripgrep fd

