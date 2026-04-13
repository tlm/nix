{
  config,
  pkgs,
  ...
}: {
  containers.coredns = {
    autoStart = true;
    hostBridge = "container-br";
    localAddress = null;
    localAddress6 = "fc00::2";
    privateNetwork = true;
    privateUsers = "pick";
    config = {
      config,
      pkgs,
      ...
    }: {
      environment.systemPackages = with pkgs; [
        unixtools.ping
      ];
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  systemd = {
    network = {
      enable = true;

      networks."10-wireless" = {
        matchConfig.Name = "wlp11s0f3u3";
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = "yes";
          IPv6PrivacyExtensions = "yes";
        };
        linkConfig.RequiredForOnline = "yes";
      };
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    openssh
    usbutils
    tailscale
    wireguard-tools
    nixd
    nixfmt-rfc-style
    podman
  ];

  services.prometheus = {
    enable = true;
    pushgateway = {
      enable = true;
      web = {
        listen-address = ":9091";
      };
    };

    scrapeConfigs = [
      {
        job_name = "pushgateway";
        honor_labels = true;
        static_configs = [
          {
            targets = ["localhost:9091"];
          }
        ];
      }
    ];
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "both";
    extraSetFlags = [
      "--accept-routes=true"
    ];
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      log-driver = "journald";
    };
  };

  #virtualisation.lxd = {
  #  enable = true;

  #  # This turns on a few sysctl settings that the LXD documentation recommends
  #  # for running in production.
  #  recommendedSysctlSettings = true;
  #};

  # This enables lxcfs, which is a FUSE fs that sets up some things so that
  # things like /proc and cgroups work better in lxd containers.
  # See https://linuxcontainers.org/lxcfs/introduction/ for more info.
  #
  # Also note that the lxcfs NixOS option says that in order to make use of
  # lxcfs in the container, you need to include the following NixOS setting
  # in the NixOS container guest configuration:
  #
  # virtualisation.lxc.defaultConfig = "lxc.include = ''${pkgs.lxcfs}/share/lxc/config/common.conf.d/00-lxcfs.conf";
  virtualisation.lxc.lxcfs.enable = true;

  # ip forwarding is needed for NAT'ing to work.
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv4.conf.default.forwarding" = true;
  };

  # kernel module for forwarding to work
  boot.kernelModules = ["nf_nat_ftp"];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
