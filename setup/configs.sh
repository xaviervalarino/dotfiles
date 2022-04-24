#!/usr/bin/env bash

cd .. || exit 1

stow -Rv zsh
# export ENV
source "$HOME/.zprofile"
# set up zsh history dir
mkdir -p "$XDG_DATA_HOME/zsh"

stow -Rv iterm
# iterm: use custom config directory
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$XDG_CONFIG_HOME/iterm2/"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

stow -Rv karabiner
stow -Rv hammerspoon

stow -Rv bat
stow -Rv git
stow -Rv js
stow -Rv scripts
stow -Rv stylua
stow -Rv nvim
# TODO: set up nvim
# nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Add secondary icon font used in iTerm and Nvim
# Note: update this to `brew --cask install font-*` when this ticket is closed:
# https://github.com/ryanoasis/nerd-fonts/issues/479
curl https://github.com/ryanoasis/nerd-fonts/blob/master/src/glyphs/Symbols-1000-em%20Nerd%20Font%20Complete.ttf\
  --output "$HOME/Library/Fonts/Symbols-1000-em Nerd Font Complete.ttf"
