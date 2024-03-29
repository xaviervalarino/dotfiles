# Homebrew
if [ "$(uname -m)" = "arm64" ]; then
  brew=/opt/homebrew/bin/brew
else
  brew=/usr/local/bin/brew
fi
eval "$($brew shellenv)"
export HOMEBREW_NO_ENV_HINTS=true

# Rust
path+=$HOME/.cargo/bin

# Ruby
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
path+=/usr/local/sbin

# Personal scripts
path+=$HOME/scripts

# Exports
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share

export EDITOR=$(which nvim)
