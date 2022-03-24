source $HOME/.aliases

eval "$(/opt/homebrew/bin/brew shellenv)"

# PATH
XDG_CONFIG_HOME="$HOME/.config"
XDG_DATA_HOME="$HOME/.local/share"

# Set up Rust
PATH="$PATH:$HOME/.cargo/bin"

# Ruby
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
PATH="$PATH:/usr/local/sbin"

# Add Lua language server for nvim lsp
PATH="$PATH:$HOME/.local/tools/lua-language-server/bin/macOS"

# Personal scripts
PATH="$PATH:$HOME/scripts"

EDITOR=/usr/local/bin/nvim
export BAT_THEME="catppuccin"
