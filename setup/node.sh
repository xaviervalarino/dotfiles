#!/usr/bin/env sh

# Install @latest
if ! which volta > /dev/null; then echo 'Volta is missing' exit 1; fi

volta install node@latest

# Install global packages
npm -g install \
  bash-language-server \
  prettier \
  svelte-language-server \
  typescript \
  typescript-language-server \
  vscode-langservers-extracted  \
  uvcc # camera controller

# Check what was installed
volta list
npm ls -g
