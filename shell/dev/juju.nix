{
  pkgs,
  pkgs-unstable,
  pkgs-juju-mongo,
  ...
}:
pkgs.mkShellNoCC {
  name = "juju-dev";

  packages = [
    pkgs.pkgsStatic.sqlite
    pkgs.pkgsStatic.musl
    pkgs.pkgsStatic.gcc
    pkgs.pkgsStatic.binutils
    #pkgs.sqlite
    pkgs.azure-cli.out
    pkgs.awscli2.out
    #pkgs.autoconf
    #pkgs.autogen
    #pkgs.automake
    pkgs.bash.out
    pkgs.expect.out
    #pkgs.gettext
    pkgs.gh.out
    pkgs.gnumake.out
    pkgs.go
    #pkgs.libtool
    #pkgs.zig
    #pkgs.gcc
    #pkgs.pkgsStatic.go
    pkgs-unstable.golangci-lint.out
    pkgs.jq
    #pkgs.lxc.out

    #pkgs.lxd.out
    #pkgs.pkgsMusl.musl
    #pkgs.pkgsMusl.go
    #pkgs.pkgsMusl.gcc
    #pkgs.pkgsMusl.gcc
    #pkgs.pkgsMusl.sqlite
    #pkgs.pkgsMusl.pkg-config
    #pkgs.minikube
    pkgs-juju-mongo.mongodb-4_4.out
    pkgs.kubectl.out
    pkgs.rootlesskit
    pkgs.shellcheck.out
    pkgs.shfmt.out
    pkgs.yq-go.out
    pkgs.zsh.out
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
}
