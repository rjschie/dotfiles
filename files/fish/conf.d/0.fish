if status is-interactive

  set -g fish_greeting
  set -g fish_key_bindings my_fish_key_bindings

  if command -q /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
  else if command -q /usr/local/bin/brew
    eval (/usr/local/bin/brew shellenv)
  end

  set -gx HOMEBREW_NO_AUTO_UPDATE 1
  set -gx HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK 1

  starship init fish | source

end
