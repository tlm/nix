{...}: {
  perSystem = {pkgs, ...}: {
    imports = [
      ./go.nix
      ./juju.nix
      ./ops.nix
    ];
  };
}
