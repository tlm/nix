{
  pkgs,
  lib,
  isDarwin,
  ...
}: {
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;

    defaultCacheTtl = 1800;
    enableExtraSocket = true;
    enableSshSupport = true;
    #extraConfig = ''
    #  use-keychain yes
    #'';

    pinentry.package = lib.mkIf isDarwin pkgs.pinentry_mac;
  };

  programs.ssh = {
    matchBlocks."tlm-rig" = {
      remoteForwards = [
        {
          bind.address = "/run/user/1000/gnupg/S.gpg-agent";
          host.address = "/Users/tlm/.gnupg/S.gpg-agent.extra";
        }
      ];
    };
  };
}
