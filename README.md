# Personal Dotfiles

Dotfiles for MacOS.

I use [`stow`](https://www.gnu.org/software/stow/) to manage my dotfiles. If you're not familiar with it, it simplifies the process of symlinking the dotfiles in this repo to their intended config location.

## Bootstrap

```sh
source <(curl -s https://raw.githubusercontent.com/xaviervalarino/dotfiles/main/setup/bootstrap.mac.sh)
```

## Post Install

### Symbol font

Secondary symbol font used in WezTerm / Neovim is installed via Homebrew (`font-symbols-only-nerd-font`). Can also be downloaded manually:

[Download - Symbols Nerd Font](https://github.com/ryanoasis/nerd-fonts/raw/master/src/glyphs/Symbols-2048-em%20Nerd%20Font%20Complete.ttf)
### Zen Browser

To symlink `user.js` and `chrome/userChrome.css` into your active Zen profile:

```sh
./zen/link.sh
```

### Browser Extensions

Extensions for Firefox and Chrome

Install extensions:

- [Privacy Badger](https://privacybadger.org/)
- [uBlock Origin](https://ublockorigin.com/)
  - TODO: Add Google search blacklist
- [Vimium C](https://github.com/gdh1995/vimium-c)
  - **Custom Theme:** [`zen/extensions/vimium-c.css`](./zen/extensions/vimium-c.css) (GitHub Light/Dark theme with Apple SF Pro typography)
  - **Backup / Settings:** [`zen/extensions/vimium-c.json`](./zen/extensions/vimium-c.json) (purged Chinese engines, added developer shortcuts & React docs)
  - **Quick Apply CSS:** `pbcopy < zen/extensions/vimium-c.css` -> paste into **Custom CSS styles for Vimium C UI**

- [ClearURLs](https://clearurls.gitlab.io/)
- Add [Bypass Paywall](https://github.com/iamadamdev/bypass-paywalls-chrome)

  - [Firefox link](https://github.com/iamadamdev/bypass-paywalls-chrome/releases/latest/download/bypass-paywalls-firefox.xpi)
  - Chrome requires putting extensions into "Developer Mode", use the code snippet below to download and install

  ```
  git clone --depth 1 https://github.com/iamadamdev/bypass-paywalls-chrome ~/Downloads/bypass-paywalls-chrome;\
  open -a /Applications/Google\ Chrome.app chrome://extensions/;\
  open ~/Downloads
  ```

Settings:
- Turn off Saved passwords:
  - Firefox://about:preferences#privacy --- turn off **about:preferences#privacy** > "Ask to save logins and passwords for websites
  - Chrome://settings/passwords --- turn off "Offer to save passwords"
