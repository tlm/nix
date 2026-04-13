{config, ...}: {
  networking = {
    hostName = "rustler";
    nftables.enable = true;
    useDHCP = false;
    useNetworkd = true;

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [22];
      #checkReversePath = "yes";

      interfaces = {
        "${config.services.tailscale.interfaceName}" = {
          allowedTCPPorts = [];
        };
      };
    };
  };
}
