#!/bin/zsh

# Install Brew
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
fi

# Install commons
brew install git vim gpg neovim tree n yarn jq zsh zsh-completions
