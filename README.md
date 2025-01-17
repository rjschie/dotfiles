# Dotfiles

## Installation / Setup

1. Open terminal and git clone

   ```sh
   git clone https://github.com/rjschie/dotfiles $HOME/code/github.com/rjschie/dotfiles
   ```

2. Run setup

   ```sh
   cd $HOME/code/github.com/rjschie/dotfiles
   ./setup
   ```

3. Change default Shell

   ```sh
   # Set fish as default terminal
   sudo HOMEBREW_PREFIX=$HOMEBREW_PREFIX sh -c 'echo "$HOMEBREW_PREFIX/bin/fish" >> /etc/shells'
   chsh -s $HOMEBREW_PREFIX/bin/fish
   ```

4. Open Hammerspoon, then options, then enable "Launch Hammerspoon at login"

5. Restart computer

## Improvements

### TODO

- After `./setup` runs, echo next steps
- Add `chsh` to `./setup`
- Setup launch on login for:
  - TGPro
  - Hammerspoon
- Setup applications that were installed
  - Brave
  - 1Password
- Setup a CLI that guides you through setup
  - checkbox to each software (from brew and otherwise)
  - checkbox to each step (setup ssh, setup gpg, each symlink, etc.)
- Fix Setup to add a create_symlink func that simplifies the linking

### Research

- See error about Brew Bundle installing hammerspoon, brave-browser, kitty (and probably others)
- Check out CLI tools
  - Stow
