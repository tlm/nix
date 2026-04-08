{
  self,
  inputs,
  ...
}: let
  mkNixosSystem = {
    system,
    modules,
    specialArgs ? {},
  }: let
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    mergedSpecialArgs =
      {
        inherit inputs pkgs-unstable;
        isDarwin = false;
        withGui = false;
      }
      // specialArgs;
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = mergedSpecialArgs;
      modules =
        [
          {nixpkgs.overlays = [self.overlays.default];}
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = mergedSpecialArgs;
          }
        ]
        ++ modules;
    };
in {
  flake.nixosConfigurations.tlm-rig = mkNixosSystem {
    system = "x86_64-linux";
    modules = [
      ./config.nix
      ./hardware.nix
      ./networking.nix
      ./users.nix
    ];
  };
}
