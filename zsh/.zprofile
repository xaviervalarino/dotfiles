# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Rust
path+=$HOME/.cargo/bin

# Ruby
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
path+=$PATH:/usr/local/sbin

# Personal scripts
path+=$HOME/scripts

# Exports
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share

export EDITOR=/usr/local/bin/nvim


case $ITERM_PROFILE in
  'Github light') BAT_THEME=GitHub     ;;
  *)              BAT_THEME=catppuccin ;;
esac
export BAT_THEME
