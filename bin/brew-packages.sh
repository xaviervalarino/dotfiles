#!/usr/bin/env sh

# Core
# `brew leaves --installed-on-request`
CORE=(
  bat
  fd
  fzf
  git
  git-delta
  lua-language-server
  luajit
  m-cli
  n
  neovim
  pidof
  pure
  ripgrep
  shellcheck
  stow
  the_silver_searcher
  tldr
  trash
  tree
  utimer
  zsh-completions
)

CASKS=(
  font-iosevka
  hammerspoon 
  iterm2 
  karabiner-elements 
)

printf "%s\n" "Installing core packages..."
brew install ${CORE[@]}

printf "%s\n" "Installing casks..."
brew install --cask ${CASKS[@]}


