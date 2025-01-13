if test -d $HOME/.pyenv
  set -gx PYENV_ROOT $HOME/.pyenv

  fish_add_path $PYENV_ROOT/bin

  pyenv init - | source
end
