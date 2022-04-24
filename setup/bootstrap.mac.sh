#!/usr/bin/env bash

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
if ! which brew > /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed, skipping"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

msg "Cloning dotfiles"
if [[ ! -d "$HOME/dotfiles" ]]; then
  git clone https://github.com/xaviervalarino/dotfiles.git
else
  echo "Dotfiles directory already exists"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle install
./defaults.mac.sh
./configs.sh
./npm.sh

msg "Finished"
