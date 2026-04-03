{
  description = "tlm nix flake";

  inputs = {
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    devshells.url = "github:numtide/devshell";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.url = "home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-bwrapper.url = "github:Naxdy/nix-bwrapper";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nixpkgs-fixrust.url = "github:Mic92/nixpkgs/03fbdb6e0b6f67f41436b3a892ec7b4331eda0d4";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zed.url = "github:zed-industries/zed/v0.223.4";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      debug = true;

      systems = [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-linux"
      ];

      imports = [
        inputs.devshells.flakeModule
        inputs.flake-parts.flakeModules.easyOverlay
        ./modules/hosts/hosts.nix
        ./modules/overlay
        ./modules/shell
        ./modules/system/default.nix
      ];
    };
}
