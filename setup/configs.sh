#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR" && cd .. || exit 1

stow -Rv --dotfiles zsh
# export ENV
source "$HOME/.zprofile"
# set up zsh history dir
mkdir -p "$XDG_DATA_HOME/zsh"
[ -f "$HOME/.zsh_history" ] && rm -v "$HOME/.zsh_history"

# fuzzy finder
yes | "$HOMEBREW_PREFIX/opt/fzf/install"

stow -Rv --dotfiles wezterm

stow -Rv --dotfiles karabiner
launchctl kickstart -k "gui/$(id -u)/org.pqrs.karabiner.karabiner_console_user_server"

stow -Rv --dotfiles hammerspoon
echo "Creating /usr/local dirs for hammerspoon CLI"
sudo mkdir -v /usr/local/{bin,share}
echo "Changing dirs owner to '$(whoami)'"
sudo chown -v "$(whoami):" /usr/local/{bin,share}
echo "Adding write privileges to dirs"
sudo chmod -v u+w /usr/local/{bin,share}

stow -Rv --dotfiles bat
bat cache --build

stow -Rv --dotfiles git
stow -Rv --dotfiles js
stow -Rv --dotfiles scripts
stow -Rv --dotfiles stylua
# cargo install stylua

stow -Rv --dotfiles nvim
