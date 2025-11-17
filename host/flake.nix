{
  description = "nix flake file for managing hosts";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-23-11.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    #home-manager.url = "path:/home/tlm/projects/nix-community/home-manager";
    home-manager.url = "home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-flake.url = "path:../home";
    home-flake.inputs.nixpkgs.follows = "nixpkgs";
    home-flake.inputs.home-manager.follows = "home-manager";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-23-11,
      nixpkgs-unstable,
      home-manager,
      home-flake,
      ...
    }:
    {
      nixosConfigurations.tlm-rig =
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;

          };
          pkgs-23-11 = import nixpkgs-23-11 {
            inherit system;
            config.allowUnfree = true;
          };
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit pkgs;
            inherit pkgs-unstable;
          };
          modules = [
            ./tlm-rig/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit pkgs-unstable;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.tlm = {
                imports = home-flake.homeConfigs.tlm;
              };
            }
          ];
        };
    };
}
