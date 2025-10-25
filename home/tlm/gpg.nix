{ config, pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    settings = {
    };
  };

  services.gpg-agent = {
    enable = false;
  };
}
