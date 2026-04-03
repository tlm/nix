{inputs, ...}: {
  perSystem = {system, ...}: {
    overlayAttrs = {
      claude-code =
        (import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        }).claude-code;
    };
  };
}
