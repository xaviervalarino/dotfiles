#!/usr/bin/env bash

# Place the user back where they were before
# since this script needs to be run in the shell, and not a subshell
# e.g., source ./script vs. ./script
USR_LOCATION=$PWD
trap "cd $USR_LOCATION" EXIT INT

msg () {
  printf "\n%s\n" "$1"
}
msg "Starting setup..."

msg "Installing Xcode Command Line Developer Tools"
xcode-select --install &> /dev/null

# Hold the show until it's done installing
until eval xcode-select -p &> /dev/null; do
  sleep 3
done

msg "Installing Homebrew"
if ! which brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed, skipping"
fi

msg "Cloning dotfiles"
if [[ ! -d "$HOME/dotfiles" ]]; then
  git clone https://github.com/xaviervalarino/dotfiles.git
else
  echo "Dotfiles directory already exists"
fi

if [ "$(uname -m)" = "arm64" ]; then
  brew=/opt/homebrew/bin/brew
else
  brew=/usr/local/bin/brew
fi
eval "$($brew shellenv)"

cd $HOME/dotfiles || exit 1
brew bundle install --verbose
./setup/defaults.mac.sh
./setup/configs.sh
./setup/npm.sh

msg "Finished"
