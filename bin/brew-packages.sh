#!/usr/bin/env bash

# Core
# `brew leaves --installed-on-request`
CORE=(
  bat
  coreutils
  fd
  fzf
  gh
  git
  git-delta
  glow
  imagemagick
  lua-language-server
  luajit
  m-cli
  mkcert
  n
  neovim
  nss
  pidof
  pstree
  pure
  ripgrep
  rust
  shellcheck
  stow
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
brew install "${CORE[@]}"

printf "%s\n" "Installing casks..."
brew install --cask "${CASKS[@]}"
