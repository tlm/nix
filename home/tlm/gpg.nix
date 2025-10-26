{ config, pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    settings = {
      no-autostart = true;
    };
  };

  services.gpg-agent = {
    enable = false;
  };
}
