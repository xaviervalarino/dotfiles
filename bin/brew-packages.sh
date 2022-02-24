#!/usr/bin/env sh

# Core
CORE=(
  bat
  fzf  
  git 
  git-delta 
  m-cli 
  node 
  nvm 
  pidof
  tldr 
  trash 
  vim 
  shellcheck
  the_silver_searcher
  tree
  utimer
  zsh-completions
)

CASKS=(
  hammerspoon 
  iterm2 
  karabiner-elements 
  logitech-options 
)

printf "%s\n" "Installing core packages..."
brew install ${CORE[@]}

printf "%s\n" "Installing casks..."
brew install ${CASKS[@]}


