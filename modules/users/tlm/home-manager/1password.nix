{pkgs, ...}: let
  inherit (pkgs) stdenv;
  agentSocketPath =
    if stdenv.hostPlatform.isDarwin
    then "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else "~/.1password/agent.sock";
in {
  home.packages = with pkgs; [
    _1password-cli
    _1password-gui
  ];

  programs.ssh = {
    matchBlocks."*" = {
      identityAgent = "\"${agentSocketPath}\"";
    };
  };
}
