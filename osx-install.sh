#!/usr/bin/env bash

# TODO:
# - add IF macOS or OSX?
# - add IF brew already installed
# - Set up RSA key, add public key to clipboard and open github?

# Setup OSX after a fresh install
# Tweaks for a small boot SSD
# Installs various Homebrew and NPM packages
# Sets up Terminal Theme

# =======================
# Tweak OSX for small SSD
# =======================

# Disable local Time Machine image
# sudo tmutil disablelocal

# Turn off hibernation and sleep
# sudo pmset -a hibernatemode 0
# sudo pmset -a disksleep 0

# Delete, sleep image, create zero space file and lock it
# sudo rm /var/vm/sleepimage
# sudo touch /Private/var/vm/sleepimage
# sudo chflags uchg /Private/var/vm/sleepimage

# Set noatime
# TODO: cat XML >  com.noatime.root.plist
# sudo chown root:wheel /Library/LaunchDaemons/com.noatime.root.plist
# mount | grep " /"
# Should come up noatime after restart

# Write screenshot to another location
# if [ ! -d /Volumes/Xavier_HD/screenshots ]; then
#     mkdir /Volumes/Xavier_HD/screenshots
# fi
# defaults write com.apple.screencapture location /Volumes/Xavier_HD/screenshots/


# Link home folder items
# sudo rm -v \
#    $HOME/Documents \
#    $HOME/Downloads \
#    $HOME/Pictures \
#    $HOME/Music \
#    $HOME/Movies \
#    $HOME/Public

# ln -s /Volumes/Xavier_HD/home/* $HOME

# =======================================
# Homebrew packages and Cask applications
# =======================================

if ! type $"brew" &> /dev/null; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

taps=(
    caskroom/cask \
    caskroom/versions \
    crisidev/hombrew-chunkwm \
)
for tap in ${taps[@]}
do
    brew tap $tap
done

# TODO: is cask actually useful for installing fonts?
# brew tap caskroom/fonts


brew install \
    bash \
    bash-completion \
    brew-cask-completion \
    calc \
    chunkwm \
    colordiff \
    coreutils \
    docker \
    ffmpeg \
    fontconfig \
    git \
    html2text \
    htop \
    imagemagick \
    koekeishiya/formulae/skhd --with-purify \
    m-cli \
    macvim \
    mps-youtube \
    mpv \
    neovim \
    node \
    pandoc \
    pidof \
    ranger \
    redshift \
    stow \
    terminal-notifier \
    the_silver_searcher \
    trash \
    tree \
    utimer \
    vim \
    watch \
    wget \
    youtube-dl \

# Casks

brew cask install \
    balsamiq-mockups \
    cheatsheet \
    docker \
    eloston-chromium \
    firefox-developer-edition \
    grandperspective \
    handbrake \
    iterm2 \
    itsycal \
    karabiner-elements \
    kitty \
    libreoffice \
    omnigraffle \
    onyx \
    sketch \
    sublime-text \
    the-unarchiver \
    transmission \
    vlc \

brew cleanup

# TODO: need OAuth API token if searching casks frequently?


# ================
# TODO: set up vim
# ================

# Install VimPlug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Create undo directory
mkdir -p $HOME/.vim/undo


# ======================
# Set up Perl & Perlbrew
# ======================

# curl -L https://install.perlbrew.pl | bash


# ================
# Symlink dotfiles
# ================

#TODO: need to gen RSA key?
# ssh-keygen -t rsa -b 4096 -C "xvalarino@gmail.com"
# eval "$(ssh-agent -s)"
# ssh-add ~/.ssh/id_rsa
# pbcopy < ~/.ssh/id_rsa.pub
# echo "Public RSA key copied to clipboard"

dotDir=$HOME/dotfiles
if [ -d $dotDir ];then
    (cd $dotDir; git pull)
else
    git clone git@github.com:xaviervalarino/dotfiles.git
fi

dotfiles=(\
    ag \
    bash \
    chunkwm \
    git \
    nano \
    npm \
    skhd \
    sublime_text \
    tern \
    vim \
)

for config in "${dotfiles[@]}"
do
    stow -v -d $dotDir $config
done


# ======================
# Set up Node JS and NPM
# ======================

npm_dir=$HOME/.npm-global

if [ ! -d $npm_dir ] && mkdir $npm_dir

npm config set prefix $npm_dir

npm i -g \
    browser-sync \
    browserify \
    diff-so-fancy \
    gulp-cli \
    imagemin-cli \
    jshint \
    npm \
    npm-check-updates \
    sass-lint \
    tern \
    vmd \


# =================
# Install Ruby Gems
# =================

gem install iStats


# =======================
# Install Python packages
# =======================

pip3 install pygments
