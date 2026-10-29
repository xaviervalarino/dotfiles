# Terminals

WezTerm and Ghostty are both configured. This lists every place each one is wired in, so either can be removed cleanly.

## How the theme reaches each terminal

The zsh `theme` function and Neovim's `:Theme` command set `COLOR_MODE` (dark or light) and `COLOR_PALETTE` (github, rose-pine or tokyonight), and store them under `~/.local/state/theme/`. delta, bat and the prompt read those variables, so they work the same in any terminal. Only the step that recolors the terminal differs:

- **WezTerm:** the shell and Neovim send OSC 1337 `SetUserVar` sequences, and a `user-var-changed` handler in the WezTerm config switches the color scheme.
- **Ghostty:** it has no user vars, so the shell and Neovim run `term-colors`, which prints OSC 4/10/11 color sequences from a Ghostty theme file. With no mode override, the colors reset to the config theme, which follows the macOS appearance.

Per-pane overrides are stored in files keyed on `THEME_PANE_ID`. zshrc sets it to the WezTerm pane ID, or in Ghostty to the tty name.

## Removing WezTerm

- `wezterm/`: delete the folder.
- `Brewfile`: delete `cask "wezterm"`.
- `setup/configs.sh`: delete `stow -Rv --dotfiles wezterm`.
- `zsh/dot-config/zsh/functions/theme`:
  - Delete the block under "Emit OSC 1337 only in local WezTerm sessions".
  - Change `pane_id` to plain `$THEME_PANE_ID`.
  - Drop "WezTerm" from the header comment and from the "Tier 2" comment.
- `zsh/dot-zshrc`: delete the `WEZTERM_PANE` branch of the `THEME_PANE_ID` block.
- `nvim/dot-config/nvim/lua/rc/theme.lua`:
  - Delete `is_wezterm` and the three `if is_wezterm then` blocks.
  - Drop the `WEZTERM_PANE` fallback in `get_pane_id`.
- `karabiner/dot-config/karabiner/karabiner.edn`: replace the `com.github.wez.wezterm` app match and the `:t` launch key (`:open "WezTerm"`) with the new terminal.
- `zsh/dot-zshenv`: update the "inherits from WezTerm theme" comment.
- `README.md`: update the symbol font note.

## Removing Ghostty

- `ghostty/`: delete the folder.
- `Brewfile`: delete `cask "ghostty"`.
- `setup/configs.sh`: delete `stow -Rv --dotfiles ghostty`.
- `scripts/scripts/term-colors`: delete it.
- `zsh/dot-config/zsh/functions/theme`:
  - Delete the block under "Ghostty has no user vars".
  - Drop "Ghostty" from the header comment.
- `zsh/dot-zshrc`: delete the `ghostty` branch of the `THEME_PANE_ID` block, and drop the Ghostty sentence from its comment.
- `nvim/dot-config/nvim/lua/rc/theme.lua`: delete `sync_ghostty` and its three calls.
- Unstow the config with `stow -D --dotfiles ghostty`, run from `~/dotfiles`.

Find anything this list misses with `git grep -n -i -E "wezterm|ghostty|term-colors|1337|THEME_PANE_ID"`.
