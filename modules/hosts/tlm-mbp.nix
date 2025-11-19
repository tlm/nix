{ ... }:
{
  imports = [
    ../users/users.nix
  ];

  networking = {
    hostName = "tlm-mbp";
    localHostName = "tlm-mbp";
  };

  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 6;
}
