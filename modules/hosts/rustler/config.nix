{pkgs, ...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  systemd.network = {
    enable = true;

    networks."10-ethernet" = {
      matchConfig.Name = "en*";
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = "yes";
        IPv6PrivacyExtensions = "no";
      };
      linkConfig.RequiredForOnline = "yes";
    };
  };

  programs.zsh.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      AllowAgentForwarding = true;
      StreamLocalBindUnlink = true;
      PasswordAuthentication = false;
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    openssh
    tailscale
    nixd
    nixfmt-rfc-style
  ];

  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "client";
  };

  system.stateVersion = "25.11";
}
