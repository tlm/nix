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
    propogatedBuildInputs = with pkgs.pkgsStatic; [
      sqlite
      gcc
    ];

    packages =
      (with pkgs.pkgsStatic; [
        musl
        binutils
        go
      ])
      ++ (with pkgs; [
        azure-cli
        awscli2
        bash
        expect
        gcc
        gopatch
        golangciLintGo126
        gh
        gnumake
        jq
        kubectl
        shellcheck
        shfmt
        yq-go
        zsh
        zip
        unzip
      ]);

    shellHook = ''
      export GOBIN=''$(mktemp -d -p "" juju-go-path.XXXX)
      echo "Using temporary GOBIN: ''${GOBIN}"
      export PATH="''${PATH}:''${GOBIN}"
      export GOFLAGS
      export CGO_LDFLAGS
      export GOFLAGS='"-ldflags=-extldflags=-static -linkmode=external"'
      export CGO_CFLAGS="-I${pkgs.pkgsStatic.sqlite.dev}/include"
      export CGO_LDFLAGS="-L${pkgs.pkgsStatic.sqlite.out}/lib -L${pkgs.pkgsStatic.musl}/lib"

      if [ -z "$IN_ZSH" ]; then
        export IN_ZSH=1
        export SHELL=${pkgs.zsh}/bin/zsh
        exec ${pkgs.zsh}/bin/zsh -i
      fi

      echo "Welcome to the Juju development shell!"
    '';
  };
}
