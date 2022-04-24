#!/usr/bin/env bash

# Core
# `brew leaves --installed-on-request`
CORE=(
  bat
  coreutils
  fd
  fzf
  gh
  gh
  git
  git-delta
  glow
  imagemagick
  lua-language-server
  m-cli
  mkcert
  moreutils
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
  figma
  google-chrome
  hammerspoon 
  homebrew/cask-fonts/font-iosevka
  homebrew/cask-versions/firefox-developer-edition
  iterm2 
  karabiner-elements 
  miro
  slack
)

printf "%s\n" "Installing core packages..."
brew install "${CORE[@]}"

printf "%s\n" "Installing casks..."
brew install --cask "${CASKS[@]}"
