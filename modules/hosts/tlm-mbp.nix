{ intputs, ... }:
{
  imports = [
    ../users/tlm.nix
    ../users/tlm-host-packages.nix
  ];

  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "tlm-mbp";
    localHostName = "tlm-mbp";
  };

  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 6;
}
