# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Rust
path+=$HOME/.cargo/bin

# Ruby
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
path+=$PATH:/usr/local/sbin

# Exports
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share

export EDITOR=/usr/local/bin/nvim

export BAT_THEME="catppuccin"
