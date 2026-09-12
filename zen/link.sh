#!/usr/bin/env bash
set -euo pipefail

# Find active Zen profile on macOS
ZEN_DIR="$HOME/Library/Application Support/zen/Profiles"

if [ ! -d "$ZEN_DIR" ]; then
  echo "Error: Zen directory not found at $ZEN_DIR"
  exit 1
fi

PROFILE_DIR=$(find "$ZEN_DIR" -maxdepth 1 -name "*.Default*" | head -n 1)

if [ -z "$PROFILE_DIR" ] || [ ! -d "$PROFILE_DIR" ]; then
  echo "Error: No default Zen profile found in $ZEN_DIR"
  exit 1
fi

DOTFILES_ZEN="$HOME/dotfiles/zen"

# Ensure local directories and template files exist
mkdir -p "$DOTFILES_ZEN/chrome"
touch "$DOTFILES_ZEN/chrome/userChrome.css"
touch "$DOTFILES_ZEN/user.js"

# Symlink chrome directory and user.js into the active Zen profile
ln -sfn "$DOTFILES_ZEN/chrome" "$PROFILE_DIR/chrome"
ln -sf "$DOTFILES_ZEN/user.js" "$PROFILE_DIR/user.js"

echo "Successfully linked dotfiles/zen -> $PROFILE_DIR"
