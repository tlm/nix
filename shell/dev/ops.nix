{
  pkgs,
  ...
}:
pkgs.mkShell {
  name = "ops";

  packages = with pkgs; [
    _1password-cli
    terraform.out
  ];

  shellHook = ''
    if [ -z "$IN_ZSH" ]; then
      export IN_ZSH=1
      export SHELL=${pkgs.zsh}/bin/zsh
      exec ${pkgs.zsh}/bin/zsh -i
    fi
  '';
}
