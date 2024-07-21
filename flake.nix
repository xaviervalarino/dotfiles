{
  description = "MacOS dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    mac-app-util.url = "github:hraban/mac-app-util";
  };
  outputs = inputs@{ nixpkgs, darwin, home-manager, mac-app-util, ... }: {
    darwinConfigurations.Xaviers-MacBook-Pro-2 = 
      darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
        };
        modules = [
          ./modules/darwin
          mac-app-util.darwinModules.default
          home-manager.darwinModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              verbose = true;
              users.xavier.imports = [
                ./modules/home-manager
                mac-app-util.homeManagerModules.default
              ];
            };
          }
        ];
      };
  };
}
