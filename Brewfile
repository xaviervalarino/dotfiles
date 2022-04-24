machine=`uname -n`.chomp.sub(/\..*/,"") 

tap "homebrew/bundle"
tap "homebrew/cask"
tap "homebrew/cask-fonts"
tap "homebrew/cask-versions"
tap "homebrew/core"

brew "bat"
brew "coreutils"
brew "fd"
brew "fzf"
brew "gh"
brew "git"
brew "git-delta"
brew "glow"
brew "imagemagick"
brew "lua-language-server"
brew "m-cli"
brew "mas"
brew "moreutils"
brew "n"
brew "neovim"
brew "pidof"
brew "pstree"
brew "pure"
brew "ripgrep"
brew "rust"
brew "shellcheck"
brew "stow"
brew "tldr"
brew "trash"
brew "tree"
brew "utimer"
brew "zsh-completions"

cask "figma"
cask "firefox-developer-edition"
cask "font-iosevka"
cask "hammerspoon"
cask "iterm2"
cask "karabiner-elements"
cask "bitwarden"

# Work
if machine == "track-xrv"
  brew "mkcert"
  brew "nss"
  cask "slack"
  cask "miro"
  cask "google-chrome"
end

# Personal
if machine == "TimeBandit"
  mas "Affinity Designer", id: 824171161
  cask "Affinity Publisher"
  cask "Affinity Photo"
end

# vim:ft=ruby
