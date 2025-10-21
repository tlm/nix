{
  pkgs,
  pkgs-unstable,
  ...
}:
let
  inherit pkgs;
  inherit pkgs-unstable;
  overlay = final: prev {
  };
in
(pkgs.extend overlay).mkShell {
  name = "esphome";

  packages = [
    pkgs.git
    #pkgs."python3.13-kconfiglib"
    (pkgs-unstable.python3.withPackages (
      ps: with ps; [
        kconfiglib
      ]
    ))
    pkgs-unstable.esphome
  ];

  shellHook = ''
    if [ -z "$IN_ZSH" ]; then
      export IN_ZSH=1
      export SHELL=${pkgs.zsh}/bin/zsh
      exec ${pkgs.zsh}/bin/zsh -i
    fi
  '';
}
