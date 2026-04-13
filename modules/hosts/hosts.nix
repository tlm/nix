{
  self,
  inputs,
  ...
}: let
  inherit ((import ./lib.nix {inherit self inputs;})) mkNixosSystem;
in {
  flake.nixosConfigurations = {
    rustler = mkNixosSystem {
      system = "x86_64-linux";
      modules = [./rustler];
    };

    tlm-rig = mkNixosSystem {
      system = "x86_64-linux";
      modules = [./tlm-rig];
    };
  };

  flake.darwinConfigurations = {
    "tlm-mbp" = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        isDarwin = true;
        withGui = true;
      };
      modules = [
        {
          nixpkgs.overlays = [
            self.overlays.default
          ];
        }
        inputs.nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            user = "tlm";
            taps = {
              "homebrew/homebrew-core" = inputs.homebrew-core;
              "homebrew/homebrew-cask" = inputs.homebrew-cask;
            };
            mutableTaps = false;
          };
        }
        inputs.home-manager.darwinModules.home-manager
        ./tlm-mbp.nix
      ];
    };
  };
}
