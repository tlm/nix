{ pkgs, pkgs-unstable, ... }:
{
  programs.zed-editor = {
    enable = true;
    package = pkgs-unstable.zed-editor;
    installRemoteServer = true;
    extraPackages = with pkgs; [
      gopls
      nixd
      nodejs
    ];
  };

}
