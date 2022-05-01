#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR" && cd .. || exit 1

stow -Rv zsh
# export ENV
source "$HOME/.zprofile"
# set up zsh history dir
mkdir -p "$XDG_DATA_HOME/zsh"
[ -f "$HOME/.zsh_history" ] && rm -v "$HOME/.zsh_history"

# fuzzy finder
yes | /usr/local/opt/fzf/install

stow -Rv iterm
mkdir -p "$XDG_CONFIG_HOME/iterm2/"
# iterm: use custom config directory
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$XDG_CONFIG_HOME/iterm2/"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

stow -Rv karabiner
launchctl kickstart -k "gui/$(id -u)/org.pqrs.karabiner.karabiner_console_user_server"

stow -Rv hammerspoon

stow -Rv bat
bat cache --build

stow -Rv git
stow -Rv js
stow -Rv scripts
stow -Rv stylua
cargo install stylua

stow -Rv nvim
# TODO: set up nvim
# nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Add secondary icon font used in iTerm and Nvim
# Note: update this to `brew --cask install font-*` when this ticket is closed:
# https://github.com/ryanoasis/nerd-fonts/issues/479
# TODO: not working
# curl --LJO https://github.com/ryanoasis/nerd-fonts/blob/master/src/glyphs/Symbols-2048-em%20Nerd%20Font%20Complete.ttf\
  # --output "$HOME/Library/Fonts/Symbols-2048-em Nerd Font Complete.ttf"
open https://github.com/ryanoasis/nerd-fonts/blob/master/src/glyphs/Symbols-2048-em%20Nerd%20Font%20Complete.ttf
