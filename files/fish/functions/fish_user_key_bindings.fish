function fish_user_key_bindings

  #: Make Ctrl-y accept suggestion
  bind --preset -M insert \cy forward-bigword
  bind --preset \cy forward-bigword
  bind --preset -M visual \cy forward-bigword

  #: Make Ctrl-n & Ctrl-p search down/up
  bind --preset -M insert \cn down-or-search
  bind --preset -M insert \cp up-or-search
  bind --preset \cn down-or-search
  bind --preset \cp up-or-search
  bind --preset -M visual \cn down-or-search
  bind --preset -M visual \cp up-or-search

end

