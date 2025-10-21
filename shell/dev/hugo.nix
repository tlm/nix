{
  pkgs,
  ...
}:
pkgs.mkShell {
  name = "hugo";

  packages = with pkgs; [
    hugo.out
  ];

  shellHook = ''
    if [ -z "$IN_ZSH" ]; then
      export IN_ZSH=1
      export SHELL=${pkgs.zsh}/bin/zsh
      exec ${pkgs.zsh}/bin/zsh -i
    fi
  '';
}
