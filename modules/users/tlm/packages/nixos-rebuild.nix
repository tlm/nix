{pkgs, ...}: {
  home-manager.users.tlm.home = {
    packages = [
      pkgs.nixos-rebuild-ng
    ];
  };
}
