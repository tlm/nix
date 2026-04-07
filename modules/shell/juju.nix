{pkgs, ...}: let
  golangciLintGo126 = pkgs.golangci-lint.override {
    buildGo125Module =
      if pkgs ? buildGo126Module
      then pkgs.buildGo126Module
      else throw "buildGo126Module is not available in this nixpkgs revision.";
  };
in {
  devShells.juju = pkgs.mkShellNoCC {
    name = "juju-dev";
    packages = [
      pkgs.pkgsStatic.sqlite
      pkgs.pkgsStatic.musl
      pkgs.pkgsStatic.gcc
      pkgs.pkgsStatic.binutils
      pkgs.azure-cli.out
      pkgs.awscli2.out
      pkgs.bash.out
      pkgs.expect.out
      pkgs.gh.out
      pkgs.gnumake.out
      pkgs.go
      golangciLintGo126
      pkgs.gopatch
      pkgs.jq
      pkgs.kubectl.out
      pkgs.rootlesskit
      pkgs.shellcheck.out
      pkgs.shfmt.out
      pkgs.yq-go.out
      pkgs.zsh.out
      pkgs.zip.out
      pkgs.unzip.out
    ];

    shellHook = ''
      export GOBIN=''$(mktemp -d -p "" juju-go-path.XXXX)
      echo "Using temporary GOBIN: ''${GOBIN}"
      export PATH="''${PATH}:''${GOBIN}"
      export GOFLAGS
      export GOFLAGS='-ldflags=-linkmode=external -ldflags=-extldflags=-static'

      if [ -z "$IN_ZSH" ]; then
        export IN_ZSH=1
        export SHELL=${pkgs.zsh}/bin/zsh
        exec ${pkgs.zsh}/bin/zsh -i
      fi

      echo "Welcome to the Juju development shell!"
    '';
  };
}
