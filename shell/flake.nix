{
  description = "tlm dev shells";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-juju-mongo.url = "github:nixos/nixpkgs?ref=nixos-23.11";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-juju-mongo,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    in
    {
      devShells = nixpkgs.lib.genAttrs supportedSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          pkgs-juju-mongo = import nixpkgs-juju-mongo {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };
        in
        {
          esphome = import ./dev/esphome.nix {
            pkgs = nixpkgs.lib.makeExtensible pkgs;
            inherit pkgs-unstable;
            #pkgs-unstable = nixpkgs-unstable.lib.makeExtensible pkgs-unstable;
          };
          go = import ./dev/go.nix { inherit pkgs; };
          hugo = import ./dev/hugo.nix { inherit pkgs; };
          juju = import ./dev/juju.nix {
            inherit pkgs;
            inherit pkgs-unstable;
            inherit pkgs-juju-mongo;
          };
          ops = import ./dev/ops.nix { inherit pkgs; };
          rust = import ./dev/rust.nix { inherit pkgs; };
        }
      );
    };
}
