#!/usr/bin/env sh

npm install -g \
  bash-language-server \
  prettier_d_slim \
  typescript-language-server \
  typescript \
  vscode-langservers-extracted \

# Check what was installed
npm ls -g
