{inputs, ...}: {
  perSystem = {...}: {
    overlays = [inputs.nix-bwrapper.overlays.default];
  };
}
