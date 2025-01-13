## Desires
- [ ] Move plugin config to one file that just loads the plugin, then
      separate files, for each, that do the config. So I can `:so %`
      to reload plugin
- [ ] Consolidate filetypes for JS/TS/JSX/TSX so I can just define them once
- [ ] Add `cmd+bs` keybind in Insert to backspace all the way back
- [ ] Find better keymaps and move them all into one file
  - make surrounds better
  - remove <space><space> for open buffers and use something else
  - `U` for redo
  - `H` and `L` for begin/end of line
  - `<leader>b`... for buffer actions ([w]rite, [x]close, [wa]write all, etc.)
  - `<leader>f`... for finding with telescope (and getting back `s` as a replacer)
    - `ff` - cwd search
    - `fp` - project search (git or something else to delineate project)
    - `fd` - buffer search
  - `<leader>e`... for "explore" (nvim-tree)
- [ ] Fix auto-formatting not working (on save, and give a motion/command to do it)
- [ ] Auto-indent on `o`
- [ ] Auto-add closing pairs in programming files
- [ ] Open Command in floating window (like Telescope) with Normal/Insert modes available
- [ ] Use `vim.opt.formatoptions:remove 'o'`

## Plugins
- [ ] Project & Session manager
- [ ] Replace Oil? with nvim-tree, or just add it.
  - Tree view is really helpful for me to explore a new project
- [ ] Easy motion?

## REFs
- https://github.com/josean-dev/dev-environment-files/tree/main/.config/nvim
- https://github.com/christoomey/vim-tmux-navigator/
