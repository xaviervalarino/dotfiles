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
yes | "$HOMEBREW_PREFIX/opt/fzf/install"

stow -Rv kitty

stow -Rv karabiner
launchctl kickstart -k "gui/$(id -u)/org.pqrs.karabiner.karabiner_console_user_server"

stow -Rv hammerspoon
# Set up /usr/local/ for hammerspoon CLI
echo "Creating /usr/local dirs"
sudo mkdir -v /usr/local/{bin,share}
echo "Changing dirs owner to '$(whoami)'"
sudo chown -v "$(whoami):" /usr/local/{bin,share}
echo "Adding write privileges to dirs"
sudo chmod -v u+w /usr/local/{bin,share}

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
