{pkgs, ...}: {
  devshells.go = {
    name = "go";
    packages = [
      pkgs.go
      pkgs.golangci-lint.out
      pkgs.zsh.out
    ];

    bash.interactive = ''
      if [ -z "$IN_ZSH" ]; then
        export IN_ZSH=1
        export SHELL=${pkgs.zsh}/bin/zsh
        exec ${pkgs.zsh}/bin/zsh -i
      fi

      echo "Welcome to the Go development shell!"
    '';
  };
}
