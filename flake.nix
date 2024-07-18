{
  description = "MacOS dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs: {
    darwinConfigurations.Xaviers-MacBook-Pro-2 = 
      inputs.darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = import inputs.nixpkgs {
          system = "aarch64-darwin";
        };
        modules = [
          ({ pkgs, ...}: {
            nix.extraOptions = ''
              experimental-features = nix-command flakes
            '';
            services.nix-daemon.enable = true;
            users.users.xavier.home = "/Users/xavier";
            programs.zsh.enable = true;
            environment.shells = [ pkgs.bash pkgs.zsh ];
            environment.loginShell = pkgs.zsh;
            environment.systemPackages = [ pkgs.coreutils ];
            # system.stateVersion
            system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
            # system.defaults.finder.AppleShowAllExtensions = true;
            system.defaults.finder._FXShowPosixPathInTitle = true;
            system.defaults.dock.autohide = true;
          })
          inputs.home-manager.darwinModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.xavier.imports = [
                ({ pkgs, ... }: {
                  # home.username = "xavier";
                  # home.homeDirectory = "/Users/xavier";
                  home.stateVersion = "24.05";
                  home.packages = [
                    pkgs.ripgrep
                    pkgs.fd
                    pkgs.du-dust
                  ];
                  home.sessionVariables = {
                    EDITOR = "nvim";
                  };
                  programs.home-manager.enable = true;
                  programs.bat.enable = true;
                  programs.bat.config.theme = "base16";
                  programs.fzf.enable = true;
                  programs.fzf.enableZshIntegration = true;
                  programs.git.enable = true;
                  programs.zsh.enable = true;
                  programs.zsh.enableCompletion = true;
                  programs.zsh.autosuggestion.enable = true;
                  programs.zsh.syntaxHighlighting.enable = true;
                  # programs.zsh.shellAliases = true;
                  programs.wezterm.enable = true;
                  programs.wezterm.enableZshIntegration = true;
                })
              ];
            };
          }
        ];
      };
  };
}
