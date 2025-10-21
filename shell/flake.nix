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
      supportedSystems = ["x86_64-linux" "aarch64-linux"];
    in {
      devShells = nixpkgs.lib.genAttrs supportedSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          pkgs-unstable = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          pkgs-juju-mongo = import nixpkgs-juju-mongo {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };
        in {
          esphome = import ./dev/esphome.nix {
            inherit pkgs;
            inherit pkgs-unstable;
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

   # nixpkgs.lib.genAttrs supportedSystems (system:
   #   let
   #     pkgs = import nixpkgs {
   #       inherit system;
   #       config.allowUnfree = true;
   #     };
   #     pkgs-unstable = import nixpkgs {
   #       inherit system;
   #       config.allowUnfree = true;
   #     };
   #     pkgs-golang-ci = nixpkgs-golang-ci.legacyPackages.${system};
   #     pkgs-juju-mongo = import nixpkgs-juju-mongo {
   #       inherit system;
   #       config = {
   #         allowUnfree = true;
   #       };
   #     };
   #   in
   #   {
   #     #devShells = {
   #     #  "test" = {};
   #     #  "x86_64-linux" = {
   #     #    go = import ./go { inherit pkgs; };
   #     #  };
   #     #};
   #     #devShells = {
   #     #    ${system}.esphome = import ./dev/esphome.nix { inherit pkgs; inherit pkgs-unstable; };
   #     #    ${system}.ops = import ./dev/ops.nix { inherit pkgs; };
   #     #    ${system}.go = import ./go { inherit pkgs; };
   #     #    ${system}.rust = import ./rust { inherit pkgs; };
   #     #    ${system}.juju = pkgs.mkShellNoCC {
   #     #      name = "juju-dev";

   #     #      packages = [
   #     #        pkgs.pkgsStatic.sqlite
   #     #        pkgs.pkgsStatic.musl
   #     #        pkgs.pkgsStatic.gcc
   #     #        pkgs.pkgsStatic.binutils
   #     #        #pkgs.sqlite
   #     #        pkgs.azure-cli.out
   #     #        pkgs.awscli2.out
   #     #        #pkgs.autoconf
   #     #        #pkgs.autogen
   #     #        #pkgs.automake
   #     #        pkgs.bash.out
   #     #        pkgs.expect.out
   #     #        #pkgs.gettext
   #     #        pkgs.gh.out
   #     #        pkgs.gnumake.out
   #     #        pkgs.go
   #     #        #pkgs.libtool
   #     #        #pkgs.zig
   #     #        #pkgs.gcc
   #     #        #pkgs.pkgsStatic.go
   #     #        pkgs-unstable.golangci-lint.out
   #     #        pkgs.jq
   #     #        #pkgs.lxc.out

   #     #        #pkgs.lxd.out
   #     #        #pkgs.pkgsMusl.musl
   #     #        #pkgs.pkgsMusl.go
   #     #        #pkgs.pkgsMusl.gcc
   #     #        #pkgs.pkgsMusl.gcc
   #     #        #pkgs.pkgsMusl.sqlite
   #     #        #pkgs.pkgsMusl.pkg-config
   #     #        #pkgs.minikube
   #     #        #pkgs-juju-mongo.mongodb-4_4.out
   #     #        pkgs.kubectl.out
   #     #        pkgs.rootlesskit
   #     #        pkgs.shellcheck.out
   #     #        pkgs.shfmt.out
   #     #        pkgs.yq-go.out
   #     #        pkgs.zsh.out
   #     #      ];

   #     #      shellHook = ''
   #     #        export GOBIN=''$(mktemp -d -p "" juju-go-path.XXXX)
   #     #        echo "Using temporary GOBIN: ''${GOBIN}"
   #     #        export PATH="''${PATH}:''${GOBIN}"
   #     #        export GOFLAGS
   #     #        export GOFLAGS='-ldflags=-linkmode=external -ldflags=-extldflags=-static'

   #     #        if [ -z "$IN_ZSH" ]; then
   #     #        export IN_ZSH=1
   #     #        export SHELL=${pkgs.zsh}/bin/zsh
   #     #        exec ${pkgs.zsh}/bin/zsh -i
   #     #        fi

   #     #        echo "Welcome to the Juju development shell!"
   #     #      '';
   #     #    };
   #     #  };
   #   }
   # );
}
