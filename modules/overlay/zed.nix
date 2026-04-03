{inputs, ...}: {
  perSystem = {system, ...}: {
    overlayAttrs = {
      zed-editor =
        (import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        }).zed-editor;
    };
  };
}
