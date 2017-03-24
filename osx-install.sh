#!/bin/bash

# Setup OSX after a fresh install
# Tweaks for a small boot SSD
# Installs various Homebrew and NPM packages
# Sets up Terminal Theme

# =======================
# Tweak OSX for small SSD
# =======================

# Disable local Time Machine image
sudo tmutil disablelocal

# Turn off hibernation and sleep
sudo pmset -a hibernatemode 0
sudo pmset -a disksleep 0

# Delete, sleep image, create zero space file and lock it
sudo rm /var/vm/sleepimage
sudo touch /Private/var/vm/sleepimage
sudo chflags uchg /Private/var/vm/sleepimage

# Set noatime
# TODO: cat XML >  com.noatime.root.plist
sudo chown root:wheel /Library/LaunchDaemons/com.noatime.root.plist
mount | grep " /"
# Should come up noatime after restart
ls

# Write screenshot to another location
if [ ! -d /Volumes/Xavier_HD/screenshots ]; then
    mkdir /Volumes/Xavier_HD/screenshots
fi
defaults write com.apple.screencapture location /Volumes/Xavier_HD/screenshots/


# Link home folder items
sudo rm -v \
    $HOME/Documents \
    $HOME/Downloads \
    $HOME/Pictures \
    $HOME/Music \
    $HOME/Movies \
    $HOME/Public

ln -s /Volumes/Xavier_HD/home/* $HOME

# TODO: Fonts and Messages do not work
# http://apple.stackexchange.com/questions/262501/symlinking-fonts-and-messages-folders-to-2nd-hdd-does-not-seem-to-work
# Links large Library items (Fonts, Mail, Messages) to external HDD
# ln -s /Volumes/Xavier_HD/lib_items/* $HOME/Library


# ==============================
# Homebrew and Cask Applications
# ==============================

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install \
    bash \
    bash-completion \
    brew-cask-completion \
    coreutil \
    git \
    htop \
    khd \
    kwm \
    neovim/neovim/neovim \
    node \
    pandoc \
    pip-completion \
    stow \
    terminal-notifier \
    the_silver_searcher \
    trash \
    tree \
    wget \


# Casks
brew tap caskroom/cask

brew cask install \
    Caskroom/versions/omnigraffle6 \
    awareness \
    balsamiq-mockups \
    cheatsheet \
    eleston-chromium \
    filezilla \
    firefox \
    flux \
    fontforge \
    handbrake \
    itsycal \
    whichspace \
    karabiner \
    seil \
    sublime-text \
    the-unarchiver \
    transmission \
    vlc \

# TODO: need OAuth API token if searching casks frequently?

# TODO: is cask actually useful for installing fonts?
# brew tap caskroom/fonts


# =========================
# Install borderless iTerm2
# =========================
git clone https://github.com/jaredculp/iterm2-borderless-padding.git
./install.sh 15 15


# ======================
# Set up Perl & Perlbrew
# ======================

\curl -L https://install.perlbrew.pl | bash


# ==============
# Clone dotfiles
# ==============

#TODO: need to gen RSA key?
ssh-keygen -t rsa -b 4096 -C "xvalarino@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
pbcopy < ~/.ssh/id_rsa.pub
echo "Public RSA key copied to clipboard"

git clone git@github.com:xaviervalarino/dotfiles.git


# ======================
# Set up Node JS and NPM
# ======================

mkdir ~/.npm-global
npm config set prefix "$HOME/.npm-global"

npm i -g \
    base16-builder \
    browserify \
    gulp-cli \
    jshint \
    npm \
    npm-check-updates \
    sass-lint \
    vmd \


# ======================
# Create Terminal Themes
# ======================

base16-builder -s atelier-sulphurpool -t iterm2 -b light > sulphurpool-light.itermcolors
base16-builder -s atelier-sulphurpool -t iterm2 -b dark > sulphurpool-dark.itermcolors
base16-builder -s atelier-sulphurpool -b dark > base16-ateliersulphurpool.dark.sh
base16-builder -s atelier-sulphurpool -t -b dark > base16-ateliersulphurpool.dark.sh

# if ! .config; mkdir .config
mkdir $HOME/.config/base16-shell
base16-builder -s atelier-sulphurpool -t shell -b dark > $HOME/.config/base16-shell/base16-ateliersulphurpool.dark.sh
base16-builder -s atelier-sulphurpool -t shell -b light > $HOME/.config/base16-shell/base16-ateliersulphurpool.light.sh

# Make executable
for file in base16-ateliersulphurpool.*; do chmod +x $file; done

