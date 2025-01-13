# Dotfiles

## Installation / Setup

1. Open terminal and git clone
```bash
git clone https://github.com/rjschie/dotfiles $HOME/code/github.com/rjschie/dotfiles
```

2. Run setup
```bash
cd $HOME/code/github.com/rjschie/dotfiles
./setup
```

3. Change default Shell
```bash
# Set fish as default terminal
chsh -s $HOMEBREW_PREFIX/bin/fish
```

4. Close terminal and open kitty


### TODO
- [ ] Setup launch on login for:
    - TGPro
    - Hammerspoon
- [ ] Setup applications that were installed
    - Brave
    - 1Password

### Research
- [ ] Check out CLI tools
    - Stow

## TEST INSTALL NOTES
### TODO
- [ ] See error about Brew Bundle installing hammerspoon, brave-browser, kitty (and probably others)
- [ ] Fix Setup to add a create_symlink func that simplifies the linking
- [ ] Setup a CLI that guides you through setup
    - checkbox to each software (from brew and otherwise)
    - checkbox to each step (setup ssh, setup gpg, each symlink, etc.)
- [ ] Setup default shell
    - needs to make sure fish is in `/etc/shells` file
- [ ] Update message to indicate logging out/in to start fresh

