function my_fish_key_bindings

  fish_vi_key_bindings

  #: Make Ctrl-y accept suggestion
  bind --preset -M insert \cy forward-word
  bind --preset \cy forward-word
  bind --preset -M visual \cy forward-word

  #: Make Ctrl-n & Ctrl-p search down/up
  bind --preset -M insert \cn down-or-search
  bind --preset -M insert \cp up-or-search
  bind --preset \cn down-or-search
  bind --preset \cp up-or-search
  bind --preset -M visual \cn down-or-search
  bind --preset -M visual \cp up-or-search

end

