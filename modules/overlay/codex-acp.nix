{inputs, ...}: {
  perSystem = {system, ...}: {
    overlayAttrs = {
      codex-acp =
        (import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        }).codex-acp;
    };
  };
}
