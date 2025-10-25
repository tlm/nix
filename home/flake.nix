{
  description = "tlm home-manager flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    let
      pkgs = import nixpkgs {
        config.allowUnfree = true;
        system = "x86_64-linux";
      };
      pkgs-unstable = import nixpkgs-unstable { system = "x86_64-linux"; };
    in
    {
      homeConfigs = {
        tlm = [
          ./tlm/tlm.nix
        ];
      };

      homeConfigurations = {
        "tlm@tlm-rig" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit pkgs-unstable; };
          inherit pkgs;
          modules = self.homeConfigs.tlm;
        };
        "tlm@devel01" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit pkgs-unstable; };
          inherit pkgs;
          modules = self.homeConfigs.tlm;
        };
      };
    };
}
