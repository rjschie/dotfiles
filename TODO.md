## Neovim

- [x] In buffer picker: C-d to remove buffer
- [ ] In buffer picker: Highlighted '+'
- [ ] Auto session save & restore when I quite and reload in a CWD
  - "AutoSession save" / "Autosession restore"?
- [ ] File search should include folders when ending with `/` (e.g. `src/` should show ./src/ directory as top result)
- [ ] Move plugin config to one file that just loads the plugin, then
      separate files, for each, that do the config. So I can `:so %`
      to reload plugin

--- ? ---

- [ ] Consolidate filetypes for JS/TS/JSX/TSX so I can just define them once
- [x] ~~Add `cmd+bs` keybind in Insert to backspace all the way back~~
- [ ] Fix auto-formatting not working (on save, and give a motion/command to do it)
- [ ] Auto-indent on `o`
- [ ] Auto-add closing pairs in programming files
- [ ] Open Command in floating window (like Telescope) with Normal/Insert modes available
- [ ] Use `vim.opt.formatoptions:remove 'o'`
