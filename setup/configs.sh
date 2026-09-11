#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR" && cd .. || exit 1

# Scaffold XDG directory structure before stowing
# (ensures ~/.config is a real directory, not a symlink to a single stowed folder)
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_DATA_HOME/zsh"
mkdir -p "$XDG_STATE_HOME/zsh"
mkdir -p "$XDG_CACHE_HOME"

stow -Rv --dotfiles zsh
# export ENV
source "$HOME/.zshenv" 2>/dev/null || true
source "$HOME/.zprofile" 2>/dev/null || true
[ -f "$HOME/.zsh_history" ] && rm -v "$HOME/.zsh_history"

# fuzzy finder
yes | "$HOMEBREW_PREFIX/opt/fzf/install"

stow -Rv --dotfiles wezterm

stow -Rv --dotfiles karabiner
launchctl kickstart -k "gui/$(id -u)/org.pqrs.karabiner.karabiner_console_user_server"
goku 2>/dev/null || true

stow -Rv --dotfiles hammerspoon

stow -Rv --dotfiles bat
bat cache --build

stow -Rv --dotfiles docker
stow -Rv --dotfiles git
stow -Rv --dotfiles glow
stow -Rv --dotfiles js
stow -Rv --dotfiles mise
stow -Rv --dotfiles scripts
stow -Rv --dotfiles stylua
# cargo install stylua

stow -Rv --dotfiles tealdeer
tldr --update 2>/dev/null || true

stow -Rv --dotfiles nvim

# Stow private agent configurations if submodule is present
if [ -d "$SCRIPT_DIR/../agents" ]; then
  stow -Rv --dotfiles -d "$SCRIPT_DIR/../agents" -t "$HOME" gemini 2>/dev/null || true
  stow -Rv --dotfiles -d "$SCRIPT_DIR/../agents" -t "$HOME" claude 2>/dev/null || true
fi
