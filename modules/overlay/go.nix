{inputs, ...}: {
  perSystem = {system, ...}: {
    overlayAttrs = {
      go =
        (import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        }).go;
    };
  };
}
