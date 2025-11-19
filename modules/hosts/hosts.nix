{ inputs, ... }:
{
  flake.darwinConfigurations = {
    "tlm-mbp" = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./tlm-mbp.nix
      ];
    };
  };

  perSystem = { system, lib, inputs, pkgs, ... }: {
  };
}
