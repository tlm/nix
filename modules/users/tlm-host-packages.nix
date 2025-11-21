{ pkgs, ... }:
{
  users.users.tlm.packages = with pkgs; [
    _1password-gui
    git
  ];

  programs._1password-gui.enable = true;
}
