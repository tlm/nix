{
  self,
  inputs,
  ...
}: {
  mkNixosSystem = {
    system,
    modules,
    specialArgs ? {},
  }: let
    mergedSpecialArgs =
      {
        inherit inputs;
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
}
