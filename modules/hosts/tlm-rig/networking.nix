{config, ...}: {
  networking = {
    hostName = "tlm-rig";
    nftables.enable = true;
    useDHCP = false; # disable this option to let networkd take control.
    useNetworkd = true; # let systemd-networkd take control.

    wg-quick.interfaces = {
      wg1 = {
        address = ["192.168.3.2/32"];
        privateKeyFile = "/etc/wireguard/private.key";
        peers = [
          {
            publicKey = "xE0LnvuhTAKILZNUFKmA8YRPGGOo5GDT3aNJMs70834=";
            endpoint = "167.179.164.182:51820";
            allowedIPs = ["192.168.3.0/24" "192.168.1.0/24"];
            persistentKeepalive = 25;
          }
        ];
      };
    };

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
      enable = false;
      allowPing = true;
      allowedTCPPorts = [22];
      allowedUDPPorts = [];
      trustedInterfaces = ["lxdbr0" "wg1"];

      checkReversePath = false;

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
}
