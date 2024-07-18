{ pkgs, ... }: {
  home = {
    stateVersion = "24.05";
    packages = [
      pkgs.ripgrep
      pkgs.fd
      pkgs.du-dust
    ];
    sessionVariables = {
      EDITOR = "nvim";
    };
    file.".zprofile".source = ../../zsh/zprofile;
    file.".zshenv".source = ../../zsh/zshenv;
    file.".zshrc".source = ../../zsh/zshrc;
  };
  programs = {
    home-manager.enable = true;
    bat.enable = true;
    bat.config.theme = "base16";
    fzf.enable = true;
    fzf.enableZshIntegration = true;
    git.enable = true;
    git.includes = [
      { path  = "~/dotfiles/git/config"; }
      { path  = "~/dotfiles/git/exclude"; }
    ];
    # zsh.enable = true;
    # zsh.enableCompletion = true;
    # zsh.initExtra = /Users/xavier/dotfiles/zsh/zshrc;
    # zsh.autosuggestion.enable = true;
    # zsh.syntaxHighlighting.enable = true;
    # zsh.shellAliases = true;
    wezterm.enable = true;
    wezterm.enableZshIntegration = true;
  };
}
