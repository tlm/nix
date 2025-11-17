{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  containers.coredns = {
    autoStart = true;
    hostBridge = "container-br";
    localAddress = null;
    localAddress6 = "fc00::2";
    privateNetwork = true;
    privateUsers = "pick";
    config =
      { config, pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          unixtools.ping
        ];
      };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking = {
    hostName = "tlm-rig";
    nftables.enable = true;
    useDHCP = false; # disable this option to let networkd take control.
    useNetworkd = true; # let systemd-networkd take control.

    bridges = {
      container-br = {
        interfaces = [
          "wlp11s0f3u3"
        ];
      };
    };

    nftables.tables.nat6 = {
      enable = true;
      family = "ip6";
      content = ''
        chain prerouting {
          type nat hook prerouting priority 100;
        }

        chain postrouting {
          type nat hook postrouting priority 100;
          oifname "wlp11s0f3u3" masquerade
        }
      '';
    };

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ ];
      trustedInterfaces = [ "lxdbr0" ];

      interfaces = {
        "${config.services.tailscale.interfaceName}" = {
          allowedTCPPorts = [
            9090
            9091
          ];
        };
      };
    };

    wireless = {
      enable = true;
      networks.tlm = {
        psk = "qd7FgX4Hnr@NU*2csKB";
      };
    };
  };

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

  users.users.tlm = {
    isNormalUser = true;
    description = "Thomas Miller";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "lxd"
    ];
    packages = with pkgs; [ home-manager ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHxsBSstfw6+55P/YPS8PyH6m58hxt3q2RK2OP1P6J/2"
    ];
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
            targets = [ "localhost:9091" ];
          }
        ];
      }
    ];
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "none";
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      log-driver = "journald";
    };
  };

  virtualisation.lxd = {
    enable = true;

    # This turns on a few sysctl settings that the LXD documentation recommends
    # for running in production.
    recommendedSysctlSettings = true;
  };

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
  boot.kernelModules = [ "nf_nat_ftp" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
