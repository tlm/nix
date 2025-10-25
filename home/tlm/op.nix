{ pkgs, ... }:
{
  home.packages = with pkgs; [
    _1password-cli
  ];

  home.file.".config/1Password/ssh-agent.conf".text = ''
    [ssh-agent]
    enabled = true
  '';
}
