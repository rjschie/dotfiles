#!/bin/zsh

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

mkdir -p ~/.zprezto
rm -rf ~/.zprezto/runcoms
ln -sf "$PWD/files/zshrc" ~/.zshrc
ln -sfn "$PWD/files/zprezto/runcoms" ~/.zprezto
ln -sf "$PWD/files/zprezto/modules/prompt/functions/prompt_rygar_setup" ~/.zprezto/modules/prompt/functions