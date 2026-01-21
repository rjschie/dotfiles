# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Setup

```sh
./setup  # runs xcode, homebrew, symlinks, mac-defaults, fisher
```

Manual post-setup:
- Set fish as default shell (see README)
- Enable Hammerspoon at login
- Restart

## Structure

```
files/           # all configs, symlinked to ~/.config or ~/
  fish/          # shell: conf.d/, functions/, completions/
  nvim/          # lua-based, lazy.nvim plugin manager
  git/           # config + config_override pattern
  tmux/          # tmux.conf
  kitty/         # terminal emulator
  hammerspoon/   # macos automation
  ssh/           # keys + config_override pattern
  gh/            # github cli
scripts/         # mac-defaults.sh
Brewfile         # homebrew packages
```

## Key Patterns

**Symlinks**: Direct links from `files/<tool>` to `~/.config/<tool>` or `~/.<tool>`

**Override files**: `config_override` in git/ and ssh/ for machine-specific settings (not committed)

**Neovim**: `init.lua` → `lua/config/` (keymaps, options, autocmds) + `lua/plugins/` (individual plugin specs). Uses lazy.nvim.

**Fish**: Numbered files in `conf.d/` (0.fish, 1-exports.fish, 2-aliases.fish, 3-additional.fish)

## Notes

- No test suite
- macOS-focused (Homebrew, Hammerspoon)
- Catppuccin theme across nvim/kitty
