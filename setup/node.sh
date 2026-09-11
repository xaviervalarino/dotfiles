#!/usr/bin/env sh

# Install Node via mise
if ! command -v mise > /dev/null; then
  echo 'mise is missing, install with: brew install mise'
  exit 1
fi

mise use -g node@lts

# Install global packages
mise exec node@lts -- npm -g install \
  bash-language-server \
  prettier \
  svelte-language-server \
  typescript \
  typescript-language-server \
  vscode-langservers-extracted \
  uvcc # camera controller

# Check what was installed
mise ls node
mise exec node@lts -- npm ls -g --depth=0
