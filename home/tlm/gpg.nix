{ config, pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    settings = {
    };
  };

  programs.gpg-agent = {
    enable = false;
  };
}
