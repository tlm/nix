{
  pkgs,
  ...
}:
pkgs.mkShell {
  name = "go-dev";

  packages = with pkgs; [
    go.out
    golangci-lint.out
    zsh.out
  ];

  shellHook = ''
    if [ -z "$IN_ZSH" ]; then
      export IN_ZSH=1
      export SHELL=${pkgs.zsh}/bin/zsh
      exec ${pkgs.zsh}/bin/zsh -i
    fi
  '';
}
