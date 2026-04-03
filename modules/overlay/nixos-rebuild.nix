{inputs, ...}: {
  perSystem = {system, ...}: let
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs = import inputs.nixpkgs {inherit system;};
  in {
    overlayAttrs = {
      nixos-rebuild = pkgs.lib.hiPrio (pkgs-unstable.nixos-rebuild-ng.overrideAttrs (old: {
        postInstall =
          (old.postInstall or "")
          + ''
            rm -rf $out/share/zsh
          '';
      }));
    };
  };
}
