{lib, ...}: {
  imports = [
    ../users/tlm
  ];

  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "tlm-mbp";
    localHostName = "tlm-mbp";
  };

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = ["tlm"];
    #builders = lib.mkForce "ssh-ng://tlm@tlm-rig x86_64-linux  - 8 - - -";
    builders-use-substitutes = true;
  };

  nix.linux-builder.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
  };

  users.users.tlm = {
    home = "/Users/tlm";
    isHidden = false;
  };

  system.stateVersion = 6;
  system.primaryUser = "tlm";
}
