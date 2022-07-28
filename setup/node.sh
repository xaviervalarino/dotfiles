#!/usr/bin/env sh

# Install @latest
if ! which volta > /dev/null; then echo 'Volta is missing' exit 1; fi
if ! which node > /dev/null; then volta install node@latest; fi

# Install global packages
volta install \
  bash-language-server \
  prettier \
  typescript \
  typescript-language-server \
  vscode-langservers-extracted 

# Check what was installed
volta list
